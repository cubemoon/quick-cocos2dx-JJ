
require("sdk.ui.init")
local InterimPlayScene = class("InterimPlayScene", require("game.ui.scene.PlayScene"))

local BackgroundView = require("interim.ui.view.BackgroundView")
local PlayView = require("interim.ui.view.PlayView")
local UIView = require("interim.ui.view.UIView")
local PositionConfig = require("interim.util.PositionConfig")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_POPVIEW_NONE = InterimUtilDefine.INTERIM_POPVIEW_NONE
local INTERIM_POPVIEW_MATCHAWARD = InterimUtilDefine.INTERIM_POPVIEW_MATCHAWARD 

-- 游戏界面初始化
function InterimPlayScene:ctor(controller) 
  InterimPlayScene.super.ctor(self, controller)
  self.controller = controller
 
end
local count = 0
function InterimPlayScene:initView()
    InterimPlayScene.super.initView(self)
	
	-- if Util.screenOrientation == 0 then  --竖屏时直接返回 ，不初始化view PC端用不到 只在android上使用
	-- 	return
	-- 	print("InterimPlayScene:initView")
	-- end

    print("初始化界面 initView" .. "count :" .. count)
    count = count + 1
   
   -- if count> 1 then
  	--  	return
   -- end

    self.positionConfig = PositionConfig.new(self)
	self.backgroundView = BackgroundView.new(self)
	self:addView(self.backgroundView)

	self.playView = PlayView.new(self)
	self:addView(self.playView)

	if self.uiView ~= nil then
		self.uiView:stopUpdateTimer()  
	end
	     

	self.uiView = UIView.new(self)
	self:addView(self.uiView)

    if self.playView then
   		self:stopCountDown()
	end

  	self:refreshCoinPool()
end

function InterimPlayScene:getController()
	return self.controller
end

function InterimPlayScene:playerEliminate()
	self.uiView:showForceMessage("很遗憾，您的积分不够2倍基数，您被淘汰出局了", 2)
end

function InterimPlayScene:onDestory()
   InterimPlayScene.super.onDestory( self )
   JJLog.i("InterimPlayScene:onDestory")
   self:stopUpdateTimer()
   self:stopCountDown()
   self.uiView:stopAllActions()
   self.playView:stopAllActions()
   self.uiView = nil
   self.playView = nil
   self.backgroundView = nil
end

function InterimPlayScene:playerStandUpTip()
	self.uiView:showBuyChipView()
	self.uiView:showForceMessage("您的金币过低，请补充后继续", 2)
end

function InterimPlayScene:showNotEnoughMoney()
	self.uiView:showNotEnoughMoney()
end

function InterimPlayScene:calculateBetByExpect(expect)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()
	if playerInfo == nil then
		JJLog.i("calculateBetByExpect " .. expect .. " playerInfo nil, return 0")
		return 0
	end
	JJLog.i("calculateBetByExpect " .. expect)
	local myCoin = playerInfo.tkInfo.score
	local balance = gameData:getPlayerCardBalance()
	JJLog.i("balance : " .. balance)
	local multi = 1
	if balance == 0 then
		multi = 25
	elseif balance == 2 then
		multi = 12
	elseif balance == 3 then
		multi = 6
	elseif balance == 4 then
		multi = 4
	elseif balance == 5 then
		multi = 3
	end

	local betCoin = expect
	

	-- if gameData.property.isTourny == true then
	-- 	if betCoin < gameData.nBaseScore then
	-- 		betCoin = gameData.nBaseScore
	-- 	end
	-- end
	-- if betCoin < gameData.nBaseScore then
	-- 		betCoin = gameData.nBaseScore
	-- end

	if betCoin > myCoin  then
		betCoin = myCoin
	end

	if betCoin > gameData.tableCoin then
		betCoin = gameData.tableCoin
	end

	JJLog.i("betcoin : " .. betCoin)
	JJLog.i("my coni : " .. myCoin)
	return betCoin
end

