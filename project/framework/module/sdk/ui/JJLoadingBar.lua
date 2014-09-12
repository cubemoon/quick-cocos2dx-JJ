local JJViewGroup = import(".JJViewGroup")

local JJLoadingBar = class("JJLoadingBar", JJViewGroup)

JJLoadingBar.BG_ZORDER = -10
JJLoadingBar.PROGRESS_ZORDER = 0
local TAG = "JJLoadingBar"

--[[
	params:参数说明
	viewSize: view size
	background: table type, see JJView's background parameter
	    image: string type
	    scale9: bool type, optional
	    zorder: integer type,  infulence the show order, more large more top
	images: table type
	    progress: string type
	    scale9: bool type, optional
	    zorder: integer type
	maxmum: 最大允许值
	minimum: 最小允许值
	value: 初始值
--]]
function JJLoadingBar:ctor(params)
	JJLoadingBar.super.ctor(self, params)
	self:setTouchEnable(true)
	
	self.prgSprite_ = nil
	self.value_ = 0
	self.minimumValue_ = 0
	self.maxmumValue_ = 100

	if params ~= nil then

		if params.images ~= nil then
			self:setProgressImage(params.images)
		end
		
		if params.minimum ~= nil then
			self.minimumValue_ = params.minimum
		end

		if params.maxmum ~= nil then
			self.maxmumValue_ = params.maxmum
		end
	end
	
	self:relayout()
end

function JJLoadingBar:setProgressImage(images)
	JJLog.i(TAG, "setProgressImage()")
	if images ~= nil then
		--JJLog.i(TAG, "image="..images)
		assert(type(images)=="table", "ERROR: images should be table type!")
	end

	if self.prgSprite_ ~= nil then
		self.prgSprite_:removeSelf()
		self.prgSprite_ = nil
	end

	self.prgSprite_ = jj.ui.JJImage.new({
										image=images.progress
	})
	
	self.prgSprite_:setEnableScissor(true)
	if images.zorder ~= nil then
		self:addView(self.prgSprite_, images.zorder)
	else
		self:addView(self.prgSprite_, self.PROGRESS_ZORDER)
	end
end

function JJLoadingBar:getValue()
	return self.value_
end

function JJLoadingBar:setValue(value)
	--JJLog.i(TAG, "setValue("..value..")")
	
	if value < self.minimumValue_ then
		value = self.minimumValue_
	end

	if value > self.maxmumValue_ then
		value = self.maxmumValue_
	end

	self.value_ = value
	self:relayout()
end

function JJLoadingBar:relayout()
	--JJLog.i(TAG, "relayout() IN")
	if self.bg_ == nil then
		JJLog.i(TAG, "ERROR: bg sprite is nil")
		return
	end
	if self.prgSprite_ == nil then
		JJLog.i(TAG, "ERROR: prg sprite is nil")
		return
	end
	
	
	--JJLog.i(TAG, "self.value_="..self.value_)
	self.bg_:setAnchorPoint(CCPoint(0, 0.5))
	self.bg_:setPosition(CCPoint(0, self:getHeight()/2))
	local bgscalex = self:getWidth()/self.bg_:getContentSize().width
	--JJLog.i(TAG, "bgscalex="..bgscalex)
	self.bg_:setScaleX(bgscalex)

	local xlength = self:getWidth()*self.value_/100
	
	local xscale = xlength / self.prgSprite_:getWidth()
	--JJLog.i(TAG, "xscale="..xscale)
	self.prgSprite_:setAnchorPoint(CCPoint(0, 0.5))
	self.prgSprite_:setPosition(CCPoint(0, self:getHeight()/2))
	-- self.prgSprite_:setScaleX(xscale)
	self.prgSprite_:setWidth(xlength)
--	self.prgSprite_:setVisible(false)
	--JJLog.i(TAG, "relayout() OUT")
end



return JJLoadingBar
