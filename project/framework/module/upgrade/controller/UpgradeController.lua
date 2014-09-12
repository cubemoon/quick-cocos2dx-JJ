require("Promoter")

local UpgradeController = {}
local GameItems = {}
local TAG = "UpgradeController"
local DUMP_PATH = device.writablePath .. "upgrade_err.json"
local SEND_ERR_DELAY = 1
local CURL_DELAY = 5
local HTTP_RESPONSE_DELAY = 10
local CHECK_TIMEOUT = 10
local DOWNLOAD_TIMEOUT = 1000
local RETRY_TIMES = 3

function UpgradeController:getCheckUrl()
    local util = require("upgrade.util.UpgradeUtil")
    local platform = device.platform
    if device.platform == "windows" or device.platform == "mac" then
        platform = "android"
    end
    local serverConfig = util:getServerConfig() or {}
    local checkUrl = string.format("%s?screen=%s&imei=%s&promoter=%s&gameid=%d&platform=%s&net=%s&operator=%s&zip_ver=%s",
        serverConfig.check_update_url,
        util:getScreenSize(),              --screen
        util:getIMEI(),                    --imei
        PROMOTER_ID,                       --promoter
        ORIGINAL_PACKAGE_ID,                --gameid
        platform,                          --platform
        util:getNetworkName(),             --net
        util:getOperator(),                --operator
        util:getLuaVersion("sdk")          --zip_ver
    )

    print(TAG, "getCheckUrl check update url : ", checkUrl)
    return checkUrl
end

--[[
    获取用于更新时发送至服务器端的相关数据
    @return 序列化过的json字符串
]]
function UpgradeController:getRequestValue()
    local util = require("upgrade.util.UpgradeUtil")
    local postTable = {
        ["cur_ver"] = util:getClientVersion(),
        ["zip_ver"] = util:getLuaVersion("sdk"),
        ["model"] = util:getDeviceModel(),
        ["sys_ver"] = util:getSysVersion(),
        ["mac"] = util:getMacAddress(),
        ["imsi"] = util:getIMSI(),
        ["iccid"] = util:getICCID(),
        ["processor"] = util:getProcessor(),
        ["token"] = util:getToken()
    }
    return postTable
end

--[[
    检查更新
    @param 前传来的回调函数地址
]]
function UpgradeController:checkUpgrade(callback)
    if not self:checkStatus() then return false end
    local requestValue = self:getRequestValue()
    local checkUrl = self:getCheckUrl()
    print(TAG, "checkUpgrade checkUrl : ", checkUrl)
    dump(requestValue, "requestValue")
    local util = require("upgrade.util.UpgradeUtil")

    local preTime = getCurrentMillis()

    local request = network.createHTTPRequest(function (event)
        local success = (event.name == "completed")

        local analyticsPath = device.writablePath .. "update/module/game/data/AnalyticsConfig.json";
        local analyticsData = util:getJson(analyticsPath) or {}
        local analyticsItem = { result = success, time = getCurrentMillis() - preTime }
        table.insert(analyticsData, analyticsItem)
        util:saveJson(analyticsData, analyticsPath)

        local req = event.request
        if not success then
            callback({error = "fail"})
            local params = {}
            params.err_type = UpgradeDefine.MSG_ERROR_CHECK_UPGRADE
            params.curl_code = req:getErrorCode()
            self:recordUpgradeError(params)
            return
        end
        -- 返回状态值不等于200
        local code = req:getResponseStatusCode()
        if code ~= 200 then
            callback({error = code})
            local params = {}
            params.err_type = UpgradeDefine.MSG_ERROR_CHECK_UPGRADE
            params.response_code = code
            self:recordUpgradeError(params)
            return
        end

        local responseHead = req:getResponseHeadersString()
        print("response head : ", responseHead)
        local responseTable = nil
        -- 根据返回数据的head是否包含gzip来判断是否解压数据
        if string.find(responseHead, "gzip") ~= nil then
            responseTable = json.decode(req:getDecompressDataLua()) or {}
        else
            responseTable = json.decode(req:getResponseString()) or {}
        end
        dump(responseTable, "response")

        callback(responseTable)
    end, checkUrl, "POST")
    for key, value in pairs(requestValue) do
        request:addPOSTValue(key, value)
    end
    request:setTimeout(CHECK_TIMEOUT)
    if util:isWap() then
        util:setWapProxy(request)
    end
    if require("upgrade.util.UpgradeUtil"):supportFunction("getDecompressDataLua") then
        request:addRequestHeader("Accept-Encoding:gzip;")
    end
    request:start()
    return true
