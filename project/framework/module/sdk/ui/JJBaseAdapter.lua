
local JJBaseAdapter = class("JJBaseAdapter")

local TAG = "JJBaseAdapter"

function JJBaseAdapter:ctor()
	self.observer_ = nil
end
--获取item个数
function JJBaseAdapter:getCount()
   
end
--根据position获取item
function JJBaseAdapter:getItem(position)

end

--get iitem ID by position
function JJBaseAdapter:getItemId(position)

end

function JJBaseAdapter:getView(position, viewGroup, convertView)

end

function JJBaseAdapter:registerDataSetObserver(observer)
	self.observer_ = observer
end

function JJBaseAdapter:unregisterDataSetObserver(observer)
	self.observer_ = nil
end

function JJBaseAdapter:notifyDataSetChanged()
	if self.observer_ ~= nil then
		self.observer_:onChanged()
	else
		JJLog.i(TAG, "ERROR: observer is nil")
	end
end

return JJBaseAdapter
