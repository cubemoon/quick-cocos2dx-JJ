--[[
	和比赛相关的控制器，管理比赛信息、更新逻辑等
]]
TourneyController = {}
local TAG = "TourneyController"

require("game.data.config.MatchConfigManager")
require("game.pb.TourneyMsg")
require("game.pb.HttpMsg")
require("game.data.lobby.MatchPointManager")

local DEBUG = false
local log = JJLog
local JJLog = {
    i = function(...)
        if DEBUG then
            log.i(...)
        end
    end,

    e = function(...)
        if DEBUG then
            log.e(...)
        end
    end
}

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local EntryFeeItem = require("game.data.model.EntryFeeItem")
local SignupRequireItem = require("game.data.tourney.SignupRequireItem")

local CHECK_TICK = 15 -- 15s 检查一次
local games_ = {} -- Key: gameId, value: lastUpdateTick

local TOURNEY_UPDATE_TICK = 180 -- 三分钟更新一次 TourneyList

local allTourney_ = {} -- Key: tourneyId, Value: tourneyInfo
local gameTourney_ = {} -- Key: gameId, Value: zoneTable, Key: zoneId, Value: tourneyId
local singupData_ = {}
local tourneyGameId = {} -- key: tourneyId, value :gameId
local matchGameId = {} -- key: matchId, value: gameId

local hasTourneyInfo_ = {} -- Key：gameId，value：bool 是否有该游戏的比赛数据
TourneyController.inPlayScene_ = false

--[[
	私有函数
]]
local function traceAllTourney()
	JJLog.i(TAG, "----AllTourney Start----")
	for tourneyId, tourneyInfo in pairs(allTourney_) do
        if tourneyInfo.matchconfig_ then
		  JJLog.i(TAG, tourneyId, tourneyInfo.matchconfig_.productName)
        end
	end
	JJLog.i(TAG, "----AllTourney End----")
end

--[[
    更新 TourneyInfo 内容
]]
local function _updateTourneyData(tourneyData, tourneyInfo)
	JJLog.i(TAG, "_updateTourneyData")
    if tourneyData ~= nil and tourneyInfo ~= nil then
        tourneyInfo.tourneyId_ = tourneyData.tourneyid
        tourneyInfo.matchStartTime_ = tourneyData.matchstarttime
        tourneyInfo.matchStartType_ = tourneyData.startmatchtype
        tourneyInfo.tourneyState_ = tourneyData.tourneystat
        if tourneyData.matchstarttime > 0 then
            DynamicTimeMatchManager:addMatchStartTime(tourneyData.tourneyid, tourneyData.matchstarttime)
        end
    end
end

--[[
    获取一个游戏所有的 TourneyInfo
]]
local function _getTourneyListByGameId(gameId)
	JJLog.i(TAG, "_getTourneyListByGameId, gameId=", gameId)
    local list = {}
	for tourneyId, tourneyInfo in pairs(allTourney_) do
		if tourneyInfo.gameId_ == gameId then
			list[tourneyId] = tourneyInfo
		end
	end
	-- JJLog.i(TAG, "----_getTourneyListByGameId Start----")
	-- for tourneyId, tourneyInfo in pairs(list) do
 --        if tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.productName then
	-- 	  JJLog.i(TAG, tourneyId, tourneyInfo.matchconfig_.productName)
 --        end
	-- end
	-- JJLog.i(TAG, "----_getTourneyListByGameId End----")
    return list
end

--[[
    和当前保存的 TourneyList 相比较，找出增加的比赛
]]
local function _getAddedTourneyList(new)
	JJLog.i(TAG, "_getAddedTourneyList")
    local addTourneyList = {}
	for i, tourneyData in pairs(new) do
		if allTourney_[tourneyData.tourneyid] == nil then
			table.insert(addTourneyList, tourneyData)
		end
	end
	-- JJLog.i(TAG, "---- _getAddedTourneyList Start----")
	-- for i,tourneyData in pairs(addTourneyList) do
	-- 	JJLog.i(TAG, tourneyData.tourneyid)
	-- end
	-- JJLog.i(TAG, "---- _getAddedTourneyList End----")
	return addTourneyList
end


