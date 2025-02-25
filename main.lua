local api = require("api")
local file = "thiccbars\\data\\_global.lua"
local CreateSlider =  require('thiccbars/util/slider') 
checkButton = require('thiccbars/util/check_button')
globals = require("thiccbars//common")
-- First up is the addon definition!
-- This information is shown in the Addon Manager.
-- You also specify "unload" which is the function called when unloading your addon.
local sandbox_addon = {
  name = "Thicc Bars",
  author = "Delarme",
  desc = "Nameplate overhaul addon.",
  version = "1.2.1"
}

local nextcheck = false
local settingschanged = true
-- The Load Function is called as soon as the game loads its UI. Use it to initialize anything you need!
local w
local settings = {}
local event
local eventwatched
local ROWPADDING = 7
local CreateRaidMember
local SetViewOfRaidMember
local preview
local SettingsFrame
local SettingsButton
local raidmanager




function LoadSettings()
	
	return api.File:Read(file)
end
function SaveSettings()
    api.File:Write(file, settings)
    settingschanged = true
end

function CheckSettings()
    if settings == nil then
        settings = {}
    end
    if settings.version == nil then
        settings.version = 1
    end
    if settings.showbars == nil then
        settings.showbars = true
    end
    if settings.shiftenabled == nil then
        settings.shiftenabled = true
    end
    if settings.ctrlenabled == nil then
        settings.ctrlenabled = true
    end
    if settings.bartransparency == nil then
        settings.bartransparency = 100
    end
    if settings.width == nil then
        settings.width = globals.MEMBER_WIDTH
    end
    if settings.hpheight == nil then
        settings.hpheight = 28
    end
    if settings.mpheight == nil then
        settings.mpheight = 6
    end
    if settings.buffsize == nil then
        settings.buffsize = 16
    end
end



local function OnRightClickMenu(popup_menu)
  

end


function DoUpdate()
    if w == nil then
        return
    end
    if w.party == nil then
        return
    end
    for i = 1, #w.party do
        local party = w.party[i]
        party:Refresh(settings, settingschanged)
    end
    if SettingsFrame:IsVisible() then
        SettingsFrame:Refresh(settings, settingschanged)
    end
    --local mousex, mousey = api.Input:GetMousePos()
   
    --mousex = math.ceil(mousex / settings.width)
    --mousey = math.ceil(mousey / (settings.hpheight + settings.mpheight))
    
    settingschanged = false
end

local function OnUpdate()
    local res, error = pcall(DoUpdate)
    if res == false then
        api.Log:Err(error)
    end
end

local targetoftargetframe
local targetunitframe
local ondragold
local ondragoldtarget
local ondragoldwatched
local watchtargetframe

local function hijackOnDrag(arg)

    ondragold(arg)
    --if player is moving the window we escape
    if api.Input:IsShiftKeyDown() then
        return
    end
    targetoftargetframe.eventWindow:OnClick("LeftButton")
end

local function hijackWatchedOnDrag(arg)
    
    ondragoldwatched(arg)
    --if player is moving the window we escape
    if api.Input:IsShiftKeyDown() then
        return
    end
    watchtargetframe.eventWindow:OnClick("LeftButton")
end



local function ChangeTarget(arg)
    targetunitframe.target = arg
    targetunitframe.eventWindow:OnClick("LeftButton")
    targetunitframe.target = "target"
end



