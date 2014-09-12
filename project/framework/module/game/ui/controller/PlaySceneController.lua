--[[
    打牌界面的基类
    统一处理开赛、退赛
]]
require("bit")
local PlaySceneController = class("PlaySceneController", require("game.ui.controller.JJGameSceneController"))

local TAG = "PlaySceneController"

PlaySceneController.startGameParam_ = nil
PlaySceneController.matchId_ = 0
PlaySceneController.matchType_ = 0
PlaySceneController.inGameScene = true
PlaySceneController.reconnectGameHandler_ = nil -- 断线重连回来，检查是否会收到开赛消息

local RECONNECT_GAME_TICK = 3 -- 断线重连回来后，等待多长时间收不到开赛消息，退出比赛

--[[   
    参数
    @params:
        @packageId
        @startGameParam:  是个table,详细内容见game.data.model.StartGameParam               
        @gameData: 是个table,详细内容见game.data.game.GameData
]]
function PlaySceneController:ctor(controllerName, sceneName, theme, dimens, startGameParam, gameData)
    PlaySceneController.super.ctor(self, controllerName, sceneName, theme, dimens)

    MainController:removeScene(MainController:getCurPackageId(), JJSceneDef.ID_SWITCH_TO_GAME)
    self.startGameParam_ = startGameParam
    self.matchId_ = 0

    if startGameParam then
        gameData.initTable_ = false
        gameData.matchType_ = startGameParam.matchType_
        gameData.userId_ = UserInfo.userId_
        GameDataContainer:addGameData(startGameParam.matchId_, gameData)

        MatchMsg:sendEnterMatchReq(startGameParam.matchId_, startGameParam.gameId_, startGameParam.ticket_)
        MatchMsg:sendPushUserPlaceOrderPositionReq(startGameParam.matchId_)

        self.matchId_ = startGameParam.matchId_
        self.matchType_ = startGameParam.matchType_
    end

    Util:keepScreenOn(true)
    TourneyController.inPlayScene_ = true

    self.bCanCleanHold = true
    self.outPlayerAmount = 0

    self:startGameIfNeed()
    --self:doReConnectMultiMatch()

    self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

    self.lastPromptTime = 0
    self.queryNewMatchStartScheduler = self.scheduler.scheduleGlobal(function() self:queryNewMatchWillStart() end, 60)

    self.needDisplayNetWorkPoor = false
    self:preLoadSound()
end

function PlaySceneController:destoryUI()
    self.bCanCleanHold = true
    self:askCleanHoldMsg()

    if self.queryNewMatchStartScheduler then
        self.scheduler.unscheduleGlobal(self.queryNewMatchStartScheduler)
        self.queryNewMatchStartScheduler = nil
    end

    if self.loadResScheduler_ then
        self.scheduler.unscheduleGlobal(self.loadResScheduler_)
        self.loadResScheduler_ = nil
    end

    self:closeSignupDlg()
    self:showProgressDlg(false)
    self:showMatchDesDlg(false, true)
    self:showNewMatchWillStartDlg(false)
    self:showExitGameDialog(false)
    self:showExitGameDialogForErrorMatch(false)
    self:showCloseGameDlg(false)

    if self.currentView_ and self.currentView_.onPause then 
        self.currentView_:onPause() 
    end
    self.currentView_ = nil
    self.playView__ = nil
    self.currentViewId_ = nil
end

function PlaySceneController:onDestory()
    JJLog.i("linxh", "PlaySceneController:onDestory")
    self.destoryed_ = true

    self:destoryUI()

    TourneyController.inPlayScene_ = false
    PlaySceneController.super.onDestory(self)
end

function PlaySceneController:destoryView()
    JJLog.i("linxh", "PlaySceneController:destoryView")
    self:destoryUI()
end

--onCreate
function PlaySceneController:onSceneEnter()
    JJLog.i("linxh", "PlaySceneController:onSceneEnter")
    PlaySceneController.super.onSceneEnter(self)
    self.destoryed_ = false        
    self:askHoldMsg() --和endLoadRes对应
    self:recover()
end

function PlaySceneController:onSceneEnterFinish()
    JJLog.i("linxh", "PlaySceneController:onSceneEnterFinish 2")
    PlaySceneController.super.onSceneEnterFinish(self)
    local gd = self:getGameData()
    --在这里开始加载资源，保证第一个view能够完全显示    
    if gd and gd:isFirstRound() then
        self:startLoadRes()
        gd:setFirstRoundFlag(false) --切换界面一次后就不再走first round了
    else
        self:askCleanHoldMsg() --对应onSceneEnter的hold
    end
end

--onResume
function PlaySceneController:onResume()
    JJLog.i("linxh", "PlaySceneController:onResume")
    local ret = PlaySceneController.super.onResume(self)
    self:startBgSound()
    self.bCanCleanHold = true
    self:askCleanHoldMsg()
    return ret
end

--onPause
function PlaySceneController:onPause()
    JJLog.i("linxh", "PlaySceneController:onPause")

    self:unLoadSound()
    self:destoryUI()

    PlaySceneController.super.onPause(self)
end