function InterimPlayScene:onViewCallback(sender , message)
	if message == "max" then

		print("onViewCallback max")
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		local tableCoin = gameData.tableCoin
		local playerInfo = gameData:getMyPlayerInfo()
		if playerInfo ~= nil then
			--local betCoin = self:calculateBetByExpect(tableCoin)
			local betCoin = sender.value
		InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, playerInfo.tkInfo.seat)
		end
	elseif message == "min" then
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		local playerInfo = gameData:getMyPlayerInfo()
		if playerInfo ~= nil then
			-- local betCoin = self:calculateBetByExpect(gameData.nBaseScore)
			local betCoin = sender.value
			InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, playerInfo.tkInfo.seat)
		end
	elseif message == "25percent" then
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		local tableCoin = gameData.tableCoin
		local playerInfo = gameData:getMyPlayerInfo()
		if playerInfo ~= nil then
			-- local betCoin = self:calculateBetByExpect(tableCoin*0.25)
			local betCoin = sender.value
			InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, playerInfo.tkInfo.seat)
		end
	elseif message == "50percent" then
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		local tableCoin = gameData.tableCoin
		local playerInfo = gameData:getMyPlayerInfo()
		if playerInfo ~= nil then
			-- local betCoin = self:calculateBetByExpect(tableCoin*0.5)
			local betCoin = sender.value
			InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, playerInfo.tkInfo.seat)
		end
	elseif message == "fold" then
		-- local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		-- local playerInfo = gameData:getMyPlayerInfo()
		-- InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, playerInfo.tkInfo.seat)	
		self.playView:autoFold()
	elseif message == "Deal" then
		
	end
end

function InterimPlayScene:onPlayViewClicked(sender)
	math.randomseed(os.time())
	local randomCard = math.random(52)
	sender:dealMiddleCard(randomCard)
end

function InterimPlayScene:updatePlayerDisplay(playerInfo)
 	self.playView:updatePlayerDisplay(playerInfo)

end

function InterimPlayScene:removePlayerFromSeat(playerInfo)
	self.playView:removePlayerFromSeat(playerInfo)
	self.uiView:hideEmoteButton()
	-- if playerInfo ==  then
	-- 	--todo
	-- end
	self.uiView:setTrustAndAutoByButtonVisible(true)  -- 站起时移除头像的同时显示换桌快速坐下，托管和自动补码按钮
	self.playView:alertStopAnimation()
end

function InterimPlayScene:handleNetPoorMsg()
    self.uiView:handleNetPoorMsg()
end

function InterimPlayScene:handleNetBreakAck(msg)
     self.playView:handleNetBreak( msg.seatorder, true )
end

function InterimPlayScene:handleNetResumeAck(msg)
     self.playView:handleNetBreak( msg.seatorder, false )
end

function InterimPlayScene:updateInitCardDisplay(data)
	self:delayUpdateInitCardDisplay()
	self.playView:alertStopAnimation()           --当重新发牌时说明玩家网络已恢复正常
end

function InterimPlayScene:handleTipMsgAckMsg( text )
	 self.uiView:showTipMsg(text)
end

function InterimPlayScene:handleBeginHandAckMsg()
	self.uiView:closeTip()
end

function InterimPlayScene:delayUpdateInitCardDisplay()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	self.uiView:stopLoadingAnim()
	JJLog.i("delayUpdateInitCardDisplay *** stopLoadingAnim()")

	if gameData.isDiggerEnd == false and gameData. popviewStatus == INTERIM_POPVIEW_DRAWCARD then
		self.uiView:hideDrawCardView()
	end

	self.uiView:updateInitCardDisplay(gameData)
  	self.playView:updateInitCardDisplay(gameData)
  	self.backgroundView:updateInitCardDisplay(gameData)

end

function InterimPlayScene:updateInitCardDisplayHistory( gameData )
	self.uiView:updateInitCardDisplay(gameData)
  	self.playView:updateInitCardDisplayHistory(gameData)
  	self.backgroundView:updateInitCardDisplay(gameData)

end

function InterimPlayScene:updateCoinData(data)
	self.playView:playCoinData(data)
	self.uiView:stopLoadingAnim()
	--JJLog.i("updateCoinData *** stopLoadingAnim()")
	self.playView:alertStopAnimation() 					--超时之后轮到下一家叫牌，这时把超时动画停掉
end