local function CreateViewOfSettingsFrame()
    local w = api.Interface:CreateWindow("ThiccSettingsWnd", "ThiccBar Settings", 600, 420)
    w:SetTitle("Settings")
    w:AddAnchor("CENTER", "UIParent", 0, 0)
    w:SetCloseOnEscape(true)

    local closeButton = w:CreateChildWidget("button", "closeButton", 0, false)
    closeButton:SetText("Close")
    closeButton:AddAnchor("BOTTOM", w, -45, -10)
    ApplyButtonSkin(closeButton, BUTTON_BASIC.DEFAULT)

    w.closeButton = closeButton

    previewLabel = w:CreateChildWidget("label", "previewLabel", 0, true)
    previewLabel:AddAnchor("TOPLEFT", w, 400, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 0)
    previewLabel:SetText("Preview:")
    previewLabel:SetHeight(FONT_SIZE.LARGE)
    previewLabel.style:SetFontSize(FONT_SIZE.LARGE)
    previewLabel.style:SetAlign(3)
    ApplyTextColor(previewLabel, FONT_COLOR.DEFAULT)

    w.previewLabel = previewLabel

    preview = CreateRaidMember(w, "player", "memberWindow", 0, ChangeTarget, settings)
    
    preview:Show(true)
    preview.memberIndex = 0
    preview.target = "player"

    preview:RemoveAllAnchors() -- should remove anchors before moving one
    preview:AddAnchor("TOPLEFT", w, 350, 30)

    w.preview = preview

    showThiccLabel = w:CreateChildWidget("label", "showThiccLabel", 0, true)
    showThiccLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 0)
    showThiccLabel:SetText("Thicc Bars:")
    showThiccLabel:SetHeight(FONT_SIZE.LARGE)
    showThiccLabel.style:SetFontSize(FONT_SIZE.LARGE)
    showThiccLabel.style:SetAlign(3)
    ApplyTextColor(showThiccLabel, FONT_COLOR.DEFAULT)

    w.showThiccLabel = showThiccLabel

    w.showThiccCheckButton = checkButton.CreateCheckButton("showThiccCheckButton", w, nil)
    w.showThiccCheckButton:AddAnchor("TOPLEFT", w, 100, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 0)
    w.showThiccCheckButton:SetButtonStyle("default")
    w.showThiccCheckButton:Show(true)


    keyLabel = w:CreateChildWidget("label", "keyLabel", 0, true)
    keyLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 1)
    keyLabel:SetText("While below key is held, mouse clicks will pass through thicc bars. ")
    keyLabel:SetHeight(FONT_SIZE.MIDDLE)
    keyLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    keyLabel.style:SetAlign(3)
    ApplyTextColor(keyLabel, FONT_COLOR.DEFAULT)

    w.keyLabel = keyLabel

    shiftLabel = w:CreateChildWidget("label", "shiftLabel", 0, true)
    shiftLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 2)
    shiftLabel:SetText("Shift:")
    shiftLabel:SetHeight(FONT_SIZE.LARGE)
    shiftLabel.style:SetFontSize(FONT_SIZE.LARGE)
    shiftLabel.style:SetAlign(3)
    ApplyTextColor(shiftLabel, FONT_COLOR.DEFAULT)

    w.shiftLabel = shiftLabel

    w.shiftCheckButton = checkButton.CreateCheckButton("shiftCheckButton", w, nil)
    w.shiftCheckButton:AddAnchor("TOPLEFT", w, 100, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 2)
    w.shiftCheckButton:SetButtonStyle("default")
    w.shiftCheckButton:Show(true)   

    controlLabel = w:CreateChildWidget("label", "controlLabel", 0, true)
    controlLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 3)
    controlLabel:SetText("Control:")
    controlLabel:SetHeight(FONT_SIZE.LARGE)
    controlLabel.style:SetFontSize(FONT_SIZE.LARGE)
    controlLabel.style:SetAlign(3)
    ApplyTextColor(controlLabel, FONT_COLOR.DEFAULT)

    w.controlLabel = controlLabel

    w.controlCheckButton = checkButton.CreateCheckButton("controlCheckButton", w, nil)
    w.controlCheckButton:AddAnchor("TOPLEFT", w, 100, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 3)
    w.controlCheckButton:SetButtonStyle("default")
    w.controlCheckButton:Show(true)

    --w:CreateChildWidgetByType()
    local transparencyLabel = w:CreateChildWidget("label", "transparencyLabel", 0, true)
    transparencyLabel:SetHeight(FONT_SIZE.LARGE)
    transparencyLabel:SetAutoResize(true)
    transparencyLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 4)
    transparencyLabel:SetText("Transparency")
    transparencyLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(transparencyLabel, FONT_COLOR.DEFAULT)

    local transparencyScroll = CreateSlider("transparencyScroll", transparencyLabel)
    transparencyScroll:SetStep(1)
    transparencyScroll:SetMinMaxValues(0, 100)
    transparencyScroll:SetInitialValue(settings.bartransparency, false)
    transparencyScroll:UseWheel()

   

    transparencyScroll:AddAnchor("TOPLEFT", transparencyLabel, "BOTTOMLEFT", 0, 5)
    transparencyScroll:AddAnchor("RIGHT", w, -15, 0)
    w.transparencyScroll = transparencyScroll

    local percentLabel = w:CreateChildWidget("label", "percentLabel", 0, true)
    percentLabel:SetExtent(30, 20)
    percentLabel:AddAnchor("LEFT", transparencyLabel, "RIGHT", 7, 0)
    percentLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(percentLabel, FONT_COLOR.BLUE)
    local bg = percentLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", percentLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", percentLabel, 5, 6)
    percentLabel.bg = bg
    w.transparencyScroll.percentLabel = percentLabel

    local str = string.format("%d", settings.bartransparency)
    w.transparencyScroll.percentLabel:SetText(tostring(str))


    local WidthLabel = w:CreateChildWidget("label", "WidthLabel", 0, true)
    WidthLabel:SetHeight(FONT_SIZE.LARGE)
    WidthLabel:SetAutoResize(true)
    WidthLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 6)
    WidthLabel:SetText("Width")
    WidthLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(WidthLabel, FONT_COLOR.DEFAULT)

    local WidthScroll = CreateSlider("WidthScroll", WidthLabel)
    WidthScroll:SetStep(1)
    WidthScroll:SetMinMaxValues(50, 150)
    WidthScroll:SetInitialValue(settings.width, false)
    WidthScroll:UseWheel()

   

    WidthScroll:AddAnchor("TOPLEFT", WidthLabel, "BOTTOMLEFT", 0, 7)
    WidthScroll:AddAnchor("RIGHT", w, -15, 0)
    w.WidthScroll = WidthScroll

    local widthSettingLabel = w:CreateChildWidget("label", "widthSettingLabel", 0, true)
    widthSettingLabel:SetExtent(30, 20)
    widthSettingLabel:AddAnchor("LEFT", WidthLabel, "RIGHT", 7, 0)
    widthSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(widthSettingLabel, FONT_COLOR.BLUE)
    local bg = widthSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", widthSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", widthSettingLabel, 5, 6)
    widthSettingLabel.bg = bg
    w.WidthScroll.widthSettingLabel = widthSettingLabel

    local str = string.format("%d", settings.width)
    w.WidthScroll.widthSettingLabel:SetText(tostring(str))

    local HPHeightLabel = w:CreateChildWidget("label", "HPHeightLabel", 0, true)
    HPHeightLabel:SetHeight(FONT_SIZE.LARGE)
    HPHeightLabel:SetAutoResize(true)
    HPHeightLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 8)
    HPHeightLabel:SetText("HP Height")
    HPHeightLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(HPHeightLabel, FONT_COLOR.DEFAULT)

    local HPHeightScroll = CreateSlider("HPHeightScroll", HPHeightLabel)
    HPHeightScroll:SetStep(1)
    HPHeightScroll:SetMinMaxValues(5, 50)
    HPHeightScroll:SetInitialValue(settings.hpheight, false)
    HPHeightScroll:UseWheel()

   

    HPHeightScroll:AddAnchor("TOPLEFT", HPHeightLabel, "BOTTOMLEFT", 0, 7)
    HPHeightScroll:AddAnchor("RIGHT", w, -15, 0)
    w.HPHeightScroll = HPHeightScroll

    local HPHeightSettingLabel = w:CreateChildWidget("label", "HPHeightSettingLabel", 0, true)
    HPHeightSettingLabel:SetExtent(30, 20)
    HPHeightSettingLabel:AddAnchor("LEFT", HPHeightLabel, "RIGHT", 7, 0)
    HPHeightSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(HPHeightSettingLabel, FONT_COLOR.BLUE)
    local bg = HPHeightSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", HPHeightSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", HPHeightSettingLabel, 5, 6)
    HPHeightSettingLabel.bg = bg
    w.HPHeightScroll.HPHeightSettingLabel = HPHeightSettingLabel

    local str = string.format("%d", settings.hpheight)
    w.HPHeightScroll.HPHeightSettingLabel:SetText(tostring(str))


    local MPHeightLabel = w:CreateChildWidget("label", "MPHeightLabel", 0, true)
    MPHeightLabel:SetHeight(FONT_SIZE.LARGE)
    MPHeightLabel:SetAutoResize(true)
    MPHeightLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 10)
    MPHeightLabel:SetText("MP Height")
    MPHeightLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(MPHeightLabel, FONT_COLOR.DEFAULT)

    local MPHeightScroll = CreateSlider("MPHeightScroll", MPHeightLabel)
    MPHeightScroll:SetStep(1)
    MPHeightScroll:SetMinMaxValues(0, 30)
    MPHeightScroll:SetInitialValue(settings.mpheight, false)
    MPHeightScroll:UseWheel()

   

    MPHeightScroll:AddAnchor("TOPLEFT", MPHeightLabel, "BOTTOMLEFT", 0, 7)
    MPHeightScroll:AddAnchor("RIGHT", w, -15, 0)
    w.MPHeightScroll = MPHeightScroll

    local MPHeightSettingLabel = w:CreateChildWidget("label", "MPHeightSettingLabel", 0, true)
    MPHeightSettingLabel:SetExtent(30, 20)
    MPHeightSettingLabel:AddAnchor("LEFT", MPHeightLabel, "RIGHT", 7, 0)
    MPHeightSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(MPHeightSettingLabel, FONT_COLOR.BLUE)
    local bg = MPHeightSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", MPHeightSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", MPHeightSettingLabel, 5, 6)
    MPHeightSettingLabel.bg = bg
    w.MPHeightScroll.MPHeightSettingLabel = MPHeightSettingLabel

    local str = string.format("%d", settings.mpheight)
    w.MPHeightScroll.MPHeightSettingLabel:SetText(tostring(str))

    local BuffSizeLabel = w:CreateChildWidget("label", "BuffSizeLabel", 0, true)
    BuffSizeLabel:SetHeight(FONT_SIZE.LARGE)
    BuffSizeLabel:SetAutoResize(true)
    BuffSizeLabel:AddAnchor("TOPLEFT", w, 15, 47 + (FONT_SIZE.LARGE + ROWPADDING) * 12)
    BuffSizeLabel:SetText("Debuff Icon Size")
    BuffSizeLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(BuffSizeLabel, FONT_COLOR.DEFAULT)

    local BuffSizeScroll = CreateSlider("BuffSizeScroll", BuffSizeLabel)
    BuffSizeScroll:SetStep(1)
    BuffSizeScroll:SetMinMaxValues(0, 50)
    BuffSizeScroll:SetInitialValue(settings.buffsize, false)
    BuffSizeScroll:UseWheel()

   

    BuffSizeScroll:AddAnchor("TOPLEFT", BuffSizeLabel, "BOTTOMLEFT", 0, 7)
    BuffSizeScroll:AddAnchor("RIGHT", w, -15, 0)
    w.BuffSizeScroll = BuffSizeScroll

    local BuffSizeSettingLabel = w:CreateChildWidget("label", "BuffSizeSettingLabel", 0, true)
    BuffSizeSettingLabel:SetExtent(30, 20)
    BuffSizeSettingLabel:AddAnchor("LEFT", BuffSizeLabel, "RIGHT", 7, 0)
    BuffSizeSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(BuffSizeSettingLabel, FONT_COLOR.BLUE)
    local bg = BuffSizeSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", BuffSizeSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", BuffSizeSettingLabel, 5, 6)
    BuffSizeSettingLabel.bg = bg
    w.BuffSizeScroll.BuffSizeSettingLabel = BuffSizeSettingLabel

    local str = string.format("%d", settings.buffsize)
    w.BuffSizeScroll.BuffSizeSettingLabel:SetText(tostring(str))

    function w:Refresh(settings, settingschanged)
        preview:Refresh(settings, settingschanged)
        preview:RemoveAllAnchors() -- should remove anchors before moving one
        preview:AddAnchor("TOPLEFT", w, 400, 75)

    end

    function w:OnClose()
        w:Show(false)
        SaveSettings()
    end

    function w:ThiccOnCheckChanged()
         local checked = w.showThiccCheckButton:GetChecked()
         settings.showbars = checked
         SaveSettings()
    end
    function w:ShiftOnCheckChanged()
          local checked = w.shiftCheckButton:GetChecked()
         settings.shiftenabled = checked  
         SaveSettings()
    end
    function w:ControlOnCheckChanged()
         local checked = w.controlCheckButton:GetChecked()
         settings.ctrlenabled = checked
         SaveSettings()
    end

    function w.transparencyScroll:OnSliderChanged(arg)
        local value = w.transparencyScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.transparencyScroll.percentLabel:SetText(tostring(str))
        settings.bartransparency = value
        settingschanged = true
    end

    function w.WidthScroll:OnSliderChanged(arg)
        local value = w.WidthScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.WidthScroll.widthSettingLabel:SetText(tostring(str))
        settings.width = value
        settingschanged = true
    end

    function w.HPHeightScroll:OnSliderChanged(arg)
        local value = w.HPHeightScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.HPHeightScroll.HPHeightSettingLabel:SetText(tostring(str))
        settings.hpheight = value
        settingschanged = true
    end

    function w.MPHeightScroll:OnSliderChanged(arg)
        local value = w.MPHeightScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.MPHeightScroll.MPHeightSettingLabel:SetText(tostring(str))
        settings.mpheight = value
        settingschanged = true
    end

    function w.BuffSizeScroll:OnSliderChanged(arg)
        local value = w.BuffSizeScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.BuffSizeScroll.BuffSizeSettingLabel:SetText(tostring(str))
        settings.buffsize = value
        settingschanged = true
    end

    w.transparencyScroll:SetHandler("OnSliderChanged", w.transparencyScroll.OnSliderChanged)
    w.WidthScroll:SetHandler("OnSliderChanged", w.WidthScroll.OnSliderChanged)
    w.HPHeightScroll:SetHandler("OnSliderChanged", w.HPHeightScroll.OnSliderChanged)
    w.MPHeightScroll:SetHandler("OnSliderChanged", w.MPHeightScroll.OnSliderChanged)
    w.BuffSizeScroll:SetHandler("OnSliderChanged", w.BuffSizeScroll.OnSliderChanged)

    w.showThiccCheckButton:SetChecked(settings.showbars)
    w.shiftCheckButton:SetChecked(settings.shiftenabled)
    w.controlCheckButton:SetChecked(settings.ctrlenabled)

    w.showThiccCheckButton:SetHandler("OnCheckChanged", w.ThiccOnCheckChanged)
    w.shiftCheckButton:SetHandler("OnCheckChanged", w.ShiftOnCheckChanged)
    w.controlCheckButton:SetHandler("OnCheckChanged", w.ControlOnCheckChanged)
    closeButton:SetHandler("OnClick", w.OnClose)

    

    return w