end

--[[
    更新apk文件
    @params {
                url       下载文件url
                md5       用于校验的md5值
                callback  用于更新显示的回调函数地址
            }
]]
function UpgradeController:startUpdateApk(params)
    local url, md5, callback = params.url, params.md5, params.callback
    -- 获取Android设备的存储路径
    local className = "cn/jj/base/JJUtil"
    local methodName = "getExternalStoragePath"
    local args = {}
    local sig = "()Ljava/lang/String;"
    local result, path = luaj.callStaticMethod(className, methodName, args, sig)
    local fullPath = string.format("%s/%s.apk", path, PROJECT_NAME)

    -- 检查服务器端文件是否更新
    if not self:checkUpdateTime(url) then
        os.remove(fullPath)
    end

    -- 比对本地缓存与服务器端的文件大小
    local fileUtil = require("upgrade.util.UpgradeUtil")
    local localSize = fileUtil:getFileSize(fullPath)
    local serverSize = JJUpdateManager:instance():getServerFileSize(url)
    print(TAG, " startUpdateApk localSize : ", localSize, " and serverSize : ", serverSize)
    if localSize > serverSize then
       os.remove(fullPath)
    elseif localSize == serverSize and localSize ~= 0 then
        if not self:checkUpdateMd5(fullPath, md5) then
            --callback(UpgradeDefine.TYPE_UPDATE_RESULT, UpgradeDefine.MSG_ERROR_MD5)
            os.remove(fullPath)
            --return
        else
            self:installPackage(fullPath)
            os.exit()
            return
        end
    end

    self:startDownload( {   url = url,
                            path =  fullPath,
                            resultFunc = function(success)
                                if success then
                                    local msg = UpgradeDefine.MSG_UPDATE_SUCCESS
                                    if not self:checkUpdateMd5(fullPath, md5) then
                                        msg = UpgradeDefine.MSG_ERROR_MD5
                                        os.remove(fullPath)
                                        return
                                    else
                                        if self.installEnable_ then
                                            self:installPackage(fullPath)
                                            os.exit()
                                        end
                                        return
                                    end
                                else
                                    msg = UpgradeDefine.MSG_ERROR_DOWNLOAD
                                end
                                callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
                            end,
                            progressFunc = function(value)
                                callback(UpgradeDefine.TYPE_UPDATE_PROGRESS, value)
                            end,
                            resume = true })
end

