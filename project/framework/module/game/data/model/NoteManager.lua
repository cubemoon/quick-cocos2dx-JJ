-- 公告私信信息管理
NoteManager = {}

local TAG = "NoteManager"

local noteTimeStamp_ = {} -- 各packageid公告时间戳
local msgTimeStamp_ = {} -- 私信时间戳
local broadcastNote_ = {} --公告信息
local privateNote_ = {} -- 私信消息
local CHECK_TICK = 15 -- 15s 检查一次
local games_ = {} -- Key: gameId, value: lastUpdateTick
local msgUpdateTick -- 个人私信updatetick
local NOTE_UPDATE_TICK = 180 -- 三分钟更新一次 Notemsg
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

NoteManager.hasPoped = false -- 是否弹出msg框

-- 获取该游戏的公告时间戳
--@ keyId(packageId/userId) 
--@noteFlag 是公告还是私信
local function _initTimeStamp(keyId, noteFlag)
    keyId = tonumber(keyId)    
    if noteFlag then
        local path = string.format("data/note_timestamp.lua")
        local lup = LuaDataFile.get(path)
        if lup ~= nil then
            noteTimeStamp_[keyId] = lup["id" .. keyId]
        else
            noteTimeStamp_[keyId] = 0
        end        
    else
        local path = string.format("data/msg_timestamp.lua")
        local lup = LuaDataFile.get(path)
        if lup ~= nil then
            msgTimeStamp_[keyId] = lup["id" .. keyId]
        else
            msgTimeStamp_[keyId] = 0
        end
    end
end

function _saveTimeStamp(keyId, lup, noteFlag)
    keyId = tonumber(keyId)    
    if noteFlag then
        if noteTimeStamp_[keyId] == nil or tonumber(noteTimeStamp_[keyId]) < tonumber(lup) then
            noteTimeStamp_[keyId] = lup
            local path = string.format("data/note_timestamp.lua")            
            local saveData = LuaDataFile.get(path)
            if saveData == nil then                
                saveData = {}
            end
            saveData["id" .. keyId] = lup
            LuaDataFile.save(saveData, path)
        end
    else
        if msgTimeStamp_[keyId] == nil or tonumber(msgTimeStamp_[keyId]) < tonumber(lup) then
            msgTimeStamp_[keyId] = lup
            local path = string.format("data/msg_timestamp.lua")            
            local saveData = LuaDataFile.get(path)
            if saveData == nil then                
                saveData = {}
            end
            saveData["id" .. keyId] = lup
            LuaDataFile.save(saveData, path)
        end        
    end
end

function NoteManager:getNoteTimeStamp(keyId, noteFlag)
    keyId = tonumber(keyId)
    if noteFlag then
        if noteTimeStamp_[keyId] == nil then
            _initTimeStamp(keyId, noteFlag)
        end
        return noteTimeStamp_[keyId]        
    else
        if msgTimeStamp_[keyId] == nil then
            _initTimeStamp(keyId, noteFlag)
        end
        JJLog.i(TAG, "getmsgTimeStamp, keyId=", keyId, ", lup=", msgTimeStamp_[keyId])
        return msgTimeStamp_[keyId]        
    end
end

function NoteManager:saveBroadNoteMsg(datas)
    for index, item in pairs(datas) do
        local keyId = tonumber(item.package_id)
        local lup = tonumber(item.last_modify)
        local path = string.format("data/%d_note.lua",keyId)
        local saveData = LuaDataFile.get(path)
        if saveData == nil then                
            saveData = {}
        end        
        item["noteFlag"] = 1
        item["readFlag"] = 0
        if string.find(item.content, "<a href=") then
            local i, index = string.find(item.content, "<a href=")
            local str = string.sub(item.content, index+1)
            local i, j, url = string.find(str, '(["].*["])')
            url = string.sub(url, 2, string.len(url)-1)
            local i,j,str2 = string.find(str, '(>.*</a>)')
            local content = string.sub(str2, 2, string.len(str2)-4)
            item.content = content
            item["url"] = url
        end
        if tonumber(item.flag) == 0 then
            table.insert(saveData, item) 
            if #saveData > 20 then
                for index = 1, #saveData-20 do
                    table.remove(saveData, index)
                end
            end
            LuaDataFile.save(saveData, path)        
        end
        _saveTimeStamp(keyId, lup, true)
    end
end

function NoteManager:savePrivateNoteMsg(datas)
    for index, item in pairs(datas) do
        local keyId = tonumber(item.to_whom)
        local lup = tonumber(item.last_modify)
        local path = string.format("data/%d_msg.lua",keyId)        
        local saveData = LuaDataFile.get(path)
        if saveData == nil then                
            saveData = {}
        end
        item["noteFlag"] = 0
        item["readFlag"] = 0
        table.insert(saveData, item)
        if #saveData > 20 then
            for index = 1, #saveData-20 do
                table.remove(saveData, index)
            end
        end
        LuaDataFile.save(saveData, path)
        _saveTimeStamp(keyId, lup, false)
    end 
end

