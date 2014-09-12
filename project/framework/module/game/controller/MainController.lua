MainController = {}
local TAG = "MainController"

require("game.def.JJGameDefine")
require("game.def.JJSceneDef")
require("game.def.ClientSwDef")
require("game.util.CrashHandler")
require("game.config.GlobalConfigManager")
require("game.config.ServerConfigManager")
require("game.msg.MsgController")
require("game.util.JJTimeUtil")
require("game.data.lobby.LobbyData")
require("game.pb.SendMsg")
require("game.pb.LobbyMsg")
require("game.pb.MobileAgentMsg")
require("game.settings.Settings")
require("game.util.JJGameUtil")
require("game.data.headimg.HeadImgManager")
require("game.message.GameMsgDef")
require("game.data.model.UserInfo")
require("game.controller.LobbyDataController")
require("game.data.model.NoteManager")
require("game.controller.LoginController")
require("game.def.JJWebViewUrlDef")
require("game.data.config.WareInfoManager")
require("game.data.config.GrowInfoManager")
require("game.data.analytics.JJAnalytics")
require("game.recommend.MatchRecommendManager")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local rankInterface = require("game.thirds.RankInterface")
local roarInterface = require("game.thirds.RoarInterface")
local shareInterface = require("game.thirds.ShareInterface")

-- 连接管理
local connectManager = require("sdk.connect.ConnectManager")

MainController.packageId_ = 0 -- 该包的ID，应用生命周期内唯一不变的
MainController.curPackageId_ = 0 -- 当前运行的包是哪一个（从大厅进入其它单包时会变化）
MainController.curGameId_ = 0 -- 当前那个游戏在前台
MainController.autoLogin_ = true -- 回到登录界面是否自动登录
MainController.breakReconnect_ = false -- 是否要进行断线重连

local loginReq_ = false -- 本次连接请求是否要执行登录流程。比如获取验证吗这种是不需要走登录流程的

local BACKGROUND_KILL_TICK = 900 -- 切后台15分钟杀程序
local backgroundTick = 0 -- 切到后台的时间点
local lastCheckBackgroundTick = 0
local BACKGROUND_KILL_CHECK_TICK = 60 -- 检查周期

local gameFinishCB_ = {} -- 游戏结束时的回调，进入游戏时注册，回到大厅后调用并取消注册
local luaPath_ = nil -- 大厅中 Lua 搜索路径的备份，从游戏回到大厅时用于重置

--[[
    初始化
    @packageId: 这个包的定义
]]
function MainController:init(packageId)
    JJLog.i(TAG, "init")

    luaPath_ = package.path
    JJLog.i(TAG, "init, luaPath_=", luaPath_)

    -- 设置 FPS 30 帧
    Util:setFrameTick(33)
    self.packageId_ = packageId
    self.curPackageId_ = packageId
    self.curGameId_ = packageId
    JJSDK:registerMsgListener(handler(self, self.handleMsg))
    JJSDK:registerTimerListener(handler(self, self.handleTimer))
    jj.ui.setOnClickSoundMute(not Settings.getSoundEffect())
    jj.ui.setOnClickSound("sound/common_s_click.mp3")
    HeadImgManager:init()
    LoginController:init()
    JJAnalytics:init(packageId)

    -- 更新 GlobalConfig
    GlobalConfigManager:update(packageId)
    -- 更新 ServerConfig
    ServerConfigManager:init()
    ServerConfigManager:update()

    shareInterface:setShareGameUrl()
    MatchRecommendManager:startCheckRecomMatchPrompt()

    -- 如果是大厅包，处于后台退出时间设置为1小时
    if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_HALL then
        BACKGROUND_KILL_TICK = 3600
    end

    -- 启动后，过段时间，上传 Dump 文件
    require("game.controller.DumpManager"):start()

    -- 上传更新失败以及获取游戏节点失败的统计
    require("upgrade.controller.UpgradeController"):sendUpgradeError()
end

--[[
    退出
]]
function MainController:exit()
    LoginController:logout()
    local JJGameUtil = require("game.util.JJGameUtil")
    JJGameUtil:exit()
    shareInterface:stopSDK()
    self:disconnect()
    -- app:exit()
    Util:exitApp()
end

