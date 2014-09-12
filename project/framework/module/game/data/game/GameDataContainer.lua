-- 游戏数据管理器

GameDataContainer = {
	gameDataMap_ = {} -- key = matchid, value = gamedata
}

function GameDataContainer:addGameData(matchId, gameData)
	self.gameDataMap_[matchId] = gameData
end

function GameDataContainer:getGameData(matchId)
	return self.gameDataMap_[matchId]
end

function GameDataContainer:removeGameData(matchId)
	if self.gameDataMap_[matchId] ~= nil then
		self.gameDataMap_[matchId] = nil
	end	
end

return GameDataContainer