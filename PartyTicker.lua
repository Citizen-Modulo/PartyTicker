-- PartyTicker - compatible with the WoW 3.3.5 UI API (Interface 30300)
local ADDON_NAME = ...
local DEFAULT_SPEED = 120
local MIN_SPEED, MAX_SPEED = 20, 600
local DEFAULT_SIZE, MIN_SIZE, MAX_SIZE = 22, 10, 48
local FRAME_WIDTH, FRAME_HEIGHT = 900, 30

local defaults = {
    speed = DEFAULT_SPEED,
    size = DEFAULT_SIZE,
    raid = false,
    guild = true,
    officer = false,
    locked = true,
    point = "TOP",
    relativePoint = "TOP",
    x = 0,
    y = -40,
}

local queue = {}
local active = false
local db
local fallbackGlyphs = {}
local fallbackWidth = 0
local textX = FRAME_WIDTH + 1
local ticker = CreateFrame("Frame", "PartyTickerFrame", UIParent)
ticker:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
ticker:SetFrameStrata("HIGH")
ticker:Hide()

local background = ticker:CreateTexture(nil, "BACKGROUND")
background:SetAllPoints(ticker)
background:SetTexture(0, 0, 0, 0.58)

-- Use native clipping when the client provides it.
local hasNativeClipping = type(ticker.SetClipsChildren) == "function"
if hasNativeClipping then
    ticker:SetClipsChildren(true)
end

local text = ticker:CreateFontString(nil, "ARTWORK", "GameFontNormal")
text:SetPoint("LEFT", ticker, "LEFT", 0, 0)
text:SetJustifyH("LEFT")
text:SetJustifyV("MIDDLE")
text:SetWordWrap(false)
text:SetText("")

-- Older clients without SetClipsChildren use edge masks as a fallback.
-- The FontString is also constrained to the available width.
local edgeMasks = {}
if not hasNativeClipping then
    for i = 1, 2 do
        local mask = ticker:CreateTexture(nil, "OVERLAY")
        mask:SetTexture(0, 0, 0, 0.58)
        mask:SetWidth(3)
        mask:SetPoint("TOP", ticker, "TOP", (i == 1 and -1 or 1) * (FRAME_WIDTH / 2 - 1), 0)
        mask:SetPoint("BOTTOM", ticker, "BOTTOM", (i == 1 and -1 or 1) * (FRAME_WIDTH / 2 - 1), 0)
        edgeMasks[i] = mask
    end
end

local function getChatColor(chatType)
    local info = ChatTypeInfo and (ChatTypeInfo[chatType] or ChatTypeInfo.PARTY or ChatTypeInfo.PARTY_LEADER)
    if info then
        return info.r or 0.67, info.g or 0.67, info.b or 1
    end
    return 0.67, 0.67, 1
end

local function savePosition()
    if not db then return end
    local point, relativeTo, relativePoint, x, y = ticker:GetPoint(1)
    if point then
        db.point = point
        db.relativePoint = relativePoint or point
        db.x = x or 0
        db.y = y or 0
    end
end

local function applyPosition()
    ticker:ClearAllPoints()
    local point = db.point or "TOP"
    local relativePoint = db.relativePoint or point
    ticker:SetPoint(point, UIParent, relativePoint, db.x or 0, db.y or -40)
end

local function setLocked(locked)
    db.locked = locked and true or false
    ticker:SetMovable(not db.locked)
    ticker:EnableMouse(not db.locked)
    if db.locked then
        ticker:RegisterForDrag()
        ticker:SetScript("OnDragStart", nil)
        ticker:SetScript("OnDragStop", nil)
    else
        ticker:RegisterForDrag("LeftButton")
        ticker:SetScript("OnDragStart", function(self)
            self:StartMoving()
        end)
        ticker:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing()
            savePosition()
            if not active then
                self:Hide()
                text:SetText("")
            end
        end)
        if not active then
            text:SetText("PartyTicker — Drag to move")
            local r, g, b = getChatColor()
            text:SetTextColor(r, g, b)
            text:ClearAllPoints()
            text:SetPoint("LEFT", ticker, "LEFT", 10, 0)
            text:SetWidth(FRAME_WIDTH - 20)
            text:Show()
            ticker:Show()
        end
    end
end