--[[back键处理]]
function PlaySceneController:onBackPressed()
    JJLog.i("linxh", "PlaySceneController:onBackPressed")
    local ret = false
    if self.currentView_ then
        ret = self.currentView_:onBackPressed()        
    end

    if not ret then
        if self.matchDesDlg_ and self.matchDesDlg_:isShowing() then
            self.showMatchDes = false
            self:showMatchDesDlg(true, true)
            ret = true        
        elseif self:isInDiplomaWaitView() then
            if self.matchId_ <= 0 then
                --未获得 MatchID，说明是处于报名等待状态
                LobbyDataController:unSignupMatch(self.tourneyId_ or (self.startGameParam_ and self.startGameParam_.tourneyId_))
            else
                self:exitMatch(true)
                ret = true
            end
        else
            if self.newExitGameDlg_ and self.newExitGameDlg_:isShowing() then
                self:showExitGameDialog(false)
            else
                self:showExitGameDialog(true)
            end
            ret = true
        end
    end
    return ret
end

function PlaySceneController:updateStartGameParam(matchId)
    self.matchId_ = matchId
    self.startGameParam_.matchId_ = matchId
    local matchData = StartedMatchManager:getMatch(matchId)
    if matchData then
        local tourneyInfo = LobbyDataController:getTourneyInfoByTourneyId(matchData.tourneyId_)
        local startGameParam
        if self.startGameParam_ ~= nil then
            startGameParam = self.startGameParam_
        else
            startGameParam = require("game.data.model.StartGameParam").new()
        end

        startGameParam.desk_ = tonumber(tourneyInfo and tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.desk)
        startGameParam.matchType_ = tonumber(tourneyInfo and tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType)
        startGameParam.matchId_ = matchId
        startGameParam.startType_ = startGameParam.TYPE_START_SIGNUP_WAIT
        startGameParam.tourneyId_ = matchData.tourneyId_
        self.startGameParam_ = startGameParam
        self.matchType_ = startGameParam.matchType_
    end
end

function PlaySceneController:isMyMatchMsg(msg)
    local ret = true
    local matchId = -1
    local msgCategory = msg[MSG_CATEGORY]

    if msgCategory == MATCH_ACK_MSG then 
        matchId = msg.match_ack_msg.matchid
    elseif msgCategory == MATCHVIEW_ACK_MSG then 
        matchId = msg.matchview_ack_msg.matchid
    elseif msgCategory == LORD_ACK_MSG then 
        matchId = msg.lord_ack_msg.matchid
    elseif msgCategory == POKER_ACK_MSG then 
        matchId = msg.poker_ack_msg.matchid
    elseif msgCategory == MAHJONG_ACK_MSG then 
        matchId = msg.mahjong_ack_msg.matchid
    elseif msgCategory == MAHJONGTP_ACK_MSG then 
        matchId = msg.mahjongtp_ack_msg.matchid
    elseif msgCategory == HLLORD_ACK_MSG then 
        matchId = msg.hllord_ack_msg.matchid
    elseif msgCategory == PKLORD_ACK_MSG then 
        matchId = msg.pklord_ack_msg.matchid
    elseif msgCategory == THREECARD_ACK_MSG then 
        matchId = msg.threecard_ack_msg.matchid
    elseif msgCategory == LZLORD_ACK_MSG then 
        matchId = msg.lzlord_ack_msg.matchid
    elseif msgCategory == NIUNIU_ACK_MSG then 
        matchId = msg.douniu_ack_msg.matchid
    elseif msgCategory == MAHJONGBR_ACK_MSG then 
        matchId = msg.mahjongbr_ack_msg.matchid
    elseif msgCategory == MAHJONGSC_ACK_MSG then 
        matchId = msg.mahjongscn_ack_msg.matchid
    elseif msgCategory == MAHJONGPUBLIC_ACK_MSG then 
        matchId = msg.mahjongdz_ack_msg.matchid
    elseif msgCategory == INTERIM_ACK_MSG then 
        matchId = msg.interim_ack_msg.matchid
    elseif msgCategory == RUNFAST_ACK_MSG then 
        matchId = msg.runfast_ack_msg.matchid
    elseif msgCategory == MAHJONGTDH_ACK_MSG then 
        matchId = msg.mahjongtdh_ack_msg.matchid
    end

    if matchId ~= -1 then 
        ret = (self.matchId_ == matchId)
    end

    return ret
end

function PlaySceneController:getMatchId()
    return self.matchId_
end

function PlaySceneController:getGameData()
    return GameDataContainer:getGameData(self.matchId_)
end

function PlaySceneController:getMatchData()
    return StartedMatchManager:getMatch(self.matchId_)
end

function PlaySceneController:notInHistoryState(gd)
    local gameData = gd
    if not gameData then
        gameData = self:getGameData()
    end
    if gameData then
        return not gameData.history_
    end
    return true
end

