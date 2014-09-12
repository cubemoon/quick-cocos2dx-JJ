-- 奖状界面数据
require("sdk.xml.LuaXml")
local CVAwardItem = class("CVAwardItem")

function CVAwardItem:ctor()
	self.count_ = 0
	self.id_ = 0
	self.value_ = nil
	self.name_ = nil
end



function CVAwardItem:initWithXml(xmlStr)	
	local xfile = xml.eval(xmlStr)
	local result = nil

	if xfile and xfile[1] then 	
		result = {}

		for i, node in ipairs(xfile[1]) do
			local item = CVAwardItem.new()
			item.count_ = tonumber(Util:_catString(node.count))
			if node[1] then
				item.id_ = tonumber(Util:_catString(node[1].id))
				item.value_ = Util:_catString(node[1].value)
				item.name_ = Util:_catString(node[1].tip)
			end

			result[i] = item
		end
	end

	return result
end

return CVAwardItem