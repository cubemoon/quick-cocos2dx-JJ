--[[
登录模块：包括登录相关消息流程的处理和登录历史信息的处理
]]
LoginController = {}
local TAG = "[LoginController]"
local roarInterface = require("game.thirds.RoarInterface")
local payDef = require("game.def.PayDef")
local settings = require("game.settings.Settings")

LOGIN_TYPE_NONE = 1
LOGIN_TYPE_JJ = 2 -- JJ账号登录
LOGIN_TYPE_NOREG = 3 -- 免注册
LOGIN_TYPE_RANDOM_PWD = 4 -- 随机密码

-- 登录参数
LoginController.type_ = LOGIN_TYPE_NONE -- 最后一次登录类型
LoginController.username_ = ""
LoginController.password_ = ""
LoginController.specCode_ = nil -- 免注册登录参数
LoginController.loginData_ = nil -- 登录历史数据

LoginController.STATE_UNLOGIN = 0
LoginController.STATE_LOGINING = 1
LoginController.STATE_LOGIN = 2
LoginController.loginState_ = LoginController.STATE_UNLOGIN

LoginController.firstLoginSuc_ = true -- 应用启动后，第一次登录成功

local SPEC_CODE_FILE = "data/speccode.lua"

function LoginController:init()
    JJLog.i(TAG, "init")

    -- 从文件读出之前的登录信息
    self.loginData_ = require("game.data.login.LoginData")
    self.loginData_:init()

    self.type_, self.username_, self.password_ = self.loginData_:getLastRecord()
    self:initSpecCode()
end

-- 设置登录参数，设置后调用 startLogin 开始登录流程
function LoginController:setLoginParam(loginType, name, pw)
    JJLog.i(TAG, "setLoginParam, loginType=", loginType)
    self.type_ = loginType
    self.username_ = name
    self.password_ = pw
end

-- 重新获取最后一次登录参数
function LoginController:reInitLastRecord()
    self.type_, self.username_, self.password_ = self.loginData_:getLastRecord()
end

-- 开始登录流程
function LoginController:startLogin()
    if Util:isG10086() or Util:isQihu360() then
        payDef:initG10086Sdk()
        local enable = payDef:getG10086IsMusicEnabled()
        JJLog.i(TAG, "startLogin, enable=", enable)
        settings:setSoundBg(enable)
    end
    self.loginState_ = LoginController.STATE_LOGINING
    MainController:setAutoLogin(true)
    MainController:startConnect(true)
end

