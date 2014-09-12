Util = {}

local TAG = "Util"
local isActive = true

--统一数据缓存到lua中
Util.imei_ = nil
Util.mac_ = nil

-- 获取客户端版本号
function Util:getClientVersion()
    local result, version = false, "1000"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getClientVersion"
        local args = {}
        local sig = "()I"
        result, version = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getClientVersion"
        local args = {}
        result, version = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return version
end

-- 获取客户端版本号
function Util:getVersionName()
    local result, versionName = false, "1.00.00"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getVersionName"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, versionName = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    elseif not device.platform == "windows" then
    end
    return versionName
end

function Util:getPackageVersion(packageName)
    local result, version = false, "1000"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getPackageVersion"
        local args = { packageName }
        local sig = "(Ljava/lang/String;)I"
        result, version = luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
    return version
end

-- 获取脚本包版本号
function Util:getScriptVersion()
    --local version = CCUserDefault:sharedUserDefault():getStringForKey("current-version-code")
    package.loaded["sdk.config"] = nil
    local version = require("sdk.config").version_ or 0
    return version
end

-- 获取屏幕宽高
function Util:getScreenSize()
    local result, size = false, "unknow"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getScreenSize"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, size = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getScreenSize"
        local args = {}
        result, size = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return size
end

-- 获取设备名
function Util:getDeviceModel()
    local result, model = false, "unknow"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getDeviceModel"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getDeviceModel"
        local args = {}
        result, model = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return model
end

-- 获取系统版本号
function Util:getSysVersion()
    local result, sysVersion = false, "unknow"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getSysVersion"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, sysVersion = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getSysVersion"
        local args = {}
        result, sysVersion = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return sysVersion
end

-- 获取 Mac
function Util:getMacAddress()
    local result, mac = false, ""

    if device.platform == "android" then
        if self.mac_ == nil then
            local className = "cn/jj/base/JJUtil"
            local methodName = "GetLocalData"
            local args = {"mac"}
            local sig = "(Ljava/lang/String;)Ljava/lang/String;"
            result, self.mac_ = luaj.callStaticMethod(className, methodName, args, sig)
        end
        mac = self.mac_
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getMacAddress"
        local args = {}
        result, mac = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    JJLog.i(TAG, "mac = ",mac)
    return mac
end

-- 获取 IMEI
function Util:getIMEI()
    local result, imei = false, ""

    if device.platform == "android" then
        if self.imei_ == nil then
            local className = "cn/jj/base/JJUtil"
            local methodName = "GetLocalData"
            local args = {"imei"}
            local sig = "(Ljava/lang/String;)Ljava/lang/String;"
            result, self.imei_ = luaj.callStaticMethod(className, methodName, args, sig)
        end
        imei = self.imei_
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getIMEI"
        local args = {}
        result, imei = luaoc.callStaticMethod(className,methodName,args)
    elseif device.platform == "windows" then
        imei = "990003127187397"
    else
    end
    JJLog.i(TAG, "imei = ",self.imei_)
    return imei
end

-- 获取 IMSI
function Util:getIMSI()
    local result, imsi = false, ""

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getIMSI"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, imsi = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "windows" then
        imsi = "460006101611307" --模拟器测试用
    else
    end
    JJLog.i(TAG, "imsi = ", imsi)
    return imsi
end

-- 获取 ICCID
function Util:getICCID()
    local result, iccid = false, ""

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getICCID"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, iccid = luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
    return iccid
end

-- 获取处理器架构
function Util:getProcessor()
    local result, processor = false, ""

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getProcessor"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, processor = luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
    return processor
end

-- 获取当前网络类型
function Util:getNetworkType()
    local result, type = false, 0

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getNetworkType"
        local args = {}
        local sig = "()I"
        result, type = luaj.callStaticMethod(className, methodName, args, sig)
    else -- if device.platform == "windows" then
        type = 1
    end
    return type
end

-- 获取网络名
function Util:getNetworkName()
    local result, name = false, "unknow"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getConnectTypeName"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, name = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getNetworkName"
        local args = {}
        result, name = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return name
end

-- 获取运营商
function Util:getOperator()
    local result, operator = false, "unknow"

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getOperator"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, operator = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "getOperator"
        local args = {}
        result, operator = luaoc.callStaticMethod(className,methodName,args)
    elseif not device.platform == "windows" then
    end
    return operator
