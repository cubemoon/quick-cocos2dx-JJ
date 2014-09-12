local GameItemController = {}

local TAG = "GameItemController"

local GameItems = {}

local FolderItems = {}

-- 更新游戏节点配置文件
function GameItemController:refreshGameItems(callback, times)
    local uptime = CCUserDefault:sharedUserDefault():getStringForKey("game_uptime", "0")
    local util = require("upgrade.util.UpgradeUtil")
    local serverConfig = util:getServerConfig()
    local isPack = 0
    if RUNNING_MODE == RUNNING_MODE_GAME then
        isPack = 1
    end
    local checkUrl =  string.format("%s?platform=%s&promoterid=%s&uptime=%s&screen=%s&net=%s&new=%d&imei=%s&isPack=%d&fromID=%d&cur_ver=%s",
        serverConfig.game_node_url,
        --device.platform,
        -- TODO 暂时固定android平台
        "android",
        PROMOTER_ID,
        uptime,
        util:getScreenSize(),
        util:getNetworkName(),
        1,
        util:getIMEI(),
        isPack,
        ORIGINAL_PACKAGE_ID,
        util:getClientVersion()
        )
    print(TAG, " refreshGameItems checkUrl : ", checkUrl)
    local request = network.createHTTPRequest(function (event)
        local success = (event.name == "completed")
        local req = event.request
        local errCode = req:getErrorCode()
        if not success then
            if toint(times) < 2 then
                os.execute("sleep " .. 1)
                print(TAG, "retry to refreshGameItems for times : ", toint(times))
                self:refreshGameItems(callback, toint(times) + 1)
            else
                self:_recordRefreshError({ curl_code = errCode })
                callback(false)
            end
            req:release()
            return
        end
        -- 返回状态值不等于200
        local req = event.request
        local code = req:getResponseStatusCode()
        if code ~= 200 then
            self:_recordRefreshError({ response_code = code })
            callback(false)
            req:release()
            return
        end
        -- local responseTable = json.decode(req:getResponseString()) or {}
        local responseHead = req:getResponseHeadersString()
        print("response head : ", responseHead)
        local responseTable = nil
        -- 根据返回数据的head是否包含gzip来判断是否解压数据
        if string.find(responseHead, "gzip") ~= nil then
            responseTable = json.decode(req:getDecompressDataLua()) or {}
        else
            responseTable = json.decode(req:getResponseString()) or {}
        end

        local resultFlag = 0
        local datas = responseTable.datas
        dump(datas, "game items")
        if not datas or #datas == 0 then
            print(TAG, "responseTable datas is nil")
            callback(false)
            return
        end
        for i = 1, #datas do
            local data = vardump(datas[i], "GameItem" .. tostring(datas[i].id))
            local fileName = string.format("update/module/game/res/config/gameitems/GameItem%s.json", datas[i].id)
            local preNode = util:getJson(fileName)
            if preNode ~= nil and preNode.icon ~= datas[i].icon then
                local pkgId = datas[i].package_id or "0"
                local delPath = string.format("%supdate/module/hall/res/img/hall/lobby/%s.png", device.writablePath, pkgId)
                os.remove(delPath)
            end
            if not util:saveJson(datas[i], fileName) then
                resultFlag = 1
            end
        end
        if resultFlag == 0 then
            CCUserDefault:sharedUserDefault():setStringForKey("game_uptime", responseTable.uptime)
            CCUserDefault:sharedUserDefault():flush()
            callback(true)
        else
            self:_recordRefreshError({ comment = "write json fail" })
            callback(false)
        end
        req:release()
    end, checkUrl, "POST")
    local versions = {}
    if RUNNING_MODE == RUNNING_MODE_GAME then
        local pkgName = tostring(PROJECT_NAME)
        if util:exist(pkgName .. "/config.lua") then
            versions[tostring(CURRENT_PACKAGE_ID)] = require(pkgName .. ".config").version_
        end
    else
        self:getGameItemVersions("1", versions)
    end
    request:addPOSTValue("versions", json.encode(versions))
    print(TAG, "versions : ", json.encode(versions))
    request:setTimeout(40)
    if util:isWap() then
        util:setWapProxy(request)
    end
    if require("upgrade.util.UpgradeUtil"):supportFunction("getDecompressDataLua") and type(request.getDecompressDataLua) == "function" then
        request:addRequestHeader("Accept-Encoding:gzip;")
    end
    request:start()
end

function GameItemController:initClassify(rootId)
    GameItems = {}
    local root = self:getNodeJson(rootId)
    if root ~= nil and root.status == "0" and root.childrenNodes ~= nil then
        local classifies = string.split(root.childrenNodes, ",")
        for i=1,#classifies do
            local classify = self:getNodeJson(classifies[i]) or {}
            if classify.childrenNodes ~= nil then
                local children = string.split(classify.childrenNodes, ",")
                for i=1,#children do
                   self:initGameItems(children[i])
                end
            end
            -- TODO 目前只获取分类一的数据
            return
        end
    end
end

