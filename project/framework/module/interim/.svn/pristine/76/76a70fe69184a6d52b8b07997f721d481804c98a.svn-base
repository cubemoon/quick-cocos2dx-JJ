local InterimPlaySceneController = class("InterimPlaySceneController", require("game.ui.controller.PlaySceneController"))
local SoundManager = require("game.sound.SoundManager")
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require("interim.pb.InterimMsg")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_PLAYER_STATUS_EMPTY = InterimUtilDefine.INTERIM_PLAYER_STATUS_EMPTY
local INTERIM_PLAYER_STATUS_ENGAGED = InterimUtilDefine.INTERIM_PLAYER_STATUS_ENGAGED
local INTERIM_PLAYER_STATUS_STANDBY = InterimUtilDefine.INTERIM_PLAYER_STATUS_STANDBY
local INTERIM_PLAYER_STATUS_FOLD = InterimUtilDefine.INTERIM_PLAYER_STATUS_FOLD

local InitCardAck = InterimUtilDefine.InitCardAck 
local CoinAck = InterimUtilDefine.CoinAck
local OverAck = InterimUtilDefine.OverAck
local CurPrizePoolAck = InterimUtilDefine.CurPrizePoolAck 
local ConGambAck = InterimUtilDefine.ConGambAck
local GambEndAck = InterimUtilDefine.GambEndAck                 -- 有人获得博彩消息
local CurPrizePoolNoteAck = InterimUtilDefine.CurPrizePoolNoteAck
local ChangeScoreAck = InterimUtilDefine.ChangeScoreAck
local DivideTableCoinAck = InterimUtilDefine.DivideTableCoinAck

local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function InterimPlaySceneController:onDestory()
   InterimPlaySceneController.super.onDestory(self)
   --self:askHoldMsg()
end

function InterimPlaySceneController:handleMatchAckMsg_()

end

function InterimPlaySceneController:handleLobbyAckMsg_()
  -- body
end

function InterimPlaySceneController:changeView( ... )
  -- body
end

function InterimPlaySceneController:handleMatchViewAckMsg_( ... )
  -- body
end

function InterimPlaySceneController:handleMatchInfoAckMsg_( ... )
  -- body
end

local function _newGameData(tid)
  local gameData = nil
  local gameId = JJGameDefine.GAME_ID_INTERIM
  gameData = require("interim.data.InterimData").new()
  return gameData, gameId
end

function InterimPlaySceneController:ctor(controllerName, sceneName,startGameParam)

    local gameData = _newGameData(startGameParam and startGameParam.tourneyId_)
    -- require("interim.data.InterimData").new()
    INTERIM_MATCH_ID = startGameParam.matchId_
    JJLog.i("INTERIM_MATCH_ID" .. INTERIM_MATCH_ID)

    gameData.enteringScene = true
    gameData.tourneyID = startGameParam.tourneyId_
    gameData:setFirstRoundFlag(true)
    self.startGameParam = startGameParam
    self.resignupDlg_ = nil
    self.getSignupInfoScheduler = nil
    self.isTuisai = false


    self.animationFactory = require("interim.util.AnimationFactory").new(self)

    self.gameData = gameData
    --self.allPlayerConut = 0
    if gameData == nil then
      JJLog.i("gameData is nil !!!")
    end
    InterimPlaySceneController.super.ctor(self,
           controllerName,
           sceneName, 
           require("interim.ui.InterimTheme"), 
           require("interim.ui.InterimDimens"), 
           startGameParam, 
           gameData)
end

