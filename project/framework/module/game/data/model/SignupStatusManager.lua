-- 比赛报名状态管理
-- require("game.data.model.SignupItem")

SignupStatusManager = {
	startedMatch_ = {},  --{matchid, signupitem} 开始的比赛
	signupedMatch_ = {}, --{tourenyId, signupitem} 已经报名的比赛
	signupingMatch_ = {}, --{tourneyId, signupitem} 可报名比赛
	exitMatchId_ = 0,
	exitProductId_ = 0,
	signupItemClass_ = require("game.data.model.SignupItem")
}

function SignupStatusManager:reset()
	self.startedMatch_ = {}
	self.signupedMatch_ = {}
	self.signupingMatch_ = {}
	exitMatchId_ = 0
	exitProductId_ = 0
end

--添加开赛的match信息
function SignupStatusManager:addStartedItem(signupItem)
	if signupItem ~= nil then
		self.startedMatch_[signupItem.matchId_] = signupItem
	end
end

--移除开赛的match信息
function SignupStatusManager:removeStartedItem(matchId)
	if self.startedMatch_[matchId] ~= nil then
		self:setExitMatchIdProductId(matchId, self.startedMatch_[matchId].pruductId_)
		self.startedMatch_[matchId] = nil
	end
end

function SignupStatusManager:setExitMatchIdProductId(matchId, productId)
	self.exitMatchId_ = matchId
	self.exitProductId_ = productId
end

function SignupStatusManager:getStartedItem(matchId, gameId)
	if self.startedMatch_[matchId] ~= nil then
		return self.startedMatch_[matchId]
	else 
		return nil
	end
end

function SignupStatusManager:getStartedMatchCount()
	return #self.startedMatch_
end

--增加报名中的match信息
function SignupStatusManager:addSignupingItem(gameId, productId, tourneyId)
	local signupItem = self.signupItemClass_.new()
	signupItem.productId_ = productId
	signupItem.tourneyId_ = tourneyId
	local matchConfigItem = MatchConfigManager:getMatchConfigItem(gameId, productId)
	if matchConfigItem ~= nil then
		signupItem.matchName_ = matchConfigItem.productName
		signupItem.matchType_ = tonumber(matchConfigItem.matchType)
	end
	self.signupingMatch_[tourneyId] = signupItem
end

function SignupStatusManager:removeSignupingItem(tourneyId)
	if self.signupingMatch_[tourneyId] ~= nil then
		local signupItem = self.signupItemClass_.new()
		signupItem = self.signupingMatch_[tourneyId]
		self.signupingMatch_[tourneyId] = nil
		return signupItem
	else
		return nil
	end
end

function SignupStatusManager:getSignupingItem(tourneyId)
	if self.signupingMatch_[tourneyId] ~= nil then
		return self.signupingMatch_[tourneyId]
	else
		return nil
	end
end

--增加已经报名的match信息
function SignupStatusManager:addSignupedItem(gameId, productId, tourneyId, matchPoint, startTime)
	local signupItem = self.signupItemClass_.new()
	signupItem.productId_ = productId
	signupItem.tourneyId_ = tourenyId
	signupItem.matchPoint_ = matchPoint
	signupItem.startTime_ = startTime
	local matchConfigItem = MatchConfigManager:getMatchConfigItem(gameId, productId)
	if matchConfigItem ~= nil then
		signupItem.matchType_ = tonumber(matchConfigItem.matchType)
		signupItem.matchName_ = matchConfigItem.productName
	end
	self.signupedMatch_[tourneyId] = signupItem
end

function SignupStatusManager:addSignupedItemCls(signupItem)
	if signupItem then
		self.signupedMatch_[signupItem.tourneyId_] = signupItem
	end 
end

function SignupStatusManager:removeSignupedItem(tourneyId)
	if self.signupedMatch_[tourneyId] ~= nil then
		self.signupedMatch_[tourneyId] = nil
	end
	tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
	if tourneyInfo ~= nil then
		tourneyInfo.status_ = MatchDefine.STATUS_SIGNUPABLE
	end
end

function SignupStatusManager:getSignupedItem(tourneyId)
	if self.signupedMatch_[tourneyId] ~= nil then
		return self.signupedMatch_[tourneyId]
	else
		return nil
	end
end

function SignupStatusManager:getSignupedItemList()
	return self.signupedMatch_
end

--得到距离目前时间最近的开赛的match信息
function SignupStatusManager:getNearestTimedItem()
	local nearItem = nil
	if self.signupedMatch_ ~= nil then
		for i, item in pairs(self.signupedMatch_) do
			if item.matchType_ ~= MatchDefine.MATCH_TYPE_FIXED then
				return item
			end
			if nearItem ~= nil then
				if item.matchType_ == MatchDefine.MATCH_TYPE_FIXED and item.startTime_ > 0 and nearItem.startTime_ > item.startTime_ then
					nearItem = self.signupedMatch_[i]
				end
			else
				if item.matchType_ == MatchDefine.MATCH_TYPE_FIXED and item.startTime_ > 0 then
					nearItem = item
				end
			end		
		end		
	end
	return nearItem
end

function SignupStatusManager:exitMatch(matchId)
	if self.startedMatch_[matchId] ~= nil then
		self:removeSignupedItem(self.startedMatch_[matchId].tourneyId_)		
		self:setExitMatchIdProductId(matchId, self.startedMatch_[matchId].productId_)
	end
	self:removeStartedItem(matchId)
end

return SignupStatusManager
