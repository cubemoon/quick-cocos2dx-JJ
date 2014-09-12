UpgradeUtil = {}

require("Promoter")

local TAG = "UpgradeUtil"

-- 获取客户端版本号
function UpgradeUtil:getClientVersion()
	local result, version = false, "99999"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getClientVersion"
		args = {}
		sig = "()I"
		result, version = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return version
end

function UpgradeUtil:getLuaVersion(packageName)
    --local version = 0
    --if self:exist(packageName .. "/config.lua") then
        --version = require(packageName .. ".config").version_ or 0
    --end
    local config = require(packageName .. ".config")
    if type(config) == "boolean" then
        print("UpgradeUtil getLuaVersion require config is boolean, name : ", packageName)
        return 0
    end
    local version = config.version_ or 0
    print(TAG, "getLuaVersion IN version : ", version, " and packageName : ", packageName)
    return version
end

function UpgradeUtil:exist(filePath)
    local path = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
    local ret = CCFileUtils:sharedFileUtils():isFileExist(path) or false
	return ret
end

function UpgradeUtil:writeFile(filePath, content, mode, encrypt)
    local path = filePath
    if device.platform == "windows" then
        path = string.gsub(filePath, "/", "\\")
    end

    if not self:isAbsolutePath(filePath) then
		path = device.writablePath .. filePath
	end
	local pathInfo = self:pathinfo(path)
	if not self:exist(pathInfo.dirname) then
		self:mkdir(filePath)
	end
    local res = 0;
    if encrypt then
        if not io.writefile(path, "JJXX", "w") then
            res = 1
        end
        if not io.writefile(path, crypto.encryptXXTEA(content, "jjmatch"), "a+") then
            res = 1
        end
    else
        if not io.writefile(path, content, mode) then
            res = 1
        end
    end

    return res == 0
end

function UpgradeUtil:pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        elseif b == 92 then -- 92 = char "\"
        	break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

-- 建立文件夹，递归进行，从 writable 目录往下
function UpgradeUtil:mkdir(path)
	local isAbs = self:isAbsolutePath(path)
	if self:exist(path) then
		return
	end

	local separate = "/"

	local i = string.find(path, separate, 1)

	while i ~= nil do
		local separtePath = string.sub(path, 1, i)

		local tmp = separtePath
		if not isAbs then
			tmp = device.writablePath .. separtePath
		end

		if not self:exist(tmp) then
      		if device.platform == "ios" or device.platform == "windows" then
      			CCFileUtils:sharedFileUtils():createPath(separtePath)
      		else
      			os.execute(('mkdir ' .. tmp))
      		end
		end

		i = string.find(path, separate, i + 1)
	end
end

