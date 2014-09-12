--[[
登录历史数据
Yangzukang	2013.11.15	目前只保存普通登录数据，免注册登录数据只保存类型，不保存数据
]] 
local LoginData = {}
local TAG = "LoginData"

local datas_ = {}
local DATA_FILE_PATH = "data/LoginHistory.lua"

function LoginData:trace()
	JJLog.i(TAG, "all accounts data", vardump(datas_, "datas_"))
end

local function _loadFromDatabase(self)
	local data = nil		
	local ret = nil

    className = "cn/jj/base/JJUtil"
    methodName = "getLoginData"
    args = {false} -- false获取全部数据
    sig = "(Z)Ljava/lang/String;"
    result, data = luaj.callStaticMethod(className, methodName, args, sig)
	JJLog.i(TAG, "result = ",result,"data = ",data)  
  
	if data ~= nil and type(data) == "string" then
		ret = {}
		ret.jj = {}

		local decode = json.decode(data)
		JJLog.i(TAG, "decode = ",type(decode),"content = ",tostring(decode))  

		for _,ld in pairs(decode.data) do 
			JJLog.i(TAG, "name = ",ld.name,"pw = ",ld.password)  
			if ld.name == "jj_lastLoginName" then
				if ld.password == "" then
				  	ret.lastType_ = LOGIN_TYPE_NOREG
				else
					ret.lastType_ = LOGIN_TYPE_JJ
				end
			else
				local item = {} 
				item.name_ = ld.name
				item.pw_ = ld.password
				table.insert(ret.jj, item)
			end
		end
	end
	JJLog.i(TAG, "_loadFromDatabase", vardump(ret, "ret"))
	return ret   	
end	

local function _load(self)

	local ret = nil
	local typeData

	if device.platform == "android" then
		ret = _loadFromDatabase(self)
	else
		ret = LuaDataFile.get(DATA_FILE_PATH)
	end

	return ret
end

local function _save(self)
	local platform = device.platform    	

	if platform ~= "android" then
		LuaDataFile.save(datas_, DATA_FILE_PATH)
	end
end	

-- 初始化数据：从文件读取
function LoginData:init()
	JJLog.i(TAG, "init")
	-- 都没有数据，给默认值
	if datas_ == nil or #datas_ == 0 or datas_.jj == nil or #datas_.jj == 0 then
		datas_ = _load(self) or {}
	end
end

-- 添加一条登录记录
function LoginData:addRecord(loginType, name, pw)
	JJLog.i(TAG, "addRecord, type=" .. loginType)
	datas_.lastType_ = loginType
	if loginType == LOGIN_TYPE_JJ then
		self:saveJJ(name, pw)
	elseif loginType == LOGIN_TYPE_NOREG then
		-- 免注册登录，保存类型就行了 
		if device.platform == "android" then
			self:saveJJ("", "")
		end
	end
	_save(self)
end

-- 类型和用户名应该能确定一条登录数据
function LoginData:removeRecord(loginType, name)
	if self:remove(loginType, name) == true then
		_save(self)
	end
end

-- 获取最后一次登录数据
function LoginData:getLastRecord()
	JJLog.i(TAG, "getLastRecord")
	local item = nil
	if datas_.lastType_ == LOGIN_TYPE_JJ then
		local typeData = datas_["jj"]
		if typeData ~= nil then
			if device.platform == "android" then
				className = "cn/jj/base/JJUtil"
			    methodName = "getLoginData"
			    args = {true}
			    sig = "(Z)Ljava/lang/String;"
			    result, data = luaj.callStaticMethod(className, methodName, args, sig)
				JJLog.i(TAG, "result = ",result,"data = ",data)

				if data~= "{}" then
					local decode = json.decode(data)
					item = {}
					item.name_ = decode.name
					item.pw_ = decode.password
				end
			else
				item = typeData[1]	
			end	

		    if item then
		       	return LOGIN_TYPE_JJ, item.name_, item.pw_       
		    else
		       	return LOGIN_TYPE_NOREG
		    end    
		end
	elseif datas_.lastType_ == LOGIN_TYPE_NOREG then
		return LOGIN_TYPE_NOREG
	end

	return LOGIN_TYPE_NONE
end

-- 保存JJ帐号登录记录
-- last: 是否保存到最后，用于兼容老的数据
function LoginData:saveJJ(name, pw, last)
	JJLog.i(TAG, "saveJJ, name=" .. name .. ", pw=" .. pw .. ", sec="..JJTimeUtil:getCurrentSecond())

	self:remove(LOGIN_TYPE_JJ, name)
	local typeData = datas_["jj"]
	if typeData == nil then
		typeData = {}
		datas_["jj"] = typeData
	end

	if name ~= "" then
		local item = {}
		item.name_ = name
		item.pw_ = pw
		if last then
			typeData[#typeData + 1] = item
		else
			table.insert(typeData, 1, item)
		end
	end

	if device.platform == "android" then
	    className = "cn/jj/base/JJUtil"
        methodName = "saveLoginData"
        args = {name,pw,math.floor(JJTimeUtil:getCurrentSecond()+0.5)}
        sig = "(Ljava/lang/String;Ljava/lang/String;I)V"
        result, model = luaj.callStaticMethod(className, methodName, args, sig)
    	JJLog.i(TAG, "result = ",result,"model = ",model)  
	end
end

-- 获取所有的 JJ 登录信息
function LoginData:getJJ()
	return datas_["jj"]
end

-- 类型和用户名应该能确定一条登录数据，删除成功返回 True，否则 False
function LoginData:remove(loginType, name)
	local key = ""
	
	if loginType == LOGIN_TYPE_JJ then
		key = "jj"
	end
	
	local typeData = datas_[key]
	
	if typeData ~= nil then
		for i,v in ipairs(typeData) do
			if v.name_ == name then
				JJLog.i(TAG,"remove name=",name)
				table.remove(typeData, i)
				if device.platform == "android" then
	    			className = "cn/jj/base/JJUtil"
        			methodName = "deleteLoginData"
        			args = {name,math.floor(JJTimeUtil:getCurrentSecond()+0.5)}
        			sig = "(Ljava/lang/String;I)V"
        			result, model = luaj.callStaticMethod(className, methodName, args, sig)
    				JJLog.i(TAG, "result = ",result,"model = ",model)  
				end
				return true
			end
		end
	end

	return false
end

return LoginData