--[[
	Lobby 消息处理
]]
require("game.data.lobby.LobbyData")
require("game.util.JJTimeUtil")
require("game.data.game.GameDataContainer")
local TourneyChangeMsg = require("game.message.TourneyChangeMsg")

LobbyMsgController = {}
local TAG = "[LobbyMsgController]"

-- lobby ack msg
LOGIN_ACK = 1
LOGOUT_ACK = 2
ANONYMOUSE_BROWSE_ACK = 3
GET_USER_ALLGROW_ACK = 4
GETUSERALLWARE_ACK = 5
GET_ACC_NUMMONEY_ACK = 6
TOURNEYSIGNUPEX_ACK = 7
TOURNEYUNSIGNUP_ACK = 8
GET_SYSMSGEX_ACK = 9
QUICK_START_GAME_ACK = 10
GETUSERINTERFIXTOURNEYLIST_ACK = 11
START_CLIENT_ACK = 12
PUSH_USER_WARE_ACK = 13
PUSHUSERGROW_ACK = 14
PUSHACCNUMMONEY_ACK = 15
PUSHUSERSCORE_ACK = 16
PUSH_USER_MONEY_ACK = 17
GETUSERMATCHPOINTSIGNUPTOURNEYLIST_ACK = 18
PUSH_SYSBOARD_ACK = 19
GET_TICKET_TEMPEX_ACK = 20
MODIFY_NICKNAME_ACK = 21
TERMINATE_NOTIFY_ACK = 22
VERIFY_NICKNAME_ACK = 23
VERIFY_LOGINNAME_ACK = 24
GET_VERIFY_CODE_ACK = 25
REGISTER_ACK = 26
GETSINGLEGROW_ACK = 27
SEND_REGSMSCODE_ACK = 28
MOBILE_REGISTER_ACK = 29
MOBILE_LOGIN_ACK = 30
PUSH_INFO_ACK = 31
GENERAL_LOGIN_ACK = 32
NOREG_LOGIN_ACK = 33
NOREGBIND_DEFAULTACC_ACK = 34
NOREGBIND_EMILACC_ACK = 35
NOREGBIND_MOBILEACC_ACK = 36
GETSMS_RANDOMPWD_ACK = 37
RANDOMPWD_LOGIN_ACK = 38
GET_ACCESS_TOKEN_ACK = 39
OPEN_PARTNER_LOGING_ACK = 40
TOKEN_LOGIN_ACK = 41
MODIFY_FIGURE_ACK = 42
GET_USER_DOMAIN_GROW_ACK = 43
VERIFY_LOGINNAMEEXIST_ACK = 44
MODIFY_GROW_ACK = 45

