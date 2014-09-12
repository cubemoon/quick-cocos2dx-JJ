HttpMsgController = {}
local TAG = "HttpMsgController"

require("game.data.config.MatchConfigManager")
require("game.data.model.NoteManager")
require("game.data.config.MoreGameManager")
require("game.controller.TourneyController")

COMMON_HTTP_ACK = 1
COMMON_HTTP_GET_RANK_IN_MACTCH_ACK = 2
COMMON_HTTP_GET_NOTE_MSG_ACK = 3
COMMON_HTTP_GET_PRI_MSG_ACK = 4
COMMON_HTTP_CHECK_MORE_GAME_ACK = 5
COMMON_HTTP_GET_MORE_GAME_ACK = 6
COMMON_HTTP_GET_WARE_MSG_ACK = 7
COMMON_HTTP_GET_POST_ROAR_ACK = 8
COMMON_HTTP_GET_MATCH_CONFIG_ACK = 9

function HttpMsgController:handleMsg(msg)
	msg[MSG_CATEGORY] = HTTP_ACK_MSG
	local ack = msg.http_ack_msg
	if #ack.commonhttp_ack_msg ~= 0 then
		self:handleCommonHttpAck(msg)
	end
end

function    HttpMsgController:filterMsg(msg)
    JJLog.i(TAG, "filterMsg IN")
    local ret = false
    local ack = msg.http_ack_msg
    if #ack.commonhttp_ack_msg ~= 0 then
		ret = self:filterCommonHttpAck(msg)
	end
    return ret
end

-- 头像
local _handleGetHeadImgAck = function(self, datas, attr)
	JJLog.i(TAG, "_handleGetHeadImgAck")

    if(datas) then
        for index, data in pairs(datas) do
            local url = data.src
            local headId = data.head_id
            if url ~= nil and headId ~= nil then
                HeadImgManager:handleGetImgAck(headId, url)
            end
        end
    end

end

-- 比赛配置
local _handleMatchConfigAck = function(self, datas, attr, msg)
	JJLog.i(TAG, "_handleMatchConfigAck")

	local gameId = nil
    msg[MSG_TYPE] = COMMON_HTTP_GET_MATCH_CONFIG_ACK
    if(datas) then
        for index, matchConfig in pairs(datas) do
            if gameId == nil then
                gameId = matchConfig.gameId
            end
            MatchConfigManager:saveMatchConfig(matchConfig)
            TourneyController:modifyTourneyInfoList(gameId, matchConfig.productId)
        end
    end

	-- 分段的，再获取
	if attr.id == 1 then
		HttpMsg:sendGetMatchConfigReq(gameId, MatchConfigManager:getTimeStamp(gameId))
	end
end

-- 排行榜信息
local _handleGetRankInMatch = function(self, datas, attr, msg)
	JJLog.i(TAG, "_handleGetRankInMatch")
	msg[MSG_TYPE] = COMMON_HTTP_GET_RANK_IN_MACTCH_ACK

    if(datas) then
        local data = datas[1]
        msg.gameid = (attr and attr.gameid) or 0
        msg.rank = (data and data.rank) or 0
        msg.score = (data and data.score) or 0
        msg.userid = (data and data.userid) or 0
    end

end

-- 公告
local _handleGetBroadMessage = function(self, datas, attr, msg)
	JJLog.i(TAG, "_handleGetBroadMessage")
	msg[MSG_TYPE] = COMMON_HTTP_GET_NOTE_MSG_ACK

    if(datas) then
        NoteManager.hasPoped = false
	    NoteManager:saveBroadNoteMsg(datas)
    end

end

-- 私信
local _handleGetPriMessage = function(self, datas, attr, msg)
	JJLog.i(TAG, "_handleGetPriMessage")
	msg[MSG_TYPE] = COMMON_HTTP_GET_PRI_MSG_ACK
    if(datas) then
        --NoteManager.hasPoped = false
	    NoteManager:savePrivateNoteMsg(datas)
    end

end

-- 更多游戏
local _handleCheckMoreGame = function(self, datas, attr, msg)
    JJLog.i(TAG, "_handleCheckMoreGame")
    msg[MSG_TYPE] = COMMON_HTTP_CHECK_MORE_GAME_ACK
    MoreGameManager:handleCPCheckMoreGameAck(datas, attr)
end

