
local JJViewGroup = import(".JJViewGroup")
local JJScrollView = class("JJScrollView", JJViewGroup)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

--direction
JJScrollView.DIRECTION_VERTICAL   = 1
JJScrollView.DIRECTION_HORIZONTAL = 2

JJScrollView.SCROLL_DEACCEL_RATE = 0.95
JJScrollView.SCROLL_DEACCEL_DIST = 1.0
JJScrollView.BOUNCE_DURATION = 0.15
JJScrollView.INSET_RATIO = 0.2

--[[
	params:
	viewSize: CCSize type, size of view
	direction: the scroll type of scroll view, default is vertical type
--]]
local TAG = "JJScrollView"
function JJScrollView:ctor(params)
	assert(params~=nil, "ERROR: params should not be nil!")
	assert(params.viewSize ~=nil, "ERROR: params.viewSize should not be nil!")
	JJScrollView.super.ctor(self, params)
	self:setEnableScissor(true)
	self.direction_ = params.direction or self.DIRECTION_VERTICAL
	assert(self.direction_ ==self.DIRECTION_VERTICAL or self.direction_==self.DIRECTION_HORIZONTAL, "ERROR: invalid direction!")
	
	self.dragThreshold_ = 5
	self.bounceThreshold_ = 20
	self.animateTime_ = 0.4
	self.scrollDistance_ = CCPoint(0,0)
	self.bDragging_ = false
	self.layer_ = nil
	self.bCanScrollFlag_ = false
	self.leftThreshold_ = self:getWidth()/4
	self.rightThreshold_ = self:getWidth()*3/4
	self.topThreshold_ = self:getHeight()/4
	self.bottomThreshold_ = self:getHeight()*3/4
end

function JJScrollView:setContentView(view)
	-- JJLog.i(TAG, "setContentView()")
	if self.layer_ ~= nil then
		self.layer_:removeSelf()
		self.layer_ = nil
	end
	
	if view == nil then
		return
	end
	
	self.layer_ = view
	view:setEnableScissor(true)
	view:setAnchorPoint(ccp(0, 1))
	local left = 0
	local top = self:getHeight()
	-- JJLog.i(TAG, "left=0, top=", top)
	view:setPosition(ccp(0, top))
	if self:getDirection() == self.DIRECTION_VERTICAL then
		if view:getHeight() > self:getHeight() then
			self.bCanScrollFlag_ = true
		else
			self.bCanScrollFlag_ = false
		end
	else
		if view:getWidth() > self:getWidth() then
			-- JJLog.i(TAG, "OK can scroll")
			self.bCanScrollFlag_ = true
		else
			-- JJLog.i(TAG, "WARNNING: can not scroll")
			self.bCanScrollFlag_ = false
		end	
	end
	self:addView(view)
end


function JJScrollView:isTouchMoving()
	return self.bTouchMoving_
end

function JJScrollView:getDirection()
	return self.direction_
end

function JJScrollView:onTouchBegan(x, y)
	if self:isTouchInside(x,y) ~= true then
		return false
	end
	
	self.drag_ = {
		startX = x,
		startY = y,
		pos = CCPoint(x,y)
	}
	
	self.bDragging_ = true

	return true
end

function JJScrollView:_caculateDeaccelerate(distance)
	
	local y = self.layer_:getPositionY()
	local x = self.layer_:getPositionX()
	local a = 1
	if self:getDirection() == self.DIRECTION_VERTICAL then
		if distance.y > 0 then
			if y - self.layer_:getHeight() > self.topThreshold_ then
	
			else
				if y - self.layer_:getHeight() > 0 then
					local d = y - self.layer_:getHeight()
					a = 1 - d/self.topThreshold_
				end
			end
		elseif distance.y < 0 then
			if y < self.bottomThreshold_ then
	
			else
				if y < self:getHeight() then
					local d = self:getHeight() - y
					a = 1 - d/self.topThreshold_
				end
			end
		end
	else
		if distance.x > 0 then
			if x > self.leftThreshold_ then
	
			else
				local d = x
				a = 1 - d/self.leftThreshold_
			end
		elseif distance.x < 0 then
			if x + self.layer_:getWidth() < self.rightThreshold_ then

			else
				local d = self:getWidth() - (x + self.layer_:getWidth())
				a = d/(self:getWidth() - self.rightThreshold_)
			end
		end
	end

	return a
end

