
--[[
params:
    image: string type, the path of the image file
    scale9: boolean type, indicator the image should be create as scale9 image, optional
    capInsets: CCRect type,  capInsets The values to use for the cap insets, optional

--]]

local TAG = "JJSprite"
local JJSprite = class("JJSprite", function(params)
						   local sprite = nil
						   if params ~= nil then
							   assert(params.image~=nil and type(params.image)=="string", "ERROR: invalue params.image")

						   	   if params.scale9 ~= nil and params.scale9 == true then
								   if params.capInsets ~= nil then
									   sprite = CCScale9Sprite:create(params.capInsets, params.image)
								   else
									   sprite = CCScale9Sprite:create(params.image)
								   end
						   	   else
						   		   sprite = CCSprite:create(params.image)
						   	   end
						   else
						   	   sprite = CCSprite:create()
						   end
						   CCSpriteExtend.extend(sprite)
						   return sprite
								   end)


function JJSprite:ctor(params)

	self.id_ = 0
end

function JJSprite:setViewSize(w, h)
	self:setContentSize(CCSizeMake(w,h))
end

function JJSprite:getViewSize()
	return self:getContentSize()
end

function JJSprite:setId(id)
	self.id_ = id
end

function JJSprite:getNode()
	return self
end

function JJSprite:removeSelf(bCleanup)
	local cleanup = bCleanup or true
	self:removeFromParentAndCleanup(cleanup)
end


return JJSprite

