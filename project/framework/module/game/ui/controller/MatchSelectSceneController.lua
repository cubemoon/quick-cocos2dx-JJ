local MatchSelectSceneController = class("MatchSelectSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "MatchSelectSceneController"

local UIUtil = require("game.ui.UIUtil")
MatchSelectSceneController.viewIndex_ = 0 -- 在list还是zone界面
MatchSelectSceneController.zoneId_ = 1 -- zoneId

--[[
	参数
    @params:
        @packageId
    	@gameId
    	@title: 标题
    	@zone: 赛区标题
        @urlColor: www.jj.cn 的字体颜色
        @registerColor: 注册按钮中字体的颜色
        @topicUrl: 活动网址         
]]

function MatchSelectSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    MatchSelectSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, params)
    if params.customParam == nil then
        self.customParam_ = require("game.ui.MatchSelectStyle1")
    else
        self.customParam_ = params.customParam
    end

    self.isShowSingleLordLoadDialog = params.isShowSingleLordLoadDialog
    self.gameId = params.gameId
    self.singleUserInfoManager = params.singleUserInfoManager
    MainController:removeScene(params.packageId, JJSceneDef.ID_SWITCH_TO_GAME)
end

function MatchSelectSceneController:onActive()
    MatchSelectSceneController.super.onActive(self)
    MainController:setCurGameId(self.params_.gameId)
end

function MatchSelectSceneController:onDestory()
    MatchSelectSceneController.super.onDestory(self)
    if JJSDK:containSceneId(JJSceneDef.ID_MAIN) == false then
        TourneyController:delGame(self.params_.gameId)
    end
end

function MatchSelectSceneController:onBackPressed()
    if self.gameId and self.gameId == JJGameDefine.GAME_ID_LORD_SINGLE and self.singleUserInfoManager then
        self.singleUserInfoManager:singleLordLoginOutRecord()
    end

    if self.scene_ == nil then
        JJSDK:popScene()
    else

        if self.scene_:dialogIsExist() == true then
            -- do nothing
        elseif self.scene_:secondViewIsExist() == true then
            self.scene_:onBackPressed()
        else
            --if RUNNING_MODE == RUNNING_MODE_HALL then
            --    JJSDK:popScene()
            --else
                self.scene_:onBackPressed()
            --end
        end
    end
end

--[[
    切屏动画结束，判断是否需要自动登录
]]
function MatchSelectSceneController:onSceneEnterFinish()
    MatchSelectSceneController.super.onSceneEnterFinish(self)
    if self.isShowSingleLordLoadDialog then
        self:showSingleLordLoadDialog()
        self.isShowSingleLordLoadDialog = false
    end
    JJLog.i(TAG, "onSceneEnterFinish, autoLogin=", MainController.autoLogin_, ", breakReconnect=", MainController.breakReconnect_)
    if MainController.autoLogin_ and not MainController.breakReconnect_ and not MainController:isConnected() and self.gameId ~= JJGameDefine.GAME_ID_LORD_SINGLE then
        LoginController:reInitLastRecord()
        self:startLogin()
    end
    if self.scene_ then
        self.scene_:showMsg()
    end
end

function MatchSelectSceneController:showSingleLordLoadDialog()
end

function MatchSelectSceneController:handleMsg(msg)
    MatchSelectSceneController.super.handleMsg(self, msg)
    -- 连接失败
    if msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateFail then
        self.scene_:showLoginDialog(false)
        self.scene_:refreshUserInfo()

    elseif msg.type == SDKMsgDef.TYPE_NET_STATE and msg.state == kJJSocketRequestStateDisconnect then
        if self.scene_:isLoginDialog() then
            self:onLoginFailed(99)
        end
        self.scene_:refreshUserInfo()

    elseif msg.type == GameMsgDef.ID_CUSTOM_TOURNEY_CHANGE then
        self.scene_:handleMsg(msg)
    elseif msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
            -- 登录消息
            if msg[MSG_TYPE] == NOREG_LOGIN_ACK or msg[MSG_TYPE] == GENERAL_LOGIN_ACK then
                if msg.param == 0 then
                    self:onLoginSuccess()
                else
                    self:onLoginFailed(msg.param)
                end

            -- 金币变化
            elseif msg[MSG_TYPE] == PUSHACCNUMMONEY_ACK or msg[MSG_TYPE] == PUSH_USER_MONEY_ACK then

                self.scene_:refreshUserInfo()
                self.scene_:handleMsg(msg)
                if LoginController.type_ == LOGIN_TYPE_NOREG then
                    if (Settings:getNoRegGoldPrompt() == false) then
                        if not Util:isQihu360() and (UserInfo.gold_ >= 2000) then
