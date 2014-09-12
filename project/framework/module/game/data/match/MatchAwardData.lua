-- 奖状界面数据
require("sdk.xml.LuaXml")
local MatchAwardData = class("MatchAwardData")
local TAG = "MatchAwardData "

function MatchAwardData:ctor()
    self.matchId_ = 0         -- 得到奖励的matchid
    self.nickName_ = ""      -- 得到奖励的用户名
    self.matchName_ = ""      -- 比赛名称
    self.historyNote_ = ""     -- 以往在此比赛中成绩
    self.rank_ = 0            --比赛排名
    self.totalPlayer_ = 0      -- 参加人数    
    self.awards_ = {}        -- 获得的所有奖励
    self.wAwards_ = {}        -- 获得的物品奖励
    self.xml = nil   --奖励原始的xml信息
    self.matchAwardEventTime = JJTimeUtil:getCurrentSecond()
end
--[[
test dataxmlStr="<Award MatchName="斗地主免费赢1元手机充值卡" MPID="438" TourneyID="1168860" MatchID="1197871245" 
UserID="184728997" Rank="16" MatchBeginTime="(14-04-03 16:43)" PlayerAmount="96">
<M ID="金币"  V="50" />
<S ID="经验"  V="200" />
<H Note="恭喜！您在本赛事中曾荣获过1次“冠军”，加油！(14-04-03 16:59)" />
</Award>
]]
function MatchAwardData:initWithXml(xmlStr, nickName)
    self.xml = xmlStr
    local str = string.gsub(xmlStr, " = ", "=")
    --JJLog.i(vardump(str, "xmlstr "))

    local xfile = xml.eval(str)
    --JJLog.i(vardump(xfile, "xfile = "))    

    self.nickName_ = nickName        
    self.totalPlayer_ = tonumber(Util:_catString(xfile.PlayerAmount))
    self.matchId_ = tonumber(Util:_catString(xfile.MatchID))
    self.matchName_ = Util:_catString(xfile.MatchName)
    self.rank_ = tonumber(Util:_catString(xfile.Rank))
    
    local aIndex, wIndex = 1, 1
    local item = nil
    for i, node in ipairs(xfile) do        
    	--JJLog.i("linxh", node[1], ", ", node["\"M\""], "," , node.M, ",", node[2], ", ", node[0])
        if node[0] == "H" then
        	self.historyNote_ = Util:_catString(node.Note)
        elseif node[0] == "M" or node[0] == "S" then
        	item = {wareId=0,
        			amount=Util:_catString(node.V),
        			type=Util:_catString(node.ID)}
        	self.awards_[aIndex] = item
        	aIndex = aIndex + 1
        elseif node[0] == "G" then
         	local nId = tonumber(Util:_catString(node.ID)) or 0
         	if nId ~= 209 and nId ~= 79 then --过滤掉 Flash平台经验
         		local name = GrowInfoManager:getGrowName(nId)
         		if name and string.len(name) > 0 then
         			item = {wareId=nId,
		        			amount=Util:_catString(node.V),
		        			type=name}
		        	self.awards_[aIndex] = item
		        	aIndex = aIndex + 1
         		end
            end
        elseif node[0] == "W" then
        	local nId = tonumber(Util:_catString(node.ID)) or 0
        	local name = WareInfoManager:getWareName(nId)
        	if name and string.len(name) > 0 then
        		local ware  = WareInfoManager:getWareItem(nId)
        		item = {wareId=nId,
		        		amount=Util:_catString(node.V),
		        		type=name,
		        		merit = (ware and ware.merit_ware) or ""}
		        --将物品放到最前面
		        table.insert(self.awards_, 1, item)
		        aIndex = aIndex + 1

		        self.wAwards_[wIndex] = item
		        wIndex = wIndex + 1
        	end
        end
    end

	--JJLog.i(vardump(self, "award"))  
end


return MatchAwardData