--[[
    和当前保存的 TourneyList 相比较，找到删除的比赛
]]
local function _getDeletedTourneyList(gameId, new)
	JJLog.i(TAG, "_getDeletedTourneyList, gameId=", gameId)
    local delTourneyList = {}
    local newList = {}
    if new ~= nil then
	    for k,v in pairs(new) do
	    	newList[v.tourneyid] = v
	    end
   	end

    local old = _getTourneyListByGameId(gameId)
    if old ~= nil then
    	for i, tourneyInfo in pairs(old) do
    		if newList[i] == nil then
                table.insert(delTourneyList, tourneyInfo)
    		end
    	end
    end
    -- JJLog.i(TAG, "---- _getDeletedTourneyList Start----")
	-- for tourneyId, tourneyInfo in pairs(delTourneyList) do
 --        if tourneyInfo.matchconfig_ then        
	-- 	  JJLog.i(TAG, tourneyId, tourneyInfo.matchconfig_.productName)
 --        end
	-- end
	-- JJLog.i(TAG, "---- _getDeletedTourneyList End----")
    return delTourneyList
end

--[[
    删除需要删除的 TourneyInfo
]]
local function _delTourneyInfoFromList(gameId, list)
	JJLog.i(TAG, "_delTourneyInfoFromList, gameId=", gameId)
	local gameTourneyList = gameTourney_[gameId]
	for i, tourneyInfo in pairs(list) do
        for zoneId, zoneIdList in pairs(gameTourneyList) do
            for k, tourneyId in pairs(zoneIdList) do
                if tourneyId == tourneyInfo.tourneyId_ then
                    table.remove(zoneIdList, k)
                end             
            end
        end
        allTourney_[tourneyInfo.tourneyId_] = nil
    end
    -- traceAllTourney()
end

-- 找出moreCategory包含的赛区参数
local function _findCategory(str)
    local ids = {}
    if string.len(str) == 1 then
        table.insert(ids, str)        
        return ids
    end 
    local i = 0
    while true do
        i = string.find(str, "|", i+1)
        if i == nil then
            local category = string.sub(str, string.len(str))
            table.insert(ids, category)            
            break 
        end
        local category = string.sub(str, i-1, i-1)
        table.insert(ids, category)       
    end
    return ids     
end

local function _getCategory(matchConfig)
    local categoryIds = {}

    if matchConfig then
        if matchConfig.moreCategory and string.len(matchConfig.moreCategory) > 0  then
            categoryIds = _findCategory(matchConfig.moreCategory)
        elseif matchConfig.newCategoryId and string.len(matchConfig.newCategoryId) > 0 
              and tonumber(matchConfig.newCategoryId) ~= 0 then
              table.insert(categoryIds, matchConfig.newCategoryId)
        elseif matchConfig.categoryId then 
            table.insert(categoryIds, matchConfig.categoryId)
        end
    end

    return categoryIds
end

--[[
    增加 TourneyInfo 到数据中
]]
local function _addTourneyInfo(gameId, list)
	JJLog.i(TAG, "_addTourneyInfo, gameId=", gameId)
    local addedTourneyIdList = {}
    for i, tourneyData in pairs(list) do
        local productId = tourneyData.productid
        local tourneyId = tourneyData.tourneyid
        local matchConfig = MatchConfigManager:getMatchConfigItem(gameId, productId)
        if matchConfig ~= nil then
            local categoryIds = _getCategory(matchConfig)
            if gameTourney_[gameId] == nil then
                gameTourney_[gameId] = {}
            end

            for k, categoryId in pairs(categoryIds) do                
                if gameTourney_[gameId][categoryId] == nil then
                    gameTourney_[gameId][categoryId] = {}
                end
                table.insert(gameTourney_[gameId][categoryId], tourneyId)
            end 
        end
        local tourneyInfo = require("game.data.tourney.TourneyInfo").new()
        tourneyInfo.matchconfig_ = matchConfig
        tourneyInfo.tourneyId_ = tourneyId
        tourneyInfo.gameId_ = gameId
        tourneyInfo.productId_ = productId
        allTourney_[tourneyId] = tourneyInfo
        table.insert(addedTourneyIdList, tourneyId)
    end
    return addedTourneyIdList   
end

