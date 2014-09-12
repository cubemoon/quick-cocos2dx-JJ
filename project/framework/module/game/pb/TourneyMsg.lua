-- Tourney 消息
TourneyMsg = {}

require("game.pb.SendMsg")

local function _getTKMobileReq()
	local msg = {}
	return msg
end

local function _getTourneyReq(gameId)
	local msg = _getTKMobileReq()
	msg.tourney_req_msg = {gameid = gameId}
	return msg
end

--获取tourney list 信息
function TourneyMsg:sendGetTourneyListReq(gameId)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.gettourneylist_req_msg = {}
	SendMsg:send(msg)
end

--获取单个tourney信息
function TourneyMsg:sendGetTourneyReq(gameId, tourneyId)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.gettourney_req_mag = {tourneyid = tourneyId}
	SendMsg:send(msg)
end

--获取比赛人数信息
function TourneyMsg:sendGetTourneyPlayerAmountExReq(gameId)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.gettourneyplayeramountex_req_msg = {}
	SendMsg:send(msg)
end

--获取比赛开赛点信息
function TourneyMsg:sendGetMatchPointReq(gameId, tourneyIds)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.getmatchpoint_req_msg = {tourneyid = tourneyIds}
	SendMsg:send(msg)
end

--获取报名信息
function TourneyMsg:sendGetSignupDataListReq(gameId, tourneyIds)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.getsignupdatalist_req_msg = {tourneyid = tourneyIds}
	SendMsg:send(msg)
end

--获取指定productid的tourney信息
function TourneyMsg:sendGetSpecificTourneyInfoReq(gameId, productId)
	local msg = _getTourneyReq(gameId)
	msg.tourney_req_msg.getspecifictourneyinfo_req_msg = {productid = productId}
	SendMsg:send(msg)
end


return TourneyMsg