function JJScrollView:onTouchMoved(x, y)
	-- JJLog.i(TAG, "onTouchMoved(",x, ",", y, ")")
	if self.bCanScrollFlag_ == false then
		JJLog.i(TAG, " can not scroll just return")
		return
	end

	local deaccelerate = 1

	if self.bDragging_ == true and self.layer_ ~= nil then
		self:_stopDeaccelerateScheduler()
		if ccpDistance(ccp(self.drag_.startX, self.drag_.startY), ccp(x,y)) > self.dragThreshold_ then
			self.bTouchMoving_ = true
		end
		
		local distance = ccpSub(ccp(x, y), ccp(self.drag_.pos.x, self.drag_.pos.y))
		
		self.drag_.pos.x = x
		self.drag_.pos.y = y
		
		if self:isTouchInside(x, y) == true then
			if self:getDirection() == self.DIRECTION_VERTICAL then
				distance = ccp(0, distance.y)
			else
				distance = ccp(distance.x, 0)
			end

			self.scrollDistance_ = distance
			local pos = self.layer_:getPositionInPoint()
			
			
			-- 拖动超过阀值就不在更新位置
			if self:getDirection() == self.DIRECTION_VERTICAL then
				if distance.y > 0 then
					if self.layer_:getPositionY() - self.layer_:getHeight() > self.topThreshold_ then
						distance.y = 0
					else
						if self.layer_:getPositionY() - self.layer_:getHeight() > 0 then
							local d = self.layer_:getPositionY() - self.layer_:getHeight()
							deaccelerate = 1 - d/self.topThreshold_
						end
					end
				elseif distance.y < 0 then
					if self.layer_:getPositionY() < self.bottomThreshold_ then
						distance.y = 0
					else
						if self.layer_:getPositionY() < self:getHeight() then
							local d = self:getHeight() - self.layer_:getPositionY()
							deaccelerate = 1 - (self:getHeight() - self.layer_:getPositionY())/self.topThreshold_
						end
					end
				end
			else
				if distance.x > 0 then
					if self.layer_:getPositionInPoint().x > self.leftThreshold_ then
						distance.x = 0
					end
				elseif distance.x < 0 then
					if self.layer_:getPositionInPoint().x + self.layer_:getWidth() < self.rightThreshold_ then
						distance.x = 0
					end
				end
			end
			
			deaccelerate = self:_caculateDeaccelerate(distance)
			if deaccelerate < 1 then
				deaccelerate = deaccelerate*0.4
			end
			-- JJLog.i(TAG, "deaccelerate=", deaccelerate)
			local bUpdate = false
			if self:getDirection() == self.DIRECTION_VERTICAL then
				if distance.y ~= 0 then
					bUpdate = true
				end
				distance.y = distance.y*deaccelerate
			else
				if distance.x ~= 0 then
					bUpdate = true
				end
				distance.x = distance.x*deaccelerate
			end

			if bUpdate == true then
				local newPos = ccpAdd(pos, distance)
				-- JJLog.i(TAG, "newPos.x=", newPos.x, ", newPos.y=", newPos.y)
				self:setContentOffset(newPos)
			end
		else
			self:onTouchEnded(x,y)
		end
	end
end

function JJScrollView:_startDeacceleHandler()
	self:_stopDeaccelerateScheduler()
	JJLog.i(TAG, "_startDeacceleHandler()")
	self.deacceleHandler_ = scheduler.scheduleUpdateGlobal(handler(self,self.deaccelerateScrolling))
end

function JJScrollView:onTouchEnded(x, y)
	-- JJLog.i(TAG, "onTouchEnded(",x, ",", y, ")")
	if self.bTouchMoving_ == true then
		if self.bCanScrollFlag_ == true then
			if self.deacceleHandler_ ~= nil then
				self:_stopDeaccelerateScheduler()
			else
				if self.layer_:getPositionY() < self:getHeight() or self.layer_:getPositionY() - self.layer_:getHeight() then
					self:relocateContainer(true)
				else
					self:_startDeacceleHandler()
				end
			end
		end
		self.bTouchMoving_ = false
		self.bDragging_ = false
	end
end

function JJScrollView:onTouchCancelled(x, y)
	self.bTouchMoving_ = false
	self.bDragging_ = false

	self:_stopDeaccelerateScheduler()
end

function JJScrollView:setContentOffset(offset, animated)
	-- JJLog.i(TAG, "setContentOffset() offset=(", offset.x, ",", offset.y,")")
	if self.layer_ == nil then
		return
	end
	local x = offset.x
	local y = offset.y
	
	if animated == true then
		self:setContentOffsetInDuration(offset, self.BOUNCE_DURATION)
	else
		self.layer_:setPosition(offset)
	end
	
