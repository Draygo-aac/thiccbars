local MAX_RAID_PARTY_MEMBERS = 5
local UNIT_VISIBLE_MAX_DISTANCE = 130
local LIGHT_PURPLE = {
  0.737,
  0.075,
  1
  }
local LIGHT_PURPLE_TARGET = {
  0.541,
  0,
  0.769
  }
local markerCoords = {
    {
    384,
    48,
    24,
    24
    },
    {
    408,
    48,
    24,
    24
    },
    {
    432,
    48,
    24,
    24
    },
    {
    456,
    48,
    24,
    24
    },
    {
    480,
    48,
    24,
    24
    },
    {
    312,
    72,
    24,
    24
    },
    {
    336,
    72,
    24,
    24
    },
    {
    360,
    72,
    24,
    24
    },
    {
    384,
    72,
    24,
    24
    },
    {
    408,
    72,
    24,
    24
    },
    {
    432,
    72,
    24,
    24
    },
    {
    456,
    72,
    24,
    24
    }
}
SetViewOfRaidMember = require("thiccbars//member_view")
function CreateRaidMember(parent, name , ownId, index, ChangeTarget, settings)
  local w = SetViewOfRaidMember(name, ownId, index, parent)
  w:Show(false)
  
  w.memberIndex = index
  w.partyIndex = math.floor((index - 1) / 5) + 1
  w.target = name
  w.isPet = name == "playerpet1"
  w.bypassTeamCheck = name == "player" or name == "watchtarget" or  w.isPet
  w.settings = settings
  w.notplayer = name ~= "player"

  w:SetSimpleMode(settings)
  function w:SetName(name)
    if name ~= nil and w.state.name ~= name then
      w.nameLabel:SetText(name)
      w.state.name = name
    end
  end
  function w:SetGuild(name)
    if name ~= nil then
      if w.state.gname ~= name then
        w.guildLabel:Show(true)
        w.guildLabel:SetText(name)
      end
    else
        w.guildLabel:Show(false)
    end
  end
  function w:SetMaxHp(maxHp)
    if maxHp ~= nil then
      w.hpBar.statusBar:SetMinMaxValues(0, maxHp or 0)
      w.state.mhp = maxHp or 0
    end
  end
  function w:SetHp(hp)
    if hp ~= nil then
      w.hpBar.statusBar:SetValue(hp or 0)
      w.state.hp = hp or 0
    end
  end
  function w:SetMaxMp(maxMp)
    if maxMp ~= nil then
      w.mpBar.statusBar:SetMinMaxValues(0, maxMp or 0)
      w.state.mmp = maxMp or 0
    end
  end
  function w:SetMp(mp)
    if mp ~= nil then
      w.mpBar.statusBar:SetValue(mp or 0)
      w.state.mp = mp or 0
    end
  end
  function w:UpdateName()
    local unitid = api.Unit:GetUnitId(w.target)
    local myId = api.Unit:GetUnitId("target")
    local name = api.Unit:GetUnitNameById(unitid)
    local myName = api.Unit:GetUnitNameById(myId)
    local info = api.Unit:GetUnitInfoById(unitid)

    --api.Log:Info(info)
    if myId == unitid then
      self.selected = true
      self.selectedIcon:Show(true)
    else
      self.selected = false

      self.selectedIcon:Show(false)
    end
    self:SetName(name)
    if info.expeditionName ~= nil then
        self:SetGuild(info.expeditionName)
    else
        self:SetGuild(nil)
    end
  end

  function w:UpdateMaxHp()
    local maxHp = api.Unit:UnitMaxHealth(w.target)
    if self.state.mhp == maxHp then
      return
    end
    self:SetMaxHp(maxHp)
  end
  function w:UpdateHp()
    local hp = api.Unit:UnitHealth(w.target)
    if self.state.hp == hp then
      return
    end
    self:SetHp(hp)
    self.state.dead = hp == 0
  end
  function w:UpdateMaxMp()
    local maxMp = api.Unit:UnitMaxMana(w.target)
    if self.state.mmp == maxMp then
      return
    end
    self:SetMaxMp(maxMp)
  end
  function w:UpdateMp()
    local mp = api.Unit:UnitMana(w.target)
    if self.state.mp == mp then
      return
    end
    self:SetMp(mp)
  end
  function w:GetRGB(carray)
    return ConvertColor(carray[1]), ConvertColor(carray[2]), ConvertColor(carray[3]), ConvertColor(carray[4])
  end
  function w:SetColor(key)
    if self.state.currentkey == key and self.state.selectedstate == self.selected then
      return
    end

    local color = self.settings.barcolors[key]
    local textcolor = self.settings.textcolors[key]
    local selectedcolor = self.settings.selectedtextcolors[key]


    self.hpBar.statusBar:SetBarColor(self:GetRGB(color))
    if self.selected then
      self.nameLabel.style:SetColor(self:GetRGB(selectedcolor))
      self.guildLabel.style:SetColor(self:GetRGB(selectedcolor))
    else
      self.nameLabel.style:SetColor(self:GetRGB(textcolor))
      self.guildLabel.style:SetColor(self:GetRGB(textcolor))
    end
    self.state.currentkey = key
    self.state.selected = self.selected
  end


  function w:UpdateBuff(dead)
    w.buffWindow:BuffUpdate(w.target, dead)
    self.state.pvpDebuff = w.buffWindow.pvpDebuff
    self.state.disabled = w.buffWindow.disabled
  end

  function w:UpdateRoleOfHpBarTexture()
    if self.target == "watchtarget" then
      local unitid = api.Unit:GetUnitId(self.target)
      local info = api.Unit:GetUnitInfoById(unitid)

      if info.faction == "hostile" then
        self:SetColor("enemy")
        return
      end
      if info.social ~= nil then
        if info.social == "raid" then

        else
          if self.state.pvpDebuff == false then
            self:SetColor("ally") 
            return
          else
            self:SetColor("allyflagged")
            return
          end
        end
      else
        if self.state.pvpDebuff == false then
          self:SetColor("ally")  
          return
        else
          self:SetColor("allyflagged")
          return
        end
      end
    end
    if self.target == "playerpet1" then
      self:SetColor("pet")
      return
    end
    if self.state.pvpDebuff then
      self:SetColor("flagged")
    else
      if self.state.disabled then
        self:SetColor("disabled")
        return
      end
      if self.settings.enablerolecolors then
        if self.state.role == 1 then
          self:SetColor("defender")
          return
        elseif self.state.role == 2 then
          self:SetColor("healer")
          return
        elseif self.state.role == 3 then
          self:SetColor("attacker")
          return
        end
      end

      self:SetColor("undecided")
      return
    end
  end 

  function w:UpdateRoleOfHpBarTextureParty()
    if self.pvpDebuff then
      self:SetColor("pflagged")
    else
      if self.disabled then
        self:SetColor("pdisabled")
        return
      end
      if self.settings.enablerolecolors then
        if self.state.role == 1 then
          self:SetColor("pdefender")
          return
        elseif self.state.role == 2 then
          self:SetColor("phealer")
          return
        elseif self.state.role == 3 then
          self:SetColor("pattacker")
          return
        end
      end

      self:SetColor("pundecided")
      return
    end
  end 

  function w:UpdateNameLabelWidth()
    local width = self.hpBar:GetWidth()
     local nameWidth = width
    if self.marker:IsVisible() then
      nameWidth = nameWidth - self.marker:GetWidth()
    end

    if self.leaderMark:IsVisible() then
        nameWidth = nameWidth - self.leaderMark:GetWidth()
    end

    if self.distanceLabel:IsVisible() then
      width = width - self.distanceLabel:GetWidth() - (6 * api._Thicc.uiScale)
    end
    self.nameLabel:SetWidth(nameWidth)
    self.guildLabel:SetWidth(width)
  end
  function w:UpdateLeaderMark()
    local authority = api.Unit:UnitTeamAuthority(self.target)
    --local myId = api.Unit:GetUnitId("target")
    --local targetName = api.Unit:GetUnitNameById(unitid)

    self.leaderMark:Show(false)

    if authority == "leader" or authority == "subleader" then
      self.leaderMark:Show(true)
      self.leaderMark:SetMark(authority, true)
    end

    self:UpdateNameLabelWidth()
    if self.leaderMark:IsVisible() then
      self.nameLabel:RemoveAllAnchors()
      self.nameLabel:AddAnchor("TOPLEFT", self.leaderMark, "TOPRIGHT", 2, -3)
    else
      self.nameLabel:RemoveAllAnchors()
      self.nameLabel:AddAnchor("TOPLEFT", self.hpBar, 3, 0)
    end

  end

  function w:UpdatePvPFlag()

    local flag = api.Unit:UnitIsForceAttack(self.target)

    self.pvpIcon:Show(flag)
  end

  function w:UpdateDistance()
    if self.target == nil then
      return
    end
    local distance = api.Unit:UnitDistance(self.target)
    if distance == nil then
      self:Show(false)
      return
    end
    distance = math.abs(math.ceil(distance))
    --api.Log:Info(distance)
    local str = string.format("%dm", distance)
    self.distanceLabel:SetText(str)
    local width = self.distanceLabel.style:GetTextWidth(str)
    self.distanceLabel:SetWidth(width)
  end

  function w:UpdateBackground()
    local unitid = api.Unit:GetUnitId(w.target)
    local targetid = api.Unit:GetUnitId("target")
    if unitid == targetid then
        self.bg:SetColor(ConvertColor(230), ConvertColor(197), ConvertColor(35), 1)
        return
    end
    self.bg:SetColor(ConvertColor(55), ConvertColor(42), ConvertColor(17), 0.8)
  end
  local SetMarkerTexture = function(markerTexture, markerIndex)
    markerTexture:SetCoords(markerCoords[markerIndex][1], markerCoords[markerIndex][2], markerCoords[markerIndex][3], markerCoords[markerIndex][4])
  end
  function w:SetMarker(memberId, markers)
    self.marker:SetVisible(false)
    if memberId == nil then
      return
    end
    if self.marker == nil then
      return
    end
    self.state.markerId = 0

    for i = 1, 12 do
      local markerUnitId = markers[i]
      if markerUnitId == memberId then
        self.marker:SetVisible(true)
        self.state.markerId = i
        SetMarkerTexture(self.marker, i)
        return
      end
    end
  end

  function w:Position()

    self:RemoveAllAnchors() -- should remove anchors before moving one
    self:AddAnchor("TOPLEFT", "UIParent", w.state.posX, w.state.posY)
  end

  function w:Refresh(settings, settingschanged, markers, mypartyidx, myId, refreshrender)
    local show = true
    
    self.state.posX = 0
    self.state.posY = 0
    self.state.posZ = 0
    self.settings = settings
    
    if settingschanged or refreshrender then
      self:TranslucenceFrame(settings.bartransparency / 100)
      self:SetSimpleMode(settings)
    end
    if settings.showbars == false then
      self:Show(false)
      show = false
    end
    if settings.showraid == false then
      self:Show(false)
      show = false
    end
    if self.isPet then
      show = settings.showmount and settings.showbars
      self:Show(show)
    end
    self.targetid = api.Unit:GetUnitId(w.target)
    
    if self.targetid == myId then
      if w.notplayer then
        self:Show(false)
        show = false
      end
    end
    if self.bypassTeamCheck or api.Unit:UnitIsTeamMember(self.target) == true then

      if w.notplayer then
     
        local offsetX, offsetY, offsetZ = api.Unit:GetUnitScreenPosition(self.target)

        if offsetX == nil then
          self:Show(false)
          show = false
          return
        end
        if offsetX ~= offsetX then
          offsetX = api._Thicc.screenw / 2
          offsetZ = -offsetZ
        end
        if offsetY ~= offsetY then
          offsetY = api._Thicc.screenh / 2
        end

        offsetX = math.ceil(offsetX)
        offsetY = math.ceil(offsetY) - 22
            
        offsetXHalf = math.ceil(settings.width / 2)
        offsetYHalf = math.ceil((settings.hpheight + settings.mpheight) / 2)
        
        self.state.posX = offsetX - offsetXHalf
        self.state.posY = offsetY - offsetYHalf
        self.state.posZ = offsetZ

        if offsetZ < 0 then
          self:Show(false)
          show = false
          return
        end
      end
      self:SetMarker(self.targetid, markers)

      self.state.role = 0
      if (self.memberIndex > 0 and self.memberIndex <= 50) then
        self.state.role = api.Team:GetRole(self.memberIndex)
      elseif self.isPet then
        self.state.role = 4
      elseif api.Unit:UnitIsTeamMember(self.target) == true and self.notplayer then
        show = false
        self:Show(false)
        return
      end

      self:Show(show)
      self:UpdateName()
      self:UpdateMaxHp()
      self:UpdateHp()
      self:UpdateMaxMp()
      self:UpdateMp()
      self:UpdateBuff(self.dead)
      self:UpdateLeaderMark()
      self:UpdateDistance()
      self:UpdateBackground()
      self:UpdatePvPFlag()
      if settings.enablepartycolors and mypartyidx == self.partyIndex then
        self:UpdateRoleOfHpBarTextureParty()
      else
        self:UpdateRoleOfHpBarTexture()
      end

      if settings.ctrlenabled and api.Input:IsControlKeyDown() then
        self.eventWindow:Show(false)
        self:Clickable(false)
        return
      else
        self:Clickable(true)
        self.eventWindow:Show(true)
      end
      if settings.shiftenabled and api.Input:IsShiftKeyDown() then
        self.eventWindow:Show(false)
        self:Clickable(false)
        return
      else
        self:Clickable(true)
        self.eventWindow:Show(true)
      end
      return true
    else
      self:Show(false)
    end
    return false
  end

  local event = w.eventWindow
  function event:OnClick(arg, arg1, arg2)
    if arg == "MiddleButton" then
        return
    end
    if self:IsVisible() == false then
      return
    end
    if w.target ~= nil then
      ChangeTarget(w.target)
    end
  end


  event:SetHandler("OnClick", event.OnClick)

  function event:OnDragStart()
    self:OnClick("LeftButton")
  end

  event:EnableDrag(true)
  event:SetHandler("OnDragStart", event.OnDragStart)

  function w:OnClose()
    local event = w.eventWindow
  end
  return w
end
local retval = {}
retval.CreateRaidMember = CreateRaidMember
retval.SetViewOfRaidMember = SetViewOfRaidMember
return retval