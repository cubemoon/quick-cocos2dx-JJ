--[[
	将 Lua 文件作为数据文件使用
]]
LuaDataFile = {}
local TAG = "LuaDataFile"

-- local crypto = require("framework.crypto")

-- 从 Lua 文件中获取数据
function LuaDataFile.get(filePath)
    local table = nil
    if JJFileUtil:exist(filePath) then
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

-- 为了兼容数字字符串作为 key 的情况
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

-- 将 Lua Table dump 到文件中，默认是加密的
function LuaDataFile.save(data, filePath, encode)
	JJLog.i(TAG, "save, filePath=", filePath)
    local jsonTable = json.encode(data)
    JJFileUtil:writeFile(filePath, jsonTable)
end

--将table转换为string的接口
function LuaDataFile.table2string(data)
    local buf = _vardumpEx(data)
    buf = string.sub(buf, string.len("[\"<var>\"]") + 3)

    return buf
end

return LuaDataFile