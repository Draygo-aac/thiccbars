WATCH_DEBUFF_IFDEAD = {
    18353
}

DICTONARY_WATCH_DEBUFF_ID = { 
    [18351] = true, -- petify but buff
    [20349] = true, 
    [18352] = true, --abyssal petrify
    [3783] = true, --petrify
    [3845] = true, --petrify
    [6967] = true, --jola
    [21383] = true, --filthy mucus (sealbreaker)
    [2869] = true, -- enervate
    [2870] = true,
    [6955] = true,
    [15208] = true,
    [2124] = true,
    [2745] = true,
    [1176] = true,
    [4712] = true,
    [2835] = true,
    [101] = true, --enervate
    [467] = true,  --curse
    [15210] = true,
    [20572] = true, --chilling wind
    [20570] = true, 
    [20571] = true,
    [6184] = true, -- leech
    [14284] = true, --distress
    [15175] = true,
    [6896] = true,
    [6904] = true, --cursed flame
    [15225] = true, --mark
    [15141] = true, --nightmare grinder (belt tk)
    [7188] = true, --TK
    [2012] = true,
    [17159] = true,
    [1169] = true,
    [4866] = true,
    [4286] = true,
    [2261] = true,
    [551] = true,
    [771] = true, --charm
    [21434] = true,
    [21432] = true
}

globals = require("thiccbars//common")

local BUFF_ANIMATION_TIME = 0.1
local BLINK_START_TIME = 0
local BLINK_HALF_CYCLE = 800

local function SetViewOfBuffWindow(id, w, maxCount)
    w.buffCountOnSingleLine = 12
    w.iconSize = 14
    w.iconXGap = 2
    w.iconYGap = 2
    w.iconSortVertical = false
    w.button = {}
    for i = 1, maxCount do
        local button = CreateItemIconButton(id .. ".button[" .. i .. "]", w)
    
        button:Show(false)
        button:Clickable(false)
        button.anim = false
        F_SLOT.ApplySlotSkin(button, button.back, SLOT_STYLE.BUFF)
        button.back:SetColor(1, 0, 0, 1)
        w.button[i] = button
    end
    function w:SetVisibleBuffCount(count)
        w.visibleBuffCount = count
    end
    w:SetVisibleBuffCount(maxCount)
    function w:SetLayout(buffCountOnSingleLine, size, xGap, yGap, sortVertical)
        self.iconSortVertical = sortVertical
        if self.buffCountOnSingleLine == buffCountOnSingleLine and self.iconSize == size and self.iconXGap == xGap then
            return
        end
        self.buffCountOnSingleLine = buffCountOnSingleLine
        self.iconSize = size
        self.iconXGap = xGap
        for i = 1, #w.button do
            self.button[i]:SetExtent(size, size)
            self.button[i]:RemoveAllAnchors()
            local column = i - 1
            self.button[i]:AddAnchor("TOPLEFT", self, column * (size + xGap), 0)
        end
    end
    return w
end

local function UpdateExtent(wnd, count)
    local row = math.floor((count - 1) / wnd.buffCountOnSingleLine)
    local column = math.mod(count - 1, wnd.buffCountOnSingleLine)
    if wnd.sortVertical == true then
        row, column = column, row
    end
    if count < wnd.buffCountOnSingleLine then
        wnd:SetExtent((wnd.iconSize + wnd.iconXGap) * (column + 1), (wnd.iconSize + wnd.iconYGap) * (row + 1))
    else
        wnd:SetExtent((wnd.iconSize + wnd.iconXGap) * wnd.buffCountOnSingleLine, (wnd.iconSize + wnd.iconYGap) * (row + 1))
    end
end

function IsInWatchList(buffInfo, dead)
    --18353 is abyssal debuffs
    --2167 is pvp flag
    if dead then
        if buffInfo.buff_id == 18353 then
            return true, false
        end
    else
        return DICTONARY_WATCH_DEBUFF_ID[buffInfo.buff_id], buffInfo.buff_id == 2167
    end
    return false, false
end

function GetWatchedDebuffs(target, dead)
    local pvpDebuff = false
    local watchedDebuffList = {}
    local count = api.Unit:UnitDeBuffCount(target) or 0
    for i = 1, count do
        local buffInfo = api.Unit:UnitDeBuff(target, i)
        local watched, pvp = IsInWatchList(buffInfo, dead)
        if watched then
            table.insert(watchedDebuffList, buffInfo)
        end
        if pvp then
            pvpDebuff = true
        end
    end
    return watchedDebuffList, pvpDebuff
end

