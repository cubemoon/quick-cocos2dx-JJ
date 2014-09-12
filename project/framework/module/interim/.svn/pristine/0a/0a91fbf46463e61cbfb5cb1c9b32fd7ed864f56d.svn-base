local PlayerInfo = require("interim.data.InterimPlayerInfo")

-- match 消息在XXX游戏中的处理
InterimMatchMsgGameController = {gameController={}}
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_PLAYER_STATUS_EMPTY = InterimUtilDefine.INTERIM_PLAYER_STATUS_EMPTY
local INTERIM_PLAYER_STATUS_ENGAGED = InterimUtilDefine.INTERIM_PLAYER_STATUS_ENGAGED
local INTERIM_PLAYER_STATUS_STANDBY = InterimUtilDefine.INTERIM_PLAYER_STATUS_STANDBY
local INTERIM_PLAYER_STATUS_FOLD = InterimUtilDefine.INTERIM_PLAYER_STATUS_FOLD

function InterimMatchMsgGameController:passMsgToGameController(msg, gameId)
  if msg and gameId then

    if not InterimMatchMsgGameController.gameController[gameId] then
      if gameId == JJGameDefine.GAME_ID_INTERIM then
        InterimMatchMsgGameController.gameController[gameId] = require("interim.msg.InterimMsgController")
      end
    end
    InterimMatchMsgGameController.gameController[gameId]:handleMsg(msg)
  end
end

