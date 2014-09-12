--[[
    用于展示上层原生 Web 界面
]]
local WebViewController = class("WebViewController")
local TAG = "WebViewController"


WebViewController.needSSO = true
-- cookie失效后重新登录
WebViewController.getCookieOnly_ = false
-- webview不存在的情况下提前获取cookie
WebViewController.preGetCookieOnly_ = false
WebViewController.toDo_ = nil

local _showWebView

--[[
    参数
    @params:
        @url: 连接地址
        @sso: 是否需要 SSO
        @ssoUrl: 加载cookie域
        @title: 标题
        @urlNoParam:加载的url不需要添加参数
        @orientation:横竖屏设置，1为竖屏，2为横屏
        @scale: 传送scale数值给JAVA层使用
]]
function WebViewController:showActivity(params)

    self.params_ = params
    if self.params_ == nil then
        self.params_ = {}
    end

    _showWebView(self)

    -- if Util:isSetCookie() == false and self.params_.sso == true then
    --     LobbyMsg:sendGetSSO(UserInfo.userId_)
    -- end    
end

function WebViewController:getSSOAndCookie()
    self.preGetCookieOnly_ = true
    LobbyMsg:sendGetSSO(UserInfo.userId_)
    
end

local function _startLoginWebAndLoadWeb(url, ssourl)

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "startLoginWebAndLoadWeb"
        local args = {url, ssourl}
        local sig = "(Ljava/lang/String;Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "JJWebController"
        local methodName = "startLoginWebAndLoadWeb"   
        local args = {["url"] = url,["ssourl"] = ssourl}   
        luaoc.callStaticMethod(className, methodName, args) 
        JJLog.i(TAG,"_startLoginWebAndLoadWeb result=",result," operator=",operator)
    elseif not device.platform == "windows" then
    end
end

-- url--getcookieULR
local function _getCookieForWebView(url)

    if device.platform == "android" then
        local className = "cn/jj/base/JJUtil"
        local methodName = "getCookieForWebView"
        local args = {url}
        local sig = "(Ljava/lang/String;)V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then
        local className = "JJWebController"
        local methodName = "getCookieForWebView"        
        local args = {["url"] = url}
        result, operator = luaoc.callStaticMethod(className,methodName,args)
        JJLog.i(TAG,"_getCookieForWebView result=",result," operator=",operator)
    elseif not device.platform == "windows" then
    end
end

function WebViewController:getAppID()
    local appId = 10004
    if device.platform == "android" then
        if MainController.curPackageId_ ~= JJGameDefine.GAME_ID_HALL then
            if MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONG then
                appId = 10007
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_THREE_CARD then
                appId = 10008
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_RUNFAST then
                appId = 10009
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_INTERIM then
                appId = 10010
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_POKER then
                appId = 10011
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_NIUNIU then
                appId = 10012
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONGPUBLIC then
                appId = 10013
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONG_TP then
                appId = 10014
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONG_BR then
                appId = 10015
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONG_SC then
                appId = 10016
            elseif MainController.curPackageId_ == JJGameDefine.GAME_ID_MAHJONGTDH then
                appId = 10017
            else 
                appId = 10003
            end
        end
    elseif device.platform == "ios" then
        appId = 30000
    end
    return appId
end

local function _getSSOURL(url)

    local ssoURL = JJWebViewUrlDef.MOB_SSO_URL

    if url == JJWebViewUrlDef.URL_OTHER_CHARGE then
        ssoURL = JJWebViewUrlDef.CHARGE_SSO_URL
    end

    return ssoURL
end

local function _getIconRes()
    local id = MainController.curGameId_
    local res = ""

    JJLog.i(TAG, "_getIconRes, id=", id)

    if id == JJGameDefine.GAME_ID_LORD_UNION or id == JJGameDefine.GAME_ID_LORD_UNION_HL or id == JJGameDefine.GAME_ID_LORD
        or id == JJGameDefine.GAME_ID_LORD_LZ or id == JJGameDefine.GAME_ID_LORD_HL
        or id == JJGameDefine.GAME_ID_LORD_PK or id == JJGameDefine.GAME_ID_LORD_SINGLE then
        res = "common"
    -- elseif id == JJGameDefine.GAME_ID_LORD_UNION then
    -- elseif id == JJGameDefine.GAME_ID_MAHJONG or id == JJGameDefine.GAME_ID_MAHJONG_TP then
    --     res = "mahjong"
    else --"hall"
        res = JJGameDefine:getGameDirName(id)
        if res == "" then
            res = "common"
        end
    end

    JJLog.i(TAG, "_getIconRes, res=", res)

    return res
end

local function _getLoginMode()
    local LoginData = require("game.data.login.LoginData")
    local loginmode = LoginData:getLastRecord()
    local mode = 0

    if loginmode == LOGIN_TYPE_NOREG then
        mode = 1
    elseif loginmode == LOGIN_TYPE_JJ then
        mode = 2
    -- elseif loginmode = LOGIN_TYPE_JJ then
    --     mode = 3
    else
        mode = 0
    end

    return mode
end