local _vardumpEx = function(object, label)
    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        if type(v) == "boolean" then
            -- Debug: boolean for gsub will crash
        else
            v = string.gsub(v, string.char(10), "\\n")
        end
        return tostring(v)
    end

    local function _vardump(object, label, indent, nest)
        label = label or "<var>"
        local postfix = ""
        if nest > 1 then postfix = "," end
        if type(object) ~= "table" then
            if type(label) == "string" then
                result[#result +1] = string.format("%s[\"%s\"] = %s%s", indent, label, _v(object), postfix)
            else
                result[#result +1] = string.format("%s%s%s", indent, _v(object), postfix)
            end
        elseif not lookupTable[object] then
            lookupTable[object] = true

            if type(label) == "string" then
                result[#result +1 ] = string.format("%s[\"%s\"] = {", indent, label)
            else
                result[#result +1 ] = string.format("%s{", indent)
            end
            local indent2 = indent .. "    "
            local keys = {}
            local values = {}
            for k, v in pairs(object) do
                keys[#keys + 1] = k
                values[k] = v
            end
            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)
            for i, k in ipairs(keys) do
                _vardump(values[k], k, indent2, nest + 1)
            end
            result[#result +1] = string.format("%s}%s", indent, postfix)
        end
    end
    _vardump(object, label, "", 1)

    return table.concat(result, "\n")
end

function UpgradeUtil:save(data, filePath, encode)
	local buf = _vardumpEx(data)
	buf = "return " .. string.sub(buf, string.len("[\"<var>\"]") + 3)
    local ret = 0
    if encode == true then
        if not self:writeFile(filePath, "JJXX") then
            ret = 1
        end
        if not self:writeFile(filePath, crypto.encryptXXTEA(buf, "jjmatch"), "a+") then
            ret = 1
        end
    else
        if not self:writeFile(filePath, buf) then
            ret = 1
        end
    end
    return ret == 0
end

function UpgradeUtil:saveJson(t, path)
    local jsonStr = json.encode(t)
    return self:writeFile(path, jsonStr)
end

function UpgradeUtil:getJson(filePath)
    local table = nil
    if self:exist(filePath) then
        local size = 0
        local tmp, size = CCFileUtils:sharedFileUtils():getFileData(filePath, "r", size)
        if (tmp ~= nil) then
            tmp = string.sub(tmp, 1, size)
        end
        if size > 0 then
            table = json.decode(tmp)
        end
    end
    return table
end

function UpgradeUtil:getPackageVersion(packageName)
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

function UpgradeUtil:isAbsolutePath(path)
	if device.platform == "windows" then
		-- 路径第二个字符为":"
		local head = string.sub(path, 2, 2)
		return head == ":"
	else
		-- 路径第一个字符为"/"
		return string.sub(path, 0, 1) == "/"
	end
end

-- 获取屏幕宽高
function UpgradeUtil:getScreenSize()
	local result, size = false, "unknow"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getScreenSize"
		args = {}
		sig = "()Ljava/lang/String;"
		result, size = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return size
end

-- 获取设备名
function UpgradeUtil:getDeviceModel()
	local result, model = false, "unknow"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getDeviceModel"
		args = {}
		sig = "()Ljava/lang/String;"
		result, model = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return model
end

-- 获取系统版本号
function UpgradeUtil:getSysVersion()
	local result, sysVersion = false, "unknow"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getSysVersion"
		args = {}
		sig = "()Ljava/lang/String;"
		result, sysVersion = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return sysVersion
end

-- 获取 Mac
function UpgradeUtil:getMacAddress()
	local result, mac = false, ""
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "GetLocalData"
		args = {"mac"}
		sig = "(Ljava/lang/String;)Ljava/lang/String;"
		result, mac = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return mac
end

-- 获取 IMEI
function UpgradeUtil:getIMEI()
    -- 默认生成一个随机的IMEI
    local save = CCUserDefault:sharedUserDefault()
    math.randomseed(os.time())
    local randomNum = os.time() .. math.random(10000, 99999)
	--local result, imei = false, os.time() .. math.random(10000, 99999)
    local result, imei = false, save:getStringForKey("random_imei", randomNum)
    save:setStringForKey("random_imei", imei)
    save:flush()
	local className, methodName, args, sig
	if device.platform == "android" then
        className = "cn/jj/base/JJUtil"
        methodName = "GetLocalData"
        args = {"imei"}
        sig = "(Ljava/lang/String;)Ljava/lang/String;"
        result, imei = luaj.callStaticMethod(className, methodName, args, sig)
        if imei == nil or imei == "" then
            imei = save:getStringForKey("random_imei", imei)
        end
	elseif not device.platform == "windows" then

	end
	return imei
end

-- 获取 IMSI
function UpgradeUtil:getIMSI()
	local result, imsi = false, ""
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getIMSI"
		args = {}
		sig = "()Ljava/lang/String;"
		result, imsi = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return imsi
end

-- 获取 ICCID
function UpgradeUtil:getICCID()
	local result, iccid = false, ""
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getICCID"
		args = {}
		sig = "()Ljava/lang/String;"
		result, iccid = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return iccid
end

-- 获取处理器架构
function UpgradeUtil:getProcessor()
	local result, processor = false, ""
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getProcessor"
		args = {}
		sig = "()Ljava/lang/String;"
		result, processor = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return processor
end

-- 获取当前网络类型
function UpgradeUtil:getNetworkType()
	local result, type = false, 0
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getNetworkType"
		args = {}
		sig = "()I"
		result, type = luaj.callStaticMethod(className, methodName, args, sig)
	else -- if device.platform == "windows" then
		type = 1
	end
	return type
end

-- 获取网络名
function UpgradeUtil:getNetworkName()
	local result, name = false, "unknow"
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getConnectTypeName"
		args = {}
		sig = "()Ljava/lang/String;"
		result, name = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return name
end

-- 获取运营商
function UpgradeUtil:getOperator()
	local result, operator = false, 0
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJUtil"
		methodName = "getOperator"
		args = {}
		sig = "()Ljava/lang/String;"
		result, operator = luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
	return operator
end

function UpgradeUtil:getExternalStoragePath()
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

function UpgradeUtil:getToken()
	local version = self:getClientVersion()
	local promoteId = PROMOTER_ID
	local imei = self:getIMEI()
    print("UpgradeUtil getToken imei : ", imei)
	local token = string.format("%d%%%d%%%d%%%s", ORIGINAL_PACKAGE_ID, PROMOTER_ID, version, imei)
    local md5 = crypto.md5(token, false)
	print(TAG, "token : ", token, " and md5 : ", md5)
	return md5
end

-- 调用网络设置
function UpgradeUtil:callNetworkSetting()
	print(TAG, "callNetworkSetting")
	local result = false
	local className, methodName, args, sig
	if device.platform == "android" then
		className = "cn/jj/base/JJActivity"
		methodName = "callNetworkSetting"
		args = {}
		sig = "()V"
		luaj.callStaticMethod(className, methodName, args, sig)
	elseif not device.platform == "windows" then

	end
end

-- 获取手机使用状态
function UpgradeUtil:getStorageSize()
    local result, value

	print(TAG, "getStorageSize")
	if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getStorageSize"
        local args = {}
        local sig = "()Ljava/lang/String;"
		result, value = luaj.callStaticMethod(className, methodName, args, sig)
		print(TAG, "getStorageSize value = ", value)
	elseif device.platform == "ios" then

	end
	return value
	-- return romsize, originalromsize, SDsize, originalSDsize
end

function UpgradeUtil:getFileSize(path)
	local fp = io.open(path, "rb")
	if not fp then return 0 end
	local size = fp:seek("end")
	fp:close()
	return size
end

function UpgradeUtil:getServerConfig()
    local serverConfig = self:getJson("config/ServerConfig.json")
    return serverConfig or {}
end

function UpgradeUtil:getLocalSdkVer()
	local versions = require("script_version_in_client")
	local sdkVer = versions.sdk or 1103
	print("UpgradeUtil sdkVer : ", sdkVer)
	return sdkVer
end

function UpgradeUtil:supportFunction(funcName)
	local support = false
	if funcName ~= nil and type(JJFunctionManager) ~= "nil" then
		support = JJFunctionManager:instance():supportFunction(funcName)
	end
	return support
end

function UpgradeUtil:isWap()
	local netType = self:getNetworkType()
	return toint(netType) == 3
end

function UpgradeUtil:setWapProxy(request)
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
	if tolua.type(request) == "CCHTTPRequest" and type(JJFunctionManager) ~= "nil" then
		if JJFunctionManager:instance():supportFunction("setWapProxy") then
			request:setWapProxy(ip, port)
		end
	end
end

function UpgradeUtil:isKuaiya()
    return PROMOTER_ID == 35131
end

function UpgradeUtil:isQihu360()
    return PROMOTER_ID == 50694
end

return UpgradeUtil
