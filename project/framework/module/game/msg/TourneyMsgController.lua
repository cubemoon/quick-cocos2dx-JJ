-- tourney消息处理文件

TourneyMsgController = {}
require("game.controller.TourneyController")
require("game.data.lobby.MatchPointManager")
require("game.data.lobby.DynamicTimeMatchManager")
require("game.data.config.MatchConfigManager")
require("game.data.config.WareInfoManager")
require("game.data.config.GrowInfoManager")
require("game.data.model.SignupStatusManager")
require("game.data.model.EntryFeeItem")
require("game.def.MatchDefine")

local TourneyChangeMsg = require("game.message.TourneyChangeMsg")
local TAG = "TourneyMsgController"
local receiveAmountMsg = false

--  Tourney ack msg
GET_TOURNEY_LIST_ACK = 1
GET_TOURNEY_ACK = 2
GET_TOURNEY_PLAYERCOUNT_ACK = 3
GET_TOURNEY_MATCHPOINT = 4
GET_TOURNEY_SIGNUPDATA_LIST = 5

function TourneyMsgController:handleMsg(msg)
	JJLog.i(TAG, "handleMsg")
	msg[MSG_CATEGORY] = TOURNEY_ACK_MSG
	local tourney = msg.tourney_ack_msg
	if #tourney.gettourneylist_ack_msg ~= 0 then
		self:handleGetTourneyListAck(msg)

	elseif #tourney.gettourney_ack_mag ~= 0 then
		self:handleGetTourneyAck(msg)

	elseif #tourney.gettourneyplayeramountex_ack_msg ~= 0 then
		self:handleGetTourneyPlayerAmountexAck(msg)

	elseif #tourney.getmatchpoint_ack_msg ~= 0 then
		self:handleGetMatchPointAck(msg)

	elseif #tourney.getsignupdatalist_ack_msg ~= 0 then
		self:handleGetSignupDataListAck(msg)

	end

end

-- 处理tourneyListAck 消息
function TourneyMsgController:handleGetTourneyListAck(msg)
	msg[MSG_TYPE] = GET_TOURNEY_LIST_ACK
	local tourneyList = msg.tourney_ack_msg.gettourneylist_ack_msg.tourneylist
	for i = 1, #tourneyList do
		-- 此句为了能完全解析出protobuf内容(protobuf 动态解析)
		local tourneyId = tourneyList[i].tourneyid
	end
	TourneyController:setTourneys(msg.tourney_ack_msg.gameid, tourneyList)
end

-- 处理tourneytAck 消息
function TourneyMsgController:handleGetTourneyAck(msg)
	msg[MSG_TYPE] = GET_TOURNEY_ACK
	local tourneydata = msg.tourney_ack_msg.gettourney_ack_mag.tourneydata
end

-- 处理tourneyPlayerAmountex 消息
function TourneyMsgController:handleGetTourneyPlayerAmountexAck(msg)
	local exmsg = TourneyChangeMsg.new()

	msg[MSG_TYPE] = GET_TOURNEY_PLAYERCOUNT_ACK
	local a_list = {}
	local playerAmountList = msg.tourney_ack_msg.gettourneyplayeramountex_ack_msg.amountlist
	for i = 1, #playerAmountList do
		local tourneyId = playerAmountList[i].tourneyid
		table.insert(exmsg.tourneyIdList_, tourneyId)
		a_list[i] = playerAmountList[i]
	end
	TourneyController:setPlayerAmount(msg.tourney_ack_msg.gameid, playerAmountList)
	if not receiveAmountMsg then
		receiveAmountMsg = true
		signupedItemList = SignupStatusManager:getSignupedItemList()
		if signupedItemList ~= nil then
			for k, item in pairs(signupedItemList) do
				local tourneyId = item.tourneyId_
				tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
				tourneyInfo.status_ = MatchDefine.STATUS_SIGNOUTABLE	
				tourneyInfo.matchStartTime_ = item.startTime_
				table.insert(exmsg.tourneyIdList_, tourneyId)	
			end			
		end
	end
    JJSDK:pushMsgToSceneController(exmsg)
end

-- 处理tourneyMatchPoint 消息
function TourneyMsgController:handleGetMatchPointAck(msg)
	local exmsg = TourneyChangeMsg.new()

	msg[MSG_TYPE] = GET_TOURNEY_MATCHPOINT
	local tourneyMatchPointList = msg.tourney_ack_msg.getmatchpoint_ack_msg.tourneymatchpointlist
	for i = 1, #tourneyMatchPointList do
		local tourneyId = tourneyMatchPointList[i].tourneyid
		table.insert(exmsg.tourneyIdList_, tourneyId)
		for j = 1, #tourneyMatchPointList[i].matchpointlist do
			local matchPoint = tourneyMatchPointList[i].matchpointlist[j].matchpoint
		end
	end
	TourneyController:setMatchPoint(msg.tourney_ack_msg.gameid,tourneyMatchPointList)
    JJSDK:pushMsgToSceneController(exmsg)
end

-- 处理tourneySignupDataList 消息
function TourneyMsgController:handleGetSignupDataListAck(msg)
	msg[MSG_TYPE] = GET_TOURNEY_SIGNUPDATA_LIST
	local signupdatalist = msg.tourney_ack_msg.getsignupdatalist_ack_msg.tourneysignupdatalist
	for i = 1, #signupdatalist do
		local tourneyId = signupdatalist[i].tourneyid
		for j = 1, #signupdatalist[i].growlist do
			--完全解析出protobuf内容
			local growId = signupdatalist[i].growlist[j].growid
		end
		for j = 1, #signupdatalist[i].warelist do
			local waretypeId = signupdatalist[i].warelist[j].waretypeid
		end
		for j = 1, #signupdatalist[i].matchsignuplist do
			local signupType = signupdatalist[i].matchsignuplist[j].signuptype
			for k = 1, #signupdatalist[i].matchsignuplist[j].growlist do
				local growId = signupdatalist[i].matchsignuplist[j].growlist[k].growid
			end
			for k = 1, #signupdatalist[i].matchsignuplist[j].warelist do
				local wareTypeId = signupdatalist[i].matchsignuplist[j].warelist[k].waretypeid
			end
		end
	end
	TourneyController:setSignupData(signupdatalist)
end

-- function 