end



local function ShowSettings()
	SettingsFrame:Show(true)
end


local function Load() 
    membermethods = require("thiccbars//member")
    CreateRaidMember = membermethods.CreateRaidMember
    SetViewOfRaidMember = membermethods.SetViewOfRaidMember
    settings = LoadSettings()

    CheckSettings()

    SettingsFrame = CreateViewOfSettingsFrame()
    SettingsFrame:Show(false)

    raidmanager = ADDON:GetContent(UIC.RAID_MANAGER )

    if raidmanager.thiccButton ~= nil then
        raidmanager.thiccButton:Show(false)
        raidmanager.thiccButton = nil
    end

    local SettingsButton = raidmanager:CreateChildWidget("button", "thiccButton", 0, false)
    SettingsButton:SetText("Thicc Settings")
    SettingsButton:AddAnchor("BOTTOM", raidmanager, -25, -20)
    ApplyButtonSkin(SettingsButton, BUTTON_BASIC.DEFAULT)

    raidmanager.thiccButton = SettingsButton

    SettingsButton:SetHandler("OnClick", ShowSettings)

    --target of target frame
    targetoftargetframe = ADDON:GetContent(UIC.TARGET_OF_TARGET_FRAME)
    ondragold = targetoftargetframe.eventWindow.OnDragStart
    targetoftargetframe.eventWindow.OnDragStart = hijackOnDrag
    event = targetoftargetframe.eventWindow
    event:SetHandler("OnDragStart", event.OnDragStart)
    
    --target unit frame to get workaround to select target
    targetunitframe = ADDON:GetContent(UIC.TARGET_UNITFRAME)
    
    --watch target frame
    watchtargetframe = ADDON:GetContent(UIC.WATCH_TARGET_FRAME)
    ondragoldwatched = watchtargetframe.eventWindow.OnDragStart
    watchtargetframe.eventWindow.OnDragStart = hijackWatchedOnDrag
    eventwatched = watchtargetframe.eventWindow
    eventwatched:SetHandler("OnDragStart", eventwatched.OnDragStart)

    w = api.Interface:CreateEmptyWindow("emptywidget", "UIParent")
    w:Clickable(false)
    w:Show(false)
    w.simple = false
    w.vertical = false
    w.rowCount = 0
    w.columnCount = 0

    --create raid member tags   
    local party = {}
    for i = 1, 50 do
        party[i] = CreateRaidMember(nil, string.format("party%d", i), "memberWindow", i, ChangeTarget, settings)
    end
    w.party = party

    SaveSettings()