function LobbyMsgController:handleMsg(msg)
    JJLog.i(TAG, "handleMsg")
    msg[MSG_CATEGORY] = LOBBY_ACK_MSG
    local lobby = msg.lobby_ack_msg
    if #lobby.anonymous_ack_msg ~= 0 then
        self:handleAnonymouseBrowseAck(msg)

    elseif #lobby.noreglogin_ack_msg ~= 0 then
        self:handleNoRegLoginAck(msg)

    elseif #lobby.generallogin_ack_msg ~= 0 then
        self:handleGeneralLoginAck(msg)

    elseif #lobby.pushuserscore_ack_msg ~= 0 then
        self:handlePushUserScoreAck(msg)

    elseif #lobby.pushusergrow_ack_msg ~= 0 then
        self:handlePushUserGrowAck(msg)

    elseif #lobby.pushaccnummoney_ack_msg ~= 0 then
        self:handlePushAccnumMoneyAck(msg)

    elseif #lobby.pushusermoney_ack_msg ~= 0 then
        self:handlePushUserMoneyAck(msg)

    elseif #lobby.getuserallware_ack_msg ~= 0 then
        self:handleGetUserAllWareAck(msg)

    elseif #lobby.pushuserware_ack_msg ~= 0 then
        self:handlePushUserWareAck(msg)

    elseif #lobby.getsinglegrow_ack_msg ~= 0 then
        self:handleGetSingleGrowAck(msg)

    elseif #lobby.getuserinterfixtourneylist_ack_msg ~= 0 then
        self:handleGetUserInterfixTourneyListAck(msg)

    elseif #lobby.getusermatchpointsignuptourneylist_ack_msg ~= 0 then
        self:handleGetUserMatchPointSignupTourneyListAck(msg)

    elseif #lobby.tourneysignupex_ack_msg ~= 0 then
        self:handleTourneySigupexAck(msg)

    elseif #lobby.tourneyunsignup_ack_msg ~= 0 then
        self:handleTourneyUnsignupAck(msg)

    elseif #lobby.startclientex_ack_msg ~= 0 then
        self:handleStartClientexAck(msg)

    elseif #lobby.gettickettempex_ack_msg ~= 0 then
        self:handleTicketTempExAck(msg)

    elseif #lobby.getverifycode_ack_msg ~= 0 then
        self:handleGetVerifyCodeAck(msg)

    elseif #lobby.register_ack_msg ~= 0 then
        self:handleRegisterAck(msg)

    elseif #lobby.urssendregsmscode_ack_msg ~= 0 then
        JJLog.i(TAG, "urssendregsmscode_ack_msg")
        self:handleURSSendRegSMSCodeAck(msg)

    elseif #lobby.mobileregister_ack_msg ~= 0 then
        JJLog.i(TAG, "mobileregister_ack_msg")
        self:handleMobileRegisterAck(msg)

    elseif #lobby.noregbindmobileacc_ack_msg ~= 0 then
        JJLog.i(TAG, "noregbindmobileacc_ack_msg")
        self:handleNoRegBindMobileAccAck(msg)

    elseif #lobby.noregbinddefaultacc_ack_msg ~= 0 then
        JJLog.i(TAG, "noregbinddefaultacc_ack_msg")
        self:handleNoRegBindDefaultAccAck(msg)

    elseif #lobby.verifyloginname_ack_msg ~= 0 then
        JJLog.i(TAG, "verifyloginname_ack_msg")
        self:handleVerifyLoginNameAck(msg)

    elseif #lobby.verifyloginnameexist_ack_msg ~= 0 then
        JJLog.i(TAG, "verifyloginnameexist_ack_msg")
        self:handleVerifyLoginNameExistAck(msg)

    elseif #lobby.terminatenotify_ack_msg ~= 0 then
        self:handleTerminateNotifyAck(msg)

    elseif #lobby.getuserdomaingrow_ack_msg ~= 0 then
        self:handleGetUserDomainGrowAck(msg)

    elseif #lobby.getsysmsgex_ack_msg ~= 0 then
        self:handleGetSysMsgExAck(msg)

    elseif #lobby.lspushinfo_ack_msg ~= 0 then
        self:handleLsPushInfoAck(msg)

    elseif #lobby.modifygrow_ack_msg ~= 0 then
        self:handleModifyGrowAck(msg)

    else
        JJLog.i(TAG, "Unknown Msg")
    end
end

-- AnonymouseBrowse
function LobbyMsgController:handleAnonymouseBrowseAck(msg)
    JJLog.i(TAG, "handleAnonymouseBrowseAck")
    msg[MSG_TYPE] = ANONYMOUSE_BROWSE_ACK
    if LobbyData:isRecvAnonymousBrowser() == false then
        LobbyData:setRecvAnonymousBrowser(true)
        local ack = msg.lobby_ack_msg.anonymous_ack_msg
        LobbyData:setAnoneymousId(ack.anonymousid)
        JJTimeUtil:setServerTime(ack.servertime)
        JJAnalytics:setLocalIP(ack.userip)
    end
end

-- 免注册登录
function LobbyMsgController:handleNoRegLoginAck(msg)
    JJLog.i(TAG, "handleNoRegLoginAck")
    msg[MSG_TYPE] = NOREG_LOGIN_ACK
    local lc = require("game.controller.LoginController")
    lc:handleNoRegLoginAck(msg)
