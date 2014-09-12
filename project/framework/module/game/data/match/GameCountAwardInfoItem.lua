-- 奖状界面数据
require("sdk.xml.LuaXml")
local GameCountAwardInfoItem = class("GameCountAwardInfoItem")

function GameCountAwardInfoItem:ctor()
	self.id_ = 0
	self.name_ = nil
	self.note_ = nil
    self.style_  = 0 --Style为1表示满足max就回到min。2表示满足max就应用下一条ruler，如果没有下一条就应用最后一条
  	self.rulers_ = nil
end

function GameCountAwardInfoItem:initWithXml(xmlStr)	
	local xfile = xml.eval(xmlStr)
	local result = nil
	if xfile then 	
		result = {}

		for i, node in ipairs(xfile) do
			local item = GameCountAwardInfoItem.new()
			item.id_ = tonumber(Util:_catString(node.id))
			item.name_ = Util:_catString(node.name)
			item.note_ = Util:_catString(node.Note)
			item.style_ = tonumber(Util:_catString(node.style))          
			item.rulers_ = {}
			for j, subnode in ipairs(node) do
				local ruler = {}
				ruler.min_ = tonumber(Util:_catString(subnode.min))
				ruler.max_ = tonumber(Util:_catString(subnode.max))
				ruler.name_ = Util:_catString(subnode.name)
				item.rulers_[j] = ruler
			end

			result[i] = item			
		end
	end
	return result
end

return GameCountAwardInfoItem