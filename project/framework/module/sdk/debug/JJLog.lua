--[[
	日志：参数用 , 隔断，不要用 .. 来连接，在非 string 类型时容易出错
]]

-- require("sdk.util.Util")
require("sdk.file.JJFileUtil")
require("sdk.file.LuaDataFile")
local ui = import("sdk.ui.init")
JJLog = {}

local DEBUG_ON = false
local DEBUG_MODE_FILE = false
local DEBUG_MSG_ON = false

local LEVEL_INFO = 1
local LEVEL_ERROR = 10
local DEBUG_LEVEL = LEVEL_INFO
local externalPath = JJFileUtil:getExternalStorageDirectory()
local path = ""
local logfile = ""
if string.len(externalPath) > 0 then
	path = externalPath.."/".."JJLogConfig.txt"
	logfile = externalPath.."/jjlog.txt"
else
	path = "JJLogConfig.txt"

	if device.platform ~= "android" then
		logfile = CCFileUtils:sharedFileUtils():getWritablePath()
		logfile = logfile.."jjlog.txt"
	else
		-- print("externalPath=", externalPath)
		logfile = externalPath.."/jjlog.txt"
	end
end


-- print("[LQT]: logfile=", logfile)
lua_setLogPath(logfile)
-- JJFileUtil:writeFile(logfile, " ", "wb")

local uiList = {}

-- print("[LQT-----LQT]")

-- print(vardump(ui))
for k, v in pairs(ui) do
	uiList[k] = true
	-- print("[LQT]ui--->", k)
end
-- print("[LQT-----LQT] end")


local size = 0
local tmp, size = CCFileUtils:sharedFileUtils():getFileData(path, "r", size)

-- print("[LQT]: tmp=", tmp)
-- print("[LQT] size=", size)
local filterList = {
	
}

if tmp ~= nil and string.len(tmp) > 0 then
	local b = 0
	local e = 0
	while true do
		b, e = string.find(tmp, ",\n")
		
		if b == nil then break end

		local k = string.sub(tmp, 1, b-1)
		filterList[k] = true
		tmp = string.sub(tmp, e+1)
	end
end

if size > 0 then
	DEBUG_ON = filterList["#OpenLog#"]
	DEBUG_MODE_FILE = filterList["#SaveToFile#"]
end

print(vardump(filterList, "filterList"))

function JJLog.i(tag, ...)

	if DEBUG_ON ~= true then
		return
	end

	if tag == nil then tag = "nil" end

	if JJLog._isFilterMode(tag) ~= true then
		return
	else
		-- print("[LQT]: tag=", tag, "is in filter mode!")
	end 

	if DEBUG_MODE_FILE ~= true then
		jjprint("[I]".."["..tag.."]", ...)
	else
		jjprint("#SaveToFile#", "[I]".."["..tag.."]", ...)
	end


end

function JJLog.e(tag, ...)
	if DEBUG_ON ~= true then
		return 
	end

	if DEBUG_MODE_FILE ~= true then
		jjprint("[E]".."["..tag.."]", ...)
	else
		jjprint("#SaveToFile#", "[E]".."["..tag.."]", ...)
	end

end


--打印消息类型、名称
function JJLog.printNetMsg(tag, msg)

	if DEBUG_MSG_ON ~= true then
		return
	end

	local category, msgType
    for i, v in pairs(msg) do
        if type(v) == "table" then
            category = i
            for ii, vv in pairs(msg[i]) do
                if type(vv) == "table" then
                    msgType = ii
                    break
                end
            end
            break
        end
    end
    jjprint("[MSG]".." ["..tag.."]: "..(category or "nil").." | "..(msgType or "nil"))
end

function JJLog._isFilterMode(tag)

	if size == 0  then

		return true
	else
		if filterList["*"] == true  then
			return true
		elseif filterList["NotUI"] == true then
			if uiList[tag] ~= nil then
				return false
			else
				return true
			end
		elseif filterList[tag] == true then
			return true
		end
	end
	return false
end

function JJLog.setDebug(flag)
	if flag == nil then return end
	if flag == true then
		DEBUG_ON = true
	else
		DEBUG_ON = false
	end
end

function JJLog.isDebug()
	return DEBUG_ON
end

function JJLog.setWriteToFile(flag)
	if flag == nil then return end

	if flag == true then
		DEBUG_MODE_FILE = true
	else
		DEBUG_MODE_FILE = false
	end
end

function JJLog.isWriteToFile()
	return DEBUG_MODE_FILE
end

return JJLog
