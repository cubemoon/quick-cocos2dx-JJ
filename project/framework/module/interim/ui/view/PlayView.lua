
local JJViewGroup = require("sdk.ui.JJViewGroup")
local CardGroup = require("interim.ui.view.CardGroup")
local CardView = require("interim.ui.view.CardView")
local SeatView = require("interim.ui.view.SeatView")
local AnimationFactory = require("interim.util.AnimationFactory")
local PlayView = class("PlayView", JJViewGroup)
local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_PLAYER_STATUS_EMPTY = InterimUtilDefine.INTERIM_PLAYER_STATUS_EMPTY
local INTERIM_PLAYER_STATUS_ENGAGED = InterimUtilDefine.INTERIM_PLAYER_STATUS_ENGAGED
local INTERIM_PLAYER_STATUS_STANDBY = InterimUtilDefine.INTERIM_PLAYER_STATUS_STANDBY
local INTERIM_PLAYER_STATUS_FOLD = InterimUtilDefine.INTERIM_PLAYER_STATUS_FOLD

local INTERIM_RESULT = InterimUtilDefine.INTERIM_RESULT 
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND
--local InterimDimens = require("interim.ui.InterimDimens")

function PlayView:ctor(parentScene)
	PlayView.super.ctor(self)
	self.parentScene = parentScene
	self.positionConfig = parentScene.positionConfig
    self.theme_ = parentScene.theme_
    self.dimens_ = parentScene.dimens_
	self:initView()
	self.nextSeatIndex = -1
	self.shouldPlaySitAnim = true
	-- self.gameData = viewController.gameData
end

function PlayView:initView()
	
	local backCard = CardView.new()
    backCard:setAnchorPoint(ccp(0.5, 0.5))
    local pos = ccp(self.positionConfig.dealCardStartPosition.x, 
    	self.positionConfig.dealCardStartPosition.y - self.dimens_:getDimens(0))
    backCard:setPosition(pos)
    self:addView(backCard)
    backCard:setScale(self.dimens_.scale_)
    backCard:setRotation(90)

    -- backCard = CardView.new()
    -- backCard:setAnchorPoint(ccp(0.5, 0.5))
    -- pos = ccp(self.positionConfig.dealCardStartPosition.x, 
    -- 	self.positionConfig.dealCardStartPosition.y + self.dimens_:getDimens(10))
    -- backCard:setPosition(pos)
    -- self:addView(backCard)
    -- backCard:setScale(self.dimens_.scale_)

	self.seatTable = {}

	self.dealingCard = false

	for i=1,5 do
		self.seatTable[i] = SeatView.new(self)
		self:addView(self.seatTable[i])
		self.seatTable[i]:setSeatIndex(i)
		self.seatTable[i]:setLayoutIndex(i)
		
 	--	local imageFile = "img/interim/common/roboticon" .. i .. "_info.png" 
	--	local texture = CCTextureCache:sharedTextureCache():addImage(imageFile)
    --   	self.seatTable[i].playerView.portrait:setTexture(texture)
      
	end

	for i=1,5 do
		self.seatTable[i]:hideCards()
	end

	self:refreshData()

end

function PlayView:updateInitCardDisplayHistory(gameData)

	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
       		
	if gameData.enteringHistory == true
	 	 and gameData.property.isTourny == true then
		return
	end

	local dealer = gameData.bankSeat
	local firstSeat = gameData.firstSeat
	for i=1,5 do
		seat = self.seatTable[i]
		if seat.seatIndex == dealer then
			seat:setDealer(true)
		else
			seat:setDealer(false)
		end

		if seat.seatIndex == firstSeat then
			seat:setCalling(false)
		else
			seat:setNormal()
		end

		seat:hideCards()
		local coinBet = gameData.anBottomCoin[i]
		if coinBet > 0 then
			seat:bottomBet(coinBet)
		end
	end

	self:startDealCardInstant()

	local myPlayerInfo = gameData:getMyPlayerInfo()
	if myPlayerInfo and gameData.firstSeat == myPlayerInfo.tkInfo.seat then
		self.parentScene:myTurn()

	end
end


