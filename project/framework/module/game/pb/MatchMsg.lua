-- 比赛消息
MatchMsg = {}

require("game.pb.SendMsg")

local function _getTKMobileReq()
	local msg = {}
	return msg
end

local function _getMatchReq(matchId)
	local msg = _getTKMobileReq()
	msg.match_req_msg = {
		matchid = matchId
	}
	return msg
end

--确认进入比赛
function MatchMsg:sendEnterMatchReq(matchId, gameId, _ticket)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.entermatch_req_msg = {
		gameid = gameId,
		ticket = _ticket
	}
	SendMsg:send(msg)
end

--进入局制
function MatchMsg:sendEnterRoundReq(matchId, gameId, _ticket)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.enterround_req_msg = {
		gameid = gameId,
		ticket = _ticket
	}
	SendMsg:send(msg)
end

--退出比赛
function MatchMsg:sendExitGameReq(matchId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.exitgame_req_msg = {}
	SendMsg:send(msg)
end

--请求玩家排名
function MatchMsg:sendPushUserPlaceOrderPositionReq(matchId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.pushuserplaceorderposition_req_msg = {}
	SendMsg:send(msg)
end

--请求stage排名
function MatchMsg:sendGetStagePlayerOrderReq(matchId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.getstageplayerorder_req_msg = {}
	SendMsg:send(msg)
end

-- 请求岛屿赛继续
function MatchMsg:sendContinueReq(matchId, userId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.continue_req_msg = {userid = userId}
	SendMsg:send(msg)
end

--请求离开岛屿赛
function MatchMsg:sendLeaveReq(matchId, userId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.leave_req_msg = {userid = userId}
	SendMsg:send(msg)
end

--请求加血(岛屿赛)
function MatchMsg:sendHematinicReq(matchId, userId, hp)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.hematinic_req_msg = {
		userid = userId,
		hematinic = hp
	}
	SendMsg:send(msg)
end

--请求复活
function MatchMsg:sendPlayerReliveReq(matchId, userId, brelive)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.playerrelive_req_msg = {userid = userId, relive = brelive
	}
	SendMsg:send(msg)
end

--请求自动注册
function MatchMsg:sendRegisterAutoReq(matchId, passWord)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.registerauto_req_msg = {
		partnerid = 3,
		password = passWord
	}
	SendMsg:send(msg)
end

--请求坐下
function MatchMsg:sendPlayerSitDownReq(matchId, _seat)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.playersitdown_req_msg = {seat = _seat}
	SendMsg:send(msg)
end

--请求补充筹码
function MatchMsg:sendAddHPReq(matchId, _hp)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.addhp_req_msg = {hp = _hp}
	SendMsg:send(msg)
end

--请求下一局旁观
function MatchMsg:sendMarkPlayerIdleReq(matchId, bidle)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.markplayeridle_req_msg = {idle = bidle}
	SendMsg:send(msg)
end

--请求自动补充筹码（散桌赛）
function MatchMsg:sendMarkAutoAddHPReq(matchId, bauto)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.markautoaddhp_req_msg = {autoaddhp = bauto}
	SendMsg:send(msg)
end
	
--请求进入并退出比赛：用于在斗地主的客户端里面，收到了德州扑克的开赛消息时
function MatchMsg:sendExitMatchReq(matchId, _ticket, gameId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.exitmatch_req_msg = {ticket = _ticket, gameid = gameId}
	SendMsg:send(msg)
end

--请求获取当前剩余桌数（锦标赛）
function MatchMsg:sendStageBoutResultReq(matchId, users)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.stageboutresult_req_msg = {}
	msg.match_req_msg.stageboutresult_req_msg.userid = users
	SendMsg:send(msg)
end
	
--请求发送表情或文字ID
function MatchMsg:sendGameSimpleActionReq(matchId, senderUserId, toUserId, emotionId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.gamesimpleaction_req_msg = {useridfrom = senderUserId, useridto = toUserId, emotionid = emotionId}
	SendMsg:send(msg)
end

--获取玩家在round中的排名
function MatchMsg:sendGetRoundPlayerOrderReq(matchId)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.getroundplayerorder_req_msg = {}
	SendMsg:send(msg)
end

--岛屿赛锁定对手请求
function MatchMsg:sendLockDownReq(matchId, seatId, lock)
	local msg = _getMatchReq(matchId)
	msg.match_req_msg.lockdown_req_msg = {seat = seatId, unlock = lock}
	SendMsg:send(msg)
end

-- 请求换桌
function MatchMsg:sendChangeTable(matchid)
	local msg = _getMatchReq(matchid)
	msg.match_req_msg.playerchangetable_req_msg = {}
	SendMsg:send(msg)
end

return MatchMsg