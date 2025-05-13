local api = require("api")
local file = "thiccbars\\data\\_global.lua"
local CreateSlider =  require('thiccbars/util/slider') 
checkButton = require('thiccbars/util/check_button')
globals = require("thiccbars//common")
-- First up is the addon definition!
-- This information is shown in the Addon Manager.
-- You also specify "unload" which is the function called when unloading your addon.
local thicc_addon = {
  name = "Thicc Bars",
  author = "Delarme",
  desc = "Nameplate overhaul addon.",
  version = "1.5.4"
}
local widthoff = 0
local width = 64 - ( widthoff * 2 )
MARKERSCALER = 50
local markerCoords = {
    {
    0 + widthoff,
    0,
    width,
    75
    },
    {
    64  + widthoff,
    0,
    width,
    77
    },
    {
    128 + widthoff,
    0,
    width,
    75
    },
    {
    192 + widthoff,
    0,
    width,
    75
    },
    {
    0 + widthoff,
    75,
    width,
    75
    },
    {
    64 + widthoff,
    75,
    width,
    75
    },
    {
    128 + widthoff,
    75,
    width,
    75
    },
    {
    192 + widthoff,
    75,
    width,
    75
    },
    {
    0 + widthoff,
    150,
    width,
    75
    },
    {
    64 + widthoff,
    150,
    width,
    75
    },
    {
    128 + widthoff,
    150,
    width,
    75
    },
    {
    192 + widthoff,
    150,
    width,
    75
    }
}

--create a 50x50 grid template. 
local gridtemplate = {
    0,0,
    0,1,
    1,0,
    1,1,
    0,2,
    1,2,
    0,3,
    1,3,
    0,4,
    1,4,
    2,0,
    2,1,
    2,2,
    2,3,
    2,4,
    0,5,
    1,5,
    2,5,
    0,6,
    1,6,
    2,6,
    3,0,
    3,1,
    3,2,
    3,3,
    3,4,
    3,5,
    3,6,
    0,7,
    1,7,
    2,7,
    3,7,
    0,8,
    1,8,
    2,8,
    3,8,
    4,0,
    4,1,
    4,2,
    4,3,
    4,4,
    4,5,
    4,6,
    4,7,
    4,8,
    0,9,
    1,9,
    2,9,
    3,9,
    4,9
}
local tiles = {}

local nextcheck = false
local settingschanged = true

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
        settings.bartransparency = globals.TRANSPARENCY
    end
    if settings.width == nil then
        settings.width = globals.MEMBER_WIDTH
    end
    if settings.hpheight == nil then
        settings.hpheight = globals.MEMBER_HPHEIGHT
    end
    if settings.mpheight == nil then
        settings.mpheight = globals.MEMBER_MPHEIGHT
    end
    if settings.buffsize == nil then
        settings.buffsize = globals.BUFF_ICONSIZE 
    end
    if settings.autotile == nil then
        settings.autotile = false
    end
    if settings.iconoffset == nil then
        settings.iconoffset = 36
    end
    if settings.overheadiconsize == nil then
        settings.overheadiconsize = 34
    end
    if settings.markertransparency == nil then
        settings.markertransparency = 100
    end
    if settings.namesize == nil then
        settings.namesize = FONT_SIZE.MIDDLE
    end
    if settings.guildsize == nil then
        settings.guildsize = FONT_SIZE.SMALL
    end
end

local raid = {}


local function TestOverlap(a, b)
    local x1 = a.posX
    local y1 = a.posY
    local w = settings.width
    local h = settings.hpheight + settings.mpheight 
    local x2 = b.posX
    local y2 = b.posY

    return x1 < x2 + w and
           x2 < x1 + w and
           y1 < y2 + h and
           y2 < y1 + h
end

local WritePosition
local MoveParent
local Merge
local CheckOnMove

local function ClearTiles()
    for i = 1, #tiles do
        table.remove(tiles)
    end
end

local function CreateTile(parent)
    local tile = {}
    tile.parent = parent
    tile.members = {}
    table.insert(tile.members, parent)
    table.insert(tiles, tile)
    tile.idx = #tiles
    tile.deleted = false
    parent.tileroot = tile
    return tile
end