local function splitUtf8(value)
    local chars = {}
    for char in string.gmatch(value, "[%z\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = char
    end
    return chars
end

local function hideFallbackGlyphs()
    for i = 1, #fallbackGlyphs do fallbackGlyphs[i].fontString:Hide() end
    fallbackGlyphs = {}
    fallbackWidth = 0
end

local function prepareFallback(value, r, g, b)
    hideFallbackGlyphs()
    local fontFile, fontSize, fontFlags = text:GetFont()
    local measure = ticker:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    measure:SetFont(fontFile, fontSize, fontFlags)
    measure:SetJustifyH("LEFT")
    measure:SetJustifyV("MIDDLE")
    local chars = splitUtf8(value)
    for i = 1, #chars do
        measure:SetText(chars[i])
        local glyphWidth = math.max(1, measure:GetStringWidth())
        local glyph = ticker:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        glyph:SetFont(fontFile, fontSize, fontFlags)
        glyph:SetTextColor(r, g, b)
        glyph:SetText(chars[i])
        glyph:SetJustifyH("LEFT")
        glyph:SetJustifyV("MIDDLE")
        glyph:SetWidth(glyphWidth + 1)
        glyph:Hide()
        fallbackGlyphs[#fallbackGlyphs + 1] = { fontString = glyph, width = glyphWidth }
        fallbackWidth = fallbackWidth + glyphWidth
    end
    measure:Hide()
end

local function applyFontSize()
    local fontFile = text:GetFont()
    local size = db and db.size or DEFAULT_SIZE
    text:SetFont(fontFile, size, "OUTLINE")
    ticker:SetHeight(math.max(FRAME_HEIGHT, size + 12))
    if not hasNativeClipping and active then
        local value = text:GetText() or ""
        local r, g, b = text:GetTextColor()
        prepareFallback(value, r, g, b)
    end
end

local function startNext()
    if #queue == 0 then
        active = false
        ticker:Hide()
        text:SetText("")
        text:Show()
        hideFallbackGlyphs()
        return
    end
    active = true
    local item = table.remove(queue, 1)
    local r, g, b = item.r, item.g, item.b
    text:SetTextColor(r, g, b)
    text:SetText(item.text)
    local width = text:GetStringWidth()
    if not width or width <= 0 then width = 1 end
    textX = FRAME_WIDTH + 1
    text:ClearAllPoints()
    text:SetPoint("LEFT", ticker, "LEFT", textX, 0)
    text:SetWidth(math.max(width + 2, FRAME_WIDTH))
    if hasNativeClipping then
        hideFallbackGlyphs()
        text:Show()
    else
        text:Hide()
        prepareFallback(item.text, r, g, b)
        fallbackWidth = fallbackWidth or width
    end
    ticker:Show()
end

local function enqueue(message, author, label, chatType)
    if not message or message == "" then return end
    local prefix = label or "Party"
    local authorPrefix = author and author ~= "" and (author .. ": ") or ""
    local r, g, b = getChatColor(chatType or "PARTY")
    queue[#queue + 1] = {
        text = "[" .. prefix .. "] " .. authorPrefix .. message,
        r = r, g = g, b = b,
    }
    if not active then startNext() end
end

ticker:SetScript("OnUpdate", function(self, elapsed)
    if not active then return end
    local speed = (db and db.speed or DEFAULT_SPEED) * elapsed
    textX = textX - speed
    local x = textX
    local textWidth = text:GetStringWidth() or 0
    if not hasNativeClipping then
        local offset = 0
        for i = 1, #fallbackGlyphs do
            local glyph = fallbackGlyphs[i]
            local left = x + offset
            glyph.fontString:ClearAllPoints()
            glyph.fontString:SetPoint("LEFT", self, "LEFT", left, 0)
            if left >= 0 and left + glyph.width <= FRAME_WIDTH then
                glyph.fontString:Show()
            else
                glyph.fontString:Hide()
            end
            offset = offset + glyph.width
        end
        textWidth = fallbackWidth
    else
        text:ClearAllPoints()
        text:SetPoint("LEFT", self, "LEFT", x, 0)
    end
    if x + textWidth < 0 then
        startNext()
    end
end)

local function registerChatEvents()
    ticker:UnregisterEvent("CHAT_MSG_PARTY")
    ticker:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
    ticker:UnregisterEvent("CHAT_MSG_RAID")
    ticker:UnregisterEvent("CHAT_MSG_RAID_LEADER")
    ticker:UnregisterEvent("CHAT_MSG_GUILD")
    ticker:UnregisterEvent("CHAT_MSG_OFFICER")
    ticker:RegisterEvent("CHAT_MSG_PARTY")
    ticker:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    if db.guild then ticker:RegisterEvent("CHAT_MSG_GUILD") end
    if db.officer then ticker:RegisterEvent("CHAT_MSG_OFFICER") end
    if db.raid then
        ticker:RegisterEvent("CHAT_MSG_RAID")
        ticker:RegisterEvent("CHAT_MSG_RAID_LEADER")
    end
end

ticker:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon ~= ADDON_NAME then return end
        PartyTickerDB = type(PartyTickerDB) == "table" and PartyTickerDB or {}
        db = PartyTickerDB
        for key, value in pairs(defaults) do
            if db[key] == nil then db[key] = value end
        end
        db.speed = math.max(MIN_SPEED, math.min(MAX_SPEED, tonumber(db.speed) or DEFAULT_SPEED))
        db.size = math.max(MIN_SIZE, math.min(MAX_SIZE, tonumber(db.size) or DEFAULT_SIZE))
        applyFontSize()
        db.raid = db.raid and true or false
        db.guild = db.guild ~= false
        db.officer = db.officer and true or false
        applyPosition()
        setLocked(db.locked ~= false)
        registerChatEvents()
    elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
        local message, author = ...
        enqueue(message, author, "Party", "PARTY")
    elseif db and db.guild and event == "CHAT_MSG_GUILD" then
        local message, author = ...
        enqueue(message, author, "Guild", "GUILD")
    elseif db and db.officer and event == "CHAT_MSG_OFFICER" then
        local message, author = ...
        enqueue(message, author, "Officer", "OFFICER")
    elseif db and db.raid and (event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER") then
        local message, author = ...
        enqueue(message, author, "Raid", "RAID")
    end
end)
ticker:RegisterEvent("ADDON_LOADED")

SLASH_PARTYTICKER1 = "/pticker"
SlashCmdList.PARTYTICKER = function(input)
    if not db then
        print("PartyTicker: Settings are still loading.")
        return
    end
    local command, argument = string.match(input or "", "^%s*(%S*)%s*(.-)%s*$")
    command = string.lower(command or "")
    argument = string.lower(argument or "")

    if command == "speed" then
        local speed = tonumber(argument)
        if speed then
            db.speed = math.max(MIN_SPEED, math.min(MAX_SPEED, speed))
            print("PartyTicker: Speed set to " .. db.speed .. " px/s.")
        else
            print("PartyTicker: Usage: /pticker speed <number> (20-600)")
        end
    elseif command == "size" then
        local size = tonumber(argument)
        if size then
            db.size = math.max(MIN_SIZE, math.min(MAX_SIZE, size))
            applyFontSize()
            print("PartyTicker: Font size set to " .. db.size .. ".")
        else
            print("PartyTicker: Usage: /pticker size <number> (10-48)")
        end
    elseif command == "raid" then
        if argument == "on" then
            db.raid = true
            registerChatEvents()
            print("PartyTicker: Raid chat enabled.")
        elseif argument == "off" then
            db.raid = false
            registerChatEvents()
            print("PartyTicker: Raid chat disabled.")
        else
            print("PartyTicker: Usage: /pticker raid on|off")
        end
    elseif command == "guild" or command == "officer" then
        local key = command
        local enabled = db[key]
        if argument == "on" then
            enabled = true
        elseif argument == "off" then
            enabled = false
        elseif argument == "" then
            enabled = not enabled
        else
            print("PartyTicker: Usage: /pticker " .. command .. " on|off (currently: " .. (enabled and "on" or "off") .. ")")
            return
        end
        db[key] = enabled
        registerChatEvents()
        print("PartyTicker: " .. (key == "guild" and "Guild chat" or "Officer chat") .. " " .. (enabled and "enabled" or "disabled") .. ".")
    elseif command == "status" then
        print("PartyTicker: Party on | Raid " .. (db.raid and "on" or "off") .. " | Guild " .. (db.guild and "on" or "off") .. " | Officer " .. (db.officer and "on" or "off") .. ".")
    elseif command == "test" then
        enqueue("PartyTicker is ready!", UnitName("player") or "Test", "Party", "PARTY")
        enqueue("Guild chat is displayed as a ticker.", UnitName("player") or "Test", "Guild", "GUILD")
    elseif command == "lock" then
        setLocked(true)
        print("PartyTicker: Position locked.")
    elseif command == "unlock" then
        setLocked(false)
        print("PartyTicker: Drag the ticker with the left mouse button.")
    elseif command == "reset" then
        for key, value in pairs(defaults) do db[key] = value end
        applyFontSize()
        applyPosition()
        setLocked(true)
        registerChatEvents()
        print("PartyTicker: Settings reset.")
    else
        print("PartyTicker: /pticker speed <number> | size <number> | raid on/off | guild on/off | officer on/off | status | test | lock | unlock | reset")
    end
end
