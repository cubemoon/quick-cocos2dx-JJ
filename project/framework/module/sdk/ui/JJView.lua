local JJView = class("JJView")

JJView.NORMAL = "normal"
JJView.HIGHLIGHT = "highlight"
JJView.DISABLE = "disable"
JJView.TOUCH_MODE_REST = 0
JJView.TOUCH_MODE_DOWN = 1
JJView.TOUCH_MODE_MOVE = 2
JJView.TOUCH_MODE_CANCELL = 3
JJView.TOUCH_MODE_END = 4
local TAG = "JJView"
--[[
	params: table type
	viewSize: CCSize type, size of view
	background: table type
	    image: string type, the name of background image
	    scale9: bool type, indicator the image is 2dx scale9Sprite or not
	    zorder: integer type, infulence the show order, more large more top
	clickSound: string type, the sound effect when this view be clicked
	layout:
	   paddingLeft: number type, optional
	   paddingRight: number type, optional
	   paddingTop: number type, optional
	   paddingBottom: number type, optional
	   padding: number type, optional

--]]
function JJView:ctor(params)
	self.node_ = CCNodeExtend.extend(JJNode:create())
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.viewSize_ = CCSizeMake(0,0)
	self.onClickListener_ = nil
	self.stateChangeListener_ = nil
	self.bEnable_ = true
	self.bTouchEnable_ = false
	self.bFocus_ = false
	self.state_ = "normal"
	self.bTouchedIn_ = false
	self.Id_ = 0
	self.parent_ = nil
	self.bTouchIn_ = false
	self.paddingLeft_ = 0
	self.paddingRight_ = 0
	self.paddingTop_ = 0
	self.paddingBottom_ = 0
	self.mTouchMode_ = self.TOUCH_MODE_REST
	if params ~= nil then
		assert(type(params)=="table", "invalid params")
		
		if params.viewSize ~= nil then
			self:setViewSize(params.viewSize.width, params.viewSize.height)
		end

		if params.background ~= nil then
			assert(type(params.background)=="table", "invalid params of background")
			-- JJLog.i(TAG, "set background")
			local background = params.background
			if background.scale9 ~= nil and background.scale9 == true then
				self.bg_ = display.newScale9Sprite(background.image)
				-- JJLog.i(TAG, "the background is scale9sprite")
				self.bg_:setContentSize(self:getViewSize())
			else
				self.bg_ = display.newSprite(background.image)
			end
			self.bg_:setAnchorPoint(ccp(0,0))
			self.bg_:setPosition(ccp(0,0))
			if params.background.zorder ~= nil then
				assert(type(params.background.zorder)=="number", "ERROR: zorder should be number type!")
				self.node_:addChild(self.bg_, params.background.zorder)
			else
				self.node_:addChild(self.bg_, -100)
			end
			self.background_ = background
		end

		if params.clickSound ~= nil then
			self.sound_ = params.clickSound
		end

	if params ~= nil and params.layout ~= nil then
		assert(type(params.layout)=="table", "ERROR: params.layout invalid type, should be table table!")
		local layout = params.layout
		if layout.padding ~= nil then
			self.paddingLeft_ = layout.padding
			self.paddingRight_ = layout.padding
			self.paddingTop_ = layout.padding
			self.paddingBottom_ = layout.padding
			local pd = layout.padding
			self:setPadding(pd, pd, pd, pd)
		else
			self.paddingLeft_ = layout.paddingLeft or 0
			self.paddingRight_ = layout.paddingRight or 0
			self.paddingTop_ = layout.paddingTop or 0
			self.paddingBottom_ = layout.paddingBottom or 0
			self:setPadding(self.paddingLeft_, self.paddingTop_, self.paddingRight_, self.paddingBottom_)
		end
	end

	end
	
	self.node_:ignoreAnchorPointForPosition(false)

	self:addScriptEventListener(BEFORE_DRAW, function()
									self:beforeDraw()
	end)
	self:addScriptEventListener(AFTER_DRAW, function()
									self:afterDraw()
	end)

	self:addScriptEventListener(cc.Event.ENTER_SCENE, function ()
									self:onEnter()
													  end
	)


	self:addScriptEventListener(cc.Event.EXIT_SCENE, function ()
									self:onExit()
													 end
	)
end

