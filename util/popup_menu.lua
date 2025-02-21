local buttonWidth = 105
local buttonHeight = 20
local frameMargin = 10
function CreateTooltipDrawable(widget)
  local bg = widget:CreateNinePartDrawable(TEXTURE_PATH.HUD, "background")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  bg:SetCoords(733, 169, 14, 15)
  bg:SetInset(7, 7, 6, 7)
  widget.bg = bg
end

function SetButtonFontOneColor(button, color)
  button:SetTextColor(color[1], color[2], color[3], color[4])
  button:SetPushedTextColor(color[1], color[2], color[3], color[4])
  button:SetHighlightTextColor(color[1], color[2], color[3], color[4])
  button:SetDisabledTextColor(color[1], color[2], color[3], color[4])
end

function SetButtonFontColor(button, color)
  local n = color.normal
  local h = color.highlight
  local p = color.pushed
  local d = color.disabled
  button:SetTextColor(n[1], n[2], n[3], n[4])
  button:SetHighlightTextColor(h[1], h[2], h[3], h[4])
  button:SetPushedTextColor(p[1], p[2], p[3], p[4])
  button:SetDisabledTextColor(d[1], d[2], d[3], d[4])
end

function SetButtonFontColorByKey(button, key, useSameColor)
  if useSameColor then
    local color = F_COLOR.GetColor(key)
    button:SetTextColor(color[1], color[2], color[3], color[4])
    button:SetHighlightTextColor(color[1], color[2], color[3], color[4])
    button:SetPushedTextColor(color[1], color[2], color[3], color[4])
    button:SetDisabledTextColor(color[1], color[2], color[3], color[4])
  else
    local color = {
      normal = F_COLOR.GetColor(string.format("%s_df", key)),
      highlight = F_COLOR.GetColor(string.format("%s_ov", key)),
      pushed = F_COLOR.GetColor(string.format("%s_on", key)),
      disabled = F_COLOR.GetColor(string.format("%s_dis", key))
    }
    local n = color.normal
    local h = color.highlight
    local p = color.pushed
    local d = color.disabled
    button:SetTextColor(n[1], n[2], n[3], n[4])
    button:SetHighlightTextColor(h[1], h[2], h[3], h[4])
    button:SetPushedTextColor(p[1], p[2], p[3], p[4])
    button:SetDisabledTextColor(d[1], d[2], d[3], d[4])
  end
end

