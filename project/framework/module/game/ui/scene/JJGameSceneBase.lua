require("game.data.model.StartedMatchManager")

local JJGameSceneBase = class("JJGameSceneBase", require("sdk.scenestack.SceneBase"))
local TAG = "JJGameSceneBase"

JJGameSceneBase.theme_ = nil
JJGameSceneBase.dimens_ = nil

JJGameSceneBase.landScape_ = true -- 请求横屏

local RECONNECT_TICK = 15
local NEW_MATCH_START_COUNTDOWN = 10
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
JJGameSceneBase.reconnectHandler_ = nil -- 句柄
JJGameSceneBase.reconnectDialog_ = nil -- 对话框
JJGameSceneBase.newMatchStartHandler_ = nil
JJGameSceneBase.newMatchStartDialog_ = nil --新比赛开始对话框
JJGameSceneBase.signupConfirmDialog_ = nil --距离开赛时间短时报名提示框

-- 横竖版风格
JJGameSceneBase.THEME_PORTRAIT_SYTLE = 0
JJGameSceneBase.THEME_LANDSCAPE_SYTLE = 1

JJGameSceneBase.themeStyle_ = nil --窗口排版风格

function JJGameSceneBase:chagneScreen()
    if self.landScape_ then
        Util:requestLandScape()
    else
        Util:requestPortrait()
    end
end

function JJGameSceneBase:ctor(controller)
    self.orientation__ = JJSDK.ORIENTATION_LANDSCAPE
    if device.platform == "ios" then
        self:chagneScreen()
        JJGameSceneBase.super.ctor(self, controller)        
    else
        JJGameSceneBase.super.ctor(self, controller)
        self:chagneScreen()
    end
end

function JJGameSceneBase:onDestory()    
    self.bg_ = nil
    self.title_ = nil
    self.backBtn_ = nil
    self.rightBtn_ = nil
    self.themeStyle_ = nil
    self.landscapeBackLayer_ = nil
    self.landscapeBackBtn_ = nil 
    
    if self.reconnectDialog_ ~= nil then
        self.reconnectDialog_ = nil
        scheduler.unscheduleGlobal(self.reconnectHandler_)
        self.reconnectHandler_ = nil
        MainController.breakReconnect_ = true
    end
    if self.newMatchStartDialog_ ~= nil then
        self.newMatchStartDialog_ = nil
    end
   if self.newMatchStartHandler_ ~= nil then
        scheduler.unscheduleGlobal(self.newMatchStartHandler_)
        self.newMatchStartHandler_ = nil
    end
    if self.signupConfirmDialog_ ~= nil then
        self.signupConfirmDialog_ = nil
    end
    JJGameSceneBase.super.onDestory(self)
end

function JJGameSceneBase:initView()
    JJGameSceneBase.super.initView(self)
    self.theme_ = self.controller_.theme_
    self.dimens_ = self.controller_.dimens_
    self.titleTopOffset_ = self.dimens_.height - self.dimens_:getDimens(30)
    self.contentTopOffset_ = self.dimens_.height - self.dimens_:getDimens(40)
    self.contentLeftOffset_ = self.dimens_:getDimens(50)
    self.landscapeTitleBgWidth_ = self.dimens_:getDimens(154)
    self.landscapeContentHeight_ = self.dimens_:getDimens(400)
    self.landscapeContentWidth_ = self.dimens_:getDimens(595)

    if self.theme_ ~= nil then
        self:setBg(self.theme_:getImage("common/bg_normal.jpg"))
    end

    if MainController.breakReconnect_ then
        self:doBreakReconnect()
    end
    local current = getCurrentSecond()
    local interval = current - StartedMatchManager.newMatchStartTimeStamp_
    local param = StartedMatchManager.newMatchParam_
    if interval >= 0 and interval < NEW_MATCH_START_COUNTDOWN and param ~= nil then
        param.countdown = NEW_MATCH_START_COUNTDOWN - interval
        self:doNewMatchStart(param)
    elseif StartedMatchManager.newMatchParam_ ~= nil then
        StartedMatchManager.newMatchParam_ = nil
    end