--                            MainController:setNeedPromptNoRegBind(true)
                            JJLog.i(TAG, "enterNoRegLoginDialog before gold")
                            Settings:setNoRegGoldPrompt(true)
                            self.scene_:showGuideToBindNoRegDialog(true)
                        end
                    end
                end

            -- 用户物品变化：刷新秋卡数量
            elseif msg[MSG_TYPE] == GETUSERALLWARE_ACK or msg[MSG_TYPE] == PUSH_USER_WARE_ACK then
                self.scene_:refreshUserInfo()
                self.scene_:handleMsg(msg)

            elseif msg[MSG_TYPE] == TOURNEYSIGNUPEX_ACK then

            elseif msg[MSG_TYPE] == TOURNEYUNSIGNUP_ACK then

                local ack = msg.lobby_ack_msg.tourneyunsignup_ack_msg
                if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
                    jj.ui.JJToast:show({
                        text = "退赛成功! ",
                        dimens = self.dimens_,
                    })
                else
                    jj.ui.JJToast:show({
                        text = "退赛失败 " .. MatchDefine.toString(tonumber(msg.param)),
                        dimens = self.dimens_,
                    })
                end
            end

            -- 如果是即时赛已经切换到play界面了
            if self.scene_ ~= nil then
                self.scene_:handleMsg(msg)
            end
        elseif msg[MSG_CATEGORY] == MATCHINFO_ACK_MSG and msg[MSG_TYPE] == MATCH_SIGN_COUNT_INFO_ACK then
            if self.scene_ ~= nil then
                self.scene_:handleMsg(msg)
            end
        elseif msg[MSG_CATEGORY] == MATCHINFO_ACK_MSG and msg[MSG_TYPE] == MATCH_TABLE_INFO_CHANGE_ACK then
            MainController:pushScene(self.params_.packageId, JJSceneDef.ID_TABLE_SELECT)
        elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG and (msg[MSG_TYPE] == COMMON_HTTP_GET_NOTE_MSG_ACK or msg[MSG_TYPE] == COMMON_HTTP_GET_PRI_MSG_ACK or msg[MSG_TYPE] == COMMON_HTTP_GET_MATCH_CONFIG_ACK) then
            if self.scene_ ~= nil then
                self.scene_:handleMsg(msg)
            end
        end
    elseif msg.type == GameMsgDef.ID_ROAR_MSG_UPDATE_CHANGE then
        self.scene_:refreshRoarNewMsgInfo()
    end
end

function MatchSelectSceneController:startLogin()
    JJLog.i(TAG, "startLogin")

    if Util:getNetworkType() == 0 then
        if self.scene_ then
            self.scene_:showNoNetworkDialog(true)
        end
    else
        if self.scene_ then
            self.scene_:showLoginDialog(true)
        end
        LoginController:startLogin()
    end
end

--[[
    请求获取 Tourney 信息
]]
local function _getTourneyInfo(self)
    require("game.controller.TourneyController")
    TourneyController:addGame(self.params_.gameId)
        -- 请求已报名比赛信息
    LobbyMsg:sendGetUserInterfixTourneyListReq(UserInfo.userId_)
end

--[[
    登录成功
]]
function MatchSelectSceneController:onLoginSuccess()
    JJLog.i(TAG, "onLoginSuccess")
    self.scene_:showLoginDialog(false)
    self.scene_:refreshUserInfo()
    _getTourneyInfo(self)
end

--[[
    登录失败
]]
function MatchSelectSceneController:onLoginFailed(param)
    JJLog.i(TAG, "onLoginFailed")
    self.scene_:showLoginDialog(false)
    UIUtil.showLoginFailed(param, self.dimens_)
end

--[[
    点击注册
]]
function MatchSelectSceneController:onClickRegister()
    JJLog.i(TAG, "onClickRegister")

    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:pushScene(self.params_.packageId, id)
end

--onResume
function MatchSelectSceneController:onResume()
    local ret = MatchSelectSceneController.super.onResume(self)
    MainController:resumeControllerThirdProcess()
    return ret
end

function MatchSelectSceneController:refreshBottomViewBtn()
    JJLog.i(TAG, "refreshBottomViewBtn")
    self.scene_:refreshBottomViewBtn()
end

return MatchSelectSceneController