function MainController:setCurPackageId(packageId)
    JJLog.i(TAG, "setCurPackageId, packageId=", packageId)
    self.curPackageId_ = packageId
end

function MainController:getCurPackageId()
    return self.curPackageId_
end

function MainController:setCurGameId(gameId)
    JJLog.i(TAG, "setCurGameId, gameId=", gameId)
    self.curGameId_ = gameId
end

function MainController:getCurGameId()
    return self.curGameId_
end

function MainController:setAutoLogin(flag)
    self.autoLogin_ = flag
end

function MainController:getAutoLogin()
    return self.autoLogin_
end

local function _getPre(packageId)
    local table = JJSceneDef.PRE_[packageId]
    if table ~= nil then
        return table[1], table[2]
    end
    return "", ""
end

--[[
    用于规则的 Scene/Controller 命名，获取全名称。
    由于有些界面的控制器完全不需要重载，使用基类功能即可，增加一个 basecontroller 的返回值
    @gameId: 游戏
    @return:
    basecontroller/controller, scene
    nil: 无此界面
]]
local function _getSceneNameByGameId(gameId, sceneId)
    --[[
        @errId
        1: 没有这个GameId
        2: 没有这个界面
        3: 界面文件未找到
    ]]
    local function err(errId)
        JJLog.e(TAG, "_getSceneNameByGameId ERROR=", errId, ", gameId=", gameId, ", sceneId=", sceneId)
    end

    local pre, filePre = _getPre(gameId)

    if pre ~= nil then
        if JJSceneDef.param_[sceneId] ~= nil then
            local baseController = "game.ui.controller." .. JJSceneDef.param_[sceneId][1]
            local baseScene = "game.ui.scene." .. JJSceneDef.param_[sceneId][2]
            local controller = pre .. "controller." .. filePre .. JJSceneDef.param_[sceneId][1]
            local scene = pre .. "scene." .. filePre .. JJSceneDef.param_[sceneId][2]

            local baseControllerPath = string.gsub(baseController, "%.", "/")
            local baseScenePath = string.gsub(baseScene, "%.", "/")
            local controllerPath = string.gsub(controller, "%.", "/")
            local scenePath = string.gsub(scene, "%.", "/")

            local controllerExist = JJFileUtil:exist(controllerPath .. ".lua")
            local sceneExist = JJFileUtil:exist(scenePath .. ".lua")
            
            -- [Yangzukang][2014.08.20]特殊处理，斗地主最早的包是有 LordUnionPlayScene 的，后面去掉了，APK 包里的还在，未升级 APK 的话，会导致找到了之前的文件
            if gameId == JJGameDefine.GAME_ID_LORD_UNION and sceneExist then
                local i, j = string.find(scenePath, "PlayScene")
                if i then
                    sceneExist = false
                end
            end

            if (controllerExist or JJFileUtil:exist(baseControllerPath .. ".lua")) and (sceneExist or JJFileUtil:exist(baseScenePath .. ".lua")) then

                if not controllerExist then
                    controller = baseControllerPath
                end
                if not sceneExist then
                    scene = baseScene
                end

                return controller, scene
            else
                err(3)
            end
        else
            err(2)
        end
    else
        err(1)
    end
end

--[[
    切换到某个界面
    @gameId: 游戏
    @sceneId: 界面
    @...: 参数
]]
function MainController:pushScene(gameId, sceneId, ...)
    JJLog.i(TAG, "pushScene, gameId=", gameId, ", sceneId=", sceneId)
    local controller, scene = _getSceneNameByGameId(gameId, sceneId)
    JJLog.i(TAG, "pushScene, controller=", controller, ", scene=", scene)
    if controller ~= nil and scene ~= nil then
        JJSDK:pushScene(sceneId, controller, scene, ...)
    end
end

function MainController:changeToScene(gameId, sceneId, ...)
    JJLog.i(TAG, "changeToScene, gameId=", gameId, ", sceneId=", sceneId)
    local controller, scene = _getSceneNameByGameId(gameId, sceneId)
    JJLog.i(TAG, "changeToScene, controller=", controller, ", scene=", scene)
    if controller ~= nil and scene ~= nil then
        JJSDK:changeToScene(sceneId, controller, scene, ...)
    end
end

