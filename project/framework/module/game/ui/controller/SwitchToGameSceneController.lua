local SwitchToGameSceneController = class("SwitchToGameSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "SwitchToGameSceneController"

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local download = require("sdk.download.DownloadManager")
require("game.data.config.MoreGameManager")

SwitchToGameSceneController.schedulerHandler_ = nil
SwitchToGameSceneController.downloadReq_ = 0
SwitchToGameSceneController.retryHandler_ = 0
SwitchToGameSceneController.next_ = false
SwitchToGameSceneController.update_ = false -- 是否有需要更新的

local TO_NEXT_SCENE_TICK = 1.0 -- 切换下一个界面的时间间隔，让动画多跑一会

-- 本地函数
local _checkTourney = nil
local _checkDownload = nil
local _startDownload = nil
local _downloadResultCB = nil
local _downloadProcessCB = nil
local _tryInstall = nil
local _retryDownload = nil
local _checkResult = nil

--[[
    参数
    @params:
        @packageId: 哪个包
        @gameId: 哪个游戏
        @anims: 动画图片列表
        @nextScene: 下一个界面
        @url: 更新包地址
        @path: 保存路径
        @fileSize: 服务器端文件大小
        @md5: 文件的 md5 值
]]
function SwitchToGameSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
    SwitchToGameSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
    MainController:setCurPackageId(self.params_.packageId)
    MoreGameManager:sendCheckMoreGameReq(self.params_.packageId)
end

local function unschedule(self)
    JJLog.i(TAG, "unschedule, self.schedulerHandler_=", self.schedulerHandler_)
    if self.schedulerHandler_ ~= nil then
        scheduler.unscheduleGlobal(self.schedulerHandler_)
        self.schedulerHandler_ = 0
    end
end

function SwitchToGameSceneController:onDestory()
    SwitchToGameSceneController.super.onDestory(self)

    unschedule(self)

    if self.retryHandler_ ~= 0 then
        scheduler.unscheduleGlobal(self.retryHandler_)
        self.retryHandler_ = 0
    end

    if self.downloadReq_ ~= 0 then
        download:stopDownload(self.downloadReq_)
        self.downloadReq_ = 0
    end
end

function SwitchToGameSceneController:onBackPressed()
    if self.update_ then
        JJLog.i(TAG, "onBackPressed, Do Nothing")
    else
        SwitchToGameSceneController.super.onBackPressed(self)
    end
end

function SwitchToGameSceneController:handleMsg(msg)
    SwitchToGameSceneController.super.handleMsg(self, msg)

    if msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_LIST_ACK then
    elseif msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_ACK then
    elseif msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_PLAYERCOUNT_ACK then
        unschedule(self)
        self.schedulerHandler_ = scheduler.performWithDelayGlobal(handler(self, self.toNextScene), TO_NEXT_SCENE_TICK)
        JJLog.i(TAG, "handleMsg, startScheduler, self.schedulerHandler_=", self.schedulerHandler_)
    elseif msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_MATCHPOINT then
    elseif msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_SIGNUPDATA_LIST then
    end
end

function SwitchToGameSceneController:onSceneEnterFinish()
    SwitchToGameSceneController.super.onSceneEnterFinish(self)
    JJLog.i(TAG, "onSceneEnterFinish, url=", self.params_.url, ", path=", self.params_.path)
    -- 先检查是否有更新
    if self.params_.url ~= nil and self.params_.path ~= nil then
        self.update_ = true
        _checkDownload(self)
    else
        _checkTourney(self)
    end
end

function SwitchToGameSceneController:toNextScene()
    JJLog.i(TAG, "toNextScene, self.next_=", self.next_)
    if self.next_ == false then
        self.next_ = true
        MainController:setCurPackageId(self.params_.packageId)
        if self.params_.nextScene == JJSceneDef.ID_PLAY then
            MainController:startGameScene(self.params_.gameId, self.params_.gameParam)
        else
            -- 默认进入赛区选择界面
            MainController:pushScene(self.params_.packageId, self.params_.nextScene, self.params_.gameId)
        end
    end
end

function _checkTourney(self)
    JJLog.i(TAG, "_checkTourney")

    --动态显隐配置
    HttpMsg:sendDisplayModule(self.params_.packageId)

    -- 获取玩家对于该游戏的成就
    LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine.JJ_DOMAIN_COMMON, self.params_.packageId)

    -- 只有斗地主合集包特殊
    if self.params_.packageId == JJGameDefine.GAME_ID_LORD_UNION then
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD), JJGameDefine.GAME_ID_LORD)
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_HL), JJGameDefine.GAME_ID_LORD_HL)
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_PK), JJGameDefine.GAME_ID_LORD_PK)
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_LZ), JJGameDefine.GAME_ID_LORD_LZ)
    else
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(self.params_.packageId), self.params_.packageId)
    end

    -- 合集包单独处理
    if self.params_.packageId == JJGameDefine.GAME_ID_LORD_UNION or self.params_.packageId == JJGameDefine.GAME_ID_LORD_UNION_HL then
        if TourneyController:hasTourneyInfo(JJGameDefine.GAME_ID_LORD) then
            unschedule(self)
            self.schedulerHandler_ = scheduler.performWithDelayGlobal(handler(self, self.toNextScene), TO_NEXT_SCENE_TICK)
        else
            TourneyController:addGame(JJGameDefine.GAME_ID_LORD)
            TourneyController:addGame(JJGameDefine.GAME_ID_LORD_HL)
            TourneyController:addGame(JJGameDefine.GAME_ID_LORD_PK)
            TourneyController:addGame(JJGameDefine.GAME_ID_LORD_LZ)
        end
    else

        if TourneyController:hasTourneyInfo(self.params_.packageId) then
            unschedule(self)
            self.schedulerHandler_ = scheduler.performWithDelayGlobal(handler(self, self.toNextScene), TO_NEXT_SCENE_TICK)
        else
            TourneyController:addGame(self.params_.gameId)
        end
    end

    -- 获取公告私信
    NoteManager:delGame(self.params_.packageId)
    NoteManager:addGame(self.params_.packageId)
    -- 更新全局配置
    GlobalConfigManager:update(self.params_.packageId)
    -- 请求已报名比赛信息
    if UserInfo.userId_ ~= 0 and self.params_.nextScene ~= JJSceneDef.ID_PLAY then
        LobbyMsg:sendGetUserInterfixTourneyListReq(UserInfo.userId_)
    end
