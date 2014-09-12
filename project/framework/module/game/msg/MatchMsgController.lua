-- matchmsg 处理文件

MatchMsgController = {}
require("game.data.model.StartedMatchManager")
local TAG = "MatchMsgController :"

--  match ack msg
ENTER_MATCH_ACK = 1
ENTER_ROUND_ACK = 2
EXIT_GAME_ACK = 3
PUSH_USERORDER_ACK = 4
CONTINUE_ACK = 5
LEAVE_ACK = 6
HEMATINIC_ACK = 7
PLAYER_RELIVE_ACK = 8
REGISTERAUTO_ACK = 9
PLAYER_SITDOWN_ACK = 10
ADDHP_ACK = 11
MARK_PLAYER_IDLE_ACK = 12
MARK_AUTO_ADDHP_ACK = 13
START_TABLE_ACCEPT_INVITE_ACK = 14
TIP_MSG_ACK = 15
PUSH_MATCH_STAGE_ACK = 16
STAGEPLAYER_ORDER_ACK = 17
ROUND_PLAYER_ACK = 18
PUSH_MATCH_PLAYERINFO_ACK = 19
ADD_GAMEPLAYERINFO_ACK = 20
PUSH_RULERINFO_ACK = 21
BEGIN_HAND_ACK = 22
RULER_INFO_ACK = 23
PLAYER_ORDER_CHANGE_ACK = 24
NOQUERY_EXIT_GAME_ACK = 25
PUSH_MATCH_AWARD = 26
SCORE_BASE_RAISE_ACK = 27
CHANGE_GAME_RULERNOTE_ACK = 28
REST_ACK = 29
RELIVE_COST_ACK = 30
PUSH_GAME_COUNT_AWARDINFO_ACK = 31
PUSH_PLAYER_GAME_DATA_ACK = 32
NOTIFY_GUEST_REGISTER_ACK = 33
NETBREAK_ACK = 34
NETRESUME_ACK = 35
HISTORY_BEGIN_ACK = 36
HISTORY_END_ACK = 37
HAND_OVER_ACK = 38
OVER_GAME_ACK = 39
INIT_GAMETABLE_ACK = 40
STAGEBOUT_RESULT_ACK = 41
GAME_SIMPLE_ACTION_ACK = 42
LOCK_DOWN_ACK = 43
MARD_LOCK_DOWN_ACK = 44
RULERINFOEX_ACK = 45
CVAWARDINFO_ACK = 46
CVAWARD_ACK = 47
GAME_JACKPOT_ACK = 48
GAME_JACKPOT_COUNT_ACK = 49
GAME_JACKPOT_WINNER_ACK = 50
GAME_PLAYER_ARRIVED_ACK = 51
EXCHANGE_ISLAND_ACK = 52 -- 岛屿赛加血设置
MATCH_OPTION_ACK = 53 -- 比赛选项


