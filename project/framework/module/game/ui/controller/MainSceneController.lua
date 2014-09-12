--[[
    合集包游戏的主界面
]]
local MainSceneController = class("MainSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "MainSceneController"
local UIUtil = require("game.ui.UIUtil")
local MGC = require("game.data.config.MoreGameManager")
--[[
    参数
    @params:
        @packageId
        @games: 需要更新比赛信息的游戏
            @gameId
            @single: 是否单机
            @images
                @normal
                @highlight
]]

function MainSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    MainSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
    if RUNNING_MODE == RUNNING_MODE_HALL then
        MainController:removeScene(params.packageId, JJSceneDef.ID_SWITCH_TO_GAME)
    else
        JJSDK:removeAllScene()
    end
end

function MainSceneController:onActive()
    MainSceneController.super.onActive(self)
    MainController:setCurGameId(self.params_.packageId)
end

function MainSceneController:onDestory()
    MainSceneController.super.onDestory(self)
    for i = 1, #self.params_.games do
        if self.params_.games[i].single == true then
        else
            TourneyController:delGame(self.params_.games[i].gameId)
        end
    end
end

function MainSceneController:onBackPressed()
   -- if RUNNING_MODE == RUNNING_MODE_HALL then
      --  JJSDK:popScene()
   -- else
        if self.scene_ ~= nil then
            self.scene_:onBackPressed()
        end
   -- end
end

--[[
    消息处理
]]
function MainSceneController:handleMsg(msg)
    MainSceneController.super.handleMsg(self, msg)

    -- 连接失败
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateFail then
        self.scene_:showLoginDialog(false)
        self.scene_:refreshUserInfo()

    elseif msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateDisconnect then
        if self.scene_:isLoginDialog() then
            self:onLoginFailed(99)
        end
        self.scene_:refreshUserInfo()

    elseif msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
            -- 登录消息
            if msg[MSG_TYPE] == NOREG_LOGIN_ACK or msg[MSG_TYPE] == GENERAL_LOGIN_ACK then
                if msg.param == 0 then
                    if msg[MSG_TYPE] == NOREG_LOGIN_ACK then
                        JJLog.i(TAG, "enterNoRegLoginDialog before")
                        self.scene_:showFirstInDialog(true)
                        self:enterNoRegLoginDialog()
                    end
                    self:onLoginSuccess()
                else
                    self:onLoginFailed(msg.param)
                end

                -- 金币变化
            elseif msg[MSG_TYPE] == PUSHACCNUMMONEY_ACK or msg[MSG_TYPE] == PUSH_USER_MONEY_ACK then
                self.scene_:refreshUserInfo()
                if LoginController.type_ == LOGIN_TYPE_NOREG then
                    local count = Settings:getNoRegLoginCount()
                    if (Settings:getNoRegGoldPrompt() == false) and (count > 1) then
                        if not Util:isQihu360() and (UserInfo.gold_ >= 2000) then
                            JJLog.i(TAG, "enterNoRegLoginDialog before gold")
                            Settings:setNoRegGoldPrompt(true)
                            self.scene_:showGuideToBindNoRegDialog(true)
                        end
                    end
                end

                -- 用户物品变化：刷新秋卡数量
            elseif msg[MSG_TYPE] == GETUSERALLWARE_ACK or msg[MSG_TYPE] == PUSH_USER_WARE_ACK then
                self.scene_:refreshUserInfo()
            elseif msg[MSG_TYPE] == TOURNEYSIGNUPEX_ACK then
                -- self.scene_:refreshNoteMsg()
            end

        elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG then
            if (msg[MSG_TYPE] == COMMON_HTTP_CHECK_MORE_GAME_ACK) then
                self:onCheckMoreGame()
            end
        elseif msg[MSG_CATEGORY] == TOURNEY_ACK_MSG and msg[MSG_TYPE] == GET_TOURNEY_PLAYERCOUNT_ACK then
            if msg.tourney_ack_msg.gameid == self.scene_.selectGameId_ then
                self:enterMatchSelectSceneReceiveMsg(self.scene_.selectGameId_)
            end
        end
    elseif msg.type == GameMsgDef.ID_UPDAGE_HEAD_IMG then
        self.scene_:refreshUserInfo(true)
    elseif msg.type == GameMsgDef.ID_ROAR_MSG_UPDATE_CHANGE then
        self.scene_:refreshRoarNewMsgInfo()
    elseif msg.type == GameMsgDef.ID_NOTE_MSG_READ_STATE_CHANGE then
        if Util:isQihu360() then
            if self.scene_.bottomView_ then
                self.scene_.bottomView_:updateMsgNum()
            end
            self.scene_:checkUnreadMsg()
        end
    end
end

--[[
    开始登录
]]
function MainSceneController:startLogin()
    JJLog.i(TAG, "startLogin")
    -- 无网络提示
    if Util:getNetworkType() == 0 then
        self.scene_:showNoNetworkDialog(true)
    else
        self.scene_:showLoginDialog(true)
        LoginController:startLogin()
    end
end

--[[
    切屏动画结束，判断是否需要自动登录
]]
function MainSceneController:onSceneEnterFinish()
    MainSceneController.super.onSceneEnterFinish(self)
    JJLog.i(TAG, "onSceneEnterFinish, autoLogin=", MainController.autoLogin_, ", breakReconnect=", MainController.breakReconnect_)
    if MainController.autoLogin_ and not MainController.breakReconnect_ and not MainController:isConnected() then
        LoginController:reInitLastRecord()
        self:startLogin()
    end
    if self.scene_ and self.scene_.checkUnreadMsg then
        self.scene_:checkUnreadMsg()
    end
end

--[[
    请求获取 Tourney 信息
]]
local function _getTourneyInfo(self)
    require("game.controller.TourneyController")
    for i = 1, #self.params_.games do
        if self.params_.games[i].single == true then
        else
            TourneyController:addGame(self.params_.games[i].gameId)
        end
    end
    -- 请求已报名比赛信息
    LobbyMsg:sendGetUserInterfixTourneyListReq(UserInfo.userId_)
end

--请求获取 notemsg 信息
local function _getNoteMsg(self)
    require("game.data.model.NoteManager")
    NoteManager:addGame(MainController:getCurPackageId())
end

--请求check更多游戏信息
local function _checkMoreGame(self)
    MGC:sendCheckMoreGameReq(self.params_.packageId)
end

--[[
    登录成功
]]
function MainSceneController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess")
    self.scene_:showLoginDialog(false)
    HeadImgManager:delImg(UserInfo.userId_)
    self.scene_:refreshUserInfo()
    _getTourneyInfo(self)
    _getNoteMsg(self)
    _checkMoreGame(self)
    if self.scene_.checkUnreadMsg then
        self.scene_:checkUnreadMsg()
    end
end

--[[
    登录失败
]]
function MainSceneController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    self.scene_:showLoginDialog(false)
    UIUtil.showLoginFailed(param, self.dimens_)
    self.scene_:refreshUserInfo()
end

--[[
    check moregame
]]
function MainSceneController:onCheckMoreGame(param)
    JJLog.i(TAG, "onCheckMoreGame")

    local dis = MGC:getIsDisplay()

    if (dis) then
        MGC:sendGetMoreGameReq(self.params_.packageId)
    end

    self.scene_:refreshMoreGameShow()
end

--[[
    点击注册
]]
function MainSceneController:onClickRegister()
    JJLog.i(TAG, "onClickRegister")
    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:pushScene(self.params_.packageId, id)
end

--[[
    点击登陆
]]
function MainSceneController:onClickLogin()
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_JJ_LOGIN)
end

