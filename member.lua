local MAX_RAID_PARTY_MEMBERS = 5
local UNIT_VISIBLE_MAX_DISTANCE = 130
STATUSBAR_STYLE = {
  S_HP_PARTY = {
    coords = {
      301,
      20,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    },
    afterImage_color_down = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    }
  },
  S_HP_FRIENDLY = {
    coords = {
      301,
      0,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    },
    afterImage_color_down = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    }
  },
  S_HP_NEUTRAL = {
    coords = {
      301,
      60,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    },
    afterImage_color_down = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    }
  },
  S_HP_HOSTILE = {
    coords = {
      301,
      40,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    },
    afterImage_color_down = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    }
  },
  S_HP_PREEMTIVE_STRIKE = {
    coords = {
      301,
      100,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  S_HP_OFFLINE = {
    coords = {
      301,
      80,
      150,
      19
    },
    afterImage_color_up = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    },
    afterImage_color_down = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    }
  },
  S_MP = {
    coords = {
      301,
      140,
      150,
      13
    }
  },
  S_MP_OFFLINE = {
    coords = {
      301,
      154,
      150,
      13
    }
  },
  L_HP_FRIENDLY = {
    coords = {
      0,
      0,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    },
    afterImage_color_down = {
      ConvertColor(134),
      ConvertColor(207),
      ConvertColor(82),
      1
    }
  },
  L_HP_NEUTRAL = {
    coords = {
      0,
      60,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    },
    afterImage_color_down = {
      ConvertColor(230),
      ConvertColor(141),
      ConvertColor(36),
      1
    }
  },
  L_HP_HOSTILE = {
    coords = {
      0,
      40,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    },
    afterImage_color_down = {
      ConvertColor(223),
      ConvertColor(69),
      ConvertColor(69),
      1
    }
  },
  L_HP_PARTY = {
    coords = {
      0,
      20,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(86),
      ConvertColor(198),
      ConvertColor(239),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  L_HP_PREEMTIVE_STRIKE = {
    coords = {
      0,
      100,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    },
    afterImage_color_down = {
      ConvertColor(202),
      ConvertColor(110),
      ConvertColor(105),
      1
    }
  },
  L_HP_OFFLINE = {
    coords = {
      0,
      80,
      300,
      19
    },
    afterImage_color_up = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    },
    afterImage_color_down = {
      ConvertColor(46),
      ConvertColor(46),
      ConvertColor(46),
      1
    }
  },
  L_MP = {
    coords = {
      0,
      140,
      300,
      13
    }
  },
  L_MP_OFFLINE = {
    coords = {
      0,
      154,
      300,
      13
    }
  },
  HP_RAID = {
    coords = {
      0,
      0,
      62,
      27
    }
  },
  HP_RAID_TANKER = {
    coords = {
      63,
      0,
      62,
      27
    }
  },
  HP_RAID_DEALER = {
    coords = {
      63,
      28,
      62,
      27
    }
  },
  HP_RAID_HEALER = {
    coords = {
      0,
      28,
      62,
      27
    }
  },
  HP_RAID_OFFLINE = {
    coords = {
      0,
      56,
      62,
      27
    }
  },
  MP_RAID = {
    coords = {
      63,
      72,
      62,
      5
    }
  },
  MP_RAID_OFFLINE = {
    coords = {
      63,
      78,
      62,
      5
    }
  },
  S_HP_RAID = {
    coords = {
      63,
      84,
      62,
      16
    }
  },
  S_HP_RAID_TANKER = {
    coords = {
      0,
      84,
      62,
      16
    }
  },
  S_HP_RAID_DEALER = {
    coords = {
      63,
      56,
      62,
      16
    }
  },
  S_HP_RAID_HEALER = {
    coords = {
      0,
      101,
      62,
      16
    }
  },
  S_HP_RAID_OFFLINE = {
    coords = {
      63,
      101,
      62,
      16
    }
  },
  S_MP_RAID = {
    coords = {
      0,
      118,
      62,
      4
    }
  },
  S_MP_RAID_OFFLINE = {
    coords = {
      63,
      118,
      62,
      4
    }
  }
}