function PlaySceneController:handleMsg(msg)
    local gd = self:getGameData()

    if not gd then JJLog.i("linxh", "no game data error") return end

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        local msgCategory = msg[MSG_CATEGORY]
        if msgCategory == MATCH_ACK_MSG then --match消息处理
            self:handleMatchAckMsg_(msg, gd)
        elseif msgCategory == LOBBY_ACK_MSG then --Lobby消息处理
            self:handleLobbyAckMsg_(msg, gd)
        elseif msgCategory == MATCHVIEW_ACK_MSG then
            self:handleMatchViewAckMsg_(msg, gd)
        elseif msgCategory == MATCHINFO_ACK_MSG then
            self:handleMatchInfoAckMsg_(msg, gd)
        end
    elseif msg.type == GameMsgDef.ID_MATCH_VIEW_CHANGE then
        if self:notInHistoryState() then
            self:recover()
        end

    -- [Yangzukang][2014.08.25]断线期间比赛结束了，重连回来，不会收到开赛消息
    -- 加个保护，重连后 5s 内收不到开赛消息，退出游戏界面
    elseif msg.type == GameMsgDef.ID_LOGIN_RESULT then
        if MainController:isConnected() then
            if (self.reconnectGameHandler_ ~= nil) then
                self.scheduler.unscheduleGlobal(self.reconnectGameHandler_)
                self.reconnectGameHandler_ = nil
            end
            self.reconnectGameHandler_ = self.scheduler.performWithDelayGlobal(function()
                JJLog.i(TAG, "reconnectGameHandler_ timeout")
                jj.ui.JJToast:show({
                    text = "恢复比赛失败，返回上级界面",
                    dimens = self.dimens_,
                })
                self:exitMatch(true)
            end, RECONNECT_GAME_TICK)
        end
    end

    PlaySceneController.super.handleMsg(self, msg)
end

function PlaySceneController:handleMatchAckMsg_(msg, gd)
    local msgType = msg[MSG_TYPE]

    if msgType == HAND_OVER_ACK then
        --gd.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
        if not gd:playNot2Wait() then
            self:transferWaitViewDelay(5)
        end
    elseif msgType == HISTORY_BEGIN_ACK then
        --散桌比赛旁观过程中会不断受到hitory begin消息，导致界面不断闪现历史恢复界面
        --为了避免加入判断，不是最好做法，最好的办法直接判断比赛是否散桌       
        if not gd:playNot2Wait() then
            self:recover()
        end
    elseif msgType == HISTORY_END_ACK then
        self:recover()
    elseif msgType == RELIVE_COST_ACK then --复活
        self.waitingRelive = true
        self.reviveStartTick = JJTimeUtil:getCurrentSecond()
        self:recover() --不管能不能复活都先跳到复活界面
    elseif msgType == PUSH_MATCH_PLAYERINFO_ACK then --3人pk
        self:recover()
    elseif msgType == REST_ACK then --岛赛等待消息                
        self:recover()
    elseif msgType == CONTINUE_ACK then -- 岛屿赛继续
        gd.islandWait_ = false
    elseif msgType == PUSH_MATCH_AWARD then --奖状消息        
        if self:isInIslandWaitView() then --如果是岛屿赛等待，更新
            self.currentView_:recvAward()
        elseif not gd:isLandMatch() then --不是岛屿赛的话，切换到奖状界面
            self:recover()
        end
    elseif msgType == CVAWARDINFO_ACK or msgType == CVAWARD_ACK then
        if self:isInIslandWaitView() then
            self.currentView_:updateTaskInfo()
        end
    elseif msgType == HEMATINIC_ACK then
        if self:isInIslandWaitView() then
            self.currentView_:onHematinicAck(msg)
        end
    elseif msgType == TIP_MSG_ACK then
        self:handleTipMsg_(msg, gd)
    elseif msgType == ROUND_PLAYER_ACK then
        if self.matchDesDlg_ then
            self.matchDesDlg_:setRankContent()
        end
        if self:isInPromotionWaitView() then
            self.currentView_:setContent()
        end
    elseif msgType == STAGEBOUT_RESULT_ACK then
        if self:isInPromotionWaitView() then
            self.currentView_:updateStageBontResult(msg.match_ack_msg.stageboutresult_ack_msg.nLeave_,
                self.outPlayerAmount)
            self.currentView_:setContent()
        end
    elseif msgType == PUSH_USERORDER_ACK then
        if self:isInPromotionWaitView() then
            local md = self:getMatchData()
            if md then
                self.currentView_:setTotalRank(md.rank_ + 1, md.leavePlayer_)
            end
        end
    end
end

function PlaySceneController:handleMatchViewAckMsg_(msg, gd)
    local msgType = msg[MSG_TYPE]

    if msgType == MATCHVIEW_UPDATE_ACK then
        if self:isInPromotionWaitView() then
            self.currentView_:setWaitInfo()
        end
    end
end

function PlaySceneController:handleMatchInfoAckMsg_(msg, gd)
    local msgType = msg[MSG_TYPE]

    if msgType == MATCH_SIGN_COUNT_INFO_ACK and self.bReSignupMatch then
        if self:isInDiplomaWaitView() then
            local ack = msg.matchinfo_ack_msg.getsigncount_ack_msg
            local tid = ack and ack.tourneyid
            if tid == 0 and self.startGameParam_ then
                tid = self.startGameParam_.tourneyId_
            end
            local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tid)
            local mc = tourneyInfo and tourneyInfo.matchconfig_
            if mc then
                self.timeToMatchStartAvg = ack.matchcreateinterval
                self:showMatchCountDown(mc.matchType, ack.signupplayer,
                    ack.matchplayercount, tid)
                if not self.getSignupInfoScheduler then
                    self.getSignTourneyId = tid
                    self:getSignCount(self.getSignTourneyId)
                end
            end
        else
            self:closeSignupDlg()
        end
    end