end

function JJScrollView:setContentOffsetInDuration(offset, dt)
	transition.stopTarget(self.container_)
   transition.moveTo(self.layer_:getNode(), {
						x = offset.x,
						y = offset.y,
						time = 0.3,
						easing = "backOut"
   })
end

function JJScrollView:deaccelerateScrolling(dt)
	--JJLog.i(TAG, "deaccelerateScrolling()")
	
	if self.bDragging_ == true then
		self:_stopDeaccelerateScheduler()
		return
	end
	local pos = ccpAdd(self.layer_:getPositionInPoint(), self.scrollDistance_)
	self.layer_:setPosition(pos)
	self.scrollDistance_ = ccpMult(self.scrollDistance_, self.SCROLL_DEACCEL_RATE)
	
	local deltaX = math.abs(self.scrollDistance_.x)
	local deltaY = math.abs(self.scrollDistance_.y)
	--JJLog.i(TAG, "deltaX="..deltaX..", deltaY="..deltaY)
   
	local bInerDis = (deltaX <= self.SCROLL_DEACCEL_DIST and deltaY <= self.SCROLL_DEACCEL_DIST)
	local x,y = self.layer_:getPosition()
	--JJLog.i(TAG, "bInerDis=", bInerDis)
	if bInerDis == true then
		self:_stopSchedulerAndRelocator();
	else
		if self:getDirection() == self.DIRECTION_VERTICAL then
			if self.scrollDistance_.y > 0 then
				if y-self.layer_:getHeight() > self.topThreshold_ then
					self:_stopSchedulerAndRelocator();
				end
			elseif self.scrollDistance_.y < 0 then
				if y < self.bottomThreshold_ then
					self:_stopSchedulerAndRelocator();
				end
			end
		else
			if self.scrollDistance_.x > 0 then
				if x > self.leftThreshold_ then
					self:_stopSchedulerAndRelocator();
				end
			else
				if x + self.layer_:getWidth() < self.rightThreshold_ then
					self:_stopSchedulerAndRelocator();
				end
			end
		end
	end

end

function JJScrollView:_relocateWhithAnim(dt)
	dt = dt * 100
	JJLog.i(TAG, "_relocateWhithAnim() dt=", dt)
	if self.bStartRelocate_ == true then
		if self.relocateParam_ ~= nil then
			local p = ccp(1,1)
			local x, y = self.layer_:getPosition()
			if self:getDirection() == self.DIRECTION_VERTICAL then
				if self.relocateParam_.up == true then
					p.y = -1
					local a = self:_caculateDeaccelerate(p)*7*1.618
					JJLog.i(TAG, "a=", a)
					-- a = 1 - a
					if a < 0.618 then a = 0.618 end
					y = y + dt*a
					JJLog.i(TAG, "delat y=", dt*a)
					if y > self.relocateParam_.y then
						y = self.relocateParam_.y
						self.bStartRelocate_ = false
					end
				else
					p.y = 1
					local a = self:_caculateDeaccelerate(p)*4*1.618
					if a < 0.618 then a = 0.618 end

					-- a = 1 - a
					y = y - dt*a
					JJLog.i(TAG, "delta y=", dt*a)
					if y < self.relocateParam_.y then
						y = self.relocateParam_.y
						self.bStartRelocate_ = false
					end
				end
			else
				if self.relocateParam_.left == true then
					p.x = 1
					local a = self:_caculateDeaccelerate(p)
					-- a = 1 - a
					x = x - dt*a
					if x < self.relocateParam_.x then
						x = self.relocateParam_.x
						self.bStartRelocate_ = false
					end
				else
					p.x = -1
					local a = self:_caculateDeaccelerate(p)
					-- a = 1 - a
					x = x + dt*a
					if x > self.relocateParam_.x then
						x = self.relocateParam_.x
						self.bStartRelocate_ = false
					end
				end
			end
			JJLog.i(TAG, "y=", y)
			JJLog.i(TAG, "newY=", self.relocateParam_.y)
			self.layer_:setPosition(ccp(x, y))
		end
	else
		self:unscheduleUpdate()
	end
end