SetViewOfRaidMember = require("thiccbars//member_view")
function CreateRaidMember(parent, name , ownId, index, ChangeTarget, settings)
  local w = SetViewOfRaidMember(name, ownId, index, parent)
  w:Show(false)
  w.memberIndex = index
  w.target = string.format("team%d", w.memberIndex)
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
        self:SetGuild("<" .. info.expeditionName .. ">")
    end
  end

  function w:UpdateMaxHp()
    local maxHp = api.Unit:UnitMaxHealth(w.target)
    self:SetMaxHp(maxHp)
  end
  function w:UpdateHp()
    local hp = api.Unit:UnitHealth(w.target)
    self:SetHp(hp)
  end
  function w:UpdateMaxMp()
    local maxMp = api.Unit:UnitMaxMana(w.target)
    self:SetMaxMp(maxMp)
  end
  function w:UpdateMp()
    local mp = api.Unit:UnitMana(w.target)
    self:SetMp(mp)
  end
  function w:UpdateBuff()
    w.buffWindow:BuffUpdate(w.target)
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
      width = width - 5
    if self.leaderMark:IsVisible() then
        width = width - self.leaderMark:GetWidth()
      end
    end
    self.nameLabel:SetWidth(width)
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
      self.nameLabel:AddAnchor("TOPLEFT", self.leaderMark, "TOPRIGHT", 2, -1)
    else
      self.nameLabel:RemoveAllAnchors()
      self.nameLabel:AddAnchor("TOPLEFT", self.hpBar, 3, 2)
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
    function w:Refresh(settings, settingschanged)
        if settingschanged then
            self:TranslucenceFrame(settings.bartransparency / 100)
            self:SetSimpleMode(settings)
        end
        if settings.showbars == false then
            self:Show(false)
            return
        end
        local unitid = api.Unit:GetUnitId(w.target)
        local myId = api.Unit:GetUnitId("player")
        if unitid == myId then
            if w.target ~= "player" then
                self:Show(false)
                return
            end
        end

    if api.Unit:UnitIsTeamMember(self.target) == true or self.target == "player" then

        if self.target ~= "player" then
            --local pos = api.Unit:GetUnitScreenPosition(self.target)
            --api.Log:Info(self.target)
            --local x, y, z = api.Unit:UnitWorldPosition(self.target)
            --z = z
      
            local offsetX, offsetY, offsetZ = api.Unit:GetUnitScreenPosition(self.target)
            if offsetX == nil then
                self:Show(false)
                return
            end
            if offsetZ < 0 then
                self:Show(false)
                return
            end
            --api.Log:Info(offsetZ)
            offsetX = math.ceil(offsetX)
            offsetY = math.ceil(offsetY) - 22
            self:RemoveAllAnchors() -- should remove anchors before moving one
            offsetXHalf = math.ceil(settings.width / 2)
            offsetYHalf = math.ceil((settings.hpheight + settings.mpheight) / 2)
            self:AddAnchor("TOPLEFT", "UIParent", offsetX - offsetXHalf, offsetY - offsetYHalf)
        end

        self:Show(true)
        --self:UpdateRoleOfHpBarTexture()
        self:UpdateName()
        self:UpdateMaxHp()
        self:UpdateHp()
        self:UpdateMaxMp()
        self:UpdateMp()
        self:UpdateBuff()
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
  local SetMarkerTexture = function(markerTexture, markerIndex)
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
    markerTexture:SetCoords(markerCoords[markerIndex][1], markerCoords[markerIndex][2], markerCoords[markerIndex][3], markerCoords[markerIndex][4])
  end
  function w:SetMarker(memberId, markerid)
    if memberId == nil then
      return
    end
    if self.marker == nil then
      return
    end
    --api.Log:Info(tostring(memberId) .. " ".. tostring(markerid))
      -- markerUnitId == memberId then
        self.marker:SetVisible(true)
        SetMarkerTexture(self.marker, markerid)
        --return
      --end
    --for i = 1, 12 do
    --  local markerUnitId = X2Unit:GetOverHeadMarkerUnitId(i)
    --  if markerUnitId == memberId then
    --    self.marker:SetVisible(true)
    --    SetMarkerTexture(self.marker, i)
    --    return
    --  end
    --end
  end
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
        w:SetMarker(memberId, arg[2])
      end
      w:UpdateNameLabelWidth()
    elseif event == "ENTERED_WORLD" then
      local memberId = api.Unit:GetUnitId(w.target)
      --w.marker:SetVisible(false)
      --w:SetMarker(memberId)
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