--[[
    更新游戏的所有 Toureny 相关数据
    @gameId:
]]
local function _updateGame(gameId)
    JJLog.i(TAG, "_updateGame, gameId=", gameId)
    games_[gameId] = JJTimeUtil:getCurrentSecond()
    TourneyMsg:sendGetTourneyListReq(gameId)
    TourneyMsg:sendGetMatchPointReq(gameId, nil)
    TourneyMsg:sendGetSignupDataListReq(gameId, nil)    
    TourneyMsg:sendGetTourneyPlayerAmountExReq(gameId)
    HttpMsg:sendGetMatchConfigReq(gameId, MatchConfigManager:getTimeStamp(gameId))
end

local function _updateMatchPoint(gameId)
    local tourneyList = MatchPointManager:getNeedUpdateTourney()    
    if tourneyList ~= nil and #tourneyList > 0 then              
        TourneyMsg:sendGetMatchPointReq(gameId, nil)
    end
end

--[[
    每帧回调
]]
local function _update(dt)
    JJLog.i(TAG, "_update")
    local top = JJSDK:getTopSceneController()
    if TourneyController.inPlayScene_ == false then
        local cur = JJTimeUtil:getCurrentSecond()

        local gameId = MainController:getCurGameId()
        if gameId == JJGameDefine.GAME_ID_LORD_UNION or gameId == JJGameDefine.GAME_ID_LORD_UNION_HL then 
            gameId = JJGameDefine.GAME_ID_LORD
        end
        gameId = tostring(gameId)

        local lastTick = games_[gameId] or 0        
        if (cur - lastTick) > TOURNEY_UPDATE_TICK then
            _updateGame(gameId)
        else
            _updateMatchPoint(gameId)
        end    
    end
end

-- 外部接口
--[[
    添加需要监听的游戏
    @gameId
]]
function TourneyController:addGame(gameId)
    JJLog.i(TAG, "addGame, gameId=", gameId)
    if games_ == nil or table.nums(games_) == 0 then
        games_ = {}
        scheduler.scheduleGlobal(_update, CHECK_TICK)
    end
    gameId = tostring(gameId)
    if games_[gameId] == nil then
        _updateGame(gameId)
    end
end

--[[
    删除需要监听的游戏
    @gameId
]]
function TourneyController:delGame(gameId)
    JJLog.i(TAG, "delGame, gameId=", gameId)
    gameId = tostring(gameId)
    games_[gameId] = nil
end

--[[
    是否存在该游戏的比赛信息
]]
function TourneyController:hasTourneyInfo(gameId)
    JJLog.i(TAG, "hasTourneyInfo, gameId=", gameId)
    gameId = tostring(gameId)
    return hasTourneyInfo_[gameId]
end

--[[
    取比赛列表
]]
function TourneyController:updateGame(gameId)
    gameId = tostring(gameId)
    _updateGame(gameId)
end

--[[
    收到 TourenyList 的消息，内容处理
    @gameId:
    @tourneyList: 网络数据
]]
function TourneyController:setTourneys(gameId, tourneyList)
	JJLog.i(TAG, "setTourneys, gameId=", gameId)
    if #tourneyList == 0 then
        return
    end
    for i, tourneyData in pairs(tourneyList) do
        tourneyGameId[tourneyData.tourneyid] = gameId
    end
    gameId = tostring(gameId)

    local bFirst = true
    local gameTourneys = gameTourney_[gameId]
    if gameTourneys ~= nil then
        bFirst = false
    end
	-- 1 查找添加和删除的列表
	-- 找到需要增加的比赛
    local needAddList = _getAddedTourneyList(tourneyList)
    -- 2. 将新增的比赛添加到 tourneyList 中
    local addedList = _addTourneyInfo(gameId, needAddList) 
	-- 找到需要删除的比赛
    local needDelList = _getDeletedTourneyList(gameId, tourneyList)
    -- 3. 去掉应该删除的
    _delTourneyInfoFromList(gameId, needDelList)
    -- 4. 更新新数据
    for i,tourneyData in pairs(tourneyList) do
    	local tourneyInfo = self:getTourneyInfoByTourneyId(tourneyData.tourneyid)
    	if tourneyInfo ~= nil then
    		_updateTourneyData(tourneyData, tourneyInfo)
    	end
    end
    if bFirst == false and (needAddList ~= nil and table.nums(needAddList) > 0 ) or(needDelList ~= nil and table.nums(needDelList) > 0) then
        local exmsg = require("game.message.TourneyChangeMsg").new()
        JJSDK:pushMsgToSceneController(exmsg)        
    end
