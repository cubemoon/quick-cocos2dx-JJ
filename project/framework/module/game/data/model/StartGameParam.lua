local StartGameParam = class("StartGameParam")

-- 启动游戏方式
StartGameParam.TYPE_START_CLIENT = 1
StartGameParam.TYPE_START_SIGNUP_WAIT = 2

function StartGameParam:ctor()
	self.startType_ = 0
    self.gameId_ = 0
	self.productId_ = 0
	self.tourneyId_ = 0
	self.matchId_ = 0
    self.matchType_ = 0
	self.desk_ = 0
    self.ticket_ = ""
end

return StartGameParam