--[[
    更新脚本
    @params {
                index       更新脚本包索引
                scriptData  脚本包的更新数据表
                callback    响应回调，通常参数为type和value，进度更新只传进度值为参数
            }
]]
function UpgradeController:startUpdateScript(params)
    local callback = params.callback
    local index = params.index
    local scriptData = params.data
    local size = #scriptData
    print(TAG, " startUpdateScript params index : ", index, " and size : ", size)
    if index > size then
        params.callback(UpgradeDefine.TYPE_UPDATE_END, size)
        return
    end

    local scriptItem = scriptData[index]
    local fullPath = string.format("%stemp/%s.zip", device.writablePath, scriptItem.HashCode)

    local save = CCUserDefault:sharedUserDefault()
    -- 比对本地缓存与服务器端的文件大小
    local fileUtil = require("upgrade.util.UpgradeUtil")
    local localSize = fileUtil:getFileSize(fullPath)
    local serverSize = JJUpdateManager:instance():getServerFileSize(url)
    print(TAG, " startUpdateScript localSize : ", localSize, " and serverSize : ", serverSize)
    if localSize > serverSize then
        os.remove(fullPath)
    elseif localSize == serverSize and serverSize ~= 0 then
        if not self:checkUpdateMd5(fullPath, md5) then
            os.remove(fullPath)
        else
            JJUpdateManager:instance():startUncompress(fullPath, device.writablePath .. "update/", function(result)
                if result ~= UNCOMPRESS_RESULT_FAIL then
                    msg = UpgradeDefine.MSG_UPDATE_SUCCESS
                    save:setStringForKey("uptime" .. params.id, params.uptime)
                    save:flush()
                    local cmd = "rm " .. fullPath
                    os.execute(cmd)
                else
                    msg = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                    local errors = {}
                    errors.err_type = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                    errors.pkg_name = "sdk"
                    self:recordUpgradeError(errors)
                end
                callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
            end)
            return
        end
    end

    self:startDownload({  url = scriptItem.FileURL,
                            path = fullPath,
                            resultFunc = function(success)
                                local msg = UpgradeDefine.MSG_UPDATE_SUCCESS
                                if success then
                                    if not self:checkUpdateMd5(fullPath, scriptItem.HashCode) then
                                        msg = UpgradeDefine.MSG_ERROR_MD5
                                        local cmd = "rm " .. fullPath
                                        os.execute(cmd)
                                    else
                                        -- 解压缩相关处理
                                        JJUpdateManager:instance():startUncompress(fullPath, device.writablePath .. "update/", function(result)
                                                    if result ~= UNCOMPRESS_RESULT_FAIL then
                                                        params.index = params.index + 1
                                                        self:startUpdateScript(params)
                                                        local cmd = "rm " .. fullPath
                                                        os.execute(cmd)
                                                    else
                                                        local errors = {}
                                                        errors.err_type = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                                                        errors.pkg_name = "sdk"
                                                        self:recordUpgradeError(errors)
                                                        msg = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                                                        callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
                                                    end
                                                end)
                                    end
                                else
                                    msg = UpgradeDefine.MSG_ERROR_DOWNLOAD
                                end
                                callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
                            end,
                            progressFunc = function(value)
                                callback(UpgradeDefine.TYPE_UPDATE_PROGRESS, value)
                            end,
                            resume = true,
                            err_type = UpgradeDefine.MSG_ERROR_UPGRADE_SDK })
end

--[[
    更新下载函数
    @params {
                url          下载地址
                path         下载存储路径
                resultFunc   下载结果通知回调地址
                progressFunc 下载进度回调地址
                resume       是否支持断点续传
                times        已经尝试下载次数
                err_type     用于统计更新下载出错类型
            }
]]
function UpgradeController:startDownload(params)
    assert(type(params.resultFunc)=="function", "download:startDownload need a result callback")
    local request = network.createHTTPRequest(function (event)
        local req = event.request
        if event.name == "cancelled" then
            req:release()
            return
        end
        local success = (event.name == "completed")
        local errCode = req:getErrorCode()
        if not success then
            print(TAG, "http request is not success!")
            if params.resume == true then
                if toint(params.times) == RETRY_TIMES then
                    print(TAG, "http request code ", errCode)
                    local errors = {}
                    errors.err_type = params.err_type or UpgradeDefine.MSG_ERROR_DOWNLOAD
                    errors.curl_code = errCode
                    errors.url = params.url
                    self:recordUpgradeError(errors)
                    params.resultFunc(false)
                else
                    print(TAG, "retry download for times : ", toint(params.times))
                    params.times = toint(params.times) + 1
                    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
                    scheduler.performWithDelayGlobal(function()
                        self:startDownload(params)
                    end, CURL_DELAY)
                    req:release()
                    return
                    --self:startDownload(params)
                end
            else
                -- 不支持断点续传条件下，直接返回错误结果
                print(TAG, "http request code ", errCode)
                local errors = {}
                errors.err_type = params.err_type or UpgradeDefine.MSG_ERROR_DOWNLOAD
                errors.curl_code = errCode
                errors.url = params.url
                self:recordUpgradeError(errors)
                params.resultFunc(false)
            end
            req:release()
            return
        end
        -- 返回状态值不等于200
        local code = req:getResponseStatusCode()
        local result = true
        if code == 302 and toint(params.times) < RETRY_TIMES then
            local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
            scheduler.performWithDelayGlobal(function()
                params.times = toint(params.times) + 1
                self:startDownload(params)
            end, HTTP_RESPONSE_DELAY)
            req:release()
            return
        end
        if code ~= 200 and code ~= 206 then
            print(TAG, " getResponseStatusCode code is ", code, " and url : ", params.url)
            result = false
            local errors = {}
            errors.err_type = params.err_type or UpgradeDefine.MSG_ERROR_DOWNLOAD
            errors.response_code = code
            errors.url = params.url
            self:recordUpgradeError(errors)
        end
        params.resultFunc(result)
        req:release()
    end, params.url)
    request:setTimeout(DOWNLOAD_TIMEOUT)
    local util = require("upgrade.util.UpgradeUtil")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:startDownload(params.path, params.progressFunc, params.resume)
    return request