end

--[[
    保存报名条件
]]
function TourneyController:setSignupData(data)
	JJLog.i(TAG, "setSignupData")
	for i, signupData in pairs(data) do
		local tourneyInfo = self:getTourneyInfoByTourneyId(signupData.tourneyid)
		if tourneyInfo ~= nil then
			tourneyInfo.signupData_ = signupData
		end
	end
end

--[[
    保存 MatchPoint
]]
function TourneyController:setMatchPoint(gameId, data)
	JJLog.i(TAG, "setMatchPoint")
    MatchPointManager:addMatchPointList(data, gameId)
	for i, matchpoint in pairs(data) do
		local tourneyInfo = self:getTourneyInfoByTourneyId(matchpoint.tourneyid)
		if tourneyInfo ~= nil then
			tourneyInfo.matchpoint_ = matchpoint.matchpointlist
		end
	end
end

--[[
    保存人数：人数消息是Tourney消息序列中的最后一条，在这条里面通知界面进行更新
]]
function TourneyController:setPlayerAmount(gameId, data)
	JJLog.i(TAG, "setPlayerAmount, gameId=", gameId)
    gameId = tostring(gameId)
    hasTourneyInfo_[gameId] = true        

	for i, playeramount in pairs(data) do
	    local tourneyInfo = self:getTourneyInfoByTourneyId(playeramount.tourneyid)
		if tourneyInfo ~= nil then
			tourneyInfo.playingAmount_ = playeramount.playingamount
			tourneyInfo.runAmount_ = playeramount.runamount
			tourneyInfo.signupAmount_ = playeramount.signupamount
		end
	end
end

--[[
    获取游戏中某个赛区的所有比赛信息
]]
function TourneyController:getTourneyListByZoneId(gameId, zoneId)
	JJLog.i(TAG, "getTourneyListByZoneId, gameId=", gameId, ", zoneId=", zoneId)
	gameId = tostring(gameId)
	zoneId = tostring(zoneId)
    local tourneyInfoList = {}
    local gameTourneyList = gameTourney_[gameId]
    if gameTourneyList ~= nil then
       	local  tourneyIdList = gameTourneyList[zoneId]
       	if tourneyIdList ~= nil then
	        for i, tourneyId in pairs(tourneyIdList) do
	            local tourneyInfo = allTourney_[tourneyId]
	            -- 如果正在报名中，不修改状态
	            if tourneyInfo.status_ ~= MatchDefine.STATUS_SIGNUPING then
	                self:checkSignupReqirement(tourneyInfo)
	                -- 检查报名条件会修改tourneyInfo的状态，如果用户已经报名，重置为可退赛状态
	                if SignupStatusManager:getSignupedItem(tourneyInfo.tourneyId_) ~= nil then
	                    tourneyInfo.status_ = MatchDefine.STATUS_SIGNOUTABLE
	                end
	            end
                -- if tourneyInfo:getSignupTime() <= JJTimeUtil:getCurrentSecond() and tourneyInfo.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
                -- else
	            	table.insert(tourneyInfoList, tourneyInfo)
                -- end
	        end
	    end
    end
    -- 相同productid 的比赛，按照开赛时间排序,其它的按序号排序
    function _sortTourneyList(a, b)
            if a.matchconfig_ and b.matchconfig_ and a.matchconfig_.productId ~= b.matchconfig_.productId then
                return (tonumber(a.matchconfig_.serial) < tonumber(b.matchconfig_.serial))
            else
                return (a:getSignupTime(0) < b:getSignupTime(0))                
            end        
    end
    table.sort(tourneyInfoList, _sortTourneyList)
    return tourneyInfoList;
end

--[[
    获取比赛信息
]]
function TourneyController:getTourneyInfoByTourneyId(tourneyId)
    return allTourney_[tourneyId]
end

