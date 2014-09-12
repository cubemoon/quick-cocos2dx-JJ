
local JJViewGroup = require("sdk.ui.JJViewGroup")
local CardGroup = class("CardGroup", JJViewGroup)

local CardView = require("interim.ui.view.CardView")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_OPPONENT_CARD_SCALE = InterimUtilDefine.INTERIM_OPPONENT_CARD_SCALE 
local INTERIM_MY_CARD_SCALE = InterimUtilDefine.INTERIM_MY_CARD_SCALE 
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND
local DEAL_MIDDEL_CARD_DURATION = 0.3

function CardGroup:ctor(parentView)
	CardGroup.super.ctor(self)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self.positionConfig = parentView.positionConfig
	self.myself = parentView.myself
 	self.cardConcealed = parentView.cardConcealed
 	self.dealingCard = false
 	self:initView()
end

function CardGroup:initView()
	-- self.txtOne = jj.ui.JJLabel.new({
 --    	fontSize = 20,
 --    	color = ccc3(255, 255, 255),
 --    	text = "Hello",
 --    })
 --    self.txtOne:setAnchorPoint(ccp(0.5, 0.5))
 --    self.txtOne:setPosition(ccp(0,0))
 --    self:addView(self.txtOne)
	self.cards = {}
	self.cards[1] = nil
	self.cards[2] = nil
	self.middleCard = nil

 	self.cards[1] = CardView.new()
 	self.cards[1]:setCardGroup(self)
 	self:addView(self.cards[1])

 	self.cards[2] = CardView.new()
 	self.cards[2]:setCardGroup(self)
 	self:addView(self.cards[2])


 	-- self.tipLabel = jj.ui.JJLabel.new({
  --   	fontSize = 30*self.dimens_.scale_,
  --   	color = ccc3(255, 255, 255),
  --   	text = "tip",
  --   })
  --   self.tipLabel:setAnchorPoint(ccp(0.5, 0.5))
  --   self.tipLabel:setPosition(ccp(0,0))
  --   self:addView(self.tipLabel)
  --   self.tipLabel:setVisible(false)


    self.tipLabel = jj.ui.JJLabelBMFont.new({
         text="X00",
         font="img/interim/ui/cardTipFont.fnt",
         textAlign = ui.TEXT_ALIGN_LEFT
    })
    self.tipLabel:setScale(self.dimens_.scale_)
    self.tipLabel:setAnchorPoint(ccp(0.5,0.5))
    self.tipLabel:setPosition(0, 0)
    self:addView(self.tipLabel)
    self.tipLabel:setVisible(false)

 	self.middleCard = CardView.new()
 	self.middleCard:setCardGroup(self)
 	self:addView(self.middleCard)

 	

    self:resetCard()
end

function CardGroup:hideCards()
	self.cards[1]:setVisible(false)
	self.cards[2]:setVisible(false)
	self.middleCard:setVisible(false)
	JJLog.i("隐藏中间牌 hideCards")
end

function CardGroup:setCards(cards)
	self.cards = cards
end

function CardGroup:getCardPosition(layoutIndex, cardIndex)
	if layoutIndex == 1 then
		local pos
		if cardIndex == "1" then
			pos = self.positionConfig.seatViewLayoutTableLeft.card[1]
		elseif cardIndex == "2" then
			if self.cardConcealed == true then
				pos = self.positionConfig.seatViewLayoutTableLeft.cardHidden[2]
			else
				pos = self.positionConfig.seatViewLayoutTableLeft.card[2]
			end
		elseif cardIndex == "middle" then
			pos = self.positionConfig.seatViewLayoutTableLeft.middleCard
		elseif cardIndex == "hidden1" then
			pos = self.positionConfig.seatViewLayoutTableLeft.cardHidden[1]
		elseif cardIndex == "hidden2" then
			pos = self.positionConfig.seatViewLayoutTableLeft.cardHidden[2]
		end
		return pos
	elseif layoutIndex == 2 or layoutIndex == 3 then
		local pos
		if cardIndex == "1" then
			if self.cardConcealed == true then
				pos = self.positionConfig.seatViewLayoutTableRight.cardHidden[1]
			else
				pos = self.positionConfig.seatViewLayoutTableRight.card[1]
			end
		elseif cardIndex == "2" then
			if self.cardConcealed == true then
				pos = self.positionConfig.seatViewLayoutTableRight.cardHidden[2]
			else
				pos = self.positionConfig.seatViewLayoutTableRight.card[2]
			end
		elseif cardIndex == "middle" then
			pos = self.positionConfig.seatViewLayoutTableRight.middleCard
		end
		return pos
	elseif layoutIndex == 4 or layoutIndex == 5 then
		local pos
		if cardIndex == "1" then
			if self.cardConcealed == true then
				pos = self.positionConfig.seatViewLayoutTableLeft.cardHidden[1]	
			else
				pos = self.positionConfig.seatViewLayoutTableLeft.card[1]
			end
		elseif cardIndex == "2" then
			if self.cardConcealed == true then
				pos = self.positionConfig.seatViewLayoutTableLeft.cardHidden[2]
			else
				pos = self.positionConfig.seatViewLayoutTableLeft.card[2]
			end
		elseif cardIndex == "middle" then
			pos = self.positionConfig.seatViewLayoutTableLeft.middleCard
		end
		return pos
	end
