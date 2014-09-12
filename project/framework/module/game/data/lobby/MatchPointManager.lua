-- 比赛开赛点信息管理文件

MatchPointManager = {curMatchPoint_ = {}, allMatchPoints_  = {}}
-- curMatchPoint_  某个Tourney当前显示的开赛点 {tourneyId = matchPoint(proto中matchpoint)}
-- allMatchPoint_  某个Tourney所有的开赛点 {tourneyId = {matchPoints(proto中matchpoint)}}

local TAG = "MatchPointManager"
function MatchPointManager:ctor()
	-- self.curMatchPoint = {}
	-- self.allMatchPoint = {}
end

--判断tourneyId是否有matchpoint消息
function MatchPointManager:containMatch(tourneyId)
	if self.allMatchPoints_[tourneyId] ~= nil then
		return true		
	else 
		return false
	end	
end

--添加matchpointlist消息
function MatchPointManager:addMatchPointList(tourneyMatchPointList, gameId)
	JJLog.i(TAG, "addMatchPointList")
	if tourneyMatchPointList ~= nil and #tourneyMatchPointList > 0 then
		for i = 1, #tourneyMatchPointList do
			self:addMatchPointListForTourneyId(tourneyMatchPointList[i].tourneyid,tourneyMatchPointList[i].matchpointlist,gameId)
		end
	end
end

--添加matchpoint消息，和tourneyid绑定
function MatchPointManager:addMatchPointListForTourneyId(tourneyId, matchPointList, gameId)
	local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
	if tourneyInfo ~= nil and matchPointList ~= nil then
		local totalPlayer = self:getTotalPlayers(matchPointList)
		tourneyInfo.playingAmount_ = totalPlayer
		tourneyInfo.runAmount_ = totalPlayer
		tourneyInfo.signupAmount_ = totalPlayer
		local signupingMatchPointList = {}
		for i = 1, #matchPointList do 
			if matchPointList[i].state == MatchDefine.TOURNEYSIGNUPING then
				table.insert(signupingMatchPointList, matchPointList[i])
			end
		end
		self.allMatchPoints_[tourneyId] = signupingMatchPointList
		-- 检查MatchPoint中已取消的比赛，假如用户已经报名，在已报名里表中删除
		local signupItem = SignupStatusManager:getSignupedItem(tourneyId)
		if signupItem ~= nil then
			for i = 1, #matchPointList do
				if matchPointList[i].matchpoint == signupItem.startTime_ then
					if matchPointList[i].state ~= MatchDefine.TOURNEYSIGNUPING and matchPointList[i].state ~= MatchDefine.TOURNEYSTARTUPING then
						SignupStatusManager:removeSignupedItem(tourneyId)			
					end
					break
				end
			end
		end
	else

	end
end

--获取此tourneyid某开赛点的matchpoint信息
function MatchPointManager:getMatchPoint(tourneyId, matchPoint)
	if self.allMatchPoints_ ~= nil then
		local items = self.allMatchPoints_[tourneyId]
		if items ~= nil then
			for i = 1, #items do
				if items[i].matchpoint == matchPoint then
					return items[i]
				end
			end
		else 
			return nil
		end
	end		
end

--获取某tourenyid 有效开赛点对应的matchpoint信息
function MatchPointManager:getLastMatchPoint(tourneyId)
	if #self.allMatchPoints_ ~= nil then
		local items = self.allMatchPoints_[tourneyId]
		if items ~= nil then
			for k, item in pairs(items) do
				if item.state == MatchDefine.TOURNEYSIGNUPING and item.matchpoint > JJTimeUtil:getCurrentSecond() then
					self.curMatchPoint_[tourneyId] = item
					return item
				end	
			end
		else
			return nil
		end
	end
	return nil
end

--获取tourenyid 参赛人数
function MatchPointManager:getTotalPlayersForTourneyId(tourneyId)
	if #self.allMatchPoints_ ~= 0 then
		local matchPointList = self.allMatchPoints_[tourneyId]
		self:getTotalPlayers(matchPointList)
	end
end

function MatchPointManager:getTotalPlayers(matchPointList)
	local count  = 0
	if matchPointList ~= nil and #matchPointList ~= 0 then
		for i = 1, #matchPointList do
		count = count + math.max(matchPointList[i].runamount, matchPointList[i].playingamount, matchPointList[i].signupamount)
		end
	end
	JJLog.i(TAG, "getTotalPlayers = "..count)
	return count
end

--获取最近的开赛点matchpoint 信息
function MatchPointManager:getCurMatchPoint(tourneyId)
	if self.curMatchPoint_ ~= nil then
		if self.curMatchPoint_[tourneyId] ~= nil then
			return self.curMatchPoint_[tourneyId]
		end
	end
	return nil
end

function MatchPointManager:notifyViewUpdate(tourneyId)

end

--获取需要更新matchpoint的tourneyids
function MatchPointManager:getNeedUpdateTourney()
	local arrlist = {}
	if self.allMatchPoints_ ~= nil then
		time = JJTimeUtil:getCurrentSecond()
		for tourneyId, matchPoints in pairs(self.allMatchPoints_) do
			if #matchPoints > 0 then
				if matchPoints[1].matchpoint < time then
					table.insert(arrlist,tourneyId)
				end
			end
		end
	end
	return arrlist
end

return MatchPointManager