end

function Util:getExternalStoragePath()
    local result, path
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getExternalStoragePath"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, path = luaj.callStaticMethod(className, methodName, args, sig)
    else
        path = device.writablePath .. "temp/"
    end
    return path
end

function Util:getToken()
    local version = self:getClientVersion()
    local promoteId = PROMOTER_ID
    local imei = self:getIMEI()
    local token = string.format("%d%%%d%%%d%%%s", CURRENT_PACKAGE_ID, PROMOTER_ID, version, imei)
    local md5 = crypto.md5(token, false)
    JJLog.i(TAG, "token : ", token, " and md5 : ", md5)
    return md5
end

function Util:getApkBuildTime()
    local result, date = false, "0"
    local dateInt = ""
    local dateStr = ""
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getApkBuildTime"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, date = luaj.callStaticMethod(className, methodName, args, sig)
        local time = "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d"
        if string.find(date, time) then
            dateStr = string.sub(date, string.find(date, time))
            dateInt = dateStr
            local n = 0
            if dateInt then
                dateInt, n = string.gsub(dateInt, "-", function(s) return "" end)
            end
            if dateInt then
                dateInt, n = string.gsub(dateInt, ":", function(s) return "" end)
            end
            if dateInt then
                dateInt, n = string.gsub(dateInt, " ", function(s) return "" end)
            end
        end

        JJLog.i(TAG, "getApkBuildTime IN dateInt is ", dateInt, " dateStr is ", dateStr)
    else
        JJLog.i(TAG, "getApkBuildTime wrong platform!")
    end
    return dateInt, dateStr
end

-- 请求横屏
function Util:requestLandScape()
    JJLog.i(TAG, "requestLandScape")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "requestLandScape"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "setLandscape"
        local args = {}
        luaoc.callStaticMethod(className, methodName, args)
    elseif not device.platform == "windows" then
    end
end

-- 请求竖屏
function Util:requestPortrait()
    JJLog.i(TAG, "requestPortrait")
    
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "requestPortrait"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "DeviceController"
        local methodName = "setPortrait"
        local args = {}
        luaoc.callStaticMethod(className, methodName, args)        
    elseif not device.platform == "windows" then
    end
end

-- 背光常亮
function Util:keepScreenOn(flag)
    local result, mac = false, ""

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "keepScreenOn"
        local args = { flag }
        local sig = "(Z)V"
        result, mac = luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

-- 显示自定义界面
-- 参数说明（格式：参数名称，参数說明，参数数据类型，备注）
-- Tag 标记上层View的标识  String 必填
-- w 标记上层View的宽度 int 必填
-- h标记上层页面的高度 int 必填
-- marginTop 标记View的据顶部的相对距离 int 必填
-- marginLeft 标记View左边距 int 必填
-- callback 注册Lua回调函数以供上层（如，android平台的Java代码）调用 int 必填
-- customViewURL 标记上层View需要连接的URL地址 String 必填
-- appId Cookie6 用到的ID int 必填（大厅是 10002，其他是 10003）
-- param 其他自定义字符串参数 String 可选
-- isactivity 是否需要新启动一个activity加载网页 boolean 必选
-- ssoURL Cookie加载域的地址，如果错误会导致加载网页失败且切换到登录页 String 必填

-- 注意：callback一定传入self，因为Java回调时，Lua虚拟机可以找到对应的对象调用对应的回调函数。
-- 请封装handler(self, self.func)的形势注册。确保回调成功。另外需要Lua与Java互调请参考网址
-- http://dualface.github.io/blog/2013/01/01/call-java-from-lua/
-- 内容。
-- function Util:showCustomView(tag, w, h, marginTop, marginLeft, callback, customViewURL, appId, param, isactivity, ssoURL)
function Util:showCustomView(tag, w, h, marginTop, marginLeft, callback, customViewURL, appId)
    -- JJLog.i(TAG, "showCustomView isactivity = ", isactivity, " type(isactivity) = ", type(isactivity),
    --     " param = ", param, " type(param) = ", type(param))

    -- if isactivity == nil then
    --     isactivity = false
    -- end

    -- if ssoURL == nil or ssoURL == "" then
    --     ssoURL = JJWebViewUrlDef.MOB_SSO_URL
    -- end

    -- if customViewURL == JJWebViewUrlDef.URL_OTHER_CHARGE then
    --     ssoURL = JJWebViewUrlDef.CHARGE_SSO_URL
    -- end

    -- JJLog.i(TAG, "showCustomView isactivity = ", isactivity, " type(isactivity) = ", type(isactivity),
    --     " param = ", param, " type(param) = ", type(param))

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "showCustomView"
        local args = { tag, w, h, marginTop, marginLeft, callback, customViewURL, appId}
        local sig = "(Ljava/lang/String;IIIIILjava/lang/String;I)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