--[[
    将界面从栈中清除掉
]]
function MainController:removeScene(gameId, sceneId)
    JJLog.i(TAG, "removeScene, gameId=", gameId, ", sceneId=", sceneId)
    local controller = _getSceneNameByGameId(gameId, sceneId)
    if controller ~= nil then
        JJSDK:removeScene(controller)
    end
end

--[[
    将传入界面之上的所有界面从栈中清除掉，但不跳转到传入界面（和 ChangeToScene 的区别）
]]
function MainController:removeToScene(gameId, sceneId)
    JJLog.i(TAG, "removeToScene, gameId=", gameId, ", sceneId=", sceneId)
    local controller = _getSceneNameByGameId(gameId, sceneId)
    if controller ~= nil then
        JJSDK:removeToScene(controller)
    end
end

--[[
    判断是否支持这个游戏
]]
local function _supportGame(gameId)
    local support = false
    -- 游戏包模式
    if RUNNING_MODE == RUNNING_MODE_GAME then
        if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_UNION or CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_UNION_HL then
            if gameId == JJGameDefine.GAME_ID_LORD or gameId == JJGameDefine.GAME_ID_LORD_HL or gameId == JJGameDefine.GAME_ID_LORD_PK or gameId == JJGameDefine.GAME_ID_LORD_LZ then
                support = true
            end
        elseif gameId == CURRENT_PACKAGE_ID then
            support = true
        end
    else -- 大厅模式
        -- TODO: 调用大厅接口来判断是否支持
        local gameUtil = require("game.util.JJGameUtil")
        support = gameUtil:luaGameExist(gameId)
    end

    return support
end

local function handleNewMatchStartDelay()
    local top = JJSDK:getTopSceneController()
    if top ~= nil and top.showNewMatchStart ~= nil and StartedMatchManager.newMatchParam_ ~= nil then
        top:showNewMatchStart(StartedMatchManager.newMatchParam_)
    end
end

-- 消息处理接口：分发消息
function MainController:handleMsg(msg)
    JJLog.i(TAG, "handleMsg, type=", msg.type)
    -- 网络连接状态消息
    if msg.type == SDKMsgDef.TYPE_NET_STATE then
        JJLog.i(TAG, "handleMsg, state=", msg.state)
        if msg.state == kJJSocketRequestStateConnecting then -- 开始连接
            JJLog.i(TAG, "handleMsg, start connect")
        elseif msg.state == kJJSocketRequestStateConnected then -- 连接成功
            JJLog.i(TAG, "handleMsg, connected")
            require("game.pb.PBMsg")
            UserInfo:reset()
            SignupStatusManager:reset() -- tourney init
            rankInterface:init() --排行榜初始化