function InterimPlaySceneController:handleMsg(msg)
  local gameData = self.gameData
  InterimPlaySceneController.super.handleMsg(self, msg)
  
  self:handleLocalMsg(msg, gameData)

  if msg[MSG_CATEGORY] == INTERIM_ACK_MSG then
    if msg and msg[MSG_CATEGORY] and msg[MSG_TYPE] then
      JJLog.i("MSG_CATEGORY:" .. msg[MSG_CATEGORY])
      JJLog.i("MSG_TYPE:" .. msg[MSG_TYPE])
      JJLog.i("----------------------------")
    end
    if msg[MSG_TYPE] == InitCardAck then
      self:handleInitCardAck(msg, gameData)
    elseif msg[MSG_TYPE] == CoinAck then
      self:handleCoinAck(msg, gameData)
    elseif msg[MSG_TYPE] == OverAck then
      self:handleOverAck(msg, gameData)
    elseif msg[MSG_TYPE] == CurPrizePoolAck then    
      self:handleCurPrizePoolAck(msg, gameData)
    elseif msg[MSG_TYPE] == ConGambAck then
      self:handleConGambAck(msg, gameData)
    elseif msg[MSG_TYPE] == GambEndAck then
      self:handleGambEndAck(msg, gameData)
    elseif msg[MSG_TYPE] == CurPrizePoolNoteAck then          
      self:handleCurPrizePoolNoteAck(msg, gameData)
    elseif msg[MSG_TYPE] == ChangeScoreAck then          
      self:handleChangeScoreAck(msg, gameData)
    elseif msg[MSG_TYPE] == DivideTableCoinAck then
      self:handleDivideTableCoinAck(msg, gameData)
    end

  elseif msg[MSG_CATEGORY] == MATCH_ACK_MSG then
    if msg and msg[MSG_CATEGORY] and msg[MSG_TYPE] then
      JJLog.i("MSG_CATEGORY:" .. msg[MSG_CATEGORY])
      JJLog.i("MSG_TYPE:" .. msg[MSG_TYPE])
      JJLog.i("----------------------------")
    end
    if msg[MSG_TYPE] == ENTER_MATCH_ACK then
      self:handleEnterMatchAck(msg, gameData)
    elseif msg[MSG_TYPE] == ENTER_ROUND_ACK then
      self:handleEnterRoundAck(msg, gameData)
    elseif msg[MSG_TYPE] == ADD_GAMEPLAYERINFO_ACK then
      self:handleAddGamePlayerInfoAck(msg, gameData)
    elseif msg[MSG_TYPE] == BEGIN_HAND_ACK then
      self:handleBeginHandAckMsg(msg)
    elseif msg[MSG_TYPE] == OVER_GAME_ACK then      
    --  self:handleOverGameAck(msg, gameData)
    elseif msg[MSG_TYPE] == HISTORY_BEGIN_ACK then
    --  self:handleHistoryMsgBeginAck(msg, gameData)
    elseif msg[MSG_TYPE] == HISTORY_END_ACK then
      self:handleHistoryMsgEndAck(msg, gameData)
    elseif msg[MSG_TYPE] == INIT_GAMETABLE_ACK then
      self:handleInitGameTableAck(msg, gameData)
    elseif msg[MSG_TYPE] == PLAYER_SITDOWN_ACK then
      self:handlePlayerSitDownAck(msg, gameData)
    elseif msg[MSG_TYPE] == ADDHP_ACK then
      self:handleAddHPAck(msg, gameData)
    elseif msg[MSG_TYPE] == GAME_SIMPLE_ACTION_ACK then
      self:handleGameSimpleActionAck(msg, gameData)
    elseif msg[MSG_TYPE] == RULERINFOEX_ACK then
      self:handleRulerInfoAck(msg, gameData)
    elseif msg[MSG_TYPE] == PUSH_MATCH_AWARD then
      self:handlePushMatchAward( gameData )
    elseif msg[MSG_TYPE] == PUSH_PLAYER_GAME_DATA_ACK then
      self:handlePushPlayerGameData(msg, gameData)
    elseif msg[MSG_TYPE] == PUSH_GAME_COUNT_AWARDINFO_ACK then
      self:handlePushGameCountAwardInfo(msg, gameData)
    elseif msg[MSG_TYPE] == PUSH_RULERINFO_ACK then
      self:handlePushRulerInfo(msg, gameData)
    elseif msg[MSG_TYPE] == GAME_JACKPOT_WINNER_ACK then
      self:handleJackPotWinner(msg, gameData)
    elseif msg[MSG_TYPE] == NETBREAK_ACK then
      self:handleNetBreakAck(msg, gameData)
    elseif msg[MSG_TYPE] == NETRESUME_ACK then
      self:handleNetResumeAck(msg, gameData)
    elseif msg[MSG_TYPE]  == TIP_MSG_ACK then

      local ack  = msg.match_ack_msg.tipmsg_ack_msg
      JJLog.i("ack.text *********= " .. ack.text)
      if ack and string.find(ack.text, "系统将重新调整位置") then
          self:handleTipMsgAckMsg(msg)
          return--此条消息特殊处理，其他使用基类的处理  
      elseif ack and string.find(ack.text, "请等待其他人加入") then --参赛人数不足时停止loading动画否则用户无法退出
          self:getScene():stopLoadingAnim()
      elseif ack and string.find(ack.text, "您被淘汰出局") then --玩家积分不足基数的2倍，淘汰出局
          self:getScene():playerEliminate()
      end
    end
  elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG then
        if msg[MSG_TYPE] == COMMON_HTTP_GET_RANK_IN_MACTCH_ACK then
          self:handleGetRankInMatchAck(msg, gameData)
        end
    --网络卡的处理
  elseif msg.type == SDKMsgDef.TYPE_NET_LAZY  then
      self:handleNetPoorMsg()
  elseif msg[MSG_CATEGORY] == MATCHINFO_ACK_MSG then 
       if msg[MSG_TYPE] == MATCH_SIGN_COUNT_INFO_ACK then
            self:handleSignCountAck(msg, gameData)
       end
  elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG then 
      if msg[MSG_TYPE] == TOURNEYSIGNUPEX_ACK then
            self:handleTourneySignUpExAck(msg, gameData)
      elseif msg[MSG_TYPE] == START_CLIENT_ACK then
            self:closeSignupDlg()
      elseif msg[MSG_TYPE] == TOURNEYUNSIGNUP_ACK then
            self:handleTourneyUnSignUpAck(msg, gameData)
      end
  end