--[[
    获取同一个 ProductId 所有的 TourneyInfo
]]
function TourneyController:getTourneyInfoListByProductId(productId)
	JJLog.i(TAG, "getTourneyInfoListByProductId, productId=", productId)
    local tourneyInfoList = {}
    for k, tourneyInfo in pairs(allTourney_) do
        if tonumber(tourneyInfo.productId_) == tonumber(productId) or (tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.productId == productId) then
            table.insert(tourneyInfoList, tourneyInfo)
        end
    end
    return tourneyInfoList
end

--[[
    取得 ProductId 列表对应的 TourneyInfo 列表
]]
function TourneyController:getTourneyInfoListByProductIdList(productIdList)
	JJLog.i(TAG, "getTourneyInfoListByProductIdList")
	local tourneyInfoList = {}
	if productIdList ~= nil then
		for i, productId in pairs(productIdList) do
			local tourneyList = self:getTourneyInfoListByProductId(productId)
			for k, tourneyInfo in pairs(tourneyList) do
				table.insert(tourneyInfoList, tourneyInfo)
			end
		end
	end
    return tourneyInfoList
end

-- MatchConfig 更新了，刷新 TourneyInfo 的数据
function TourneyController:modifyTourneyInfoList(gameId, productId)
    MatchConfigManager:removeMatchConfigItem(gameId, productId)  
    local matchconfig = MatchConfigManager:getMatchConfigItem(gameId, productId)
    if matchconfig ~= nil then
        local tourneyInfoList = self:getTourneyInfoListByProductId(productId)
        for k, tourneyInfo in pairs(tourneyInfoList) do
            tourneyInfo.matchconfig_ = matchconfig
            allTourney_[tourneyInfo.tourneyId_].matchconfig_ = matchconfig

            local categoryIds = _getCategory(matchconfig)
            if gameTourney_[gameId] == nil then
                gameTourney_[gameId] = {}
            end

            for k, categoryId in pairs(categoryIds) do                
                if gameTourney_[gameId][categoryId] == nil then
                    gameTourney_[gameId][categoryId] = {}
                    table.insert(gameTourney_[gameId][categoryId], tourneyInfo.tourneyId_)
                else
                    for k, v in pairs(gameTourney_[gameId][categoryId]) do
                        if v == tourneyInfo.tourneyId_ then
                            table.remove(gameTourney_[gameId][categoryId], k)
                            break
                        end
                    end                    
                    table.insert(gameTourney_[gameId][categoryId], tourneyInfo.tourneyId_)                                        
                end
            end
        end
    end
end

