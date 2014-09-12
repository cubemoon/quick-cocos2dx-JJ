local JJViewGroup = import(".JJViewGroup")
local ContentLayer = class("ContentLayer", JJViewGroup)

function ContentLayer:ctor(params)
	ContentLayer.super.ctor(self)
	self.TAG = "ContentLayer"
	self:setViewSize(params.viewSize.width, params.viewSize.height)
	self.viewItems_ = {}
	self.parentSize_ = params.viewSize
	self:setEnableScissor(true)
end

function ContentLayer:getAdapter()
	local p = self:getParentView()
	if p ~=nil then
		return p:getAdapter()
	end

	return nil
end

function ContentLayer:refreshListView()
	local p = self:getParentView()
	if p ~= nil then
		return p:refreshListView()
	end
end

function ContentLayer:insertToHead(cell, idx)
	--JJLog.i(self.TAG, "insertToHead() idx=", idx)
	assert(cell~=nil, "ERROR: cell should not be nil!")
	cell:setIdx(idx)
	local v = self.viewItems_[#self.viewItems_]
	
	table.insert(self.viewItems_, 1, cell)
	self:addView(cell)
	
	local left = 0
	local top = self.parentSize_.height
	
	if v ~= nil then
		top = v:getPositionY() + cell:getHeight()
	end
	
	self:_setCellPos(cell, left, top)
	self:_updateSize()
end

function ContentLayer:_setCellPos(cell, x, y)
	assert(cell~=nil, "ERROR: cell should not be nil!")
	--JJLog.i(self.TAG, "_setCellPosition(",x,y,")")
	cell:setAnchorPoint(ccp(0,1))
	cell:setPosition(ccp(x,y))
end

function ContentLayer:insertToTail(cell, idx)
	--JJLog.i(self.TAG, "insertToTail() idx=", idx)
	assert(cell~=nil, "ERROR: cell should not be nil!")
	cell:setIdx(idx)
	local v = self.viewItems_[#self.viewItems_]	
	self:addView(cell)

	self.viewItems_[#self.viewItems_+1] = cell
	
	local left = 0
	local top = self:getHeight()


	if v ~= nil then
		top = v:getPositionY() - v:getHeight()
	else
		--JJLog.i(self.TAG, "v == nil")
		top = self.parentSize_.height 
	end

	self:_setCellPos(cell, left, top)

	self:_updateSize()
	-- top = self:getHeight()
	-- for k, v in ipairs(self.viewItems_) do
	-- 	v:setPositionY(top)
	-- 	top = top - v:getHeight()
	-- end
	--JJLog.i(self.TAG, "insertToTail() OUT")
end

function ContentLayer:_updateSize()
	--JJLog.i(self.TAG, "_updateSize() IN")
	local h = 0
	for k, v in ipairs(self.viewItems_) do
		h = h + v:getHeight()
	end
	--JJLog.i(self.TAG, "h=", h)
	-- self:setHeight(h)
	self:setViewSize(self:getWidth(), h)

	local top = self:getHeight()
	for k, v in ipairs(self.viewItems_) do
		v:setPositionY(top)
		top = top - v:getHeight()
	end
	--JJLog.i(self.TAG, "_updateSize() OUT")
end

function ContentLayer:removeFromHead()
	--JJLog.i(self.TAG, "removeFromHead()")
	local h = 0
	local view = self.viewItems_[1]
	if view ~= nil then
		
		table.remove(self.viewItems_, 1)
		view:retain()
		view:removeSelf()
		self:_updateSize()
		h = self:getHeight()
		for k, v in ipairs(self.viewItems_) do
			v:setPositionY(h)
			h = h - v:getHeight()
		end
	end

	return view
end

function ContentLayer:removeFromTail()
	--JJLog.i(self.TAG, "removeFromTail() IN")
	
	local view = self.viewItems_[#self.viewItems_]
	if view ~= nil then
		view:retain()
		view:removeSelf(false)
		local index = #self.viewItems_
		--JJLog.i(self.TAG, "index=", index)
		table.remove(self.viewItems_, index)
		--JJLog.i(self.TAG, "2 index=", #self.viewItems_)

		self:_updateSize()
		--JJLog.i(self.TAG, "update pos")
		local h = self:getHeight()
		for k,v in ipairs(self.viewItems_) do
			--JJLog.i("k=",k, ", h=", h)
			if v ~= nil then
				v:setPositionY(h)
				h = h - v:getHeight()
			end
		end
		--JJLog.i(self.TAG, "after udpate pos")
	end
	--JJLog.i(self.TAG, "removeFromTail() OUT")
	return view
end

function ContentLayer:getFirstVisibleIndex()
	local v = self.viewItems_[1]
	if v ~= nil then
		return v:getIdx()
	end
end

function ContentLayer:getLastVisibleIndex()
	local v = self.viewItems_[#self.viewItems_]
	if v ~= nil then
		return v:getIdx()
	end
end

function ContentLayer:getFirstVisibleView()
	return self.viewItems_[1]
end

function ContentLayer:getLastVisibleView()
	return self.viewItems_[#self.viewItems_]
end

function ContentLayer:getItemByPosition(x,y)
	-- local point = self:convertToNodeSpace(ccp(x,y))
	local point = ccp(x,y)
	--JJLog.i(self.TAG, "_getItemByPosition(", x, y, ")")

	for k ,v in ipairs(self.viewItems_) do
		local box = v:getBoundingBox(true)
		-- --JJLog.i(self.TAG, "idx=", v:getIdx(), "v.box=", box.origin.x, box.origin.y, box.size.width, box.size.height)
		if box:containsPoint(point) then
			--JJLog.i(self.TAG, "OK find pressed cell")
			return v
		end
	end
end


function ContentLayer:removeAllCell()
	self.viewItems_ = {}
	self:removeAllView()
end

function ContentLayer:resetCellsPos()
	--JJLog.i(self.TAG, "resetCellsPos() IN")
	local left = 0
	local top = self:getHeight()
	for k, v in ipairs(self.viewItems_) do
		v:setPositionY(top)
		top = top - v:getHeight()
	end
end

return ContentLayer
