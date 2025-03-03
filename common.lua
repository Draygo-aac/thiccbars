globals = {}
globals.RAID_FRAME_PARTY_LABEL_WIDTH = 34
globals.RAID_FRAME_PARTY_LABEL_HEIGHT = 19
globals.PARTY_FRAME_AMONG_INSET = 3
globals.MEMBER_FRAME_AMONG_INSET_HORIZON = 5
globals.MEMBER_FRAME_AMONG_INSET_VERTICAL = 0
globals.PARTY_FRAME_AMONG_INSET_HORIZON = 3
globals.PARTY_FRAME_AMONG_INSET_VERTICAL = 15
globals.BG_INSET = 6
globals.PATH = "ui/hud/unit_raid_frame.dds"
globals.MEMBER_WIDTH = 100
globals.MEMBER_HPHEIGHT = 28
globals.MEMBER_MPHEIGHT = 4
globals.BUFF_ICONSIZE = 16
globals.MEMBER_HEIGHT = 32
globals.TRANSPARENCY = 100
globals.SIMPLE_MEMBER_WIDTH = 88
globals.SIMPLE_MEMBER_HEIGHT = 22
local MAX_RAID_PARTIES = 10
local MAX_RAID_PARTY_MEMBERS = 5
globals.RAID_FRAME_WIDTH = globals.MEMBER_WIDTH * 5 + globals.PARTY_FRAME_AMONG_INSET_HORIZON * 4
globals.RAID_FRAME_HEIGHT = globals.RAID_FRAME_PARTY_LABEL_HEIGHT * 2 + globals.MEMBER_HEIGHT * 10 + globals.MEMBER_FRAME_AMONG_INSET_VERTICAL * 10 + globals.PARTY_FRAME_AMONG_INSET_VERTICAL
globals.SIMPLE_RAID_FRAME_WIDTH = globals.SIMPLE_MEMBER_WIDTH * 5 + globals.PARTY_FRAME_AMONG_INSET_HORIZON * 4
globals.SIMPLE_RAID_FRAME_HEIGHT = globals.RAID_FRAME_PARTY_LABEL_HEIGHT * 2 + globals.SIMPLE_MEMBER_HEIGHT * 10 + globals.MEMBER_FRAME_AMONG_INSET_VERTICAL * 10 + globals.PARTY_FRAME_AMONG_INSET_VERTICAL

return globals