--[[
公用游戏的Match消息处理，如果某个游戏需要对某个消息做特殊处理，
调用passMsgToGameController把该消息透传到自己的gamecontroller中处理
]]
function InterimMatchMsgGameController:handleMsg(msg, gameId)
  if msg[MSG_CATEGORY] ~= MATCH_ACK_MSG then return end
  local matchId = msg.match_ack_msg.matchid
  JJLog.i("matchMsg:matchId****************: " .. matchId)
  local gameData = GameDataContainer:getGameData(matchId)
  if not gameData then return end

  local ack = msg.match_ack_msg
  local msgType = msg[MSG_TYPE]

  -- 消息：进入比赛确认消息，得到比赛的Context
  if msgType == ENTER_MATCH_ACK then
    -- 更新排名信息
    MatchMsg:sendPushUserPlaceOrderPositionReq(matchId)
    local ack = msg.match_ack_msg.entermatch_ack_msg
    gameData.matchName = ack.matchname
    JJLog.i("matchname: " .. gameData.matchName)
    local matchrank = ack.matchrank
    JJLog.i("matchrank: " .. matchrank)
    local titlestyle = ack.titlestyle
    JJLog.i("titlestyle: " .. titlestyle)
    gameData.interimMatchId = ack.matchid
    JJLog.i("matchMsg:matchId: " .. ack.matchid)
  elseif msgType == INIT_GAMETABLE_ACK then
  
    JJLog.i("INIT_GAMETABLE_ACK")
    local ack = msg.match_ack_msg.initgametable_ack_msg
    gameData:resetGame()

    dump(ack, "INIT_GAMETABLE_ACK")
   
    -- playerinfolist是在按照所有座位顺序排列，包括空玩家
    -- 服务器座位索引从0开始
    for k,v in pairs(ack.playerinfolist) do
      gameData.allPlayerInfo[k] = PlayerInfo.new()
      local playerInfo = gameData.allPlayerInfo[k]
      
      playerInfo.tkInfo.userid = v.userid
      JJLog.i("**********playerInfo.tkInfo.userid" .. playerInfo.tkInfo.userid)
      playerInfo.tkInfo.nickname = v.nickname
      JJLog.i("**********playerInfo.tkInfo.nickname" .. playerInfo.tkInfo.nickname)
      playerInfo.tkInfo.figureId = v.figureid
      JJLog.i("**********playerInfo.tkInfo.figureId" .. playerInfo.tkInfo.figureId)
      playerInfo.tkInfo.seat = k
      playerInfo.tkInfo.arrived = true
    end

    gameData.maxaddtohp = ack.maxaddtohp
    gameData.minaddtohp = ack.minaddtohp
    gameData.exchangerate = 10000/ack.exchangerate
    JJLog.i("gameData.maxaddtohp: " .. gameData.maxaddtohp)
    JJLog.i("gameData.minaddtohp: " .. gameData.minaddtohp)
    JJLog.i("gameData.exchangerate: " .. gameData.exchangerate)
    gameData.hpmode = ack.hpmode
    JJLog.i("gameData.hpmode: " .. ack.hpmode)
  -- 每局开始之前会逐个重新获得所有玩家信息
  elseif msgType == ADD_GAMEPLAYERINFO_ACK then
  
    local ack = msg.match_ack_msg.addgameplayerinfo_ack_msg
   
    JJLog.i("XXXXXXXXXXXXXXXXXXXXXXXX")
    JJLog.i("ADD_GAMEPLAYERINFO_ACK: " .. ack.playerinfo.seatorder)
    JJLog.i("XXXXXXXXXXXXXXXXXXXXXXXX")
     
    local seatIndex = ack.playerinfo.seatorder + 1
    if ack.playerinfo.arrived == true then
      local playerInfo = PlayerInfo.new()
      gameData.allPlayerInfo[seatIndex] = playerInfo
      playerInfo.tkInfo.seat = seatIndex
      playerInfo.tkInfo.userid = ack.playerinfo.userid
      playerInfo.tkInfo.nickname = ack.playerinfo.nickname
      playerInfo.tkInfo.figureId = ack.playerinfo.figureid
       --JJLog.i("头像figureId:" .. ack.playerinfo.figureid)
      playerInfo.tkInfo.matchrank = ack.playerinfo.matchrank
      --JJLog.i("玩家排名：matchrank" .. playerInfo.tkInfo.matchrank .. "nickname: " .. playerInfo.tkInfo.nickname .. "seatIndex" .. seatIndex)
      playerInfo.tkInfo.score = ack.playerinfo.score
      --JJLog.i("添加玩家，积分：" .. playerInfo.tkInfo.score)
      if playerInfo.tkInfo.userid == UserInfo.userId_ then
        --JJLog.i("设置我的积分gameData.myCoin = playerInfo.tkInfo.score " .. gameData.myCoin .. " new: " .. playerInfo.tkInfo.score)
        if gameData.property.isTourny == true then
          gameData.myCoin = playerInfo.tkInfo.score
        else
          if playerInfo.tkInfo.score ~= 0 then
            gameData.myCoin = playerInfo.tkInfo.score
          end
        end
      end

      playerInfo.tkInfo.arrived = ack.playerinfo.arrived
      playerInfo.tkInfo.netStatus = ack.playerinfo.netstatus
      playerInfo.handChips = ack.playerinfo.score
      playerInfo.dataUpdated = true
      playerInfo.status = INTERIM_PLAYER_STATUS_STANDBY
    end
   
   -- 主角玩家坐下以后的消息
  elseif msgType == PLAYER_SITDOWN_ACK then
    
    local ack = msg.match_ack_msg.playersitdown_ack_msg
    local seatIndex = ack.seat + 1
    JJLog.i("seat:" .. seatIndex)
    if ack.seat < 0 then
        if ack.playerinfo.userid == UserInfo.userId_ then
          JJLog.i("User self stand up")
        end
    end

    gameData.status = false

    if seatIndex > 0 then
      JJLog.i("XXXXXXXXXXXXXXXXXXXXXXXX")
      JJLog.i("detecting player enter game : " .. seatIndex)
      JJLog.i("player id : " .. ack.playerinfo.userid)
      JJLog.i("XXXXXXXXXXXXXXXXXXXXXXXX")
     
      local playerInfo = PlayerInfo.new()
      gameData.allPlayerInfo[seatIndex] = playerInfo
      playerInfo.tkInfo.seat = seatIndex
      playerInfo.tkInfo.userid = ack.playerinfo.userid
      playerInfo.tkInfo.nickname = ack.playerinfo.nickname
      playerInfo.tkInfo.figureId = ack.playerinfo.figureid
      JJLog.i("头像figureId:" .. ack.playerinfo.figureid)
      playerInfo.tkInfo.ready = ack.playerinfo.ready
      playerInfo.tkInfo.score = 0
      playerInfo.dataUpdated = true
      playerInfo.status = INTERIM_PLAYER_STATUS_STANDBY
    else
      local playerInfo = gameData:getPlayerInfoByID(ack.playerinfo.userid)
      if playerInfo ~= nil then
       -- playerInfo.tkInfo.seat = seatIndex
        playerInfo.tkInfo.userid = ack.playerinfo.userid
        playerInfo.tkInfo.nickname = ""
        playerInfo.tkInfo.score = 0
        playerInfo.dataUpdated = false
        playerInfo.status = INTERIM_PLAYER_STATUS_EMPTY 
      end
    end
  elseif msgType == ENTER_ROUND_ACK then
  
  elseif msg[MSG_TYPE] == BEGIN_HAND_ACK then

  -- elseif msg[MSG_TYPE] == GAME_JACKPOT_ACK then
  --   local ack = msg.match_ack_msg.gamejackpot_ack_msg
  --   gameData.jackpotcount = ack.jackpotcount
  --   gameData.jackpotinfo = ack.jackpotinfo
  --   JJLog.i("jackpotcount: " .. gameData.jackpotcount)
  --   JJLog.i("jackpotinfo" .. gameData.jackpotinfo)
    
  -- elseif msg[MSG_TYPE] == GAME_JACKPOT_COUNT_ACK then
  --   local ack = msg.match_ack_msg.gamejackpotcount_ack_msg
  --   gameData.jackpotcount = ack.jackpotcount

  elseif msg[MSG_TYPE] == RULER_INFO_ACK then
    local ack = msg.match_ack_msg.rulerinfo_ack_msg
    local property = ack.property
    JJLog.i("property : " .. property)
  
  elseif msg[MSG_TYPE] == RULERINFOEX_ACK then
    local ack = msg.match_ack_msg.rulerinfoex_ack_msg
    local property = ack.propertyex
    JJLog.i("propertyex : " .. property)

    local result = string.split(property, ",")

    for k,v in pairs(result) do
       JJLog.i(v)
    end
    gameData.property.callTime = result[1]
    gameData.property.lotteryTime = result[2]

    local rate = result[11]
    rate = string.split(rate, "%")
    rate = tonumber(rate[1])*0.0001
    gameData.property.fiveFlushRewardRate = rate
    JJLog.i("gameData.property.fiveFlushRewardRate : " .. gameData.property.fiveFlushRewardRate)

    rate = result[12]
    rate = string.split(rate, "%")
    rate = tonumber(rate[1])*0.0001
    gameData.property.AJ4RewardRate = rate
    JJLog.i("gameData.property.AJ4RewardRate : " .. gameData.property.AJ4RewardRate)

    rate = result[13]
    rate = string.split(rate, "%")
    rate = tonumber(rate[1])*0.0001
    gameData.property.flushRewardRate = rate
    JJLog.i("gameData.property.flushRewardRate : " .. gameData.property.flushRewardRate)

    rate = result[14]
    rate = string.split(rate, "%")
    rate = tonumber(rate[1])*0.0001
    gameData.property.normal4RewardRate = rate
    JJLog.i("gameData.property.normal4RewardRate : " .. gameData.property.normal4RewardRate)

    gameData.property.poolBottom = tonumber(result[21])

    if result[22] == "1" then
      gameData.property.isTourny = true
    else
      gameData.property.isTourny = false
    end

    if gameData.property.isTourny == true then
      gameData:resetUpdatedPlayer()
      gameData:unflagAllPlayerInfo()
    end

  elseif msg[MSG_TYPE] == GAME_SIMPLE_ACTION_ACK then
    local ack = msg.match_ack_msg.gamesimpleaction_ack_msg
    gameData.emote.useridfrom = ack.useridfrom
    gameData.emote.emotionid = ack.emotionid + 1

  elseif msg[MSG_TYPE] == ADDHP_ACK then
    local ack = msg.match_ack_msg.addhp_ack_msg
    gameData.hpadded = ack.hpadded
    JJLog.i("添加筹码 : " .. ack.hpadded)
    gameData.myCoin = gameData.myCoin + ack.hpadded
 
  elseif msg[MSG_TYPE] == HISTORY_BEGIN_ACK then
    local ack = msg.match_ack_msg.historymsgbegin_ack_msg
    if gameData.property.isTourny == true then
      gameData.enteringHistory = true 
      gameData.historyMyCoin = gameData.myCoin
      JJLog.i("历史消息开始")
    end

  elseif msg[MSG_TYPE] == HISTORY_END_ACK then
    local ack = msg.match_ack_msg.historymsgend_ack_msg
    if gameData.property.isTourny == true then
      gameData.enteringHistory = false
      gameData.historyMyCoin = nil
      JJLog.i("历史消息结束" .. #gameData.historyData)
      if gameData.historyData ~= nil then

        gameData.bankSeat = gameData.historyData.bankSeat
        gameData.firstSeat = gameData.historyData.firstSeat
        JJLog.i("setting first seata " .. gameData.firstSeat)
        gameData.cardCount = gameData.historyData.cardCount
        gameData.playerCount = gameData.historyData.playerCount
        gameData.nBaseScore = gameData.historyData.nBaseScore
        gameData.tableCoin = gameData.historyData.tableCoin
        
        JJLog.i("playerCards")
        gameData.playerCards[1] = gameData.historyData.playerCards[1]
        gameData.playerCards[2] = gameData.historyData.playerCards[2]
        for i,v in ipairs(gameData.playerCards) do
          JJLog.i(v)
        end

        for i=1,5 do
          gameData.allPlayerInfo[i]:resetCard()
        end
      
        JJLog.i("cardCount: " .. gameData.cardCount .. " playerCount: "  .. gameData.playerCount)
        JJLog.i("nBaseScore: " .. gameData.nBaseScore .. " enProba: "  .. gameData.enProba)
        JJLog.i("anBottomCoin: ")
        gameData.anBottomCoin = {}
        for i,v in ipairs(gameData.historyData.anBottomCoin) do
          local coin = gameData.historyData.anBottomCoin[i]
          if coin > 0 and gameData.minCoin == nil then
            gameData.minCoin = coin * 6
          end

          gameData.anBottomCoin[#gameData.anBottomCoin + 1] = coin
          JJLog.i(gameData.historyData.anBottomCoin[i])
          -- 参与发牌的玩家，下注玩家才会发牌
          if coin > 0 then
            gameData.allPlayerInfo[i].status = INTERIM_PLAYER_STATUS_ENGAGED

            if gameData.allPlayerInfo[i].tkInfo.userid == UserInfo.userId_ then
              gameData.allPlayerInfo[i].cardLeft = gameData.playerCards[1]
              gameData.allPlayerInfo[i].cardRight = gameData.playerCards[2]
              JJLog.i("设置玩家左右卡：" .. gameData.allPlayerInfo[i].cardLeft .. 
                  " " .. gameData.allPlayerInfo[i].cardRight)
              gameData.allPlayerInfo[i].cardMiddle = nil
            else
              gameData.allPlayerInfo[i].cardLeft = 0
              gameData.allPlayerInfo[i].cardRight = 0
              gameData.allPlayerInfo[i].cardMiddle = nil
            end

          else
            if gameData.allPlayerInfo[i].tkInfo.userid ~= 0 then
              gameData.allPlayerInfo[i].status = INTERIM_PLAYER_STATUS_STANDBY
            end
          end
      end

      gameData.roundInfo.roundId = gameData.roundInfo.roundId + 1
      
      gameData.coinData = {}
      gameData:roundStarting()

      end
    end

  elseif msg[MSG_TYPE] == GAME_JACKPOT_WINNER_ACK then
    local ack = msg.match_ack_msg.gamejackpotwinner_ack_msg  
    local winnercount = ack.winnercount
    gameData.recieveNewWiner = true 
    JJLog.i("winnercount :****" .. winnercount)
    local desc = ack.desc
    if desc ~= nil then
      local result = string.split(desc, ",")

      gameData.winnerDesc = {}
      for k,v in pairs(result) do
         gameData.winnerDesc[#gameData.winnerDesc + 1] = v
      end
    end
  elseif msg[MSG_TYPE] == PUSH_PLAYER_GAME_DATA_ACK then
    local ack = msg.match_ack_msg.pushplayergamedata_ack_msg
      gameData.playerGameData.userid = ack.userid
      gameData.playerGameData.exchangerate = ack.exchangerate
      gameData.playerGameData.leftchip = ack.leftchip
      gameData.playerGameData.totalfinishedgamecount = ack.totalfinishedgamecount
      gameData.playerGameData.curgamehand = ack.curgamehand
      gameData.playerGameData.curfinishedgamecount = ack.curfinishedgamecount
      gameData.myCoin = ack.leftchip

      JJLog.i("ack.userid" ..  ack.userid .. ":".. ack.exchangerate .. ":" .. ack.leftchip .. ":" .. ack.totalfinishedgamecount)

  elseif msg[MSG_TYPE] == PUSH_MATCH_AWARD then
    local ack = msg.match_ack_msg.pushmatchaward_ack_msg
    local awardText = ack.awardtext
    local matchAward = require("game.data.match.MatchAwardData").new()
    matchAward:initWithXml(awardText, UserInfo.nickname_)
    gameData.matchAward = matchAward
    gameData.showAward = true
    print("比赛结果 matchAward")
    dump(gameData.matchAward, "matchAward")

  elseif msg[MSG_TYPE] == PUSH_USERORDER_ACK then
    local ack = msg.match_ack_msg.pushuserplaceorderposition_ack_msg
    gameData.leavePlayer = ack.totalplayercount
    gameData.rank = ack.playercurplaceorder + 1
  elseif msg[MSG_TYPE] == STAGEPLAYER_ORDER_ACK then
    --gameData:setMatchPlayers(msg.match_ack_msg.stageplayerorder_ack_msg.orderlist)
    --JJLog.i("************************排名信息")
  elseif msg[MSG_TYPE] == PUSH_RULERINFO_ACK then
      local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
 
      if gameData.roundInfo.scoreBase == nil 
        or gameData.roundInfo.scoreBase < matchData.roundInfo_.scoreBase_ then
        gameData.roundInfo.scoreBase = matchData.roundInfo_.scoreBase_
        gameData.roundInfo.showScoreBase = true
      end

      if gameData.roundInfo.roundId ~= matchData.roundInfo_.roundId_ - 1 then
        gameData.roundInfo.roundId = matchData.roundInfo_.roundId_ - 1
      end

      JJLog.i("收到比赛详情")
      dump(matchData.roundInfo_, "matchData.roundInfo")
       if matchData.baseRaiseTime_ ~= nil then
         JJLog.i("*****************baseraisetime:   " .. matchData.baseRaiseTime_)
       end
  elseif msg[MSG_TYPE] ==TIP_MSG_ACK then
          JJLog.i("*************TIP_MSG_ACK*************")
         
  elseif msg[MSG_TYPE] == MATCH_OPTION_ACK then
        local ack = msg.match_ack_msg.matchoption_ack_msg
        local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
        JJLog.i(TAG, "MATCH_OPTION_ACK IN msg is ", vardump(ack.flags))
        JJLog.i(TAG, "MATCH_OPTION_ACK IN msg is ", bit.band(ack.flags, 0x02) == 0x02)
      
        matchData.isSupportChangeTable_ = bit.band(ack.flags, 0x02) == 0x02
  else

    self:passMsgToGameController(msg, gameId)
  end
end

