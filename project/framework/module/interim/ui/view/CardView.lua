
local CardView = class("CardView", jj.ui.JJImage)

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_CARD_BACK = InterimUtilDefine.INTERIM_CARD_BACK 
local INTERIM_CARD_IMAGE = InterimUtilDefine.INTERIM_CARD_IMAGE

function CardView:ctor(params)
	CardView.super.ctor(self, params)
	
	self:setTouchEnable(true)
	
	self:concealed()

    self.cardID = 0		

    self.delegate = nil
end

function CardView:setCardGroup(var)
	self.cardGroup = var
end

function CardView:onTouchBegan(x, y)
	if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
		self:setTouchedIn(true)
--		JJLog.i("onTouchBegan x: " .. x .. " y: " .. y)
		if self.delegate ~= nil then
			self.delegate:onCardTouched(self)
		end
		return true
	end

	return false
end

function CardView:onTouchMoved(x, y)
	if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
		self:setTouchedIn(true)
		if self.delegate ~= nil then
			self.delegate:onCardMoved(self)
		end
	else
		if self.delegate ~= nil then
			self.delegate:onCardMoveEnded(self)
		end
	end
end

function CardView:setCardID(cardID)
	self.cardID = cardID
end

function CardView:getCardID()
	return self.cardID
end

function CardView:concealed()
	self.isConcealed = true

	local texture = CCTextureCache:sharedTextureCache():addImage(INTERIM_CARD_BACK)
    self:setTexture(texture)
    local rect = CCRect:new()
    rect.size = texture:getContentSize()
    self:setTextureRect(rect)
end

function CardView:expose()
	self.isConcealed = false

	JJLog.i("exposing card " .. self.cardID)
	if self.cardID == 0 then
		return
	end
	local cardImageFile = INTERIM_CARD_IMAGE[self.cardID]
	if cardImageFile == nil then
		return
	end
	local texture = CCTextureCache:sharedTextureCache():addImage(cardImageFile)
	if texture ~= nil then
	   self:setTexture(texture)
	end
end

function CardView:dealCardFinished()
	if self.cardGroup then
		self.cardGroup:onDealCardFinished(self)
	end
end

function CardView:dealMiddleCardFinished()
	self:expose()
	if self.cardGroup then
		self.cardGroup:onDealMiddleCardFinished(self)
	end
end

function CardView:setOriginPos(x, y)
	self.originPos = ccp(x, y)
end

return CardView