function JJView:setEnableScissor(bEnable)
	self.node_:setEnableScissor(bEnable)
end

function JJView:isEnableScissor()
	return self.node_:isEnableScissor()
end

function JJView:onEnter()
	-- JJLog.i(TAG, "onEnter()")
end

function JJView:onExit()
	-- JJLog.i(TAG, "onExit()")
end

function JJView:beforeDraw()
	-- JJLog.i(TAG, "beforeDraw", self.node_:getTag())

	self.bScissorRestored_ = false;
    local frame = self.node_:getViewRect()
	-- JJLog.i(TAG, "beforeDraw, frame x=", frame.origin.x, ", y=", frame.origin.y, ", w=", frame.size.width, ", h=", frame.size.height);
	-- JJLog.i(TAG, "beforeDraw, CCEGLView::sharedOpenGLView()->isScissorEnabled()=", CCEGLView:sharedOpenGLView():isScissorEnabled());
	if CCEGLView:sharedOpenGLView():isScissorEnabled() then
		self.bScissorRestored_ = true
		self.rectParentScissor_ = CCEGLView:sharedOpenGLView():getScissorRect()
		-- JJLog.i(TAG, "beforeDraw, rectParentScissor_ x=", self.rectParentScissor_.origin.x, ", y=", self.rectParentScissor_.origin.y, ", w=", self.rectParentScissor_.size.width, ", h=", self.rectParentScissor_.size.height);
		-- set the intersection of self.rectParentScissor_ and frame as the new scissor rect
		if frame:intersectsRect(self.rectParentScissor_) then
            local x = MAX(frame.origin.x, self.rectParentScissor_.origin.x);
            local y = MAX(frame.origin.y, self.rectParentScissor_.origin.y);
            local xx = MIN(frame.origin.x + frame.size.width, self.rectParentScissor_.origin.x + self.rectParentScissor_.size.width);
            local yy = MIN(frame.origin.y + frame.size.height, self.rectParentScissor_.origin.y + self.rectParentScissor_.size.height);
			-- JJLog.i(TAG, "beforeDraw, final x=", x, ", y=", y, ", w=", xx-x, ",h=", yy-y);
			CCEGLView:sharedOpenGLView():setScissorInPoints(x, y, xx-x, yy-y);
		end
	elseif frame.size.width ~= 0 and frame.size.height ~= 0 then
		CCEGLView:sharedOpenGLView():enableScissor()
		-- JJLog.i(TAG, "beforeDraw, final x=", frame.origin.x, ", y=", frame.origin.y, ", w=", frame.size.width, ", h=", frame.size.height);
		CCEGLView:sharedOpenGLView():setScissorInPoints(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	end
end

function JJView:afterDraw()
	-- JJLog.i(TAG, "afterDraw, restored_=", self.bScissorRestored_)
	--restore the parent's scissor rect
	if self.bScissorRestored_ then 
		CCEGLView:sharedOpenGLView():setScissorInPoints(self.rectParentScissor_.origin.x, self.rectParentScissor_.origin.y, self.rectParentScissor_.size.width, self.rectParentScissor_.size.height)
	else
		CCEGLView:sharedOpenGLView():disableScissor()
	end
end

function JJView:addScriptEventListener(event, callback)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:addScriptEventListener(event, callback)
end

function JJView:removeScriptEventListener(event, handle)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:removeScriptEventListener(event, handle)
end

function JJView:removeAllScriptEventListenersForEvent(event)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:removeAllScriptEventListenersForEvent(event)
end

function JJView:removeAllScriptEventListeners()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:removeAllScriptEventListeners()
end

function JJView:hasScriptEventListener(event)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:hasScriptEventListener(event)
end

function JJView:getNode()
	return self.node_
end

function JJView:setParentView(parent)
	if parent ~= nil then
		self.parent_ = parent
	else
		JJLog.i(TAG, "ERROR: parent == nil")
	end
end

function JJView:getParentView()
	return self.parent_
end

function JJView:getId()
	return self.Id_
end


function JJView:removeSelf(bCleanup)
	-- JJLog.i(TAG, "removeSelf()")
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	local parent = self:getParentView()
	local cleanup  = true

	if bCleanup ~= nil and bCleanup == false then
		cleanup = false
	end
	
	if parent ~= nil then
		parent:removeView(self, cleanup)
	else
		--	  JJLog.i(TAG, "parent is nil")
		self.node_:removeFromParentAndCleanup(cleanup)
	end
end

function JJView:setId(id)
	self.Id_ = id
end

function JJView:getPaddingLeft()
	return self.paddingLeft_
end

function JJView:getPaddingRight()
	return self.paddingRight_
end

function JJView:getPaddingTop()
	return self.paddingTop_
end

function JJView:getPaddingBottom()
	return self.paddingBottom_
end

function JJView:setPaddingLeft(value)
    assert(type(value) == "number", "ERROR: value should be number type!")
	if self.paddingLeft_ ~= value then
		self.paddingLeft_ = value
		self:relayout()
	end
end

function JJView:setPaddingRight(value)
    assert(type(value) == "number", "ERROR: value should be number type!")
	if self.paddingRight_ ~= value then
		self.paddingRight_ = value
		self:relayout()
	end
end

function JJView:setPaddingTop(value)
    assert(type(value) == "number", "ERROR: value should be number type!")
	if self.paddingTop_ ~= value then
		self.paddingTop_ = value
		self:relayout()
	end
end

function JJView:setPadding(left, top, right, bottom)
	-- JJLog.i(TAG, "setPadding(", left, top, right, bottom, ")")
	assert(type(left)=="number", "ERROR: left should be number")
	assert(type(top)=="number", "ERROR: top should be number")
	assert(type(right)=="number", "ERROR: right should be number")
	assert(type(bottom)=="number", "ERROR: bottom should be number")
	
	if self.paddingLeft_ ~= left or self.paddingRight_ ~= right or self.paddingTop_ ~= top or self.paddingBottom_ ~= bottom then
		self.paddingLeft_ = left
		self.paddingRight_ = right
		self.paddingTop_ = top
		self.paddingBottom_ = bottom
		self:relayout()
	end
end

function JJView:getPadding()
	return self.paddingLeft_, self.paddingTop_, self.paddingRight_, self.paddingBottom_
end

function JJView:setPaddingBottom(value)
    assert(type(value) == "number", "ERROR: value should be number type!")
	if self.paddingBottom_ ~= value then
		self.paddingBottom_ = value
		self:relayout()
	end
end

function JJView:setBackground(params)

	if params == nil then
		return
	end
	-- JJLog.i(TAG, "setBackground()")

	if self.bg_ ~= nil then
		self.bg_:removeFromParentAndCleanup(true)
		self.bg_ = nil
	end

	local bg = nil
	self.background_ = params

	if params.scale9 == true then
		-- JJLog.i(TAG, "image=", params.image)
		bg = display.newScale9Sprite(params.image)
		bg:setContentSize(CCSizeMake(self.viewSize_.width, self.viewSize_.height))
	else
		bg = display.newSprite(params.image)
	end
	-- JJLog.i(TAG, "add bg to self")
	self:getNode():addChild(bg, -100)
	bg:setAnchorPoint(ccp(0,0))
	bg:setPosition(ccp(0,0))
	self.bg_ = bg
end

function JJView:getBackground()
	return self.bg_
end

function JJView:setOnClickListener(listener)
	self.onClickListener_ = listener
end

function JJView:setOnStateChangeListener(listener)
	self.stateChangeListener_ = listener
end

function JJView:isTouchInside(x, y)
	-- JJLog.i(TAG, "isTouchInside()")
	local pos = ccp(x, y)
	-- local rect = self:getCascadeBoundingBox()
	local rect = nil
	if self:getWidth() > 0 and self:getHeight() > 0 then
		rect = self:getBoundingBox(true)
	else
		rect = self:getCascadeBoundingBox()
	end
	
	local res = rect:containsPoint(pos)
	return res
end

function JJView:setEnable(flag)
	if self.bEnable_ ~= flag then
		self.bEnable_ = flag
		if flag == true then
			self:setState(self.NORMAL)
		else
			self:setState(self.DISABLE)
		end
	end
end

function JJView:isEnable()
	return self.bEnable_
end

function JJView:_setTouchEnabled(flag)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setTouchEnabled(flag)
end

function JJView:addTouchEventListener()

end

function JJView:setTouchEnable(flag)
	self.bTouchEnable_ = flag
end

function JJView:isTouchEnable()
	return self.bTouchEnable_
end
function JJView:setFocus(flag)
	self.bFocus_ = flag
end

function JJView:isFocus()
	return self.bFocus_
end

function JJView:onTouch(event, x, y)
	--JJLog.i(TAG, "onTouch("..event.."), should override in inherited class")

	if event == "began" then
		return self:onTouchBegan(x, y)
	elseif event == "moved" then
		self:onTouchMoved(x, y)
	elseif event == "ended" then
		self:onTouchEnded(x, y)
	elseif event == "cancelled" then
		self:onTouchCancelled(x, y)
	else
		JJLog.i(TAG, "invalid touch event, event=", event)
	end
end

function JJView:onTouchBegan(x, y)
	if self:isTouchInside(x, y) == true and self.onClickListener_ ~= nil then
		self:setTouchedIn(true)

		return true
	end
	return false 
end

function JJView:onTouchMoved(x, y)
	if self:isTouchedIn() then
		if not self:isTouchInside(x,y) then
			self:setTouchedIn(false)
			self:setState(self.NORMAL)
		end
	end
end

function JJView:onTouchEnded(x, y)
	if self:isTouchInside(x, y) == true then
		if self:isTouchedIn() == true then
			self:setTouchedIn(false)
			if self.onClickListener_ ~= nil then
				if jj.ui.isOnClickSoundMute() ~= true then
					local sound = jj.ui.getOnClickSound()
					if sound ~= nil then
						JJLog.i(TAG, "sound=", sound)
						audio.playSound(sound)
					end
				end
				self.onClickListener_(self)
			end
		end
	end
end

function JJView:onTouchCancelled(x, y)
	if self:isTouchedIn() == true then
		self:setTouchedIn(false)
	end
end

function JJView:onKey(key, type)
	JJLog.i(TAG, "JJView:onKey()")
end
function JJView:relayout()
	--JJLog.i(TAG, "JJView:relayout()")
end


function JJView:setState(value)
	--print("JJView:setState() state="..value)
	if not value or value == self.state_ then
		return
	end

	local oldState = self.state_
	self.state_ = value
	self:relayout()

	if self.stateChangeListener_ then
		self.stateChangeListener_(value)
	end
	
end

function JJView:getState()
	return self.state_
end

function JJView:setTouchedIn(flag)
	if self.bTouchIn_ ~= flag then
		self.bTouchIn_ = flag
	end
end

function JJView:isTouchedIn()
	return self.bTouchIn_
end

function JJView:getViewSize()
	if self.viewSize_ ~= nil then
		return self.viewSize_
	else
		return self:getContentSize()
	end
end

function JJView:setViewSize(w, h)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	-- JJLog.i(TAG, "setViewSize(",w, ", ", h, ")")
	local bRelayout = false
	if self.viewSize_ ~= nil then
		if self.viewSize_.width ~= w or self.viewSize_.height ~= h then
			self.viewSize_ = CCSizeMake(w, h)
			bRelayout = true
			-- JJLog.i(TAG, "OK set viewsize 1")
		end
	else
		bRelayout = true
		self.viewSize_ = CCSizeMake(w, h)
		-- JJLog.i(TAG, "OK set viewsize 2")
	end

	if self.background_ ~= nil then
		if self.background_.scale9 == true and self.bg_ ~= nil then
			-- JJLog.i(TAG, "set self.bg_ contetntSize")
			self.bg_:setContentSize(self.viewSize_)
		end
	else
		-- JJLog.i(TAG, "background is nil")
	end
	self.node_:setContentSize(self.viewSize_)
	
	-- if bRelayout == true then
	-- 	self:relayout()
	-- end

end

function JJView:setWidth(w)
	self:setViewSize(w, self:getHeight())
end

function JJView:setHeight(h)
	self:setViewSize(self:getWidth(), h)
end

function JJView:getWidth()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	if self.viewSize_ ~= nil then
		return self.viewSize_.width
	else
		return self.node_:getContentSize().width
	end
end

function JJView:getHeight()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	if self.viewSize_ ~= nil then
		return self.viewSize_.height
	else
		return self.node_:getContentSize().height
	end
end

function JJView:dispatchTouchEvent(event, x, y)
	-- JJLog.i(TAG, "dispatchTouchEvent("..event..")")
	return self:onTouch(event,x,y)
end


--FOLLOW IS CCNode.tolua interface

function JJView:setZOrder(zOrder)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setZOrder(zOrder)
end


function JJView:getZOrder()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getZOrder()
end

function JJView:setVertexZ(vertexZ)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setVertexZ(vertexZ)
end

function JJView:getVertexZ()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getVertexZ()
end

function JJView:setScaleX(fScaleX)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setScaleX(fScaleX)
end

function JJView:getScaleX()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getScaleX()
end

function JJView:setScaleY(fScaleY)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:setScaleY(fScaleY)
end

function JJView:getScaleY()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getScaleY()
end

function JJView:setScale(scale)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setScale(scale)
end

function JJView:getScale()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getScale()
end


function JJView:setPosition(...)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	local arg = {...}
	
	--   JJLog.i(TAG, "setPosition() cont="..#arg)
	-- local director = CCDirector:sharedDirector()
	-- local glview = director:getOpenGLView()
	-- local size = glview:getFrameSize()

	if #arg == 1 then
		assert(tolua.type(arg[1])=="CCPoint", "error invalid params")
		local pos = arg[1]
		--JJLog.i(TAG, "x="..pos.x..", y="..pos.y)
		local x = math.floor(pos.x+0.5)
		local y = math.floor(pos.y+0.5)
		-- x = math.min(x, size.width)
		-- y = math.min(y, size.height)
		local p = ccp(x, y)
		self.node_:setPosition(p)
	elseif  #arg == 2 then
		local x = math.floor(arg[1]+0.5)
		local y = math.floor(arg[2]+0.5)
		--JJLog.i(TAG, "x="..x..", y="..y)
		-- assert((type(x)=="number" and type(y)=="number"), "error invalid params")
		-- x = math.min(x, size.width)
		-- y = math.min(y, size.height)
		self.node_:setPosition(x, y)
	else
		assert(0, "error invalid params!")
	end
end

--返回值为： x, y
function JJView:getPosition()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getPosition()
end

function JJView:getPositionInPoint()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getPositionInCCPoint()
end

function JJView:setPositionX(x)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:setPositionX(x)
end

function JJView:getPositionX()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getPositionX()
end

function JJView:setPositionY(y)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setPositionY(y)
end

function JJView:getPositionY()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getPositionY()
end

function JJView:setSkewX(fSkewX)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setSkewX(fSkewX)
end

function JJView:getSkewX()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getSkewX()
end

function JJView:setSkewY(fSkewY)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setSkewY(fSkewY)
end

function JJView:getSkewY()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getSkewY()
end

function JJView:setAnchorPoint(anchorPoint)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setAnchorPoint(anchorPoint)
end

--[[
	Returns the anchor poin percent.
	
	see setAnchorPoint(const CCPoint&)

	return The anchor poof node.
--]]

function JJView:getAnchorPoint()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getAnchorPoint()
end


function JJView:setVisible( visible)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setVisible(visible)
end


function JJView:isVisible()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:isVisible()
end


--[[
	Sets the rotation (angle) of the node in degrees.
	
	0 is the default rotation angle.
	Positive values rotate node clockwise, and negative values for anti-clockwise.
	
	param fRotation     The roration of the node in degrees.
--]]
function JJView:setRotation(fRotation)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setRotation(fRotation)
end

--[[
	Returns the rotation of the node in degrees.
	see setRotation(float)
	return The rotation of the node in degrees.
--]]
function JJView:getRotation()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getRotation()
end


function JJView:setRotationX(fRotationX)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setRotationX(fRotationX)
end


function JJView:getRotationX()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getRotationX()
end

--[[
	Sets the Y rotation (angle) of the node in degrees which performs a vertical rotational skew.
	*
	0 is the default rotation angle.
	Positive values rotate node clockwise, and negative values for anti-clockwise.
	*
	@param fRotationY    The Y rotation in degrees.
--]]
function JJView:setRotationY(fRotationY)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setRotationY(fRotationY)
end

	--[[
	Gets the Y rotation (angle) of the node in degrees which performs a vertical rotational skew.
	*
	@see setRotationY(float)
	*
	@return The Y rotation in degrees.
--]]
function JJView:getRotationY()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:getRotationY()
end

--[[
	Returns whether or not the node accepts event callbacks.
	*
	Running means the node accept event callbacks like onEnter(), onExit(), update()
	*
	@return Whether or not the node is running.
--]]
function JJView:isRunning()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:isRunning()
end

--[[
	Registers a script function that will be called in onEnter() & onExit() seires functions.
	*
	This handler will be removed automatically after onExit() called.
	@code
	-- lua sample
	local function sceneEventHandler(eventType)
	if eventType == kCCNodeOnEnter then
	-- do something
	elseif evetType == kCCNodeOnExit then
	-- do something
	end
	end
	scene::registerScriptHandler(sceneEventHandler)
	endcode
	
	warning This method is for internal usage, don't call it manually.
	todo Perhaps we should rename it to get/set/removeScriptHandler acoording to the function name style.
	
	param handler   A number that indicates a lua function.
--]]

function JJView:registerScriptHandler(handlerFunc)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:registerScriptHandler(handlerFunc)
end


	--[[
	Unregisters a script function that will be called in onEnter() & onExit() series functions.
	
	see registerScriptHandler(int)
--]]
function JJView:unregisterScriptHandler()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:unregisterScriptHandler()
end


function JJView:addTouchEventListener(handlerFunc)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:registerScriptTouchHandler(handlerFunc)
end

function JJView:removeTouchEventListener()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:removeTouchEventListener()
end

function JJView:cleanup()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:cleanup()
end


function JJView:getBoundingBox(bConvertToWorld)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")

	local bConverted = false
	if bConvertToWorld ~= nil then
		assert(type(bConvertToWorld)=="boolean", "ERROR: bConvertToWorld should be boolean type!")
		bConverted = bConvertToWorld
	end
	return self.node_:getBoundingBox(bConverted)
end


function JJView:getCascadeBoundingBox(convertToWorld)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	local bConvert = true
	if converToWorld ~= nil then
		assert(type(convertToWorld)=="boolean", "ERROR: convertToWorl should be bool type")
		bConvert = convertToWorld
	end
	return self.node_:getCascadeBoundingBox(bConvert)
end

function JJView:getCascadeBoundingBoxWidth()
	return self:getCascadeBoundingBox().size.width
end

function JJView:getCascadeBoundingBoxHeight()
	return self:getCascadeBoundingBox().size.height
end

function JJView:getBoundingBoxWidth()
	return self:getBoundingBox().size.width
end

function JJView:getBoundingBoxHeight()
	return self:getBoundingBox().size.height
end

function JJView:runAction(action)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:runAction(action)
end

function JJView:stopAction(action)
	assert(not tolua.isnull(self.node_), "stopAction ERROR: node should not be nil!")
	self.node_:stopAction(action)
end

function JJView:stopAllActions()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:stopAllActions()
end

function JJView:unscheduleUpdate()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:unscheduleUpdate()
end

function JJView:scheduleUpdate(nHandler)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:scheduleUpdate(nHandler, 0)
end

function JJView:scheduleUpdateWithPriorityLua(nHandler, priority)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:scheduleUpdateWithPriorityLua(nHandler, priority)
end

function JJView:convertToNodeSpace(worldPoint)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:convertToNodeSpace(worldPoint)
end

function JJView:convertToWorldSpace(nodePoint)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	return self.node_:convertToWorldSpace(nodePoint)
end

--[[
	由parent调用，告诉parent自己是否希望parent能把中断的控制权下放给自己处理
--]]
function JJView:shouldHandDownInterIntercept()
	return false
end

function JJView:release()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:release()
end

function JJView:retain()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:retain()
end

function JJView:autorelease()
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:autorelease()
end


function JJView:setOpacity(value)
	assert(not tolua.isnull(self.node_), "ERROR: node should not be nil!")
	self.node_:setOpacity(value)
end

function JJView:schedule(callback, interval)
	assert(not tolua.isnull(self.node_), "schedule ERROR: node should not be nil!")
	return self.node_:schedule(callback, interval)
end

function JJView:performWithDelay(callback, delay)
	assert(not tolua.isnull(self.node_), "performWithDelay, ERROR: node should not be nil!")
	return self.node_:performWithDelay(callback, delay)
end

function JJView:unschedule(handler)
	assert(not tolua.isnull(self.node_), "unschedule, ERROR: node should not be nil!")
	self:stopAction(handler)
end

return JJView