-- 随机生成一个数字或者字符
local HEX = "0123456789ABCDEF"
local function getRandomHEX()
    local index = math.random(#HEX)
    return string.sub(HEX, index, index)
end

-- 随机生成一个 IMEI 串
local function getRandomIMEI()
    local imei = ""
    for i=1,15 do
        imei = imei .. getRandomHEX()
    end
    return imei
end

-- 随机生成 MAC 串
local function getRandomMAC()
    local mac = ""
    for i=1,6 do
        for j=1,2 do
            mac = mac .. getRandomHEX()
        end
        if i ~= 6 then
            mac = mac .. ":"
        end
    end
    return mac
end

-- 初始化免注册登录串
function LoginController:initSpecCode()
    JJLog.i(TAG, "initSpecCode")
    if device.platform == "android" then
        if self.specCode_ == nil then
            className = "cn/jj/base/JJUtil"
            methodName = "GetLocalData"
            args = {"speccode"}
            sig = "(Ljava/lang/String;)Ljava/lang/String;"
            result, self.specCode_ = luaj.callStaticMethod(className, methodName, args, sig)
            JJLog.i(TAG, "result = ",result,"self.specCode_ = ",self.specCode_)
        end
    else
        local tmp = LuaDataFile.get(SPEC_CODE_FILE)
        if tmp ~= nil then
            self.specCode_ = tmp.code
        end
        JJLog.i(TAG, "initSpecCode, code=", self.specCode_)
        if self.specCode_ == nil then
            local IMEI = Util:getIMEI()
            local MAC = Util:getMacAddress()
            if IMEI == nil or string.len(IMEI) == 0 then
                IMEI = getRandomIMEI()
            end
            if MAC == nil or string.len(MAC) == 0 then
                MAC = getRandomMAC()
            end

            IMEI = string.upper(IMEI)
            MAC = string.upper(MAC)

            self.specCode_ = "JJ002_Android" .. crypto.md5(IMEI) .. crypto.md5(MAC)
            LuaDataFile.save({ code = self.specCode_ }, SPEC_CODE_FILE)
        end
    end
end

function LoginController:getJJ()
    return self.loginData_:getJJ()
end

-- 登录
function LoginController:login()
    if self.type_ == LOGIN_TYPE_JJ then
        self:loginJJ()
    elseif self.type_ == LOGIN_TYPE_NOREG or self.type_ == LOGIN_TYPE_NONE then
        -- 如果没有取到记录，默认为免注册登录
        self.type_ = LOGIN_TYPE_NOREG
        self:loginNoReg()
    elseif self.type_ == LOGIN_TYPE_RANDOM_PWD then
        self:loginRandomPWD()
    else
        echoError("LoginController:login, NONE Login type!!!")
    end
end

-- 登出
function LoginController:logout()
    JJLog.i(TAG, "logout")
    if MainController:isConnected() and UserInfo.userId_ ~= 0 then
        LobbyMsg:sendLogoutReq(UserInfo.userId_)
        LoginController.loginState_ = LoginController.STATE_UNLOGIN
    end
end

-- JJ账号登录
function LoginController:loginJJ()
    JJLog.i(TAG, "loginJJ, username=", self.username_, ", password=", self.password_)
    LobbyMsg:sendGeneralLoginReq(self.username_, self.password_, Util:getMacAddress())
end

-- 免注册登录
function LoginController:loginNoReg()
    JJLog.i(TAG, "loginNoReg, specCode=", self.specCode_)
    LobbyMsg:sendNoRegLoginReq(self.specCode_, Util:getMacAddress())
end

-- 随机密码登录
function LoginController:loginRandomPWD()
    JJLog.i(TAG, "loginRandomPWD, username=", self.username_, ", password=", self.password_)
end

-- 免注册登录
function LoginController:handleNoRegLoginAck(msg)
    JJLog.i(TAG, "handleNoRegLoginAck")
    local ack = msg.lobby_ack_msg.noreglogin_ack_msg
    if msg.param == 0 then
        JJLog.i(TAG, "Login Success")
        self:loginSuccess(ack.userinfo)
    else
        JJLog.i(TAG, "Login Failed")
        self:loginFailed(msg.param)
    end
end

function LoginController:handleGeneralLoginAck(msg)
    JJLog.i(TAG, "handleGeneralLoginAck")
    local ack = msg.lobby_ack_msg.generallogin_ack_msg
    if msg.param == 0 then
        JJLog.i(TAG, "Login Success")
        self:loginSuccess(ack.userinfo)
    else
        JJLog.i(TAG, "Login Failed")
        self:loginFailed(msg.param)
    end
end

function LoginController:loginSuccess(userinfo)
    JJLog.i(TAG, "loginSuccess")
    self.loginState_ = LoginController.STATE_LOGIN
    UserInfo.userId_ = userinfo.userid
    UserInfo.nickname_ = userinfo.nickname
    UserInfo.figureId_ = userinfo.figureid
    UserInfo.gold_ = userinfo.gold
    UserInfo.cert_ = userinfo.cert
    UserInfo.totalScore_ = userinfo.score
    UserInfo:setMaxScore(userinfo.score)
    UserInfo.totalMasterScore_ = userinfo.masterscore

    Util:registerLuaLogReportNickname(UserInfo.nickname_)

    --最后一次登录时间   lifeng 2014.06.04 用于本地PUSH
    local lastLogin = require("game.data.push.LastLogin")
    lastLogin:saveLastLogin(JJTimeUtil:getCurrentServerTime())

    self:askUserInfo()

    self.loginData_:addRecord(self.type_, self.username_, self.password_)

    -- 判断是否更新头像id，需要更新则删除头像缓存
    -- if HeadImgManager:getHeadIdToUserId(UserInfo.userId_) ~=nil and
    --     HeadImgManager:getHeadIdToUserId(UserInfo.userId_) ~= UserInfo.figureId_ then
        -- ImageCacheManager:deleteCacheData(JJWebViewUrlDef.URL_GET_HEAD_ICON.. UserInfo.userId_)
    -- end
    -- HeadImgManager:saveHeadIdToUserId(UserInfo.figureId_, UserInfo.userId_)

    -- 重设Web View Cookie状态
    Util:resetCookie(false)
    local WebViewController = require("game.ui.controller.WebViewController")
    WebViewController:getSSOAndCookie()

    local msg = require("game.message.LoginResultMsg").new(true)
    JJSDK:pushMsgToSceneController(msg)
    roarInterface:initRoarAllMsg(UserInfo.userId_)--初始化一下咆哮数据
    roarInterface:getAllRoarRemindData()--获取提醒数据
    HttpMsg:sendRoarGroupCcpAppConfigReq(MainController.curPackageId_)--  云通讯配置
    roarInterface:getRoarOfflineCloudReq(UserInfo.userId_)--语音离线获取
    roarInterface:getRoarAllRemindMsg()
end

function LoginController:loginFailed(param)
    JJLog.i(TAG, "loginFailed")
    self.loginState_ = LoginController.STATE_UNLOGIN
    MainController:disconnect()

    -- 重置用户信息
    UserInfo:reset()

    local msg = require("game.message.LoginResultMsg").new(false)
    JJSDK:pushMsgToSceneController(msg)
    roarInterface:initRoarAllMsg(-1)--初始化一下咆哮数据
end

-- 登录成功后，请求获取用户的数据：成就、物品、已报名等
function LoginController:askUserInfo()
    JJLog.i(TAG, "askUserInfo")
    -- 请求成就
    if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_HALL then
        LobbyMsg:sendGetUserAllGrowReq(UserInfo.userId_)
    else
        LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine.JJ_DOMAIN_COMMON, CURRENT_PACKAGE_ID)

        -- 只有斗地主合集包特殊
        if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_UNION or CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_UNION_HL then
            LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD), JJGameDefine.GAME_ID_LORD)
            LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_HL), JJGameDefine.GAME_ID_LORD_HL)
            LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_PK), JJGameDefine.GAME_ID_LORD_PK)
            LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(JJGameDefine.GAME_ID_LORD_LZ), JJGameDefine.GAME_ID_LORD_LZ)
        else
            LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, JJGameDefine:getDomainId(CURRENT_PACKAGE_ID), CURRENT_PACKAGE_ID)
        end
    end

    -- 请求金豆
    local platform_ = device.platform
    JJLog.i(TAG, "LoginController:askUserInfo, platform_=", platform_)
    if platform_ == "mac" or platform_ == "ios" then
        LobbyMsg:sendGetAccNumMoneyReq(UserInfo.userId_, 0, 200) -- 200：金豆
    end

    -- 请求物品
    LobbyMsg:sendGetUserAllWareReq(UserInfo.userId_)

    -- 获取临时头像积分
    LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, 83)

    -- 请求抽奖积分
    LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, 7101)

    -- 请求VIP积分：TODO: VIP积分需要动态获取
    LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, 1000002)

    -- 请求变大厅积分
    LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, 7201)

    local JJGameUtil = require("game.util.JJGameUtil")
    if JJGameUtil:checkChangeToHall() then
        LobbyMsg:sendModifyGrowReq(UserInfo.userId_, 7201, 1)
    end

    -- 请求任务积分
    -- LobbyMsg:sendGetUserDomainGrowReq(UserInfo.userId_, 1100, CONFIG_GAME_ID)

    -- 请求头像
    HeadImgManager:getImg(UserInfo.userId_, UserInfo.figureId_)

    -- 只有第一次登录成功才需要更新的内容
    if self.firstLoginSuc_ then
        -- 更新物品
        HttpMsg:sendGetWareReq(CONFIG_GAME_ID, WareInfoManager:getTimeStamp(), 0, false)

        -- 充值配置
        local payconfig = require("game.data.config.PayConfigManager")
        payconfig:init()
        HttpMsg:sendPayConfig(CURRENT_PACKAGE_ID, payconfig:getTimeStamp())

        --动态显隐配置
        HttpMsg:sendDisplayModule(CURRENT_PACKAGE_ID)
    end
    --Push
    local pushconfig = require("game.data.push.PushData").new()
    HttpMsg:sendPushReq(CURRENT_PACKAGE_ID, pushconfig.TYPE_AD, pushconfig:getLastUpdate(pushconfig.TYPE_AD))
    HttpMsg:sendPushReq(CURRENT_PACKAGE_ID, pushconfig.TYPE_LOCAL, pushconfig:getLastUpdate(pushconfig.TYPE_LOCAL))

    LobbyMsg:sendGetUserInterfixTourneyListReq(UserInfo.userId_)

    self.firstLoginSuc_ = false
