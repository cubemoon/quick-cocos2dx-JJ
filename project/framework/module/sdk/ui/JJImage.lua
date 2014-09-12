local JJView = import(".JJView")
local JJImage = class("JJImage", JJView)

local TAG = "JJImage"
JJImage.sprite_ = nil -- sprite
--[[
	params 参数描述：
    image: string type，the image file path
    scale9:   whether is 2dx scale9 sprite or not
    viewSize:     scale9 sprite size
--]]
function JJImage:ctor(params)
	JJImage.super.ctor(self, params)
	local image = nil
	local scale9 = false
	if params then
		if params.image ~= nil then
			image = params.image
		end
		
		if params.scale9 ~= nil then
			scale9 = params.scale9
		end
	end
	
	self.scale9_ = scale9
	self.sprite_ = nil
	self:setAnchorPoint(ccp(0.5, 0.5))
	self:_initImage(image, scale9)

	if image == nil then
		JJLog.i(TAG, "WARNNING: the image name is nil!")
	end
end

function JJImage:_initImage(image, bScale9)
	if self.sprite_ ~= nil then
		self.sprite_:removeFromParent()
		self.sprite_ = nil
	end
	if bScale9 == true then
		-- JJLog.i(TAG, "OK create scale9 sprite")
		self.sprite_ = display.newScale9Sprite(image)
		if self:getWidth() > 0 and self:getHeight() > 0 then
			self.sprite_:setContentSize(self:getViewSize())
		end
	else
		self.sprite_ = display.newSprite(image)
	end
	self.sprite_:setAnchorPoint(ccp(0.5, 0.5))
	self:getNode():addChild(self.sprite_)

	self:setViewSize(self.sprite_:getContentSize().width, self.sprite_:getContentSize().height)
	
	-- JJLog.i(TAG, "size.w=", self:getWidth(), ", size.h=", self:getHeight())
	self.sprite_:setPosition(self:getWidth()/2, self:getHeight()/2)

end 

-- viewsize 改变时重新布局
function JJImage:relayout()
	if self.sprite_ == nil then return end

	local size = self:getViewSize()
	local width = size.width
	local height = size.height
	self.sprite_:setPosition(ccp(width/2, height/2))
end


function JJImage:setTexture(texture)
	if self.sprite_ ~= nil then
		self.sprite_:setTexture(texture)
	end
end

function JJImage:setTextureRect(rect)
	if self.sprite_ ~= nil then
		self.sprite_:setTextureRect(rect)
	end
end

function JJImage:getTextureRect(rect)
	if self.sprite_ ~= nil then
		return self.sprite_:getTextureRect()
	end
end

function JJImage:playAnimationForever(animation)
	if self.sprite_ ~= nil then
		self.sprite_:playAnimationForever(animation)
	end
end

function JJImage:setViewSize(w, h)
	JJImage.super.setViewSize(self, w, h)
	if self.sprite_ ~= nil then
		self.sprite_:setContentSize(CCSize(w,h))
		self.sprite_:setPosition(ccp(w/2, h/2))
	end
end

function JJImage:setOpacity(value)
	if self.sprite_ ~= nil then
		self.sprite_:setOpacity(value)
	end
end

function JJImage:getPositionInCCPoint()
	if self.sprite_ ~= nil then
		return self.sprite_:getPositionInCCPoint()
	end
end

function JJImage:getImage()
	return self.sprite_
end

function JJImage:setImage(image, bScale9)
	assert(image~=nil, "ERROR: image should not be nil!")
	
	self:_initImage(image, bScale9)
end

function JJImage:setAntiAliasTexParameters()
	if self.sprite_ ~= nil then
		self.sprite_:getTexture():setAntiAliasTexParameters()
	end
end

function JJImage:isFlipX()
	if self.scale9_ ~= true and self.sprite_ ~= nil then
		return self.sprite_:isFlipX()
	end
end

function JJImage:setFlipX(bFlipX)
	if self.scale9_ ~= true and self.sprite_ ~= nil then
		self.sprite_:setFlipX(bFlipX)
	end
end

function JJImage:isFlipY()
	if self.scale9_ ~= true and self.sprite_ ~= nil then
		return self.sprite_:isFlipY()
	end
end

function JJImage:setFlipY(bFlipY)
	if self.scale9_ ~= true and self.sprite_ ~= nil then
		self.sprite_:setFlipY(bFlipY)
	end
end

return JJImage
