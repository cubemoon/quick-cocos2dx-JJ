-- matchconfig 信息描述

local MatchConfigItem = class("MatchConfigItem")
require("sdk.xml.LuaXml")
function MatchConfigItem:ctor()
	self.productId_ = 0
	self.productName_ = ""
	self.category_ = 0
	self.matchType_ = 0
	self.minPlayers_ = 0
	self.maxPlayers_ = 0
	self.lastUpdate_ = 0
	self.hot_ = 0
	self.serial_ = 0
	self.matchIntro_ = ""
	self.status_ = 0
	self.aclass_ = false
	self.color_ = 0
	self.awardList_ = {}
	self.desk_ = 0
	self.signupFee_ = ""
end

--解析matchconfig.xml文件得到tourneyinfo
function MatchConfigItem:getMatchCongfigItem(filePath)

	local path = device.writablePath .. filePath
	-- TODO：兼容Android，发现文件不存在与读写目录下，就从预置里面拷贝出来
	if not io.exists(path) then
		local nSize = 0
		path = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
		local data = CCFileUtils:sharedFileUtils():getFileData(path, "rb", nSize)
		if data ~= nil then
			JJFileUtil:writeFile(filePath, data, "wb")
		end
	end

	path = JJFileUtil:getFullPath(filePath)
	if path == nil then
		return false
	end

	local xfile = xml.load(path)
	local xmlnode = xfile:find("productId")
	if xmlnode ~= nil then
		self.productId_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("productName")
	if xmlnode ~= nil then
		self.productName_ = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("categoryId")
	if xmlnode ~= nil and self.category_ ==0 then
		self.category_ = tonumber(xmlnode[1])
		xmlnode = nil
	end		
	xmlnode = xfile:find("newCategoryId")
	if xmlnode ~= nil then
		self.category_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("matchType")
	if xmlnode ~= nil then
		self.matchType_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("minPlayer")
	if xmlnode ~= nil then
		self.minPlayers_ = tonumber(xmlnode[1])
		xmlnode = nil 
	end
	xmlnode = xfile:find("maxPlayer")
	if xmlnode ~= nil then
		self.maxPlayers_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("lastUpdate")
    if xmlnode ~= nil then
		self.lastUpdate_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("hot")
	if xmlnode ~= nil then
		self.hot_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("serial")
	if xmlnode ~= nil then
		self.serial_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("intro")
	if xmlnode ~= nil then		
		self.matchIntro_ = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("status")
	if xmlnode ~= nil then
		self.status_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("desk")
	if xmlnode ~= nil then
		self.desk_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("amatch")
	if xmlnode ~= nil then
		self.aclass_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("exes")
	if xmlnode ~= nil then
		self.signupFee_ = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("color")
	if xmlnode ~= nil then
		self.color_ = tonumber(xmlnode[1])
		xmlnode = nil
	end	
	local awards = xfile:find("awards")	
	for i = 1, #awards do
		if awards[i]:find("position") ~= nil then
			local award = {}
			award["position"] = awards[i]:find("position")[1]
			award["description"] = awards[i]:find("desc")[1]
			award["serial"] = tonumber(awards[i]:find("serial")[1])
			self.awardList_[i] = award			
		end
	end     
	return true
end

return MatchConfigItem