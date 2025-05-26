local MAX_RAID_PARTY_MEMBERS = 5
local UNIT_VISIBLE_MAX_DISTANCE = 130

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
  w.target = name
  w:SetSimpleMode(settings)
  function w:SetName(name)
    if name ~= nil then
      w.nameLabel:SetText(name)
    end
  end
  function w:SetGuild(name)
    if name ~= nil then
        w.guildLabel:Show(true)
        w.guildLabel:SetText(name)
    else
        w.guildLabel:Show(false)
    end
  end
  function w:SetMaxHp(maxHp)
    if maxHp ~= nil then
      w.hpBar.statusBar:SetMinMaxValues(0, maxHp or 0)
    end
  end
  function w:SetHp(hp)
    if hp ~= nil then
      w.hpBar.statusBar:SetValue(hp or 0)
    end
  end
  function w:SetMaxMp(maxMp)
    if maxMp ~= nil then
      w.mpBar.statusBar:SetMinMaxValues(0, maxMp or 0)
    end
  end
  function w:SetMp(mp)
    if mp ~= nil then
      w.mpBar.statusBar:SetValue(mp or 0)
    end
  end
  function w:UpdateName()
    local unitid = api.Unit:GetUnitId(w.target)
    local myId = api.Unit:GetUnitId("target")
    local name = api.Unit:GetUnitNameById(unitid)
    local myName = api.Unit:GetUnitNameById(myId)
    local info = api.Unit:GetUnitInfoById(unitid)

    --api.Log:Info(info)
    if name == myName then
      self.nameLabel.style:SetColor(ConvertColor(252), ConvertColor(219), ConvertColor(39), 1)
      self.guildLabel.style:SetColor(ConvertColor(252), ConvertColor(219), ConvertColor(39), 1)
      self.selectedIcon:Show(true)
    else
      self.nameLabel.style:SetColor(1, 1, 1, 1)
      self.guildLabel.style:SetColor(1, 1, 1, 1)
      self.selectedIcon:Show(false)
    end
    self:SetName(name)
    if info.expeditionName ~= nil then
        self:SetGuild(" " .. info.expeditionName)
    else
        self:SetGuild(nil)
    end
  end

  function w:UpdateMaxHp()
    local maxHp = api.Unit:UnitMaxHealth(w.target)
    self:SetMaxHp(maxHp)
  end
  function w:UpdateHp()
    local hp = api.Unit:UnitHealth(w.target)
    self:SetHp(hp)
    self.dead = hp == 0
  end
  function w:UpdateMaxMp()
    local maxMp = api.Unit:UnitMaxMana(w.target)
    self:SetMaxMp(maxMp)
  end
  function w:UpdateMp()
    local mp = api.Unit:UnitMana(w.target)
    self:SetMp(mp)
  end
  function w:UpdateBuff(dead)
    w.buffWindow:BuffUpdate(w.target, dead)
  end
  function w:ChangeHpBarTexture_role(simpleMode, role)
   -- if simpleMode then
   --   if role == TMROLE_TANKER then
   --     self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID_TANKER)
   --   elseif role == TMROLE_HEALER then
   --     self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID_HEALER)
   --   elseif role == TMROLE_DEALER then
   --     self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID_DEALER)
   --   else
   --     self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID)
   --   end
   -- elseif role == TMROLE_TANKER then
   --   self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_TANKER)
   -- elseif role == TMROLE_HEALER then
   --   self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_HEALER)
   -- elseif role == TMROLE_DEALER then
   --   self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_DEALER)
   -- else
   --   self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID)
   -- end
  end
  function w:UpdateRoleOfHpBarTexture()
    --api.Log:Info(self.target)
    if self.target == "watchtarget" then
        local unitid = api.Unit:GetUnitId(self.target)
        local info = api.Unit:GetUnitInfoById(unitid)
        
       -- api.Log:Info("test")
        if info.faction == "hostile" then
            self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_DEALER)
        else
            self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID)
        end
        --api.Log:Info("test2")
    end
    --local role = api.Unit:GetRole(self.memberIndex)
    --local myMemberIndex = api.Unit:GetTeamPlayerIndex()
    --local isOffline = X2Unit:UnitIsOffline(self.target)
    --if isOffline then
    --  if self.simple then
    --    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID_OFFLINE)
    --  else
    --    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_OFFLINE)
    --  end
    --else
    --  self:ChangeHpBarTexture_role(self.simple, role)
    --  if self.simple then
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP_RAID)
    --  else
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.MP_RAID)
    --  end
    --end
  end
  function w:UpdateNameLabelWidth()
    local width = self.hpBar:GetWidth()

    if self.marker:IsVisible() then
      width = width - self.marker:GetWidth()
      if self.leaderMark:IsVisible() then
        width = width - self.leaderMark:GetWidth()
      end
    else
      --width = width - 5
    if self.leaderMark:IsVisible() then
        width = width - self.leaderMark:GetWidth()
      end
    end
    local nameWidth = width
    if self.distanceLabel:IsVisible() then
        width = width - self.distanceLabel:GetWidth()
    end
    self.nameLabel:SetWidth(nameWidth)
    self.guildLabel:SetWidth(width)
  end
  function w:UpdateLeaderMark()
    local authority = api.Unit:UnitTeamAuthority(self.target)
    local myId = api.Unit:GetUnitId("target")
    local targetName = api.Unit:GetUnitNameById(unitid)

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
  --local GetTeamInPlayer = function()
    --local myMemberIndex = X2Team:GetTeamPlayerIndex()
    --return string.format("team%d", myMemberIndex)
  --end
  function w:UpdateOffline()
    --if self.target == GetTeamInPlayer() then
    --  return
    --end
    --local isOffline = api.Unit:UnitIsOffline(self.target)
    --if isOffline then
    --  self:TranslucenceFrame(false)
    --  if self.simple then
    --    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_RAID_OFFLINE)
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP_RAID_OFFLINE)
    --  else
    --    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.HP_RAID_OFFLINE)
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.MP_RAID_OFFLINE)
    --  end
    --  ApplyTextColor(self.nameLabel, FONT_COLOR.DARK_GRAY)
    --  self.offlineLabel:Show(not self.simple)
    --else
    --  self.offlineLabel:Show(false)
    --  if self.simple then
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP_RAID)
    --  else
    --    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.MP_RAID)
    --  end
    --end
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
    self:Show(true)
  end

  function w:UpdateBackground()
    local unitid = api.Unit:GetUnitId(w.target)
    local targetid = api.Unit:GetUnitId("target")
    if unitid == targetid then
        self.bg:SetColor(ConvertColor(255), ConvertColor(219), ConvertColor(39), 1)
        return
    end
    self.bg:SetColor(1, 1, 1, 0.8)
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
    self.markerId = 0

    for i = 1, 12 do
      local markerUnitId = markers[i]
      if markerUnitId == memberId then
        self.marker:SetVisible(true)
        self.markerId = i
        SetMarkerTexture(self.marker, i)
        return
      end
    end
  end

    function w:Position()

        self:RemoveAllAnchors() -- should remove anchors before moving one
        self:AddAnchor("TOPLEFT", "UIParent", w.posX, w.posY)
    end

    function w:Refresh(settings, settingschanged, markers)
        local show = true
        self.tileroot = nil
        self.idx = 0
        self.posX = 0
        self.posY = 0
        if settingschanged then
            self:TranslucenceFrame(settings.bartransparency / 100)
            self:SetSimpleMode(settings)
        end
        if settings.showbars == false then
            self:Show(false)
            show = false
            --return
        end
        self.targetid = api.Unit:GetUnitId(w.target)
        local myId = api.Unit:GetUnitId("player")
        if self.targetid == myId then
            if w.target ~= "player" then
                self:Show(false)
                show = false
                --return
            end
        end
        if api.Unit:UnitIsTeamMember(self.target) == true or self.target == "player"  or self.target == "watchtarget" then

        if self.target ~= "player" then

            --local pos = api.Unit:GetUnitScreenPosition(self.target)
            --api.Log:Info(self.target)
            --local x, y, z = api.Unit:UnitWorldPosition(self.target)
            --z = z
      
            local offsetX, offsetY, offsetZ = api.Unit:GetUnitScreenPosition(self.target)
            if offsetX == nil then
                self:Show(false)
                show = false
                return
            end
            if offsetZ < 0 then
                self:Show(false)
                show = false
                return
            end
            --api.Log:Info(offsetZ)
            offsetX = math.ceil(offsetX)
            offsetY = math.ceil(offsetY) - 22
            
            offsetXHalf = math.ceil(settings.width / 2)
            offsetYHalf = math.ceil((settings.hpheight + settings.mpheight) / 2)

            w.posX = offsetX - offsetXHalf
            w.posY = offsetY - offsetYHalf
           
        end
        self:SetMarker(self.targetid, markers)
        if show == false then
            return false
        end

        self:Show(show)
        self:UpdateRoleOfHpBarTexture()
        self:UpdateName()
        self:UpdateMaxHp()
        self:UpdateHp()
        self:UpdateMaxMp()
        self:UpdateMp()
        self:UpdateBuff(self.dead)
        self:UpdateLeaderMark()
        self:UpdateDistance()
        self:UpdateBackground()
        

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
  function event:OnClick(arg)
    --api.Log:Info("Click")
    if self:IsVisible() == false then
      return
    end
    --arg == "LeftButton" and 
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



  function event:OnEvent(event, ...)
    if event == "TEAM_MEMBERS_CHANGED" then
      if arg[1] == "owner_changed" and (arg[4] == w.memberIndex or arg[5] == w.memberIndex) then
        w:UpdateLeaderMark()
      end
      --local func = locale.team.msgFunc[arg1]
      --if func ~= nil then
       -- local notifyMsg = func(arg2, arg3)
        --if notifyMsg ~= nil then
          --X2Chat:DispatchChatMessage(CMF_PARTY_AND_RAID_INFO, notifyMsg)
        --else
        --  LuaAssert(string.format("error - arg2 = %s, arg3 = %s", tostring(arg2), tostring(arg3)))
        --end
      --end
    elseif event == "TEAM_MEMBER_DISCONNECTED" then
      if arg[1] == true then
        w:UpdateOffline()
      end
    elseif event == "SET_OVERHEAD_MARK" then
      local memberId = api.Unit:GetUnitId(w.target)
      if arg[1] ~= memberId then
        return
      end
      
      if not arg[3] then
        w.marker:SetVisible(false)
        w:UpdateNameLabelWidth()
        return
      else
        w:SetMarker(memberId)
      end
      w:UpdateNameLabelWidth()
    elseif event == "ENTERED_WORLD" then
      local memberId = api.Unit:GetUnitId(w.target)
      w.marker:SetVisible(false)
      w:SetMarker(memberId)
      w:UpdateNameLabelWidth()
    end
  end
  event:SetHandler("OnEvent", event.OnEvent)
  event:RegisterEvent("TEAM_MEMBERS_CHANGED")
  event:RegisterEvent("TEAM_MEMBER_DISCONNECTED")
  event:RegisterEvent("SET_OVERHEAD_MARK")
  event:RegisterEvent("ENTERED_WORLD")
  function w:OnClose()
    local event = w.eventWindow
    event:ReleaseHandler("OnEvent")
  end
  return w
end
local retval = {}
retval.CreateRaidMember = CreateRaidMember
retval.SetViewOfRaidMember = SetViewOfRaidMember
return retval