function MatchMsgController:handleMsg(msg, gameId)
    JJLog.i(TAG, "MatchMsgController:handleMsg")
    msg[MSG_CATEGORY] = MATCH_ACK_MSG
    local matchmsg = msg.match_ack_msg
    local matchData = StartedMatchManager:getMatch(matchmsg.matchid)

    if not matchData then
        JJLog.i("MatchMsgController", "MatchMsgController:handleMsg match data is nil")
    elseif #matchmsg.entermatch_ack_msg ~= 0 then
        self:handleEnterMatchAck(msg, matchData, gameId)
    elseif #matchmsg.enterround_ack_msg ~= 0 then
        self:handleEnterRoundAck(msg, matchData, gameId)

    elseif #matchmsg.exitgame_ack_msg ~= 0 then
        self:handleExitGameAck()

    elseif #matchmsg.pushuserplaceorderposition_ack_msg ~= 0 then
        self:handlePushUserPlaceOrderPosition(msg, matchData, gameId)

    elseif #matchmsg.continue_ack_msg ~= 0 then
        self:handleContinueAck(msg, matchData, gameId)

    elseif #matchmsg.leave_ack_msg ~= 0 then
        self:handleLeaveAck(msg, matchData, gameId)

    elseif #matchmsg.hematinic_ack_msg ~= 0 then
        self:handleHematinicAck(msg, matchData, gameId)

    elseif #matchmsg.playerrelive_ack_msg ~= 0 then
        self:handlePlayerReliveAck(msg, matchData, gameId)

    elseif #matchmsg.registerauto_ack_msg ~= 0 then
        self:handleRegisterAutoAck(msg, matchData, gameId)

    elseif #matchmsg.playersitdown_ack_msg ~= 0 then
        self:handlePlayerSitDownAck(msg, matchData, gameId)

    elseif #matchmsg.addhp_ack_msg ~= 0 then
        self:handleAddHpAck(msg, matchData, gameId)

    elseif #matchmsg.markplayeridle_ack_msg ~= 0 then
        self:handleMarkPlayerIdleAck(msg, matchData, gameId)

    elseif #matchmsg.markautoaddhp_ack_msg ~= 0 then
        self:handleMardAutoAddHPAck(msg, matchData, gameId)

    elseif #matchmsg.tipmsg_ack_msg ~= 0 then
        self:handleTipMsgAck(msg, matchData, gameId)

    elseif #matchmsg.pushmatchstageposition_ack_msg ~= 0 then
        self:handlePushMatchStagePositionAck(msg, matchData, gameId)

    elseif #matchmsg.stageplayerorder_ack_msg ~= 0 then
        self:handleStagePlayerOrderAck(msg, matchData, gameId)

    elseif #matchmsg.roundplayerorder_ack_msg ~= 0 then
        self:handleRoundPlayerOrderAck(msg, matchData, gameId)

    elseif #matchmsg.pushmatchplayerinfo_ack_msg ~= 0 then
        self:handlePushMatchPlayerInfoAck(msg, matchData, gameId)

    elseif #matchmsg.addgameplayerinfo_ack_msg ~= 0 then
        self:handleAddGamePlayerInfoAck(msg, matchData, gameId)

    elseif #matchmsg.pushroundrulerinfo_ack_msg ~= 0 then
        self:handlePushRoundRulerInfoAck(msg, matchData, gameId)

    elseif #matchmsg.beginhand_ack_msg ~= 0 then
        self:handleBeginHandAck(msg, matchData, gameId)

    elseif #matchmsg.rulerinfo_ack_msg ~= 0 then
        self:handleRulerInfoAck(msg, matchData, gameId)

    elseif #matchmsg.stageplayerorderchanged_ack_msg ~= 0 then
        self:handleStagePlayerOrderChangeAck(msg, matchData, gameId)

    elseif #matchmsg.noqueryexitgame_ack_msg ~= 0 then
        self:handleNoqueryExitGameAck(msg, matchData, gameId)

    elseif #matchmsg.pushmatchaward_ack_msg ~= 0 then
        self:handlePushMatchAwardAck(msg, matchData, gameId)

    elseif #matchmsg.scorebaseraise_ack_msg ~= 0 then
        self:handleScoreBaseRaiseAck(msg, matchData, gameId)

    elseif #matchmsg.changegamerulernote_ack_msg ~= 0 then
        self:handleChangeGameRulerNoteAck(msg, matchData, gameId)

    elseif #matchmsg.rest_ack_msg ~= 0 then
        self:handleRestAck(msg, matchData, gameId)

    elseif #matchmsg.relivecost_ack_msg ~= 0 then
        self:handleReliveCostAck(msg, matchData, gameId)

    elseif #matchmsg.pushgamecountawardinfo_ack_msg ~= 0 then
        self:handlePushGameCountAwardInfoAck(msg, matchData, gameId)

    elseif #matchmsg.pushplayergamedata_ack_msg ~= 0 then
        self:handlePushPlayerGameDataAck(msg, matchData, gameId)

    elseif #matchmsg.notifyguestregister_ack_msg ~= 0 then
        self:handleNotifyGuestRegisterAck(msg, matchData, gameId)

    elseif #matchmsg.netbreak_ack_msg ~= 0 then
        self:handleNetBreakAck(msg, matchData, gameId)

    elseif #matchmsg.netresume_ack_msg ~= 0 then
        self:handleNetResumeAck(msg, matchData, gameId)

    elseif #matchmsg.historymsgbegin_ack_msg ~= 0 then
        self:handleHistoryMsgBeginAck(msg, matchData, gameId)

    elseif #matchmsg.historymsgend_ack_msg ~= 0 then
        self:handleHistoryMsgEndAck(msg, matchData, gameId)

    elseif #matchmsg.handover_ack_msg ~= 0 then
        self:handleHandOverAck(msg, matchData, gameId)

    elseif #matchmsg.overgame_ack_msg ~= 0 then
        self:handleOverGameAck(msg, matchData, gameId)

    elseif #matchmsg.initgametable_ack_msg ~= 0 then
        self:handleInitGameTableAck(msg, matchData, gameId)

    elseif #matchmsg.stageboutresult_ack_msg ~= 0 then
        self:handleStageBoutResultAck(msg, matchData, gameId)

    elseif #matchmsg.gamesimpleaction_ack_msg ~= 0 then
        self:handleGameSimpleActionAck(msg, matchData, gameId)

    elseif #matchmsg.gamecvawardinfo_ack_msg ~= 0 then
        self:handleGameCVAwardInfoAck(msg, matchData, gameId)

    elseif #matchmsg.gamecvaward_ack_msg ~= 0 then
        self:handleGameCVAwardAck(msg, matchData, gameId)

    elseif #matchmsg.lockdown_ack_msg ~= 0 then
        self:handleLockDownAck(msg, matchData, gameId)

    elseif #matchmsg.marklockdown_ack_msg ~= 0 then
        self:handleMarkLockDownAck(msg, matchData, gameId)

    elseif #matchmsg.rulerinfoex_ack_msg ~= 0 then
        self:handleRulerInfoExAck(msg, matchData, gameId)

    elseif #matchmsg.gamejackpot_ack_msg ~= 0 then
        self:handleGameJackpotAck(msg, matchData, gameId)

    elseif #matchmsg.gamejackpotcount_ack_msg ~= 0 then
        self:handleGameJackpotCountAck(msg, matchData, gameId)

    elseif #matchmsg.gamejackpotwinner_ack_msg ~= 0 then
        self:handleGameJackpotWinnerAck(msg, matchData, gameId)

    elseif #matchmsg.gameplayerarrived_ack_msg ~= 0 then
        self:handleGamePlayerArrivedAck(msg, matchData, gameId)

    elseif #matchmsg.matchoption_ack_msg ~= 0 then
        msg[MSG_TYPE] = MATCH_OPTION_ACK
        self:passMessageToGameController(msg, gameId)

    elseif #matchmsg.exchangeisland_ack_msg ~= 0 then
        msg[MSG_TYPE] = EXCHANGE_ISLAND_ACK
        self:passMessageToGameController(msg, gameId)

    else
        JJLog.i(TAG, "unknown msg")
    end