end

-- 断线重连
function JJGameSceneBase:doBreakReconnect()
    JJLog.i(TAG, "doBreakReconnect, reconnectDialog=", self.reconnectDialog_)
    if self.reconnectDialog_ then
        return
    end
    JJCloseIMEKeyboard()
    local reconnectTick = RECONNECT_TICK

    if self.reconnectHandler_ ~= nil then
        scheduler.unscheduleGlobal(self.reconnectHandler_)
        self.reconnectHandler_ = nil
    end
    self.reconnectHandler_ = scheduler.scheduleGlobal(function()
        JJLog.i(TAG, "reconnectHandler_ IN")
        if self.reconnectDialog_ ~= nil then
            reconnectTick = reconnectTick - 1
            JJLog.i(TAG, "reconnectTick=", reconnectTick)
            self.reconnectDialog_:setPrompt("网络不给力，努力重连中...(" .. reconnectTick .. ")");
            if reconnectTick == 0 then
                scheduler.unscheduleGlobal(self.reconnectHandler_)
                self.reconnectDialog_:dismiss()
                self.reconnectDialog_ = nil
                local UIUtil = require("game.ui.UIUtil")
                UIUtil.showLoginFailed(99, self.dimens_)
            else
                if LoginController.loginState_ == LoginController.STATE_UNLOGIN then
                    LoginController:startLogin()
                end
            end
        elseif self.reconnectHandler_ ~= nil then
            scheduler.unscheduleGlobal(self.reconnectHandler_)
            self.reconnectHandler_ = nil
        end
    end, 1)

    -- 由于是同步由 ConnectManager 调用过来的，直接处理的话会被 ConnectManager 的后续操作影响到，改为异步操作
    scheduler.performWithDelayGlobal(function()
        LoginController:startLogin()
    end, 0.001)

    self.reconnectDialog_ = require("game.ui.view.AlertDialog").new({
        title = "掉线了",
        prompt = "网络不给力，努力重连中...(" .. reconnectTick .. ")",
        theme = self.theme_,
        dimens = self.dimens_,
        backKey = true,
        backKeyClose = true,
        onDismissListener = function()

            JJLog.i(TAG, "reconnectDialog_, onDismissListener, mode=", RUNNING_MODE)
            self.reconnectDialog_ = nil
            MainController.breakReconnect_ = false

            if not MainController:isConnected() then
                MainController:onDisconnected()
            end
        end,
    })
--[[
    self.reconnectDialog_:setButton1("取消", function()
        JJLog.i(TAG, "Disconnect, select cancel")
        MainController:disconnect()
    end)
]]

    self.reconnectDialog_:setCloseButton(nil)
    self.reconnectDialog_:setCanceledOnTouchOutside(false)
    self.reconnectDialog_:show(self, 1000)
end

function JJGameSceneBase:onEnterTransitionFinish()
    JJGameSceneBase.super.onEnterTransitionFinish(self)

    -- 做一些界面的通用处理
    if MainController.breakReconnect_ then
        self:doBreakReconnect()
    end
end

-- 设置界面背景：按照全屏进行拉伸
function JJGameSceneBase:setBg(resName)

    if self.bg_ ~= nil then
        self:removeView(self.bg_)
        self.bg_ = nil
    end

    -- 背景
    self.bg_ = jj.ui.JJImage.new({
        image = resName,
    })
    self.bg_:setPosition(self.dimens_.cx, self.dimens_.cy)
    self.bg_:setScaleX(self.dimens_.wScale_)
    self.bg_:setScaleY(self.dimens_.hScale_)
    self.rootView__:addView(self.bg_, -100)
end