-- 关闭自定义界面
function Util:closeCustomView(tag)
    JJLog.i(TAG, "closeCustomView")

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "closeCustomView"
        local args = { tag }
        local sig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

function Util:showWebActivity(tag, callback, goURL, appId, title, ssourl, sso, resdir, loginmode, orientation, isshare, scale)

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "showWebActivity"
        local args = nil
        local sig = nil
        local paramsJson = nil


        local ptag = tag
        local pgoURL = goURL
        local pappId = appId
        local ptitle = title
        local pssourl = ssourl
        local psso = sso
        local presdir = resdir
        local ploginmode = loginmode
        local porientation = orientation
        local pisshare = isshare
        local pscale = scale

        if self:supportFunction("WebViewOrientation") then
            if self:supportFunction("WebViewJsonParams") then
                
                local paramsTable = {
                                tag = ptag,
                                goURL = pgoURL,
                                appId = pappId,
                                title = ptitle,
                                ssourl = pssourl,
                                sso = psso,
                                resdir = presdir,
                                loginmode = ploginmode,
                                orientation = porientation,
                                isshare = pisshare,
                                scale = pscale,
                            }
                -- JJLog.i(TAG, "_showWebView,1 ", vardump(paramsTable, "paramsTable"))
                paramsJson = json.encode(paramsTable)
                args = {paramsJson, callback}
                sig = "(Ljava/lang/String;I)V"
                -- JJLog.i(TAG, "showWebActivity 1 paramsJson = ", paramsJson, " type(paramsJson) = ", type(paramsJson))
            else
                args = { tag, callback, goURL, appId, title, ssourl, sso, resdir, loginmode, orientation}
                sig = "(Ljava/lang/String;ILjava/lang/String;ILjava/lang/String;Ljava/lang/String;ZLjava/lang/String;II)V"
            end
        else
            args = { tag, callback, goURL, appId, title, ssourl, sso, resdir, loginmode}
            sig = "(Ljava/lang/String;ILjava/lang/String;ILjava/lang/String;Ljava/lang/String;ZLjava/lang/String;I)V"
        end

        -- JJLog.i(TAG, "showWebActivity paramsJson = ", paramsJson, " type(paramsJson) = ", type(paramsJson))

        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local isLandScape = true;
        local top = JJSDK:getTopSceneController()
        if top ~= nil and top.scene_ ~= nil then
            isLandScape = top.scene_.landScape_
        end
        local className = "JJWebController"
        local methodName = "showWebView"
        local args = { ["tag"] = tag, ["callback"] = callback, ["goURL"] = goURL, ["appId"] = appId, ["title"] = title, ["ssourl"] = ssourl, ["sso"] = sso, ["resdir"] = resdir, ["loginmode"] = loginmode, ["orientation"] = orientation, ["isLandScape"] = isLandScape }
        result, operator = luaoc.callStaticMethod(className,methodName,args)
        JJLog.i(TAG,"showWebActivity result=",result," operator=",operator)
    elseif not device.platform == "windows" then
    end
end

function Util:closeWebActivity()

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "closeWebActivity"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "closeJJWebView"
        local args = {}
        luaoc.callStaticMethod(className, methodName, args)       
    elseif not device.platform == "windows" then
    end
end

