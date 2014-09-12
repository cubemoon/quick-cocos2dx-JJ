local JJView = import("sdk.ui.JJView")

local JJViewGroup = class("JJViewGroup", JJView)

local TAG = "JJViewGroup"

function JJViewGroup:ctor(params)
	JJViewGroup.super.ctor(self, params)

	self.bTouchEnable_ = true
	self.mChildren_ = {
		
	}
	
	self.mViewsMap_ = {}
	self.bAllowIntercept_ = true
	self.bInterceptCanHandDown_ = false
end

function JJViewGroup:onExit()
	JJViewGroup.super.onExit(self)
end


function JJViewGroup:registTouchHandler()
	self:_setTouchEnabled(true)
	self:addTouchEventListener(handler(self, self.dispatchTouchEvent))
end

function JJViewGroup:_isTextureObj(view)
	local t = typen(view)
	if t == LUA_TUSERDATA then t = tolua.type(view) end

	if t == "CCSprite" or t == "CCScale9Sprite" or t == "CCLabelTTF" then
		return true
	end

	return false
end

function JJViewGroup:addView(view, zOrder, id)
	-- JJLog.i(TAG, "addView()")
	-- JJLog.i(TAG, "cont="..#self.mChildren_..", id="..self:getId()..", name="..view.__cname)

	if self:_isTextureObj(view) == true then
		if zOrder == nil then
			self:getNode():addChild(view)
		else
			self:getNode():addChild(view, zOrder)
		end
	else
		view:setParentView(self)
		if id ~= nil then
			view:setId(id)
		end
		self.mChildren_[#self.mChildren_+1] = view
		self.mViewsMap_[view:getId()] = view

		if zOrder == nil then
			self:getNode():addChild(view:getNode())
		else
			self:getNode():addChild(view:getNode(), zOrder)
		end
	end
end

function JJViewGroup:getViewById(id)
	-- for __, v in ipairs(self.mChildren_) do
	-- 	if v:getId() == id then
	-- 		return v
	-- 	end
	-- end
	return self.mViewsMap_[id]
end

function JJViewGroup:getViewCount()
	if self.mChildren_ ~= nil then
		return #self.mChildren_
	else
		return 0
	end
end

function JJViewGroup:removeView(view, bCleanup)
	local k, v, bFind=0,1,false
	local idx = 0
	if self.mFirstTouchChild_ == view then
		self.mFirstTouchChild_ = nil
	end
	local cleanup = true
	if bCleanup ~= nil then
		cleanup = bCleanup
	end
	for k, v in ipairs(self.mChildren_) do
		if v == view then
			bFind = true
			self.mViewsMap_[v:getId()] = nil 
			idx = k
			-- JJLog.i(TAG, "OK find the view k="..k)
			break
		end
	end
	
	if bFind == true then
		-- local count = #self.mChildren_
		-- JJLog.i(TAG, "OK find the node idx="..idx..", to remove it")
		-- JJLog.i(TAG, "befor remove count="..count)
		table.remove(self.mChildren_, idx)

		-- count=#self.mChildren_
		-- JJLog.i(TAG, "after remove count="..count)

		self:getNode():removeChild(view:getNode(), cleanup)
	else

		if self:_isTextureObj(view) == true then
			JJLog.i("OK t=", t, "removed")
			self:getNode():removeChild(view, cleanup)
		else
			JJLog.i(TAG, "ERROR: view="..view.__cname.." not found")
		end
	end

end

function JJViewGroup:removeAllView()
	self.mChildren_ = {}
	self.mViewsMap_ = {}
	self.mFirstTouchChild_ = nil
	self:getNode():removeAllChildren()
end

function JJViewGroup:_canDispatch(v, x, y)
	-- JJLog.i(TAG, "_canDispatch()")

	-- if v:isTouchInside(x,y) then
	-- 	JJLog.i(TAG, "v.__name=", v.__cname, ", OK isTouchInside")
	-- else
	-- 	JJLog.i(TAG, "W not touchInside")
	-- end
	
	if v ~= nil and v:isVisible() and v:isTouchEnable() and v:isEnable() and v:isTouchInside(x, y) then
		return true
	else
		return false
	end
end

function JJViewGroup:dispatchTouchEvent(event, x, y)
	-- JJLog.i(TAG, "dispatchTouchEvent(", event, ")")

	local handled = false
	local intercepted = false

	--if event is began, sort the child list
	if event == "began" then
		self.mFirstTouchChild_ = nil

		local temp={}
		-- for __, v in ipairs(self.mChildren_) do
		for k=#self.mChildren_, 1, -1 do
			local v = self.mChildren_[k]
			v.order__ = v:getNode():getDrawOrder()
	
			if #temp == 0 then
				temp[1] = v
			else
				local bInserted = false
				for i=1, #temp do
					
					if v.order__ > temp[i].order__ then
						table.insert(temp, i, v)
						bInserted = true
						break
					end
				end

				if bInserted ~= true then
					table.insert(temp, v)
				end
			end
		end
	
		self.mChildren_ = temp

		-- table.sort(self.mChildren_, function (a,b)
		-- 			   return a.order__ > b.order__
		-- end)

	end
	
	if event == "began" then
		if self.bAllowIntercept_ == true then
			intercepted = self:onInterceptTouchEvent(event, x, y)
		end
	elseif self.mFirstTouchChild_ ~= nil  and self.mFirstTouchChild_:shouldHandDownInterIntercept() ~= true then
		-- JJLog.i(TAG, "first touch child ~=nil, and first child not require hand down intercept()")
		if self.bAllowIntercept_ == true then
			intercepted = self:onInterceptTouchEvent(event, x, y)
		end
	elseif self.mFirstTouchChild_ == nil then
		--if the children not handle the event, just process as intercepted...
		-- JJLog.i(TAG, "name=", self.__cname, "if the children not handle the event, just process as intercepted...")
		intercepted = true
	else
		JJLog.i(TAG, "default intercepted is false")
		intercepted = false
	end

	-- if  need intercept, then  pass to self`s onTouch fucntion deal it 
	if intercepted == true then
		JJLog.i(TAG, "event dispatch interrupt")
		handled = self:onTouch(event, x, y)
		return handled
	else
		--should dispatch to children
		-- JJLog.i(TAG, "event continue dispatch")
		local child = self.mFirstTouchChild_

		-- if not member touch target child, then loop process to find it
		if child == nil then

			for _, v in ipairs(self.mChildren_) do
				if v.dispatchTouchEvent ~= nil then
					-- JJLog.i(TAG, "v name="..v.__cname)
					if self:_canDispatch(v, x, y) then
						handled = v:dispatchTouchEvent(event, x, y)
						if handled == true then
							JJLog.i(TAG, "OK find the touch target="..v.__cname)
							self.mFirstTouchChild_ = v
							return true
						else
							-- JJLog.i(TAG, "target="..v.__cname..", return false")
						end
					else
						-- JJLog.i(TAG, "v name="..v.__cname.."is invisible or disable, continue")
					end
				end
			end
		else
			--had member the touch target just call dispatch function to dispatch it
			-- JJLog.i(TAG, "dispatch event to view=", child.__cname, ", id=", child:getId())
			return child:dispatchTouchEvent(event, x, y)
		end
	end
	JJLog.i(TAG, "not children handle, self process it")

	return JJViewGroup.super.dispatchTouchEvent(self, event, x, y)
	--return self:onTouch(event, x, y)
end

--[[
	和android的viewgroup的hook机制类似， 如果返回ture则中断事件向viewgroup的自控件传递
	如果touch down时返回true，则后续的move， up等消息都不会向viewgroup的自控件传递
--]]

function JJViewGroup:onInterceptTouchEvent(event, x, y)
	-- JJLog.i(TAG, "name=", self.__cname, "onInterceptTouchEvent("..event..") return false")
	return false
end

--[[
	由parent调用，告诉parent自己是否希望parent能把中断的控制权下放给自己处理
--]]
function JJViewGroup:shouldHandDownInterIntercept()
	-- return self.bInterceptCanHandDown_
	if self.mFirstTouchChild_ ~= nil then
		return self.mFirstTouchChild_:shouldHandDownInterIntercept()
	else
		return false
	end
end

function JJViewGroup:sendCancelledTouchEventToFirstTargetView(event, x, y)
	if self.mFirstTouchChild_ ~= nil then
		-- JJLog.i(TAG, "send cancelled event")
		self.mFirstTouchChild_:dispatchTouchEvent(event, 0, 0)
		self.mFirstTouchChild_ = nil
	end
end

return JJViewGroup
