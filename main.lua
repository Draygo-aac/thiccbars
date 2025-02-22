local api = require("api")
local file = "thiccbars\\data\\_global.lua"
local CreateSlider =  require('thiccbars/util/slider') 
checkButton = require('thiccbars/util/check_button')
-- First up is the addon definition!
-- This information is shown in the Addon Manager.
-- You also specify "unload" which is the function called when unloading your addon.
local sandbox_addon = {
  name = "Thicc Bars",
  author = "Delarme",
  desc = "Nameplate overhaul addon.",
  version = "1.1"
}

local nextcheck = false
local settingschanged = true
-- The Load Function is called as soon as the game loads its UI. Use it to initialize anything you need!
local w
local settings = {}

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

local event
local eventwatched
local ROWPADDING = 5
local function CreateViewOfSettingsFrame()
    local w = api.Interface:CreateWindow("ThiccSettingsWnd", "ThiccBar Settings", 600, 300)
    w:SetTitle("Settings")
    w:AddAnchor("CENTER", "UIParent", 0, 0)
    w:SetCloseOnEscape(true)

    local closeButton = w:CreateChildWidget("button", "closeButton", 0, false)
    closeButton:SetText("Close")
    closeButton:AddAnchor("BOTTOM", w, -45, -10)
    ApplyButtonSkin(closeButton, BUTTON_BASIC.DEFAULT)

    w.closeButton = closeButton


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
    w.transparencyScroll:SetHandler("OnSliderChanged", w.transparencyScroll.OnSliderChanged)

    w.showThiccCheckButton:SetChecked(settings.showbars)
    w.shiftCheckButton:SetChecked(settings.shiftenabled)
    w.controlCheckButton:SetChecked(settings.ctrlenabled)

    w.showThiccCheckButton:SetHandler("OnCheckChanged", w.ThiccOnCheckChanged)
    w.shiftCheckButton:SetHandler("OnCheckChanged", w.ShiftOnCheckChanged)
    w.controlCheckButton:SetHandler("OnCheckChanged", w.ControlOnCheckChanged)
    closeButton:SetHandler("OnClick", w.OnClose)

    

    return w
end
local SettingsFrame
local SettingsButton
local raidmanager


local function ShowSettings()
	SettingsFrame:Show(true)
end


local function Load() 

    globals = require("thiccbars//common")
    CreateRaidMember = require("thiccbars//member")
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
        party[i] = CreateRaidMember(w, string.format("party%d", i), "memberWindow", i, ChangeTarget)
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
api.On("ShowPopUp", OnRightClickMenu)
api.On("UPDATE", OnUpdate)

-- Here we make sure to bind the functions we defined to our addon. This is how the game knows what function to use!
sandbox_addon.OnLoad = Load
sandbox_addon.OnUnload = Unload


return sandbox_addon