function JJGameSceneBase:setLandscapeThemeTitle(title)
    if self.landscapeBackLayer_ == nil then
        self:setLandscapeThemeBackBtn()
    end
    
    if string.find(title, "img") ~= nil then
        self.title_ = jj.ui.JJImage.new({
                image = title,
            })

        self.title_:setScale(self.dimens_.scale_)
    else
        JJLog.i("setLandscapeThemeTitle",self.title_)
        self.title_ = jj.ui.JJLabel.new({
                text = title,
                fontSize = self.dimens_:getDimens(28),
                viewSize = CCSize(self.dimens_:getDimens(50), self.dimens_:getDimens(240)),
                singleLine = false,
                align = ui.TEXT_ALIGN_CENTER,
                valign = ui.TEXT_VALIGN_TOP,
            })
    end

    JJLog.i(TAG, "setTitle, bghight=", self.landscapeBackBtn_:getHeight(), ",self.dimens_.height=", self.dimens_.height)

    self.title_:setAnchorPoint(ccp(0.5, 1))
    self.title_:setPosition(self.dimens_:getDimens(154/2), self.dimens_:getDimens(451 - 140))
    self.landscapeBackLayer_:addView(self.title_)

end

-- 设置通用标题
function JJGameSceneBase:setTitle(title)

    if self.title_ ~= nil then
        self:removeView(self.title_)
        self.title_ = nil
    end

    if self.themeStyle_ == self.THEME_LANDSCAPE_SYTLE then
        self:setLandscapeThemeTitle(title)
    else
        -- 图片
        if string.find(title, "img") ~= nil then
            self.title_ = jj.ui.JJImage.new({
                image = title,
            })
        else -- 文字
            self.title_ = jj.ui.JJLabel.new({
                text = title,
                fontSize = 28,
            })
        end
        self.title_:setAnchorPoint(ccp(0.5, 1))
        self.title_:setPosition(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(20))
        self.title_:setScale(self.dimens_.scale_)
        self:addView(self.title_, -99)
    end
end

function JJGameSceneBase:setLandscapeThemeBackBtn(imgs)
    
    if self.landscapeBackLayer_ == nil then

        self.landscapeBackLayer_ = jj.ui.JJViewGroup:new()
        self.landscapeBackLayer_:setPosition(self.landscapeTitleBgWidth_, self.dimens_.height/2)
        self.landscapeBackLayer_:setAnchorPoint(ccp(1, 0.5))
        self.landscapeBackLayer_:setViewSize(self.dimens_:getDimens(154), self.dimens_:getDimens(451))
        self:addView(self.landscapeBackLayer_)

        local images = {
                    normal = self.theme_:getImage("common/return_bg_n.png"),
                    highlight = self.theme_:getImage("common/return_bg_p.png"),
                    --scale9=true,
                    viewSize = CCSize(154, 451),
                }

        if (imgs) then
            images = imgs
        end        

        self.landscapeBackBtn_ = jj.ui.JJButton.new({
            images = images,
            viewSize = CCSize(154, 451),
        })
        self.landscapeBackBtn_:setAnchorPoint(ccp(0, 0))
        self.landscapeBackBtn_:setPosition(0,0)
        self.landscapeBackBtn_:setScale(self.dimens_.scale_)
        self.landscapeBackBtn_:setOnClickListener(function() self.controller_:onBackPressed() end)
        self.landscapeBackLayer_:addView(self.landscapeBackBtn_, -99)
    end
end