end

function InterimPlaySceneController:handleTipMsgAckMsg(msg)
    local ack = msg.match_ack_msg.tipmsg_ack_msg
    if ack then
        if string.find(ack.text, "系统将重新调整位置") then          
         self:getScene():handleTipMsgAckMsg( ack.text )
        end
    end
end

function InterimPlaySceneController:handleBeginHandAckMsg(msg)
      self:getScene():handleBeginHandAckMsg() 
end

function InterimPlaySceneController:handleTourneyUnSignUpAck(msg, gameData)
    local ack = msg.lobby_ack_msg.tourneyunsignup_ack_msg
    if ack.success_ then
        self:closeSignupDlg()
        self.gameData.showResignup = false

        self.isTuisai = true

        jj.ui.JJToast:show({text = "退赛成功",dimens = self.dimens_})
        if self.startGameParam and 
            (self.startGameParam.tourneyId_ == 0
            or self.startGameParam.tourneyId_ == ack.tourneyid) then


            JJLog.i("self__isTuisai__istrue")
        end
     end
end

function InterimPlaySceneController:handleTourneySignUpExAck(msg, gameData)
   --不再进行提示，在lobbymsgcontroller里面已经处理了
    if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
        local ack = msg.lobby_ack_msg.tourneysignupex_ack_msg
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(ack.tourneyid)
        local type = tourneyInfo and tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType
        if tonumber(type) == MatchDefine.MATCH_TYPE_TIMELY then
            --结束当前比赛
            -- self:exitMatch(false, 0)
        end

        self.isTuisai = false

        --设置新比赛的参数，切换到等待界
        if self.startGameParam then
            self.startGameParam.startType_ = self.startGameParam.TYPE_START_SIGNUP_WAIT
            self.startGameParam.productId_ = tourneyInfo.matchconfig_.productId
            self.startGameParam.tourneyId_ = ack.tourneyid
            self.startGameParam.matchType_ = type

            JJLog.i("TOURNEYSIGNUPEX_ACK__startGameParam_")
        end

        JJLog.i("TOURNEYSIGNUPEX_ACK_ACK__"..ack.tourneyid)

        --重置界面

        --报名成功，清除赛奖状状态

        --再来一局显示倒计时
        MatchInfoMsg:sendGetSignCountReq(ack.tourneyid)
        JJLog.i("sendGetSignCountReq__Interim")
    end