local function SetViewOfPopupMenuFrame(id, parent)
  local w = api.Interface:CreateEmptyWindow(id, parent)
  w:SetTitleInset(0, frameMargin, 0, 0)
  CreateTooltipDrawable(w)
  w.buttons = {}
  function w:Resize()
    local count = #self.buttons
    local width = 0
    for i = 1, count do
      local btn = self.buttons[i]
      local w = btn:GetWidth()
      if width < w then
        width = w
      end
      btn:SetAutoResize(false)
    end
    for i = 1, count do
      self.buttons[i]:SetExtent(width, buttonHeight)
    end
    local height = frameMargin * 2 + count * buttonHeight
    width = frameMargin * 2 + width
    self:SetExtent(width, height)
  end
  function w:AddButton(info)
    local btnColor = {
      normal = {
        ConvertColor(209),
        ConvertColor(192),
        ConvertColor(172),
        1
      },
      highlight = {
        ConvertColor(233),
        ConvertColor(197),
        ConvertColor(155),
        1
      },
      pushed = {
        ConvertColor(200),
        ConvertColor(168),
        ConvertColor(129),
        1
      },
      disabled = {
        ConvertColor(120),
        ConvertColor(120),
        ConvertColor(120),
        1
      }
    }
    local index = #self.buttons + 1
    local btn = self:CreateChildWidget("button", "button", index, true)
    SetButtonFontColor(btn, btnColor)
    if index == 1 then
      btn:AddAnchor("TOPLEFT", w, frameMargin, frameMargin)
    else
      btn:AddAnchor("TOPLEFT", self.buttons[index - 1], "BOTTOMLEFT", 0, 0)
    end
    local insetLeft = 5
    local insetRight = 5
    if info.text_inset ~= nil then
      insetLeft = insetLeft + info.text_inset.left
      insetRight = insetRight + info.text_inset.right
    end
    if info.text_color ~= nil then
      local valType = type(info.text_color)
      if valType == "string" then
        local color = Hex2Dec(info.text_color)
        SetButtonFontOneColor(btn, {
          color[1],
          color[2],
          color[3],
          color[4]
        })
      elseif valType == "table" then
        SetButtonFontOneColor(btn, {
          info.text_color[1],
          info.text_color[2],
          info.text_color[3],
          info.text_color[4]
        })
      end
    end
    --if info.radio ~= nil then
    --  local firstOffset = {}
    --  firstOffset.x = 0
    --  firstOffset.y = 3
    --  local radioBtn = CreateRadioButton(btn:GetId() .. ".checkBoxes", btn, 1, nil, firstOffset, nil, "tooltip")
    --  radioBtn:SetTextButtonStyle("soft_brown")
    --  radioBtn[1]:SetChecked(info.radio)
    --  btn.radioBtn = radioBtn[1]
    --  insetLeft = insetLeft + 16
    --end
    --if info.check ~= nil then
    --  local check = btn:CreateImageDrawable(TEXTURE_PATH.OVERHEAD_MARK, "background")
    --  check:AddAnchor("LEFT", btn, 0, 0)
    --  check:SetExtent(17, 13)
    --  if info.check.value then
    --    check:SetCoords(239, 225, 17, 13)
    --  else
    --    check:SetCoords(239, 238, 17, 13)
    --  end
    --  check:SetVisible(info.check.isShow)
    --  insetLeft = insetLeft + 20
    --end
    if info.image ~= nil then
      local image = btn:CreateImageDrawable(info.image.path, "background")
      if info.anchorInfo ~= nil then
        image:AddAnchor(info.anchorInfo.myAnchor, btn, info.anchorInfo.targetAnchor, info.anchorInfo.anchorX, info.anchorInfo.anchorY)
      else
        image:AddAnchor("RIGHT", btn, -insetRight, 0)
        insetRight = insetRight + info.image.width + 3
      end
      image:SetExtent(info.image.width, info.image.height)
      image:SetCoords(info.image.x, info.image.y, info.image.width, info.image.height)
    end
    btn:SetInset(insetLeft, 0, insetRight, 0)
    btn:SetAutoResize(true)
    btn:SetText(info.text)
    btn.style:SetShadow(false)
    btn.style:SetAlign(ALIGN.LEFT)
    self.buttons[index] = btn
    return btn
  end
  w:EnableHidingIsRemove(true)
  w:SetCloseOnEscape(true)
  return w
end
local popupMenu
function GetDefaultPopupInfoTable()
  local infoTable = {}
  infoTable.target = nil
  infoTable.hideProcedure = nil
  infoTable.infos = {}
  function infoTable:AddInfo(text, proc, arg, hasChild, tooltipData)
    local index = #self.infos + 1
    self.infos[index] = {}
    self.infos[index].text = text or ""
    self.infos[index].proc = proc or nil
    self.infos[index].arg = arg
    self.infos[index].hasChild = hasChild or false
    self.infos[index].tooltipData = tooltipData or nil
  end
  function infoTable:AddLayoutInfo(text_inset)
    local index = #self.infos
    self.infos[index].text_inset = text_inset or nil
  end
  function infoTable:AddTextButtonColor(text_color)
    local index = #self.infos
    self.infos[index].text_color = text_color
  end
  function infoTable:AddRadioBtn(isChecked)
    local index = #self.infos
    self.infos[index].radio = isChecked
  end
  function infoTable:AddCheckBtn(isShow, isHighlight)
    local index = #self.infos
    self.infos[index].check = {isShow = isShow, value = isHighlight}
  end
  function infoTable:AddImage(image)
    local index = #self.infos
    self.infos[index].image = image
  end
  function infoTable:AddImageAnchorInfo(anchorInfo)
    local index = #self.infos
    self.infos[index].anchorInfo = anchorInfo
  end
  function infoTable:AddDisableStatus(disable)
    local index = #self.infos
    self.infos[index].disable = disable
  end
  function infoTable:GetPopupInfoTableCount()
    return #self.infos
  end
  return infoTable
end
function HidePopUpMenu(parent)
  if popupMenu == nil then
    return
  end
  if parent ~= nil then
    if parent:GetAttachedWidget() == popupMenu then
      popupMenu:Show(false)
    end
  else
    popupMenu:Show(false)
  end
end
local SafeCallFunc = function(func, ...)
  if func ~= nil then
    func(...)
  end