end

function CardGroup:refreshDualCardLayout()
	
end

function CardGroup:refreshLayout()
	local layoutIndex = self.layoutIndex
	if layoutIndex == 1 then
		local pos = self:getCardPosition(layoutIndex, "1")
		self.cards[1]:setPosition(pos)
		self.cards[1]:setScale(self.dimens_.scale_*INTERIM_MY_CARD_SCALE)
		
		pos = self:getCardPosition(layoutIndex, "2")
		self.cards[2]:setPosition(pos)
		self.cards[2]:setScale(self.dimens_.scale_*INTERIM_MY_CARD_SCALE)

		pos = self:getCardPosition(layoutIndex, "middle")
		self.middleCard:setPosition(pos)
		self.middleCard:setScale(self.dimens_.scale_*INTERIM_MY_CARD_SCALE)
	elseif layoutIndex == 2 or layoutIndex == 3 then
		local pos = self:getCardPosition(layoutIndex, "1")
		self.cards[1]:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.cards[1]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)

		pos = self:getCardPosition(layoutIndex, "2")
		self.cards[2]:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.cards[2]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)

		pos = self:getCardPosition(layoutIndex, "middle")
		self.middleCard:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.middleCard:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
	elseif layoutIndex == 4 or layoutIndex == 5 then
		local pos = self:getCardPosition(layoutIndex, "1")
		self.cards[1]:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.cards[1]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)

		pos = self:getCardPosition(layoutIndex, "2")
		self.cards[2]:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.cards[2]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
		
		pos = self:getCardPosition(layoutIndex, "middle")
		self.middleCard:setPosition(ccp(pos.x*INTERIM_OPPONENT_CARD_SCALE, pos.y))
		self.middleCard:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
	end

	self.tipLabel:setPosition(self.middleCard:getPosition())
end

function CardGroup:convertPos(pos)
	local seatPos = self.positionConfig.seatPositionTable[self.layoutIndex]
	local selfPos = ccp(self:getPositionX(), self:getPositionY())
	--local cardGroupPos = ccp(self:getPositionX(), self:getPositionY)
	local newPos = ccp(- seatPos.x + pos.x - selfPos.x,- seatPos.y + pos.y - selfPos.y)
	return newPos
end

function CardGroup:resetCard()
	local startPosition = self.positionConfig.dealCardStartPosition
	--JJLog.i("重置起始坐标, " .. startPosition.x .. " " .. startPosition.y)
	--JJLog.i("startPosition x: " .. startPosition.x .. " y: " .. startPosition.y)
	self.dealCardStartPos = self:convertToNodeSpace(startPosition)
	--JJLog.i("起始坐标：" .. self.dealCardStartPos.x .. " " .. self.dealCardStartPos.y)
	--self.dealCardStartPos = self:convertPos(startPosition)
	--JJLog.i("起始坐标：" .. self.dealCardStartPos.x .. " " .. self.dealCardStartPos.y)
	
	self.cards[1]:concealed()
	self.cards[2]:concealed()
	self.cards[1]:setVisible(false)
	self.cards[2]:setVisible(false)
	JJLog.i("隐藏中间牌resetCard")
	self.middleCard:setVisible(false)

	self.tipLabel:setVisible(false)
