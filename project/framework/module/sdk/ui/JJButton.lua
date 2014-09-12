local JJViewGroup = import(".JJViewGroup")

local JJButton = class("JJButton", JJViewGroup)

JJButton.IMAGE_ZORDER = -99
JJButton.LABEL_ZORDER = 0


local TAG = "JJButton"

--[[
    params:
        images: 图片
            scale9: 是否拉伸
            normal:
            highlight:
            disable:
]]

function JJButton:ctor(params)
	JJButton.super.ctor(self, params)
	-- JJLog.i(TAG, "ctor() IN")
	-- Button 的文字默认居中
	params.align = params.align or ui.TEXT_ALIGN_CENTER
	self.label_ = nil
	self:setTouchEnable(true)
	self.images_ = params.images
	self.sprite_ = nil
	self.currentImage_ = nil
	self.select_ = false	
	self.sprites_ = {}
	self.opacity_ = nil
	-- self.label_ = jj.ui.JJLabel.new(params)
	-- self:addView(self.label_, self.LABEL_ZORDER)

	if params.text ~= nil then
		self.label_ = jj.ui.JJLabel.new(params)
		self:addView(self.label_, self.LABEL_ZORDER)
	end
	self:_initButtonImage()
	self:relayout()
	self:_updateButtonLabel()
end

function JJButton:_creatSprite(name, bScale9)

	local w = self:getWidth()
	local h = self:getHeight()
	local sp = nil
	if bScale9 == true then
		sp = display.newScale9Sprite(name)
		if w > 0 and h > 0 then
			sp:setContentSize(self.viewSize_)
		end
	else
		sp = display.newSprite(name)
		if w > 0 and h > 0 then
			local size = sp:getContentSize()
			local scalex = w/size.width
			local scaley = h/size.height
			sp:setScaleX(scalex)
			sp:setScaleY(scaley)
		end
	end
	return sp
end


function JJButton:_initButtonImage()

	local state = self:getState()
	local bScale9 = false
	-- JJLog.i(TAG, "_initButtonImage() ")
	if self.images_ ~= nil then 
		bScale9 = self.images_.scale9 or false
	else
		return
	end
	
	local validKeys = {}
	validKeys["normal"] = true
	validKeys["highlight"] = true
	validKeys["disable"] = true
	local size = self:getViewSize()
	for k, v in pairs(self.images_) do
		local sp = nil
		if validKeys[k] == true then
			sp = self:_creatSprite(v, bScale9)
			self.sprites_[k] = sp

			if state ~= k then
				sp:setVisible(false)
			end

			sp:setAnchorPoint(ccp(0,0))
			sp:setPosition(ccp(0, 0))
			self:getNode():addChild(sp, self.IMAGE_ZORDER)

		end
	end
	
	if size.width == 0 and size.height == 0 then
		local sp = self.sprites_["normal"]
		if sp ~= nil then
			local cntSize = sp:getContentSize()
			JJButton.super.setViewSize(self, cntSize.width, cntSize.height)
		end
	end
	
	self.sprite_ = self.sprites_[state]

end
--只支持scale9
function JJButton:setViewSize(w, h)
    JJButton.super.setViewSize(self, w, h)
    if self.images_ ~= nil and self.images_.scale9 == true and self.sprite_ then
        self.sprite_:setContentSize(CCSize(w, h))
    end
end

function JJButton:relayout()
    JJButton.super.relayout(self)
    self:_updateButtonImage()
end

function JJButton:_updateButtonImage()
    local state = self:getState()
	-- JJLog.i(TAG, "_updateButtonImage() IN state=", state)
    if self.images_ == nil then
        return
    end

    if self:isSelect() then
        state = self.HIGHLIGHT
    end
	
	local curSpr = self.sprites_[state]

	--如果curSpr 为nil 就只设置透明度
	if curSpr == nil  then
        local opacity = 255
        if state == self.HIGHLIGHT or state == self.DISABLE then
            opacity = 200
        else
            opacity = 255
        end
		
        if self.sprite_ then
            self.sprite_:setOpacity(opacity)
        end

        return
	else
		self.sprite_ = curSpr
    end
	
	for k, v in pairs(self.sprites_) do
		if v ~= nil then
			if state ~= k then
				v:setVisible(false)
			else
				v:setVisible(true)
			end
		end
	end

    self.sprite_:setOpacity(255)
    self.sprite_:setAnchorPoint(ccp(0,0))
    self.sprite_:setPosition(ccp(0, 0))
end

function JJButton:_updateButtonLabel()
	if self.label_ then
		self.label_:setAnchorPoint(ccp(0.5,0.5))
		local x = 0
		local y = 0
		if not self.images_ then
			local size = self.label_:getViewSize()
			x = size.width/2
			y = size.height/2
		else
			local size = self:getViewSize()
			x = size.width/2
			y = size.height/2
		end
		self.label_:setPosition(ccp(x, y))
	end
end

function JJButton:setButtonImage(state, image)
    if image == nil then return end
    self.images_[state] = image
	
	local bScale9 = self.images_.scale9 or false
	
	local sp = self:_creatSprite(image, bScale9)
	self:getNode():addChild(sp, self.IMAGE_ZORDER)
	if self.sprites_[state] ~= nil then
		self.sprites_[state]:removeFromParentAndCleanup()
		self.sprites_[state] = nil
	end
	self.sprites_[state] = sp
	self.sprite_ = self.sprites_[self:getState()]
    self:_updateButtonImage()
    return self
end

function JJButton:onTouch(event, x, y)

    if event == "began" then
        self:setState(self.HIGHLIGHT)
        self:setTouchedIn(true)
        return true

    elseif event == "moved" then 
        if self:isTouchedIn() then
            if not self:isTouchInside(x,y) then
                self:setTouchedIn(false)
                self:setState(self.NORMAL)
            end
        end

    elseif event == "ended" then
        self:setState(self.NORMAL)
        if self:isTouchedIn() then
            self:setTouchedIn(false)
			if jj.ui.isOnClickSoundMute() ~= true then
				self.sound_ = jj.ui.getOnClickSound()
				if self.sound_ ~= nil then
					audio.playSound(self.sound_)
				else
					JJLog.i(TAG, "sound == nil")
				end
			end
            if self.onClickListener_ then
              self.onClickListener_(self)
            end
        end

    elseif event == "cancelled" then
        self:setTouchedIn(false)
        self:setState(self.NORMAL)
    else
        JJLog.i(TAG, "else event="..event)
    end
end

function JJButton:setSelect(flag)
    self.select_ = flag
    self:relayout()
end

function JJButton:isSelect()
    return self.select_
end

function JJButton:setText(txt)
	if self.label_ and txt then
		self.label_:setText(txt)
		self:_updateButtonLabel()
	end
end

function JJButton:setColor(color)
	if self.label_ and color then
		self.label_:setColor(color)
	end
end

function JJButton:setOpacity(value)
	if self.opacity_ ~= value then
		self.opacity_ = value
		if self.label_ ~= nil then
			self.label_:setOpacity(value)
		end

		if self.sprite_ ~= nil then
			self.sprite_:setOpacity(value)
		end
	end
end
return JJButton