end

function InterimPlaySceneController:handleSignCountAck(msg, gameData)
  if gameData.showAward then
      local ack = msg.matchinfo_ack_msg.getsigncount_ack_msg
      local tid = ack and ack.tourneyid
      if tid == 0 and self.startGameParam then
          tid = self.startGameParam.tourneyId_
      end 
      JJLog.i("InterimPlaySceneController:handleSignCountAck")
      local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tid)
      local mc = tourneyInfo and tourneyInfo.matchconfig_                
      if mc then
          self.timeToMatchStartAvg = ack.matchcreateinterval
          gameData.signupplayer = ack.signupplayer
          gameData.maxmatchplayercount = ack.matchplayercount
          self:showMatchCountDown(mc.matchType, ack.signupplayer,
                                  ack.matchplayercount, tid)

          if not self.getSignupInfoScheduler then
              self.getSignTourneyId =  tid
              self.getSignupInfoScheduler = self:schedule(function() 
              MatchInfoMsg:sendGetSignCountReq(self.getSignTourneyId) end, 3)
          end
      end
  else
      self:closeSignupDlg()
  end
end

function InterimPlaySceneController:closeSignupDlg()
  self:showReSignupDlg(false)

    if self.getSignupInfoScheduler ~= nil then
        self:unschedule(self.getSignupInfoScheduler)
        self.getSignupInfoScheduler = nil
    end

    self.timeToMatchStartAvg = nil
    -- self.getSignTourneyId = nil
end

function InterimPlaySceneController:showReSignupDlg(flag, params)    
    if flag then
        self.resignupDlg_ = self.resignupDlg_ or require("game.ui.view.ReSignupDialog").new(
            {
                theme = self.theme_,
                dimens = self.dimens_,
                mask = false,
                matchType = params.matchType,
                tourneyId = params.tourneyId,
                matchPoint = params.matchPoint,
                onDismissListener = function() self.resignupDlg_ = nil end

            })
        self.resignupDlg_:show(self.scene_)        
        self.resignupDlg_:setCanceledOnTouchOutside(false)

        self.gameData.showResignup = true
    elseif self.resignupDlg_ then
        self.resignupDlg_:dismiss()
        self.resignupDlg_ = nil
    end
end

function InterimPlaySceneController:showMatchCountDown(matchType, signPlayer, maxPlayer, tourneyId)
    JJLog.i("scd", "InterimPlaySceneController:showMatchCountDown, ", tourneyId)
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
            self.resignupDlg_:setStartMatchLastTime(math.modf(avt/maxPlayer*(maxPlayer-signPlayer)))
        end
        self.resignupDlg_:setPercent(signPlayer, maxPlayer)
    end
end

function InterimPlaySceneController:handleNetPoorMsg()
    self:getScene():handleNetPoorMsg()
end

function InterimPlaySceneController:handleNetBreakAck(msg, gameData)
    local ack = msg.match_ack_msg.netbreak_ack_msg
    self:getScene():handleNetBreakAck(ack)
end

function InterimPlaySceneController:handleNetResumeAck(msg, gameData)
    local ack = msg.match_ack_msg.netresume_ack_msg
    self:getScene():handleNetResumeAck(ack)
end


function InterimPlaySceneController:handleInitCardAck(msg, data)
  data.gameStarted = true
  for i,v in ipairs(self.gameData.allPlayerInfo) do
      self:updatePlayerDisplay(v)
  end
  self:getScene():updateInitCardDisplay(data)
  MatchMsg:sendGetStagePlayerOrderReq(self.matchId_)  --发送玩家排名请求
end

function InterimPlaySceneController:handleCoinAck(msg, data)
   self:getScene():updateCoinData(data.coinData)
end