--[[
    检查比赛报名条件
    @tourneyInfo: 这个比赛的 Tourney 信息
]]
function TourneyController:checkSignupReqirement(tourneyInfo)
    JJLog.i(TAG, "checkSignupReqirement")
    if tourneyInfo == nil or tourneyInfo.signupData_ == nil then
    	return
    end

    tourneyInfo:clearEntryFee()
    tourneyInfo.status_ = MatchDefine.STATUS_WAITING_DATA
    local signupData = tourneyInfo.signupData_
    local signupRequireItemList = {} -- 报名所需物品、成就的说明
    local growSignable = true -- 成就要求是否满足
    local wareSignable = true -- 物品要求是否满足
    
    -- 检查用户grow是否符合报名条件(经验是否满足)
    if signupData.growlist ~= nil and #signupData.growlist > 0 then 
        for i, growReq in pairs(signupData.growlist) do 
            local growId = growReq.growid
            local userGrowValue = UserInfo:getGrowCount(growId)
            if (userGrowValue == 0 and growReq.minvalue > 0) or (userGrowValue ~= 0 and userGrowValue < growReq.minvalue) or (userGrowValue ~= 0 and userGrowValue > growReq.maxvalue) then
                growSignable = false
                tourneyInfo.status_ = MatchDefine.STATUS_OUT_OF_REQUIREMENT
                local growName = GrowInfoManager:getGrowName(growId)
                local str = string.format("\"")
                if growName == nil then
                    str = str.." \""
                else
                    str = str..growName.."\""
                end
                if userGrowValue == 0 or userGrowValue < growReq.minvalue then
                    str = str.."大于"..growReq.minvalue
                elseif userGrowValue > growReq.maxvalue then
                    str = str.."小于"..growReq.maxvalue
                else
                    str = str.."大于0"
                end
                if tourneyInfo.signupData_ ~= nil and tourneyInfo.signupData_.signupnotecondition ~= nil then
                    str = tourneyInfo.signupData_.signupnotecondition
                end
                local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_GROW, growId, growName, userGrowValue, growReq.minvalue, growReq.maxvalue, str)
                table.insert(signupRequireItemList, requireItem)
            end
        end
    end
    
    -- 检查用户ware是否符合报名条件（比如是否有高手证,非报名费用）
    if signupData.warelist ~= nil and #signupData.warelist > 0 then
        for i, wareReq in pairs(signupData.warelist) do
            local wareId = wareReq.waretypeid
            local userWareValue = UserInfo:getWareCount(wareId)
            if (userWareValue == 0 and wareReq.minvalue > 0) or (userWareValue ~= 0 and userWareValue < wareReq.minvalue) or (userWareValue ~= 0 and userWareValue > wareReq.maxvalue) then
                wareSignable = false
                tourneyInfo.status_ = MatchDefine.STATUS_OUT_OF_REQUIREMENT
                local wareName = WareInfoManager:getWareName(wareId)
                local str = "\""
                if #wareName == 0 then
                    str = str.." \""
                else
                    str = str..wareName.."\""
                end
                if userWareValue < wareReq.minvalue then 
                    str = str.."大于"..wareReq.minvalue
                elseif userWareValue> wareReq.maxvalue then
                    str = str.."小于"..wareReq.maxvalue
                else
                    str = str.."大于0"           
                end
               	local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_WARE, wareId, wareName, userWareValue, wareReq.minvalue, wareReq.maxvalue, str)
                table.insert(signupRequireItemList, requireItem)                   
            end
        end
    end

	-- 检查报名消耗

	if signupData.matchsignuplist ~= nil and #signupData.matchsignuplist > 0 then
        for i, signupItem in pairs(signupData.matchsignuplist) do
            local entryFeeItem = EntryFeeItem.new()
            entryFeeItem.note_ = signupItem.signupnote
            entryFeeItem.type_ = signupItem.signuptype
            local str = ""
            local goldReq = false
            if signupItem.gold > 0 then
                entryFeeItem.goldReq_ = true
            else
                entryFeeItem.goldReq_ = false
            end
            if signupItem.gold > 0 and UserInfo.gold_ < signupItem.gold then
                str = "金币数量大于" .. signupItem.gold
                entryFeeItem.reason_ = str
                entryFeeItem.useable_ = false
                goldReq = true
                local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_GOLD, 0, "金币", UserInfo.gold_, signupItem.gold, signupItem.gold, str)
                table.insert(signupRequireItemList, requireItem)
            end

            if entryFeeItem.useable_ and signupItem.cert > 0 and UserInfo.cert_ < signupItem.cert then
                str = "参赛积分大于" .. signupItem.cert
                entryFeeItem.reason_ = str
                entryFeeItem.useable_ = false
                local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_CERT, 1, "参赛积分", UserInfo.cert_, signupItem.cert, signupItem.cert, str)
                table.insert(signupRequireItemList, requireItem)                
            end

            if entryFeeItem.useable_ and #signupItem.growlist > 0 then
                for i, growReq in pairs(signupItem.growlist) do
                    local growId = growReq.growid
                    local userGrowCount = UserInfo:getGrowCount(growId)
                    if growReq.growcount > userGrowCount then
                        local growName = GrowInfoManager:getGrowName(growId)
                        str = "\"" .. growName .. "\"数量大于" .. growReq.growcount
                        entryFeeItem.reason_ = str
                        entryFeeItem.useable_ = false
                        local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_GROW, growId, growName, userGrowCount, growReq.growcount, growReq.growcount, str)
                        table.insert(signupRequireItemList, requireItem)
                    end
                end
            end

            if entryFeeItem.useable_ and #signupItem.warelist > 0 then
                for i, wareReq in pairs(signupItem.warelist) do
                    local wareId = wareReq.waretypeid
                    local userWareCount = UserInfo:getWareCount(wareId)
                    if wareReq.warecount > userWareCount then
                        local wareName = WareInfoManager:getWareName(wareId)
                        str = "\"" .. wareName .. "\"数量大于" .. wareReq.warecount
                        entryFeeItem.reason_ = str
                        entryFeeItem.useable_ = false
                        local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_WARE, wareId, wareName, userWareCount, wareReq.warecount, wareReq.warecount, str)
                        table.insert(signupRequireItemList, requireItem) 
                    end
                end
            end

            if growSignable and wareSignable and entryFeeItem.useable_ then
                tourneyInfo.status_ = MatchDefine.STATUS_SIGNUPABLE
            elseif tourneyInfo.status_ == STATUS_WAITING_DATA then
                tourneyInfo.status_ = MatchDefine.STATUS_OUT_OF_REQUIREMENT
            end

            if goldReq then
                tourneyInfo:addEntryFee(entryFeeItem, 1)
            else
                tourneyInfo:addEntryFee(entryFeeItem)
            end
        end
    else
        local entryFeeItem = EntryFeeItem.new("免费", 0, true, "", false)

            --对于没有报名条件的比赛，如果后台配置了显示，按照后台的显示（用于德州散桌赛）
            local signupFee = tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.exes
            if signupFee and string.len(signupFee) > 0 then
                entryFeeItem.note_ = tourneyInfo.matchconfig_.exes
                local index = string.find(signupFee, "金币")
                if index ~= nil then

                    local needGold = tonumber(string.sub(signupFee, 1, index-1))
                    entryFeeItem.goldReq_ = true
                    if needGold > 0 and UserInfo.gold_ < needGold then
                        str = "金币数量大于" .. needGold
                        entryFeeItem.reason_ = str
                        entryFeeItem.useable_ = false
                        goldReq = true
                        local requireItem = SignupRequireItem.new(MatchDefine.SIGNUPCOST_TYPE_GOLD, 0, "金币", UserInfo.gold_, needGold, needGold, str)
                        table.insert(signupRequireItemList, requireItem)
                    end                    

                end
            end
            if growSignable and wareSignable and entryFeeItem.useable_ then
                tourneyInfo.status_ = MatchDefine.STATUS_SIGNUPABLE
            elseif tourneyInfo.status_ == STATUS_WAITING_DATA then
                tourneyInfo.status_ = MatchDefine.STATUS_OUT_OF_REQUIREMENT
            end
        tourneyInfo:addEntryFee(entryFeeItem)
	end
    tourneyInfo:setSignupRequireItemList(signupRequireItemList)