function NoteManager:saveSysNoteMsg(param)    
    local keyId = tonumber(param.to_whom) or 0
    local lup = tonumber(param.lup) or 0
    local path = string.format("data/%d_msg.lua",keyId)
    local saveData = LuaDataFile.get(path)
    if saveData == nil then                
        saveData = {}
    end        
    local item = {}
    item["noteFlag"] = 0
    item["readFlag"] = 0
    item["title"] = param.title
    item["content"] = param.content
    item["flag"] = 0
    item["to_whom"] = tostring(keyId)
    item["package_id"] = "-1"
    item["last_modify"] = lup
    item["add_time"] = JJTimeUtil:getCurrentServerDateString()
    item["type"] = param.type
    table.insert(saveData, item)
    if #saveData > 20 then
        for index = 1, #saveData-20 do
            table.remove(saveData, index)
        end
    end
    LuaDataFile.save(saveData, path)
end

function NoteManager:getItems(packageId, userId)
    local notePath = string.format("data/%d_note.lua",tonumber(packageId))  
    local items = {}
    local tempPath = string.format("data.%d_note",tonumber(packageId)) 
    package.loaded[tempPath] = nil
    local noteItems = LuaDataFile.get(notePath)
    if noteItems ~= nil then
        for i, item in ipairs(noteItems) do
            item["key"] = i
            table.insert(items, item)
        end        
    end

    local msgPath = string.format("data/%d_msg.lua",tonumber(userId))
    tempPath = string.format("data.%d_msg",tonumber(userId)) 
    package.loaded[tempPath] = nil   
    local msgItems = LuaDataFile.get(msgPath)
    if msgItems ~= nil then
        for i, item in pairs(msgItems) do
            item["key"] = i        
            table.insert(items, item)
        end
    end   
    table.sort(items, function(a, b)
        return a.last_modify > b.last_modify
        end)
    return items
   
end

function NoteManager:removeItem(keyId, index)
    local tempPath = string.format("data.%d_msg",tonumber(keyId)) 
    package.loaded[tempPath] = nil            
    local msgPath = string.format("data/%d_msg.lua",tonumber(keyId))   
    local msgItems = LuaDataFile.get(msgPath)
    if msgItems == nil or index > #msgItems then
        return false 
    end
    table.remove(msgItems, index)
    LuaDataFile.save(msgItems, msgPath)    
    return true
end

function NoteManager:refreshItem(keyId, index, item, noteFlag, readFlag)
    local msgPath = nil
    local Items = {}
    if noteFlag then
        local tempPath = string.format("data.%d_note",tonumber(keyId)) 
        package.loaded[tempPath] = nil        
        msgPath = string.format("data/%d_note.lua",tonumber(keyId))   
        Items = LuaDataFile.get(msgPath)
    else
        local tempPath = string.format("data.%d_msg",tonumber(keyId)) 
        package.loaded[tempPath] = nil
        msgPath = string.format("data/%d_msg.lua",tonumber(keyId))   
        Items = LuaDataFile.get(msgPath)
    end
    if Items == nil or index > #Items then
        return false 
    end
    table.remove(Items, index)
    table.insert(Items, index, item)
    LuaDataFile.save(Items, msgPath)   

    if readFlag then
        JJSDK:pushMsgToSceneController(require("sdk.message.Message").new(GameMsgDef.ID_NOTE_MSG_READ_STATE_CHANGE))
    end
    return true
end

function NoteManager:getUnreadCount(packageId, userId)
    local items = self:getItems(packageId, userId)
    local count = 0
    for i, item in ipairs(items) do
        if item.readFlag == 0 then
            count = count + 1
        end
    end 
    return count    
end

function NoteManager:getUnreadCountShowDialog(packageId, userId)
    local items = self:getItems(packageId, userId)
    local count = 0
    for i, item in ipairs(items) do
        if item.readFlag == 0 and item.noteFlag == 1 then
            count = count + 1
        end
    end 
    return count    
end

local function _updateNote(gameId, onlyNote)
    games_[gameId] = JJTimeUtil:getCurrentSecond()
    HttpMsg:sendGetNoteReq(gameId, NoteManager:getNoteTimeStamp(MainController:getCurPackageId(), true))--MainController.packageId_        
    HttpMsg:sendGetMsgReq(gameId, NoteManager:getNoteTimeStamp(UserInfo.userId_, false))
end

--[[
    每帧回调
]]
local function _update(dt)
    local cur = JJTimeUtil:getCurrentSecond()
    for gameId, lastTick in pairs(games_) do
        if (cur - lastTick) > NOTE_UPDATE_TICK and gameId == MainController:getCurPackageId() then
            _updateNote(gameId)
        end
    end
end

-- 外部接口
-- 添加需要监听的游戏
function NoteManager:addGame(gameId)
    if self.handlerScheduler_ ~= nil then
        scheduler.unscheduleGlobal(self.handlerScheduler_)
        self.handlerScheduler_ = nil
    end    
    self.handlerScheduler_ = scheduler.scheduleGlobal(_update, CHECK_TICK)
    gameId = tostring(gameId)
    if games_[gameId] == nil then
        games_[gameId] = JJTimeUtil:getCurrentSecond()
        _updateNote(gameId)
    end
end

--[[
    删除需要监听的游戏
    @gameId
]]
function NoteManager:delGame(gameId)
    JJLog.i(TAG, "delGame, gameId=", gameId)
    gameId = tostring(gameId)
    games_[gameId] = nil
end

return NoteManager