function PlayView:updateInitCardDisplay(gameData)
	-- if true then
	-- 	return
	-- end
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
 		
	if gameData.enteringHistory == true
	 	 and gameData.property.isTourny == true then
		return
	end

	local dealer = gameData.bankSeat
	local firstSeat = gameData.firstSeat
	for i=1,5 do
		seat = self.seatTable[i]
		if seat.seatIndex == dealer then
			seat:setDealer(true)
		else
			seat:setDealer(false)
		end

		if seat.seatIndex == firstSeat then
			seat:setCalling(false)
		else
			seat:setNormal()
		end

		seat:hideCards()
		local coinBet = gameData.anBottomCoin[i]
		if coinBet > 0 then
			seat:bottomBet(coinBet)
		end
	end

	--local startIndex = gameData.firstSeat
	--self:startDealCard(startIndex)
	--self.dealingCard = true

	--JJLog.i("重置玩家信息")
	-- for i,v in ipairs(gameData.allPlayerInfo) do
	-- 	if v.tkInfo.userid ~= 0 then
	-- 		v.cardLeft = 0
	-- 		v.cardRight = 0
	-- 	end
	-- end
	
	-- if self:checkHasMyself() then
	-- 	self:showUserBar()
	-- end
	if gameData.enteringScene == false then
		-- local array = CCArray:create()
	 --    array:addObject(CCDelayTime:create(0.1))
	 --    array:addObject(CCCallFunc:create(handler(self, self.delayedStartDealCard)))
	 --    local seq = CCSequence:create(array)
	 --    self:runAction(seq) 
	 	if gameData.enteringHistory == true
	 	 and gameData.property.isTourny == true then
		 -- 	self:startDealCardInstant()
			-- local myPlayerInfo = gameData:getMyPlayerInfo()
			-- if gameData.firstSeat == myPlayerInfo.tkInfo.seat then
			-- 	self.parentScene:myTurn()
			-- end
		else
			self:delayedStartDealCard()
			JJLog.i("准备定时发牌")
	 	end
	else
		JJLog.i("啊啊啊啊")
		self:startDealCardInstant()

		local myPlayerInfo = gameData:getMyPlayerInfo()
		if myPlayerInfo and gameData.firstSeat == myPlayerInfo.tkInfo.seat then
			self.parentScene:myTurn()
		end
	end
end

function PlayView:startDealCardInstant()
	JJLog.i("立刻发牌")
		
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
 	for i,v in ipairs(gameData.allPlayerInfo) do
 		if v.tkInfo.userid == UserInfo.userId_ then
 			if  gameData.playerCards[1] ~= 256 and gameData.playerCards[2] ~= 256 then
	 		 	JJLog.i("我的牌：" .. gameData.playerCards[1] .. " " .. gameData.playerCards[2])
	 			local seat = self:getSeatBySeatIndex(v.tkInfo.seat)
	 			seat:hideIcons()
	 			seat:setMyself(true)
				seat.cardGroup:dealCardInstant(gameData.playerCards[1], gameData.playerCards[2])
				seat:showCardTip()

			end
		elseif v.tkInfo.userid ~= 0 then
			local seat = self:getSeatBySeatIndex(v.tkInfo.seat)
			seat:setMyself(false)
			seat:hideIcons()
			seat.cardGroup:dealCardInstant(0, 0)
		end
 	end

end

function PlayView:delayedStartDealCard()
	for i=1,5 do
		self.seatTable[i]:cancelCoinData()
		self.seatTable[i].cardGroup:hideCards()
	end

	self:stopAllActions()
	self.dealingCard = true
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
 	local startIndex = gameData.firstSeat
	self:startDealCard(startIndex)
end

function PlayView:cancelDealingCard()
	JJLog.i("中断发牌")
	self.dealingCard = false

	self:stopAllActions()
	self:startDealCardInstant()
end

function PlayView:updatePlayerDisplay(playerInfo)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	for i=1,5 do

		local seat = self.seatTable[i]
		if seat.userid == 0 then
			if gameData.property.isTourny == true  then
				seat:setVisible(false)           --比赛桌不显示空位
				print("seat.userid == 0 比赛桌不显示空位")
			else
				seat:setVisible(true)            --自由桌显示空位
				print("seat.userid != 0 自由桌显示空位")
			end
		end

	end

    local seat = self:getSeatBySeatIndex(playerInfo.tkInfo.seat)
    if seat == nil then 
    	print("PlayView:updatePlayerDisplay************seat == nil")
    	return
    else
    	seat:setVisible(true)
   		seat:setPlayerInfo(playerInfo)
	end
	
    if self:checkIsMyself(playerInfo.tkInfo.seat) == true
    	and seat.layoutIndex ~= 1 then
    	print("PlayView:checkIsMyself************ == true")
    	print("my seat is " .. playerInfo.tkInfo.seat)
    	
    	if seat.layoutIndex == 2 then
    		self:rollSeatCW(1)
    	elseif seat.layoutIndex == 3 then
    		self:rollSeatCW(2)
    	elseif seat.layoutIndex == 4 then
    		self:rollSeatACW(2)
    	elseif seat.layoutIndex == 5 then
    		self:rollSeatACW(1)
    	end

    	if self.dealingCard == true then
			self:cancelDealingCard()
		else
       		if #gameData.coinData ~= 0 then
			local seat = self:getSeatBySeatIndex(gameData.coinData.seat)
				if seat then
					seat:cancelCoinData()
					seat:playCoinDataInstant(gameData.coinData)
				end
			end
		end
		--自己坐下后头像弹动俩下
		
		if gameData.property.isTourny == false  then
    		self:seatElasticAction(seat)
			gameData.fastSitFlag = false
		else
			--seat:showResult( playerInfo.enResult )
    	end
		
	elseif  gameData.fastSitFlag == true then  		
			self:seatElasticAction(seat)
			gameData.fastSitFlag = false
    end

    if gameData.property.isTourny == true  then
    	seat:refreshCardCache()
    end
	
