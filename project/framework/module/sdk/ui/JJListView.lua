local JJViewGroup = import(".JJViewGroup")

local JJListView = class("JJlistView", JJViewGroup)
local TAG = "JJListView"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

------
local ContentLayer = import(".ContentLayer")
-----------------
JJListView.SCROLL_DEACCEL_RATE = 0.9
JJListView.SCROLL_DEACCEL_DIST = 1.0
JJListView.BOUNCE_DURATION = 0.15
JJListView.INSET_RATIO = 0.2


--[[
	params: table type
	viewSize: CCSize type
	adapter: JJBaseAdapter
--]]
function JJListView:ctor(params)
	JJListView.super.ctor(self, params)
	self:setEnableScissor(true)
	-- JJLog.i(TAG, "ctor")
	self.dragThreshold = 10
	self.bounceThreshold = 20
	self.animateTime = 0.4

	self.firstVisibleView_ = nil
	self.lastVisibleView_ = nil
	self.firstVisibleIndex_ = 1

	self.layer_ = ContentLayer.new(params)

	self:addView(self.layer_)
	self.layer_:setAnchorPoint(ccp(0, 1))
	self.layer_:setPosition(ccp(0, self:getHeight()))
	self:setAdapter(params.adapter)
	self.mRecycler_ = {}
	self.offsetPos_ = ccp(0,self:getHeight())
	self.bottomThreshold_ = self:getHeight()/4
	self.topThreshold_ = self:getHeight()*3/4
end

function JJListView:onExit()
	JJListView.super.onExit(self)
	self:_stopDeaccelerateScheduler()

	for k, v in ipairs(self.mRecycler_) do
		v:removeSelf()
	end
	self.mRecycler_ = {}
end

function JJListView:getAdapter()
	return self.adapter_
end

function JJListView:getFirstVisibleView()
	return self.layer_:getFirstVisibleView()
end

function JJListView:getLastVisibleView()
	return self.layer_:getLastVisibleView()
end

function JJListView:setAdapter(adapter)
	--JJLog.i(TAG, "setAdapter() IN")
	if adapter ~= nil then
		self.adapter_ = adapter
		local DataSetObserver ={
			onChanged= function () 
				--JJLog.i(TAG, "onChanged() IN")
				self:refreshListView()
			end
		}
		self.adapter_:registerDataSetObserver(DataSetObserver)
		self.adapter_:notifyDataSetChanged()
	else
		--JJLog.i(TAG, "WARNNING: adapter is nil")
	end
end

function JJListView:getCount()
	-- --JJLog.i(TAG, "getCount()")
	local adapter = self:getAdapter()
	if adapter ~= nil then
		local cnt = adapter:getCount()
		-- --JJLog.i(TAG, "cnt=", cnt)
		return cnt
	else
		return 0
	end
	
end

function JJListView:_getView(idx)
	local v = self.adapter_:getView(idx, self, self:getRecyclerView())
	v:setEnableScissor(true)
	return v
end

function JJListView:_getLayerPositionY()
	return self.layer_:getPositionY()
end

function JJListView:_getLayerPositionX()
	return self.layer_:getPositionX()
end

function JJListView:_getLayerHeight()
	return self.layer_:getHeight()
end

function JJListView:_getLayerWidth()
	return self.layer_:getWidth()
end

function JJListView:_setLayerPositionY(y)
	self.layer_:setPositionY(y)
end

function JJListView:setFirstViewByIndex(idx)
	if self.firstVisibleIndex_ ~= idx then
		self.firstVisibleIndex_ = idx

		self:_refreshListView()
	end
end

function JJListView:_refreshListView()
	if self:getAdapter() == nil then return end
	
	if self:getCount() < self.firstVisibleIndex_ then return end

	self.layer_:removeAllCell()
	local height = self:getHeight()
	for i=self.firstVisibleIndex_, self:getCount() do
		local cell = self:getAdapter():getView(i)
		cell:setEnableScissor(true)
		self.layer_:insertToTail(cell, i)
		if self:_getLayerHeight() >= height then
			break
		end
	end
	
	local view = self:getFirstVisibleView()
	if view ~= nil and self:_getLayerPositionY() - self:_getLayerHeight() > 0 then
		local idx = view:getIdx()

		if idx > 1 then		
			for i=idx-1, 1, -1 do
				local cell = self:_getView(i)
				self.layer_:insertToHead(cell, i)
				
				if self:_getLayerPositionY() - self:_getLayerHeight() < 0 then
					self:_setLayerPositionY(self:getHeight())
					break
				end
			end
		end
	end