end

function CardGroup:setDealCardStartPos(pos)
	self.dealCardStartPos = pos
end

function CardGroup:dealCardInstant(cardID_1, cardID_2)
	self.cards[1]:stopAllActions()
	self.cards[1]:setVisible(true)
	self.cards[1]:setCardID(cardID_1)

	self.cards[2]:stopAllActions()
	self.cards[2]:setVisible(true)
	self.cards[2]:setCardID(cardID_2)

	local cardPos_1 = self:getCardPosition(self.layoutIndex, "1")
	local cardPos_2 = self:getCardPosition(self.layoutIndex, "2")

	self.cards[1]:setPosition(cardPos_1)
	self.cards[2]:setPosition(cardPos_2)
			
	if self.myself == true then
		self.cards[1]:expose()
		self.cards[2]:expose()
	else
		self.cards[1]:concealed()
		self.cards[2]:concealed()
	end
end

function CardGroup:dealCard(cardID)
	-- JJLog.i("dealing card")
--	JJLog.i("起始坐标：" .. self.dealCardStartPos.x .. " " .. self.dealCardStartPos.y)

	if self.cards[1]:isVisible() == false then
		self.cards[1]:setCardID(cardID)
		self.cards[1]:setVisible(true)
		self.cards[1]:stopAllActions()
		if self.myself == true then
			self.cards[1]:expose()
		end
		self.cards[1]:setPosition(self.dealCardStartPos)
		self.dealingCard = true
		local targetPos = self:getCardPosition(self.layoutIndex, "1")
		local moveAction = self:createCardMoveAction(targetPos)
		local array = CCArray:create()
	    array:addObject(moveAction)
	    array:addObject(CCCallFunc:create(handler(self.cards[1], self.cards[1].dealCardFinished)))
		local seq = CCSequence:create(array)
		self.cards[1]:runAction(seq)
		-- if self.layoutIndex == 1 then
		-- 	self.cards[1]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
		-- 	local scaleAction = self:createCardScaleUpAction()
		-- 	self.cards[1]:runAction(scaleAction)
		-- else
		-- 	self.cards[1]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
		-- end
	elseif self.cards[2]:isVisible() == false then
		self.cards[2]:setCardID(cardID)
		self.cards[2]:setVisible(true)
		self.cards[2]:stopAllActions()
		if self.myself == true then
			self.cards[2]:expose()
		end
		self.cards[2]:setPosition(self.dealCardStartPos)
		local targetPos = self:getCardPosition(self.layoutIndex, "2")
		local moveAction = self:createCardMoveAction(targetPos)
		local array = CCArray:create()
	    array:addObject(moveAction)
	    array:addObject(CCCallFunc:create(handler(self.cards[2], self.cards[2].dealCardFinished)))
		local seq = CCSequence:create(array)
		self.cards[2]:runAction(seq)
		-- if self.layoutIndex == 1 then
		-- 	self.cards[2]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
		-- 	local scaleAction = self:createCardScaleUpAction()
		-- 	self.cards[2]:runAction(scaleAction)
		-- else
		-- 	self.cards[2]:setScale(self.dimens_.scale_*INTERIM_OPPONENT_CARD_SCALE)
		-- end		
	end
end

function CardGroup:onDealCardFinished(card)
	self.dealingCard = false
	-- JJLog.i("deal card finished " .. card.cardID)
	-- JJLog.i("layoutIndex: " .. self.layoutIndex)
	-- JJLog.i("is my self ? " .. tostring(self.myself))
	if self.myself == true or self.layoutIndex == 1 then
		card:expose()
		-- if self.cards[1].isConcealed == false
		--  and self.cards[2].isConcealed == false then
		--  	self:compareToSwitchCard(self.cards[1], self.cards[2])
		-- end
	end
end

