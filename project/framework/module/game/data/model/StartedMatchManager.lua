-- matchdata 管理文件
StartedMatchManager = {
	matchMap_ = {}, 	-- match 对应的matchdata  {key = matchid,value = matchdata}
    newMatchStartTimeStamp_ = 0,
    newMatchParam_
}

local TAG = "StartedMatchManager"

function StartedMatchManager:addMatch(matchData)
	if matchData == nil then
		return 
	end
	JJLog.i(TAG, "addMatch, matchId=", matchData.matchId_)
	self.matchMap_[matchData.matchId_] = matchData
end

function StartedMatchManager:getMatch(matchId)
	if self.matchMap_[matchId] ~= nil then
		return self.matchMap_[matchId]
	else
		return nil
	end
end

function StartedMatchManager:getMatchCount()
	local count = 0
	for k,v in pairs(self.matchMap_) do
		count = count + 1
	end
	JJLog.i(TAG, "getMatchCount, count=", count)
	return count
end

function StartedMatchManager:removeMatch(matchId)
	JJLog.i(TAG, "removeMatch, matchId=", matchId)
	if self.matchMap_[matchId] ~= nil then
		self.matchMap_[matchId] = nil
	end
end

function StartedMatchManager:removeAllMatchs()
	JJLog.i(TAG, "removeAllMatchs")
	self.matchMap_ = {}
end

function StartedMatchManager:existsMatch(tourneyId)
	local existsMatch = false
	for k, matchData in pairs(self.matchMap_) do
		--tourneyId相同表示是“再来一局”
		if matchData.tourneyId_ ~= tourneyId then
			existsMatch = true
			break
		end
	end
	JJLog.i("TAG","existsMatch,",existsMatch)
	return existsMatch
end

return StartedMatchManager