end

--toast只有在为false时，才不显示
function PlaySceneController:handleTipMsg_(msg, gd, toast)
    local ack = msg.match_ack_msg.tipmsg_ack_msg

    if (toast ~= false) then
        jj.ui.JJToast:show({ text = ack.text, dimens = self.dimens_ })
    end

    if gd and gd:isInWaitState() and gd.promotion_ then
        self:recover()
    end

    if bit.band(ack.nextoper, 0x02) == 0x02 then
        --不是打牌界面才起作用
        --if (not self.waitingRelive) and not self:isInPlayView() then
        if not self.waitingRelive then --麻将会在playview时就下发次消息
            --增加被踢出比赛的原因提示，在此保存，然后弹出提示框的时候提示用户
            self.tipExitMsg_ = ack.text
            self.needExit = true
            self:recover()
        end
    end

    local st = string.find(ack.text, "本轮将淘汰")
    if st then
        self.outPlayerAmount = string.sub(ack.text, -2)
        gd.outPlayerAmount_ = self.outPlayerAmount
    elseif self.doReliveReq_ then
        st = string.find(ack.text, "不复活")
        if st and self.currentViewId_ == JJSceneDef.MATCH_VIEW_ROUND_WAIT then --不复活，退出当前比赛
            self:exitMatch(true)
        end
    end
end

function PlaySceneController:handleLobbyAckMsg_(msg, gd)
    local msgType = msg[MSG_TYPE]
    if msgType == TOURNEYSIGNUPEX_ACK then
        self:showProgressDlg(false)
        --不再进行提示，在lobbymsgcontroller里面已经处理了
        if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
            local ack = msg.lobby_ack_msg.tourneysignupex_ack_msg
            local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(ack.tourneyid)
            local type = tourneyInfo and tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType
            --BUG#8603 即时赛，奖状界面点击再玩一次按钮，没有弹出倒计时框
            --这里退赛会清除数据，等下个比赛开赛时再清除数据，由maincontroller统一处理
            --[[if tonumber(type) == MatchDefine.MATCH_TYPE_TIMELY then
                --结束当前比赛
                self:exitMatch(false)
            end]]

            --设置新比赛的参数，切换到等待界面
            if self.startGameParam_ then
                self.startGameParam_.startType_ = self.startGameParam_.TYPE_START_SIGNUP_WAIT
                self.startGameParam_.productId_ = tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.productId
                self.startGameParam_.tourneyId_ = ack.tourneyid
                self.startGameParam_.matchType_ = type
            end

            --重置界面
            self.needExit = false

            --再来一局显示倒计时
            MatchInfoMsg:sendGetSignCountReq(ack.tourneyid)
            self.bReSignupMatch = true
        end
    elseif msgType == START_CLIENT_ACK then
        --报名成功，清除赛奖状状态
        self.showedHonor = false
        self.dpShareFile_ = nil
        self.bReSignupMatch = false
        self:showProgressDlg(false)
        self:closeSignupDlg()
        if (self.reconnectGameHandler_ ~= nil) then
            self.scheduler.unscheduleGlobal(self.reconnectGameHandler_)
            self.reconnectGameHandler_ = nil
        end
    elseif msgType == TOURNEYUNSIGNUP_ACK then
        self:showProgressDlg(false)
        local ack = msg.lobby_ack_msg.tourneyunsignup_ack_msg
        if ack.success_ then
            jj.ui.JJToast:show({ text = "退赛成功", dimens = self.dimens_ })
            if self.startGameParam_ and
                    (self.startGameParam_.tourneyId_ == 0
                            or self.startGameParam_.tourneyId_ == ack.tourneyid) then
                --单机tid=0, 单机比赛过程中退其它比赛只关闭对话框
                if self:isInDiplomaWaitView() or self.startGameParam_.tourneyId_ == 0 then
                    self:closeSignupDlg()
                else
                    self:close()
                end
            end
            self.bReSignupMatch = false
        end
    end
end

function PlaySceneController:close()
    --快速游戏或者断线重连进入的，回到大厅。
    MainController:pushScene(MainController:getCurPackageId(), JJSceneDef.ID_MAIN)
end

function PlaySceneController:onExitGameListener()
    JJLog.i("PlaySceneController", "onExitGameListener IN")
end

--[[
    退出当前比赛
    @close: 
        true: 弹出界面
]]
function PlaySceneController:exitMatch(close, matchId)
    JJLog.i("linxh", "exitMatch, matchId=", self.matchId_, ", matchType=", self.matchType_, ", close=", close, ",matchId =", matchId)

    local tid = self.tourneyId_ or (self.startGameParam_ and self.startGameParam_.tourneyId_) or 0
    -- 未获得 MatchID，说明是处于报名等待状态
    if self.matchId_ <= 0 then
        if tid > 0 then
            LobbyDataController:unSignupMatch(tid)
        end
    else
        local tinfo = TourneyController:getTourneyInfoByTourneyId(tid)
        local mc = tinfo and tinfo.matchconfig_
        if tinfo and tinfo.status_ == MatchDefine.STATUS_SIGNOUTABLE
                and mc and tonumber(mc.matchType) == MatchDefine.MATCH_TYPE_FIXED then
            --定时赛报名，维持状态不变
        else
            if self.matchType_ == MatchDefine.MATCH_TYPE_ISLAND then --岛屿赛
                MatchMsg:sendLeaveReq(self.matchId_, UserInfo.userId_)
                --MatchMsg:sendExitMatchReq(self.matchId_, 
                --                         self.startGameParam_ and self.startGameParam_.ticket_, self.gameId_)
            else --即时赛
                MatchMsg:sendExitGameReq(self.matchId_)
            end

            SignupStatusManager:exitMatch(self.matchId_)
            StartedMatchManager:removeMatch(matchId or self.matchId_)
            GameDataContainer:removeGameData(matchId or self.matchId_)

            --散桌换桌，有时会一直处于roundwait界面
            self.matchId_ = nil
            self.tourneyId_ = nil
            self.startGameParam_ = nil
        end
    end

    if close then
        Util:keepScreenOn(false)
        JJSDK:popScene()
    end