end

-- Unload is called when addons are reloaded.
-- Here you want to destroy your windows and do other tasks you find useful.
local function Unload()
    if targetoftargetframe ~= nil then
	   -- info.Click = old
        targetoftargetframe.eventWindow.OnDragStart = ondragold
        event:SetHandler("OnDragStart", event.OnDragStart)
    end
    if watchtargetframe ~= nil then
	   -- info.Click = old
        watchtargetframe.eventWindow.OnDragStart = ondragoldwatched
        eventwatched:SetHandler("OnDragStart", eventwatched.OnDragStart)
    end
   if w ~= nil then
        for i = 1, #w.party do
            w.party[i]:OnClose()
            w.party[i]:Show(false)
        end
        w.party = nil
        w:Show(false)
        w = nil
   end
   if wi ~= nil then
        wi:Show(false)
        wi = nil
    end

    if raidmanager.thiccButton ~= nil then
        raidmanager.thiccButton:Show(false)
        raidmanager.thiccButton = nil
    end

end
--api.On("ShowPopUp", OnRightClickMenu)
api.On("UPDATE", OnUpdate)

-- Here we make sure to bind the functions we defined to our addon. This is how the game knows what function to use!
sandbox_addon.OnLoad = Load
sandbox_addon.OnUnload = Unload


return sandbox_addon
