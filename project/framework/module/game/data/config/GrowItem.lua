local GrowItem = class("GrowItem")
require("sdk.xml.LuaXml")

function GrowItem:ctor()
	self.growId_ = 0
	self.growName_ = ""
	self.growExplain_ = ""
	self.growIntro_ = ""
	self.lastUpdate_ = 0
end

function GrowItem:initData(filePath)
	local path = CCFileUtils:sharedFileUtils():fullPathForFilename(filePath)
	if io.exists(path) ~= true then
		return false
	end
	local xfile = xml.load(path)
	local xmlnode = xfile:find("id")
	if xmlnode ~= nil then
		self.growId_ = tonumber(xmlnode[1])
		xmlnode = nil
	end
	xmlnode = xfile:find("name")
	if xmlnode ~= nil then
		self.growName_ = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("explain")
	if xmlnode ~= nil then
		self.growExplain_ = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("intro")
	if xmlnode ~= nil then
		self.growIntro = xmlnode[1]
		xmlnode = nil
	end
	xmlnode = xfile:find("uptime")
	if xmlnode ~= nil then
		self.lastUpdate_ = tonumber(xmlnode[1])
		xmlnode = nil
	end	
end

function GrowItem:toXmlStr()	
	local xmlStr = string.format("<grow><id>%d</id><name>%s</name><explain>%s</explain><intro>%s</intro><uptime>%d</uptime></grow>",self.growId_,self.growName_,self.growExplain_,self.growIntro_,self.lastUpdate_)
	return xmlStr
end

return GrowItem