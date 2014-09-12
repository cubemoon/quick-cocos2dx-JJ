local UpdateManager = {}

local TAG = "UpdateManager"

--[[
-- 检查更新
-- @params  url       检查更新地址
--          callback  检查更新结果回调函数，参数为服务器端返回的数据，类型为table
--          reqTable  用于post请求的相关数据，类型为table
--]]
function UpdateManager:checkUpdate(url, callback, reqTable)
    local request = network.createHTTPRequest(function (event)
        local success = (event.name == "completed")
        if not success then
            callback({error = "fail"})
            request:release()
            return
        end
        -- 返回状态值不等于200
        local req = event.request
        local code = req:getResponseStatusCode()
        if code ~= 200 then
            callback({error = code})
            JJLog.i(TAG, "checkUpdate fail and error code is ", code)
            request:release()
            return
        end
        -- 将服务器端返回的json数据转换成table
        local responseTable = json.decode(req:getResponseString()) or {}
        -- 回调处理UI
        callback(responseTable)
        request:release()
    end, url, "POST")
    reqTable = reqTable or {}
    for key, value in pairs(reqTable) do
        request:addPOSTValue(key, value)
    end
    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

--[[
-- 下载更新包
-- params {
--          url               更新包下载地址
--          savePath          下载存储路径
--          resultCallback    更新结果回调, 参数为true表示下载成功，false表示下载失败
--          progressCallback  更新进度回调, 参数为当前更新百分比
--        }
--]]
function UpdateManager:update(params)
    local download = require("sdk.download.DownLoadManager")
    download:startDownload({ url = params.url,
                             path = params.savePath,
                             resultFunc = resultCallback,
                             progressFunc = progressFunc,
                             resume = true
    })
end

--[[
-- 解压缩zip包
-- @params zipPath         压缩包的所在路径
--         savePath        解压缩后的存储路径
--         resultCallback  解压缩结果回调，参数为true表示解压缩成功
--]]
function UpdateManager:uncompress(zipPath, savePath, resultCallback)
    JJUpdateManager:instance():startUncompress(zipPath, savePath, resultCallback)
end

--[[
-- 计算指定文件的MD5值
-- @param  path  需计算MD5值文件的所在路径
-- @return 计算所得得MD5值，计算出错时返回""字符串
--]]
function UpdateManager:getFileMd5(path)
    local localMd5 = JJUpdateManager:instance():getFileMD5Lua(path)
    return localMd5 or ""
end

--[[
-- 获取服务器端指定资源文件的大小
-- @param  url  自定资源的url地址
-- @return 该资源文件于服务器端的实际大小
--]]
function UpdateManager:getServerFileSize(url)
    local serverSize = JJUpdateManager:instance():getServerFileSize(url)
    if serverSize < 0 then
        serverSize = 0
    end
    return serverSize
end

--[[
-- 获取服务器端指定资源的最后修改时间
-- @param  url  指定资源的url地址
-- @return 该资源于服务器端的最后修改时间
--]]
function UpdateManager:getServerFileTime(url)
    local updateTime = JJUpdateManager:instance():getServerFileTime(url)
    return updateTime
end

--[[
-- 安装apk
-- @params  path  apk文件所在路径
--]]
function UpdateManager:installApk(path)
    local className, methodName, args, sig
    if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "installApk"
        args = {path}
        sig = "(Ljava/lang/String;)V"
        result = luaj.callStaticMethod(className, methodName, args, sig)
    else
        JJLog.i(TAG, "The platform is wrong when install apk!")
    end
end

return UpdateManager