end

function JJListView:refreshListView()
	-- JJLog.i(TAG, "refreshListView()")
	if self:getAdapter() == nil then return end
	
	local left = 0
	local top = self:getHeight()
	self.firstVisibleIndex_ = 1
	local layerH = self:_getLayerHeight()
	local layerY = self:_getLayerPositionY()
	local bottomFlow = layerH - layerY
	local topFlow = layerY - self:getHeight()
	local view = self:getFirstVisibleView()
	local vBottomY = self:getHeight()

	if view ~= nil then
		-- JJLog.i(TAG, "ok first visible view is not nil, idx=", view:getIdx())
		self.firstVisibleIndex_ = view:getIdx()
		left = view:getPositionX()
		top = view:getPositionY()
		if top < self:getHeight() then
			top = self:getHeight()
		end
		vBottomY = layerY - view:getHeight()
		-- JJLog.i(TAG, "vBottomY=", vBottomY, "self.h=", self:getHeight())
	end

	view = nil
	self.layer_:removeAllCell()

	for i=self.firstVisibleIndex_, self:getCount() do
		local cell = self:getAdapter():getView(i)
		cell:setEnableScissor(true)
		-- -- JJLog.i(TAG, "for i=", i)
		self.layer_:insertToTail(cell, i)
		if top - self:_getLayerHeight() <= 0 then
			-- JJLog.i(TAG, "		if top - self:_getLayerHeight() <= 0 then break end")
			break
		end
	end
	
	local view = self.layer_:getFirstVisibleView()
	-- JJLog.i(TAG, "view idx=", view:getIdx())
	--if the layer height < self.h, then set layer pos to (0, self.h)
	if self:_getLayerHeight() < self:getHeight()  or (view~=nil and vBottomY + view:getHeight() < self:getHeight()) then
		-- if self:_getLayerHeight() < self:getHeight() then
		-- JJLog.i(TAG, "	if self:_getLayerHeight() < self:getHeight() then")
        if view ~= nil then
            local y = view:getPositionY()
			local firstIdx = view:getIdx()
			vBottomY = vBottomY + view:getHeight()
			-- JJLog.i(TAG, "firstIdx=", firstIdx)
			if firstIdx > 1 then
				for i=firstIdx-1, 1, -1 do
					local cell = self:_getView(i)
					self.layer_:insertToHead(cell, i)

					vBottomY = vBottomY + cell:getHeight()

					if vBottomY > self:getHeight() then
						self:_setLayerPositionY(vBottomY)
						-- JJLog.i(TAG, "vBottomY=", vBottomY, ", i=", i, ", break")
						break
					end
				end
			end

			if y > self:_getLayerHeight() then
				self.layer_:resetCellsPos()
			end
		else
			-- JJLog.i(TAG, "view==nil")
		end	
	end
	
	if self:_getLayerPositionY() - self:_getLayerHeight() > 0 then
		self:relocateContainer(false)
	end
	-- JJLog.i(TAG, "refreshListView() OUT")
end

function JJListView:onTouchBegan(x, y)
	JJLog.i(TAG, "touchBegan()")

	self.startX = x
	self.startY = y
	self.touchPoint = ccp(x,y)
	self.bTouchMoved = false
	self.bDragging = true

	return true
end

function JJListView:_caculateDeaccelerate(bUp)

	local y = self:_getLayerPositionY()
	local a = 1


	if bUp == true then
		local d = y - self:_getLayerHeight() 
		if d > 0 and d < self.bottomThreshold_ then
			a = 1 - d/self.bottomThreshold_
		end
	else
		local d = self:getHeight() - y
		if d > 0 and d < self.topThreshold_ then
			a = 1 - d/self.topThreshold_
		end
	end

	-- if a > 1 then a = 1 end
	return a
end

function JJListView:onTouchMoved(x, y)
	JJLog.i(TAG, "onTouchMoved(", x, y, ")")
	if self.bDragging == true and self:isTouchInside(x,y) then
		-- JJLog.i(TAG, "self.bDragging==true")
		if ccpDistance(ccp(self.startX, self.startY), ccp(x,y)) > self.dragThreshold then
			self.bTouchMoved = true
		end
		
		local pos = ccp(x,y)
		local moveDis = ccpSub(pos, self.touchPoint)
		self.touchPoint = pos
		self.scrollDistance_ = moveDis
		self:startScrollIfNeeded(moveDis.y)
		-- JJLog.i(TAG, "moveDis.y=", moveDis.y)
	end
