--[[
	管理比赛配置文件
]]
MatchConfigManager = {}
local TAG = "MatchConfigManager"

require("game.def.JJGameDefine")

local timeStamp_ = {} -- 各游戏 MatchConfig 的时间戳

--[[
	文件命名规则
	@读取时间戳: %PACKAGE_NAME%/res/config/matchs/%GAME_NAME%/timestamp.lua
	@写入时间戳: update/module/%PACKAGE_NAME%/res/config/matchs/%GAME_NAME%/timestamp.lua
	@读取比赛配置: %PACKAGE_NAME%/res/config/matchs/%GAME_NAME%/%PRODUCT_ID%_mc.lua
	@写入比赛配置: update/module/%PACKAGE_NAME%/res/config/matchs/%GAME_NAME%/%PRODUCT_ID%_mc.lua
]]
local FILE_TYPE_READ_TIMESTAMP = 1
local FILE_TYPE_WRITE_TIMESTAMP = 2
local FILE_TYPE_READ_MATCH_CONFIG = 3
local FILE_TYPE_WRITE_MATCH_CONFIG = 4
local FILE_TYPE_READ_MATCH_CONFIG_TEMP = 5 -- 读出来的数据
local FILE_NAME_TABLE = {}
FILE_NAME_TABLE[FILE_TYPE_READ_TIMESTAMP] = "%s/res/config/matchs/%s/timestamp.lua"
FILE_NAME_TABLE[FILE_TYPE_WRITE_TIMESTAMP] = "update/module/%s/res/config/matchs/%s/timestamp.lua"
FILE_NAME_TABLE[FILE_TYPE_READ_MATCH_CONFIG] = "%s/res/config/matchs/%s/%d_mc.lua"
FILE_NAME_TABLE[FILE_TYPE_WRITE_MATCH_CONFIG] = "update/module/%s/res/config/matchs/%s/%d_mc.lua"
FILE_NAME_TABLE[FILE_TYPE_READ_MATCH_CONFIG_TEMP] = "config.matchs.%s.%d_mc"

local function _getPackageNameAndGameName(gameId)
	gameId = tonumber(gameId)
	local gameName = JJGameDefine.GAME_DIR_TABLE[gameId]
	local packageName = gameName

	if gameId == JJGameDefine.GAME_ID_LORD or gameId == JJGameDefine.GAME_ID_LORD_HL or gameId == JJGameDefine.GAME_ID_LORD_LZ or gameId == JJGameDefine.GAME_ID_LORD_PK then
		packageName = JJGameDefine.GAME_DIR_TABLE[JJGameDefine.GAME_ID_LORD_UNION]
	end

	return packageName, gameName
end

--[[
	初始化时间戳
	@gameId: 游戏
]]
local function _initTimeStamp(gameId)
	local packageName, gameName = _getPackageNameAndGameName(gameId)
	local path = string.format(FILE_NAME_TABLE[FILE_TYPE_READ_TIMESTAMP], packageName, gameName)
	local timeStamp = LuaDataFile.get(path)
	if timeStamp ~= nil then
		timeStamp_[gameId] = timeStamp["id" .. gameId]
	else
		timeStamp_[gameId] = 0
	end
	JJLog.i(TAG, "_initTimeStamp, gameId=", gameId, ", lup=", timeStamp_[gameId])
end

--[[
	保存时间戳
	@gameId: 比赛
	@lup: 时间
]]
local function _saveTimeStamp(gameId, lup)
	JJLog.i(TAG, "_saveTimeStamp, gameId=", gameId, ", lup=", lup)
	gameId = tonumber(gameId)
	if timeStamp_[gameId] == nil or tonumber(timeStamp_[gameId]) < tonumber(lup) then
		timeStamp_[gameId] = lup

		local saveData = {}
		saveData["id" .. gameId] = lup
		local packageName, gameName = _getPackageNameAndGameName(gameId)
		local path = string.format(FILE_NAME_TABLE[FILE_TYPE_WRITE_TIMESTAMP], packageName, gameName)
		LuaDataFile.save(saveData, path)
	end
end

--[[
	获取该游戏的比赛配置时间戳
	@gameId: 
]]
function MatchConfigManager:getTimeStamp(gameId)
	gameId = tonumber(gameId)
	if timeStamp_[gameId] == nil then
		_initTimeStamp(gameId)
	end

	JJLog.i(TAG, "getTimeStamp, gameId=", gameId, ", lup=", timeStamp_[gameId])
	return timeStamp_[gameId]
end

--[[
	获取比赛配置
	@gameId: 游戏
	@productId: 比赛
]]
function MatchConfigManager:getMatchConfigItem(gameId, productId)
	local packageName, gameName = _getPackageNameAndGameName(gameId)
	local path = string.format(FILE_NAME_TABLE[FILE_TYPE_READ_MATCH_CONFIG], packageName, gameName, productId)
	return LuaDataFile.get(path)
end

-- 清空之前读出来的item文件
function MatchConfigManager:removeMatchConfigItem(gameId, productId)
	local packageName, gameName = _getPackageNameAndGameName(gameId)
	local tempPath = string.format(FILE_NAME_TABLE[FILE_TYPE_READ_MATCH_CONFIG_TEMP], gameName, productId) 
    package.loaded[tempPath] = nil	
end

--[[
	保存比赛配置
	@data: 配置数据
]]
function MatchConfigManager:saveMatchConfig(data)
	local gameId = tonumber(data.gameId)
	local productId = tonumber(data.productId)
	local packageName, gameName = _getPackageNameAndGameName(gameId)
	local path = string.format(FILE_NAME_TABLE[FILE_TYPE_WRITE_MATCH_CONFIG], packageName, gameName, productId)
	_saveTimeStamp(gameId, data.lastUpdate)
	if data.status ~= 1 then
		LuaDataFile.save(data, path)
	else

		-- TODO: 删除该比赛文件
	end
end

return MatchConfigManager