end

function PlayView:seatElasticAction(seat)
		local array = CCArray:create()
		local moveBy = CCMoveBy:create(0.25, ccp(0, 20))
		array:addObject(moveBy)
		local moveBack = moveBy:reverse()
		array:addObject(moveBack)
		local moveBy2 = CCMoveBy:create(0.25, ccp(0, 10))
		array:addObject(moveBy2)
		local moveBack2  = moveBy2:reverse()
		array:addObject(moveBack2)
		local callBack = CCCallFuncN:create(function ()
			seat:setLayoutIndex(1)
		end)
		array:addObject(callBack)

		local  seqAction = CCSequence:create(array)
		seat:runAction(seqAction)
end

function PlayView:setSeatPos( seat )
		seat:setLayoutIndex(1)
end

function PlayView:removePlayerFromSeat(playerInfo)
	local seat = self:getSeatBySeatIndex(playerInfo.tkInfo.seat)
	if UserInfo.userId_ == playerInfo.tkInfo.userid then
		self.parentScene:hideUIBar()
	end
	playerInfo.tkInfo.userid = 0
   	seat:setPlayerInfo(playerInfo)
end

function PlayView:playCoinData(data)
	-- if true then
	-- 	return 
	-- end
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
       		
	if gameData.enteringHistory == true
	 	 and gameData.property.isTourny == true then
		return
	end

	if self.dealingCard == true then
		self:cancelDealingCard()
	end

	local seatIndex = data.seat
	local seat = self:getSeatBySeatIndex(seatIndex)

	if self:checkValidCoinData(data) == false then
		return
	end

	JJLog.i("叫牌playCoinData")

	self.nextSeatIndex = data.nextSeat
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	gameData.firstSeat = self.nextSeatIndex
	
	if self.nextSeatIndex ~= nil then
		JJLog.i("seatIndex: " .. seatIndex .. " self.nextSeatIndex: " .. self.nextSeatIndex)
	end
	

	local mySeat = self:getMySeat()
	-- if mySeat == nil or mySeat.seatIndex ~= seatIndex then
	-- 	self:callSeat(seat, false)
	-- end

	if mySeat ~= nil
	 --and mySeat.seatIndex ~= seatIndex 
	 then
		self:showUserBar()
	end

	JJLog.i("data.coin: " .. data.coin )
	JJLog.i("data win: " .. data.coinWin)
	
	--seat.cardGroup:setTipe("")
	if gameData.enteringScene == false then

		if gameData.enteringHistory == true and gameData.property.isTourny == true then
			-- if data.coin > 0 then
			-- 	seat:playCoinDataInstant(data)

			-- 	gameData.tableCoin = gameData.tableCoin + data.coin - data.coinWin
			-- 	self.parentScene:refreshCoinPool()

			-- 	self:seatPlayCardFinished(seat)
			-- else
			-- 	if data.drawCard == 256 and gameData.tableCoin > 0 then
			-- 		seat:showFoldCard()
			-- 		self:seatPlayCardFinished(seat)
			-- 	end
			-- end
		else
			if data.coin > 0 then
				seat:playCoinData(data)
			else
				if data.drawCard == 256 and gameData.tableCoin > 0 then
					seat:showFoldCard()
					self:seatPlayCardFinished(seat)
				end
			end
		end
	else
		if data.coin > 0 then
			seat:playCoinDataInstant(data)

			gameData.tableCoin = gameData.tableCoin + data.coin - data.coinWin
			self.parentScene:refreshCoinPool()
			self:seatPlayCardFinished(seat)
		else
			if data.drawCard == 256 and gameData.tableCoin > 0 then
				seat:showFoldCard()
				self:seatPlayCardFinished(seat)
			end
		end
		
	end

end