end

-- 进入比赛消息处理
function MatchMsgController:handleEnterMatchAck(msg, matchData, gameId)
    msg[MSG_TYPE] = ENTER_MATCH_ACK
    local ack = msg.match_ack_msg.entermatch_ack_msg

    matchData.matchId_ = ack.matchid
    matchData.matchName_ = ack.matchname
    matchData.startTime_ = ack.matchstarttime
    matchData.serverStartTime_ = ack.matchstarttime
    if ack.totalmatchplayer ~= 0 then
        matchData.totalMatchPlayer_ = ack.totalmatchplayer
    end
    self:passMessageToGameController(msg, gameId)
end

--进入局制处理函数
function MatchMsgController:handleEnterRoundAck(msg, matchData, gameId)
    msg[MSG_TYPE] = ENTER_ROUND_ACK
    local ack = msg.match_ack_msg.enterround_ack_msg

    matchData.tablePlayers_ = {}
    matchData.seat_ = ack.seatorder
    matchData.userType_ = ack.usertype

    self:passMessageToGameController(msg, gameId)
end

-- [[当前玩家排名：这个只会告诉 当前名次 和 玩家总数]]
function MatchMsgController:handlePushUserPlaceOrderPosition(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_USERORDER_ACK
    local ack = msg.match_ack_msg.pushuserplaceorderposition_ack_msg
    matchData.leavePlayer_ = ack.totalplayercount
    matchData.rank_ = ack.playercurplaceorder
    JJLog.i("handlePushUserPlaceOrderPosition12------- = ", ack.playercurplaceorder, ack.totalplayercount)
    self:passMessageToGameController(msg, gameId)
end

-- [[岛屿赛继续处理函数]]
function MatchMsgController:handleContinueAck(msg, matchData, gameId)
    msg[MSG_TYPE] = CONTINUE_ACK
    local ack = msg.match_ack_msg.continue_ack_msg
    ack.success_ = not msg.param or msg.param == 0

    if ack.success_ then
        local gd = GameDataContainer:getGameData(matchData.matchId_)
        if gd then gd.islandWait_ = false end
    end
    --self:passMessageToGameController(msg, gameId)
end

-- [[离开岛屿赛消息处理函数]]
function MatchMsgController:handleLeaveAck(msg, matchData, gameId)
    msg[MSG_TYPE] = LEAVE_ACK
    require("game.data.lobby.LobbyData").inLobby = true --设置用户状态，用来确定是否更新MatchPoint
end

-- 加血消息（岛屿赛）处理
function MatchMsgController:handleHematinicAck(msg, matchData, gameId)
    msg[MSG_TYPE] = HEMATINIC_ACK
    local ack = msg.match_ack_msg.hematinic_ack_msg
    ack.success_ = not (msg.param and msg.param == 1) or false

    if ack.success_ and matchData.islandData_ then
        matchData.islandData_.life_ = matchData.islandData_.life_ + ack.hematinic
    end

    self:passMessageToGameController(msg, gameId)
end

-- 复活消息处理
function MatchMsgController:handlePlayerReliveAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PLAYER_RELIVE_ACK
    local ack = msg.match_ack_msg.playerrelive_ack_msg
    if (msg.param and msg.param == 0) or not msg.param then
        ack.success = true
    else
        ack.success = false
    end
end

--自动注册消息处理
function MatchMsgController:handleRegisterAutoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = REGISTERAUTO_ACK
    local nickName = msg.match_ack_msg.registerauto_ack_msg.nickname
end

--坐下(德州才有)消息处理
function MatchMsgController:handlePlayerSitDownAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PLAYER_SITDOWN_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[补充筹码（散桌赛）]]
function MatchMsgController:handleAddHpAck(msg, matchData, gameId)
    msg[MSG_TYPE] = ADDHP_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[下一局旁观]]