end

-- 普通登录
function LobbyMsgController:handleGeneralLoginAck(msg)
    JJLog.i(TAG, "handleGeneralLoginAck")
    msg[MSG_TYPE] = GENERAL_LOGIN_ACK
    local lc = require("game.controller.LoginController")
    lc:handleGeneralLoginAck(msg)
end

-- 推送玩家积分信息
function LobbyMsgController:handlePushUserScoreAck(msg)
    JJLog.i(TAG, "handlePushUserScoreAck")
    msg[MSG_TYPE] = PUSHUSERSCORE_ACK
    local ack = msg.lobby_ack_msg.pushuserscore_ack_msg
    UserInfo.totalMasterScore_ = ack.masterscore
    UserInfo.totalScore_ = ack.score
    UserInfo:setMaxScore(ack.score)
end

-- 推送用户成就
function LobbyMsgController:handlePushUserGrowAck(msg)
    JJLog.i(TAG, "handlePushUserGrowAck")
    msg[MSG_TYPE] = PUSHUSERGROW_ACK
    local list = msg.lobby_ack_msg.pushusergrow_ack_msg.growlist
    for i = 1, #list do
        local grow = list[i]
        UserInfo:addGrow(grow.growid, grow.value)
    end
end

-- 推送用户金融信息
function LobbyMsgController:handlePushAccnumMoneyAck(msg)
    JJLog.i("linxh", "handlePushAccnumMoneyAck")
    msg[MSG_TYPE] = PUSHACCNUMMONEY_ACK
    local ack = msg.lobby_ack_msg.pushaccnummoney_ack_msg
    -- 0: 普通；10：保险箱；100：幸运卡；200：金豆
    JJLog.i("linxh", "handlePushAccnumMoneyAck, ack.acctype=", ack.acctype)
    if ack.acctype == 0 or ack.acctype == 200 then
        UserInfo.gold_ = ack.gold
        UserInfo.cert_ = ack.cert
    end
end

-- 推送用户金币变化
function LobbyMsgController:handlePushUserMoneyAck(msg)
    JJLog.i("linxh", "handlePushUserMoneyAck")
    msg[MSG_TYPE] = PUSH_USER_MONEY_ACK
    local ack = msg.lobby_ack_msg.pushusermoney_ack_msg
    --JJLog.i("linxh", "handlePushUserMoneyAck, ack.gold=", ack.gold , ", ack.cert=", ack.cert)
    UserInfo.gold_ = ack.gold
    UserInfo.cert_ = ack.cert
end

-- 获取所有用户物品
function LobbyMsgController:handleGetUserAllWareAck(msg)
    JJLog.i(TAG, "handleGetUserAllWareAck")
    msg[MSG_TYPE] = GETUSERALLWARE_ACK
    local list = msg.lobby_ack_msg.getuserallware_ack_msg.warelist
    for i = 1, #list do
        local ware = list[i]
        UserInfo:addWare(ware.wareid, ware.waretypeid, ware.count)
    end
end

-- 物品变化
function LobbyMsgController:handlePushUserWareAck(msg)
    JJLog.i(TAG, "handlePushUserWareAck")
    msg[MSG_TYPE] = PUSH_USER_WARE_ACK
    local list = msg.lobby_ack_msg.pushuserware_ack_msg.warelist
    for i, ware in ipairs(list) do
        if ware.count == 0 then
            UserInfo:delWare(ware.wareid, ware.waretypeid)
        else
            UserInfo:addWare(ware.wareid, ware.waretypeid, ware.count)
        end
    end
end

-- 单个成就
function LobbyMsgController:handleGetSingleGrowAck(msg)
    JJLog.i(TAG, "handleGetSingleGrowAck")
    msg[MSG_TYPE] = GETSINGLEGROW_ACK
    local grow = msg.lobby_ack_msg.getsinglegrow_ack_msg
    UserInfo:addGrow(grow.growid, grow.growbalance)
end

