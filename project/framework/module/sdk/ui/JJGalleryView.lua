local JJGalleryView = class("JJGalleryView", import(".JJViewGroup"))

local TAG = "JJGalleryView"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
JJGalleryView.SCROLL_DEACCEL_RATE = 0.9
JJGalleryView.SCROLL_DEACCEL_DIST = 1.0
JJGalleryView.BOUNCE_DURATION = 0.5
JJGalleryView.INSET_RATIO = 0.2

--[[
	params: table type
	viewSize: CCSize type, view size
	adapter: JJBaseAdapter type
	
--]]

function JJGalleryView:ctor(params)
	JJGalleryView.super.ctor(self, params)
	JJLog.i(TAG, "ctor() IN")
	self:setEnableScissor(true)
	self.dragThreshold = 10
	self.bounceThreshold = 20
	self.animateTime = 0.4
	self.viewItems_ = {}
	self.itemSelectedListener_ = nil
	self.deaccelRate_ = self.SCROLL_DEACCEL_RATE
	self.deaccelThresholdDist_ = self.SCROLL_DEACCEL_DIST
	self.bounceDuration_ = self.BOUNCE_DURATION

	self.adapter_ = params.adapter
	
	self.focusIdx_ = 1
	-- self:reloadGallery()
	-- self.adapter_ = params.adapter
	self:setAdapter(params.adapter)
	self:setFocusView(self.viewItems_[1])
	self.bScrollOnlyOneByOne_ = true
	self.accelerationThreshold_ = 3
	self.leftThreshold_ = self:getWidth()/4
	self.rightThreshold_ = self:getWidth()*3/4
end

function JJGalleryView:getAdapter()
	return self.adapter_
end

function JJGalleryView:setAdapter(adapter)
	if adapter ~= nil then
		self.adapter_ = adapter
		local DataSetObserver ={
			onChanged= function () 
				-- JJLog.i(TAG, "onChanged() IN")
				self:refreshGalleryView()
			end
		}
		self.adapter_:registerDataSetObserver(DataSetObserver)
		self.adapter_:notifyDataSetChanged()
	end
end

function JJGalleryView:setFocusView(view)
	-- JJLog.i(TAG, "setFocusView()")
	if self.focusView_ ~= view then
		self.focusIdx_ = view:getIdx()
		self.focusView_ = view
		-- if view ~= nil and self.itemSelectedListener_ ~= nil and self.bTouchMoved ~= true then
		if view ~= nil and self.itemSelectedListener_ ~= nil then
			self.itemSelectedListener_(self, view, view:getIdx(), view:getId())
		end
		return true
	else
		return false
	end
end

function JJGalleryView:getFocusView()
	return self.focusView_
end

function JJGalleryView:getDeaccelRate()
	return self.deaccelRate_
end

function JJGalleryView:setDeaccelRate(value)
	if self.deaccelRate_ ~= value then
		self.deaccelRate_ = value
	end
end

function JJGalleryView:getDeaccelThresholdDist()
	return self.deaccelThresholdDist_
end

function JJGalleryView:setDeaccelThresholdDist(value)
	if self.deaccelThresholdDist_ ~= value then
		self.deaccelThresholdDist_ = value
	end
end

function JJGalleryView:getBounceDuration()
	return self.bounceDuration_
end

function JJGalleryView:setBounceDuration(value)
	if self.bounceDuration_ ~= value then
		self.bounceDuration_ = value
	end
end

function JJGalleryView:setAccelerationThreshold(value)
	if self.accelerationThreshold_ ~= value then
		self.accelerationThreshold_ = value
	end
end

function JJGalleryView:getAccelerationThreshold()
	return self.accelerationThreshold_
end

function JJGalleryView:setOnItemSelectedListener(l)
	self.itemSelectedListener_ = l
end

function JJGalleryView:_getView(idx)
	assert(self.adapter_~=nil, "ERROR: adapter is nil")
	return self.adapter_:getView(idx)
end

function JJGalleryView:_getCount()
	assert(self.adapter_~=nil, "ERROR: adapter is nil")
	return self.adapter_:getCount()
end