end

function PlaySceneController:reSignupMatch()
    JJLog.i("linxh", "PlaySceneController:reSignupMatch")
    self.reSignupFee = nil
    local tid = (self.startGameParam_ and self.startGameParam_.tourneyId_) or 0
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tid)
    if tourneyInfo ~= nil then
        TourneyController:checkSignupReqirement(tourneyInfo)
    end    

    if tourneyInfo then
        if tourneyInfo.status_ == MatchDefine.STATUS_SIGNUPABLE then
            local signupType = 0
            local singupFee = tourneyInfo:getEntryFee()
            if singupFee and #singupFee > 0 then
                for i = 1, #singupFee do
                    if singupFee[i].useable_ then
                        signupType = singupFee[i].type_
                        self.reSignupFee = singupFee[i].note_
                        if string.find(self.reSignupFee, "免费") then
                            self.reSignupFee = tourneyInfo.minGoldCost_ .. "金币"
                        end
                        break
                    end
                end
            end

            -- 报名，把当前的退掉
            local tm = tourneyInfo:getSignupTime()
            local state = LobbyDataController:signupMatch(self.gameId_, tid, tm, signupType, 0, 0)
            if state then
                self:askCreateDialog(self.DIALOG_ID_PROGRESS, "报名中，请稍候！...")
            end
        elseif tourneyInfo.status_ == MatchDefine.STATUS_SIGNOUTABLE
                or tourneyInfo.status_ == MatchDefine.STATUS_SIGNUPING then
            jj.ui.JJToast:show({ text = "您已经报名", dimens = self.dimens_ })
        else
            jj.ui.JJToast:show({ text = "不能报名！", dimens = self.dimens_ })
        end
    end
end

function PlaySceneController:closeSignupDlg()
    self:showReSignupDlg(false)

    if self.getSignupInfoScheduler ~= nil then
        self.scheduler.unscheduleGlobal(self.getSignupInfoScheduler)
        self.getSignupInfoScheduler = nil
    end

    self.timeToMatchStartAvg = nil
    self.getSignTourneyId = nil
end

function PlaySceneController:getSignCount(tourneyId)
    MatchInfoMsg:sendGetSignCountReq(tourneyId)
    self.getSignupInfoScheduler = self.scheduler.scheduleGlobal(function()
        MatchInfoMsg:sendGetSignCountReq(tourneyId)
    end, 3)
end

function PlaySceneController:showReSignupDlg(flag, params)
    if flag then
        self.resignupDlg_ = self.resignupDlg_ or require("game.ui.view.ReSignupDialog").new({
            theme = self.theme_,
            dimens = self.dimens_,
            matchType = params.matchType,
            tourneyId = params.tourneyId,
            matchPoint = params.matchPoint,
            onDismissListener = function() self.resignupDlg_ = nil end
        })
        self.resignupDlg_:show(self.scene_)
        self.resignupDlg_:setCanceledOnTouchOutside(false)
    elseif self.resignupDlg_ then
        self.resignupDlg_:dismiss()
        self.resignupDlg_ = nil
    end
end

function PlaySceneController:showMatchCountDown(matchType, signPlayer, maxPlayer, tourneyId)
    JJLog.i("linxh", "PlaySceneController:showMatchCountDown, ", tourneyId)
    if not self.resignupDlg_ then
        tourneyId = tourneyId or 0
        self.tourneyId_ = tourneyId
        local signupitem = SignupStatusManager:getSignupedItem(tourneyId)
        local params = {}
        params.matchType = matchType
        params.tourneyId = tourneyId
        params.matchPoint = (signupitem and signupitem.startTime_) or 0
        params.signPlayer = signPlayer
        params.maxPlayer = maxPlayer
        self:showReSignupDlg(true, params)
    end

    local avt = self.timeToMatchStartAvg or 30
    self.resignupDlg_:setStartMatchAvgTime(avt)
    if signPlayer and maxPlayer then
        if signPlayer > maxPlayer then --BUG #7435 出现-0
            self.resignupDlg_:setStartMatchLastTime(2)
        else
            self.resignupDlg_:setStartMatchLastTime(math.modf(avt / maxPlayer * (maxPlayer - signPlayer)))
        end
        self.resignupDlg_:setPercent(signPlayer, maxPlayer)
    end
end