-- 仅仅获取cookie，且添加获取后的其他处理，可以回调lua也可直接在上层直接处理。
function Util:getCookieAndTodo(tag, callback, todo, appId, param)
    JJLog.i(TAG, "showCustomView")

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getCookieAndTodo"
        local args = { tag, callback, todo, appId, param }
        local sig = "(Ljava/lang/String;ILjava/lang/String;ILjava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "JJWebController"
        local methodName = "getCookieAndTodo"  
        local args = { ["tag"] = tag, ["callback"] = callback, ["todo"] = todo, ["appId"] = appId, ["param"] = param }   
        result, operator = luaoc.callStaticMethod(className,methodName,args)
        JJLog.i(TAG,"getCookieAndTodo result=",result," operator=",operator)  
    elseif not device.platform == "windows" then

    end
end

-- 自定义界面的back按键处理
function Util:onBackPressedForCustomView()
    JJLog.i(TAG, "onBackPressedForCustomView")

    if device.platform == "android" then
        local className = "cn/jj/base/JJActivity"
        local methodName = "callBackPressedForCoustomView"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end


-- 是否已经设置过广场的 Cookie
function Util:isSetCookie()
    local result = false
    local isSetCookie = false

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "isGetCookie"
        local args = {}
        local sig = "()Z"
        result, isSetCookie = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "JJWebController"
        local methodName = "isGetCookie"
        local args = {}
        result, isSetCookie = luaoc.callStaticMethod(className, methodName, args)
    elseif not device.platform == "windows" then
    end
    JJLog.i(TAG, "isSetCookie result=",result,"isSetCookie=",isSetCookie)
    return isSetCookie
end

-- 设置广场的 Cookie 状态
function Util:resetCookie(state)
    JJLog.i(TAG, "resetCookie")
    local result = false
    local operator = false
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "resetCookie"
        local args = { state }
        local sig = "(Z)V"
        result, operator = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "JJWebController"
        local methodName = "resetCookie"
        local args = {["state"] = state}
        result, operator = luaoc.callStaticMethod(className, methodName, args)     
    elseif not device.platform == "windows" then
    end
    JJLog.i(TAG, "isSetCookie result=",result,"operator=",operator)
end

-- 调用网络设置
function Util:callNetworkSetting()
    JJLog.i(TAG, "callNetworkSetting")
    local result = false

    if device.platform == "android" then
        local className = "cn/jj/base/JJActivity"
        local methodName = "callNetworkSetting"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

-- 退出整个应用
function Util:exitApp()
    local result, operator = false, 0

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "exitApp"
        local args = {}
        local sig = "()V"
        result = luaj.callStaticMethod(className, methodName, args, sig)
    elseif not device.platform == "windows" then
    end
end

function Util:getStringSize(text, fontName, fontSize, maxSize)
    local realSize = CCSize(0, 0)

    if device.platform == "android" then
        local result, ret
        local className = "cn/jj/base/StringSize"
        local methodName = "getStringConstrainedSize"
        local args = { text, fontName, fontSize, maxSize.width, maxSize.height }
        local sig = "(Ljava/lang/String;Ljava/lang/String;III)Ljava/lang/String;"
        result, ret = luaj.callStaticMethod(className, methodName, args, sig)
        local retArr = string.split(ret, ",")
        realSize.width = tonumber(retArr[1])
        realSize.height = tonumber(retArr[2])
    elseif device.platform == "ios" then
        realSize = getStringConstrainedSize(text, fontName, fontSize, maxSize)
	elseif device.platform == "mac" then
		realSize = getStringConstrainedSize(text, fontName, fontSize, maxSize)
    end
    return realSize
end

-- 获取手机使用状态
function Util:getStorageSize()
    JJLog.i(TAG, "getStorageSize")
    local value = nil

    if device.platform == "android" then
        local result
        local className = "cn/jj/base/JJUtil"
        local methodName = "getStorageSize"
        local args = {}
        local sig = "()Ljava/lang/String;"
        result, value = luaj.callStaticMethod(className, methodName, args, sig)
        JJLog.i(TAG, "getStorageSize value = ", value)
    elseif device.platform == "ios" then
    end
    return value
    -- return romsize, originalromsize, SDsize, originalSDsize
end

--[[
解析XML时用到，去掉多余的引号
]]
function Util:_catString(str)
    if str == nil then
        return nil
    end
    return string.sub(str, 2, string.len(str) - 1)
end