end

--[[
    安装游戏程序
    @param 安装包绝对路径
]]
function UpgradeController:installPackage(path)
    local className, methodName, args, sig
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "installApk"
        args = {path}
        sig = "(Ljava/lang/String;)V"
        result = luaj.callStaticMethod(className, methodName, args, sig)
    else
        print("UpgradeController installPackage platform is wrong!")
    end
end

--[[
    检查服务器端某一文件是否被更新
    @param url：被检查文件的统一资源定位符
    @return：返回true表示未被更新
]]
function UpgradeController:checkUpdateTime(url)
    local key = crypto.md5(url)
    local save = CCUserDefault:sharedUserDefault()
    local recordTime = save:getIntegerForKey(key)
    local updateTime = JJUpdateManager:instance():getServerFileTime(url)
    print(TAG, " checkUpdateTime recordTime : ", recordTime, " and updateTime : ", updateTime)
    save:setIntegerForKey(key, updateTime)
    save:flush()
    if recordTime == 0 then
        return false
    else
        return (recordTime == updateTime)
    end
end

--[[
    检查文件md5值是否正确
    @param path:被检查的文件路径
           md5:用于检查校验的md5值
    @return 返回true表示md5校验正确
]]
function UpgradeController:checkUpdateMd5(path, md5)
    local localMd5 = JJUpdateManager:instance():getFileMD5Lua(path)
    print(TAG, " checkUpdateMd5 local md5 : ", localMd5, " server md5 : ", md5)
    if localMd5 ~= md5 then
        local params = {}
        params.err_type = UpgradeDefine.MSG_ERROR_MD5
        params.server_md5 = md5
        params.local_md5 = localMd5
        self:recordUpgradeError(params)
    end
    return localMd5 == md5
end

function UpgradeController:checkStatus()
    -- windows平台直接返回true
    if device.platform == "windows" then
        return true
    end

    local util = require("upgrade.util.UpgradeUtil")
    -- 查看网络状态
    if util:getNetworkType() == 0 then
        -- 网络未连接
        return false
    end

    -- 查看脚本版本状态
    local versions = require("script_version_in_client")
    local keys = table.keys(versions)
    local values = table.values(versions)
    for i = 1, #keys do
        local path = string.format("%s/config", keys[i])
        local config = {}
        if util:exist(path .. ".lua") then
            config = require(path)
        end
        -- 如果update内模块版本小于整包内对应的模块版本，清除update下该模块目录
        print(TAG, "update config version : ", config.version_, " package version : ", values[i], " module : ", keys[i])
        if tonum(config.version_) < tonum(values[i]) then
            local cmd = string.format("rm -r %supdate/module/%s", device.writablePath, keys[i])
            print(TAG, "checkStatus rm cmd : ", cmd)
            os.execute(cmd)
            if keys[i] == "sdk" then
                os.execute(string.format("rm -r %supdate/module/game", device.writablePath))
                os.execute(string.format("rm -r %supdate/module/hall", device.writablePath))
                os.execute(string.format("rm -r %supdate/module/upgrade", device.writablePath))
                --清除配置的game_uptime值，用于获取游戏节点
                local save = CCUserDefault:sharedUserDefault()
                save:setStringForKey("game_uptime", "0")
                save:flush()
            end
        end
    end

    return true