end

function TourneyController:testTourney()

    -- local tourneyInfo = self:getTourneyInfoByTourneyId(1051211)
    -- if tourneyInfo ~= nil then
    --     self:checkSignupReqirement(tourneyInfo)
    -- end

    -- for i=1,3 do
    --     local list = TourneyController:getTourneyListByZoneId(1009, i)
    --     for k, tourneyInfo in pairs(list) do
    --         print("---" .. tourneyInfo.matchconfig_.productName .. "--- START ---")
    --         print("报名点：" .. tourneyInfo:getSignupTime())
    --         print("开赛点：" .. tourneyInfo:getStartTimeString())
    --         print("人数：" .. tourneyInfo:getPlayerAmount())
    --         print("---" .. tourneyInfo.matchconfig_.productName .. "--- END ---")
    --     end
    -- end
end

-- 根据tourneyid得到gameid
function TourneyController:getGameIdByTourneyId(tourneyId)
    local gameId = 0
    if tourneyGameId ~= nil then
        gameId = tourneyGameId[tourneyId]
    end
    if gameId == nil or gameId == 0 then
        gameId = JJGameDefine.GAME_ID_LORD
    end
    return gameId
end

-- 将相应的matchid加到gameid中
function TourneyController:addMatchIdToGameId(matchId, gameId)
    if matchGameId ~= nil then
        matchGameId[matchId] = gameId
    end
end

-- 根据matchid得到gameid
function TourneyController:getGameIdByMatchId(matchId)
    local gameId = 0
    if matchGameId ~= nil then
        gameId = matchGameId[tourneyId]
    end
    if gameId == nil or gameId == 0 then
        gameId = JJGameDefine.GAME_ID_LORD
    end
    return gameId
end

return TourneyController
