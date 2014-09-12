--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 14-3-25
-- Time: 下午8:02
-- To change this template use File | Settings | File Templates.
--

MoreGameManager = {}

local TAG = "MoreGameManager"

require("game.pb.HttpMsg")
local imgCache = require("sdk.cache.ImageCacheManager")

local currentPackageId = nil
local getPackageDatas = function ()
    return "data/" .. currentPackageId .. "_MoreGames.lua"
end

--是否显示更多游戏按钮
local isDisplay = false

--[[存储所有游戏数据
id
jumpUrl
jumpName
state
order
imageUrl
uptime
imgpre
bootparam
--]]
local Datas = nil

--[[
imgpre":"http:\/\/image.m.jj.cn\/game\/","uptime":1395805713}
--]]
local Attrs = nil

function MoreGameManager:sendCheckMoreGameReq(packageid)
    JJLog.i(TAG, "sendCheckMoreGameReq", packageid)

    if(currentPackageId ~= packageid) then
        HttpMsg:sendCheckMoreGameReq(packageid, 1)
        currentPackageId = packageid
        Datas = {}
        Attrs = {}
    end
end

function MoreGameManager:sendGetMoreGameReq(packageid)
    local uptime = 0

    --增加内部处理，当更新更多游戏列表前，检测是否已经初始化完毕，如果没有则先从已经保存的文件系统初始化
    local datas = self:getDatas()
    if (datas == nil) then
        self:initFromFile()
    end

    if (Attrs) then
        uptime = Attrs.uptime
    end

    JJLog.i(TAG, "sendGetMoreGameReq", packageid, uptime)
    HttpMsg:sendGetMoreGameReq(packageid, uptime)
end

function MoreGameManager:handleCPCheckMoreGameAck(datas, attr)
    JJLog.i(TAG, "handleCPCheckMoreGameAck")

    if (attr) then
        local value = attr.display

        if (value == true) then
            isDisplay = true
        end
    end

    if(isDisplay) then
        self:sendGetMoreGameReq(currentPackageId)
    end
end

function MoreGameManager:handleCPGetMoreGameAck(datas, attr)
    JJLog.i(TAG, "handleCPGetMoreGameAck")

    if (attr) then
        Attrs = attr
    end

    if (datas) then
        for k, v in pairs(datas) do
            Datas[v.id] = v
        end

        local update = #datas
        if (update > 0) then
            local save = {}
            save.datas = Datas
            save.attr = Attrs
            LuaDataFile.save(save, getPackageDatas())
        end
    end

    self:updateDisplayDatas()
end

function MoreGameManager:initFromFile()
    JJLog.i(TAG, "initFromFile")
    local save = LuaDataFile.get(getPackageDatas())

    if (save and typen(save) == table) then
        Datas = save.datas
        Attrs = save.attr
    else
        Datas = {}
        Attrs = {}
    end
end

local DisplayDatas = {}
local sendDownloadedMsg = function(item)
    JJLog.i(TAG, "sendDownloadedMsg")

    local message = require("sdk.message.Message").new(GameMsgDef.ID_MOREGAME_DOWNLOADED_IMG)
    JJSDK:pushMsgToSceneController(message)
end

local _getImgCB = function(filePath, url)
    for k, v in pairs(DisplayDatas) do
        if (v.ImgHttp == url) then
            v.ImgLocal = filePath
            sendDownloadedMsg(v)
            break
        end
    end
end

function MoreGameManager:downloadImages()
    JJLog.i(TAG, "downloadImages")

    for k, v in pairs(DisplayDatas) do
        local path = imgCache:downloadImage(v.ImgHttp, _getImgCB)

        if (path) then
            v.ImgLocal = path
            sendDownloadedMsg(v)
        end
    end
end

function MoreGameManager:updateDisplayDatas()
    JJLog.i(TAG, "updateDisplayDatas")
    DisplayDatas = {}

    local index = 1
    for k, v in pairs(Datas) do
        if (v and (v.state == "0")) then
            DisplayDatas[index] = v

            --准备最终的http路径
            v.ImgHttp = Attrs.imgpre .. v.bigimg_url
            index = index + 1
        end
    end

    --按照order排序
    local function sordCmp(a, b)
        return a.order < b.order
    end

    table.sort(DisplayDatas, sordCmp)

    --LuaDataFile.save(DisplayDatas, "data/MoreGameDisplayDatas.lua")
    --JJLog.i(TAG, "Datas", vardump(Datas, "Datas"))
    --JJLog.i(TAG, "DisplayDatas", vardump(DisplayDatas, "DisplayDatas"))

    self:downloadImages()
end

function MoreGameManager:getDisplayDatas()
    JJLog.i(TAG, "getDisplayDatas", vardump(DisplayDatas, "DisplayDatas"))

    return DisplayDatas
end

function MoreGameManager:getIsDisplay()
    JJLog.i(TAG, "getIsDisplay")

    return isDisplay
end

function MoreGameManager:getDatas()
    JJLog.i(TAG, "getDatas")

    return Datas
end

function MoreGameManager:getImgUrl(data)
    JJLog.i(TAG, "getHttpUrl")
    local ret = ""

    if (data) then
        ret = Attrs.imgpre .. data.bigimg_url
    end

    return ret
end

return MoreGameManager