-- 用户已报名比赛：定点，动态开赛点哪种
function LobbyMsgController:handleGetUserInterfixTourneyListAck(msg)
    JJLog.i(TAG, "handleGetUserInterfixTourneyListAck")
    local exmsg = TourneyChangeMsg.new()
    msg[MSG_TYPE] = GETUSERINTERFIXTOURNEYLIST_ACK
    local tourneylist = msg.lobby_ack_msg.getuserinterfixtourneylist_ack_msg.tourneylist
    for k, item in pairs(tourneylist) do
        local tourneyId = item.tourneyid
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
        if tourneyInfo ~= nil then
            if not (tourneyInfo.matchStartTime_ > 0 and tourneyInfo.matchStartTime_ < JJTimeUtil:getCurrentSecond()) then
                local signupItem = require("game.data.model.SignupItem").new()
                signupItem.tourneyId_ = tourneyId
                if tourneyInfo.matchconfig_ then
                    signupItem.productId_ = tourneyInfo.matchconfig_.productId
                    signupItem.matchName_ = tourneyInfo.matchconfig_.productName
                    signupItem.matchType_ = tonumber(tourneyInfo.matchconfig_.matchType)
                end

                local matchStartTime = DynamicTimeMatchManager:getMatchStartTime(tourneyId)
                if matchStartTime ~= nil and matchStartTime > 0 then
                    signupItem.startTime_ = matchStartTime
                end
                signupItem.matchPoint_ = tourneyInfo.matchStartTime_
                SignupStatusManager:addSignupedItemCls(signupItem)
                tourneyInfo.status_ = MatchDefine.STATUS_SIGNOUTABLE
                table.insert(exmsg.tourneyIdList_, tourneyId)
            end
        end
    end
    JJSDK:pushMsgToSceneController(exmsg)
end

-- 用户已报名比赛：定点，MatchPoint 哪种
function LobbyMsgController:handleGetUserMatchPointSignupTourneyListAck(msg)
    JJLog.i(TAG, "handleGetUserMatchPointSignupTourneyListAck")
    local exmsg = TourneyChangeMsg.new()
    msg[MSG_TYPE] = GETUSERMATCHPOINTSIGNUPTOURNEYLIST_ACK
    local tourneyid = msg.lobby_ack_msg.getusermatchpointsignuptourneylist_ack_msg.tourneyid
    local matchpointList = msg.lobby_ack_msg.getusermatchpointsignuptourneylist_ack_msg.matchpointlist
    for k, v in pairs(matchpointList) do
        local tourneyId = v.tourneyid
        local matchpoint = v.matchpoint
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)

        local mp = MatchPointManager:getMatchPoint(tourneyId, matchpoint)
        if not (mp == nil or mp.state ~= MatchDefine.TOURNEYSIGNUPING or matchpoint < JJTimeUtil:getCurrentSecond()) then
            if tourneyInfo ~= nil then
                local signupItem = require("game.data.model.SignupItem").new()
                signupItem.tourneyId_ = tourneyId

                local gameId = TourneyController:getGameIdByTourneyId(tourneyId)                
                local productId = 0
                if tourneyInfo.matchconfig_ then
                    productId = tourneyInfo.matchconfig_.productId
                end
                local matchConfigItem = MatchConfigManager:getMatchConfigItem(gameId, productId)
                if matchConfigItem ~= nil then
                    signupItem.matchName_ = matchConfigItem.productName
                    signupItem.matchType_ = tonumber(matchConfigItem.matchType)
                    signupItem.matchType_ = tonumber(matchConfigItem.matchType)
                end
                local matchStartServerTime = 0
                if matchpoint > 0 then
                    signupItem.startTime_ = matchpoint
                    matchStartServerTime = matchpoint
                else
                    local matchStartTime = DynamicTimeMatchManager:getMatchStartTime(tourneyId)
                    if matchStartTime ~= nil and matchStartTime > 0 then
                        signupItem.startTime_ = matchStartServerTime
                        matchStartServerTime = matchStartTime
                    end
                end
                signupItem.matchPoint_ = matchpoint
                signupItem.startTime_ = matchStartServerTime
                SignupStatusManager:addSignupedItemCls(signupItem)
                tourneyInfo.status_ = MatchDefine.STATUS_SIGNOUTABLE
                table.insert(exmsg.tourneyIdList_, tourneyId)
            end
        end
    end
    JJSDK:pushMsgToSceneController(exmsg)