-- 设置返回按钮,imgs返回按钮底图，nil为默认
function JJGameSceneBase:setBackBtn(flag, imgs)
    if flag == true then
        if self.backBtn_ ~= nil then
            self:removeView(self.backBtn_)
            self.backBtn_ = nil
        end
        -- 1 
        if self.themeStyle_ == self.THEME_LANDSCAPE_SYTLE then
            self:setLandscapeThemeBackBtn(imgs)

            self.backBtn_ = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/return_btn_landscape_n.png"),
                viewSize = CCSize(100,70),
            })
            self.backBtn_:setAnchorPoint(ccp(0.5,1))
            self.backBtn_:setScale(self.dimens_.scale_)
            self.backBtn_:setPosition(self.dimens_:getDimens(154/2), self.dimens_:getDimens(451 - 80))
            self.landscapeBackLayer_:addView(self.backBtn_)
        else

            

            local images = {
                normal = self.theme_:getImage("common/return_btn_n.png"),
            }

            if (imgs) then
                images = imgs
            end

            self.backBtn_ = jj.ui.JJButton.new({
                images = images,
            })
            self.backBtn_:setAnchorPoint(ccp(0, 1))
            self.backBtn_:setPosition(self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
            self.backBtn_:setScale(self.dimens_.scale_)
            self.backBtn_:setOnClickListener(function() self.controller_:onBackPressed() end)
            self:addView(self.backBtn_, -99)
        end
    else
        if self.backBtn_ ~= nil then
            self.backBtn_:setVisible(false)
        end
    end
end

--[[
    点击按钮的操作
    @target：点击对象
]]
function JJGameSceneBase:onClick(target)
end

-- 设置右侧功能按钮
function JJGameSceneBase:setRightBtn(flag, imgs, callback)
    if flag == true then
        if self.rightBtn_ == nil then
            self.rightBtn_ = jj.ui.JJButton.new({
                images = imgs,
            })
            self.rightBtn_:setAnchorPoint(ccp(1, 1))
            self.rightBtn_:setPosition(self.dimens_.width - self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(5))
            self.rightBtn_:setScale(self.dimens_.scale_)
            if callback ~= nil then
                self.rightBtn_:setOnClickListener(function() callback() end)
            end
            self:addView(self.rightBtn_)
        else
            self.rightBtn_:setButtonImage("normal", imgs.normal)
            self.rightBtn_:setButtonImage("highlight", imgs.highlight)
            self.rightBtn_:setVisible(true)
        end
    else
        if self.rightBtn_ ~= nil then
            self.rightBtn_:setVisible(false)
        end
    end
end

-- 新比赛开始提示
function JJGameSceneBase:doNewMatchStart(param)
    JJLog.i(TAG, "doNewMatchStart, Dialog=", self.newMatchStartDialog_)
    JJCloseIMEKeyboard()
    if self.newMatchStartDialog_ or not param then
        return
    end
    local startTick
    if param.countdown ~= nil then
        startTick = param.countdown
    else
        startTick = NEW_MATCH_START_COUNTDOWN
    end
    self.newMatchStartHandler_ = scheduler.scheduleGlobal(function()
        JJLog.i(TAG, "newMatchStartHandler_ IN")
        if self.newMatchStartDialog_ ~= nil then
            startTick = startTick - 1
            JJLog.i(TAG, "startTick=", startTick)
            if startTick <= 0 then
                self.newMatchStartDialog_:dismiss()
                JJLog.i(TAG, "Time out New match start, select old")
                if self.newMatchStartHandler_ ~= nil then
                    scheduler.unscheduleGlobal(self.newMatchStartHandler_)
                end
                MatchMsg:sendExitMatchReq(param.matchId_, param.ticket_, param.gameId_)
                StartedMatchManager.newMatchParam_ = nil
                self.newMatchStartDialog_ = nil
            else
                self.newMatchStartDialog_:setPrompt(param.name .. "开始了，是否进入？(" .. startTick .. ")");
            end
        elseif self.newMatchStartHandler_ ~= nil then
            scheduler.unscheduleGlobal(self.newMatchStartHandler_)
            self.newMatchStartHandler_ = nil
        end
    end, 1)

    self.newMatchStartDialog_ = require("game.ui.view.AlertDialog").new({
        title = "新比赛开始了",
        prompt = param.name .. "开始了，是否进入？(" .. startTick .. ")",
        theme = self.theme_,
        dimens = self.dimens_,
        backKey = true,
        backKeyClose = false,
        onDismissListener = function()
            JJLog.i(TAG, "new match start dialog dismissed")
            if self.newMatchStartHandler_ ~= nil then
                scheduler.unscheduleGlobal(self.newMatchStartHandler_)
                self.newMatchStartHandler_ = nil
            end
        end,
    })

    self.newMatchStartDialog_:setButton1("是", function()
        JJLog.i(TAG, "New match start, select new")
        -- 退出老比赛
        if self.newMatchStartHandler_ ~= nil then
            scheduler.unscheduleGlobal(self.newMatchStartHandler_)
            self.newMatchStartHandler_ = nil
        end
        local top = JJSDK:getTopSceneController()
        JJLog.i(TAG, "top=", top)
        if top ~= nil then
            JJLog.i(TAG, "top.exitMatch=", top.exitMatch)
        end

        if top and top:getSceneId() == JJSceneDef.ID_SINGLE_LORD_PLAY then
            -- 保存单机进度
            if top and top.saveSingleLordData then
                top:saveSingleLordData()
            end
        end
        
        if top ~= nil and top.exitMatch ~= nil then
            top:exitMatch(false)
            JJSDK:removeScene(top:getTag())
        end
        MainController:startGameScene(param.gameId_, param)
        StartedMatchManager.newMatchParam_ = nil
    end)

    self.newMatchStartDialog_:setButton2("否", function()
        JJLog.i(TAG, "New match start, select old")
        if self.newMatchStartHandler_ ~= nil then
            scheduler.unscheduleGlobal(self.newMatchStartHandler_)
            self.newMatchStartHandler_ = nil
        end
        MatchMsg:sendExitMatchReq(param.matchId_, param.ticket_, param.gameId_)
        StartedMatchManager.newMatchParam_ = nil
    end)

    self.newMatchStartDialog_:setCanceledOnTouchOutside(false)
    self.newMatchStartDialog_:show(self, 1000)
end

--关闭新比赛提示框，并退出该比赛
function JJGameSceneBase:closeNewMatchDailog(param)
    if self.newMatchStartHandler_ ~= nil then
        scheduler.unscheduleGlobal(self.newMatchStartHandler_)
    end 
    if self.newMatchStartDialog_ ~= nil then
        self.newMatchStartDialog_:dismiss()
        JJLog.i(TAG, "Time out New match start, select old")
        MatchMsg:sendExitMatchReq(param.matchId_, param.ticket_, param.gameId_)
        StartedMatchManager.newMatchParam_ = nil
        self.newMatchStartDialog_ = nil
    end
end

function JJGameSceneBase:showSignupConfirmDialog(param)
    JJLog.i(TAG, "showSignupConfirmDialog, Dialog=", self.signupConfirmDialog_)
    if self.signupConfirmDialog_ or not param then
        return
    end
    local str = param.str
    local tourneyId = param.tourneyId
    local matchPoint = param.matchPoint
    local signupType = param.signupType
    local gameId = param.gameId

    self.signupConfirmDialog_ = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = str,
        theme = self.theme_,
        dimens = self.dimens_,
        onDismissListener = function()
            self.signupConfirmDialog_ = nil
        end,
        backKey = true,
    })

    self.signupConfirmDialog_:setButton1("确定", function()
        local userId = UserInfo.userId_
        local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tourneyId)
        if tourneyInfo and tourneyInfo.matchconfig_ then        
            SignupStatusManager:addSignupingItem(gameId,tourneyInfo.matchconfig_.productId, tourneyId)        
            LobbyMsg:sendTourneySignupExReq(userId, tourneyId, matchPoint, signupType, gameId)
        end
    end)

    self.signupConfirmDialog_:setButton2("取消", function()

    end)
    self.signupConfirmDialog_:show(self, 1000)
end

--关闭距离开赛时间短时报名提示框
function JJGameSceneBase:closeSignupConfirmDialog()
    if self.signupConfirmDialog_ ~= nil then
        self.signupConfirmDialog_:dismiss()
    end
end

function JJGameSceneBase:isExistSignupConfirmDialog()
    if self.signupConfirmDialog_ ~= nil then
        return true
    else
        return false
    end
end

-- style 说明主题风格
-- 0 默认竖版主题
-- 1 横版主题
-- 注意此函数需要在setbackbtn和settitle之前调用
function JJGameSceneBase:setThemeStyle(style)
    self.themeStyle_ = style
end

function JJGameSceneBase:getContentHeight()
    return self.landscapeContentHeight_
end

function JJGameSceneBase:getTitleHight()
    return self.landscapeTitleBgWidth_
end

function JJGameSceneBase:getContentWidth()
    return self.landscapeContentWidth_
end

return JJGameSceneBase