function MatchMsgController:handleMarkPlayerIdleAck(msg, matchData, gameId)
    msg[MSG_TYPE] = MARK_PLAYER_IDLE_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[自动补充筹码]]
function MatchMsgController:handleMardAutoAddHPAck(msg, matchData, gameId)
    msg[MSG_TYPE] = MARK_AUTO_ADDHP_ACK
    self:passMessageToGameController(msg, gameId)
end

--服务器下发的提示信息
function MatchMsgController:handleTipMsgAck(msg, matchData, gameId)
    msg[MSG_TYPE] = TIP_MSG_ACK
    local ack = msg.match_ack_msg.tipmsg_ack_msg
    local text = ack.text

    if text and string.len(text) > 0 then
        --由于服务器发来的字串会带有 \0，转化时会出现乱码，所以去掉末尾的 \0
        if string.byte(string.sub(text, -1)) == 0 then
            text = string.sub(text, 1, -2)
        end

        --天降喜金的消息会有 <a></a> 这个标签，去掉
        text = string.gsub(text, "<a>", "")
        text = string.gsub(text, "</a>", "")

        ack.text = text
        --JJLog.i("linxh", "tip msg=", text)
        local gd = GameDataContainer:getGameData(msg.match_ack_msg.matchid)
        if gd and gd.promotionView_ then
            local st = string.find(ack.text, "本局已结束，请稍候，其他桌结束后进行总排名确定晋级者")
            if not st then st = string.find(ack.text, "您已完成加赛") end
            if not st then 
                st = string.find(ack.text, "出局人数已满") 
                if st and string.find(ack.text, "将加赛") then --防止加赛
                    st = nil
                end
            end
            
            if not st then st = string.find(ack.text,  "您已率先完成本轮，处于本桌第") end
            if not st and (gameId == JJGameDefine.GAME_ID_LORD_LZ
                    or gameId == JJGameDefine.GAME_ID_LORD_PK) then                
                --if not st then st = string.find(ack.text, "您已率先完成本轮，处于本桌第2名") end
                --if not st then st = string.find(ack.text, "您已率先完成本轮，处于本桌第3名") end
                st = string.find(ack.text, "本局已结束，您处于本桌第3名。很遗憾，您被淘汰出局了")
            end

            if not st and
                    (gameId == JJGameDefine.GAME_ID_MAHJONG_BR
                     or gameId == JJGameDefine.GAME_ID_RUNFAST) then
                st = string.find(ack.text, "您已率先完成本轮，请等候其他玩家打完后进行排名并决定晋级者")
            end

            if st then gd.promotion_ = true end
        end
    end
end

--[[比赛排名消息]]
function MatchMsgController:handlePushMatchStagePositionAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_MATCH_STAGE_ACK
    local ack = msg.match_ack_msg.pushmatchstageposition_ack_msg
    local stageName = ack and ack.stagename
    local boutName = ack and ack.boutname

    local index = 0
    repeat
        index = string.find(stageName, "%.", index + 1)
        if index and index > 0 and index < string.len(stageName) then
            matchData.stageBoutTableNo_ = tonumber(string.sub(stageName, index + 1))
        end
    until (index == nil)

    if boutName and string.len(boutName) >= 3 then
        matchData.roundCount_ = tonumber(string.sub(boutName, 2, -2))
    end
end

-- Stage 里面的排名信息
function MatchMsgController:handleStagePlayerOrderAck(msg, matchData, gameId)
    msg[MSG_TYPE] = STAGEPLAYER_ORDER_ACK
    matchData:setMatchPlayers(msg.match_ack_msg.stageplayerorder_ack_msg.orderlist)
end

--[[本牌桌上的玩家比赛名次列表更新
]]
function MatchMsgController:handleRoundPlayerOrderAck(msg, matchData, gameId)
    msg[MSG_TYPE] = ROUND_PLAYER_ACK
    --设置自己桌三位用户的名次
    matchData:setRoundPlayerOrder(msg.match_ack_msg.roundplayerorder_ack_msg.orderlist)
end

--[[下发此桌的参赛人物信息（3人 PK 的战绩等，目前用于判断是否处于晋级等待了）]]
function MatchMsgController:handlePushMatchPlayerInfoAck(msg, matchData, gameId)
    --目前配置有问题，对于只有一轮的比赛，上来就是决赛轮直接就发该消息导致进入晋级等待
    --[[msg[MSG_TYPE] = PUSH_MATCH_PLAYERINFO_ACK

    if (gameId ~= JJGameDefine.GAME_ID_LORD_LZ)
            and (gameId ~= JJGameDefine.GAME_ID_LORD_PK)
            and (gameId ~= JJGameDefine.GAME_ID_THREE_CARD) then
        local gd = GameDataContainer:getGameData(msg.match_ack_msg.matchid)
        --JJLog.i("linxh", "MatchMsgController:handlePushMatchPlayerInfoAck")
        if gd and gd.promotionView_ then gd.promotion_ = true end
        --self:passMessageToGameController(msg,gameId) --需要根据此消息判断是否晋级等待
    end]]