function JJGalleryView:_addCell(cell, x, y, idx)
	assert(cell~=nil, "ERROR: cell is nil")
	cell:setAnchorPoint(ccp(0,1))
	cell:setPosition(ccp(x, y))
	self:addView(cell)
	cell:setIdx(idx)
end

function JJGalleryView:setFocusViewByIndex(idx)
	if self.focusIdx_ ~= idx then
		self.focusIdx_ = idx
		self:refreshGalleryView()
	end
end

function JJGalleryView:getFocusViewByIndex()
	local v = self:getFocusView()
	if v ~= nil then
		return v:getIdx()
	end
	return 1
end

function JJGalleryView:refreshGalleryView()
	JJLog.i(TAG, "refreshGalleryView()")
	local left = 0
	local top = self:getHeight()
	local firstIndex = 1
	local view = self.viewItems_[1]
	local focusView = self:getFocusView()

	local focusIdx = self.focusIdx_

	--step 1: 保存当前状态: 获取焦点的idx， 第一个items的left位置等
	if focusView ~= nil then
		-- focusIdx = focusView:getIdx()
	end

	if view ~= nil then
		local pos = view:getPositionInPoint()
		left = pos.x
		top = pos.y
		firstIndex = view:getIdx()
	end
	
	-- JJLog.i(TAG, "left="..left..", top="..top..", firstIdx="..firstIndex)

	--step 2: 移除所有 item views并清空， self.viewItems_
	-- self:removeAllView()
	for k, v in ipairs(self.viewItems_) do
		if v ~= nil then
			v:removeSelf()
		end
	end
	self.viewItems_ = {}

	--step 3: 重新添加view item
	local count = self:_getCount()  
	for i = firstIndex, count do
		local child = self:_getView(i)
		self:_addCell(child, left, top, i)
		JJLog.i(TAG, "left="..left)
		left = left + child:getWidth()
		self.viewItems_[#self.viewItems_+1] = child
		if left > 2*self:getWidth() then
			break
		end
	end
	
	--如果最左侧的item位置大于 -2*self:getWidth()，则自动补齐左侧的view item
	-- first view x position is inside viewsize
	local width = self:getWidth()
	-- JJLog.i(TAG, "view size w="..width)
	view = self.viewItems_[1]
	if view ~= nil then
		left = view:getPositionX()
		-- JJLog.i(TAG, "LQT: left="..left)
		if left > -2*width and view:getIdx() > 1 then
			-- JJLog.i(TAG, "OK enter add left item flow...")
			local idx = view:getIdx()
			-- JJLog.i(TAG, "idx ="..idx)
			for i=idx-1, 1, -1 do 
				local child = self:_getView(i)
				if child ~= nil then
					left = left - child:getWidth()
					self:_addCell(child, left, top, i)
					table.insert(self.viewItems_, 1, child)
					
					if left < -2*self:getWidth() then
						-- JJLog.i(TAG, "OK  left < -2*self:getWidth() break out")
						break
					end
				end
			end
		else
			JJLog.i(TAG, "do nothing for add left item")
		end
	end

	--step 4:设置focus cell，
	JJLog.i(TAG, "set focus view, focus id="..focusIdx)
	if focusIdx > #self.viewItems_ then 
		focusIdx = #self.viewItems_
	end

	for k,v in ipairs(self.viewItems_) do
		if v:getIdx() == focusIdx then
			self:setFocusView(v)
			JJLog.i(TAG, "OK set focus view")
			break
		end
	end

	--if the last item is the focus visible item
	view = self.viewItems_[#self.viewItems_]
	if view ~= nil and view:getPositionX() + view:getWidth() <= self:getWidth() then
		JJLog.i(TAG, "   --if the last item is the focus visible item, focusIdx="..view:getIdx())
		self:setFocusView(view)
	end

	--step 5: 重新定位
	self:relocateContainer(true)
end

function JJGalleryView:onTouchBegan(x, y)
	-- JJLog.i(TAG, "onTouchBegan()")
	
	if self:isTouchInside(x, y) ~= true then
		return false
	end

	self.startX = x
	self.startY = y
	
	self.originTime_ = getCurrentMillis()
	self.touchPoint = self:convertToNodeSpace(ccp(x, y))
	self.bTouchMoved = false
	self.bDragging = true
	
	return true
end

function JJGalleryView:onTouchMoved(x, y)
	if self.drag.startX == x and self.drag.startY == y then return end
	-- JJLog.i(TAG, "onTouchMoved()")
	if self.bDragging == true and self:isTouchInside(x, y) then
		--JJLog.i(TAG, "self.bDragging==true")
		if ccpDistance(CCPoint(self.startX, self.startY), CCPoint(x,y)) > self.dragThreshold then
			self.bTouchMoved = true
		end

		local newPoint = self:convertToNodeSpace(CCPoint(x, y))
		local moveDistance = ccpSub(newPoint, self.touchPoint)
		self.touchPoint = newPoint
		
		self.scrollDistance_ = moveDistance		 
		local bRes, bFocusChanged = self:scrollIfNeeded(moveDistance.x)
		
		if self:isScrollOneByOne() == true and bFocusChanged == true then
			self:_stopDeaccelerateScheduler()
			self:relocateContainer()
			self.bDragging = false
			self.bTouchMoved = false
		end
	end
end

function JJGalleryView:onTouchEnded(x, y)
	-- JJLog.i(TAG, "onTouchEnded()")
	-- [[  
	if self.bTouchMoved == true then
		if self:isScrollOneByOne() then
			local delta = self.scrollDistance_.x
			local len = math.abs(delta)
			local deltaTime = (getCurrentMillis()-self.originTime_)/1000
			local speed = len/deltaTime
			-- JJLog.i(TAG, "deltaTime=", deltaTime, ", len=", len, ", speed=", speed)
			
			-- if math.abs(delta) > self:getAccelerateThresholdDist() then
			if speed > self:getAccelerationThreshold() then
				-- JJLog.i(TAG, "math.abs(delta) > 5 delta=", delta)
				self:_stopDeaccelerateScheduler()
				local view = self:getFocusView()
				if view ~= nil then
					local focusIdx = view:getIdx()
					local idx = focusIdx
					-- JJLog.i("focusIdx=", focusIdx)
					if delta > 0 then
						-- JJLog.i(TAG, "delta > 0")
						if focusIdx > 1 then					
							-- JJLog.i(TAG, "idx = focusIdx+1")
							idx = focusIdx-1
						end
					else
						-- JJLog.i(TAG, "delta < 0")
						if focusIdx < self:_getCount() then
							idx = focusIdx + 1
						end
					end
					-- JJLog.i(TAG, "idx=", idx)
					for k, v in ipairs(self.viewItems_) do
						if v:getIdx() == idx then
							-- JJLog.i(TAG, "OK find focus view")
							self:setFocusView(v)
							break
						end
					end
					self:relocateContainer(true)
				end
			else
				self.deacceleHandler_ = scheduler.scheduleUpdateGlobal(handler(self,self.deaccelerateScrolling))
			end
		else
			self.deacceleHandler_ = scheduler.scheduleUpdateGlobal(handler(self,self.deaccelerateScrolling))			
		end

		self.bDragging = false
		self.bTouchMoved = false
	else
		-- [[
		-- local child = self:_getItemByPosition(x,y)
		-- if child ~= nil then
		if true then
			-- JJLog.i(TAG, "the idx="..child:getIdx().." is selected")
			-- self:setFocusView(child)
			local view = self:getFocusView()
			
			local deltaX = self:getWidth()/2 - (view:getPositionX()+view:getWidth()/2)
			
			view = self.viewItems_[#self.viewItems_]
			
			if view ~= nil then
				local right = view:getPositionX()+view:getWidth() + deltaX
				if right < self:getWidth()*2 then
					local index = view:getIdx()
					local count = self:_getCount()
					local left = view:getPositionX()+view:getWidth()
					local top = view:getHeight()

					if index <  count then
						for i=index+1, count do
							local child = self:_getView(i)
							self:_addCell(child, left, top, i)
							left = left + child:getWidth()
							self.viewItems_[#self.viewItems_+1] = child
							if left > self:getWidth()*2 then
								break
							end
						end
					end
				end
			end
			view = self.viewItems_[1]
			if view ~= nil then
				local left = view:getPositionX()
				local index = view:getIdx()
				local left = view:getPositionX()
				local top = view:getHeight()
				local leftX = left
				if index > 1 then
					for i=index-1, 1, -1 do
						local child = self:_getView(i)
						leftX = leftX - child:getWidth()
						self:_addCell(child, leftX, top, i)
						table.insert(self.viewItems_, 1, child)
						
						if leftX < -self:getWidth() then
							break
						end
					end
				end
			end
			self:relocateContainer(true)
			if self.onItemSelectedListener_ ~= nil then
				self.onItemSelectedListener_(self, child, child:getIdx(), child:getId())
			end
		end
		--]]
	end
	--]]
end

function JJGalleryView:onTouchCancelled(x, y)
	-- JJLog.i(TAG, "onTouchCancelled()")
	self.bDragging = false
	self.bTouchMoved = false
end

function JJGalleryView:_getItemByPosition(x,y)
	local point = self:convertToNodeSpace(ccp(x,y))
	
	for k ,v in ipairs(self.viewItems_) do
		if v:getBoundingBox():containsPoint(point) then
			return v
		end
	end
end


function JJGalleryView:deaccelerateScrolling(dt)
	-- JJLog.i(TAG, "deaccelerateScrolling()")
	if self.bDragging == true then
		self:_stopDeaccelerateScheduler()
		return
	end
	
	-- JJLog.i(TAG, "self.deltaX="..self.scrollDistance_.x)
	self.scrollDistance_ = ccpMult(self.scrollDistance_, self:getDeaccelRate())
	
	local bRes, bFocusChanged = self:scrollIfNeeded(self.scrollDistance_.x)
	-- JJLog.i(TAG, "bRes=", bRes)
	
	if self:isScrollOneByOne() ~= true then
		bFocusChanged = false
	end
	
	if bRes == false or bFocusChanged == true or math.abs(self.scrollDistance_.x) <= self:getDeaccelThresholdDist() then
		self:_stopDeaccelerateScheduler()
		self:relocateContainer(true)
	end
end

function JJGalleryView:_stopDeaccelerateScheduler()
	if self.deacceleHandler_ ~= nil then
		scheduler.unscheduleGlobal(self.deacceleHandler_)
		self.deacceleHandler_ = nil
	end
end

function JJGalleryView:relocateContainer(animated)
	-- JJLog.i(TAG, "relocateContainer()")
	local left = self:getWidth()/2
	local top = self:getHeight()
	local index = self.focusIdx_
	local view = nil
	for k ,v in ipairs(self.viewItems_) do 
		
		if v:getIdx() == index then
			view = v
			break
		end
	end
	local deltaX = 0

	if view ~= nil then
		local x = view:getPositionX()
		deltaX = self:getWidth()/2 - x - view:getWidth()/2	  
	end

	if animated == false then
		self:scrollIfNeeded(deltaX)
	else
		local left = 0
		local top = self:getHeight()

		-- JJLog.i(TAG, "deltaX=", deltaX)
		if deltaX > 0 then
			view = self.viewItems_[1]
			
			if view ~= nil then
				left = view:getPositionX()+deltaX
				-- JJLog.i(TAG, "left=", left)
				local idx = view:getIdx()
				if left > 0 and view:getIdx() > 1 then
					local x = view:getPositionX()
					local y = view:getHeight()
					for i=idx-1, 1, -1 do
						local child = self:_getView(i)
						x = x - child:getWidth()
						self:_addCell(child, x, y, i)
						table.insert(self.viewItems_, 1, child)
						if x <= 0 then
							break
						end
					end
				end
			end
		elseif deltaX < 0 then
			view = self.viewItems_[#self.viewItems_]
			if view ~= nil then
				local x = view:getPositionX()
				local y = view:getHeight()
				local right = x + view:getWidth()+deltaX
				-- JJLog.i(TAG, "right=", right)
				if right < self:getWidth() then
					local idx = view:getIdx()
					x = x + view:getWidth()
					if idx < self:_getCount() then
						for i = idx+1, self:_getCount() do
							local child = self:_getView(i)
							self:_addCell(child, x, y, i)
							x = x + child:getWidth()
							
							self.viewItems_[#self.viewItems_+1] = child

							if x >= self:getWidth() then
								break
							end
						end
					end
				end
			end
		end

		local duration = self:getBounceDuration()
		for k, v in ipairs(self.viewItems_) do
			--backOut
			transition.stopTarget(v:getNode())
			
			transition.moveBy(v:getNode(), {
								  x = deltaX,
								  y = 0,
								  time = duration,
								  easing = "EXPONENTIALOUT"
			})
		end


	end
end

function JJGalleryView:_scroll(deltaX)
	-- JJLog.i(TAG, "_scroll() deltaX=", deltaX)
	local bFocusChanged = false
	local centerX = self:getWidth()/2
	for __, v in ipairs(self.viewItems_) do
		v:setPositionX(v:getPositionX()+deltaX)
		local left = v:getPositionX()
		local right = left + v:getWidth()
		if left < centerX and right > centerX then
			bFocusChanged = self:setFocusView(v)
		end 
	end
	return bFocusChanged
end

function JJGalleryView:scrollRight(deltaX)
	local bRes = false
	local bFocusChanged = false
	local view = self.viewItems_[1]   
	self.scrollDirection_ = 2

	if view ~= nil and view:getIdx() == 1 and view:getPositionX() > self.leftThreshold_ then
		return bRes
	end

	bFocusChanged = self:_scroll(deltaX)
	bRes = true

	if view ~= nil and view:getIdx() == 1 and view:getPositionX() > 0 then

	else
		-- if the first visible view entirely enter the visible rect, then auto add pre view
		if view ~= nil and view:getPositionX() > 0 then
			local index = view:getIdx()
			if index > 1 then
				local child = self:_getView(index-1)
				local left = view:getPositionX()-child:getWidth()
				local top = view:getHeight()
				self:_addCell(child, left, top, index-1)
				table.insert(self.viewItems_, 1, child)
			end
		end

		-- if the last move out of the view visible rect, remove it
		view = self.viewItems_[#self.viewItems_]
		if view ~= nil and view:getPositionX() > self:getWidth()*2 then
			view:removeSelf()
			table.remove(self.viewItems_, #self.viewItems_)
		end
	end
	return bRes, bFocusChanged
end

function JJGalleryView:scrollLeft(deltaX)
	local view = self.viewItems_[#self.viewItems_]
	local bRes = false
	local bFocusChanged = false
	self.scrollDirection_ = 1
	if view ~= nil and view:getIdx() == self:_getCount() and view:getPositionX()+view:getWidth() < self.rightThreshold_ then
		return bRes
	end
	
	bFocusChanged = self:_scroll(deltaX)
	bRes = true

	if view ~= nil and view:getIdx() == self:_getCount() and view:getPositionX()+view:getWidth() < self:getWidth() then

	else
		-- if the first visible view entirely move outof sight, then remove it
		view = self.viewItems_[1]
		if view ~= nil and view:getPositionX() + view:getWidth() < -self:getWidth() then
			view:removeSelf()
			table.remove(self.viewItems_, 1)
		end

		-- if the last view entirely enter the visible rect ,then auto add next view
		view = self.viewItems_[#self.viewItems_]
		if view ~= nil and view:getPositionX() + view:getWidth() < self:getWidth() then
			local index = view:getIdx()
			
			if index < self:_getCount() then
				local child = self:_getView(index+1)
				local left = view:getPositionX()+view:getWidth()
				local top = view:getHeight()
				self:_addCell(child, left, top, index+1)
				self.viewItems_[#self.viewItems_+1] = child
			end
		end
	end

	return bRes, bFocusChanged
end

function JJGalleryView:_caculateDeaccelerate(bLeft)
	local a = 1
	if bLeft == true then
		local view = self.viewItems_[#self.viewItems_]
		if view ~= nil and view:getIdx() == self:_getCount() then
			local x = view:getPositionX() + view:getWidth()
			if x < self:getWidth() and x > self.rightThreshold_ then
				a = (x - self.rightThreshold_)/(self:getWidth() - self.rightThreshold_)
			end
		end
	else
		local view = self.viewItems_[1]
		if view ~= nil and view:getIdx() == 1 then
			local x = view:getPositionX()
			if x > 0 and x < self.leftThreshold_ then
				a = 1 - x/self.leftThreshold_
			end
		end
	end
	
	return a
end

function JJGalleryView:scrollIfNeeded(deltaX)
	local deaccelerate = self:_caculateDeaccelerate(deltaX<0)
	JJLog.i(TAG, "scrollIfNeeded() deaccelerate=", deaccelerate)
	if deaccelerate < 1 then
		deaccelerate = deaccelerate*0.4
	end
	
	deltaX = deltaX*deaccelerate

	if deltaX > 0 then 
		return self:scrollRight(deltaX)
	elseif deltaX < 0 then
		return self:scrollLeft(deltaX)
	end

	return false
end


JJGalleryView.TOUCH_MODE_REST = 0
JJGalleryView.TOUCH_MODE_DOWN = 1
JJGalleryView.TOUCH_MODE_MOVE = 2
JJGalleryView.TOUCH_MODE_CANCELL = 3
JJGalleryView.TOUCH_MODE_END = 4

function JJGalleryView:onInterceptTouchEvent(event, x, y)
	JJLog.i(TAG, "onInterceptTouchEvent("..event..", "..x..", "..y..")")
	if event == "began" then
		self.mTouchMode_ = self.TOUCH_MODE_REST
		self.drag = {
			startX=x,
			startY=y,
			isTap = true
		}
		--	  self.mTouchMode_ =0
		if self:isTouchInside(x, y) then
			JJLog.i(TAG, "touch inside set touchmode to DOWN")
			self.mTouchMode_ = self.TOUCH_MODE_DOWN
		end
		self:onTouch(event, x, y)
		return false
	else
		if event == "moved" then
			JJLog.i(TAG, "startX="..self.drag.startX..", x="..x)
			if self.drag.startX == x and self.drag.startY == y then
				return false
			end
			local deltaX = math.abs(self.drag.startX - x)
			local deltaY = math.abs(self.drag.startY - y)
			
			local delta = math.abs((x - self.drag.startX)/(y - self.drag.startY))
			
			local distance = deltaX*deltaX + deltaY*deltaY
			JJLog.i(TAG, "distance = "..distance)
			if self.mTouchMode_ == self.TOUCH_MODE_MOVE then
				JJLog.i(TAG, "self.mTouchMode_==self.TOUCH_MODE_MOVE just return true")
				return true
			end

			if deltaX > 5 or distance > 25 then
				JJLog.i(TAG, "OK move distance > 5 in tercept the follow event")
				self.mTouchMode_ = self.TOUCH_MODE_MOVE
				if self.mFirstTouchChild_ ~= nil then
					JJLog.i(TAG, "send cancelled event")
					self.mFirstTouchChild_:dispatchTouchEvent("cancelled", 0, 0)
					self.mFirstTouchChild_ = nil
				end
				return true
			else
				return false
			end
		elseif event == "ended" then
			self.drag = nil
			if self.mTouchMode_ == self.TOUCH_MODE_MOVE then
				self.mTouchMode_ = self.TOUCH_MODE_END
			end

			if self.mTouchMode_ == self.TOUCH_MODE_END then
				return true
			end
			return false
		elseif event == "cancelled" then
			if self.mTouchMode_ ~= self.TOUCH_MODE_REST then
				return true
			else
				return false
			end
		end
		
	end

	return false
end

function JJGalleryView:setScrollOneByOne(flag)
	self.bScrollOnlyOneByOne_ = flag
end

function JJGalleryView:isScrollOneByOne()
	return self.bScrollOnlyOneByOne_
end

function JJGalleryView:isTouchInside(x, y)
	local pos = ccp(x, y)
	local rect = self:getBoundingBox(true)
	return rect:containsPoint(pos)
end

function JJGalleryView:onExit()
	JJGalleryView.super.onExit(self)
	self:_stopDeaccelerateScheduler()
end

return JJGalleryView