--[[
    点击网络设置
]]
function MainSceneController:onClickNetworkSetting()
    JJLog.i(TAG, "onClickNetworkSetting")
    Util:callNetworkSetting()
end

--[[
    点击更多游戏
]]
function MainSceneController:onClickMoreGame()
    JJLog.i(TAG, "onClickMoreGame")
    if MainController:isLogin() then
        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MORE_GAME)
    else
        LoginController:reInitLastRecord()
        self:startLogin()
    end
end

--[[
    进入比赛列表界面
    @gameId
]]
function MainSceneController:enterMatchSelectScene(gameId)
    JJLog.i(TAG, "enterMatchSelectScene IN gameId is ", gameId)
    if gameId == JJGameDefine.GAME_ID_LORD_SINGLE then
        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MATCH_SELECT, gameId)
    elseif MainController:isLogin() then
        if TourneyController:hasTourneyInfo(gameId) ~= true then
            if self.scene_ then
                self.scene_:showGetMatchWaitDialog(true)
                self.scene_.selectGameId_ = gameId
            end
            TourneyController:updateGame(gameId)
        else
            MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MATCH_SELECT, gameId)
        end
    else
        LoginController:reInitLastRecord()
        self:startLogin()
    end
end

function MainSceneController:enterMatchSelectSceneReceiveMsg(gameId)
    if self.scene_:existWaitDialog() == true then
        self.scene_:showGetMatchWaitDialog(false)
        MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MATCH_SELECT, gameId)
    end
end

--[[
    提示进入注册引导界面
    @gameId
]]
function MainSceneController:enterNoRegLoginDialog()
    JJLog.i(TAG, "enterNoRegLoginDialog IN")
    if not Util:isQihu360() then
        local count = Settings:getNoRegLoginCount()
        count = count + 1
        Settings:setNoRegLoginCount(count)
        --注册引导
        if (count == 5) then
            self.scene_:showGuideToBindNoRegDialog(true)
        end
    end
end

--onResume
function MainSceneController:onResume()
    local ret = MainSceneController.super.onResume(self)
    MainController:resumeControllerThirdProcess()
    return ret
end

function MainSceneController:refreshBottomViewBtn()
    JJLog.i(TAG, "refreshBottomViewBtn")
    self.scene_:refreshBottomViewBtn()
end

return MainSceneController