-- 跳转浏览器的接口
-- 需要传入 URL地址
-- url 需要 "http://"前缀
function Util:openSystemBrowser(url)
    JJLog.i(TAG, "openSystemBrowser")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "openSystemBrowser"
        local args = { url }
        local sig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "UtilController"
        local methodName = "openSystemBrowser"
        local args = {
        _url = url,
        }
        result, operator = luaoc.callStaticMethod(className,methodName,args)
    end
end

function Util:registerConnectivity(callback)
    JJLog.i(TAG, "registerConnectivity")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "registerConnectivity"
        local args = { callback }
        local sig = "(I)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
end

function Util:unRegisterConnectivity()
    JJLog.i(TAG, "unRegisterConnectivity")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "unRegisterConnectivity"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
end

function Util:registerBatteryReceiver(callback)
    JJLog.i(TAG, "registerBatteryReceiver")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "registerBatteryReceiver"
        local args = { callback }
        local sig = "(I)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "BatteryController"
        local methodName = "registerBatteryReceiver"
        local args = { listener = callback }
        local ok, ret = luaoc.callStaticMethod(className,methodName,args)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end
    end
end

function Util:unRegisterBatteryReceiver()
    JJLog.i(TAG, "unRegisterBatteryReceiver")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "unRegisterBatteryReceiver"
        local args = {}
        local sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "BatteryController"
        local methodName = "releaseSharedBatteryController"
        local ok, ret = luaoc.callStaticMethod(className,methodName)
        if not ok then
            print(string.format(" -- call API failure, error code: %s",tostring(ret)))
        end
    end
end

function Util:stringStartWith(str, substr)
    if str ~= nil and substr ~= nil then
        if string.find(str, substr) == 1 then
            return true
        end
    end
    return false
end

--[[
	判断运营商SIM卡
]]
function Util:isCMSim()
    local imsi = self:getIMSI()
    JJLog.i(TAG, "isCMSim imsi = ", imsi)
    if self:stringStartWith(imsi, "46000") or self:stringStartWith(imsi, "46002") or self:stringStartWith(imsi, "46007") then
        return true
    end
    return false
end

function Util:isCUSim()
    local imsi = self:getIMSI()
    JJLog.i(TAG, "isCUSim imsi = ", imsi)
    if self:stringStartWith(imsi, "46001") then
        return true
    end
    return false
end

function Util:isCTSim()
    local imsi = self:getIMSI()
    JJLog.i(TAG, "isCTSim imsi = ", imsi)
    if self:stringStartWith(imsi, "46003") or self:stringStartWith(imsi, "46005") then
        return true
    end
    return false
end

function Util:getInstalledGameLocation(pkgName)
    local result, value

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getInstalledGameLocation"
        local args = { pkgName }
        local sig = "(Ljava/lang/String;)Z"
        result, value = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
    return value
end

function Util:computeInstalledGamesSize(pkgName, callback)
    local result, value

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "computeInstalledGamesSize"
        local args = { pkgName, callback }
        local sig = "(Ljava/lang/String;I)V"
        result, value = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
    return value
end

function Util:getInstalledGameSize(pkgName)
    local result, value

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getInstalledGameSize"
        local args = { pkgName }
        local sig = "(Ljava/lang/String;)Ljava/lang/String;"
        result, value = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
    return value
end

function Util:unInstallGame(pkgName)
    JJLog.i(TAG, "unInstallGame")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "unInstallGame"
        local args = { pkgName }
        local sig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
end

function Util:appEnterBackGround()
    JJLog.i(TAG, "appEnterBackGround")
    isActive = false
end

function Util:appEnterForeGround()
    JJLog.i(TAG, "appEnterForeGround")
    isActive = true
end

function Util:isAppActive()
    return isActive
end

function Util:getBackground()
    JJLog.i(TAG, "getBackground")
    local result, isBackground

    if device.platform == "android" then
        local className = "cn/jj/base/JJActivity"
        local methodName = "getBackground"
        local args = {}
        local sig = "()Z"
        result, isBackground = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
    return isBackground
end

function Util:isAppBackground()
    JJLog.i(TAG, "isAppBackground")
    local result, isBackground
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "isAppBackground"
        local args = {}
        local sig = "()Z"
        result, isBackground = luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
    end
    return isBackground
end

function Util:setFrameTick(tick)
    JJLog.i(TAG, "setFrameTick")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "setFrameTick"
        local args = { tick }
        local sig = "(I)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    end