end

--下发此桌的玩家信息
function MatchMsgController:handleAddGamePlayerInfoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = ADD_GAMEPLAYERINFO_ACK
    matchData:addTablePlayer(msg.match_ack_msg.addgameplayerinfo_ack_msg.playerinfo)
    self:passMessageToGameController(msg, gameId)
end

--[[局制信息：赛制等的 xml
]]
function MatchMsgController:handlePushRoundRulerInfoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_RULERINFO_ACK
    local rulerInfo = msg.match_ack_msg.pushroundrulerinfo_ack_msg.rulerinfo
    if rulerInfo then
        matchData.roundInfo_ = require("game.data.match.RoundInfo"):initWithXml(rulerInfo)
    end
    self:passMessageToGameController(msg, gameId)
    --[[local rulerInfo = <Round id="8" type="1" BoutID="1" TableID="8" GameID="1" APRP="1">
  <l name="积分方式" value="积分"/>
  <l name="游戏基数" value="100"/>
  <l name="局制名称" value="2局积分制"/>
  <l name="Note" value="2局积分最高者获胜.共 4 轮"/>
  </Round>
  local res = require("game.data.match.RoundInfo"):initWithXml(rulerInfo)
  JJLog.i("linxh", vardump(res, "roundinfo"))]]
end

--[[一把开始了消息处理]]
function MatchMsgController:handleBeginHandAck(msg, matchData, gameId)
    finishThirdActivityLua()
    msg[MSG_TYPE] = BEGIN_HAND_ACK

    --重置岛屿要求休息的数据，根据此来判断这局比赛是否要求休息了
    matchData.islandData_ = nil
    matchData.awardData_ = nil
    -- 更新排名信息
    MatchMsg:sendPushUserPlaceOrderPositionReq(msg.match_ack_msg.matchid)
    --JJLog.i("handleBeginHandAck8900000000000-----")

    self:changeToPlayState(msg.match_ack_msg.matchid)

    self:passMessageToGameController(msg, gameId)
end

--[[游戏时间、JJ 炸弹规则等]]
function MatchMsgController:handleRulerInfoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = RULER_INFO_ACK
    matchData.scoreBase_ = msg.match_ack_msg.rulerinfo_ack_msg.scorebase
    self:passMessageToGameController(msg, gameId)
end

--[[仅仅通知比赛名次发生变化，客户端自行决定是否要去主动更新名次数据]]
function MatchMsgController:handleStagePlayerOrderChangeAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PLAYER_ORDER_CHANGE_ACK
end

--[[服务器要求玩家退离比赛，服务器端会直接断开连接]]
function MatchMsgController:handleNoqueryExitGameAck(msg, matchData, gameId)
    msg[MSG_TYPE] = NOQUERY_EXIT_GAME_ACK
end

--奖状信息消息处理
function MatchMsgController:handlePushMatchAwardAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_MATCH_AWARD
    local awardText = msg.match_ack_msg.pushmatchaward_ack_msg.awardtext
    local awardData = require("game.data.match.MatchAwardData").new()
    awardData:initWithXml(awardText, UserInfo.nickname_)
    matchData.awardData_ = awardData

    if not Util:isAppActive() then
        local RoarInterface = require("game.thirds.RoarInterface")
        RoarInterface:exitRoar()
        local RankInterface = require("game.thirds.RankInterface")
        RankInterface:exitRank()
    end

    local gd = GameDataContainer:getGameData(matchData.matchId_)
    if gd then
        gd.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
        gd:setAward(true)

        --如果应用在后台，发送 Notification 消息
        if not Util:isAppActive() then
            local JJNotificationManager = require("game.alarm.JJNotificationManager")
            JJNotificationManager:setNotification(JJNotificationManager.NOTIFICATION_TYPE_GAME_OVER)
        end
    end
    --self:passMessageToGameController(msg, gameId) --需要根据此消息判断是否奖状等待
end

--[[游戏基数增加消息处理]]
function MatchMsgController:handleScoreBaseRaiseAck(msg, matchData, gameId)
    msg[MSG_TYPE] = SCORE_BASE_RAISE_ACK
    matchData.scoreBase_ = msg.match_ack_msg.scorebaseraise_ack_msg.newscorebase
end

--[[游戏规则改变消息处理]]
function MatchMsgController:handleChangeGameRulerNoteAck(msg, matchData, gameId)
    msg[MSG_TYPE] = CHANGE_GAME_RULERNOTE_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[岛屿赛休息]]
