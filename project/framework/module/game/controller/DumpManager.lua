local DumpManager = {}
local TAG = "DumpManager"
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local CHECK_TICK = 30
local FILE_DIR = device.writablePath .. "jjdump/"

-- function
local _upload

local function _readMD5()
    local data = LuaDataFile.get("so.json")
    if data ~= nil then
        return data.MD5
    end
end

local function _run(filename, filepath)
    JJLog.i(TAG, "_run, filename=", filename, ", filepath=", filepath)
    local md5 = _readMD5()
    if md5 == nil then
        md5 = "JJJJJJJJJJ"
    end
    local request = network.createHTTPRequest(function(event)
        JJLog.i(TAG, "_run, event", event)
        dump(event)
        if event ~= nil and event.name == "completed" then
            JJFileUtil:removeDir(filepath)
            _upload()
        end
        end, "http://update.m.jj.cn/mobile/android/error_log.php", "POST")
    local compiletimeInt, compiletimeStr = Util:getApkBuildTime()
    request:addPOSTValue("imei", Util:getIMEI())
    request:addPOSTValue("model", Util:getDeviceModel())
    request:addPOSTValue("sys_ver", Util:getSysVersion())
    request:addPOSTValue("platform", device.platform)
    request:addPOSTValue("gameid", CURRENT_PACKAGE_ID)
    request:addPOSTValue("app_ver", Util:getClientVersion())
    request:addPOSTValue("script_ver", Util:getScriptVersion())
    request:addPOSTValue("nickname", UserInfo.nickname_)
    request:addPOSTValue("compiletime", compiletimeStr)
    request:addPOSTValue("somd5", md5)
    request:addPOSTValue("dumptype", "zip")
    request:addFormFile(filename, filepath)

    local util = require("sdk.util.Util")
    if util:isWap() then
        util:setWapProxy(request)
    end
    request:start()
end

local function _postLog(filePath)
    JJLog.i(TAG, "_postLog, filePath=", filePath)

    local nSize = 1
    local log, nSize = CCFileUtils:sharedFileUtils():getFileData(filePath, "r", nSize)
    log = string.sub(log, 1, nSize)
    JJLog.i(TAG, "_postLog, log=", log)

    -- 上传 Lua 错误
    require("game.util.CrashHandler")
    CrashHandler:sendLog(log)
    JJFileUtil:removeDir(filePath)
end

function _upload()
    JJLog.i(TAG, "_upload")
    for entry in lfs.dir(FILE_DIR) do
        if entry ~= '.' and entry ~= '..' then
            local path = FILE_DIR .. entry
            JJLog.i(TAG, "_upload, entry=", entry, ", path=", path)
            local attr = lfs.attributes(path)
            assert(type(attr) == 'table')
            if attr.mode == "file" then
                if string.find(entry, ".dmp") then
                    local zipName = string.gsub(entry, "dmp", "zip")
                    local zipPath = FILE_DIR .. zipName
                    JJLog.i(TAG, "_upload, zipName=", zipName, ", zipPath=", zipPath)
                    JJLog.i(TAG, "_upload, type(zipDeflateFile)=", type(zipDeflateFile))
                    -- 压缩
                    if type(zipDeflateFile) == "function" then
                        JJLog.i(TAG, "_upload, is function")
                        if 0 == zipDeflateFile(path, zipPath) then
                            JJFileUtil:removeDir(path)
                            _run(zipName, zipPath)
                            break
                        end
                    end
                elseif string.find(entry, ".zip") then
                    _run(entry, path)
                    break
                elseif string.find(entry, ".log") then
                    _postLog(path)
                    -- No Break for continue post dump file
                end
            end
        end
    end
end

-- 为了和登陆错开，过一会再开始上传
function DumpManager:start()
    scheduler.performWithDelayGlobal(_upload, CHECK_TICK)
end

return DumpManager