function PlaySceneController:toRelive(flag)
    --self.toReviveFlag_ = (flag and 0) or 1
    self.doReliveReq_ = true
    MatchMsg:sendPlayerReliveReq(self.matchId_, UserInfo.userId_, (flag and 0) or 1)
    local ld = self:getGameData()
    if ld then
        ld.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
        ld.relive_ = false
        ld.threePk_ = false
    end
    self:recover()
end


function PlaySceneController:askHoldMsg()
    JJSDK:pauseNetMsg("PlaySceneController", true)
end

function PlaySceneController:askCleanHoldMsg()
    if self.bCanCleanHold then
        JJSDK:pauseNetMsg("PlaySceneController", false)
    end
end

function PlaySceneController:recover()
    JJLog.i("lilc", "PlaySceneController:recover")
    if self.scene_ then
        self:closeSignupDlg()
        self:showProgressDlg(false)

        local RoarInterface = require("game.thirds.RoarInterface")
        RoarInterface:exitRoar()
        local RankInterface = require("game.thirds.RankInterface")
        RankInterface:exitRank()

        self:changeView()

        if self:isInPlayView() then
            self.doReliveReq_ = false
            self.showMatchDes = false
            self.waitingRelive = false
        end

        if self.transferScheduler then
            self.scheduler.unscheduleGlobal(self.transferScheduler)
            self.transferScheduler = nil
        end

        --奖状界面再来一局后home锁屏，回来后恢复报名倒计时框
        if not self:isInDiplomaWaitView() then
            self.bReSignupMatch = false
        elseif self.bReSignupMatch then
            self:getSignCount(self.tourneyId_)
        end
    end
end

function PlaySceneController:changeView()
    local gd = self:getGameData()
    local view = JJSceneDef.MATCH_VIEW_ROUND_WAIT
    if gd then
        local state = gd.playState_
        local waitState = gd:getWaitState()
        JJLog.i("linxh", "changeView state =", state, ", waitState=", waitState)

        --进入比赛不成功， 来了提示， 提示比赛不存在， 此时背景为黑色,
        --这种情况是由于正在打的比赛被产品下线了
        -- 增加此页面，解决黑背景问题
        if gd:isInWaitState() and self.needExit then
            self:transferView(JJSceneDef.MATCH_VIEW_DIALOG_CONFIRM_WAIT)
            self:showExitGameDialogForErrorMatch(true)
            return
        end

        if state == JJGameStateDefine.PLAY_STATE_WAIT then
            view = self:getWaitView(waitState)
        elseif state == JJGameStateDefine.PLAY_STATE_PLAY then
            view = JJSceneDef.MATCH_VIEW_PLAY
        end
    end
    --view = JJSceneDef.MATCH_VIEW_ROUND_WAIT
    JJLog.i("linxh", "PlaySceneController:changeView ", view)
    if view then self:transferView(view) end
end

function PlaySceneController:getWaitView(waitState)
    local view = JJSceneDef.MATCH_VIEW_ROUND_WAIT

    if waitState == JJGameStateDefine.WAIT_STATE_PROMOTION then
        local gd = self:getGameData()
        if gd and gd.promotionView_ then
            view = JJSceneDef.MATCH_VIEW_PROMOTION_WAIT
        end
    elseif waitState == JJGameStateDefine.WAIT_STATE_ISLAND then
        view = JJSceneDef.MATCH_VIEW_ISLAND_WAIT
    elseif waitState == JJGameStateDefine.WAIT_STATE_RELIVE then
        local matchData = self:getMatchData()
        if matchData and matchData.reliveData_ then
            view = JJSceneDef.MATCH_VIEW_REVIVE_WAIT
        end
    elseif waitState == JJGameStateDefine.WAIT_STATE_AWARD then
        local matchData = self:getMatchData()
        if matchData and matchData.awardData_ then
            view = JJSceneDef.MATCH_VIEW_DIPLOMA
        end
    elseif waitState == JJGameStateDefine.WAIT_STATE_HISTORY then
        view = JJSceneDef.MATCH_VIEW_HISTORY_WAIT
    elseif waitState == JJGameStateDefine.WAIT_STATE_FIRST_ROUND then
        view = JJSceneDef.MATCH_VIEW_FIRST_ROUND_WAIT
    end

    return view
end

function PlaySceneController:removeView()
    if self.currentView_ then
        if self.scene_ then
            self.scene_:removeView(self.currentView_)
        end

        if self.currentView_ == self.playView__ then
            self.playView__ = nil
        end

        self.currentView_ = nil
        self.currentViewId_ = nil
    end
end

-- 游戏(roundwait award play ..等界面)切换
function PlaySceneController:transferView(viewId)
    --   playview只会隐藏，不会被移除掉
    local newSubView = nil
    if viewId ~= self.currentViewId_ then
        if viewId ~= JJSceneDef.MATCH_VIEW_PLAY and self.playView__ then
            self.playView__:setVisible(false)
        end

        if self:isInPromotionWaitView() then
            self:showMatchDesDlg(true, true)
        end

        if viewId == JJSceneDef.MATCH_VIEW_PLAY and self.playView__ then
            if self.playView__:isVisible() then
                self.playView__:setVisible(true)
            end
            self.playView__:onEnter()
        else
            newSubView = self:getMatchView(viewId)
            if not newSubView then
                newSubView = self:getDefaultMatchView(viewId)
            end
        end
    else
        if not self.currentView_:isVisible() then
            self.currentView_:setVisible(true)
        end
        self.currentView_:onEnter()
    end

    if newSubView ~= nil and self.scene_ then
        self:removeView(self.currentView_)
        self.currentViewId_ = viewId
        self.currentView_ = newSubView

        if viewId == JJSceneDef.MATCH_VIEW_PLAY then
            self.playView__ = self.currentView_
        end

        self.scene_:addView(self.currentView_)

    end