function CreateBuffWindow(id, window, maxCount)
    local w = SetViewOfBuffWindow(id, window, maxCount)
    w.count = -1
    w.buffTypeMap = {}
    w.pvpDebuff = false
    function w:ShowLifeTime(show)

    end
    function w:BuffUpdate(target, dead)
        if target == "player" then
            button = self.button[1]
            button:Show(true)
            button:SetAlpha(0.5)
            return
        end
        
        local count
        local debuffs, pvpDebuff = GetWatchedDebuffs(target, dead)
        self.pvpDebuff = pvpDebuff
        count = #debuffs or 0

        local buffTypeMap = {}
        for i = 1, #self.button do
            local button = self.button[i]
            local buffInfo 

            if i <= count and i <= self.visibleBuffCount then
                buffInfo = debuffs[i]

                if buffInfo ~= nil then
                    button.index = i
                    button.target = target
                    if button.t == nil or button.t and button.t.buff_id ~= buffInfo.buff_id then
                        F_SLOT.SetIconBackGround(button, buffInfo.path)
                    end
                    button.t = buffInfo
                    local buffType = buffInfo.buff_id
                    buffTypeMap[buffType] = i
                    button:Show(true)
                end
            else
                button.index = nil
                button.target = nil
                button.t = nil
                button:SetAlpha(1)
                button:Show(false)
            end
        end
        self.buffTypeMap = buffTypeMap
        if self.count ~= count then
            self.count = count
            UpdateExtent(self, count)
        end
    end
    return w
end