end

function JJListView:_startDeaccelerateHandler()
	JJLog.i(TAG, "_startDeaccelerateHandler()")
	self:_stopDeaccelerateScheduler()		
	self.deacceleHandler_ = scheduler.scheduleUpdateGlobal(handler(self, self.deaccelerateScrolling))
end

function JJListView:onTouchEnded(x, y)
	JJLog.i(TAG, "touchEnded()", x, y)
	
	if self.bTouchMoved == true then
		if self:_getLayerPositionY() < self:getHeight() then
			self:relocateContainer(true)
		else
			if self:_getLayerPositionY() > self:getHeight() then
				if self:_getLayerPositionY() - self:_getLayerHeight() > 0 or self:_getLayerHeight() < self:getHeight() then
					self:relocateContainer(true)
				else
					self:_startDeaccelerateHandler()
				end
				-- self:_startDeaccelerateHandler()
			else
				self:_startDeaccelerateHandler()
			end
		end
		-- self:_startDeaccelerateHandler()
		self.bDragging = false
		self.bTouchMoved = false
	else
		-- reactor onItemSelected
		local cell = self:_getItemByPosition(x,y)
		if cell ~= nil then
			-- JJLog.i(TAG, "the idx=", cell:getIdx(), ", is selected")
			if self.onItemSelectedListener_ ~= nil then
				-- JJLog.i(TAG, "befor invoke item selected listener")
				self.onItemSelectedListener_(self, cell, cell:getIdx(), cell:getId())
				-- JJLog.i(TAG, "after invoke item selected listener")
			end
		else
			-- JJLog.i(TAG, "WARNNING: cell == nil")
		end
	end
end

function JJListView:_getItemByPosition(x,y)
	return self.layer_:getItemByPosition(x,y)
end

function JJListView:touchCancelled(x, y)
	-- JJLog.i(TAG, "touchCancelled()")
	self.bDragging = false
	self.bTouchMoved = false
end

function JJListView:_stopDeaccelerateScheduler()
	if self.deacceleHandler_ ~= nil then
		scheduler.unscheduleGlobal(self.deacceleHandler_)
		self.deacceleHandler_ = nil
	end
end

function JJListView:deaccelerateScrolling(dt)
	JJLog.i(TAG, "deaccelerateScrolling()")
	if self.bDragging == true then
		-- scheduler.unscheduleGlobal(self.deacceleHandler_)
		self:_stopDeaccelerateScheduler()
		return
	end
	
	-- JJLog.i(TAG, "self.deltaY="..self.scrollDistance_.y)
	self.scrollDistance_ = ccpMult(self.scrollDistance_, self.SCROLL_DEACCEL_RATE)
	
	local bRes = self:startScrollIfNeeded(self.scrollDistance_.y)
	-- -- JJLog.i(TAG, "bRes=", bRes)
	if bRes == false or math.abs(self.scrollDistance_.y) <= self.SCROLL_DEACCEL_DIST then
		-- scheduler.unscheduleGlobal(self.deacceleHandler_)
		self:_stopDeaccelerateScheduler()
		self:relocateContainer(true)
	end
end


function JJListView:relocateContainer(animated)
	JJLog.i(TAG, "relocateContainer()")
	self:_stopDeaccelerateScheduler()
	if animated ~= true then
		self:_setLayerPositionY(self:getHeight())
	else
		local deltaY = self:_getLayerHeight() - self:_getLayerPositionY()

		local needsAnimated = 0
		local view = self:getFirstVisibleView()
		if view ~= nil then
			local firstIdx = view:getIdx()
			if firstIdx == 1 and self:_getLayerPositionY() < self:getHeight() then
				needsAnimated = 1
			end
		end

		view = self:getLastVisibleView()

		if view ~= nil then
			local lastIdx = view:getIdx()
			
			if lastIdx == self:getCount() and self:_getLayerPositionY() - self:_getLayerHeight() > 0 then
				needsAnimated = 2
			end
		end
		if needsAnimated ~= 0 then
			
			transition.stopTarget(self.layer_:getNode())
			local offsetY = 0
			if needsAnimated == 1 then
				-- JJLog.i(TAG, "needsAnimated ==1")
				offsetY = self:getHeight()
			else
				offsetY = self:_getLayerHeight()
			end
			
			if self:_getLayerHeight() < self:getHeight() then
				offsetY = self:getHeight()
			end
			transition.moveTo(self.layer_:getNode(),
							  {
								  x=0,
								  y = offsetY,
								  time = 0.3,
								  easing="backOut"
							  }
			)
		end

	end