end

function UpgradeController:startUpgradeSingle(params)
    local url, md5, callback = params.url, params.md5, params.callback
    local fullPath = string.format("%stemp/%s.zip", device.writablePath, md5)
    local msg = UpgradeDefine.MSG_UPDATE_SUCCESS
    local save = CCUserDefault:sharedUserDefault()
    -- 比对本地缓存与服务器端的文件大小
    local fileUtil = require("upgrade.util.UpgradeUtil")
    local localSize = fileUtil:getFileSize(fullPath)
    local serverSize = JJUpdateManager:instance():getServerFileSize(url)
    print(TAG, " startUpgradeSingle localSize : ", localSize, " and serverSize : ", serverSize)
    if localSize > serverSize then
        os.remove(fullPath)
    elseif localSize == serverSize and serverSize ~= 0 then
        if not self:checkUpdateMd5(fullPath, md5) then
            os.remove(fullPath)
        else
            JJUpdateManager:instance():startUncompress(fullPath, device.writablePath .. "update/", function(result)
                if result ~= UNCOMPRESS_RESULT_FAIL then
                    msg = UpgradeDefine.MSG_UPDATE_SUCCESS
                    save:setStringForKey("uptime" .. params.id, params.uptime)
                    save:flush()
                    local cmd = "rm " .. fullPath
                    os.execute(cmd)
                else
                    local errors = {}
                    errors.err_type = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                    errors.pkg_name = "sig"
                    self:recordUpgradeError(errors)
                    msg = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                end
                callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
            end)
            return
        end
    end

    self:startDownload({  url = url,
                            path =  fullPath,
                            resultFunc = function(success)
                                if success then
                                    if not self:checkUpdateMd5(fullPath, md5) then
                                        print(TAG, " startUpgradeSingle md5 check fail!")
                                        msg = UpgradeDefine.MSG_ERROR_MD5
                                        local cmd = "rm " .. fullPath
                                        os.execute(cmd)
                                    else
                                        JJUpdateManager:instance():startUncompress(fullPath, device.writablePath .. "update/", function(result)
                                            if result ~= UNCOMPRESS_RESULT_FAIL then
                                                msg = UpgradeDefine.MSG_UPDATE_SUCCESS
                                                save:setStringForKey("uptime" .. params.id, params.uptime)
                                                save:flush()
                                                local cmd = "rm " .. fullPath
                                                os.execute(cmd)
                                            else
                                                local params = {}
                                                params.err_type = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                                                params.pkg_name = PROJECT_NAME
                                                self:recordUpgradeError(params)
                                                msg = UpgradeDefine.MSG_ERROR_UNCOMPRESS
                                            end
                                            callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
                                        end)
                                        return
                                    end
                                else
                                    msg = UpgradeDefine.MSG_ERROR_DOWNLOAD
                                end
                                callback(UpgradeDefine.TYPE_UPDATE_RESULT, msg)
                            end,
                            progressFunc = function(value)
                                callback(UpgradeDefine.TYPE_UPDATE_PROGRESS, value)
                            end,
                            resume = true,
                            err_type = UpgradeDefine.MSG_ERROR_UPGRADE_SIG })
end

function UpgradeController:setInstallEnable(enable)
    self.installEnable_ = enable
