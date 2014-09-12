HBaseMsgController = {}
local TAG = "HBaseMsgController"

HBASE_GET_TECH_STATICS_ACK = 1

function HBaseMsgController:handleMsg(msg)
	msg[MSG_CATEGORY] = HBASE_ACK_MSG
	local ack = msg.hbase_ack_msg	
	if #ack.hbasecommon_ack_msg then
		self:handleCommonHbaseAck(msg)
	end
end

function HBaseMsgController:handleGetTechStaticsAck(msg, jsonTable)
    --JJLog.i(TAG, "handleGetTechStaticsAck",vardump(jsonTable))
	msg[MSG_TYPE] = HBASE_GET_TECH_STATICS_ACK
	if jsonTable.result then				
		msg.userid = jsonTable.result.userid
		msg.gameid = jsonTable.result.gameid
		msg.totalhand = jsonTable.result.totalhand or 0
		msg.winhand = jsonTable.result.winhand or 0
        msg.allin = jsonTable.result.allin or 0
        msg.giveup = jsonTable.result.giveup or 0
	end
end

-- 通用协议处理
function HBaseMsgController:handleCommonHbaseAck(msg)		
	local ack = msg.hbase_ack_msg.hbasecommon_ack_msg.commonackmsg
	--JJLog.i(TAG, "handleCommonHbaseAck ", ack)
	local jsonTable = json.decode(ack)
	if jsonTable ~= nil then
		local msgType = jsonTable.msgtype
		local msgError = jsonTable.error
		if msgError then 
			JJLog.e(TAG, "handleCommonHbaseAck, jsonTableerror", msgError)
		elseif msgType == "techstatistics" then
			self:handleGetTechStaticsAck(msg, jsonTable)
		else
			RankInterface:handleHbaseRankingMsg(ack)
			JJLog.e(TAG, "handleCommonHbaseAck, jsonTable msgtype error", msgType)
		end
	end
end