end

--验证登录名方法提供给登录时使用，成功返回nil，否则返回失败原因的字符串，可以提供提示用
--注意因为和之前账号兼容，只处理是否为空的情况，超长和超短不处理
function LoginController:checkUserName(username)
    JJLog.i(TAG, "checkUserName",username)
    local ret = nil

    local len = 0
    if (username ~= nil) then
        len = string.len(username)
    end

    if len == 0 then
        ret = "用户名不能为空！"
        JJLog.i(TAG, "checkUserName, ERR: username is nil")
    end

    return ret
end

--验证注册时登录名方法，成功返回nil，否则返回失败原因的字符串，可以提供提示用
function LoginController:checkRegisterUserName(username)
    JJLog.i(TAG, "checkRegisterUserName", username)
    local ret = nil

    local len = 0
    if (username ~= nil) then
        len = string.len(username)
    end

    local num = tonumber(username)
    if (num and num > 10000000000 and num < 30000000000) then
        ret = "帐号不能为开头是1或2的11位数字"
        return ret
    end

    if len == 0 then
        ret = "用户名不能为空！"
        JJLog.i(TAG, "checkRegisterUserName, ERR: username is nil")
    elseif len < 4 then
        ret = "帐号长度不能小于4位"
        JJLog.i(TAG, "checkRegisterUserName, ERR: username is short")
    elseif len > 18 then
        ret = "用户名过长！"
        JJLog.i(TAG, "checkRegisterUserName, ERR: username is long")
    end

    local index1 = 0
    index1 = string.find(username,"jj", 1 ,true)
    if index1 ~= nil and index1 > 0  then
        ret = "帐号包含非法字符"
        return ret
    end

    index1 = string.find(username,"JJ", 1 ,true)
    if index1 ~= nil and index1 > 0  then
        ret = "帐号包含非法字符"
        return ret
    end

    index1 = string.find(username,"jJ", 1 ,true)
    if index1 ~= nil and index1 > 0  then
        ret = "帐号包含非法字符"
        return ret
    end

    index1 = string.find(username,"Jj", 1 ,true)
    if index1 ~= nil and index1 > 0  then
        ret = "帐号包含非法字符"
        return ret
    end  

    return ret
end

--验证登录密码方法，成功返回nil，否则返回失败原因的字符串，可以提供提示用
--针对密码超短不做处理
function LoginController:checkPassword(password)
    JJLog.i(TAG, "checkPassword")
    local ret = nil

    local len = 0

    if(password ~= nil) then
        len = string.len(password)
    end

    if len == 0 then
        ret = "密码不能为空！"
        JJLog.i(TAG, "checkPassword, ERR: password is nil")
    end

    return ret
end

return LoginController