end

function LobbyMsgController:handleTourneySigupexAck(msg)
    JJLog.i(TAG, "handleTourneySigupexAck")
    msg[MSG_TYPE] = TOURNEYSIGNUPEX_ACK
    local ack = msg.lobby_ack_msg.tourneysignupex_ack_msg
    if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
        local signupItem = SignupStatusManager:removeSignupingItem(ack.tourneyid)
        if signupItem ~= nil then
            signupItem.matchPoint_ = ack.matchpoint
            signupItem.matchId_ = 0
            if signupItem.matchPoint_ > 0 then
                signupItem.startTime_ = ack.matchpoint
            else
                local matchStartTime = DynamicTimeMatchManager:getMatchStartTime(ack.tourneyid)
                if matchStartTime ~= nil and matchStartTime > 0 then
                    signupItem.startTime_ = matchStartTime
                end
            end
            SignupStatusManager:addSignupedItemCls(signupItem)
        end
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(ack.tourneyid)
        local gameId = TourneyController:getGameIdByTourneyId(ack.tourneyid)
        local productId = 0
        if tourneyInfo ~= nil then
            tourneyInfo.status_ = MatchDefine.STATUS_SIGNOUTABLE
            if tourneyInfo.matchconfig_ then
                productId = tourneyInfo.matchconfig_.productId
            end
        end
        local matchConfigItem = MatchConfigManager:getMatchConfigItem(gameId, productId)
        if matchConfigItem and tonumber(matchConfigItem.productId) > 0 then
            local signupItem = require("game.data.model.SignupItem").new()
            signupItem.tourneyId_ = ack.tourneyid
            signupItem.productId_ = matchConfigItem.productId
            signupItem.matchName_ = matchConfigItem.productName
            signupItem.matchType_ = tonumber(matchConfigItem.matchType)
            local matchStartServerTime = 0
            if ack.matchpoint > 0 then
                signupItem.startTime_ = ack.matchpoint
                matchStartServerTime = ack.matchpoint
            else
                local matchStartTime = DynamicTimeMatchManager:getMatchStartTime(ack.tourneyid)
                if matchStartTime ~= nil and matchStartTime > 0 then
                    signupItem.startTime_ = matchStartServerTime
                    matchStartServerTime = matchStartTime
                end
            end
            signupItem.matchPoint_ = ack.matchpoint
            signupItem.startTime_ = matchStartServerTime
            SignupStatusManager:addSignupedItemCls(signupItem)
            if signupItem.matchType_ == MatchDefine.MATCH_TYPE_ISLAND then
                if productId == SignupStatusManager.exitProductId_ then
                    SignupStatusManager:setExitMatchIdProductId(0, 0)
                end
            end
        end
        local str = "报名成功 !"
        if tourneyInfo ~= nil then
            if tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_FIXED) then
                local matchPoint = ack.matchpoint
                local JJGameUtil = require("game.util.JJGameUtil")
                local timeStr = JJGameUtil:getMatchStartPointPrompt(matchPoint)
                if timeStr ~= nil then
                    str = str .. timeStr
                end
            end
        end
        local dimens = 0
        local top = JJSDK:getTopSceneController()
        if top ~= nil then
            dimens = top.dimens_
        end
        jj.ui.JJToast:show({
            text = str,
            dimens = dimens,
        })
    else
        SignupStatusManager:removeSignupingItem(ack.tourneyid)
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(ack.tourneyid)
        if tourneyInfo then
            tourneyInfo.status_ = MatchDefine.STATUS_SIGNUPABLE
        end
        local dimens = 0
        local top = JJSDK:getTopSceneController()
        if top ~= nil then
            dimens = top.dimens_
        end
        jj.ui.JJToast:show({
            text = "报名失败 " .. MatchDefine.toString(tonumber(msg.param)),
            dimens = dimens,
        })
    end
