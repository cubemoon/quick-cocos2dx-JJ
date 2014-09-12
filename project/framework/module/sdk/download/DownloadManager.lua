-- 下载管理器，通过Http协议进行下载
local download = {}

local TAG = "DownloadManager"
local ERR_DOWNLOAD = 7000
local HTTP_RESPONSE_DELAY = 10
local DEFAULT_TIMEOUT = 1000
local DEFAULT_RETRY = 2
local DEFAULT_DELAY = 2

--[[
    通用下载函数
    @params {
                url          下载地址
                path         下载存储路径
                resultFunc   下载结果通知回调地址
                progressFunc 下载进度回调地址
                resume       是否支持断点续传
                times        已经尝试下载次数
                pause        需要暂停下载支持时，用来存储CCHTTPRequest句柄，pause = { req = request }
                timeout      设置下载请求超时的时间
                retry        设置需要重试下载的次数
                delay        重试间隔
            }
]]
function download:startDownload(params)
    assert(type(params.resultFunc)=="function", "download:startDownload need a result callback")
    local retry = params.retry or DEFAULT_RETRY
    local timeout = params.timeout or DEFAULT_TIMEOUT
    local delay = params.delay or DEFAULT_DELAY
    local errController = require("upgrade.controller.UpgradeController")
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
    local request = network.createHTTPRequest(function (event)
        local req = event.request
        if event.name == "cancelled" then
            req:release()
            return
        end
        local success = (event.name == "completed")
        if not success then
            JJLog.i(TAG, "http request is not success!")
            if params.resume == true then
                if toint(params.times) == retry then
                    local errors = {}
                    errors.err_type = ERR_DOWNLOAD
                    errors.curl_code = req:getErrorCode()
                    errors.url = params.url
                    errController:recordUpgradeError(errors)
                    params.resultFunc(false)
                else
                    JJLog.i(TAG, "retry download for times : ", toint(params.times))
                    params.times = toint(params.times) + 1
                    scheduler.performWithDelayGlobal(function()
                        self:startDownload(params)
                    end, delay)
                end
            else
                local errors = {}
                errors.err_type = ERR_DOWNLOAD
                errors.curl_code = req:getErrorCode()
                errors.url = params.url
                errController:recordUpgradeError(errors)
                -- 不支持断点续传条件下，直接返回错误结果
                params.resultFunc(false)
            end
            req:release()
            return
        end
        -- 返回状态值不等于200
        local code = req:getResponseStatusCode()
        local result = true
        if code == 302 and toint(params.times) < retry then
            scheduler.performWithDelayGlobal(function()
                params.times = toint(params.times) + 1
                self:startDownload(params)
            end, HTTP_RESPONSE_DELAY)
            req:release()
            return
        end
        if code ~= 200 and code ~= 206 then
            JJLog.i(TAG, " getResponseStatusCode code is ", code, " and url : ", params.url)
            local errors = {}
            errors.err_type = ERR_DOWNLOAD
            errors.response_code = code
            errors.url = params.url
            errController:recordUpgradeError(errors)
            result = false
        end
        params.resultFunc(result)
        req:release()
    end, params.url)
    request:setTimeout(timeout)
    if params.pause then
        params.pause.req = request
    end
    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:startDownload(params.path, params.progressFunc, params.resume)
    return request
end

function download:stopDownload(request)
    JJLog.i(TAG, "stopDownload is null : ", tolua.isnull(request))
    if tolua.type(request) == "CCHTTPRequest" and not tolua.isnull(request) then
        request:stopDownload()
    end
end

return download
