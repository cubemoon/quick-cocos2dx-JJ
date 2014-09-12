local LastLogin = {}
local FILE_NAME = "data/LastLogin.lua"

function LastLogin:saveLastLogin(tick)
    local data = {}
	data.tick = tick
	LuaDataFile.save(data, FILE_NAME)
end

function LastLogin:getLastLogin() 
	local data = LuaDataFile.get(FILE_NAME)
    if data ~= nil and data.tick ~= nil then
        return data.tick
    end
	return 0
end

return LastLogin