end

function Util:getLocalSdkVer()
    local versions = require("script_version_in_client")
    local sdkVer = versions.sdk
    return sdkVer
end

function Util:supportFunction(funcName)
    local support = false
    if self:getLocalSdkVer() > 1103 and funcName ~= nil and type(JJFunctionManager) ~= nil then
        support = JJFunctionManager:instance():supportFunction(funcName)
    end
    return support
end

function Util:isWap()
    local netType = self:getNetworkType()
    return toint(netType) == 3
end

function Util:setWapProxy(request)
    -- TODO just for China Mobile at present
    local ip, port
    local operater = self:getOperator()
    if operater == "CMCC" then
        ip = "10.0.0.172"
        port = 80
    end
    if ip == nil or port == nil then
        return
    end
    if tolua.type(request) == "CCHTTPRequest" and self:getLocalSdkVer() > 1103 and type(JJFunctionManager) ~= nil then
        if JJFunctionManager:instance():supportFunction("setWapProxy") then
            request:setWapProxy(ip, port)
        end
    end
end

function Util:isG10086()
    JJLog.i(TAG, "isG10086 PROMOTER_ID = ", PROMOTER_ID)    
    return PROMOTER_ID == 50256 or PROMOTER_ID == 50414 or PROMOTER_ID == 50694 or PROMOTER_ID == 30005
end

function Util:isG10010()
    return PROMOTER_ID == 50080 or PROMOTER_ID == 50583 or PROMOTER_ID == 38427
end

function Util:isEgame()
    return PROMOTER_ID == 50276
end

function Util:dial(phonenumber) 
    local prefix = "+86"
    if phonenumber ~= nil and type(phonenumber) == "string" and phonenumber ~= prefix then
        --检查输入串是否合法,后续根据号码规定补全，java层不再检测
        --判断+86开头 
        local i,j = string.find(phonenumber,prefix)
        local str = phonenumber

        if i == 1 then
            str = string.sub(phonenumber,j+1,-1)
        else
            prefix = ""
        end
        --去除非数字
        str = string.gsub(str,"%D","")
        
        if str ~= nil and string.len(str) > 0 then
            if device.platform == "android" then
                className = "cn/jj/base/JJUtil"
                methodName = "call"
                args = {prefix..str}
                sig = "(Ljava/lang/String;)V"
                result, model = luaj.callStaticMethod(className, methodName, args, sig)
                JJLog.i(TAG, "result = ",result,"model = ",model)       
            elseif not device.platform == "windows" then
            
            end
        end
    end
end

function Util:registerLuaLogReportNickname(nickname)
    print(TAG, "_registerLuaLogReportPackageId")
    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "registerLuaLogReportNickname"
        local args = { nickname }
        local sig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    end
end

function Util:decompressGzipStringData(data, len)
    local ret
    if self:supportFunction("gzipDecompressStringLua") then
        ret = JJZipUtil:instance():gzipDecompressStringLua(data, len);
    end
    return ret
end

function Util:isQihu360()
    return PROMOTER_ID == 50694
end  

function Util:isKuaiya()
    return PROMOTER_ID == 35131
end

--是否是嘻哈茶馆斗地主包，是返回true
function Util:isXhcg()
    return ORIGINAL_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_SINGLE_XHCG
end

function Util:getDcimPath()
    local value = device.writablePath .. "data", result
    if device.platform == "android" then
        if Util:supportFunction("updateDcimFile") then
            className = "cn/jj/base/JJUtil"
            methodName = "getDcimPath"
            local args = {}
            local sig = "()Ljava/lang/String;"
            result, value = luaj.callStaticMethod(className, methodName, args, sig)
        end
    elseif device.platform == "ios" then

    end
    return value
end

function Util:updateDcimFile(file)
    if Util:supportFunction("updateDcimFile") then 
        if device.platform == "android" then
            className = "cn/jj/base/JJUtil"
            methodName = "updateDcimFile"
            local args = { file }
            local sig = "(Ljava/lang/String;)V"
            luaj.callStaticMethod(className, methodName, args, sig)
        end
    end
end

--[[
    是否是函数
    @value: 需要判断的值
]]
function Util:isFunction(value)
    return type(value) == "function"
end

return Util
