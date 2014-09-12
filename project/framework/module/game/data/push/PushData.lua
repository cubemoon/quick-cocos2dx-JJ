local PushData = class("PushData")
local LastLogin = require("game.data.push.LastLogin")

local TAG = "LocalPush"

PushData.TYPE_AD = 0 			-- 推送消息
PushData.TYPE_LOCAL = 1 		-- 周期性的

local ADS_FILE_PATH = "data/PushDataAds.lua"
local LOCAL_FILE_PATH = "data/PushDataLocal.lua"

local datasAds_ = nil
local datasLocal_ = nil

function PushData:ctor()
	self.dataTable = {}
	self.lastAd = ""
	self.lastLocal = ""
	self:init()
end
	
function PushData:init()
	self:readFromFile()
end

--暂时不用	
function PushData:getInstance()
	if self.instance == nil then
		self.instance = PushData.new()
	end
	return instance
end
	
function PushData:readFromFile() 	
	if datasAds_ == nil then
		datasAds_ = LuaDataFile.get(ADS_FILE_PATH)
		if datasAds_ == nil then
			datasAds_ = {}
		end
	end

	if datasLocal_ == nil then
		datasLocal_ = LuaDataFile.get(LOCAL_FILE_PATH)
		if datasLocal_ == nil then
			datasLocal_ = {}
		end
	end
	-- 排序
	self:sort()
	self:checkInvalid()

	--JJLog.i("readFromFile1222---------------= ",#datasAds_,#datasLocal_)
end

function PushData:writeToFile( )
	--JJLog.i("writeToFile---------------= ",#datasAds_,#datasLocal_,ADS_FILE_PATH)
	--datasAds_ = {}
	if datasAds_ == nil then
		datasAds_ = {}
	end

	if datasLocal_ == nil then
		datasLocal_ = {}
	end

	LuaDataFile.save(datasAds_, ADS_FILE_PATH)
	LuaDataFile.save(datasLocal_, LOCAL_FILE_PATH)
end

function PushData:addPushItem(type, item)
	local list = nil
	JJLog.i("addPushItem---------------------------------------= ",type,item.update , self.lastLocal,self.lastAd)
	if type == PushData.TYPE_LOCAL then
		list = datasLocal_
		if item.update > self.lastLocal then
			self.lastLocal = item.update
		end
	else
		list = datasAds_
		if item.update > self.lastAd then
			self.lastAd = item.update
		end
	end

	for i,pushitem in ipairs(list) do
		if pushitem.id == item.id then		
			table.remove(list, i)
			break
		end
	end
	table.insert(list, item)

	--JJLog.i("addPushItem3355---------------------------------------= ",type,#list,item.update , self.lastLocal,self.lastAd)

	-- 排序
	--self:sort()

	self:writeToFile()
end	

-- 获取当前最近的一个提示：无论是那种类型
function PushData:getNearest( )
	local now = math.floor(JJTimeUtil:getCurrentServerTime() / 1000)
	local tick = 0
	local nSize = #datasAds_

	for i = 1, nSize do
		if datasAds_[i] ~= nil then
			local tmp = datasAds_[i].timeLine
			if tmp > now then
				tick = tmp
				break
			end
		end
	end

	local nLocalSize = #datasLocal_
	for i = 1, nLocalSize do	
		if datasLocal_[i] ~= nil then
			local tmp = datasLocal_[i].timeLine + math.floor(LastLogin:getLastLogin() / 1000)
			
			if tmp > now then
				if tick == 0 or tick > tmp then
					tick = tmp
				end
				break
			end
		end
	end

	return tick
end
	
-- 获取当前最近的一个提示：无论是那种类型
function PushData:getAllDatasTable( )
	local now = math.floor(JJTimeUtil:getCurrentServerTime() / 1000)
	local tick = 0
	local ticklist = {}
	local nSize = 0

	if datasAds_ and #datasAds_ ~= 0 then
		nSize = #datasAds_
		for i = 1, nSize do
			if datasAds_[i] ~= nil then
				local tmp = datasAds_[i].timeLine
				if tmp > now then
					--tick = tmp
					JJLog.i(TAG, "getAllDatasTable---------------- = ", tmp)
					table.insert(ticklist, tmp)
				end
			end
		end
	end

	local nLocalSize = 0

	if datasLocal_ and #datasLocal_ ~= 0 then
		nLocalSize = #datasLocal_
		for i = 1, nLocalSize do	
			if datasLocal_[i] ~= nil then
				local tmp = datasLocal_[i].timeLine + math.floor(LastLogin:getLastLogin() / 1000)
				JJLog.i(TAG, "datasLocal_1222---------------- = ",tmp,now,datasLocal_[i].timeLine)			
				if tmp > now then
					if tick == 0 or tick > tmp then
						tick = tmp
						table.insert(ticklist, tmp)
					end				
				end
			end
		end
	end
	return ticklist
end

-- 时间有误差
local TIMEOUT_DELAY = 30
function PushData:getPushItem(tick)
	local ret = nil
	local dataType = -1
	if datasAds_ and #datasAds_ ~= 0 then
		for i,item in ipairs(datasAds_) do
			if math.abs(item.timeLine - tick) < TIMEOUT_DELAY then
				ret = item
				dataType = PushData.TYPE_AD
				break
			end
		end
	end
	if ret == nil then
		local  last = math.floor(LastLogin.getLastLogin() / 1000)
		if datasLocal_ and #datasLocal_ ~= 0 then
			for i,item in ipairs(datasLocal_) do
				if math.abs(item.timeLine + last - tick) < TIMEOUT_DELAY then
					ret = item
					dataType = PushData.TYPE_LOCAL
					break
				end
			end
		end
	end
	JJLog.i("getPushItem ----------------= ",ret,tick)
	return dataType,ret
end

-- 检查过期的
function PushData:checkInvalid( )
	local now = math.floor(JJTimeUtil:getCurrentServerTime() / 1000)
	if datasAds_ and #datasAds_ ~= 0 then
		for i,item in ipairs(datasAds_) do
			JJLog.i("timeLine = ",item.timeLine,now,#datasAds_)
			if item.timeLine ~= nil then
				if item.timeLine < now then
					table.remove(datasAds_, i)				
				end
			end
		end
	end
	self:writeToFile()
end

-- 获取时间戳
function PushData:getLastUpdate(type)
	local tick = ((type == PushData.TYPE_AD) and self.lastAd) or self.lastLocal

	JJLog.i(TAG, "getLastUpdate, type=", type,tick,self.lastAd,self.lastLocal)
	return tick
end

-- 排序
function PushData:sort( )
	if datasAds_ and #datasAds_ ~= 0 then
		table.sort(datasAds_, function(a, b) return a.timeLine > b.timeLine end)
	end
	if datasLocal_ and #datasLocal_ ~= 0 then
		table.sort(datasLocal_, function(a, b) return a.timeLine > b.timeLine end)
	end
end


return PushData