end
function ShowPopUpMenu(id, stickTo, infoTable, isChild, myAnchor, targetAnchor, offsetX, offsetY)
  if infoTable:GetPopupInfoTableCount() == 0 then
    return
  end
  if isChild == nil then
    isChild = false
  end
  local parent = "UIParent"
  if isChild then
    parent = stickTo
  end
  local popup = SetViewOfPopupMenuFrame(id, parent)
  if isChild then
    parent.childPopup = popup
  end
  function popup:ClearChild()
    for i = 1, #self.buttons do
      local btn = self.buttons[i]
      if btn.childPopup ~= nil then
        btn.childPopup:Show(false)
        btn.childPopup = nil
      end
    end
  end
  for i = 1, #infoTable.infos do
    local info = infoTable.infos[i]
    local btn = popup:AddButton(info)
    function btn:OnClick()
      if info.proc ~= nil then
        if info.hasChild then
          popup:ClearChild()
          info.proc(infoTable.target, info.arg, btn)
        else
          info.proc(infoTable.target, info.arg)
          HidePopUpMenu()
          SafeCallFunc(infoTable.hideProcedure, self:GetParent())
        end
      end
    end
    btn:SetHandler("OnClick", btn.OnClick)
    function btn:OnEnter()
      popup:ClearChild()
      if info.proc ~= nil then
        if info.hasChild and info.disable ~= true then
          info.proc(infoTable.target, info.arg, btn)
        elseif info.hasChild == false and info.tooltipData ~= nil then
          --SetTargetAnchorTooltip(info.tooltipData.text, info.tooltipData.myAnchor, self, info.tooltipData.targetAnchor, info.tooltipData.offsetX, info.tooltipData.offsetY)
        end
      end
    end
    btn:SetHandler("OnEnter", btn.OnEnter)
    function btn:OnLeave()
      if info.hasChild == false and info.tooltipData ~= nil then
        HideTooltip()
      end
    end
    btn:SetHandler("OnLeave", btn.OnLeave)
    if btn.radioBtn ~= nil then
      btn.radioBtn:SetHandler("OnClick", btn.OnClick)
    end
    if info.disable == true then
      btn:Enable(false)
    end
  end
  popup:Resize()
  function popup:AnchorToMousePosition()
    local mouseX, mouseY = api.Input:GetMousePos()
    local screenWidth = 2042 --UIParent:GetScreenWidth()
    local screenHeight = 1124 -- UIParent:GetScreenHeight()
    local width, height = self:GetEffectiveExtent()
    local vertOver = screenHeight <= mouseY + height
    local horzOver = screenWidth <= mouseX + width
    --mouseX = F_LAYOUT.CalcDontApplyUIScale(mouseX)
    --mouseY = F_LAYOUT.CalcDontApplyUIScale(mouseY)
    if vertOver and horzOver then
      self:AddAnchor("BOTTOMRIGHT", "UIParent", "TOPLEFT", mouseX, mouseY)
    elseif horzOver then
      self:AddAnchor("TOPRIGHT", "UIParent", "TOPLEFT", mouseX, mouseY)
    elseif vertOver then
      self:AddAnchor("BOTTOMLEFT", "UIParent", "TOPLEFT", mouseX, mouseY)
    else
      self:AddAnchor("TOPLEFT", "UIParent", mouseX, mouseY)
    end
  end
  popup:RemoveAllAnchors()
  if not isChild then
    if popupMenu ~= nil then
      HidePopUpMenu()
    end
    popupMenu = popup
    stickTo:AttachWidget(popup)
    function popupMenu:OnHide()
      stickTo:DetachWidget()
      popupMenu = nil
    end
    popupMenu:SetHandler("OnHide", popup.OnHide)
    local events = {
      MOUSE_DOWN = function(widgetId)
        if popupMenu:IsVisible() == true and popupMenu:IsDescendantWidget(widgetId) == false then
          HidePopUpMenu()
          SafeCallFunc(infoTable.hideProcedure, popupMenu)
        end
      end
    }
    popupMenu:SetHandler("OnEvent", function(this, event, ...)
      events[event](...)
    end)
    popupMenu:RegisterEvent("MOUSE_DOWN")
  end
  popup:Show(true)
  if myAnchor == nil then
    popup:AnchorToMousePosition()
  else
    popup:AddAnchor(myAnchor, stickTo, targetAnchor, offsetX, offsetY)
  end
end



popupFuncs = {}
popupFuncs.SetViewOfPopupMenuFrame = SetViewOfPopupMenuFrame
popupFuncs.GetDefaultPopupInfoTable = GetDefaultPopupInfoTable
popupFuncs.HidePopUpMenu = HidePopUpMenu
popupFuncs.ShowPopUpMenu = ShowPopUpMenu
popupFuncs.CreateTooltipDrawable = CreateTooltipDrawable

return popupFuncs