end

function LobbyMsgController:handleTourneyUnsignupAck(msg)
    msg[MSG_TYPE] = TOURNEYUNSIGNUP_ACK
    local ack = msg.lobby_ack_msg.tourneyunsignup_ack_msg
    if (msg.param and msg.param == 0) or not msg.param then
        ack.success_ = true
    else
        ack.success_ = false
    end
    if msg.param == MatchDefine.TK_MATCHSIGNUP_SUCCESS then
        SignupStatusManager:removeSignupedItem(ack.tourneyid)
    end
end

function LobbyMsgController:handleStartClientexAck(msg)
    JJLog.i(TAG, "handleStartClientexAck")
    msg[MSG_TYPE] = START_CLIENT_ACK
    local ack = msg.lobby_ack_msg.startclientex_ack_msg
    local productId = ack.productid
    local matchId = ack.matchid
    local tourneyId = ack.tourneyid
    local gameId = ack.gameid
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(ack.tourneyid, false)
    local signupItem = require("game.data.model.SignupItem").new()
    signupItem.productId_ = ack.productid
    signupItem.tourneyId_ = ack.tourneyid
    signupItem.startTime_ = 0
    signupItem.ticket_ = ack.ticket
    dump(ack.ticket)
    signupItem.matchId_ = ack.matchid
    SignupStatusManager:removeSignupedItem(ack.tourneyid)
    SignupStatusManager:addStartedItem(signupItem)
    if tourneyInfo then
        tourneyInfo.status_ = MatchDefine.STATUS_SIGNUPABLE
    end
end

-- SSO 消息
function LobbyMsgController:handleTicketTempExAck(msg)
    msg[MSG_TYPE] = GET_TICKET_TEMPEX_ACK
    local ack = msg.lobby_ack_msg.gettickettempex_ack_msg

    local lc = require("game.ui.controller.WebViewController")
    lc:handleMsg(msg)
end

-- 普通注册时的验证码（图片）
function LobbyMsgController:handleGetVerifyCodeAck(msg)
    msg[MSG_TYPE] = GET_VERIFY_CODE_ACK
    local ack = msg.lobby_ack_msg.getverifycode_ack_msg
end

-- 注册
function LobbyMsgController:handleRegisterAck(msg)
    msg[MSG_TYPE] = REGISTER_ACK
    local ack = msg.lobby_ack_msg.register_ack_msg
end

-- 获取短信验证码
function LobbyMsgController:handleURSSendRegSMSCodeAck(msg)
    msg[MSG_TYPE] = SEND_REGSMSCODE_ACK

    local ack = msg.lobby_ack_msg.urssendregsmscode_ack_msg
    JJLog.i(TAG, "handleURSSendRegSMSCodeAck", ack.phonenumber, ack.param)
end

-- 手机注册
function LobbyMsgController:handleMobileRegisterAck(msg)
    msg[MSG_TYPE] = MOBILE_REGISTER_ACK
    local ack = msg.lobby_ack_msg.mobileregister_ack_msg
end

-- 手机绑定
function LobbyMsgController:handleNoRegBindMobileAccAck(msg)
    msg[MSG_TYPE] = NOREGBIND_MOBILEACC_ACK
    local ack = msg.lobby_ack_msg.noregbindmobileacc_ack_msg
end

-- 个性注册绑定
function LobbyMsgController:handleNoRegBindDefaultAccAck(msg)
    msg[MSG_TYPE] = NOREGBIND_DEFAULTACC_ACK
    local ack = msg.lobby_ack_msg.noregbinddefaultacc_ack_msg
end

-- 验证用户名
function LobbyMsgController:handleVerifyLoginNameAck(msg)
    msg[MSG_TYPE] = VERIFY_LOGINNAME_ACK
    local ack = msg.lobby_ack_msg.verifyloginname_ack_msg