--            rankInterface:updateRankingRuleReq() --排行榜规则获取
            roarInterface:init() --咆哮初始化
            if loginReq_ == true then
                LobbyMsg:sendAnonymouseBrowseReq()
                HttpMsg:sendRoarGroupCcpAppConfigReq(MainController.curPackageId_) --  云通讯配置
                MobileAgentMsg:sendPhoneInfoReq(ORIGINAL_PACKAGE_ID)
                LoginController:login()
            end

        elseif msg.state == kJJSocketRequestStateDisconnect then -- 连接断开
            JJLog.i(TAG, "handleMsg, disconnect")

            -- 如果当前在 WebView，关闭它
            local top = JJSDK:getTopSceneController()
            if top ~= nil and top:getSceneId() == JJSceneDef.ID_WEB_VIEW then
                JJSDK:popScene()
            end

            -- 统一处理断线: 当前需要断线重连才执行
            JJLog.i(TAG, "handleMsg, self.autoLogin_=", self.autoLogin_, ", isLogin=", UserInfo:isLogin())
            -- 登录成功，并且非单机界面断线，才会断线重连
            if self.autoLogin_ and UserInfo:isLogin() and self:getCurGameId() ~= JJGameDefine.GAME_ID_LORD_SINGLE then
                self.breakReconnect_ = true
            end
            JJLog.i(TAG, "handleMsg, self.breakReconnect_=", self.breakReconnect_)

            roarInterface:initRoarAllMsg(-1); --状态改变时初始化一下咆哮数据
            MainController:setNeedPromptNoRegBind(false);
            ConnectManager:disconnect()
            UserInfo:reset()
            SignupStatusManager:reset()
            LoginController.loginState_ = LoginController.STATE_UNLOGIN
            finishThirdActivityLua()

        elseif msg.state == kJJSocketRequestStateFail then -- 连接失败
            JJLog.i(TAG, "handleMsg, connect fail")
            LoginController.loginState_ = LoginController.STATE_UNLOGIN
            UserInfo:reset()
            ConnectManager:disconnect()
        end
        JJSDK:pushMsgToSceneController(msg)

    -- 网络消息
    elseif msg.type == SDKMsgDef.TYPE_NET_MSG then
        local decodeMsg = MsgController.handleMsg(msg)

        if decodeMsg == nil then
            JJLog.i(TAG, "handleMsg, SDKMsgDef.TYPE_NET_MSG msg is null")
            return
        end

        JJLog.i(TAG, "netmsg, category=", decodeMsg[MSG_CATEGORY], ", type=", decodeMsg[MSG_TYPE])

        --打印消息
        JJLog.printNetMsg("ACK",decodeMsg)

        -- 开赛消息统一处理
        if decodeMsg[MSG_CATEGORY] == LOBBY_ACK_MSG and decodeMsg[MSG_TYPE] == START_CLIENT_ACK then
            JJLog.i(TAG, "startGameClient")
            local ack = decodeMsg.lobby_ack_msg.startclientex_ack_msg
            local matchId = ack.matchid
            local gameId = ack.gameid
            JJLog.i(TAG, "startGameClient, gameId=", gameId, ", matchId=", matchId, "pid=", ack.productid)
            if _supportGame(gameId) then
                local matchConfig = MatchConfigManager:getMatchConfigItem(gameId, ack.productid)
                local startGameParam
                if matchConfig ~= nil then
                    startGameParam = require("game.data.model.StartGameParam").new()
                    startGameParam.gameId_ = ack.gameid
                    startGameParam.productId_ = ack.productid
                    startGameParam.desk_ = tonumber(matchConfig.desk)
                    startGameParam.matchType_ = tonumber(matchConfig.matchType)
                    startGameParam.matchId_ = matchId
                    startGameParam.startType_ = 1
                    startGameParam.tourneyId_ = ack.tourneyid
                    startGameParam.ticket_ = ack.ticket

                    -- 如果当前在 WebView，关闭它
                    Util:closeWebActivity()
                    local top = JJSDK:getTopSceneController()
                    if top ~= nil and top:getSceneId() == JJSceneDef.ID_WEB_VIEW then
                        JJSDK:popScene()
                    end
                else
                    return
                end
                -- 当前启动的比赛和当前比赛是同一个，应该是断线重连，啥也不做
                if StartedMatchManager:getMatch(matchId) ~= nil then
                    JJLog.i(TAG, "StartedMatchManager:getMatch(matchId) ~= nil matchId =",matchId)
                    MatchMsg:sendEnterMatchReq(startGameParam.matchId_, startGameParam.gameId_, startGameParam.ticket_)
                    return
                end
                local top = JJSDK:getTopSceneController()
                JJLog.i(TAG, "top=", top)

                local bIsPlayingSingleLord = false
                if top and top:getSceneId() == JJSceneDef.ID_SINGLE_LORD_PLAY then
                    bIsPlayingSingleLord = true
                end
                -- 比赛过程中，新比赛开始，保存开赛参数
                if StartedMatchManager:existsMatch(ack.tourneyid) or bIsPlayingSingleLord then
                    JJLog.i(TAG, "StartedMatchManager:existsMatch()", top)
                    if top ~= nil then
                        local param = startGameParam
                        param.name = matchConfig.productName
                        StartedMatchManager.newMatchStartTimeStamp_ = getCurrentSecond() --取本地时间，仅仅只需要时间差
                        JJLog.i(TAG, "newMatchStartTimeStamp_ ", StartedMatchManager.newMatchStartTimeStamp_)
                        if StartedMatchManager.newMatchParam_ ~= nil and top.exitNewMatchAndAlertAnotherOne ~= nil and top.inGameScene ~= nil then
                            top:exitNewMatchAndAlertAnotherOne()
                        end
                        StartedMatchManager.newMatchParam_ = param
                    end
                end
                --glsurfaceview在前台
                if Util:isAppActive() then

                    JJLog.i(TAG, "StartedMatchManager:getMatchCount()",StartedMatchManager:getMatchCount(),self.curGameId_,", top:getSceneId() = ",top:getSceneId())
                    --当前有比赛或者在单机斗地主中则弹框询问
                    if StartedMatchManager:existsMatch(ack.tourneyid) or bIsPlayingSingleLord then
                        JJLog.i(TAG, "lilc111,top.newMatchParam_ = ",top.newMatchParam_)
                        -- 不是原生界面，弹 Lua 的提示框（模式）
                        if top ~= nil and top.inGameScene ~= nil and top.showNewMatchStart ~= nil and StartedMatchManager.newMatchParam_ ~= nil then
                            top:showNewMatchStart(StartedMatchManager.newMatchParam_)
                        else
                            scheduler.performWithDelayGlobal(handleNewMatchStartDelay, 2)
                        end
                    else -- 如果当前没有比赛在进行，直接启动
                        JJLog.i(TAG, "not StartedMatchManager:existsMatch()")

                        -- 退出老比赛
                        if top ~= nil then
                            JJLog.i(TAG, "top.exitMatch=", top.exitMatch)
                        end
                        if top ~= nil and top.exitMatch ~= nil then
                            top:exitMatch(false)
                            JJSDK:removeScene(top:getTag())
                        end
                        MainController:startGameScene(gameId, startGameParam)
                    end
                --glSurfaceview in background
                else
                    finishThirdActivityLua()
                    local JJNotificationManager = require("game.alarm.JJNotificationManager")
                    JJNotificationManager:setNotification(JJNotificationManager.NOTIFICATION_TYPE_BEGIN_HANDLE)
                    -- 如果当前没有比赛在进行，或者是再来一局的情况，直接启动
                    if not StartedMatchManager:existsMatch(ack.tourneyid) then
                        JJLog.i(TAG, "StartedMatchManager:getMatchCount() bg")
                        -- 退出老比赛
                        if top ~= nil then
                            JJLog.i(TAG, "top.exitMatch=", top.exitMatch)
                        end
                        if top ~= nil and top.exitMatch ~= nil then
                            top:exitMatch(false)
                            JJSDK:removeScene(top:getTag())
                        end
                        MainController:startGameScene(gameId, startGameParam)
                    --在比赛中来了新比赛
                    else
                        JJLog.i(TAG, "newGameStart matchId",matchId, top,startGameParam)
                    end
                end
            end
        end
    -- 切换至前台
    elseif msg.type == SDKMsgDef.TYPE_ENTER_FORGROUND then
        backgroundTick = 0
    -- 切换至后台
    elseif msg.type == SDKMsgDef.TYPE_ENTER_BACKGROUND then
        backgroundTick = getCurrentSecond()
        -- 设置闹钟
        local alarmManager = require("game.alarm.JJAlarmManager")
        alarmManager:setMatchAlarm()
    -- 网络卡
    elseif msg.type == SDKMsgDef.TYPE_NET_LAZY then
        JJLog.i(TAG, "SDKMsgDef.TYPE_NET_LAZY")
        JJSDK:pushMsgToSceneController(msg)
    end