function InterimPlayScene:refreshCoinPool()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	if gameData.tableCoin < 0 then
		gameData.tableCoin = 0
	end
	self.backgroundView:setPoolCoin(gameData.tableCoin)
	--self.uiView:stopLoadingAnim()
	--JJLog.i("refreshCoinPool *** stopLoadingAnim()")
end

function InterimPlayScene:handleEnterMatchAck(gameData)
	self.uiView.rankView:setRoomTitle(gameData.matchName)
	--self.uiView:stopLoadingAnim()
	JJLog.i("handleEnterMatchAck *** stopLoadingAnim()")
end

function InterimPlayScene:exitGame()
    self.controller:exitMatch(true)
end

function InterimPlayScene:stopCountDown()
	self.playView:stopCountDown()
end

function InterimPlayScene:playAgain()
    self.controller:reSignupMatch()
end

function InterimPlayScene:shareGame()
    --self.controller:shareGame()
end

function InterimPlayScene:callBySetting(setting, tableCoin, seatIndex)
	if setting.max == true then
		if setting.flushOnly == true then
			-- 检测是否同花
			-- todo
			local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
			local flush = gameData:checkPlayerCardIsFlush()
			if flush == true then
				local betCoin = self:calculateBetByExpect(tableCoin)
				InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, seatIndex)	

			else
				InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, seatIndex)
			
			end
		else
			local betCoin = self:calculateBetByExpect(tableCoin)
			InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, betCoin, seatIndex)
		end
	else
		InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, seatIndex)		
	end
end

function InterimPlayScene:myTurn()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	--JJLog.i("轮到玩家myTurn")
	--比赛场有自动弃牌的功能 
	gameData.bMyTurn = true
	if (gameData.standFlag == true and gameData.property.isTourny == false) or 
		(gameData.autoFold  == true and gameData.property.isTourny == true)  then --如果玩家站起 或者 该比赛进入自动弃牌状态
		self.playView:autoFold()
		return
	end

	if gameData.delegated == true then
		-- 托管
		local tableCoin = gameData.tableCoin
		local playerInfo = gameData:getMyPlayerInfo()
		local balance = gameData:getPlayerCardBalance()
		if playerInfo ~= nil then
		--	local betCoin = self:calculateBetByExpect(tableCoin)
			if balance == 1 then
				InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, playerInfo.tkInfo.seat)
			elseif balance == 0 then
				local setting = gameData.delegateSetting[1]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 2 then
				local setting = gameData.delegateSetting[2]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 3 then
				local setting = gameData.delegateSetting[3]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 4 then
				local setting = gameData.delegateSetting[4]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 5 then
				local setting = gameData.delegateSetting[5]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 6 then
				local setting = gameData.delegateSetting[6]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 7 then
				local setting = gameData.delegateSetting[7]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 8 then
				local setting = gameData.delegateSetting[8]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 9 then
				local setting = gameData.delegateSetting[9]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 10 then
				local setting = gameData.delegateSetting[10]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 11 then
				local setting = gameData.delegateSetting[11]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			elseif balance == 12 then
				local setting = gameData.delegateSetting[12]
				self:callBySetting(setting, tableCoin, playerInfo.tkInfo.seat)
			end
		end
	else
		local balance = gameData:getPlayerCardBalance()
		if balance == 1 then
			self.playView:autoFold()     --自动弃牌
		
		else
			-- 	InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, playerInfo.tkInfo.seat)
			-- 	return
			local tableCoin = gameData.tableCoin
			JJLog.i("********************tableCoin:" ..  tableCoin .. "Balance:" .. balance)
			local min = self:calculateBetByExpect(gameData.nBaseScore)
			local max = 0
			if balance == 0 then
				max = self:calculateBetByExpect(math.ceil(tableCoin/25))
			elseif balance == 2 then
				max = self:calculateBetByExpect(math.ceil(tableCoin/12))
			elseif balance == 3 then
				max = self:calculateBetByExpect(math.ceil(tableCoin/6))
			elseif balance == 4 then
				max = self:calculateBetByExpect(math.ceil(tableCoin/4))
			elseif balance == 5 then
				max = self:calculateBetByExpect(math.ceil(tableCoin/3))
			else
				max = self:calculateBetByExpect(math.ceil(tableCoin/2))
			end
			
			local p25 = self:calculateBetByExpect(tableCoin*0.25)
			local p50 = self:calculateBetByExpect(tableCoin*0.50)
 
			if min == p25 and min < p50 then
				p25 = p50
				p50 = 0
			elseif min == p25 and min == p50 then
				p25 = 0
				p50 = 0
			end

		local baseCoin = 0 
		local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)

		if matchData.roundInfo_ ~= nil then
            baseCoin = matchData.roundInfo_.scoreBase_
        end
			self.uiView:setActionBarValue(baseCoin, 10*baseCoin, 20*baseCoin, max)
			self:showActionBar()
		end	
	end