local function _update(self, state)
    JJLog.i(TAG, "_update, state=", state)
    if state ~= nil then
        local jsonTable = json.decode(state)
        if jsonTable ~= nil then

            if self.params_ and self.params_.listener then
                self.params_.listener(jsonTable)
            end

            if jsonTable.getSSO ~= nil then
                -- self.getCookieOnly_ = true
                -- self.toDo_ = "reloadWebview"
                if self.preGetCookieOnly_ == false then
                    LobbyMsg:sendGetSSO(UserInfo.userId_)
                end
            end

            if jsonTable.reGetSSO ~= nil then
                self.getCookieOnly_ = true
                self.toDo_ = "reloadWebview"
                LobbyMsg:sendGetSSO(UserInfo.userId_)        
            end

            if jsonTable.close ~= nil then
                self.getCookieOnly_ = false
                self.toDo_ = nil        
            end

            if jsonTable.headImg ~= nil then
                local figureid = tonumber(jsonTable.headImg)
                -- JJLog.i(TAG, "_update, 3 ", jsonTable.headImg, " type (jsonTable.headImg)", type(jsonTable.headImg))
                -- JJLog.i(TAG, "_update, 3 figureid ", figureid, " type (figureid)", type(figureid))
                -- ImageCacheManager:deleteCacheData(JJWebViewUrlDef.URL_GET_HEAD_ICON..UserInfo.userId_)
                UserInfo.figureId_ = figureid
            end

            if jsonTable.modifyNickName ~= nil then
                UserInfo.nickname_ = jsonTable.modifyNickName
            end

            if jsonTable.register ~= nil then
                Util:closeWebActivity()
                local packageid = MainController:getCurPackageId()
                local id = MainController:getRegisterSceneId(packageid)
                JJLog.i(TAG, "_update register, packageid=", packageid, " id = ", id)
                MainController:pushScene(packageid, id)
            end
        end
    end
end

function _showWebView(self, url)
    JJLog.i(TAG, "_showWebView, ", vardump(self.params_, "self.params_"))
    local appId = self:getAppID()
    local ssoURL = _getSSOURL(self.params_.url)
    local resdir = _getIconRes()
    local loginmode = _getLoginMode()
    local orientation = 1

    if self.params_ ~= nil and self.params_.ssoUrl then
        ssoURL = self.params_.ssoUrl
    end

    if self.params_.url == JJWebViewUrlDef.URL_OTHER_CHARGE and appId ~= 10004 then
        orientation = 2
    end

    if self.params_.orientation then
        orientation = self.params_.orientation
    end

    local gotoUrl = ""
    if self.params_.url ~= nil then
        
        if not self.params_.urlNoParam then
            if string.find(self.params_.url, "?") then
                gotoUrl = self.params_.url .. "&net=" .. Util:getNetworkName() .. "&operator=" .. Util:getOperator()
            else
                gotoUrl = self.params_.url .. "?net=" .. Util:getNetworkName() .. "&operator=" .. Util:getOperator()
            end
        else
            --asset本地网页4.0版本添加？参数会加载失败，但是放在data目录不会有问题，所以本地网页不需要添加加载参数
            gotoUrl = self.params_.url
        end
    end

    local displayManager = require("game.data.config.DynamicDisplayManager")
    local isShare = displayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_SHARE)

    JJLog.i(TAG, "_showWebView isShare=",isShare)

    Util:showWebActivity("util", handler(self, _update), gotoUrl, appId, self.params_.title, ssoURL, self.params_.sso, resdir, loginmode, orientation, isShare, self.params_.scale or 0)
    
end

--[[
    SSO 消息
]]
local function _handleTicketTempEx(self, msg)
    JJLog.i(TAG, "_handleTicketTempEx")
    local ack = msg.lobby_ack_msg.gettickettempex_ack_msg
    -- 获取cookie的url
    local url = "http://jj.cn/lobby/appssologin.php?j=" .. tostring(ack.userid) .. "&d=" .. tostring(ack.ticketcrttime) .. "&t=" .. tostring(ack.type) .. "&p=" .. ack.ticket
    -- _showWebView(self, url)
    -- 需要加载cookie的url
    local ssoURL  = ""
    if self.params_ ~= nil and self.params_.url ~= nil then
        ssoURL = _getSSOURL(self.params_.url)
    end

    if self.params_ ~= nil and self.params_.ssoUrl ~= nil then
        ssoURL = self.params_.ssoUrl
    end

    if self.preGetCookieOnly_ then
        _getCookieForWebView(url)
        self.preGetCookieOnly_ = false
    else
        if self.getCookieOnly_ == false then
            _startLoginWebAndLoadWeb(url, ssoURL)
        else
            local appId = self:getAppID()
            Util:getCookieAndTodo("util", 0, self.toDo_, appId, url)
            self.getCookieOnly_ = false
        end
    end

end

function WebViewController:handleMsg(msg)

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
            -- SSO
            if msg[MSG_TYPE] == GET_TICKET_TEMPEX_ACK then
                _handleTicketTempEx(self, msg)
            end
        end
    end
end

return WebViewController