end

--[[
    开始连接网络
    @login: 是否是登录流程，登录流程的话，MainController 会统一处理Socket连接的状态消息
]]
function MainController:startConnect(login)
    JJLog.i(TAG, "startConnect")
    connectManager:disconnect()

    loginReq_ = login

    local servers = {}
    local duplicate = {} -- 判断是否重复

    local function _addAddress(item)
        if item ~= nil and item.ip ~= nil and item.port ~= nil then
            if duplicate[item.ip] == nil then
                duplicate[item.ip] = true
                table.insert(servers, item)
            end
        end
    end

    -- 测试需求：根据配置文件来设置连接地址
    local externalPath = JJFileUtil:getExternalStorageDirectory()
    local path = "jjagent"
    if string.len(externalPath) > 0 then
        path = externalPath.."/".."jjagent"
    end
    local item = LuaDataFile.get(path)
    if item ~= nil then
        _addAddress(item)
        connectManager:connect(servers)
        return
    end

    -- 1. 如果是 GPRS，先判断是否走过滤
    local filters = ServerConfigManager:getServerFilter()
    if filters ~= nil then
        for i, filter in ipairs(filters) do
            -- 当前是 GPRS 连接并且 IMSI 号匹配通过
            if string.find(Util:getIMSI(), filter.regex) ~= nil and Util:getNetworkType() == 2 then
                _addAddress(filter.server)
                _addAddress(filter.domain)
            end
        end
    end

    -- 2. 然后是优先地址
    local serverList = ServerConfigManager:getServerList()
    if serverList ~= nil then
        for i, item in ipairs(serverList) do
            _addAddress(item)
        end
    end

    -- 3. 默认地址
    local defaultServer = ServerConfigManager:getDefaultServer()
    if defaultServer ~= nil then
        _addAddress(defaultServer)
    end

    -- 4. 默认域名
    local defaultDomain = ServerConfigManager:getDefaultDomain()
    if defaultDomain ~= nil then
        _addAddress(defaultDomain)
    end

    if #servers == 0 then
        _addAddress({ip = "lobby.m.jj.cn", port = 30300})
    end

    connectManager:connect(servers)
