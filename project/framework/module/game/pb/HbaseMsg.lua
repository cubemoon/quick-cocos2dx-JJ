-- Hbase 消息
HbaseMsg = {}
local TAG = "HbaseMsg"

require("game.pb.SendMsg")

--local msgId_ = getCurrentSecond()
-- 用于判断该消息是哪个游戏的请求
--local commonHbaseMsg_ = {} -- Key: msgid, Value: package id

local function _getTKMobileReq()
	local msg = {}
	return msg
end

local function _getHbaseReq()
	local msg = _getTKMobileReq()
	msg.hbase_req_msg = {}
	return msg
end
--[[
local function _getMsgId()
	msgId_ = msgId_ + 1
	return msgId_
end

local function _saveMsg(msgId, pkgId)
	commonHbaseMsg_[tostring(msgId)] = pkgId
end
]]

--[[
	用于处理消息时，判断这条消息该回馈给哪个游戏
]]
--function HbaseMsg:_getPkg(msgId)
--	return commonHbaseMsg_[tostring(msgId)]
--end

-- 发送通用协议消息
function HbaseMsg:sendCommonHbaseReq(txt, gameId)
	--JJLog.i(TAG, "sendCommonHbaseReq, txt=", txt, ", gameId=", gameId)
	local msg = _getHbaseReq()

	msg.hbase_req_msg.hbasecommon_req_msg = {
		commonreqmsg = txt,
	}
	SendMsg:send(msg)
	--_saveMsg(msgId, msgType)
end

--获取玩家统计数据
function HbaseMsg:sendGetTechStatisticsReq(gameId_, userId)
	--local id = tostring(_getMsgId(self))
	local jsonTable = {
		msgtype = "techstatistics",
		param = {
			gameid = gameId_ or 0,
			userid = userId,
		},
	}

	local txt = json.encode(jsonTable)
	--JJLog.i(TAG, "sendGetTechStatisticsReq, txt=", txt)
	self:sendCommonHbaseReq(txt, gameId_)
end

return HbaseMsg