function PlayView:checkValidCoinData(data)
	if data.coin == 0 and data.coinWin == 0 and data.seat == 1
		and data.nextSeat == 1 and data.drawCard == 1
	 then
		return false
	end
	return true
end

function PlayView:seatPlayCardFinished(seat)
	seat:setNormal()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	if gameData == nil then
		return
	end
	
	-- 锦标赛
	if gameData.property.isTourny == true then
		JJLog.i("gameData.tableCoin : " .. gameData.tableCoin)
		JJLog.i("self.seatIndex " .. seat.seatIndex  .. " gameData.bankSeat" .. gameData.bankSeat)
		if self:checkIsMyself(seat.seatIndex) == false
			and seat.seatIndex ~= gameData.bankSeat and gameData.tableCoin == 0 then
			self.parentScene:showEmptyTableNextRound()
		end
		if self.nextSeatIndex ~= nil then
			local nextSeat = self:getSeatBySeatIndex(self.nextSeatIndex)
			if nextSeat ~= nil then
				self:callSeat(nextSeat, true)
			end
		end
	else 	-- 岛屿赛
		-- 判断是否触发挖宝
		if gameData.coinData.enResult == INTERIM_RESULT.Kasame                      --卡豹子
			or gameData.coinData.enResult == INTERIM_RESULT.Threesamestraight       --同花顺
			or gameData.coinData.enResult == INTERIM_RESULT.Kainth2                 --同花双卡
			or gameData.coinData.enResult == INTERIM_RESULT.Kainth3                 --同花三卡
		then
			-- 触发挖宝
			local wallCardCount = gameData.coinData.wallCardCount
			local playerInfo = gameData:getPlayerInfoBySeatIndex(seat.seatIndex)
			if playerInfo then
				local handCard = {}
				handCard[1] = gameData.coinData.abyCard[1]
				handCard[2] = gameData.coinData.abyCard[3]
				handCard[3] = gameData.coinData.abyCard[2]
				self.parentScene:showDrawCardView(wallCardCount, handCard, playerInfo)
			end
		else
			JJLog.i("gameData.tableCoin : " .. gameData.tableCoin)
			JJLog.i("self.seatIndex " .. seat.seatIndex  .. " gameData.bankSeat" .. gameData.bankSeat)
			if self:checkIsMyself(seat.seatIndex) == false
				and seat.seatIndex ~= gameData.bankSeat and gameData.tableCoin == 0 then
				self.parentScene:showEmptyTableNextRound()
				self:checkPlayerStand(gameData)
			end
			if self.nextSeatIndex ~= nil then
				local nextSeat = self:getSeatBySeatIndex(self.nextSeatIndex)
				if nextSeat ~= nil then
					self:callSeat(nextSeat, true)
				end
			end
		end

		-- 叫牌一圈以后，判断玩家是否站立
		if seat.seatIndex == gameData.bankSeat then
			self:checkPlayerStand(gameData)
		end
	end
end

function PlayView:checkPlayerStand(gameData)
	local playerInfo = gameData:getMyPlayerInfo()
	if playerInfo == nil then
		return
	end
	if gameData.standFlag == true then
		--gameData.standFlag = false
		MatchMsg:sendMarkPlayerIdleReq(INTERIM_MATCH_ID, true)
	end
end

function PlayView:callSeat(seat, bCountDown)
	--JJLog.i("开始叫牌")
	self:stopCountDown()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local tableCoin = gameData.tableCoin
	if tableCoin == 0 then
	--	self.parentScene:showEmptyTableNextRound()
		return
	end
	if seat == nil then
		return
	end
	JJLog.i("callseat: " .. seat.seatIndex .. " tablecoin" .. tableCoin)
	if self:checkIsMyself(seat.seatIndex) == true then
		-- self:autoFold()

		if self:playerShouldFold() == true then
			self:autoFold()
		else
		 	self.parentScene:myTurn()
		 	seat:setCalling(bCountDown)         --自己出牌倒计时
		end
	else
		self.parentScene:myTurnFinished()       --自己出牌结束
		seat:setCalling(bCountDown)              --其他玩家出牌倒计时
	end

end

function PlayView:playerShouldFold()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()
	if playerInfo == nil then
		return false
	end
	if playerInfo.status ~= INTERIM_PLAYER_STATUS_ENGAGED then
		return true
	end

	local mySeat = self:getMySeat()

	local card1, card2 = gameData.playerCards[1], gameData.playerCards[2]
	if card1 == 256 or card2 == 256 then
		return true
	end

	local balance = mySeat:getCardBalance()
	if balance == 1 then
		return true
	end

	return false
end

