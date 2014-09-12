local JJViewGroup = import(".JJViewGroup")

local JJList = class("JJlistView", JJViewGroup)
local TAG = "JJList"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local ContentLayer = import(".ContentLayer")

JJList.SCROLL_DEACCEL_RATE = 0.95
JJList.SCROLL_DEACCEL_DIST = 1.0
JJList.BOUNCE_DURATION = 0.15
JJList.INSET_RATIO = 0.2


--[[
	params: table type
	viewSize: CCSize type
	adapter: JJBaseAdapter
--]]
function JJList:ctor(params)
	JJList.super.ctor(self, params)
	JJLog.i(TAG, "ctor")
	self.dragThreshold = 10
	self.bounceThreshold = 20
	self.animateTime = 0.4

	self.firstVisibleView_ = nil
	self.lastVisibleView_ = nil
	self.firstVisibleIndex_ = 1
	JJLog.i(TAG, "befor import")
	self.layer_ = ContentLayer.new(params)
	JJLog.i(TAG, "after import")
	self:addView(self.layer_)
	self.layer_:setAnchorPoint(ccp(0, 1))
	self.layer_:setPosition(ccp(0, self:getHeight()))
	self:setAdapter(params.adapter)
	self.mRecycler_ = {}
	self.offsetPos_ = ccp(0,self:getHeight())
	self.bottomThreshold_ = self:getHeight()/4
	self.topThreshold_ = self:getHeight()*3/4
end

function JJList:onExit()
	self:_stopDeaccelerateScheduler()
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	for k, v in ipairs(self.mRecycler_) do
		v:removeSelf()
	end
	self.mRecycler_ = {}
end

function JJList:getAdapter()
	return self.adapter_
end

function JJList:getFirstVisibleView()
	return self.layer_:getFirstVisibleView()
end

function JJList:getLastVisibleView()
	return self.layer_:getLastVisibleView()
end
function JJList:setAdapter(adapter)
	JJLog.i(TAG, "setAdapter() IN")
	if adapter ~= nil then
		self.adapter_ = adapter
		local DataSetObserver ={
			onChanged= function () 
				JJLog.i(TAG, "onChanged() IN")
				self:refreshListView()
			end
		}
		self.adapter_:registerDataSetObserver(DataSetObserver)
		self.adapter_:notifyDataSetChanged()
	else
		JJLog.i(TAG, "WARNNING: adapter is nil")
	end
end

function JJList:getCount()
	JJLog.i(TAG, "getCount()")
	local adapter = self:getAdapter()
	if adapter ~= nil then
		local cnt = adapter:getCount()
		JJLog.i(TAG, "cnt=", cnt)
		return cnt
	else
		return 0
	end
	
end

function JJList:_getLayerPositionY()
	return self.layer_:getPositionY()
end

function JJList:_getLayerPositionX()
	return self.layer_:getPositionX()
end

function JJList:_getLayerHeight()
	return self.layer_:getHeight()
end

function JJList:_getLayerWidth()
	return self.layer_:getWidth()
end

function JJList:_setLayerPositionY(y)
	self.layer_:setPositionY(y)
end

function JJList:refreshListView()
	JJLog.i(TAG, "refreshListView()")
	if self:getAdapter() == nil then return end
	
	local left = 0
	local top = self:getHeight()
	self.firstVisibleIndex_ = 1
	
	local view = self:getFirstVisibleView()
	
	if view ~= nil then
		JJLog.i(TAG, "ok first visible view is not nil")
		self.firstVisibleIndex_ = view:getIdx()
		left = view:getPositionX()
		top = view:getPositionY()
		if top < self:getHeight() then
			top = self:getHeight()
		end
	end
	
	view = nil
	self.layer_:removeAllCell()
	
	for i=self.firstVisibleIndex_, self:getCount() do
		local cell = self:getAdapter():getView(i)
		JJLog.i(TAG, "for i=", i)
		self.layer_:insertToTail(cell, i)
		if top - self:_getLayerHeight() <= 0 then
			JJLog.i(TAG, "		if top - self:_getLayerHeight() <= 0 then break end")
			-- JJLog.i(TAG, "top=", top, ", layer.h=", self:_getLayerHeight(), "top-layer.h=", top-self:_getLayerHeight())
			break
		end
	end
	
	--if the layer height < self.h, then set layer pos to (0, self.h)
	if self:_getLayerHeight() < self:getHeight() then
		JJLog.i(TAG, "	if self:_getLayerHeight() < self:getHeight() then")
		self:_setLayerPositionY(self:getHeight())

		local view = self.layer_:getFirstVisibleView()
		local y = view:getPositionY()
		if view ~= nil then
			local firstIdx = view:getIdx()
			if firstIdx > 1 then
				for i=firstIdx-1, 1, -1 do
					local cell = self:_getView(i)
					assert(cell~=nil, "ERROR: cell should not be nil")
					self.layer_:insertToHead(cell, i)
					
					if self:_getLayerHeight() >= self:getHeight() then
						break;
					end
				end
			end

			JJLog.i(TAG, "y=", y, ", layer.h=", self:_getLayerHeight())
			if y > self:_getLayerHeight() then
				-- adjust cells pos
				self.layer_:resetCellsPos()
			end
		end
	end

	JJLog.i(TAG, "refreshListView() OUT")