local function WritePosition(tile, member, index)
    local gtx = (index * 2) - 1
    local frameposx = gridtemplate[gtx]
    local frameposy = gridtemplate[gtx + 1]

    local posX = tile.parent.posX
    local posY = tile.parent.posY
    local offsetX = frameposx * (settings.width + 1)
    local offsetY = frameposy * (settings.hpheight + settings.mpheight + 1)
    member.posX = posX + offsetX
    member.posY = posY + offsetY
    CheckOnMove(member, index)
end

function AddTileMember(tile, frame)
    table.insert(tile.members, frame)
    frame.tileroot = tile
    frame.idx = #tile.members
end

CheckOnMove = function(member, index)
    for i = 1, index - 1 do
        local test = raid[i]
        if test.tileroot ~= member.tileroot then
            if TestOverlap(member, test) then
                if member.tileroot ~= nil then
                    if test.tileroot ~= nil then
                        Merge(test.tileroot, member.tileroot)
                    else
                        AddToTile(member.tileroot, test)
                    end

                elseif test.tileroot ~= nil then
                    AddToTile(test.tileroot, member)
                else
                    tileroot = CreateTile(tile)
                    AddToTile(tileroot, frame)                     
                end
            end
        end
    end
end

local function MoveParent(newparent, oldparent)
    local tile = oldparent.tileroot
    if tile == nil then
        return
    end
    oldparent.posX = newparent.posX
    oldparent.posY = newparent.posY
    for i = 1, #tile.members do
        local member = tile.members[i]
        WritePosition(tile, member, i)
    end
end

AddToTile = function(tile, frame)
    AddTileMember(tile, frame)
    local parent = tile.parent
    WritePosition(tile, frame, frame.idx)
end

Merge = function(to, from)
    if to.idx == from.idx then
        return
    end
    if from.deleted then
        return
    end
    from.deleted = true
    local totalmember = #from.members
    for i = 1, #from.members  do
       
        local member = from.members[i]
        table.insert(to.members, member)
    end

    local basex = to.members[1].posX
    local basey = to.members[1].posY
    local total = basex + basey
    for i = 1, #to.members do
        local member = to.members[i]
        member.idx = i
        member.tileroot = to
        local comp = member.posX + member.posY
        
        if comp < total then
            basex = member.posX
            basey = member.posY
            total = basex + basey
        end
    end
    to.members[1].posX = basex
    to.members[1].posY = basey
    for i = 1, #to.members do
        WritePosition(to, to.members[i], i)
    end
end

local function GetOverlappingTile(frame, index)
    for i = 1, #raid do
        if i ~= index then
            local test = w.party[i]
            if frame ~= test then
                if TestOverlap(frame, test) then
                    return true, test
                end
            end
        end
    end
    return false, nil
end

local function SortFunction(a, b)
    return a.posX + a.posY < b.posX + b.posY
end

local function CreateRaidArray()
    local numberinraid = #raid
    for i= 1, numberinraid do
        table.remove(raid)
    end
    for i = 1, #w.party do
        local member = w.party[i]
        if member:IsVisible() then
            table.insert(raid, member)
        end
    end
    table.sort(raid, SortFunction)
end

