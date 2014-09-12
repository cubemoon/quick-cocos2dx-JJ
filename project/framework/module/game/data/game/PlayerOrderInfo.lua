-- player 排名积分信息
local PlayerOrderInfo = class("PlayerOrderInfo")

function PlayerOrderInfo:ctor()
	self.userId_ = 0
	self.nickName_ = ""
	self.rank_ = 0 			-- 排名
	self.out_ = false   	-- 是否除名
	self.score_ = 0     	--积分
	self.deskMate_ = false  --是否同桌
end

return PlayerOrderInfo