end


function JJListView:_scroll(y)
	-- JJLog.i(TAG, "_scroll(",y, ")")
	local bRes = false
	local top = self:_getLayerPositionY()+y
	-- JJLog.i(TAG, "top=", top, "toThreshold_=", self.topThreshold_)

	if top < self.topThreshold_ then
		-- JJLog.i(TAG, "	if top < self.topThreshold_ then")
		top = self.topThreshold_
		bRes = false
	elseif top - self:_getLayerHeight() > self.bottomThreshold_ and self:getHeight() - self:_getLayerHeight() < self.bottomThreshold_ then
		-- JJLog.i(TAG, "	elseif top - self:_getLayerHeight() > self.bottomThreshold_ then")
		top = self:_getLayerHeight() + self.bottomThreshold_
		bRes = false
	else
		bRes = true
		-- JJLog.i(TAG, "eslse bRes=true")
	end
	-- JJLog.i(TAG, "top=", top)
	self:_setLayerPositionY(top)

	return bRes
end

function JJListView:addToRecycler(cell)
	if cell == nil then return end
	-- cell:retain()
	self.mRecycler_[#self.mRecycler_+1] = cell
end

function JJListView:getRecyclerView()
	local v = self.mRecycler_[1]
	if v ~= nil then
		table.remove(self.mRecycler_,1)
		-- v:autorelease()
	end

	return v
end

function JJListView:scrollUp(y)
	-- JJLog.i(TAG, "scrollUp()")
	local bRes = false
	self.scrollDirection_ = 1
	local lastIdx = self.layer_:getLastVisibleIndex()
	local count = self:getCount()

	if lastIdx == nil then 
		return bRes
	end

	if lastIdx == count and (self:_getLayerPositionY() - self:_getLayerHeight() > self.bottomThreshold_ and self:_getLayerPositionY()-self:getHeight()> self:_getLayerHeight()/2) then
		-- JJLog.i(TAG, "pos y - layer.h > bottomThreshold_ just return")
		return bRes
	end

	bRes = self:_scroll(y)

	if lastIdx == count and self:_getLayerPositionY() - self:_getLayerHeight() > 0 then
		-- do nothing
	else
		-- if the first visible view is out of sight remove it
		local view = self:getFirstVisibleView()
		if view ~= nil and self:_getLayerPositionY()-view:getHeight() >= self:getHeight() then
			local cell = self.layer_:removeFromHead()
			self:addToRecycler(cell)
			self:_setLayerPositionY(self:getHeight())
		end

		-- if the last view is entire enter visible rect, auto add
		if self:_getLayerPositionY() - self:_getLayerHeight() > 0 then
			-- JJLog.i(TAG, "if the last view is entire enter visible rect, auto add")
			local lastIdx = self.layer_:getLastVisibleIndex()
			
			for i = lastIdx+1, count do
				local cell = self:_getView(i)
				assert(cell~=nil, "ERROR: cell is nil")
				self.layer_:insertToTail(cell, i)
				
				if self:_getLayerPositionY() - self:_getLayerHeight() < 0 then
					-- JJLog.i(TAG, "ok no need to add, break")
					break
				end
			end
		end
		
	end

	return bRes
end

function JJListView:scrollDown(y)
	-- JJLog.i(TAG, "scrollDown(",y,")")
	local bRes = false
	self.scrollDirection_ = 2
	
	local firstIdx = self.layer_:getFirstVisibleIndex()
	
	if firstIdx == nil then
		return bRes
	end
	
	if firstIdx ~= nil and firstIdx == 1 and self:_getLayerPositionY() < self.topThreshold_ then
		-- JJLog.i(TAG, "	if firstIdx == 1 and self:_getLayerPositionY() < self.topThreshold_ then return")
		return bRes
	end
	
	bRes = self:_scroll(y)
	
	if firstIdx ~= nil and firstIdx == 1 and self:_getLayerPositionY() < self:getHeight() then
		-- JJLog.i(TAG, "firstIdx==1, and layer y < h, just return")
		return bRes
	else
		-- JJLog.i(TAG, "enter normal scroll")
		-- if the first visible cell entire enter the list rect, auto add previous cell
		-- JJLog.i(TAG, "[1] firstIdx=", firstIdx, ", layer.y=", self:_getLayerPositionY(), ", self.h=", self:getHeight())

		if firstIdx ~= nil and firstIdx > 1 and self:_getLayerPositionY() < self:getHeight() then
			-- JJLog.i(TAG, "if the first visible cell entire enter the list rect, auto add previous cell")
			for i=firstIdx-1, 1, -1 do
				local cell = self:_getView(i)
				assert(cell ~= nil, "ERROR: cell should not be nil")
				self.layer_:insertToHead(cell, i)

				self:_setLayerPositionY(self:_getLayerPositionY()+cell:getHeight())

				if self:_getLayerPositionY() >= self:getHeight() and self:_getLayerPositionY() - self:_getLayerHeight() <= 0 then
					-- JJLog.i(TAG, "OK no need to add to head, break")
					break
				end
			end
		end
	
		-- if the last visible cell out of sight, remove it
		local view = self:getLastVisibleView()
		-- JJLog.i(TAG, "[2] firstIdx=", firstIdx, ", layer.y=", self:_getLayerPositionY(), ", self.h=", self:getHeight())
		if view ~= nil and self:_getLayerHeight() - self:_getLayerPositionY() >= view:getHeight() then
			-- JJLog.i(TAG, "		-- if the last visible cell out of sight, remove it")
			local cell = self.layer_:removeFromTail()
			self:addToRecycler(cell)
		end
	end
	return bRes
end


function JJListView:startScrollIfNeeded(y)
	-- JJLog.i(TAG, "startScrollIfNeeded() y="..y)
	local bRes = false
	local deaccelerate = self:_caculateDeaccelerate(y>0)

	if deaccelerate < 1 then
		deaccelerate = deaccelerate*0.4
		-- if deaccelerate < 0.05 then deaccelerate = 0.05 end
	end
	-- JJLog.i(TAG, "deaccelerate=", deaccelerate)
	y = y*deaccelerate
	if y > 0 then
		bRes = self:scrollUp(y)
	elseif y < 0 then
		bRes = self:scrollDown(y)
	end
	
	if bRes == true then
		self.offsetPos_ = ccp(self:_getLayerPositionX(), self:_getLayerPositionY())
	end
	return bRes
end


function JJListView:setOnItemSelectedListener(l)
	self.onItemSelectedListener_ = l
end

function JJListView:setOnItemClickedListener(l)
	self.onItemClickedListener_ = l
end


JJListView.TOUCH_MODE_REST = 0
JJListView.TOUCH_MODE_DOWN = 1
JJListView.TOUCH_MODE_MOVE = 2
JJListView.TOUCH_MODE_CANCELL = 3
JJListView.TOUCH_MODE_END = 4

function JJListView:onInterceptTouchEvent(event, x, y)
	-- JJLog.i(TAG, "onInterceptTouchEvent("..event..", "..x..", "..y..")")
	if event == "began" then
		self.mTouchMode_ = self.TOUCH_MODE_REST
		self.drag_ = {
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
			-- JJLog.i(TAG, "startY="..self.drag.startY..", y="..y)
			local delta = self.drag_.startY - y
			local distance = math.abs(delta)
			-- JJLog.i(TAG, "distance = "..distance)
			if self.mTouchMode_ == self.TOUCH_MODE_MOVE then
				-- JJLog.i(TAG, "self.mTouchMode_==self.TOUCH_MODE_MOVE just return true")
				return true
			end

			if distance > 5 then
				-- JJLog.i(TAG, "OK move distance > 5 in tercept the follow event")
				self.mTouchMode_ = self.TOUCH_MODE_MOVE
				if self.mFirstTouchChild_ ~= nil then
					-- JJLog.i(TAG, "send cancelled event")
					self.mFirstTouchChild_:dispatchTouchEvent("cancelled", 0, 0)
					self.mFirstTouchChild_ = nil
				end
				return true
			else
				return false
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

function JJListView:isTouchInside(x, y)
	-- JJLog.i(TAG, "isTouchInside(",x, y,")")
	local pos = ccp(x, y)
	local rect = self:getBoundingBox(true)
	-- JJLog.i(TAG, "rect=", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
	return rect:containsPoint(pos)
end

return JJListView