local function DoTiling()
    ClearTiles()
    CreateRaidArray()
    -- api.Log:Info(#raid)
    for i = 1, #raid do
        local frame = raid[i]
        local overlapping, overlapframe = GetOverlappingTile(frame, i)
        if overlapping then
            if overlapframe.tileroot ~= nil then
                if frame.tileroot == nil then
                    AddToTile(overlapframe.tileroot, frame)
                else
                    Merge(overlapframe.tileroot, frame.tileroot)
                end
            elseif frame.tileroot ~= nil then
                AddToTile(frame.tileroot, overlapframe)
            else
                local tileroot = CreateTile(overlapframe)
                AddToTile(tileroot, frame)
            end
        end
    end
end

local targetoftargetframe
local targetunitframe
local ondragold
local ondragoldtarget
local ondragoldwatched
local watchtargetframe
local markers = {}
local markersIcon = {}

function DoUpdate()
    if w == nil then
        return
    end

    if w.party == nil then
        return
    end
    for i = 1, 12 do 
        local markerUnitId = api.Unit:GetOverHeadMarkerUnitId(i)
        markers[i] = markerUnitId
        markersIcon[i]:Show(false)
        markersIcon[i]:Lower()
    end
    
    for i = 1, #w.party do
        local party = w.party[i]
        party:Refresh(settings, settingschanged, markers)
        local halfwidth = settings.width / 2
        if party.markerId > 0 then
            
            marker = markersIcon[party.markerId]
            marker:Show(true)
            --api.Log:Info(party.posX)
            marker.posX = party.posX + halfwidth
            marker.posY = party.posY - settings.iconoffset
            marker:Position()
        end
    end
    if settings.autotile then
        DoTiling()
    end
    local targetid = api.Unit:GetUnitId("target")
    for i = 1, #w.party do
        local party = w.party[i]
        party:Position()
        --if is our target, put on top by lowering first
        if targetid == party.targetid then
            party:Lower()
        end
    end
    
    if SettingsFrame:IsVisible() then
        
        SettingsFrame:Refresh(settings, settingschanged, markers)
    end
    settingschanged = false
    -- put watch target second in viewing order
    w.party[51]:Lower()
    -- order the rest front to back. 
    for i = 1, #w.party - 1 do
        local party = w.party[i]
        if targetid ~= party.targetid then
            party:Lower()
        end
    end
    
    local wt = api.Unit:GetUnitId("watchtarget")
    if wt ~= nil then
        watchtargetframe:Show(true)
    end
    return true, nil
end

local function OnUpdate()
    local res, error = pcall(DoUpdate)
    if res == false then
        api.Log:Err(error)
    end
end

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
    local w = api.Interface:CreateWindow("ThiccSettingsWnd", "ThiccBar Settings", 600, 700)
    w:SetTitle("Settings")
    w:AddAnchor("CENTER", "UIParent", 0, 0)
    w:SetCloseOnEscape(true)

    local closeButton = w:CreateChildWidget("button", "closeButton", 0, false)
    closeButton:SetText("Save")
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
    preview.buffWindow:SetLayout(12, settings.buffsize, 0, 2, false)
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
    w.showThiccCheckButton:AddAnchor("RIGHT", showThiccLabel, 100, 0)
    w.showThiccCheckButton:SetButtonStyle("default")
    w.showThiccCheckButton:Show(true)

    tilingLabel = w:CreateChildWidget("label", "tilingLabel", 0, true)
    tilingLabel:AddAnchor("BOTTOMLEFT", showThiccLabel, 0, FONT_SIZE.LARGE + ROWPADDING)
    tilingLabel:SetText("Auto-Tiling (Beta, not recommended):")
    tilingLabel:SetHeight(FONT_SIZE.LARGE)
    tilingLabel.style:SetFontSize(FONT_SIZE.LARGE)
    tilingLabel.style:SetAlign(3)
    ApplyTextColor(tilingLabel, FONT_COLOR.DEFAULT)

    w.tilingLabel = tilingLabel

    w.tilingCheckButton = checkButton.CreateCheckButton("tilingCheckButton", w, nil)
    w.tilingCheckButton:AddAnchor("RIGHT", tilingLabel, 275, 0)
    w.tilingCheckButton:SetButtonStyle("default")
    w.tilingCheckButton:Show(true)

    keyLabel = w:CreateChildWidget("label", "keyLabel", 0, true)
    keyLabel:AddAnchor("BOTTOMLEFT", tilingLabel, 15, FONT_SIZE.LARGE + ROWPADDING)
    keyLabel:SetText("While below key is held, mouse clicks will pass through thicc bars. ")
    keyLabel:SetHeight(FONT_SIZE.MIDDLE)
    keyLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    keyLabel.style:SetAlign(3)
    ApplyTextColor(keyLabel, FONT_COLOR.DEFAULT)

    w.keyLabel = keyLabel

    shiftLabel = w:CreateChildWidget("label", "shiftLabel", 0, true)
    shiftLabel:AddAnchor("BOTTOMLEFT", keyLabel, -15, (FONT_SIZE.LARGE + ROWPADDING))
    shiftLabel:SetText("Shift:")
    shiftLabel:SetHeight(FONT_SIZE.LARGE)
    shiftLabel.style:SetFontSize(FONT_SIZE.LARGE)
    shiftLabel.style:SetAlign(3)
    ApplyTextColor(shiftLabel, FONT_COLOR.DEFAULT)

    w.shiftLabel = shiftLabel

    w.shiftCheckButton = checkButton.CreateCheckButton("shiftCheckButton", w, nil)
    w.shiftCheckButton:AddAnchor("RIGHT", shiftLabel, 100, 0)
    w.shiftCheckButton:SetButtonStyle("default")
    w.shiftCheckButton:Show(true)   

    controlLabel = w:CreateChildWidget("label", "controlLabel", 0, true)
    controlLabel:AddAnchor("BOTTOMLEFT", shiftLabel, 0, FONT_SIZE.LARGE + ROWPADDING)
    controlLabel:SetText("Control:")
    controlLabel:SetHeight(FONT_SIZE.LARGE)
    controlLabel.style:SetFontSize(FONT_SIZE.LARGE)
    controlLabel.style:SetAlign(3)
    ApplyTextColor(controlLabel, FONT_COLOR.DEFAULT)

    w.controlLabel = controlLabel

    w.controlCheckButton = checkButton.CreateCheckButton("controlCheckButton", w, nil)
    w.controlCheckButton:AddAnchor("RIGHT", controlLabel, 100, 0)
    w.controlCheckButton:SetButtonStyle("default")
    w.controlCheckButton:Show(true)

    local transparencyLabel = w:CreateChildWidget("label", "transparencyLabel", 0, true)
    transparencyLabel:SetHeight(FONT_SIZE.LARGE)
    transparencyLabel:SetAutoResize(true)
    transparencyLabel:AddAnchor("BOTTOMLEFT", controlLabel, 0, FONT_SIZE.LARGE + ROWPADDING)
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
    WidthLabel:AddAnchor("TOPLEFT", transparencyScroll, "BOTTOMLEFT", 0, 0)
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
    HPHeightLabel:AddAnchor("TOPLEFT", WidthScroll, "BOTTOMLEFT", 0, 0)
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
    MPHeightLabel:AddAnchor("TOPLEFT", HPHeightScroll, "BOTTOMLEFT", 0, 0)
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
    --
    local NameFontSizeLabel = w:CreateChildWidget("label", "NameFontSizeLabel", 0, true)
    NameFontSizeLabel:SetHeight(FONT_SIZE.LARGE)
    NameFontSizeLabel:SetAutoResize(true)
    NameFontSizeLabel:AddAnchor("TOPLEFT", MPHeightScroll, "BOTTOMLEFT", 0, 0)
    NameFontSizeLabel:SetText("Name Font Size")
    NameFontSizeLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(NameFontSizeLabel, FONT_COLOR.DEFAULT)

    local NameFontSizeScroll = CreateSlider("NameFontSizeScroll", NameFontSizeLabel)
    NameFontSizeScroll:SetStep(1)
    NameFontSizeScroll:SetMinMaxValues(6, 32)
    NameFontSizeScroll:SetInitialValue(settings.namesize, false)
    NameFontSizeScroll:UseWheel()
    NameFontSizeScroll:AddAnchor("TOPLEFT", NameFontSizeLabel, "BOTTOMLEFT", 0, 7)
    NameFontSizeScroll:AddAnchor("RIGHT", w, -15, 0)
    w.NameFontSizeScroll = NameFontSizeScroll

    local NameFontSizeScrollSettingLabel = w:CreateChildWidget("label", "NameFontSizeScrollSettingLabel", 0, true)
    NameFontSizeScrollSettingLabel:SetExtent(30, 20)
    NameFontSizeScrollSettingLabel:AddAnchor("LEFT", NameFontSizeLabel, "RIGHT", 7, 0)
    NameFontSizeScrollSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(NameFontSizeScrollSettingLabel, FONT_COLOR.BLUE)
    local bg = NameFontSizeScrollSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", NameFontSizeScrollSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", NameFontSizeScrollSettingLabel, 5, 6)
    NameFontSizeScrollSettingLabel.bg = bg
    w.NameFontSizeScroll.NameFontSizeScrollSettingLabel = NameFontSizeScrollSettingLabel

    local str = string.format("%d", settings.namesize)
    w.NameFontSizeScroll.NameFontSizeScrollSettingLabel:SetText(tostring(str))

    --
    local GuildFontSizeLabel = w:CreateChildWidget("label", "GuildFontSizeLabel", 0, true)
    GuildFontSizeLabel:SetHeight(FONT_SIZE.LARGE)
    GuildFontSizeLabel:SetAutoResize(true)
    GuildFontSizeLabel:AddAnchor("TOPLEFT", NameFontSizeScroll, "BOTTOMLEFT", 0, 0)
    GuildFontSizeLabel:SetText("Guild Font Size")
    GuildFontSizeLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(GuildFontSizeLabel, FONT_COLOR.DEFAULT)

    local GuildFontSizeScroll = CreateSlider("GuildFontSizeScroll", GuildFontSizeLabel)
    GuildFontSizeScroll:SetStep(1)
    GuildFontSizeScroll:SetMinMaxValues(6, 32)
    GuildFontSizeScroll:SetInitialValue(settings.guildsize, false)
    GuildFontSizeScroll:UseWheel()
    GuildFontSizeScroll:AddAnchor("TOPLEFT", GuildFontSizeLabel, "BOTTOMLEFT", 0, 7)
    GuildFontSizeScroll:AddAnchor("RIGHT", w, -15, 0)
    w.GuildFontSizeScroll = GuildFontSizeScroll

    local GuildFontSizeSettingLabel = w:CreateChildWidget("label", "GuildFontSizeSettingLabel", 0, true)
    GuildFontSizeSettingLabel:SetExtent(30, 20)
    GuildFontSizeSettingLabel:AddAnchor("LEFT", GuildFontSizeLabel, "RIGHT", 7, 0)
    GuildFontSizeSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(GuildFontSizeSettingLabel, FONT_COLOR.BLUE)
    local bg = GuildFontSizeSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", GuildFontSizeSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", GuildFontSizeSettingLabel, 5, 6)
    GuildFontSizeSettingLabel.bg = bg
    w.GuildFontSizeScroll.GuildFontSizeSettingLabel = GuildFontSizeSettingLabel

    local str = string.format("%d", settings.guildsize)
    w.GuildFontSizeScroll.GuildFontSizeSettingLabel:SetText(tostring(str))

    --
    local BuffSizeLabel = w:CreateChildWidget("label", "BuffSizeLabel", 0, true)
    BuffSizeLabel:SetHeight(FONT_SIZE.LARGE)
    BuffSizeLabel:SetAutoResize(true)
    BuffSizeLabel:AddAnchor("TOPLEFT", GuildFontSizeScroll, "BOTTOMLEFT", 0, 0)
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

    local OverheadMarkerSizeLabel = w:CreateChildWidget("label", "OverheadMarkerSizeLabel", 0, true)
    OverheadMarkerSizeLabel:SetHeight(FONT_SIZE.LARGE)
    OverheadMarkerSizeLabel:SetAutoResize(true)
    OverheadMarkerSizeLabel:AddAnchor("TOPLEFT", BuffSizeScroll, "BOTTOMLEFT", 0, 0)
    OverheadMarkerSizeLabel:SetText("Overhead Marker Size")
    OverheadMarkerSizeLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(OverheadMarkerSizeLabel, FONT_COLOR.DEFAULT)

    local OverheadMarkerSizeScroll = CreateSlider("BuffSizeScroll", OverheadMarkerSizeLabel)
    OverheadMarkerSizeScroll:SetStep(1)
    OverheadMarkerSizeScroll:SetMinMaxValues(1, 100)
    OverheadMarkerSizeScroll:SetInitialValue(settings.overheadiconsize, false)
    OverheadMarkerSizeScroll:UseWheel()
    OverheadMarkerSizeScroll:AddAnchor("TOPLEFT", OverheadMarkerSizeLabel, "BOTTOMLEFT", 0, 7)
    OverheadMarkerSizeScroll:AddAnchor("RIGHT", w, -15, 0)
    w.OverheadMarkerSizeScroll = OverheadMarkerSizeScroll

    local OverheadMarkerSizeSettingLabel = w:CreateChildWidget("label", "OverheadMarkerSizeSettingLabel", 0, true)
    OverheadMarkerSizeSettingLabel:SetExtent(30, 20)
    OverheadMarkerSizeSettingLabel:AddAnchor("LEFT", OverheadMarkerSizeLabel, "RIGHT", 7, 0)
    OverheadMarkerSizeSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(OverheadMarkerSizeSettingLabel, FONT_COLOR.BLUE)
    local bg = OverheadMarkerSizeSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", OverheadMarkerSizeSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", OverheadMarkerSizeSettingLabel, 5, 6)
    OverheadMarkerSizeSettingLabel.bg = bg
    w.OverheadMarkerSizeScroll.OverheadMarkerSizeSettingLabel = OverheadMarkerSizeSettingLabel

    local str = string.format("%d", settings.overheadiconsize)
    w.OverheadMarkerSizeScroll.OverheadMarkerSizeSettingLabel:SetText(tostring(str))


    local OverheadMarkerOffsetLabel = w:CreateChildWidget("label", "OverheadMarkerOffsetLabel", 0, true)
    OverheadMarkerOffsetLabel:SetHeight(FONT_SIZE.LARGE)
    OverheadMarkerOffsetLabel:SetAutoResize(true)
    OverheadMarkerOffsetLabel:AddAnchor("TOPLEFT", OverheadMarkerSizeScroll, "BOTTOMLEFT", 0, 0)
    OverheadMarkerOffsetLabel:SetText("Overhead Marker Offset")
    OverheadMarkerOffsetLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(OverheadMarkerOffsetLabel, FONT_COLOR.DEFAULT)

    local OverheadMarkerOffsetScroll = CreateSlider("OverheadMarkerOffsetScroll", OverheadMarkerOffsetLabel)
    OverheadMarkerOffsetScroll:SetStep(1)
    OverheadMarkerOffsetScroll:SetMinMaxValues(-50, 150)
    OverheadMarkerOffsetScroll:SetInitialValue(settings.iconoffset, false)
    OverheadMarkerOffsetScroll:UseWheel()
    OverheadMarkerOffsetScroll:AddAnchor("TOPLEFT", OverheadMarkerOffsetLabel, "BOTTOMLEFT", 0, 7)
    OverheadMarkerOffsetScroll:AddAnchor("RIGHT", w, -15, 0)
    w.OverheadMarkerOffsetScroll = OverheadMarkerOffsetScroll

    local OverheadMarkerOffsetSettingLabel = w:CreateChildWidget("label", "OverheadMarkerOffsetSettingLabel", 0, true)
    OverheadMarkerOffsetSettingLabel:SetExtent(30, 20)
    OverheadMarkerOffsetSettingLabel:AddAnchor("LEFT", OverheadMarkerOffsetLabel, "RIGHT", 7, 0)
    OverheadMarkerOffsetSettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(OverheadMarkerOffsetSettingLabel, FONT_COLOR.BLUE)
    local bg = OverheadMarkerOffsetSettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", OverheadMarkerOffsetSettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", OverheadMarkerOffsetSettingLabel, 5, 6)
    OverheadMarkerOffsetSettingLabel.bg = bg
    w.OverheadMarkerOffsetScroll.OverheadMarkerOffsetSettingLabel = OverheadMarkerOffsetSettingLabel

    local str = string.format("%d", settings.iconoffset)
    w.OverheadMarkerOffsetScroll.OverheadMarkerOffsetSettingLabel:SetText(tostring(str))


    local OverheadMarkerTransparencyLabel = w:CreateChildWidget("label", "OverheadMarkerTransparencyLabel", 0, true)
    OverheadMarkerTransparencyLabel:SetHeight(FONT_SIZE.LARGE)
    OverheadMarkerTransparencyLabel:SetAutoResize(true)
    OverheadMarkerTransparencyLabel:AddAnchor("TOPLEFT", OverheadMarkerOffsetScroll, "BOTTOMLEFT", 0, 0)
    OverheadMarkerTransparencyLabel:SetText("Overhead Marker Transparency")
    OverheadMarkerTransparencyLabel.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(OverheadMarkerTransparencyLabel, FONT_COLOR.DEFAULT)

    local OverheadMarkerTransparencyScroll = CreateSlider("OverheadMarkerTransparencyScroll", OverheadMarkerTransparencyLabel)
    OverheadMarkerTransparencyScroll:SetStep(1)
    OverheadMarkerTransparencyScroll:SetMinMaxValues(0, 100)
    OverheadMarkerTransparencyScroll:SetInitialValue(settings.markertransparency, false)
    OverheadMarkerTransparencyScroll:UseWheel()
    OverheadMarkerTransparencyScroll:AddAnchor("TOPLEFT", OverheadMarkerTransparencyLabel, "BOTTOMLEFT", 0, 7)
    OverheadMarkerTransparencyScroll:AddAnchor("RIGHT", w, -15, 0)
    w.OverheadMarkerTransparencyScroll = OverheadMarkerTransparencyScroll

    local OverheadMarkerTransparencySettingLabel = w:CreateChildWidget("label", "OverheadMarkerTransparencySettingLabel", 0, true)
    OverheadMarkerTransparencySettingLabel:SetExtent(30, 20)
    OverheadMarkerTransparencySettingLabel:AddAnchor("LEFT", OverheadMarkerTransparencyLabel, "RIGHT", 7, 0)
    OverheadMarkerTransparencySettingLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(OverheadMarkerTransparencySettingLabel, FONT_COLOR.BLUE)
    local bg = OverheadMarkerTransparencySettingLabel:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    bg:SetCoords(0, 0, 190, 29)
    bg:AddAnchor("TOPLEFT", OverheadMarkerTransparencySettingLabel, -3, -6)
    bg:AddAnchor("BOTTOMRIGHT", OverheadMarkerTransparencySettingLabel, 5, 6)
    OverheadMarkerTransparencySettingLabel.bg = bg
    w.OverheadMarkerTransparencyScroll.OverheadMarkerTransparencySettingLabel = OverheadMarkerTransparencySettingLabel

    local str = string.format("%d", settings.markertransparency)
    w.OverheadMarkerTransparencyScroll.OverheadMarkerTransparencySettingLabel:SetText(tostring(str))

    function w:Refresh(settings, settingschanged, markers)
        preview:Refresh(settings, settingschanged, markers)
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

    function w:tilingOnCheckChanged()
         local checked = w.tilingCheckButton:GetChecked()
         settings.autotile = checked
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

    function w.OverheadMarkerSizeScroll:OnSliderChanged(arg)
        local value = w.OverheadMarkerSizeScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.OverheadMarkerSizeScroll.OverheadMarkerSizeSettingLabel:SetText(tostring(str))
        settings.overheadiconsize = value
        local multiple = settings.overheadiconsize / MARKERSCALER
        for i = 1,12 do
            markersIcon[i].marker:SetExtent(60 * multiple, 75 * multiple)
        end
        settingschanged = true
    end

    function w.OverheadMarkerOffsetScroll:OnSliderChanged(arg)
        local value = w.OverheadMarkerOffsetScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.OverheadMarkerOffsetScroll.OverheadMarkerOffsetSettingLabel:SetText(tostring(str))
        settings.iconoffset = value
        settingschanged = true
    end

    function w.OverheadMarkerTransparencyScroll:OnSliderChanged(arg)
        local value = w.OverheadMarkerTransparencyScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.OverheadMarkerTransparencyScroll.OverheadMarkerTransparencySettingLabel:SetText(tostring(str))
        settings.markertransparency = value
        for i = 1,12 do
            markersIcon[i]:SetAlpha(settings.markertransparency / 100)
        end
        settingschanged = true
    end
    --

    function w.NameFontSizeScroll:OnSliderChanged(arg)
        
        local value = w.NameFontSizeScroll:GetValue() or 0
       
        local str = string.format("%d", value)
        w.NameFontSizeScroll.NameFontSizeScrollSettingLabel:SetText(tostring(str))
        settings.namesize = value
        settingschanged = true
    end
    function w.GuildFontSizeScroll:OnSliderChanged(arg)
        local value = w.GuildFontSizeScroll:GetValue() or 0
        local str = string.format("%d", value)
        w.GuildFontSizeScroll.GuildFontSizeSettingLabel:SetText(tostring(str))
        settings.guildsize = value
        settingschanged = true
    end

    w.transparencyScroll:SetHandler("OnSliderChanged", w.transparencyScroll.OnSliderChanged)
    w.WidthScroll:SetHandler("OnSliderChanged", w.WidthScroll.OnSliderChanged)
    w.HPHeightScroll:SetHandler("OnSliderChanged", w.HPHeightScroll.OnSliderChanged)
    w.MPHeightScroll:SetHandler("OnSliderChanged", w.MPHeightScroll.OnSliderChanged)
    w.BuffSizeScroll:SetHandler("OnSliderChanged", w.BuffSizeScroll.OnSliderChanged)
    w.OverheadMarkerSizeScroll:SetHandler("OnSliderChanged", w.OverheadMarkerSizeScroll.OnSliderChanged)
    w.OverheadMarkerOffsetScroll:SetHandler("OnSliderChanged", w.OverheadMarkerOffsetScroll.OnSliderChanged)
    w.OverheadMarkerTransparencyScroll:SetHandler("OnSliderChanged", w.OverheadMarkerTransparencyScroll.OnSliderChanged)
    w.NameFontSizeScroll:SetHandler("OnSliderChanged", w.NameFontSizeScroll.OnSliderChanged)
    w.GuildFontSizeScroll:SetHandler("OnSliderChanged", w.GuildFontSizeScroll.OnSliderChanged)

    w.showThiccCheckButton:SetChecked(settings.showbars)
    w.shiftCheckButton:SetChecked(settings.shiftenabled)
    w.controlCheckButton:SetChecked(settings.ctrlenabled)
    w.tilingCheckButton:SetChecked(settings.autotile)

    w.showThiccCheckButton:SetHandler("OnCheckChanged", w.ThiccOnCheckChanged)
    w.shiftCheckButton:SetHandler("OnCheckChanged", w.ShiftOnCheckChanged)
    w.controlCheckButton:SetHandler("OnCheckChanged", w.ControlOnCheckChanged)
    w.tilingCheckButton:SetHandler("OnCheckChanged", w.tilingOnCheckChanged)
    w.closeButton:SetHandler("OnClick", w.OnClose)
    return w