end

function JJList:onTouchBegan(x, y)
	JJLog.i(TAG, "touchBegan()")

	self.startX = x
	self.startY = y
	self.touchPoint = ccp(x,y)
	self.bTouchMoved = false
	self.bDragging = true

	return true
end

function JJList:onTouchMoved(x, y)
	if self.bDragging == true and self:isTouchInside(x,y) then
		JJLog.i(TAG, "self.bDragging==true")
		if ccpDistance(ccp(self.startX, self.startY), ccp(x,y)) > self.dragThreshold then
			self.bTouchMoved = true
		end
		
		local pos = ccp(x,y)
		local moveDis = ccpSub(pos, self.touchPoint)
		self.touchPoint = pos
		self.scrollDistance_ = moveDis
		self:startScrollIfNeeded(moveDis.y)
		JJLog.i(TAG, "moveDis.y=", moveDis.y)
	end
end

function JJList:onTouchEnded(x, y)
	JJLog.i(TAG, "touchEnded()")
	
	if self.bTouchMoved == true then
		self:_stopDeaccelerateScheduler()
		self.deacceleHandler_ = scheduler.scheduleUpdateGlobal(handler(self, self.deaccelerateScrolling))
		self.bDragging = false
		self.bTouchMoved = false
	else
		-- reactor onItemSelected
		local cell = self:_getItemByPosition(x,y)
		if cell ~= nil then
			JJLog.i(TAG, "the idx=", cell:getIdx(), ", is selected")
			if self.onItemSelectedListener_ ~= nil then
				JJLog.i(TAG, "befor invoke item selected listener")
				self.onItemSelectedListener_(self, cell, cell:getIdx(), cell:getId())
				JJLog.i(TAG, "after invoke item selected listener")
			end
		else
			JJLog.i(TAG, "WARNNING: cell == nil")
		end
	end
end

function JJList:_getItemByPosition(x,y)
	return self.layer_:getItemByPosition(x,y)
end

function JJList:touchCancelled(x, y)
	JJLog.i(TAG, "touchCancelled()")
	self.bDragging = false
	self.bTouchMoved = false
end

function JJList:_stopDeaccelerateScheduler()
	if self.deacceleHandler_ ~= nil then
		scheduler.unscheduleGlobal(self.deacceleHandler_)
		self.deacceleHandler_ = nil
	end
end

function JJList:deaccelerateScrolling(dt)
	--JJLog.i(TAG, "deaccelerateScrolling()")
	if self.bDragging == true then
		-- scheduler.unscheduleGlobal(self.deacceleHandler_)
		self:_stopDeaccelerateScheduler()
		return
	end
	
	-- JJLog.i(TAG, "self.deltaY="..self.scrollDistance_.y)
	self.scrollDistance_ = ccpMult(self.scrollDistance_, self.SCROLL_DEACCEL_RATE)
	
	local bRes = self:startScrollIfNeeded(self.scrollDistance_.y)
	-- JJLog.i(TAG, "bRes=", bRes)
	if bRes == false or math.abs(self.scrollDistance_.y) <= self.SCROLL_DEACCEL_DIST then
		-- scheduler.unscheduleGlobal(self.deacceleHandler_)
		self:_stopDeaccelerateScheduler()
		self:relocateContainer(true)
	end
end


function JJList:relocateContainer(animated)
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
				JJLog.i(TAG, "needsAnimated ==1")
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

function JJList:_getView(idx)
	return self.adapter_:getView(idx, self, self:getRecyclerView())
end

function JJList:_scroll(y)
	JJLog.i(TAG, "_scroll(",y, ")")
	local bRes = false
	local top = self:_getLayerPositionY()+y
	if top < self.topThreshold_ then
		top = self.topThreshold_
		bRes = false
	elseif top - self:_getLayerHeight() > self.bottomThreshold_ then
		top = self:_getLayerHeight() + self.bottomThreshold_
		bRes = false
	else
		bRes = true
	end
	self:_setLayerPositionY(top)
	return bRes
end