local _handleGetMoreGame = function(self, datas, attr, msg)
    JJLog.i(TAG, "_handleGetMoreGame")
    msg[MSG_TYPE] = COMMON_HTTP_GET_MORE_GAME_ACK
    MoreGameManager:handleCPGetMoreGameAck(datas, attr)
end

-- 物品
local _handleGetWareMessage = function(self, datas, attr, msg)
	JJLog.i(TAG, "_handleGetWareMessage")
	msg[MSG_TYPE] = COMMON_HTTP_GET_WARE_MSG_ACK
    if(datas) then
        for index, wareItem in pairs(datas) do
            WareInfoManager:saveWareMsg(wareItem)
        end
    end
    -- 分段的，再获取
    if attr.nextpage == 1 then
        HttpMsg:sendGetWareReq(CONFIG_GAME_ID, tonumber(attr.uptime), 0, false)
    end
end

-- 充值配置
local function _handlePayConfig(self, datas, attr)
    -- 增量更新，所以需要判断是否存在内容
    -- datas存在，attr肯定存在
    if datas or attr then
        local payconfig = require("game.data.config.PayConfigManager")
        if device.platform == "ios" or device.platform == "mac" then
            payconfig:saveIOSConfig(datas)
        else
            payconfig:save(attr.uptime, attr.paytype, attr.paysort, datas)
        end
    end
end

-- 发咆哮接口信息
local _handlePostRoar = function(self, jsonTable, msg)
  JJLog.i(TAG, "_handlePostRoar")
  msg[MSG_TYPE] = COMMON_HTTP_GET_POST_ROAR_ACK
  msg.success = true
  if jsonTable ~= nil and jsonTable.error then
      local error = jsonTable.error
      msg.success = false
      msg.code = jsonTable.error.code --错误码，301是需要提示给用户的
      msg.msg = jsonTable.error.msg --错误提示
  end
end

-- Push
local _handlePushAck = function(self, datas, attr,msg)
    if datas then
        local pushData = require("game.data.push.PushData").new()
        for index, item in pairs(datas) do
            pushData.dataTable[index] = {}
            pushData.dataTable[index].id = item.id              -- 编号，唯一
            pushData.dataTable[index].title = item.title        -- 提示标题
            pushData.dataTable[index].content = item.message    -- 提示内容
            pushData.dataTable[index].timeLine = item.timeline  -- TYPE_AD: 提示时间, KEY_LOCAL: 时间间隔
            pushData.dataTable[index].update = item.created
            JJLog.i(TAG, "_handlePushAck==== ------- = ",pushData.dataTable[index].id,pushData.dataTable[index].title,
                        pushData.dataTable[index].content,pushData.dataTable[index].timeLine,pushData.dataTable[index].update,item.type)

            pushData:addPushItem(item.type, pushData.dataTable[index])
            pushData:init()
        end
    end
end

-- 动态显隐
local _handleDynamicDisplay = function(self, datas, attr,msg)
    if datas or attr then
        local displayManager = require("game.data.config.DynamicDisplayManager")
        displayManager:save(datas)
    end
end

-- 通用协议对应的消息函数表
local commonHttpFun_ = {
	GetHeadimg = _handleGetHeadImgAck,
	getmatchconf = _handleMatchConfigAck,
	getRankInMatch = _handleGetRankInMatch,
	broadmessage = _handleGetBroadMessage,
	directmessage = _handleGetPriMessage,
    getmoregame = _handleGetMoreGame,
    checkmoregame = _handleCheckMoreGame,
	getware = _handleGetWareMessage,
    payconf =  _handlePayConfig,
    postroar = _handlePostRoar,
    getAndroidPushNotes = _handlePushAck,
    getset = _handleDynamicDisplay,
}

local RANK_WHAT_ON_BEGIN = 0
local RANK_WHAT_ON_END = 47
local ROAR_WHAT_ON_BEGIN = 48
local ROAR_WHAT_ON_END = 127
local ROAR_REMIND_WHAT_ON_BEGIN = 91
local ROAR_REMIND_WHAT_ON_END = 93