end

function PlaySceneController:transferWaitView(viewId)
    local gd = self:getGameData()
    if gd and self:isInPlayView() then
        gd:resetWaitState()
        gd.playState_ = JJGameStateDefine.PLAY_STATE_WAIT
        self:recover()
    end
end

function PlaySceneController:transferWaitViewDelay(time)
    self.transferScheduler = self.scheduler.performWithDelayGlobal(handler(self, self.transferWaitView), time)
end

function PlaySceneController:isInPlayView()
    return (self.currentView_ and self.currentViewId_ == JJSceneDef.MATCH_VIEW_PLAY)
end

function PlaySceneController:isInIslandWaitView()
    return (self.currentView_ and self.currentViewId_ == JJSceneDef.MATCH_VIEW_ISLAND_WAIT)
end

function PlaySceneController:isInPromotionWaitView()
    return (self.currentView_ and self.currentViewId_ == JJSceneDef.MATCH_VIEW_PROMOTION_WAIT)
end

function PlaySceneController:isInDiplomaWaitView()
    return (self.currentView_ and self.currentViewId_ == JJSceneDef.MATCH_VIEW_DIPLOMA)
end

function PlaySceneController:getMatchView(viewId)
end

function PlaySceneController:getDefaultMatchView(viewId)
    local newSubView = nil
    if viewId == JJSceneDef.MATCH_VIEW_ROUND_WAIT then
        newSubView = require("game.ui.view.RoundWaitView").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_DIALOG_CONFIRM_WAIT then
        newSubView = require("game.ui.view.DialogConfirmWaitView").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_DIPLOMA then
        newSubView = require("game.ui.view.DiplomaView").new(self, self.startGameParam_)
    elseif viewId == JJSceneDef.MATCH_VIEW_ISLAND_WAIT then
        newSubView = require("game.ui.view.IslandWaitView").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_PROMOTION_WAIT then
        newSubView = require("game.ui.view.PromotionWait").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_REVIVE_WAIT then
        newSubView = require("game.ui.view.ReliveView").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_HISTORY_WAIT then
        newSubView = require("game.ui.view.HistoryWait").new(self)
    elseif viewId == JJSceneDef.MATCH_VIEW_FIRST_ROUND_WAIT then
        newSubView = self:getMatchView(JJSceneDef.MATCH_VIEW_ROUND_WAIT) --目前默认和roundwait一样
        if not newSubView then newSubView = require("game.ui.view.RoundWaitView").new(self) end
    end
    return newSubView
end

function PlaySceneController:isShowMatchDesDlg()
    return self.showMatchDes
end

function PlaySceneController:showMatchDesDlg(awardFlag, flag)
    if not flag then
        self.showMatchDes = true
        self.matchDesDlg_ = self.matchDesDlg_ or require("game.ui.view.MatchDesDialog").new({
            theme = self.theme_,
            dimens = self.dimens_,
            matchId = self.matchId_,
            showRank = true,
            showAward = awardFlag,
            onDismissListener = function() self.matchDesDlg_ = nil end,
            onCancelListener = function() self.showMatchDes = false end
        })
        self.matchDesDlg_:show(self.scene_)
    elseif self.matchDesDlg_ then
        self.matchDesDlg_:dismiss()
        self.matchDesDlg_ = nil
    end
end

function PlaySceneController:removeSignupWaitDialog()
    self:showProgressDlg(false)
end

function PlaySceneController:showProgressDlg(flag, txtMsg)
    if flag then
        self.progressDlg_ = self.progressDlg_ or require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_,
            {
                text = txtMsg,
                mask = false,
                onDismissListener = function() self.progressDlg_ = nil end
            })
        self.progressDlg_:show(self.scene_)
    elseif self.progressDlg_ then
        self.progressDlg_:dismiss()
        self.progressDlg_ = nil
    end
end


function PlaySceneController:preLoadSound()
end

function PlaySceneController:unLoadSound()
end

function PlaySceneController:startBgSound()
end

function PlaySceneController:startGameIfNeed()
    local md = StartedMatchManager:getMatch(self.matchId_)
    if md then
        if md.started_ then
            MatchMsg:sendEnterRoundReq(self.matchId_, self.gameId_, md.strTick_)
        else
            md.started_ = true
            --linxh 这个会导致重复发enter match消息，导致match view消息有时会在enter round之后收到
            --MatchMsg:sendEnterMatchReq(self.matchId_, self.gameId_, md.strTick_)
        end
    end
end