end

-- 断开网络
function MainController:disconnect()
    JJLog.i(TAG, "disconnect")
    LoginController.loginState_ = LoginController.STATE_UNLOGIN
    connectManager:disconnect()
end

-- 是否连接
function MainController:isConnected()
    JJLog.i(TAG, "isConnected")
    return connectManager:isConnect()
end

-- 是否已登录
function MainController:isLogin()
    JJLog.i(TAG, "isLogin, loginState=", LoginController.loginState_)
    return (LoginController.loginState_ == LoginController.STATE_LOGIN)
end

function MainController:checkConnectedForSingleLordRoar()
    return connectManager:isConnect()
end

-- 启动游戏
function MainController:startGameScene(gameId, startGameParam)
    JJLog.i(TAG, "startGameScene, gameId=", gameId)
    JJLog.i(TAG, "startGameScene, matchId=", startGameParam.matchId_)

    -- 斗地主合集包是在同一个包里面的，所以比较特殊，其他单包游戏直接启动 ID_PLAY 即可
    -- 斗地主
    local scene = JJSceneDef.ID_PLAY
    local pkgId = gameId
    if gameId == JJGameDefine.GAME_ID_LORD then
        JJLog.i(TAG, "start lord game")
        scene = JJSceneDef.ID_LORD_PLAY
        pkgId = JJGameDefine.GAME_ID_LORD_UNION
        -- 赖子斗地主
    elseif gameId == JJGameDefine.GAME_ID_LORD_LZ then
        JJLog.i(TAG, "start lzlord game")
        scene = JJSceneDef.ID_LZ_LORD_PLAY
        pkgId = JJGameDefine.GAME_ID_LORD_UNION
        -- 欢乐斗地主
    elseif gameId == JJGameDefine.GAME_ID_LORD_HL then
        JJLog.i(TAG, "start hllord game")
        scene = JJSceneDef.ID_HL_LORD_PLAY
        pkgId = JJGameDefine.GAME_ID_LORD_UNION
        -- 二斗
    elseif gameId == JJGameDefine.GAME_ID_LORD_PK then
        JJLog.i(TAG, "start hllord game")
        scene = JJSceneDef.ID_PK_LORD_PLAY
        pkgId = JJGameDefine.GAME_ID_LORD_UNION
    end

    -- 如果当前是大厅模式，并且启动的游戏和当前所在不一致
    if RUNNING_MODE == RUNNING_MODE_HALL and pkgId ~= self:getCurPackageId() then
        self:removeToScene(JJGameDefine.GAME_ID_HALL, JJSceneDef.ID_LOBBY)
    end

    local matchData = require("game.data.match.MatchData").new()
    matchData.productId_ = startGameParam.productId_
    matchData.tourneyId_ = startGameParam.tourneyId_
    matchData.matchId_ = startGameParam.matchId_
    matchData.startTime_ = 0
    matchData.strTick_ = startGameParam.ticket_
    StartedMatchManager:addMatch(matchData)

    JJLog.i(TAG,"startGameScene,getCurPackageId = ",self:getCurPackageId(),",pkgId = ",pkgId,",gameId = ",gameId)
    if RUNNING_MODE == RUNNING_MODE_HALL and self:getCurPackageId() ~= pkgId then
        local params = {gameId = tonum(gameId), packageId = tonum(pkgId),  nextScene = JJSceneDef.ID_PLAY, gameParam = startGameParam}
        self:pushScene(tonum(pkgId), JJSceneDef.ID_SWITCH_TO_GAME, params)
    else
        self:pushScene(pkgId, scene, startGameParam)
        self:setCurGameId(gameId)
    end
