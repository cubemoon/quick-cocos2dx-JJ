--[[
    用于展示上层原生 Web 界面
]]
local WebViewSceneController = class("WebViewSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "WebViewSceneController"

WebViewSceneController.backBtn_ = false -- WebView 需要回退键
WebViewSceneController.menuIsShow_ = false -- WebView Menu是否显示
WebViewSceneController.rightBtn_ = false   -- WebView Menu按键

WebViewSceneController.getCookieOnly_ = false
WebViewSceneController.toDo_ = nil
WebViewSceneController.title_ = nil

local _showWebView
local _dismissWebView

--[[
    参数
    @params:
        @width: 界面宽度
        @height: 界面高度
        @top: 界面纵向起始点
        @left: 界面横向起始点
        @url: 连接地址
        @sso: 是否需要 SSO
        @title: 标题
        @back: 是否显示返回按钮
]]
function WebViewSceneController:ctor(controllerName, sceneName, theme, dimens, params)
    WebViewSceneController.super.ctor(self, controllerName, sceneName, theme, dimens)

    self.params_ = params
    if self.params_ == nil then
        self.params_ = {}
    end

    if self.dimens_.width > self.dimens_.height then
        self.params_.width = self.dimens_.height
        self.params_.height = self.dimens_.width
    else
        self.params_.width = self.dimens_.width
        self.params_.height = self.dimens_.height
    end
    self.params_.top = self.dimens_:getDimens(115)
    self.params_.left = 0

    if self.params_.width == nil or self.params_.height == nil or self.params_.url == nil then
        JJLog.e(TAG, "ctor, params err!!!")
        return
    end

    if Util:isSetCookie() == true or self.params_.sso == false then
        _showWebView(self)
    else
        LobbyMsg:sendGetSSO(UserInfo.userId_)
    end
end

function WebViewSceneController:onDestory()
    _dismissWebView()
end

function WebViewSceneController:onBackPressed()
    JJLog.i(TAG, "onBackPressed, backBtn_=", self.backBtn_, " self.menuIsShow_ = ", self.menuIsShow_)
    if self.menuIsShow_ == true then
        self.scene_:callJSFuncByRightBtn()
    else
        if self.backBtn_ == true then
            Util:onBackPressedForCustomView()
        else
            WebViewSceneController.super.onBackPressed(self)
        end
    end
end

local function _update(self, state)
    JJLog.i(TAG, "_update, state=", state)
    if state ~= nil then
        local jsonTable = json.decode(state)
        if jsonTable ~= nil then
            if jsonTable.title ~= nil then
                self.title_ = jsonTable.title
                self.scene_:updateTitle(jsonTable.title)
                self.backBtn_ = true
            end

            if self.params_ and self.params_.listener then
                self.params_.listener(jsonTable)
            end

            if jsonTable.close == "true" then
                self.backBtn_ = false
                self:onBackPressed()
            end

            if jsonTable.rightBtn == "true" then
                self.rightBtn_ = true
                self.scene_:updateRightBtn(true)
            elseif jsonTable.rightBtn == "false" then
                self.rightBtn_ = false
                self.menuIsShow_ = falses
                self.scene_:updateRightBtn(false)
            end

            if jsonTable.getSSO ~= nil then
                self.getCookieOnly_ = true
                self.toDo_ = "reloadWebview"
                LobbyMsg:sendGetSSO(UserInfo.userId_)        
            end

            -- if jsonTable.backBtn == "true" then
            --     self.backBtn_ = true
            -- elseif jsonTable.backBtn == "false" then
            --     self.backBtn_ = false
            -- end
        end
    end
end

function _showWebView(self, url)
    JJLog.i(TAG, "_showWebView, ", vardump(self.params_, "self.params_"))
    local appId = self:getAppID()
    Util:showCustomView("util", self.params_.width, self.params_.height, self.params_.top, 0, handler(self, _update), self.params_.url, appId, url or "")
end

function _dismissWebView()
    JJLog.i(TAG, "_dismissWebView")
    Util:closeCustomView("util")
end

--[[
    SSO 消息
]]
local function _handleTicketTempEx(self, msg)
    JJLog.i(TAG, "_handleTicketTempEx")
    local ack = msg.lobby_ack_msg.gettickettempex_ack_msg
    local url = "http://jj.cn/lobby/appssologin.php?j=" .. tostring(ack.userid) .. "&d=" .. tostring(ack.ticketcrttime) .. "&t=" .. tostring(ack.type) .. "&p=" .. ack.ticket
    -- _showWebView(self, url)

    if self.getCookieOnly_ == false then
        _showWebView(self, url)
    else
        local appId = self:getAppID()
        Util:getCookieAndTodo("util", 0, self.toDo_, appId, url)
        self.getCookieOnly_ = false
    end

end

function WebViewSceneController:handleMsg(msg)
    WebViewSceneController.super.handleMsg(self, msg)

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
            -- SSO
            if msg[MSG_TYPE] == GET_TICKET_TEMPEX_ACK then
                _handleTicketTempEx(self, msg)
            end
        end
    end
end

function WebViewSceneController:onSceneEnterFinish()
     if (Settings:getNoRegExchangePrompt() == false) and (LoginController.type_ == LOGIN_TYPE_NOREG) then
        Settings:setNoRegExchangePrompt(true)
     end
    return WebViewSceneController.super.onSceneEnterFinish(self)
end

--[[
    点击注册
]]
function WebViewSceneController:onClickRegister()
    JJLog.i(TAG, "onClickRegister")

    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:pushScene(self.params_.packageId, id)
end

function WebViewSceneController:getAppID()
    local appId = 10004
    if CURRENT_PACKAGE_ID ~= JJGameDefine.GAME_ID_HALL then
        appId = 10003
    end

    return appId
end

return WebViewSceneController