end

--[[
-- 检查存储空间是否剩余充足（大于30Mb）
-- @return 空间充足返回true，反之返回false
--]]
function UpgradeController:checkStorageAvailable()
    local util = require("upgrade.util.UpgradeUtil")
    local jsonData = util:getStorageSize() or ""
    print(TAG, " checkStorageStatus jsonData : ", jsonData)
    local storageTable = json.decode(jsonData) or {}
    local sdcardTotal = storageTable.originalSDsize or 0
    local sdcardAvailable = storageTable.SDsize or 0
    local phoneTotal = storageTable.originalphonesize or 0
    local phoneAvailable = storageTable.phonesize or 0
    print("sdcardTotal : ", sdcardTotal, ", sdcardAvailable : ", sdcardAvailable, ", phoneTotal : ", phoneTotal, ", phoneAvailable : ", phoneAvailable)
    local warnSize = 30 * 1024 * 1024
    if sdcardTotal ~= 0 then
        return sdcardAvailable > warnSize
    else
        return phoneAvailable > warnSize
    end
end

--[[
-- 检查是否需要提示用户更新zip
-- @param zipSize 需要更新zip文件的大小
-- @return 需要提示用户返回true
--]]
function UpgradeController:checkUpgradeZip(zipSize)
    --local util = require("upgrade.util.UpgradeUtil")
    --local netType = util:getNetworkType() or 0
    --local warnSize = 5 * 1024 * 1024
    --local needWarn = (netType ~= 1 and tonum(zipSize) > warnSize)
    --return needWarn

    -- TODO 根据需求，不提示用户
    return false
end

function UpgradeController:checkWarnPromoters()
    local promoter = PROMOTER_ID or 0
    local condition1 = promoter >= 40001 and promoter <= 40011
    local condition2 = promoter >= 42000 and promoter <= 42999
    return condition1 or condition2
end

function UpgradeController:_upload()
    local util = require("upgrade.util.UpgradeUtil")
    local errors = util:getJson(DUMP_PATH)
    if errors == nil or errors == "" then
        print(TAG, " sendUpgradeError _upload errors is nil")
        return
    end
    if #errors == 1 and errors.err_type == UpgradeDefine.MSG_UPDATE_SUCCESS then
        print(TAG, " sendUpgradeError _upload errors is success")
        return
    end
    local errorJson = json.encode(errors)
    local request = network.createHTTPRequest(function(event)
        os.execute("rm -r " .. DUMP_PATH)
    end, "http://update.m.jj.cn/mobile/android/error_log.php", "POST")
    request:addPOSTValue("dumptype", "autoupdate")
    request:addPOSTValue("imei", util:getIMEI())
    request:addPOSTValue("model", util:getDeviceModel())
    request:addPOSTValue("sys_ver", util:getSysVersion())
    request:addPOSTValue("platform", device.platform)
    request:addPOSTValue("gameid", CURRENT_PACKAGE_ID)
    request:addPOSTValue("app_ver", util:getClientVersion())
    request:addPOSTValue("log", errorJson)
    --request:addPOSTValue("upgrade_error", errorJson)

    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

function UpgradeController:sendUpgradeError()
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    scheduler.performWithDelayGlobal(handler(self, self._upload), SEND_ERR_DELAY)
end

function UpgradeController:recordUpgradeError(params)
    local util = require("upgrade.util.UpgradeUtil")
    local path = device.writablePath .. "upgrade_err.json"
    local errors = util:getJson(DUMP_PATH) or {}
    if params.pkg_name ~= nil and params.pkg_name ~= "apk" then
        if params.pkg_name == "hall" then params.pkg_name = "sdk" end
        params.script_ver = util:getLuaVersion(params.pkg_name)
    end
    params.net_type = util:getNetworkType()
    params.original_id = ORIGINAL_PACKAGE_ID or 0
    table.insert(errors, params)
    util:saveJson(errors, path)
end

return UpgradeController
