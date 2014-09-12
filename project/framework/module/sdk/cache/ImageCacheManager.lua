--[[
	下载图片的缓存管理器
	@author xujh
]]

ImageCacheManager = {}

local TAG = "ImageCacheManager"

local gameState = require(cc.PACKAGE_NAME .. ".api.GameState")

-- 图片缓存信息表，包括下载图片URL对应的md5值和最后更新时间
local cacheData = {}

-- 储存正在下载的图片地址
local downloadUrl = {}

-- 初始化GameState，存储缓存图片相关信息
function ImageCacheManager:init()
	gameState.init(function(param)
		if param.errorCode then
			print("gamestate init error!")
		end
		return param.values
	end, "image_cache.txt", nil)
	if io.exists(gameState.getGameStatePath()) then
		cacheData = gameState.load()
	end
end

--[[
	根据图片的md5值判断是否存在在缓存表中
	@param 图片的md5值
	@return 存在：true以及所在的位置，不存在：false
]]
function ImageCacheManager:exist(md5)
    if cacheData ~= nil then
        for i = 1, #cacheData do
            if cacheData[i].md5 == md5 then
                return true, i
            end
        end
    end
	return false
end

--[[
-- 根据url来判断缓存文件是否存在
-- @param url  文件url
--        id   下载时传入的唯一标示
-- @return 存在：true以及所在的位置，不存在：false
--]]
function ImageCacheManager:existUrl(url, id)
    if type(url) ~= "string" then
        return false
    end
    local content = nil
    if id ~= nil then
        content = url .. id
    else
        content = url
    end
	local md5 = crypto.md5(content, false)
    if cacheData ~= nil then
        for i = 1, #cacheData do
            if cacheData[i].md5 == md5 then
                return true, i
            end
        end
    end
	return false
end

--[[
	修改图片在缓存表中的最后更新时间
	@param md5:图片的md5值, position:图片在缓存表中的位置
]]
function ImageCacheManager:updateCacheTime(md5, position)
    cacheData = cacheData or {}
	if cacheData[position].md5 == md5 then
		local type = cacheData[position].type
		table.remove(cacheData, position)
		local data = {}
		data.time = getCurrentSecond()
		data.md5 = md5
		data.type = type
		self:insertCacheData(data)
	else
		print("ImageCacheManager updateCacheTime ERROR!")
	end
end

--[[
	向图片缓存表中插入数据
	@param data表，包括md5,time和type
]]
function ImageCacheManager:insertCacheData(data)
    cacheData = cacheData or {}
	if table.nums(cacheData) > 1000 then
		-- 超过缓存上限，清除第一个元素（通常最久未更新时间戳）
		local cmd
		if (device.platform == "windows") then
            -- TODO 暂时注释掉保证windows player可以正常运行
			--cmd = string.format("DEL /Q %scache\\%s", device.writablePath, cacheData[1].md5)
		else
            cmd = string.format("rm -r %scache/%s", device.writablePath, cacheData[1].md5)
		end
		print("ImageCacheManager insertCacheData cmd : ", cmd)
		os.execute(cmd)
		table.remove(cacheData, 1)
	end
	table.insert(cacheData, data)
    gameState.save(cacheData)
end

--[[
	下载缓存图片
	@param url 下载图片的URL地址
		   callback 调用下载处的回调函数地址
           id  用来区分存储文件名称的唯一性, 如果url唯一可以不传
]]
function ImageCacheManager:downloadImage(url, callback, id)
    if self:isDownloading(url) then
        return nil
    end
    local content = nil
    if id ~= nil then
        content = url .. id
    else
        content = url
    end
	local md5 = crypto.md5(content, false)
	--local type = string.sub(url, string.len(url) - 3, -1)
	local savePath = string.format("%scache/%s", device.writablePath, md5)
	local exist, pos = self:exist(md5)
	if not exist then
        self:insertDownload(url)
		local request = network.createHTTPRequest(function (event)
			local ok = (event.name == "completed")
			local request = event.request
			if not ok then
                JJLog.i(TAG, "request error ", request:getErrorMessage())
                request:release()
                self:removeDownload(url)
        		return
			end
			local code = request:getResponseStatusCode()
    		if code ~= 200 and code ~= 206 then
                JJLog.i(TAG, "response status code is ", code)
                request:release()
                self:removeDownload(url)
        		return
    		end
            local item = {}
            item.time = getCurrentSecond()
            item.md5 = md5
            self:insertCacheData(item)
            self:removeDownload(url)
            if callback then callback(savePath, url, id) end
            request:release()
		end, url, "GET")
        local util = require("sdk.util.Util")
        if util:isWap() then
            util:setWapProxy(request)
        end
        -- 传递一个空的函数作为下载进度的回调
        request:startDownload(savePath, function() end, false)
	else
		JJLog.i(TAG, "The ", url, " has downloaded.")
		self:updateCacheTime(md5, pos)
		return savePath
	end
end

--[[
	根据需要删除缓存图片，释放存储空间
]]
function ImageCacheManager:gcCache()
    cacheData = cacheData or {}
	for i = #cacheData, 1, -1 do
		local recordTime = cacheData[i].time
		local currentTime = getCurrentSecond()
		if currentTime - recordTime > 7 * 24 * 60 * 60 then
			local cmd
			if (device.platform == "windows") then
                --cmd = string.format("DEL /Q %scache\\%s", device.writablePath, cacheData[i].md5)
			else
				cmd = string.format("rm -r %scache/%s", device.writablePath, cacheData[i].md5)
			end
			JJLog.i(TAG, "gcCache cmd : ", cmd)
			os.execute(cmd)
			table.remove(cacheData, i)
		end
	end
	gameState.save(cacheData)
end

function ImageCacheManager:isDownloading(url)
    downloadUrl = downloadUrl or {}
    for i=1,#downloadUrl do
        if url == downloadUrl[i] then
            return true
        end
    end
    return false
end

function ImageCacheManager:insertDownload(url)
    downloadUrl = downloadUrl or {}
    table.insert(downloadUrl, url)
end

function ImageCacheManager:removeDownload(url)
    downloadUrl = downloadUrl or {}
    local i, count = 1, #downloadUrl
    while i <= count do
        if url == downloadUrl[i] then
            table.remove(downloadUrl, i)
            count = count - 1
            i = i - 1
        end
        i = i + 1
    end
end

function ImageCacheManager:deleteCacheData(url)
	local md5 = crypto.md5(url, false)
    cacheData = cacheData or {}
    local i, count = 1, #cacheData
    --for i=1,#cacheData do
    while i <= count do
        if cacheData[i] ~= nil then
            print("cacheData[i].md5 : ", cacheData[i].md5, " md5 : ", md5)
            if cacheData[i].md5 == md5 then
                local cmd
                if (device.platform == "windows") then
                    --cmd = string.format("DEL /Q %scache\\%s", device.writablePath, cacheData[i].md5)
                else
                    cmd = string.format("rm -r %scache/%s", device.writablePath, cacheData[i].md5)
                end
                JJLog.i(TAG, "deleteCache cmd : ", cmd)
                os.execute(cmd)

                table.remove(cacheData, i)
                count = count - 1
                i = i -1
            end
        end
        i = i + 1
    end
    gameState.save(cacheData)
end

return ImageCacheManager