function JJList:addToRecycler(cell)
	if cell == nil then return end
	-- cell:retain()
	self.mRecycler_[#self.mRecycler_+1] = cell
end

function JJList:getRecyclerView()
	local v = self.mRecycler_[1]
	if v ~= nil then
		table.remove(self.mRecycler_,1)
		-- v:autorelease()
	end

	return v
end

function JJList:scrollUp(y)
	JJLog.i(TAG, "scrollUp()")
	local bRes = false
	self.scrollDirection_ = 1
	local lastIdx = self.layer_:getLastVisibleIndex()
	local count = self:getCount()

	if lastIdx == count and (self:_getLayerPositionY() - self:_getLayerHeight() > self.bottomThreshold_ and self:_getLayerPositionY()-self:getHeight()> self:_getLayerHeight()/2) then
		JJLog.i(TAG, "pos y - layer.h > bottomThreshold_ just return")
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
			JJLog.i(TAG, "if the last view is entire enter visible rect, auto add")
			local lastIdx = self.layer_:getLastVisibleIndex()
			
			for i = lastIdx+1, count do
				local cell = self:_getView(i)
				assert(cell~=nil, "ERROR: cell is nil")
				self.layer_:insertToTail(cell, i)
				
				if self:_getLayerPositionY() - self:_getLayerHeight() < 0 then
					JJLog.i(TAG, "ok no need to add, break")
					break
				end
			end
		end
		
	end

	return bRes
end

function JJList:scrollDown(y)
	JJLog.i(TAG, "scrollDown(",y,")")
	local bRes = false
	self.scrollDirection_ = 2
	
	local firstIdx = self.layer_:getFirstVisibleIndex()

	if firstIdx == 1 and self:_getLayerPositionY() < self.topThreshold_ then
		return bRes
	end
	
	bRes = self:_scroll(y)
	
	if firstIdx == 1 and self:_getLayerPositionY() < self:getHeight() then
		JJLog.i(TAG, "firstIdx==1, and layer y < h, just return")
		return bRes
	else
		JJLog.i(TAG, "enter normal scroll")
		-- if the first visible cell entire enter the list rect, auto add previous cell
		JJLog.i(TAG, "[1] firstIdx=", firstIdx, ", layer.y=", self:_getLayerPositionY(), ", self.h=", self:getHeight())
		if firstIdx > 1 and self:_getLayerPositionY() < self:getHeight() then
			JJLog.i(TAG, "if the first visible cell entire enter the list rect, auto add previous cell")
			for i=firstIdx-1, 1, -1 do
				local cell = self:_getView(i)
				assert(cell ~= nil, "ERROR: cell should not be nil")
				self.layer_:insertToHead(cell, i)

				self:_setLayerPositionY(self:_getLayerPositionY()+cell:getHeight())

				if self:_getLayerPositionY() >= self:getHeight() and self:_getLayerPositionY() - self:_getLayerHeight() <= 0 then
					JJLog.i(TAG, "OK no need to add to head, break")
					break
				end
			end
		end
	
		-- if the last visible cell out of sight, remove it
		local view = self:getLastVisibleView()
		JJLog.i(TAG, "[2] firstIdx=", firstIdx, ", layer.y=", self:_getLayerPositionY(), ", self.h=", self:getHeight())
		if view ~= nil and self:_getLayerHeight() - self:_getLayerPositionY() >= view:getHeight() then
			JJLog.i(TAG, "		-- if the last visible cell out of sight, remove it")
			local cell = self.layer_:removeFromTail()
			self:addToRecycler(cell)
		end
	end
	return bRes
end


function JJList:startScrollIfNeeded(y)
	JJLog.i(TAG, "startScrollIfNeeded() y="..y)
	local bRes = false
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


function JJList:setOnItemSelectedListener(l)
	self.onItemSelectedListener_ = l
end

function JJList:setOnItemClickedListener(l)
	self.onItemClickedListener_ = l
end


JJList.TOUCH_MODE_REST = 0
JJList.TOUCH_MODE_DOWN = 1
JJList.TOUCH_MODE_MOVE = 2
JJList.TOUCH_MODE_CANCELL = 3
JJList.TOUCH_MODE_END = 4

function JJList:onInterceptTouchEvent(event, x, y)
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
			JJLog.i(TAG, "startY="..self.drag.startY..", y="..y)
			local delta = self.drag.startY - y
			local distance = math.abs(delta)
			JJLog.i(TAG, "distance = "..distance)
			if self.mTouchMode_ == self.TOUCH_MODE_MOVE then
				JJLog.i(TAG, "self.mTouchMode_==self.TOUCH_MODE_MOVE just return true")
				return true
			end

			if distance > 5 then
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

function JJList:isTouchInside(x, y)
	JJLog.i(TAG, "isTouchInside(",x, y,")")
	local pos = ccp(x, y)
	local rect = self:getBoundingBox(true)
	-- JJLog.i(TAG, "rect=", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
	return rect:containsPoint(pos)
end

return JJList