function GameItemController:initGameItems(nodeId)
    local item = self:getNodeJson(nodeId)
    if  item ~= nil and item.status == "0" and item.icon_display == 0 then
        if item.childrenNodes ~= nil then
            local children = string.split(item.childrenNodes, ",")
            local childrenData = {}
            for i=1,#children do
                local child = self:getNodeJson(children[i])
                table.insert(childrenData, child)
            end
            item.childrenData = childrenData
            table.insert(FolderItems, item)
        end
        self:insertGameItems(item)
    end
end

function GameItemController:getGameItemVersions(nodeId, versions)
    local util = require("upgrade.util.UpgradeUtil")
    local node = self:getNodeJson(nodeId) or {}
    local pkgName = node.packagename or ""
    local ver = 0
    if node.lua == "1" then
        if util:exist(pkgName .. "/config.lua") then
            ver = require(pkgName .. ".config").version_
        end
    else
        ver = tonum(self:getPackageVersion(pkgName))
    end
    if node.status == "0" then
        versions[node.package_id] = ver
    end
    if node.childrenNodes ~= nil then
        local children = string.split(node.childrenNodes, ",")
        for i=1,#children do
            self:getGameItemVersions(children[i], versions)
        end
    end
end

function GameItemController:gameExist(isLua, packageName)
    if packageName == nil then return false end
    local result, exist = false, false
    if tonum(isLua) == 1 then
        local fileUtil = require("upgrade.util.UpgradeUtil")
        exist = fileUtil:exist(packageName .. "/config.lua")
    else
        local className, methodName, args, sig
        if device.platform == "android" then
            className = "cn/jj/base/JJUtil"
            methodName = "gameExist"
            args = {packageName}
            sig = "(Ljava/lang/String;)Z"
            result, exist = luaj.callStaticMethod(className, methodName, args, sig)
        end
    end
    return exist
end

-- function GameItemController:luaGameExist(gameId)
--     local pkgId = gameId
--     -- TODO 判断所传的gameId是否存在斗地主合集中
--     local lordunions = { 1001, 1010, 1019, 1035, 600001 }
--     for i=1,5 do
--         if gameId == lordunions[i] then
--             pkgId = 2
--         end
--     end
--     local packageName = tostring(JJGameDefine.GAME_DIR_TABLE[pkgId])
--     local fileUtil = require("upgrade.util.UpgradeUtil")
--     local exist = fileUtil:exist(packageName .. "/config.lua")
--     return exist
-- end

function GameItemController:getPackageVersion(packageName)
    packageName = packageName or ""
	local result, version = false, "1000"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getPackageVersion"
		args = {packageName}
		sig = "(Ljava/lang/String;)I"
		result, version = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return version
end

function GameItemController:setInstallEnable(enable)
    self.installEnable_ = enable
end

function GameItemController:insertGameItems(item)
    table.insert(GameItems, item)
end

function GameItemController:getGameItems()
   return GameItems
end

function GameItemController:getFolderItems()
    return FolderItems
end

function GameItemController:getInstalledGames()
    local items = self:getGameItems()
    local installList = {}
    for i=1,#items do
        local item = items[i]
        local data = {}
        data.name = item.packagename
        if self:gameExist(item.lua, item.packagename) then
            self:insertInstalledGames(item, installList)
        end
        if item.childrenData ~= nil then
            for i=1,#item.childrenData do
                local child = item.childrenData[i]
                if self:gameExist(child.lua, child.packagename) then
                    self:insertInstalledGames(child, installList)
                end
            end
        end
    end
    return installList
end

function GameItemController:insertInstalledGames(item, list)
    local internal = false
    local serverConfig = require("upgrade.util.UpgradeUtil"):getServerConfig()
    if item.lua == "1" then
        local fileUtil = require("upgrade.util.UpgradeUtil")
        internal = fileUtil:exist(string.format("assets/scripts/%s/config.lua", item.packagename))
    end
    if not internal then
        local data = {}
        data.packagename = item.packagename
        data.package_id = item.package_id
        data.icon = tostring(serverConfig.img_host) .. tostring(item.icon)
        --data.iconFocus = serverConfig.img_host .. item.iconFocus
        data.game_id = item.game_id
        data.name = item.name
        data.lua = item.lua
        data.intro = item.intro
        table.insert(list, data)
    end
end

function GameItemController:getNodeJson(nodeId)
    local id = toint(nodeId)
    local path = string.format("config/gameitems/GameItem%d.json", id)
    local util = require("upgrade.util.UpgradeUtil")
    local nodeTable = nil
    if util:exist("update/module/game/res/" .. path) then
        nodeTable = util:getJson("update/module/game/res/" .. path)
    elseif util:exist(path) then
        nodeTable = util:getJson(path)
    end
    return nodeTable
end

function GameItemController:_recordRefreshError(reason)
    local params = {}
    params.err_type = UpgradeDefine.MSG_ERROR_GAMEITEMS
    params.pkg_name = PROJECT_NAME
    if reason.curl_code ~= nil then
        params.curl_code = reason.curl_code
    end
    if reason.response_code ~= nil then
        params.response_code = reason.response_code
    end
    if reason.comment ~= nil then
        params.comment = reason.comment
    end
    local uptime = CCUserDefault:sharedUserDefault():getStringForKey("game_uptime", "0")
    params.uptime = uptime
    local upgradeController = require("upgrade.controller.UpgradeController")
    upgradeController:recordUpgradeError(params)
end

return GameItemController