end

-- 验证手机号
function LobbyMsgController:handleVerifyLoginNameExistAck(msg)
    msg[MSG_TYPE] = VERIFY_LOGINNAMEEXIST_ACK
    local ack = msg.lobby_ack_msg.verifyloginnameexist_ack_msg
end


-- 被服务器踢掉
function LobbyMsgController:handleTerminateNotifyAck(msg)
    msg[MSG_TYPE] = TERMINATE_NOTIFY_ACK
    local ack = msg.lobby_ack_msg.terminatenotify_ack_msg
    MainController:onDisconnected()
    local dimens = 0
    local top = JJSDK:getTopSceneController()
    if top ~= nil then
        dimens = top.dimens_
    end
    jj.ui.JJToast:show({
        text = "您的帐号在其他地方登录了，即将断开连接！",
        dimens = dimens,
    })
end

-- 获取域积分
function LobbyMsgController:handleGetUserDomainGrowAck(msg)
    msg[MSG_TYPE] = GET_USER_DOMAIN_GROW_ACK
    local ack = msg.lobby_ack_msg.getuserdomaingrow_ack_msg
    local userId = ack.userid
    local growList = ack.growlist
    for i = 1, #growList do
        local grow = growList[i]
        UserInfo:addGrow(grow.growid, grow.value)
    end
end

--大厅广播消息
function LobbyMsgController:handleGetSysMsgExAck(msg)
    msg[MSG_TYPE] = GET_SYSMSGEX_ACK
    local ack = msg.lobby_ack_msg.getsysmsgex_ack_msg
    local msgList = ack.msglist
    local param = {}
    for i = 1, #msgList do
        local msg = msgList[i]
        param.to_whom = UserInfo.userId_
        if msg.title == nil or string.len(msg.title) == 0 then
            param.title = "[官方消息]"
        else
            param.title = msg.title
        end
        param.content = msg.content
        param.lup = msg.sendtime
        param.type = 10
        param.id = msg.sendtime
        NoteManager:saveSysNoteMsg(param)
    end
end

--咨询系统推送的咨询

function LobbyMsgController:handleLsPushInfoAck(msg)
-- <CltDisplay><Sender>竞技世界</Sender><Caption>充值结果</Caption><Content>您有一笔订单号为[201405271725000002433118],金额为[2 元]的充值操作已成功.</Content><SendTime>1401182800</SendTime></CltDisplay>    
    local function initPushData(xmlStr) 
        require("sdk.xml.LuaXml")    
        local xfile = xml.eval(xmlStr)
        local result = nil
        if xfile then
            result = {}
            for i,v in pairs(xfile) do           
                if (type(v) == "table") then
                    for j,k in pairs(v) do
                        if type(k) == "string" and k == "Caption" then
                            result.title = v[j+1]
                        end
                        if type(k) == "string" and k == "Content" then
                            result.content = v[j+1]
                        end
                        if type(k) == "string" and k == "Sender" then
                            result.sender = v[j+1]
                        end
                        if type(k) == "string" and k == "SendTime" then
                            result.lup = v[j+1]
                        end
                    end
                end
            end
        end
        return result
    end

    msg[MSG_TYPE] = PUSH_INFO_ACK
    local ack = msg.lobby_ack_msg.lspushinfo_ack_msg
    local msgList = ack.msgitem
    for i = 1, #msgList do
        local msg = msgList[i]
        local param = initPushData(msg.displayxml)
        if param ~= nil and param.content ~= nil and type(param.content) == "string" and string.find(param.content, "Welcome.html") == nil then
            param.to_whom = UserInfo.userId_
            param.title = param.title or "[官方消息]"
            param.type = 10
            param.id = param.lup or 0            
            NoteManager:saveSysNoteMsg(param)
        end
    end
end

-- 修改积分的反馈
function LobbyMsgController:handleModifyGrowAck(msg)
    JJLog.i(TAG, "handleModifyGrowAck")
    msg[MSG_TYPE] = MODIFY_GROW_ACK
end
