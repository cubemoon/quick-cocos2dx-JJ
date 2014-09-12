HeadImgManager = {}
local TAG = "HeadImgManager"

local datas_ = nil
local DATA_FILE_PATH = "data/HeadImgData.lua"

local imgCache = require("sdk.cache.ImageCacheManager")

function HeadImgManager:init()
	if datas_ == nil then
		datas_ = LuaDataFile.get(DATA_FILE_PATH)
		if datas_ == nil then
			datas_ = {}
		end
        --JJLog.i(vardump(datas_, TAG))
	end
end

local _save = function()
	JJLog.i(TAG, "_save")
	LuaDataFile.save(datas_, DATA_FILE_PATH)
end

local _getHeadId = function(url, headId)
	JJLog.i(TAG, "_getHeadId, url=", url)
	-- for headId, headUrl in pairs(datas_) do
	-- 	if headUrl == url then
	-- 		return headId
	-- 	end
	-- end
	-- 目前没有使用url匹配获取头像id，回到返回了需要设置的头像id。
	-- 因为现在data中存储value值不唯一，所以不能使用url做循环匹配。
	local id = 0
	if datas_[headId] == url then
		id = headId
	end
	return id
end

local _getImgCB = function(filePath, url, headId)
	JJLog.i(TAG, "_getImgCB, filePath=", filePath, ", url=", url, " headId = ", headId)

	-- 通过本地消息通知机制，通知相应的接口
	local id = _getHeadId(url, headId)
	JJLog.i(TAG, "_getImgCB, id=", id)
	if id ~= nil then
		local message = require("sdk.message.Message").new(GameMsgDef.ID_UPDAGE_HEAD_IMG)
		message.headId = id
        JJSDK:pushMsgToSceneController(message)
	end
end

local function getImgDir(headId)
	local dir = ""
	local tmp = ""
	if headId > 100000 then
		tmp = (math.modf(headId/10000)%10000) .. "/" .. (math.modf(headId/100)%100) .. "/" .. headId%100 .. "/" .. headId..".jpg"
		dir = JJWebViewUrlDef.URL_GET_HEAD_ICON .. tmp
	else
		tmp = headId..".jpg"
		dir = JJWebViewUrlDef.URL_GET_TMP_HEAD_ICON .. tmp
	end
	JJLog.i(TAG, "getImgDir, dir=", dir)
	return dir
end

--[[
	根据头像id获取头像图片的文件路径
	文件存在，返回文件路径
	不存在，返回空，同时像服务器请求相应图片

	注：目前获取头像需要跟PC一致，获取头像需要传入 userid
	头像地址需要放到globalconfig中以便动态配置
	http://www.jj.cn/user_head.php?uid=
]]
function HeadImgManager:getImg(userId, headId)
	figureId = headId
	headId = tostring(headId)
	JJLog.i(TAG, "getImg, headId=", headId, " datas_[headId]= ", datas_[headId], " UserInfo.figureIdBackup_ = ", UserInfo.figureIdBackup_)

	-- 如果不存在临时头像，那么就去获取正式头像
	if datas_[headId] == nil then

		datas_[headId] = getImgDir(figureId)

		-- 如果headdata中不存在此数据，就检查缓存中是否纯在头像数据，如果存在删除从新获取。
		local isexist = imgCache:existUrl(datas_[headId], headId)
		JJLog.i(TAG, "getImg, isexist=", isexist)
		if isexist == true then
			self:delImg(datas_[headId]..headId)
		end
		_save()
	else
		
		local isexist = imgCache:existUrl(datas_[headId],headId)
		JJLog.i(TAG, "getImg, isexist=", isexist)
		if isexist == false then
			datas_[headId] = getImgDir(figureId)
			_save()
		else
			-- 如果头像缓存数据存在，检查是否是临时头像链接，如果是需要获取正式头像
			if datas_[headId] ~= getImgDir(figureId) then
				datas_[headId] = getImgDir(figureId)
				_save()
			end
		end
	end

	return imgCache:downloadImage(datas_[headId], _getImgCB,headId)

	-- if datas_[headId] ~= nil then
	-- 	return imgCache:downloadImage(datas_[headId], _getImgCB)
	-- else
	-- 	HttpMsg:sendGetHeadImgReq(headId, "")
	-- end
end

function HeadImgManager:delImg(headId)
	imgCache:deleteCacheData(getImgDir(headId)..headId)
end

function HeadImgManager:delTmpImg(headId)
	imgCache:deleteCacheData(getImgDir(headId)..headId)
end

function HeadImgManager:handleGetImgAck(headId, url)
	headId = tostring(headId)
	JJLog.i(TAG, "handleGetImgAck, headId=", headId, ", url=", url)
	datas_[headId] = url
	_save()
	imgCache:downloadImage(url, _getImgCB)
end

return HeadImgManager