function MatchMsgController:handleRestAck(msg, matchData, gameId)
    msg[MSG_TYPE] = REST_ACK

    local ack = msg.match_ack_msg.rest_ack_msg
    local islandData = require("game.data.match.IslandData").new()
    islandData.life_ = ack.life
    islandData.coin_ = ack.coin
    islandData.restTime_ = ack.resttime
    islandData.gamesCount_ = ack.gamescount
    islandData.multi_ = ack.multi
    islandData.nextLevelGames_ = ack.nextlevelgames
    islandData.nextLevelMulti_ = ack.nextlevelmulti
    islandData.awardTimeSpan_ = ack.awardtimespan
    islandData.nextAwardLeftSecond_ = ack.nextawardleftsecond
    islandData.startTime_ = JJTimeUtil:getCurrentSecond()

    if ack.hematiniclist then
        islandData.bottles_ = {} --数据接口和ack.hematiniclist一样
        local bt
        for i, ht in ipairs(ack.hematiniclist) do
            bt = {}
            bt.blood = ht.blood
            bt.cost = ht.cost
            islandData.bottles_[i] = bt
        end
    end

    if ack.coin > 0 then
        islandData.exchangeRate_ = ack.life / ack.coin
    elseif ack.exchangerate > 0 then
        islandData.exchangeRate_ = 10000 / ack.exchangerate
    else
        islandData.exchangeRate_ = 0
    end

    matchData.islandData_ = islandData

    local gd = GameDataContainer:getGameData(matchData.matchId_)
    if gd then
        gd.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
        gd.islandWait_ = true
    end
    --self:passMessageToGameController(msg, gameId)
end

--服务器下发复活条件
function MatchMsgController:handleReliveCostAck(msg, matchData, gameId)
    msg[MSG_TYPE] = RELIVE_COST_ACK
    local ack = msg.match_ack_msg.relivecost_ack_msg
    if ack then
        local rd = {} --数据结构和ack一样
        --检查用户是否满足复活条件
        rd.score = ack.score
        rd.liveplayercount = ack.liveplayercount
        rd.timeout = ack.timeout
        rd.relivable = false

        if ack.costtype == 1 then --货币复活
            if ack.costid == 2 then --金币
                rd.cost = string.format("%d金币", ack.amount)
                rd.relivable = UserInfo.gold_ >= ack.amount
            elseif ack.costid == 4 then --参赛积分
                rd.cost = string.format("%d参赛积分", ack.amount)
                rd.relivable = UserInfo.cert_ >= ack.amount
            end
        elseif ack.costtype == 1 then --物品复活
            local name = require("game.data.config.WareInfoManager"):getWareName(ack.costid)
            rd.cost = string.format("%d%s", ack.amount, name)
            rd.relivable = UserInfo:getWareCount(ack.costid) >= ack.amount
        end

        matchData.reliveData_ = rd

        local gd = GameDataContainer:getGameData(msg.match_ack_msg.matchid)
        if gd then gd.relive_ = true end
    end
end

--[[
GameCountAwardInfoItem&GameCountAwardInfoRuler
]]
function MatchMsgController:handlePushGameCountAwardInfoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_GAME_COUNT_AWARDINFO_ACK
    local text = msg.match_ack_msg.pushgamecountawardinfo_ack_msg.text
    --[[test data
    <GameCountAward>
  <Item id="1" name="积分加倍" style="2" Note="最高1倍">
  <Ruler name="1倍积分" min="200" max="400"/>
  <Ruler name="2倍积分" min="500" max="1000"/>
  </Item>
  <Item id="2" name="双赢翻番" style="1" Note="最高4倍">
  <Ruler name="3倍积分" min="200" max="400"/>
  </Item>
  </GameCountAward>
    ]]
    if text then
        matchData.gameCountAwardInfo_ = require("game.data.match.GameCountAwardInfoItem"):initWithXml(text)
    end
    self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:handlePushPlayerGameDataAck(msg, matchData, gameId)
    msg[MSG_TYPE] = PUSH_PLAYER_GAME_DATA_ACK
    matchData.finishCount = msg.match_ack_msg.pushplayergamedata_ack_msg.totalfinishedgamecount
    self:passMessageToGameController(msg, gameId)
end

--[[提示玩家注册]]
function MatchMsgController:handleNotifyGuestRegisterAck(msg, matchData, gameId)
    msg[MSG_TYPE] = NOTIFY_GUEST_REGISTER_ACK
    local ack = msg.match_ack_msg.notifyguestregister_ack_msg
    if ack.autoregister then --是否允许注册：如果不允许的话，就是把用户退出这个比赛了
        self:passMessageToGameController(msg, gameId)
    end
end

--[[游戏中用户网络断开提示消息]]
function MatchMsgController:handleNetBreakAck(msg, matchData, gameId)
    msg[MSG_TYPE] = NETBREAK_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[游戏中用户网络恢复提示消息]]
function MatchMsgController:handleNetResumeAck(msg, matchData, gameId)
    msg[MSG_TYPE] = NETRESUME_ACK
    self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:judgeSetWaitState(gameData)
    if gameData:playNot2Wait() then
        --德州、赢三张等比赛不进入wait界面
    else
        gameData.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
    end
end