function PlayView:autoFold()

	JJLog.i("autofold")
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()
	self:stopCountDown()
	InterimMsg:sendCoinReqMsg(INTERIM_MATCH_ID, 0, playerInfo.tkInfo.seat)

	local mySeat = self:getMySeat()  -- 解决从后台切回前台时不显示赢牌倍数的问题
	if mySeat ~= nil then
		mySeat.cardGroup:setTipe("")
	end

end

function PlayView:checkIsMyself(seatIndex)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getPlayerInfoBySeatIndex(seatIndex)
	local myUserid = UserInfo.userId_
	if myUserid == playerInfo.tkInfo.userid then
		return true
	end
	return false
end

function PlayView:getSeatByLayoutIndex(layoutIndex)
	for i=1,5 do
		if self.seatTable[i].layoutIndex == layoutIndex then
			return self.seatTable[i]
		end
	end
	return nil
end

function PlayView:fastSit()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	
	local seatIndex = 0
	local curTablePlayerCount = 0
	for i,v in ipairs(gameData.allPlayerInfo) do
		if v.tkInfo.userid == 0 then
			seatIndex = v.tkInfo.seat
			JJLog.i("fastSit:seatIndex*************" .. seatIndex)
			break
		else
			curTablePlayerCount = curTablePlayerCount + 1
		end
	end

	if self:checkHasMyself() == false and seatIndex ~= 0  and curTablePlayerCount < 5 then
		JJLog.i(gameData.myCoin)
		JJLog.i("my coin "  )
		if gameData.myCoin ~= nil and gameData.minCoin ~= nil then
			JJLog.i("my coin " .. gameData.myCoin)
			if gameData.myCoin < gameData.minCoin then
			 --self.parentScene.uiView:showAlertView("坐下失败", "您的金币过低，请补充后继续")
				self.parentScene.uiView:showForceMessage("坐下失败" .. "您的金币过低，请补充后继续", 2)
				self.parentScene.uiView:showBuyChipView()
			else
				MatchMsg:sendPlayerSitDownReq(INTERIM_MATCH_ID, seatIndex - 1)
			end
		else
			MatchMsg:sendPlayerSitDownReq(INTERIM_MATCH_ID, seatIndex - 1)
		end
		gameData.fastSitFlag = true   --成功发送
	elseif gameData.standFlag == true then
		self.parentScene.uiView:showForceMessage("当前座位已满，请换桌", 2)
	end
end

function PlayView:getSeatBySeatIndex(seatIndex)
	for i=1,5 do
		if self.seatTable[i].seatIndex == seatIndex then
			return self.seatTable[i]
		end
	end
	return nil
end

function PlayView:rollSeatCW(step)
	if step ~= 2 and step ~= 1 then
		return
	end

	for i=1,5 do
		local newIndex = self.seatTable[i].layoutIndex - step
		if newIndex <= 0 then
			newIndex = newIndex + 5
		end
		--self.seatTable[i]:moveToNewIndex(newIndex)
		self.seatTable[i]:setLayoutIndex(newIndex)
	end
end

function PlayView:rollSeatACW(step)
	if step ~= 2 and step ~= 1 then
		return
	end
	for i=1,5 do
		local newIndex = self.seatTable[i].layoutIndex + step
		if newIndex > 5 then
			newIndex = newIndex - 5
		end
		--self.seatTable[i]:moveToNewIndex(newIndex)
		self.seatTable[i]:setLayoutIndex(newIndex)
	end
end

function PlayView:checkSeatFull()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local full = true
	for i=1,5 do
		local playerInfo = gameData.allPlayerInfo[i]
		if playerInfo.tkInfo.userid == 0 then
			full = false
			break
		end
	end
	return full
end

function PlayView:checkHasMyself()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local has = false
	for i=1,5 do
		local playerInfo = gameData.allPlayerInfo[i]
		if playerInfo.tkInfo.userid == UserInfo.userId_ then
			has = true
			break
		end
	end
	return has
end

function PlayView:getMySeat()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local seat = nil
	for i=1,5 do
		local playerInfo = gameData.allPlayerInfo[i]
		if playerInfo.tkInfo.userid == UserInfo.userId_ then
			seat = self:getSeatBySeatIndex(playerInfo.tkInfo.seat)
			break
		end
	end
	return seat
end

function PlayView:showUserBar()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()
 
	local seat = self:getMySeat()
	if seat ~= nil then
		if playerInfo.status == INTERIM_PLAYER_STATUS_STANDBY then
     		-- self.parentScene:messageBottomTooMuch()
     	else
     		JJLog.i("self.parentScene:showToggleBar showUserBar")
     		self.parentScene:showToggleBar()
     	end
	end
end

