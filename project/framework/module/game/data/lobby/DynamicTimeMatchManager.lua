-- 管理定时赛每个tourneyid 对应的开赛时间  
--有 MatchPoint 的比赛，不用这个值，没有 MatchPoint 的比赛才用这个值（比如：每天开一场的比赛，一般就是这个值)

DynamicTimeMatchManager = {
	matchStartTimes_ = {}
	-- matchStarttimes_  某个tourneyId对应的开赛点
}

--存储某个tourneyid 对应的开赛点
function DynamicTimeMatchManager:addMatchStartTime(tourneyId, startTime)
	self.matchStartTimes_[tourneyId] = startTime
end

--获得某个tourneyid 对应的开赛点
function DynamicTimeMatchManager:getMatchStartTime(tourneyId)
	local value = 0
	if self.matchStartTimes_[tourneyId] ~= nil then		
		value = self.matchStartTimes_[tourneyId]
	end
	return value
end

--获得某个tourneyid 对应的开赛点
function DynamicTimeMatchManager:getLastStartTourneyID()
	local arrlist = {}
	local tourneyList = {}
	for tourneyId, value in pairs(self.matchStartTimes_) do
		local matchPoint = MatchPointManager:getLastMatchPoint(tourneyId)
		if matchPoint ~= nil then
			table.insert(tourneyList, tourneyId)
		elseif value <= JJTimeUtil:getCurrentSecond() then
			table.insert(arrlist, tourneyId)
			break
		end
	end
	for k,v in pairs(tourneyList) do
		table.remove(self.matchStartTimes_, k)  --- test for 
	end
	return arrlist
end

return DynamicTimeMatchManager