end

--[[
    尝试安装，失败的话删除本地缓存
    @return
]]
function _tryInstall(self)
    JJLog.i(TAG, "_tryInstall")
    local suc = 0
    local fileMd5 = JJUpdateManager:instance():getFileMD5Lua(self.params_.path)

    -- 校验
    if fileMd5 ~= self.params_.md5 then
        suc = 1
        os.remove(self.params_.path)
    else

        -- 解压安装
        JJUpdateManager:instance():startUncompress(self.params_.path, device.writablePath .. "update/", function(result)
                os.remove(self.params_.path)
                if result == UNCOMPRESS_RESULT_SUCCESS then
                    -- 大厅进入单包游戏，存在升级的情况会高概率出现强退的情况，log中死在CCFileUtils的查找文件路径缓存的Map
                    -- 遍历过程中，或者会出现msg decode error的情况，且去掉checktourney处理测试问题不能复现，所以，此处理
                    -- 加以延时处理，测试未发现问题。
                    -- modify by lihua on 2014.7.16
                    -- _checkTourney(self)
                    unschedule(self)
                    self.schedulerHandler_ = scheduler.performWithDelayGlobal(handler(self, _checkTourney), 0.5)
                elseif result == UNCOMPRESS_RESULT_ROLLBACK then
                    _checkResult(self, 1)
                else
                    _checkResult(self, 2)
                end
            end)
    end
    JJLog.i(TAG, "_tryInstall, suc=", suc)
    return suc
end

--[[
    检查下载状态
]]
function _checkDownload(self)
    JJLog.i(TAG, "_checkDownload")
    local suc = 0
    local localSize = JJFileUtil:getFileSize(self.params_.path)
    JJLog.i(TAG, "_checkDownload, localSize=", localSize, ", fileSize=", self.params_.fileSize)

    -- 如果大小和本地包相同，校验、解压安装
    if localSize == self.params_.fileSize then
        suc = _tryInstall(self)
        localSize = 0
    -- 如果本地包大小大于节点信息的值，删掉，重下
    elseif localSize > self.params_.fileSize then
        os.remove(self.params_.path)
        localSize = 0
        suc = 3
    -- 如果本地包大小小于节点信息，继续下载
    else
        suc = 3
    end

    _checkResult(self, suc)
end

--[[
    重试下载
]]
function _retryDownload(self)
    JJLog.i(TAG, "_retryDownload")
    self.retryHandler_ = 0
    _checkDownload(self)
end

function _startDownload(self)
    JJLog.i(TAG, "_startDownload")
    self.scene_:showProgress(true)
    self.downloadReq_ = download:startDownload({
        url = self.params_.url,
        path = self.params_.path,
        progressFunc = handler(self, _downloadProcessCB),
        resultFunc = handler(self, _downloadResultCB),
        resume = true,
    })
end

function _downloadResultCB(self, result)
    JJLog.i(TAG, "_downloadResultCB, result=", result)
    self.downloadReq_ = 0
    local suc = 1
    if result then
        suc = _tryInstall(self)
    end
    _checkResult(self, suc)
end

function _downloadProcessCB(self, value)
    if self.scene_ ~= nil then
        self.scene_:updateProgress(value)
    end
end

--[[
    根据结果进行下一步处理
    @result：
        0: 成功，不需要处理
        1: 失败，删除本地下载，重试
        2: 失败，不可逆，删除 Update 下的，退回大厅
        3: 继续下载
]]
function _checkResult(self, result)
    JJLog.i(TAG, "_checkResult, result=", result)
    if result == 1 then
        jj.ui.JJToast:show({ text = "更新失败，重试更新！", dimens = self.dimens_ })
        self.retryHandler_ = scheduler.performWithDelayGlobal(handler(self, _retryDownload), 2)
    elseif result == 2 then
        jj.ui.JJToast:show({ text = "更新失败，请退出重试！", dimens = self.dimens_ })
        JJFileUtil:removeDir(device.writablePath .. "update/module/" .. JJGameDefine.GAME_DIR_TABLE[self.params_.packageId])
        self.retryHandler_ = scheduler.performWithDelayGlobal(function()
            self.retryHandler_ = 0
            JJSDK:popScene()
        end, 2)
    elseif result == 3 then
        _startDownload(self)
    end
end

return SwitchToGameSceneController