--[[历史消息开始：历史消息这一段会把这一局之前的消息都重新发送一次]]
function MatchMsgController:handleHistoryMsgBeginAck(msg, matchData, gameId)
    msg[MSG_TYPE] = HISTORY_BEGIN_ACK

    local gd = GameDataContainer:getGameData(matchData.matchId_)
    if gd then
        gd.history_ = true
        self:judgeSetWaitState(gd)
    end

    --self:passMessageToGameController(msg,gameId)
end

--[[历史消息结束]]
function MatchMsgController:handleHistoryMsgEndAck(msg, matchData, gameId)
    msg[MSG_TYPE] = HISTORY_END_ACK
    local gd = GameDataContainer:getGameData(matchData.matchId_)
    if gd then
        gd.history_ = false
        gd.isOffline_ = true --记录是否是断线重连
    end
    --self:passMessageToGameController(msg, gameId)
end

--一把结束
function MatchMsgController:handleHandOverAck(msg, matchData, gameId)
    msg[MSG_TYPE] = HAND_OVER_ACK
    local gd = GameDataContainer:getGameData(matchData.matchId_)
    if gd then
        self:judgeSetWaitState(gd)
    end
    MatchMsg:sendPushUserPlaceOrderPositionReq(msg.match_ack_msg.matchid)
    self:passMessageToGameController(msg, gameId)
end

-- [[一局结束]]
function MatchMsgController:handleOverGameAck(msg, matchData, gameId)
    msg[MSG_TYPE] = OVER_GAME_ACK
    --MatchMsg:sendPushUserPlaceOrderPositionReq(msg.match_ack_msg.matchid)
    self:passMessageToGameController(msg, gameId)
end

--初始化桌子上的玩家信息（散桌赛）
function MatchMsgController:handleInitGameTableAck(msg, matchData, gameId)
    msg[MSG_TYPE] = INIT_GAMETABLE_ACK
    --先传消息到游戏保存数据，再进行切换
    self:passMessageToGameController(msg, gameId)
    self:changeToPlayState(msg.match_ack_msg.matchid)    
end

--[[一局结果]]
function MatchMsgController:handleStageBoutResultAck(msg, matchData, gameId)
    msg[MSG_TYPE] = STAGEBOUT_RESULT_ACK
    local ack = msg.match_ack_msg.stageboutresult_ack_msg
    local text = ack.text
    --由于服务器发来的字串会带有 \0，转化时会出现乱码，所以去掉末尾的 \0
    if string.byte(string.sub(text, -1)) == 0 then
        text = string.sub(text, 1, -2)
        ack.text = text
    end

    ack.nLeave_ = tonumber(text) or 1

    --更新自己的全场排名
    if ack.orderinfo then
        for i, od in ipairs(ack.orderinfo) do
            if od.userid == UserInfo.userId_ then
                matchData.rank_ = od.order
                break
            end
        end
    end
end

--表情播放消息处理
function MatchMsgController:handleGameSimpleActionAck(msg, matchData, gameId)
    msg[MSG_TYPE] = GAME_SIMPLE_ACTION_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[岛屿赛锁定对手]]
function MatchMsgController:handleLockDownAck(msg, matchData, gameId)
    msg[MSG_TYPE] = LOCK_DOWN_ACK
end

--[[通知客户端锁定了本局选手]]
function MatchMsgController:handleMarkLockDownAck(msg, matchData, gameId)
    msg[MSG_TYPE] = MARD_LOCK_DOWN_ACK
    matchData.isMarkLockDown_ = true
end

--[[游戏时间、JJ 炸弹规则等]]
function MatchMsgController:handleRulerInfoExAck(msg, matchData, gameId)
    msg[MSG_TYPE] = RULERINFOEX_ACK
    self:passMessageToGameController(msg, gameId)
end

--[[连胜奖励]]
function MatchMsgController:handleGameCVAwardInfoAck(msg, matchData, gameId)
    msg[MSG_TYPE] = CVAWARDINFO_ACK
    local text = msg.match_ack_msg.gamecvawardinfo_ack_msg.awardinfo
    --test data
    --[[<tasks>

  <task name="cvtask" tip="连胜奖励">
      <target count="1"><money id="2" value="2" tip="2金币"/></target>
  <target count="2">
      <money id="2" value="4" tip="4金币"/>
        </target>
  <target count="3">
      <money id="2" value="8" tip="8金币"/>
      </target>
  </task>
  </tasks>]]
    if text then
        matchData.cvAwardList_ = require("game.data.match.CVAwardItem"):initWithXml(text)
    end
end

--[[连胜局数]]
function MatchMsgController:handleGameCVAwardAck(msg, matchData, gameId)
    msg[MSG_TYPE] = CVAWARD_ACK
    matchData.CVWin_ = msg.match_ack_msg.gamecvaward_ack_msg.win
end

