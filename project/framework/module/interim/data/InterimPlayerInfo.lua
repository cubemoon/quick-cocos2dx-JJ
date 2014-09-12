local TkPlayerInfo = class("TkPlayerInfo")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_PLAYER_STATUS_EMPTY = InterimUtilDefine.INTERIM_PLAYER_STATUS_EMPTY
local INTERIM_PLAYER_STATUS_ENGAGED = InterimUtilDefine.INTERIM_PLAYER_STATUS_ENGAGED
local INTERIM_PLAYER_STATUS_STANDBY = InterimUtilDefine.INTERIM_PLAYER_STATUS_STANDBY
local INTERIM_PLAYER_STATUS_FOLD = InterimUtilDefine.INTERIM_PLAYER_STATUS_FOLD

function TkPlayerInfo:ctor()
	self.seat = -1
	self.userid = 0
	self.nickname = ""
	self.figureId = 0
	self.matchrank = 0
	self.score = 0
	self.arrived = false
	self.netStatus = 0
	self.ready = true
end

local InterimPlayerInfo = class("InterimPlayerInfo")

function InterimPlayerInfo:ctor()
	self.tkInfo = TkPlayerInfo.new()
	self:init()
end

function InterimPlayerInfo:init()
	self.dataUpdated = false 
	self:reset()
end

function InterimPlayerInfo:reset()
	self.tkInfo.userid = 0
	self.tkInfo.nickname = ""
	self.tkInfo.figureId = 0
	self.tkInfo.matchExcp = 0
	self.tkInfo.score = 0
	self.tkInfo.arrived = false
	self.tkInfo.netStatus = 0
	self.tkInfo.ready = true

	self.dataUpdated = false
	self.status = INTERIM_PLAYER_STATUS_EMPTY

	self.cardLeft = nil
	self.cardRight = nil
	self.cardMiddle = nil

	self.enResult = nil

	self.rank = 0
	self.score = 0

	--selg.isInMatch = false

end

function InterimPlayerInfo:resetCard()
	self.cardLeft = nil
	self.cardRight = nil
	self.cardMiddle = nil
end

return InterimPlayerInfo