end

--[[
    保存一些内存使用数据
]]
local cache_ = {}
function MainController:setTable(key, value)
    cache_[key] = value
end

function MainController:getTable(key)
    return cache_[key]
end

--读取globconfig中是否支持短信功能，决定注册界面跳转场景的ID，如果不支持直接进入个性注册功能
function MainController:getRegisterSceneId(packageid)
    local id = JJSceneDef.ID_NORMAL_REGISTER

--    local enable = ClientSwDef:isClientSwOpen(packageid, ClientSwDef.CLIENT_SW_REG_TYPE)
    local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
    local enable = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_MOBILE_REGISTER)
    if (enable) then
        id = JJSceneDef.ID_REGISTER_SELECT
    end

    return id
end

local needPromptNoRegBind = false

function MainController:setNeedPromptNoRegBind(flag)
    --    JJLog.i(TAG, "setNeedPromptNoRegBind, flag=" + flag)
    self.needPromptNoRegBind = flag
end

function MainController:getNeedPromptNoRegBind()
    --    JJLog.i(TAG, "getNeedPromptNoRegBind, needPromptNoRegBind=" + needPromptNoRegBind)
    return needPromptNoRegBind
end

--在后台的时候，因为gl线程被pause了，所以通过消息泵的_update模拟一个timer
function MainController:handleTimer(tick)
    if not Util:isAppActive() then
        JJLog.i(TAG, "handleTimer in tick = ",tick)
        local top = JJSDK:getTopSceneController()
        if top and top.handleBackgroundTimer then
            top:handleBackgroundTimer(tick)
        end

        -- 检查是否超时，一分钟检查一次
        if (tick - lastCheckBackgroundTick) > BACKGROUND_KILL_CHECK_TICK then
            lastCheckBackgroundTick = tick
            if (backgroundTick ~= 0) and (tick - backgroundTick) >= BACKGROUND_KILL_TICK then
                if Util:isAppBackground() then
                    JJLog.e(TAG, "Exit for backgound timeout!!!")
                    MainController:exit()
                end
            end
        end
    end
end

--[[
   Activity resume时第三方的一些处理，包括咆哮的未读处理等
]]
function MainController:resumeControllerThirdProcess()
    roarInterface:getRoarOfflineCloudReq(UserInfo.userId_) --云通讯离线个数
    roarInterface:getRoarAllRemindMsg()
end

--[[
    返回到大厅界面，做一些清理游戏的工作
]]
function MainController:onBackToHall()
    JJLog.i(TAG, "onBackToHall")

    -- 恢复 Lua 搜索路径
    JJLog.i(TAG, "onBackToHall, package.path=", package.path)
    JJLog.i(TAG, "onBackToHall, luaPath_=", luaPath_)
    if package.path ~= luaPath_ then
        package.path = luaPath_
    end

    -- 回调游戏的清理接口
    for gameId, cb in pairs(gameFinishCB_) do
        if cb then
            cb()
        end
    end
    gameFinishCB_ = {}
end

--[[
    注册返回大厅时清理游戏的接口
    @gameId: 游戏 Id
    @cb: 回调函数
]]
function MainController:registerGameFinishCB(gameId, cb)
    JJLog.i(TAG, "registerGameFinishCB, gameId=", gameId)
    gameFinishCB_[tostring(gameId)] = cb
end

--[[
    完全掉线后的处理。断线未重连上、被服务器踢掉……
]]
function MainController:onDisconnected()
    JJLog.i(TAG, "onDisconnected")
    MainController.autoLogin_ = false
    if RUNNING_MODE == RUNNING_MODE_HALL then
        MainController:changeToScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_LOBBY)
    else
        -- 只有斗地主合集包特殊
        if CURRENT_PACKAGE_ID == JJGameDefine.GAME_ID_LORD_UNION then
            MainController:changeToScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_MAIN)
        else
            MainController:changeToScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_MATCH_SELECT)
        end
    end

    -- 清除数据
    StartedMatchManager:removeAllMatchs()
end