function MatchMsgController:handleGameJackpotAck(msg, matchData, gameId)
    msg[MSG_TYPE] = GAME_JACKPOT_ACK
    self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:handleGameJackpotCountAck(msg, matchData, gameId)
    msg[MSG_TYPE] = GAME_JACKPOT_COUNT_ACK
    self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:handleGameJackpotWinnerAck(msg, matchData, gameId)
    msg[MSG_TYPE] = GAME_JACKPOT_WINNER_ACK
    self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:handleGamePlayerArrivedAck(msg, matchData, gameId)
    msg[MSG_TYPE] = GAME_PLAYER_ARRIVED_ACK
    --self:passMessageToGameController(msg, gameId)
end

function MatchMsgController:changeToPlayState(matchid)
    local gd = GameDataContainer:getGameData(matchid)
    if gd and gd:isInWaitState() then
        gd:resetGame()
        gd.playState_ = JJGameStateDefine.PLAY_STATE_PLAY
        JJSDK:pushMsgToSceneController(require("game.message.MatchViewChangeMsg").new(0))
    end
end

--转发match消息到game中
function MatchMsgController:passMessageToGameController(msg, gameId)
    if gameId == JJGameDefine.GAME_ID_POKER then
        if JJFileUtil:exist("poker/msg/PokerMatchMsgGameController.lua") then
            require("poker.msg.PokerMatchMsgGameController")
            PokerMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has poker file")
        end
        --斗地主
    elseif gameId == JJGameDefine.GAME_ID_LORD or gameId == JJGameDefine.GAME_ID_LORD_PK
            or gameId == JJGameDefine.GAME_ID_LORD_LZ or gameId == JJGameDefine.GAME_ID_LORD_HL then
        if JJFileUtil:exist("lordunion/msg/LordUnionMatchMsgGameController.lua") then
            require("lordunion.msg.LordUnionMatchMsgGameController")
            LordUnionMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has lordunion file")
        end
    elseif gameId == JJGameDefine.GAME_ID_NIUNIU then
        if JJFileUtil:exist("niuniu/msg/MatchMsgGameController.lua") then
            require("niuniu.msg.MatchMsgGameController")
            NiuNiuMatchMsgGameController:handleMsg(msg, gameId)
        end
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_BR then
        if JJFileUtil:exist("mahjongbr/msg/MatchMsgGameController.lua") then
            require("mahjongbr.msg.MatchMsgGameController")
            MahjongBRMatchMsgGameController:handleMsg(msg, gameId)
        end
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_SC then
        if JJFileUtil:exist("mahjongsc/msg/MatchMsgGameController.lua") then
            require("mahjongsc.msg.MatchMsgGameController")
            MahjongSCMatchMsgGameController:handleMsg(msg, gameId)
        end
        --二麻
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG_TP then
        if JJFileUtil:exist("mahjongtp/msg/MahjongTPMatchMsgGameController.lua") then
            require("mahjongtp.msg.MahjongTPMatchMsgGameController")
            MahjongTPMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has mahjongtp file")
        end
        --四麻
    elseif gameId == JJGameDefine.GAME_ID_MAHJONG then
        if JJFileUtil:exist("mahjong/msg/MahjongMatchMsgGameController.lua") then
            require("mahjong.msg.MahjongMatchMsgGameController")
            MahjongMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has mahjong file")
        end
    elseif gameId == JJGameDefine.GAME_ID_INTERIM then
        if JJFileUtil:exist("interim/msg/MatchMsgGameController.lua") then
            require("interim.msg.MatchMsgGameController")
            InterimMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has interim file")
        end
    elseif gameId == JJGameDefine.GAME_ID_RUNFAST then
        if JJFileUtil:exist("runfast/msg/RunFastMatchMsgGameController.lua") then
            require("runfast.msg.RunFastMatchMsgGameController")
            RunFastMatchMsgGameController:handleMsg(msg, gameId)
        else
            JJLog.i(TAG, "passMessageToGameController not has runfast file")
        end
        --赢三张
    elseif gameId == JJGameDefine.GAME_ID_THREE_CARD then
        if JJFileUtil:exist("threecard/msg/MatchMsgGameController.lua") then
            require("threecard.msg.MatchMsgGameController")
            ThreeCardMatchMsgGameController:handleMsg(msg, gameId)
        end
        --大众麻将
    elseif gameId == JJGameDefine.GAME_ID_MAHJONGPUBLIC then
        if JJFileUtil:exist("mahjongpublic/msg/MahjongpublicMatchMsgGameController.lua") then
            require("mahjongpublic.msg.MahjongpublicMatchMsgGameController")
            MahjongpublicMatchMsgGameController:handleMsg(msg, gameId)
        end
        --推倒胡麻将
    elseif gameId == JJGameDefine.GAME_ID_MAHJONGTDH then
        if JJFileUtil:exist("mahjongtdh/msg/MahjongtdhMatchMsgGameController.lua") then
            require("mahjongtdh.msg.MahjongtdhMatchMsgGameController")
            MahjongtdhMatchMsgGameController:handleMsg(msg, gameId)
        end
    else
        JJLog.i(TAG, "no support game")
    end
end