end

function InterimPlayScene:myTurnFinished()
	self.uiView:hideActionBar()
	local  gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	gameData.bMyTurn = false
end

function InterimPlayScene:updateCurPrizePool(pool)
	local  gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	if gameData.property.isTourny == false then
		self.uiView.lotteryView:setNumber(pool)
	end
end

function InterimPlayScene:showToggleBar()
	self.uiView:showToggleBar()
end

function InterimPlayScene:showActionBar()
	self.uiView:showActionBar()
end

function InterimPlayScene:showPlayerInfo(seatIndex, layoutIndex)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getPlayerInfoBySeatIndex(seatIndex)
	self.uiView:showPlayerInfo(playerInfo, layoutIndex)
end

function InterimPlayScene:hideUIBar()
	self.uiView:showStandBar()
end

function InterimPlayScene:standUp()
	self.playView:standUp()
end

function InterimPlayScene:updateGameSimpleActionAck(gameData)
	self.playView:updateGameSimpleActionAck(gameData)
end

function InterimPlayScene:fastSit()
	self.playView:fastSit()
end

function InterimPlayScene:refreshData()
	JJLog.i("InterimPlayScene:refreshData")
	self.playView:refreshData()
	self.uiView:refreshData()
end

function InterimPlayScene:onExit()
	audio.stopBackgroundMusic()
	JJLog.i("InterimPlayScene:onExit")
end

function InterimPlayScene:stopLoadingAnim()
	self.uiView:stopLoadingAnim()
end

function InterimPlayScene:onEnter()
	InterimPlayScene.super.onEnter(self)
	--self:refreshData()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	if gameData.showAward then
		self.uiView:stopLoadingAnim()
	end

	
	-- self.uiView:stopLoadingAnim()  --暂时启用
end

function InterimPlayScene:stopUpdateTimer()
	self.uiView:stopUpdateTimer()
end

function InterimPlayScene:showDrawCardView(cardCount, handCard, playerInfo)
	self.uiView:showDrawCardView(cardCount, handCard, playerInfo)

end

function InterimPlayScene:updateGambEndAck(msg, data)
	self.uiView:updateGambEndAck(data)
end

function InterimPlayScene:updateConGambAck(data)
	self.uiView:updateConGambAck(data)
end

function InterimPlayScene:roundStarted()
	
end

function InterimPlayScene:roundFinished()
	
end

function InterimPlayScene:showEmptyTableNextRound()
	self.uiView:showEmptyTableNextRound()
end

function InterimPlayScene:handleChangeScoreAck(gameData)
	--self.uiView:stopLoadingAnim()
	JJLog.i("handleChangeScoreAck *** stopLoadingAnim()")
end

function InterimPlayScene:handleDivideTableCoinAck(gameData)
	
	local  array = CCArray:create()
	local delay = CCDelayTime:create(2)
	array:addObject(delay)
	local callFunc = CCCallFunc:create(handler(self, self.delayDivideTableCoin))
	array:addObject(callFunc)
	
	local sequence = CCSequence:create(array)	
	self:runAction(sequence)

end

function InterimPlayScene:delayDivideTableCoin()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	gameData.tableCoin = 0
	self.playView:playDivideTableCoinAck(gameData)
	self.uiView:playDivideTableCoinAck(gameData)
	self:refreshCoinPool()
end