function InterimPlaySceneController:fakeDividCoin()
  local data = {}
  local msg = {}
  msg.interim_ack_msg = {}
  msg.interim_ack_msg.DivideTableCoin_ack_msg = {}

  for i=1,5 do
    msg.interim_ack_msg.DivideTableCoin_ack_msg[i] = 1000
  end

  local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
  local ack = msg.interim_ack_msg.DivideTableCoin_ack_msg
  
  for i,v in ipairs(ack) do
      gameData.divideTableCoin[i] = v
  end

  self:handleDivideTableCoinAck(nil, gameData)

end

function InterimPlaySceneController:handleOverAck(msg, data)
  local ack = msg.interim_ack_msg.Over_ack_msg

end

function InterimPlaySceneController:handleCurPrizePoolAck(msg, data)
  self:getScene():updateCurPrizePool(data.curPrizePool)
end

function InterimPlaySceneController:handleConGambAck(msg, data)
  self:getScene():updateConGambAck(data)
end

function InterimPlaySceneController:handleGambEndAck(msg, data)
  self:getScene():updateGambEndAck(msg, data)
end

function InterimPlaySceneController:handleCurPrizePoolNoteAck(msg, data)
  JJLog.i("gameData.poolNote : " .. data.poolNote)
end

function InterimPlaySceneController:handleChangeScoreAck(msg, data)
  self:getScene():handleChangeScoreAck(data)
end

function InterimPlaySceneController:handleDivideTableCoinAck(msg, data)
  self:getScene():handleDivideTableCoinAck(data)
end

function InterimPlaySceneController:handleEnterMatchAck(msg, data)
  self:getScene():handleEnterMatchAck(data)

end

function InterimPlaySceneController:handleEnterRoundAck(msg, gameData)
end

function InterimPlaySceneController:handleHistoryMsgEndAck(msg, gameData)
  if gameData.historyData ~= nil then
    data.gameStarted = true
    for i,v in ipairs(self.gameData.allPlayerInfo) do
        self:updatePlayerDisplay(v)
    end
    self:getScene():updateInitCardDisplayHistory(data)
     JJLog.i("handleHistoryMsgEndAck")
  end
end

function InterimPlaySceneController:handleInitGameTableAck(msg, gameData)
  JJLog.i("handleInitGameTableAck")
  for i,v in ipairs(gameData.allPlayerInfo) do
      self:updatePlayerDisplay(v)
      JJLog.i("updateplayer display: " .. v.tkInfo.seat .. " id:" .. v.tkInfo.userid)
  end
end

function InterimPlaySceneController:handleAddGamePlayerInfoAck(msg, gameData)
  local ack = msg.match_ack_msg.addgameplayerinfo_ack_msg
  local playerinfo = gameData:getPlayerInfoByID(ack.playerinfo.userid)
  if playerinfo ~= nil then
    self:updatePlayerDisplay(playerinfo)
  end
  
  JJLog.i("InterimPlaySceneController:handleAddGamePlayerInfoAck*********")
end

function InterimPlaySceneController:handlePlayerSitDownAck(msg, gameData)
  JJLog.i("player sit")
  JJLog.i("     *")
  JJLog.i("     *")
  JJLog.i("******")
  JJLog.i("*    *")
  local ack = msg.match_ack_msg.playersitdown_ack_msg
  local playerInfo = gameData:getPlayerInfoByID(ack.playerinfo.userid)
  if playerInfo ~= nil then
    if playerInfo.status == INTERIM_PLAYER_STATUS_EMPTY then    --当玩家积分不够时自动站起  
       gameData.standFlag = true 
        if gameData.myCoin <= gameData.minCoin then 
           
           local exchangerate = gameData.exchangerate
           if exchangerate == 0 then return  end
           local max = UserInfo.gold_*exchangerate
           
           if max < gameData.minaddtohp then                --金币不足弹出提示充值界面
              self:getScene():showNotEnoughMoney()
           else
              self:playerStandUpTip()                       --金币充足弹出补充筹码界面
           end
        end

      self:removePlayerFromSeat(playerInfo)
    else
      self:updatePlayerDisplay(playerInfo)
      self:playerSitdown(playerInfo)
    end
  else
     JJLog.i("cant find player with id " .. ack.playerInfo.userid)
  end
