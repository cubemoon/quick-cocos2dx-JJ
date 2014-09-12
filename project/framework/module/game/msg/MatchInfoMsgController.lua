MatchInfoMsgController = {}

local TAG = "MatchInfoMsgController"

MATCH_TABLE_INFO_CHANGE_ACK = 1
MATCH_TABLE_PLAYER_CHANGE_ACK = 2
MATCH_SIGN_COUNT_INFO_ACK = 3

require("game.data.match.MatchTableData")

function MatchInfoMsgController:handleMsg(msg)
    msg[MSG_CATEGORY] = MATCHINFO_ACK_MSG
    local matchinfo = msg.matchinfo_ack_msg

    if #matchinfo.gettablelist_ack_msg ~= 0 then
        self:handleTableInfoAck(msg)
    elseif #matchinfo.getplayer_ack_msg ~= 0 then
        self:handleTablePlayerInfoAck(msg)
    elseif #matchinfo.getsigncount_ack_msg ~= 0 then
        self:handleSignCountInfoAck(msg)
    end
end

--[[比赛的散桌信息]]
function MatchInfoMsgController:handleTableInfoAck(msg)
    msg[MSG_TYPE] = MATCH_TABLE_INFO_CHANGE_ACK

    local ack = msg.matchinfo_ack_msg.gettablelist_ack_msg
    MatchTableData:GetTableListAckHandler(ack)
end

--[[桌子详情]]
function MatchInfoMsgController:handleTablePlayerInfoAck(msg)
    msg[MSG_TYPE] = MATCH_TABLE_PLAYER_CHANGE_ACK

    local ack = msg.matchinfo_ack_msg.getplayer_ack_msg
    --JJLog.i(TAG,vardump(ack))
    MatchTableData:GetTablePlayerAckHandler(ack)
end

function MatchInfoMsgController:handleSignCountInfoAck(msg)
    msg[MSG_TYPE] = MATCH_SIGN_COUNT_INFO_ACK

    local ack = msg.matchinfo_ack_msg.getsigncount_ack_msg
    local tourneyId = ack.tourneyid
end