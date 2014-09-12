--岛屿赛休息时数据
local IslandData = class("IslandData")

function IslandData:ctor()
	self.restTime_ = 0 --剩余时间：岛屿赛等待是有时长限制的，时间到了不继续，就主动离开了
	self.life_ = 0 --剩余血量（筹码
	self.bottles_ = nil--血瓶规则 {blood = , cost = }
	self.coin_ = 0 --能换多少金币
	self.gamesCount_ = 0 --玩了几把了
	self.multi_ = 0 --当前积分倍数
	self.nextLevelGames_ = 0 --到下一个级别还有几把
	self.nextLevelMulti_ = 0 --到下一个级别积分倍数是多少
	self.exchangeRate_ = 0 --金币和筹码的兑换比例
	self.awardTimeSpan_ = 0 --颁奖间隔
	self.nextAwardLeftSecond_ = 0 --距离下次颁奖时间还有多久
	self.startTime_ = 0
end

return IslandData