end

local function ShowSettings()
	SettingsFrame:Show(true)
end
local function OnEvent(window, evt, arg1)
   -- if arg1 ~= nil then
        --api.File:Write("args.txt", arg1)
   --     api.Log:Info(tostring(arg1))
   -- end
end

local SetMarkerTexture = function(markerTexture, markerIndex)

    markerTexture:SetCoords(markerCoords[markerIndex][1], markerCoords[markerIndex][2], markerCoords[markerIndex][3], markerCoords[markerIndex][4])
end

local function Load() 

    membermethods = require("thiccbars//member")
    CreateRaidMember = membermethods.CreateRaidMember
    SetViewOfRaidMember = membermethods.SetViewOfRaidMember
    settings = LoadSettings()

    CheckSettings()
    local multiple = settings.overheadiconsize / MARKERSCALER
    for i = 1, 12 do
        table.insert(markers, "0x00")
        local wIcon = api.Interface:CreateEmptyWindow("overheadMarker" .. i, "UIParent")
        marker = wIcon:CreateImageDrawable(TEXTURE_PATH.OVERHEAD_MARK, "overlay")
        marker:SetVisible(true)
        marker:SetExtent(64 * multiple, 75 * multiple)
        SetMarkerTexture(marker, i)
        marker:AddAnchor("CENTER", wIcon, 0, 0)
        wIcon.marker = marker
        wIcon.posX = 0
        wIcon.posY = 0
        wIcon:SetAlpha(settings.markertransparency / 100)
        function wIcon:Position()

            self:RemoveAllAnchors() -- should remove anchors before moving one
            self:AddAnchor("TOPLEFT", "UIParent", wIcon.posX, wIcon.posY)
        end
        table.insert(markersIcon, wIcon)
    end
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

    w:SetHandler("OnEvent", OnEvent)
    --w:RegisterEvent("MOUSE_DOWN")

    --create raid member tags   
    local party = {}
    for i = 1, 50 do
        party[i] = CreateRaidMember(nil, string.format("team%d", i), "memberWindow", i, ChangeTarget, settings)
    end
    party[51] = CreateRaidMember(nil, "watchtarget", "memberWindow", 51, ChangeTarget, settings)
    w.party = party

    SaveSettings()
end

local function Unload()
    if targetoftargetframe ~= nil then
        targetoftargetframe.eventWindow.OnDragStart = ondragold
        event:SetHandler("OnDragStart", event.OnDragStart)
    end
    if watchtargetframe ~= nil then
        watchtargetframe.eventWindow.OnDragStart = ondragoldwatched
        eventwatched:SetHandler("OnDragStart", eventwatched.OnDragStart)
    end
    if w ~= nil then
        w:ReleaseHandler("OnEvent")
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
    for i = 1,12 do

        markersIcon[i]:Show(false)
        markersIcon[i] = nil
    end

    if raidmanager.thiccButton ~= nil then
        raidmanager.thiccButton:Show(false)
        raidmanager.thiccButton = nil
    end
end

api.On("UPDATE", OnUpdate)

thicc_addon.OnLoad = Load
thicc_addon.OnUnload = Unload

return thicc_addon