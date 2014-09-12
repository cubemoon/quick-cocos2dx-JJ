require("sdk.xml.LuaXml")
local RoundInfo = class("RoundInfo")

function RoundInfo:ctor()
	self.roundId_ = 0 --第几局
	self.roundType_ = 0 --局制类型 [[1:显示 第几局 （gameID）2显示 第几轮第几副 （boutID，gameID）]]
	self.boutId_ = 0    --第几回合
	self.tableId_ = 0   --桌号
	self.gameId_ = 0    --第几副牌
	self.scoreTypeName_ = "" --积分方法
	self.scoreBase_ = 0 --游戏基数
	self.roundTypeName_ = "" --局制名称
	self.roundNote_ = "" --局制信息
	--self.stringDic_ = {} --规则内容
	--name="积分方式" value="积分×基数"/><l name="游戏基数" value="500"/>
end

function RoundInfo:initWithXml(xmlStr)	
	local xfile = xml.eval(xmlStr)
	local result = nil

	if xfile then 			
		result = RoundInfo.new()
		result.roundId_ = tonumber(Util:_catString(xfile.id))
		result.roundType_ = tonumber(Util:_catString(xfile.type))
		result.boutId_ = tonumber(Util:_catString(xfile.BoutID))
		result.tableId_ = tonumber(Util:_catString(xfile.TableID))
		result.gameId_ = tonumber(Util:_catString(xfile.GameID))

		for i, node in ipairs(xfile) do					
			if Util:_catString(node.name) == "积分方式" then
				result.scoreTypeName_ = Util:_catString(node.value) 
			elseif Util:_catString(node.name) == "游戏基数" then
				result.scoreBase_ = tonumber(Util:_catString(node.value))
			elseif Util:_catString(node.name) == "局制名称" then
				result.roundTypeName_ = Util:_catString(node.value) 
			elseif Util:_catString(node.name) == "Note" then
				result.roundNote_ = Util:_catString(node.value) 
			end
		end		
	end

	return result
end

return RoundInfo