function JJScrollView:relocateContainer(animated)
   -- JJLog.i(TAG, "relocateContainer()")
   local x, y = self.layer_:getPosition()

   local newX = x
   local newY = y
   local bUp = false
   local bLeft = false
   if self:getDirection() == self.DIRECTION_VERTICAL then
	   if newY < self:getHeight() then
		   -- JJLog.i(TAG, "if newY < self:getHeight() then")
		   newY = self:getHeight()
		   bUp = true
	   elseif newY - self.layer_:getHeight() > 0 then
		   -- JJLog.i(TAG, "newY - self.layer_:getHeight() > 0")
		   newY = self.layer_:getHeight()
		   bUp = false
	   end
   else
	   -- JJLog.i(TAG, " DIRECTION_HORIZONTAL")
	   if newX > 0 then
		   newX = 0
		   bLeft = true
	   elseif newX + self.layer_:getWidth() < self:getWidth() then
		   newX = self:getWidth() - self.layer_:getWidth()
		   bLeft = false
	   end
   end

   if (newY ~= y or newX ~= x) then
	  -- JJLog.i(TAG, "newX="..newX..", newY="..newY)
	   if animated ~= true then
		   self:setContentOffset(CCPoint(newX, newY), animated)
	   else
		   self.relocateParam_ = {
			   x=newX,
			   y=newY,
			   up = bUp,
			   left=bLeft
		   }
		   self.bStartRelocate_ = true
		   self:scheduleUpdate(handler(self, self._relocateWhithAnim))
	   end
   end

end

function JJScrollView:_stopDeaccelerateScheduler()
	if self.deacceleHandler_ ~= nil then
		scheduler.unscheduleGlobal(self.deacceleHandler_)
		self.deacceleHandler_ = nil
		
	end
end

function JJScrollView:_stopSchedulerAndRelocator()
	self:_stopDeaccelerateScheduler()
	self:relocateContainer(true)
end


JJScrollView.TOUCH_MODE_REST = 0
JJScrollView.TOUCH_MODE_DOWN = 1
JJScrollView.TOUCH_MODE_MOVE = 2
JJScrollView.TOUCH_MODE_CANCELL = 3
JJScrollView.TOUCH_MODE_END = 4

function JJScrollView:_interceptTouchEvent()
	self.mTouchMode_ = self.TOUCH_MODE_MOVE
	if self.mFirstTouchChild_ ~= nil then
		-- JJLog.i(TAG, "send cancelled event")
		self.mFirstTouchChild_:dispatchTouchEvent("cancelled", 0, 0)
		self.mFirstTouchChild_ = nil
	end
end

function JJScrollView:onInterceptTouchEvent(event, x, y)
   -- JJLog.i(TAG, "onInterceptTouchEvent("..event..", "..x..", "..y..")")
   if event == "began" then
	  self.mTouchMode_ = self.TOUCH_MODE_REST
	  self.drag = {
		 startX=x,
		 startY=y,
		 isTap = true
	  }
	  --	  self.mTouchMode_ =0
	  if self:isTouchInside(x, y) then
		 -- JJLog.i(TAG, "touch inside set touchmode to DOWN")
		 self.mTouchMode_ = self.TOUCH_MODE_DOWN
	  end
	  self:onTouch(event, x, y)
	  return false
   else
	  if event == "moved" then
		 -- JJLog.i(TAG, "startX="..self.drag.startX..", x="..x)
		 local deltaX = math.abs(self.drag.startX - x)
		 local deltaY = math.abs(self.drag_.startY - y)
		 
		 if self.mTouchMode_ == self.TOUCH_MODE_MOVE then
			-- JJLog.i(TAG, "self.mTouchMode_==self.TOUCH_MODE_MOVE just return true")
			return true
		 end
		 
		 if self:getDirection() == self.DIRECTION_VERTICAL then
			 if deltaY > 3 then
				 JJLog.i(TAG, "OK move deltaX > 5 in tercept the follow event")
				 self:_interceptTouchEvent()
				 return true
			 else
				 return false
			 end

		 else
			 if deltaX > 3 then
				 JJLog.i(TAG, "OK move deltaX > 5 in tercept the follow event")
				 self:_interceptTouchEvent()
				 return true
			 else
				 return false
			 end

		 end


	  elseif event == "ended" then
		self.drag_ = nil
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

function JJScrollView:isTouchInside(x, y)
	local pos = ccp(x, y)
	local rect = self:getBoundingBox(true)
	return rect:containsPoint(pos)
end

function JJScrollView:onExit()
	JJScrollView.super.onExit(self)
	self:_stopDeaccelerateScheduler()
end


return JJScrollView