function PlayView:startDealCard(startIndex)
	JJLog.i("开始发牌startDealCard, " .. startIndex)
	for i=1,5 do
		self.seatTable[i]:resetCard()
	end
	self.startIndex = startIndex
	self.currentSeatIndex = startIndex
	local array = CCArray:create()
    array:addObject(CCDelayTime:create(0.1))
    array:addObject(CCCallFunc:create(handler(self, self.dealCard)))
	local seq = CCSequence:create(array)
	self:runAction(seq)

	--SoundManager:playEffect("sound/interim/b_ShuffCard.mp3")
	--SoundManager:playEffect("sound/lordunion/lord_gamewin.ogg")

	SoundManager:playEffect(INTERIM_SOUND.SHUFFLE)
end

function PlayView:moveToNextSeatIndex()
	self.currentSeatIndex = self.currentSeatIndex + 1
	if self.currentSeatIndex > 5 then
		self.currentSeatIndex = 1
	end
end

function PlayView:checkSeatActive(seat)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	if gameData == nil then
		return false
	end
	local playerInfo = gameData:getPlayerInfoBySeatIndex(seat.seatIndex)
	if seat.userid == 0 or playerInfo.status ~= INTERIM_PLAYER_STATUS_ENGAGED then
		return false
	end

	return true
end

function PlayView:dealCard()
	local seat = self:getSeatBySeatIndex(self.currentSeatIndex)

	if seat == nil then
		JJLog.i("detect seat nil at " .. self.currentSeatIndex)
		return
	end

	SoundManager:playEffect(INTERIM_SOUND.GRAB)
	
	local checkSeatActive = self:checkSeatActive(seat)
	if checkSeatActive == true then
		local checkMySelf = seat.myself

		if checkMySelf == true then
			local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
			local card = 256
			if seat.dealtCount == 0 then
				card = gameData.playerCards[1]
			elseif seat.dealtCount == 1 then
				card = gameData.playerCards[2]
			end
		
			if card ~= 256 then
				seat:dealCard(card)
			--	JJLog.i("发牌给玩家: " .. card .. " 座位号:" .. seat.seatIndex)
			end
		else
			seat:dealCard(0)
		--	JJLog.i("发牌给其他人: " .. 0 .. " 座位号:" .. seat.seatIndex)
		end

		self:moveToNextSeatIndex()
		
		seat = self:getSeatBySeatIndex(self.currentSeatIndex)
		if self.currentSeatIndex == self.startIndex
			and seat.dealtCount >= 2 then
			--and seat:handCardFull() == true then
			self:dealCardEnd()
			JJLog.i("dealcardEnd")
			return
		end

		local array = CCArray:create()
	    array:addObject(CCDelayTime:create(0.1))
	    array:addObject(CCCallFunc:create(handler(self, self.dealCard)))
		local seq = CCSequence:create(array)
		self:runAction(seq)
	else
		seat.dealtCount = seat.dealtCount + 1
		self:moveToNextSeatIndex()
		seat = self:getSeatBySeatIndex(self.currentSeatIndex)
		if self.currentSeatIndex == self.startIndex
			and seat.dealtCount >= 2 then
			--and seat:handCardFull() == true then

			local array = CCArray:create()
		    array:addObject(CCDelayTime:create(0.2))
		    array:addObject(CCCallFunc:create(handler(self, self.dealCardEnd)))
		    local seq = CCSequence:create(array)
		    self:runAction(seq) 

			--self:dealCardEnd()
			--JJLog.i("dealcardEnd")
			return
		end
		local callNext = CCCallFunc:create(handler(self, self.dealCard))
		self:runAction(callNext)
	end
end

function PlayView:dealCardEnd()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()

	self.dealingCard = false
	JJLog.i("结束发牌")

	local mySeat = self:getMySeat()
	if mySeat ~= nil then
		mySeat:showCardTip()
	end
	local startIndex = gameData.firstSeat
	JJLog.i("call first seat " .. startIndex)
	local seat = self:getSeatBySeatIndex(startIndex)
	self:callSeat(seat, true)
end

function PlayView:callBetFinished(coin)
	self.parentScene:refreshCoinPool()
end

function PlayView:playerGainCoin(coinBet, coinWon)
	if coinWon > 0 then
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		if gameData then
			gameData.tableCoin = gameData.tableCoin + coinBet - coinWon
			self.parentScene:refreshCoinPool()
		end
	end	
end

function PlayView:playerLoseCoin(coinBet)
	JJLog.i("playerLoseCoin " .. coinBet)
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)

	if gameData == nil then 
		return
	end

	gameData.tableCoin = gameData.tableCoin + coinBet
	self.parentScene:refreshCoinPool()
end