function InterimPlayScene:getTakenSeats()
	local seatTable = {}
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	
	for i,v in ipairs(gameData.allPlayerInfo) do
		if v.tkInfo.userid ~= 0 then
			local seatIndex = v.tkInfo.seat
			local seat = self.playView:getSeatBySeatIndex(seatIndex)
			seatTable[#seatTable + 1] = seat
		end
	end

	return seatTable
end

function InterimPlayScene:updateGetRankInMatchAck(msg, gameData)
--	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	JJLog.i("updateGetRankInMatchAck")
	JJLog.i("msg rank : " .. msg.rank)
	JJLog.i("msg userid : " .. msg.userid)
	local userID = toint(msg.userid)
	local playerInfo = gameData:getPlayerInfoByID(userID)

	if playerInfo then
		local seat = self.playView:getSeatBySeatIndex(playerInfo.tkInfo.seat)
		playerInfo.rank = msg.rank
		playerInfo.score = msg.score
		self.uiView:showPlayerInfo(playerInfo, seat.layoutIndex)
	else
	--	self.uiView:showPlayerInfo(playerInfo)
	end

end

function InterimPlayScene:refreshHeadImg(headId, gameData)
	for i,v in ipairs(gameData.allPlayerInfo) do
      if v.tkInfo.figureId == tonum(headId) and v.tkInfo.userid ~= 0 then
        local seat = self.playView:getSeatBySeatIndex(v.tkInfo.seat)
        local path = HeadImgManager:getImg(v.tkInfo.userid, v.tkInfo.figureId)
        if path then
        	seat.playerView.portrait:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(path)
			CCTextureCache:sharedTextureCache():removeTexture(texture)
			texture = CCTextureCache:sharedTextureCache():addImage(path)
      		seat.playerView.portrait:setTexture(texture)
        end
      end
    end 
end

function InterimPlayScene:onBackPressed()

	if self.uiView.popviewStatus == INTERIM_POPVIEW_MATCHAWARD then
		self:exitGame()
	elseif self.uiView.popviewStatus ~= INTERIM_POPVIEW_NONE then
		self.uiView:maskViewTouched()
	else
		self.uiView:showExitView()
	end
end

-- 玩家发牌后判断连号由playView调用
function InterimPlayScene:autoFold()
	self.uiView.messageView:showAutoFold()
end

function InterimPlayScene:playerSitdown(playerInfo)
   self.uiView:playerSitdown(playerInfo)
end

function InterimPlayScene:handleRulerInfoAck(gameData)
	if gameData.property.isTourny == false then
         self.uiView.lotteryView.numberLabel:setVisible(true)
    else
        self.uiView.lotteryView.numberLabel:setVisible(false)
 	end
end

function InterimPlayScene:handlePushMatchAward()
	self.uiView:showMatchAward()
	self.uiView:stopLoadingAnim() --解决最后一把出牌时点击home键退出游戏，然后再进入游戏时不显示奖状页面
	--gameData.showAward = false
    --显示奖状时游戏结束，停掉游戏中的定时器
    self:stopCountDown()
end

function InterimPlayScene:handlePushPlayerGameData(gameData)
  self.uiView:handlePushPlayerGameData(gameData)
end

function InterimPlayScene:handlePushGameCountAwardInfo(matchData)
	self.uiView:handlePushGameCountAwardInfo(matchData)
end

function InterimPlayScene:handlePushRulerInfo(matchData)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    if gameData.property.isTourny == true 
    	and gameData.roundInfo.showScoreBase == true then
    	local baseText = "基数"
    	if matchData.roundInfo_.scoreBase_ ~= nil then
    		local scoreString = InterimUtil:getStandBetChipsDispShort(matchData.roundInfo_.scoreBase_)
            baseText = "基数:" ..  scoreString 
    	end
		
	    JJLog.i(baseText)
    	self.uiView:showForceMessage(baseText,0)
    	gameData.roundInfo.showScoreBase = false
    	self.uiView.startCountDown = false  
	end
end

function InterimPlayScene:handleAddHPAck(gameData)
	self.uiView:handleAddHPAck(gameData)
end

function InterimPlayScene:handleJackPotWinner(msg, gameData)
    self.uiView:handleJackPotWinner(gameData)
end

return InterimPlayScene