function CardGroup:compareToSwitchCard(card_1, card_2)
	local cardID_1 = card_1.cardID%13
	if cardID_1 == 0 then
		cardID_1 = 13
	end
	local cardID_2 = card_2.cardID%13
	if cardID_2 == 0 then
		cardID_2 = 13
	end
	if cardID_1 > cardID_2 then
		local pos1 = ccp(card_1:getPositionX(),card_1:getPositionY())
		local pos2 = ccp(card_2:getPositionX(),card_2:getPositionY())
		local moveTo = CCMoveTo:create(0.1, pos2)
		card_1:runAction(moveTo)
		moveTo = CCMoveTo:create(0.1, pos1)
		card_2:runAction(moveTo)
	end
end

function CardGroup:createCardMoveAction(targetPos)
	local moveTo = CCMoveTo:create(0.2, targetPos)
	local easeAction = CCEaseSineOut:create(moveTo)
	return easeAction
end

function CardGroup:createCardScaleUpAction()
	local scale = CCScaleTo:create(0.08, self.dimens_.scale_*INTERIM_MY_CARD_SCALE)
	local easeAction = CCEaseSineOut:create(scale)
	return easeAction
end

function CardGroup:setMyself(var)
	self.myself = var
	if var == true then
		self:setCardConcealed(false)
	else
		self:setCardConcealed(true)
	end
end

function CardGroup:setCardConcealed(var)
	self.cardConcealed = var
end

function CardGroup:showHandCard()
	self.cardConcealed = false

	self.cards[1]:setVisible(true)
	self.cards[2]:setVisible(true)
	self.cards[1]:expose()
	self.cards[2]:expose()
	
	local pos = self:getCardPosition(self.layoutIndex, "1")
	self.cards[1]:setPosition(pos)

	pos = self:getCardPosition(self.layoutIndex, "2")
	self.cards[2]:setPosition(pos)
end

function CardGroup:dealMiddleCardInstant(cardID)
	-- self.cards[1]:setVisible(true)
	-- self.cards[2]:setVisible(true)
	-- self.cards[1]:expose()
	-- self.cards[2]:expose()
	
	-- local pos = self:getCardPosition(self.layoutIndex, "1")
	-- self.cards[1]:setPosition(pos)

	-- pos = self:getCardPosition(self.layoutIndex, "2")
	-- self.cards[2]:setPosition(pos)

	self.middleCard:setCardID(cardID)
	self.middleCard:setVisible(true)
	local targetPos = self:getCardPosition(self.layoutIndex, "middle")
	self.middleCard:expose()
	self.middleCard:setPosition(targetPos)
	JJLog.i("直接放置中间牌：" .. cardID .. " 位置： " .. targetPos.x .. " " .. targetPos.y)
end

function CardGroup:dealMiddleCard(cardID)
	local startPosition = self.positionConfig.dealCardStartPosition
	self.dealCardStartPos = self:convertToNodeSpace(startPosition)
	
	SoundManager:playEffect(INTERIM_SOUND.GRAB)
	self.middleCard:setCardID(cardID)
	--self.middleCard:concealed()
	self.middleCard:stopAllActions()
	self.middleCard:expose()
	self.middleCard:setVisible(true)
	self.middleCard:setPosition(self.dealCardStartPos)
	local targetPos = self:getCardPosition(self.layoutIndex, "middle")
	local moveTo = CCMoveTo:create(DEAL_MIDDEL_CARD_DURATION, targetPos)
	local easeAction = CCEaseSineOut:create(moveTo)
	--self:createCardMoveAction(targetPos)
	local array = CCArray:create()
    array:addObject(easeAction)
    array:addObject(CCCallFunc:create(handler(self.middleCard, self.middleCard.dealMiddleCardFinished)))
	local seq = CCSequence:create(array)
	self.middleCard:runAction(seq)
	JJLog.i("开始播放中间牌移动：" .. cardID)
end

function CardGroup:onDealMiddleCardFinished()
	self.parentView:dealMiddleCardFinished()
end

function CardGroup:setTipe(text)
	if text == nil then
		self.tipLabel:setVisible(false)
		return
	end
	self.tipLabel:setText(text)
	self.tipLabel:setVisible(true)
end

function CardGroup:getMiddlePosition()
	return self:getCardPosition(self.layoutIndex, "middle")
end

function CardGroup:getPassPosition()
	return self:getCardPosition(self.layoutIndex, "2")
end

return CardGroup