function SetViewOfRaidMember(name, ownId, index, parent)
    local w
    if parent == nil then
        w = api.Interface:CreateEmptyWindow(name, "UIParent")
        w:SetUILayer("game") --"system", "tooltip", "dialog", "game", "normal", "background", "questdirecting", "hud"
    else
        w = parent:CreateChildWidget("emptywidget", "eventWindow", 0, true)
    end
    w:SetExtent(globals.MEMBER_WIDTH, globals.MEMBER_HEIGHT)
    
    w.posX = 0
    w.posY = 0
    w.tileroot = nil
    w.dead = false
    w.markerId = 0
    w.pvpflag = false

    w:Show(true)
    local bg = w:CreateNinePartDrawable(TEXTURE_PATH.RAID, "background")
    bg:SetCoords(33, 141, 7, 7)
    bg:SetInset(3, 3, 3, 3)
    bg:SetColor(1, 1, 1, 0.8)

    local eventWindow = w:CreateChildWidget("emptywidget", "eventWindow", 0, true)
    eventWindow:AddAnchor("TOPLEFT", w, 0, 0)
    eventWindow:AddAnchor("BOTTOMRIGHT", w, 0, 0)
    eventWindow:Show(true)
    local hpBar = W_BAR.CreateStatusBarOfRaidFrame(w:GetId() .. ".hpBar", w)
    hpBar:Show(true)
    hpBar:Clickable(false)
    hpBar.statusBar:Clickable(false)
    hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID)
    w.hpBar = hpBar
    
    local mpBar = W_BAR.CreateStatusBarOfRaidFrame(w:GetId() .. ".mpBar", w)
    mpBar:Show(true)
    mpBar:Clickable(false)
    mpBar.statusBar:Clickable(false)
    w.mpBar = mpBar


    local pvpIcon = w:CreateChildWidget("emptywidget", "pvpIcon", 0, true)
    pvpIcon:SetExtent(12, 12)
    pvpIcon:Raise()
    local iconTexture = pvpIcon:CreateImageDrawable(TEXTURE_PATH.HUD, "background")
    iconTexture:SetCoords(729, 147, 12, 12)
    iconTexture:AddAnchor("TOPLEFT", pvpIcon, 0, 0)
    iconTexture:AddAnchor("BOTTOMRIGHT", pvpIcon, 0, 0)
    pvpIcon:AddAnchor("TOPRIGHT", hpBar, 0, 0)
    pvpIcon:Show(false)

    local selectedIcon = w:CreateNinePartDrawable(TEXTURE_PATH.RAID, "overlay")
    selectedIcon:SetInset(7, 7, 7, 7)

    --selectedIcon:SetCoords(87, 123, 15, 15)
    selectedIcon:SetCoords(79, 203, 18, 23)
    selectedIcon:SetVisible(true)
    selectedIcon:SetColor(1, 1, 1, 1)
    --selectedIcon:SetColor(ConvertColor(50), ConvertColor(219), ConvertColor(39), 1)

    w.selectedIcon = selectedIcon
    selectedIcon:AddAnchor("TOPLEFT", hpBar, -2, -2)
    selectedIcon:AddAnchor("BOTTOMRIGHT", mpBar, 2, 1)

    local leaderMark = W_ICON.CreateLeaderMark(w:GetId() .. ".leaderMark", w)
    leaderMark:Show(false)
    w.leaderMark = leaderMark
    leaderMark:Clickable(false)
    
    local nameLabel = w:CreateChildWidget("label", "nameLabel", 0, true)
    nameLabel:Show(true)
    nameLabel:Clickable(false)
    nameLabel:SetLimitWidth(true)
    nameLabel:SetExtent(112, FONT_SIZE.MIDDLE)
    nameLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameLabel.style:SetAlign(0)
    nameLabel:AddAnchor("TOPLEFT", w, 2, -10)
    w.nameLabel = nameLabel
    
    local guildLabel = w:CreateChildWidget("label", "guildLabel", 0, true)
    guildLabel:Show(true)
    guildLabel:Clickable(false)
    guildLabel:SetLimitWidth(true)
    guildLabel:SetExtent(112, FONT_SIZE.SMALL)
    guildLabel.style:SetFontSize(FONT_SIZE.SMALL)
    guildLabel.style:SetAlign(0)
    guildLabel:AddAnchor("BOTTOM", nameLabel, 0, FONT_SIZE.SMALL)
    guildLabel:AddAnchor("LEFT", w, 2, 0)
    guildLabel:SetText("")
    w.guildLabel = guildLabel

    local distanceLabel = w:CreateChildWidget("label", "distanceLabel", 0, true)
    distanceLabel:Show(true)
    distanceLabel:Clickable(false)
    distanceLabel:SetLimitWidth(true)
    distanceLabel:SetExtent(25, FONT_SIZE.SMALL)
    distanceLabel.style:SetFontSize(FONT_SIZE.SMALL)
    distanceLabel.style:SetAlign(2)
    distanceLabel:AddAnchor("TOPRIGHT", w, "TOPRIGHT", -3, FONT_SIZE.MIDDLE)
    distanceLabel:SetText("00m")
    w.distanceLabel = distanceLabel
    
    local marker = w:CreateImageDrawable(TEXTURE_PATH.MAP_ICON, "overlay")
    marker:SetVisible(false)
    marker:SetExtent(18, 18)
    marker:AddAnchor("TOPRIGHT", hpBar, 0, -1)
    w.marker = marker
    
    local buffWindow = w:CreateChildWidget("label", "buffwindow", 0 , true)
    CreateBuffWindow(w:GetId() .. ".buffWindow", buffWindow, 8)

    buffWindow:Show(true)
    buffWindow:Clickable(false)
    
    w.buffWindow = buffWindow
    
    bg:RemoveAllAnchors()
    bg:AddAnchor("TOPLEFT", hpBar, -3, -3)
    bg:AddAnchor("BOTTOMRIGHT", mpBar, 2, 3)
    bg:Show(true)
    w.bg = bg
    eventWindow:Raise()

    function w:SetSimpleMode(settings)
        self.simple = simple
        local height = settings.hpheight + settings.mpheight
        self:SetExtent(settings.width, height)
        self.hpBar:RemoveAllAnchors()
        self.hpBar:AddAnchor("TOPLEFT", self, 0, 0)
        self.hpBar:AddAnchor("TOPRIGHT", self, 0, 0)
        self.hpBar:SetHeight(settings.hpheight)
        self.mpBar:RemoveAllAnchors()
        self.mpBar:AddAnchor("TOPLEFT", self.hpBar, "BOTTOMLEFT", 0, -1)
        self.mpBar:AddAnchor("TOPRIGHT", self.hpBar, "BOTTOMRIGHT", 0, -1)
        self.mpBar:SetHeight(settings.mpheight)
        self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.MP_RAID)

        if settings.mpheight > 0 then
            self.mpBar:Show(true)
        else
            self.mpBar:Show(false)
        end

        self.leaderMark:RemoveAllAnchors()
        self.leaderMark:AddAnchor("TOPLEFT", self, 2, 3)
        self.buffWindow:SetLayout(12, settings.buffsize, 0, 2, false)
        self.buffWindow:RemoveAllAnchors()
        self.buffWindow:AddAnchor("TOPLEFT", self.hpBar, "TOPLEFT", 0, height - settings.buffsize - 1)
        self.buffWindow:SetVisibleBuffCount(8)

        self.nameLabel.style:SetFontSize(settings.namesize)
        self.nameLabel:SetExtent(112, settings.namesize)

        self.guildLabel.style:SetFontSize(settings.guildsize)
    end
    function w:TranslucenceFrame(percent)
        self:SetAlpha(percent)
    end
    return w
end

return SetViewOfRaidMember