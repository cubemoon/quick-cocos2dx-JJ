--报名的match信息
local SignupItem = class("SignupItem")

function SignupItem:ctor()
	self.productId_ = 0
	self.tourneyId_ = 0
	self.matchId_ = 0
	self.matchPoint_ = 0
	self.matchType_ = 0
	self.startTime_ = 0
	self.matchName_ = ""
	self.ticket_ = ""
end

return SignupItem