function PlaySceneController:queryNewMatchWillStart()
    JJLog.i("linxh", "queryNewMatchWillStart IN self.destoryed_ is ", self.destoryed_)
    local signupItem = SignupStatusManager:getNearestTimedItem()
    if (not self.destoryed_) and signupItem and (not self:isInDiplomaWaitView()) then --奖状界面不提示
        local nNearestTime = signupItem.startTime_ or 0
        local nNowTime = JJTimeUtil:getCurrentSecond()
        --五分钟之内，并且距离上次提示超过 2 分钟
        if (nNearestTime > nNowTime)
                and ((nNearestTime - nNowTime) <= 300)
                and ((nNowTime - self.lastPromptTime) >= 120) then

            self.lastPromptTime = nNowTime
            self:showNewMatchWillStartDlg(false)
            self:showNewMatchWillStartDlg(true, {
                name = signupItem.matchName_,
                tid = signupItem.tourneyId_
            })
        end
    end
end

function PlaySceneController:showNewMatchWillStartDlg(flag, param)
    if flag and param then
        self.newMatchWillStartDlg_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = param.name .. [[即将开赛。如无时间，建议退赛。]],
            onDismissListener = function() self.newMatchWillStartDlg_ = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        -- self.newMatchWillStartDlg_:setButton1("不管", function(view)
        -- --self:askDestroyDialog(self.DIALOG_ID_NEW_MATCH_WILL_START)
        -- end)
        self.newMatchWillStartDlg_:setButton2("退赛", function(view)
            LobbyDataController:unSignupMatch(param.tid)
        end)
        self.newMatchWillStartDlg_:setCloseButton(function() end)
        self.newMatchWillStartDlg_:setCanceledOnTouchOutside(true)
        self.newMatchWillStartDlg_:show(self.scene_)
    elseif self.newMatchWillStartDlg_ then
        self.newMatchWillStartDlg_:dismiss()
        self.newMatchWillStartDlg_ = nil
    end
end


function PlaySceneController:exitGameDialog()
    self:showExitGameDialog(true)
end

function PlaySceneController:showExitGameDialog(flag)
    if flag then
        self.newExitGameDlg_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = "比赛进行中，退出将导致比赛结束，是否退出？",
            onDismissListener = function() self.newExitGameDlg_ = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        self.newExitGameDlg_:setButton1("退出", function()

            self:onExitGameListener()
            if self.matchId_ <= 0 then
                --未获得 MatchID，说明是处于报名等待状态
                LobbyDataController:unSignupMatch(self.tourneyId_
                        or (self.startGameParam_ and self.startGameParam_.tourneyId_))
            else
                self:exitMatch(true)
            end
        end)
        self.newExitGameDlg_:setCloseButton(function() end)
        self.newExitGameDlg_:setCanceledOnTouchOutside(true)
        self.newExitGameDlg_:show(self.scene_)
    elseif self.newExitGameDlg_ then
        self.newExitGameDlg_:dismiss()
        self.newExitGameDlg_ = nil
    end
end

--退出不能进入的比赛
function PlaySceneController:showExitGameDialogForErrorMatch(flag)
    if flag then
        self.newExitGameDlg_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = self.tipExitMsg_ or "比赛已经结束，点击“确认”返回大厅。",
            onDismissListener = function() self.newExitGameDlg_ = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        self.newExitGameDlg_:setButton1("确认", function(view)
            self:onExitGameListener()
            if self.matchId_ <= 0 then
                --未获得 MatchID，说明是处于报名等待状态
                LobbyDataController:unSignupMatch(self.tourneyId_
                        or (self.startGameParam_ and self.startGameParam_.tourneyId_))
            else
                self:exitMatch(true)
            end
        end)
        self.newExitGameDlg_:setCloseButton(function() end)
        self.newExitGameDlg_:setCanceledOnTouchOutside(true)
        self.newExitGameDlg_:show(self.scene_)
    elseif self.newExitGameDlg_ then
        self.newExitGameDlg_:dismiss()
        self.newExitGameDlg_ = nil
    end
end

function PlaySceneController:showCloseGameDlg(flag)
    if flag then
        self.closeGameDlg_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = self.tipExitMsg_ or [[比赛已经结束，点击“确认”返回大厅。]],
            onDismissListener = function() self.closeGameDlg_ = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        self.closeGameDlg_:setButton1("确认", function(view) self:exitMatch(true) end)
        self.closeGameDlg_:show(self.scene_)
    elseif self.closeGameDlg_ then
        self.closeGameDlg_:dismiss()
        self.closeGameDlg_ = nil
    end
end

function PlaySceneController:getLoadResTime()
    return 10
end

function PlaySceneController:startLoadRes()
    JJLog.i("linxh", "PlaySceneController:startLoadRes")
    --self:askHoldMsg()
    --start load res time out timer
    self.loadResScheduler_ = self.scheduler.scheduleGlobal(function() self:endLoadRes() end,
        self:getLoadResTime())
    --开始加载资源
    self:onLoadResStart()
end

--[[
需要重载资源的子类重写该函数，重载时不要调用父类的onLoadResStart
即不允许xxxController.super.onLoadResStart(self)
]]
function PlaySceneController:onLoadResStart()
    JJLog.i("linxh", "PlaySceneController:onLoadResStart")
    self:endLoadRes()
end

function PlaySceneController:endLoadRes()
    JJLog.i("linxh", "PlaySceneController:endLoadRes")
    if self.loadResScheduler_ then --这个标记是否已经结束过
        self:askCleanHoldMsg()

        self.scheduler.unscheduleGlobal(self.loadResScheduler_)
        self.loadResScheduler_ = nil
    end
end

return PlaySceneController