-- 通用协议处理
function HttpMsgController:handleCommonHttpAck(msg)

	JJLog.i(TAG, "handleCommonHttpAck")
	msg[MSG_TYPE] = COMMON_HTTP_ACK
    local ack = msg.http_ack_msg.commonhttp_ack_msg
    --JJLog.i(TAG, "handleCommonHttpAck 1, ", ack.result)--此处有时log超长，将导致player模拟器出错，调试时请本地打开，提交时请关闭
    local jsonTable = nil
    local jsonStr = ack.result
    if JJZipUtil ~= nil and require("sdk.util.JJFunctionUtil"):exist({ method = JJZipUtil.gzipDecompressStringLua }) and ack.zipresult ~= nil and ack.zipresult ~= "" then
        JJLog.i(TAG, "common ack result is compress")
        jsonStr = JJZipUtil:instance():gzipDecompressStringLua(ack.zipresult, ack.len)
        jsonTable = json.decode(jsonStr)
    else
        jsonTable = json.decode(ack.result)
    end
	if jsonTable ~= nil then
		if jsonTable.datas ~= nil or jsonTable.attr then
			-- local fun = loadstring("return " .. jsonTable.datas)
			-- local datas = fun()
			local datas = jsonTable.datas
			local attr = jsonTable.attr
			local msgId = jsonTable.msgid
			local msgType = HttpMsg:getType(msgId)
            JJLog.i(TAG, "handleCommonHttpAck12 msgType, ", msgType," ,msgId = ",msgId," ,attr=",attr," datas==",datas)
            if msgId and ((tonumber(msgId) > RANK_WHAT_ON_BEGIN) and (tonumber(msgId) < RANK_WHAT_ON_END)) then
				RankInterface:handleRankingHttpAck(jsonStr)
			elseif msgId and ((tonumber(msgId) > ROAR_WHAT_ON_BEGIN) and (tonumber(msgId) < ROAR_WHAT_ON_END)) then
			    if ((tonumber(msgId) >= ROAR_REMIND_WHAT_ON_BEGIN) and (tonumber(msgId) <= ROAR_REMIND_WHAT_ON_END)) then
			        RoarInterface:handleRoarConfigControllerMsg(jsonStr)
			    elseif (msgType == "postroar") then
                  if _handlePostRoar ~= nil then
                       _handlePostRoar(self, jsonTable, msg)
                  end
			    else
			        RoarInterface:handleRoarHttpAck(jsonStr)
			    end
			-- for ios code start
            elseif(msgType == "roar") then
            	-- 咆哮消息json数据处理
            	RoarInterface:handleRoarHttpAck(jsonStr)
            elseif(msgType == "rank") then
                -- 排行榜消息json数据处理
                RankInterface:handleRankingHttpAck(jsonStr)
            -- for ios code end
			else
                local func = commonHttpFun_[msgType]
                if func ~= nil then
                    func(self, datas, attr, msg)
                end
            end
		else
			JJLog.e(TAG, "handleCommonHttpAck, jsonTable.datas is nil")
		end
	end
end

function HttpMsgController:filterCommonHttpAck(msg)
    local ret = false
	JJLog.i(TAG, "filterCommonHttpAck")
	local ack = msg.http_ack_msg.commonhttp_ack_msg
	JJLog.i(TAG, "filterCommonHttpAck 1, ", ack.result)
	local jsonTable = json.decode(ack.result)
	if jsonTable ~= nil then
		if jsonTable.datas ~= nil or jsonTable.attr then
			local msgId = jsonTable.msgid
			local msgType = HttpMsg:getType(msgId)
            JJLog.i(TAG, "filterCommonHttpAck msgId, ", tonumber(msgId))
			if ((tonumber(msgId) > RANK_WHAT_ON_BEGIN) and (tonumber(msgId) < RANK_WHAT_ON_END)) then
				RankInterface:handleRankingHttpAck(ack.result)
                ret = true
			elseif ((tonumber(msgId) > ROAR_REMIND_WHAT_ON_BEGIN) and (tonumber(msgId) < ROAR_WHAT_ON_END)) then
				if ((tonumber(msgId) >= ROAR_REMIND_WHAT_ON_BEGIN) and (tonumber(msgId) <= ROAR_REMIND_WHAT_ON_END)) then
           RoarInterface:handleRoarConfigControllerMsg(ack.result)
        else
           RoarInterface:handleRoarHttpAck(ack.result)
        end
                ret = true
			end
		else
			JJLog.e(TAG, "filterCommonHttpAck, jsonTable.datas is nil")
		end
	end
    return ret
end