function PlayView:onPlayerClicked(seatView)                              --点击座位坐下时调用的方法
	local seatIndex = seatView.seatIndex
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getPlayerInfoBySeatIndex(seatIndex)
	if playerInfo == nil or playerInfo.tkInfo.userid == 0 then
		if self:checkHasMyself() == false then
			-- 坐下
			if gameData.myCoin ~= nil and gameData.minCoin ~= nil then
				JJLog.i("my coin " .. gameData.myCoin)
				JJLog.i("gameData.minCoin" .. gameData.minCoin)
				if gameData.myCoin <= gameData.minCoin then

				  --self.parentScene.uiView:showAlertView("坐下失败", "您的金币过低，请补充后继续")
					self.parentScene.uiView:showForceMessage("坐下失败" .. "您的金币过低，请补充后继续", 2)
				  	self.parentScene.uiView:showBuyChipView()
				else
					MatchMsg:sendPlayerSitDownReq(INTERIM_MATCH_ID, seatIndex - 1)
					self.parentScene.uiView.standButton:setChecked(false)       --设置下局旁观状态
					self.parentScene.uiView.standByTipLabel:setVisible(false)   --隐藏提示信息
				end
			else
				MatchMsg:sendPlayerSitDownReq(INTERIM_MATCH_ID, seatIndex - 1)
				self.parentScene.uiView.standButton:setChecked(false)       --设置下局旁观状态
				self.parentScene.uiView.standByTipLabel:setVisible(false)   --隐藏提示信息
			end

		end
	else
		JJLog.i("view otherplayer")
		local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
		local playerInfo = gameData:getPlayerInfoBySeatIndex(seatIndex)
		HttpMsg:sendGetRankInMatchReq(JJGameDefine.GAME_ID_INTERIM, playerInfo.tkInfo.userId)

		--self:showPlayerInfo(seatView.seatIndex)

		-- todo 查看其他用户
	end
end

function PlayView:showPlayerInfo(seatIndex, layoutIndex)
	self.parentScene:showPlayerInfo(seatIndex, layoutIndex)

end

function PlayView:standUp()                    -- 玩家站起
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local playerInfo = gameData:getMyPlayerInfo()
	if playerInfo then
		playerInfo.status = INTERIM_PLAYER_STATUS_STANDBY  
	end
end

function PlayView:updateGameSimpleActionAck( gameData )
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	JJLog.i("emote : " )
	JJLog.i("user id : " .. gameData.emote.useridfrom)
	JJLog.i("emote id : " .. gameData.emote.emotionid)
	local playerInfo = gameData:getPlayerInfoByID(gameData.emote.useridfrom)
	local seat = self:getSeatBySeatIndex(playerInfo.tkInfo.seat)
	if seat then
		seat:showEmote(gameData.emote.emotionid)
	end
end

function PlayView:countDownExpire()
	-- 倒计时结束

	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local matchData = StartedMatchManager:getMatch(INTERIM_MATCH_ID)
	if gameData.property.isTourny == true then
		local bDelegate = false       
		for i=1,5 do
			if gameData.delegateMatchID[i] == matchData.productId_ then
				bDelegate = true
			end
		end
		if bDelegate then
			gameData.delegated = true
			self.parentScene.uiView.trustButton:setVisible(true)
			self.parentScene.uiView.autoFoldButton:setVisible(false)
			self.parentScene.uiView.standByTipLabel:setVisible(true)   --显示提示信息
			JJLog.i("trust*********************1")
		else
			gameData.autoFold = true
			self.parentScene.uiView.trustButton:setVisible(false)
			self.parentScene.uiView.autoFoldButton:setVisible(true)
			self.parentScene.uiView.autoFoldLabel:setVisible(true)
			self.parentScene.uiView.autoFoldButton:setChecked(true)       --设置一直弃牌状态
			self.parentScene.uiView.standByTipLabel:setVisible(true)   --显示提示信息
			self.parentScene.uiView.standByTipLabel:setText("已进入自动弃牌状态") 
			JJLog.i("trust*********************2")
		end
		self:autoFold()	
	else
		self:autoFold()
		self.parentScene.uiView.standButton:setChecked(true)       --设置下局旁观状态
		gameData.standFlag = true
		self.parentScene.uiView.standByTipLabel:setVisible(true)   --显示提示信息
		self.parentScene.uiView.canNotEngaedTip:setVisible(false)  
    	JJLog.i("*************************Next StandBy2")
		MatchMsg:sendMarkPlayerIdleReq(INTERIM_MATCH_ID, true)   --玩家没有进行任何操作，下局站起
	end
	-- self:autoFold()
end

