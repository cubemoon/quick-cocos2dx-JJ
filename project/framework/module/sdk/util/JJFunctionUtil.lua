JJFunctionUtil = {}

local TAG = "JJFunctionUtil"

local MIN_SDK_VERSION = 1118

local FUNCTION_LANGUAGE = {
    JAVA = "java",
    CPP  = "cpp"
}

function JJFunctionUtil:_javaClassExist(class)
    local className = "cn/jj/base/JJFunctionUtil"
    local methodName = "classExist"
    local args = {class}
    local sig = "(Ljava/lang/String;)Z"
    local result, exist = luaj.callStaticMethod(className, methodName, args, sig)
    return exist
end

function JJFunctionUtil:_checkMinSdk()
	local versions = require("script_version_in_client")
	local sdkVer = tonum(versions.sdk)
    return sdkVer > MIN_SDK_VERSION
end

--[[
-- 检测新增函数接口本地客户端是否存在
-- @params {
--            language : 数接口语言，见FUNCTION_LANGUAGE，缺省默认为cpp
--            method   : 函数接口名称，cpp类型时格式为类名.函数名的表格名称，如：CCNode.create
--            class    : Java函数接口的完整类名，如："cn/jj/base/Util"
--            sig      : Java函数接口签名，如："(Ljava/lang/String;)Z"
--         }
--]]
function JJFunctionUtil:exist(params)
	local support = false
    if params.language == FUNCTION_LANGUAGE.JAVA then
        if device.platform == "android" and self:_checkMinSdk() and self:_javaClassExist(params.class) then
            local className = params.class
            local methodName = params.method
            local sig = params.sig
            support = FunctionUtil.isJavaMethodExist(className, methodName, sig)
        end
    else
        if params.method ~= nil then
            support = tolua.type(params.method) == "function"
        end
    end
	return support
end

return JJFunctionUtil