end

function InterimPlaySceneController:playerStandUpTip()
  self:getScene():playerStandUpTip()
end

function InterimPlaySceneController:handleAddHPAck(msg, gameData)
  self:getScene():handleAddHPAck(gameData)
end

function InterimPlaySceneController:playerSitdown(playerInfo)
  self:getScene():playerSitdown(playerInfo)
end

function InterimPlaySceneController:removePlayerFromSeat(playerInfo)
  self:getScene():removePlayerFromSeat(playerInfo) 
end

function InterimPlaySceneController:updatePlayerDisplay(playerInfo)
  self:getScene():updatePlayerDisplay(playerInfo) 
end

function InterimPlaySceneController:getScene()
  return self.scene_
end

function InterimPlaySceneController:handleGameJackPotAck(msg, gameData)
  self:getScene():updateCurPrizePool(gameData.curPrizePool)
end

function InterimPlaySceneController:handleGameJackPotCountAck(msg, gameData)
  self:getScene():updateCurPrizePool(gameData.jackpotcount)
end

function InterimPlaySceneController:handleGameSimpleActionAck( msg, gameData )
  self:getScene():updateGameSimpleActionAck(gameData)
end

function InterimPlaySceneController:handleRulerInfoAck( msg, gameData )
  self:getScene():handleRulerInfoAck(gameData)
end

function InterimPlaySceneController:handlePushMatchAward( gameData )
  self:getScene():handlePushMatchAward()
  gameData.showAward = true
  print("gameData.showAward = true")
end

function InterimPlaySceneController:handlePushPlayerGameData(msg, gameData)
  self:getScene():handlePushPlayerGameData(gameData)
end

function InterimPlaySceneController:handlePushGameCountAwardInfo( msg, gameData )
  --dump(gameData.gameCountAwardInfo_, "gameData.gameCountAwardInfo_")
  local matchData = StartedMatchManager:getMatch(self.matchId_)
  --dump(matchData.gameCountAwardInfo_, "matchData.gameCountAwardInfo_")
  self:getScene():handlePushGameCountAwardInfo(matchData)
end

function InterimPlaySceneController:handlePushRulerInfo(msg, gameData)
  local matchData = StartedMatchManager:getMatch(self.matchId_)
  
  self:getScene():handlePushRulerInfo(matchData)
end

function InterimPlaySceneController:handleGetRankInMatchAck( msg, gameData )
  self:getScene():updateGetRankInMatchAck(msg, gameData)
  -- JJLog.i("handleGetRankInMatchAck")
end

function InterimPlaySceneController:handleLocalMsg(msg, gameData)

    if msg.type == GameMsgDef.ID_UPDAGE_HEAD_IMG then
        JJLog.i("handleLocalMsg")
        self:refreshHeadImg(msg.headId, gameData)
    end

end

function InterimPlaySceneController:refreshHeadImg(headId, gameData)
    self:getScene():refreshHeadImg(headId, gameData)
end

function InterimPlaySceneController:getMatchView(viewTag)
  return require("game.ui.view.JJMatchView").new(self, self.startGameParam)
end

function InterimPlaySceneController:onResume()
  JJLog.i("onresume")
  local ret = InterimPlaySceneController.super.onResume(self)
  if Settings:getSoundBg() then
    audio.playMusic(INTERIM_SOUND.BGMUSIC, true)
  end
  
  --self.onresume = true

  return ret
end

function InterimPlaySceneController:onSceneEnterFinish()
    InterimPlaySceneController.super.onSceneEnterFinish(self)

    JJLog.i("onSceneEnterFinish")

    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    gameData.enteringScene = false

    if gameData.showAward == true then
      self:getScene():stopLoadingAnim()
    end
end

function InterimPlaySceneController:onBackPressed()
   self:getScene():onBackPressed()
end

function InterimPlaySceneController:handleJackPotWinner(msg, gameData)
    self:getScene():handleJackPotWinner(msg, gameData)
end

return InterimPlaySceneController