function PlayView:stopCountDown()
	for i=1,5 do
		local seat = self.seatTable[i]
		seat:stopCountDown()
	end
end

function PlayView:alertStopAnimation()
	for i=1,5 do
		local seat = self.seatTable[i]
		seat:alertStopAnimation()
	end
end

function PlayView:handleNetBreak( seatIndex, netState )
	local seat = self:getSeatBySeatIndex(seatIndex)
	seat:showBreakNetState(netState)
end



function PlayView:playDivideTableCoinAck(gameData)

	if #gameData.coinData ~= 0 then
		JJLog.i("有叫牌数据 ，位置：" .. gameData.coinData.seat)
		local seat = self:getSeatBySeatIndex(gameData.coinData.seat)
		if seat then
			JJLog.i("中断叫牌")
			--seat:cancelCoinData()
			seat:playCoinDataInstant(gameData.coinData)
		end
	else
		JJLog.i("分牌，没有叫牌数据")
	end
	gameData.tableCoin = -10000000
	for i,v in ipairs(gameData.divideTableCoin) do
		if v > 0 then
			local seat = self:getSeatBySeatIndex(i)
			if seat ~= nil then
				seat:playGainCoin(v)
				local playerInfo = gameData:getPlayerInfoBySeatIndex(seat.seatIndex)
				seat.score = playerInfo.tkInfo.score
				seat:refreshScore()
			end
		elseif v == 0 then
			local playerInfo = gameData:getPlayerInfoBySeatIndex(i)
			local seat = self:getSeatBySeatIndex(i)
			seat:cancelCoinData()
			seat:reset()
			seat.playerView:alertStopAnimation()
			seat:setPlayerInfo(playerInfo) 
		end
	end
end

function PlayView:refreshData()

	if self.dealingCard == true then
		print("playview....................")
		return
	end
	self.shouldPlaySitAnim = false

	print("onresume playview重新刷新数据")
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)

	if gameData.property.isTourny == true  then
		for i,v in ipairs(gameData.allPlayerInfo) do
   			self:updatePlayerDisplay(v)
   			print("onresume playview重新刷新数据 gameData.property.isTourny == true")
   		end
   		self:showCardTip()
		self:showDelear()
		return
	end
	-- 	print("onresume playview重新刷新数据 gameData.property.isTourny == false")

	local seatIndex = 0
	for i,v in ipairs(gameData.allPlayerInfo) do
		print("PlayViewplayerScore:1-" .. v.tkInfo.score .. ", seatNum: " .. v.tkInfo.seat)
		seatIndex = v.tkInfo.seat
		local seat = self:getSeatBySeatIndex(seatIndex)
		if v.tkInfo.userid ~= 0 then
			
			if seat then
				seat:setVisible(true)   
				print("自由桌显示空位 --1")          
				if v.tkInfo.userid == UserInfo.userId_ and seat.layoutIndex ~= 1 then
					
					if seat.layoutIndex == 2 then
			    		self:rollSeatCW(1)
			    	elseif seat.layoutIndex == 3 then
			    		self:rollSeatCW(2)
			    	elseif seat.layoutIndex == 4 then
			    		self:rollSeatACW(2)
			    	elseif seat.layoutIndex == 5 then
			    		self:rollSeatACW(1)
			    	end

			    	if self.dealingCard == true then
						self:cancelDealingCard()
					else
						if gameData.coinData ~= nil then
							local seat = self:getSeatBySeatIndex(gameData.coinData.seat)
							if seat then
								seat:cancelCoinData()
								seat:playCoinDataInstant(gameData.coinData)
								seat:refreshCardCache()
							end
						end
					end

				end
				print("************allPlayerInfoEnd............")
				seat:reset()
				seat:setPlayerInfo(v)
				seat:refreshCardCache()
			end
		end
		
	end
	
	self:showCardTip()
	self:showDelear()

		
	print("PlayViewgameData.allPlayerInfoEnd" .. #gameData.allPlayerInfo)
end

function PlayView:onEnter()   
    PlayView.super.onEnter(self) 
end

function PlayView:showDelear()
	local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
	local dealer = gameData.bankSeat  --解决从后台切回时不显示庄家位置的bug 
	for i=1,5 do
		local seat = self.seatTable[i]
		if seat.seatIndex == dealer then
			seat:setDealer(true)
		else
			seat:setDealer(false)
		end
	end
end

function PlayView:showCardTip()
	local mySeat = self:getMySeat()  -- 解决从后台切回前台时不显示赢牌倍数的问题
	if mySeat ~= nil then
		mySeat:setMyself(true)
		mySeat:showCardTip()
		print("PlayView*********************1")
	end
end

return PlayView
