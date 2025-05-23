UOT_SLIDER = "slider"

txColor = {
    ConvertColor(153),
    ConvertColor(132),
    ConvertColor(86),
    1
  }
local SetViewOfSlider = function(id, parent)
  local slider = parent:CreateChildWidgetByType(24, id, 0, true)
  slider:SetHeight(26)
  local bg = slider:CreateImageDrawable(TEXTURE_PATH.SCROLL, "background")
  bg:SetCoords(0, 0, 256, 9)

  bg:AddAnchor("LEFT", slider, 3, 0)
  bg:AddAnchor("RIGHT", slider, -3, 0)
  bg:SetHeight(6)

  slider.bg = bg
  slider.bgColor = {
    ConvertColor(153),
    ConvertColor(132),
    ConvertColor(86),
    1
  }
  slider.bg:SetColor(slider.bgColor[1], slider.bgColor[2], slider.bgColor[3], slider.bgColor[4])
  local thumb = slider:CreateChildWidget("button", "thumb", 0, true)
  thumb:Show(true)
  ApplyButtonSkin(thumb, BUTTON_BASIC.SLIDER_HORIZONTAL_THUMB)
  --thumb:RegisterForDrag("LeftButton")
  --thumb:RegisterForClicks("LeftButton", false)
  slider:SetThumbButtonWidget(thumb)
  slider:SetFixedThumb(true)
  slider:SetMinThumbLength(17)
  thumb:SetHeight(26)
  slider:SetOrientation(1)
  return slider
end
function CreateSlider(id, parent)
  local slider = SetViewOfSlider(id, parent)
  slider.useWheel = false
  function slider:SetStep(value)
    self:SetValueStep(value)
    self:SetPageStep(value)
  end
  function slider:SetInitialValue(initialValue)
    self:SetValue(initialValue, false)
  end
  function slider:SetBgColor(colorTable)
    slider.bgColor = colorTable
    self.bg:SetColor(slider.bgColor[1], slider.bgColor[2], slider.bgColor[3], slider.bgColor[4])
  end
  function slider:SetEnable(enable)
    self.thumb:Enable(enable)
    if slider.label then
      for i = 1, #slider.label do
        slider.label[i]:Enable(enable)
      end
    end
    if enable then
      self.bg:SetColor(slider.bgColor[1], slider.bgColor[2], slider.bgColor[3], slider.bgColor[4])
    else
      self.bg:SetColor(0.5, 0.5, 0.5, 1)
    end
  end
  function slider:UseWheel()
    self.useWheel = true
    local OnWheelUp = function(self)
      if not self:IsEnabled() then
        return
      end
      if not self.useWheel then
        return
      end
      self:Up(1)
    end
    slider:SetHandler("OnWheelUp", OnWheelUp)
    local OnWheelDown = function(self)
      if not self:IsEnabled() then
        return
      end
      if not self.useWheel then
        return
      end
      self:Down(1)
    end
    slider:SetHandler("OnWheelDown", OnWheelDown)
  end
  return slider
end

return CreateSlider