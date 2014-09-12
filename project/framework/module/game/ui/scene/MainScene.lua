local MainScene = class("MainScene", require("game.ui.scene.JJGameSceneBase"))
local roarInterface = require("game.thirds.RoarInterface")
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
local TAG = "MainScene"

local UIUtil = require("game.ui.UIUtil")

-- 内部函数
local _initData

MainScene.btnMoreGame_ = nil
MainScene.btnRegister_ = nil
MainScene.btnMenu_ = nil
MainScene.bottomView_ = nil
MainScene.exitDialog_ = nil
MainScene.loginDialog_ = nil
MainScene.bindNoRegDialog_ = nil
MainScene.noNetworkDialog_ = nil
MainScene.FirstDialog_ = nil
MainScene.waitDialog_ = nil
MainScene.unreadFlag = nil
MainScene.selectGameId_ = 0

function MainScene:onDestory()
    MainScene.super.onDestory(self)
    self.btnMoreGame_ = nil
    self.btnRegister_ = nil
    self.btnMenu_ = nil
    self.bottomView_ = nil
    self.exitDialog_ = nil
    self.loginDialog_ = nil
    self.bindNoRegDialog_ = nil
    self.noNetworkDialog_ = nil
    self.FirstDialog_ = nil
    self.waitDialog_ = nil
    self.unreadFlag = nil
    MainScene.selectGameId_ = 0
end

--[[
    界面初始化
]]
function MainScene:initView()
    MainScene.super.initView(self)
    self:setBg(self.theme_:getImage("matchselect/bg.jpg"))
    self:setTitle(self.theme_:getImage("main/title.png"))

    DynamicDisplayManager:initFromFile()

    -- 更多游戏
    self.btnMoreGame_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("main/more_game_btn_n.png"),
        },
        fontSize = 28,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(100, 70),
    })
    self.btnMoreGame_:setAnchorPoint(ccp(0, 1))
    self.btnMoreGame_:setPosition(self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
    self.btnMoreGame_:setScale(self.dimens_.scale_)
    self.btnMoreGame_:setOnClickListener(handler(self, self.onClick))
    self.btnMoreGame_:setVisible(false)
    self:addView(self.btnMoreGame_)

    self:refreshMoreGameShow() --更新是否显示moregame和返回按钮

    -- 注册
    self.btnRegister_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("main/register_btn_n.png"),
        },
        text = "注册",
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(255, 255, 255),
        viewSize = CCSize(self.dimens_:getDimens(100), self.dimens_:getDimens(70)),
    })
    self.btnRegister_:setAnchorPoint(ccp(1, 1))
    self.btnRegister_:setPosition(self.dimens_.width - self.dimens_:getDimens(120), self.dimens_.height - self.dimens_:getDimens(10))
    -- self.btnRegister_:setScale(self.dimens_.scale_)
    self.btnRegister_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnRegister_)
    self.btnRegister_:setVisible(false)

    self:refreshUserInfo()

    -- 菜单
    self.btnMenu_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("main/menu_btn_n.png"),
        },
        fontSize = 28,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(100, 70),
    })
    self.btnMenu_:setAnchorPoint(ccp(1, 1))
    self.btnMenu_:setPosition(self.dimens_.width - self.dimens_:getDimens(10), self.dimens_.height - self.dimens_:getDimens(10))
    self.btnMenu_:setScale(self.dimens_.scale_)
    self.btnMenu_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnMenu_)

    -- 私信或公告未读
    local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
    -- 咆哮未读
    -- roarRemindMsgFlag_

    self.unreadFlag = jj.ui.JJImage.new({
        image = self.theme_:getImage("main/unread_flag.png"),
    })
    self.unreadFlag:setAnchorPoint(ccp(1,1))
    self.unreadFlag:setPosition(self.dimens_.width-self.dimens_:getDimens(10), self.dimens_.height-self.dimens_:getDimens(10))
    self.unreadFlag:setScale(self.dimens_.scale_)
    self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
    self:addView(self.unreadFlag)

    -- 游戏们，布局都是等分居中
    local count = #self.controller_.params_.games
    local yChange = false -- 不在一行上，5个的时候需要高低起伏
    if count == 5 then
        yChange = true
    end
    local width = self.dimens_.width / count
    local x, y = 0, self.dimens_.cy
    for i = 1, count do
        x = width * (i - 1) + width / 2
        if yChange then
            if i == 1 or i == 5 then
                y = self.dimens_.cy - self.dimens_:getDimens(30)
            elseif i == 2 or i == 4 then
                y = self.dimens_.cy - self.dimens_:getDimens(5)
            else
                y = self.dimens_.cy + self.dimens_:getDimens(30)
            end
        end

        local game = jj.ui.JJButton.new({
            images = self.controller_.params_.games[i].images,
        })
        game:setId(self.controller_.params_.games[i].gameId)
        game:setAnchorPoint(ccp(0.5, 0.5))
        game:setPosition(x, y)
        game:setScale(self.dimens_.scale_)
        game:setOnClickListener(handler(self, self.onClick))
        self:addView(game)
    end

    local urlcolor = nil
    if self.controller_.params_ ~= nil and self.controller_.params_.urlColor ~= nil then
        urlcolor = self.controller_.params_.urlColor
    else
        urlcolor = ccc3(0x11, 0x44, 0x77)
    end

    -- 网址
    local url = jj.ui.JJLabel.new({
            text = "www.jj.cn",
            fontSize = self.dimens_:getDimens(22),
            color = urlcolor,
        })
    url:setAnchorPoint(ccp(1, 0))
    url:setPosition(ccp(self.dimens_.width - self.dimens_:getDimens(20), self.dimens_:getDimens(40)))
    self:addView(url)

    -- 底下的菜单
    self.bottomView_ = require("game.ui.view.BottomView").new({
        scene = self,
        packageId = self.controller_.params_.packageId,
        theme = self.theme_,
        dimens = self.dimens_,
        gameId = JJGameDefine.GAME_ID_LORD, -- 特殊处理，目前只有斗地主合集包，在这个界面传入经典斗地主的参数
        topicUrl = self.controller_.params_.topicUrl,
    })
    self.bottomView_:setAnchorPoint(ccp(0, 0))
    self.bottomView_:setPosition(0, 0)
    self:addView(self.bottomView_)
end

function MainScene:onClick(target)
    MainScene.super.onClick(self, target)
    -- 更多游戏
    if (target == self.btnMoreGame_) then
        self.controller_:onClickMoreGame()
    -- 菜单
    elseif (target == self.btnMenu_) then
        self.bottomView_:changeState()
    -- 注册
    elseif (target == self.btnRegister_) then
        self.controller_:onClickRegister()
    else
        local gameId = target:getId()
        self.controller_:enterMatchSelectScene(gameId)
    end
end

-- 询问是否退出的对话框
function MainScene:showExitDialog(show)
    if show then
        local function onClick(self)
            JJLog.i(TAG, "showExitDialog, onClick, exit")
            -- app:exit()
            MainController:exit()
        end

        self.exitDialog_ = require("game.ui.view.AlertDialog").new({
            title = "提示",
            prompt = "您确认要退出吗？",
            onDismissListener = function() self.exitDialog_ = nil end,
            theme = self.theme_,
            dimens = self.dimens_
        })

        self.exitDialog_:setButton1("退出", onClick)
        --self.exitDialog_:setButton2("取消", nil)
        self.exitDialog_:setCloseButton(nil)
        self.exitDialog_:setCanceledOnTouchOutside(true)

        self.exitDialog_:show(self)
    else
        if self.exitDialog_ ~= nil then
            self.exitDialog_:dismiss()
        end
    end
end

-- 按下返回键
function MainScene:onBackPressed()
    JJLog.i(TAG, "onBackPressed, loginDialog=", self.loginDialog_, ", exitDialog=", self.exitDialog_)
    if self.loginDialog_ ~= nil then
        self:showLoginDialog(false)
        MainController:disconnect()
    elseif self.noNetworkDialog_ ~= nil then
        self:showNoNetworkDialog(false)
    elseif self.bindNoRegDialog_ ~= nil then
        JJLog.i(TAG, "onBackPressed, exitState=", self.exitState)
        if self.exitState ~= nil and not self.exitState then
            self:showGuideToBindNoRegDialog(false)
        end
    elseif self.FirstDialog_ ~= nil then
        self:showFirstInDialog(false)
    elseif self.exitDialog_ ~= nil then
    elseif self.bottomView_ ~= nil and self.bottomView_:isOpen() then
        self.bottomView_:changeState()
    else
        if RUNNING_MODE == RUNNING_MODE_HALL then
            JJSDK:popScene()
        else
            if (LoginController.type_ == LOGIN_TYPE_NOREG) and not Util:isQihu360() then
                self:showGuideToBindNoRegDialog(true, true)
            else
                self:showExitDialog(true)
            end
        end
    end
end

-- 显隐登录等待对话框
function MainScene:showLoginDialog(show)
    JJLog.i(TAG, "showLoginDialog, show=", show)
    if show then

        UIUtil.dismissDialog(self.loginDialog_)
        self.loginDialog_ = UIUtil.showLoginDialog(self, self.theme_, self.dimens_, function() self.loginDialog_ = nil end)

    else

        UIUtil.dismissDialog(self.loginDialog_)
        self.loginDialog_ = nil
    end
end

-- 是否处于登录等待
function MainScene:isLoginDialog()
    return self.loginDialog_ ~= nil
end

--[[
    刷新用户信息
]]
function MainScene:refreshUserInfo(upd)
    JJLog.i(TAG, "refreshUserInfo")
    self:refreshMoreGameShow()
    if self.bottomView_ ~= nil then
        self.bottomView_:refreshUserInfo(upd)
    end

    -- 如果是JJ帐号登录，显示静音按钮，否则显示注册按钮
    local lc = require("game.controller.LoginController")
    lc:init()
    if Util:isQihu360() or (UserInfo:isLogin() and lc.type_ == LOGIN_TYPE_JJ) then
        self.btnRegister_:setVisible(false)
    else
        self.btnRegister_:setVisible(true)
    end
end

function MainScene:refreshMoreGameShow()
    JJLog.i(TAG, "refreshMoreGameShow")
    local dis = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_MORE_GAME)
    -- 如果是已经登录，并且更多游戏显示控制为true
    if RUNNING_MODE == RUNNING_MODE_HALL then --增加大厅进入显示返回功能
        local images = {
            normal = self.theme_:getImage("main/return_hall_n.png"),
        }
        self:setBackBtn(true, images)
    else
        if UserInfo:isLogin() and dis then
            self.btnMoreGame_:setVisible(true)
        else
            self.btnMoreGame_:setVisible(false)
        end
    end
end

function MainScene:refreshRoarNewMsgInfo()
    JJLog.i(TAG, "refreshRoarNewMsgInfo")

    if self.bottomView_ ~= nil then
        self.bottomView_:updateRoarNewMsgInfo()
    end
    self:checkUnreadMsg()
end

--[[
    免注册登录注册引导
]]
function MainScene:showGuideToBindNoRegDialog(show, isExit)
    JJLog.i(TAG, "showGuideToBindNoRegDialog IN! and show : ", show)
    if show then
        local function onClick()
            JJLog.i(TAG, "showGuideToBindNoRegDialog, onClick, onClickRegister")
            self.controller_:onClickRegister()
        end

        local function closeDialog()
            --UIUtil.dismissDialog(self.bindNoRegDialog_)--已经dismiss，不需要再执行
            self.bindNoRegDialog_ = nil
        end

        local params = {
            btn1CB = nil,
            btn2CB = onClick,
            dismissCB = closeDialog, --点击空白区域关闭时执行
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            prompt = "亲，建议您注册升级为JJ帐号，JJ帐号会自动保留您当前的所有财物和账户信息，方便又安全。",
            btn1Txt = nil,
            isExitFlag = isExit,
        }

        if isExit then
            local function onExit()
                MainController:exit()
            end

            params.btn1CB = onExit
            params.btn1Txt = "退出"
        end

        self.bindNoRegDialog_ = UIUtil.showGuideToBindNoRegDialog(params)
        if isExit then
            self.bindNoRegDialog_:setCloseButton(function () end)
            self.exitState = isExit
        else
            self.exitState = false
        end
    else
        self.exitState = false
        if self.bindNoRegDialog_ then
            UIUtil.dismissDialog(self.bindNoRegDialog_)
            self.bindNoRegDialog_ = nil
        end
    end
end

--[[
    第一次登陆时的对话框
    @gameId
]]
function MainScene:showFirstInDialog(show)

    local count = Settings:getNoRegLoginCount()
    JJLog.i(TAG, "showFirstInDialog-----------",count)
    if not show then
        UIUtil.dismissDialog(self.FirstDialog_)
        self.FirstDialog_ = nil
    end

    if count ~= 0 or Util:isQihu360() then
        return
    end
    if show then
        local function onClick1()
            self.controller_:onClickLogin()
        end

        local function onClick2()
            self.controller_:onClickRegister()
        end

        local function closeDialog()
            self.FirstDialog_ = nil
        end


        local params = {
            btn1CB = onClick1,
            btn2CB = onClick2,
            btn3CB = nil,
            dismissCB = closeDialog, --点击空白区域关闭时执行
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            prompt = "欢迎进入JJ斗地主,系统已经自动为您生成一个来宾帐号,快去体验吧。"
        }

        self.FirstDialog_ = self:regFirstInDialog(params)
    else
        UIUtil.dismissDialog(self.FirstDialog_)
        self.FirstDialog_ = nil
    end
end

function MainScene:regFirstInDialog(params)
    local dialog = require("game.ui.view.ExtendAlertDialog").new({
        title = "",
        prompt = params.prompt,
        onDismissListener = params.dismissCB,
        theme = params.theme,
        dimens = params.dimens,
    })

    dialog:setButton1("JJ帐号登录", params.btn1CB)
    dialog:setButton2("注册帐号", params.btn2CB)
    dialog:setButton3("马上体验", params.btn3CB)
    dialog:setCloseButton(function () end)
    dialog:setRelayoutBtn()
    dialog:show(params.scene)
    dialog:setCanceledOnTouchOutside(false)
    return dialog
end

--[[
    无网络提示框
]]
function MainScene:showNoNetworkDialog(show)
    if show then

        local function _dismissCB()
            JJLog.i(TAG, "_dismissCB")
            self.noNetworkDialog_ = nil
        end

        local function _btn1CB()
            JJLog.i(TAG, "_btn1CB")
            Util:callNetworkSetting()
        end

        self.noNetworkDialog_ = UIUtil.showNoNetworkDialog(self, self.theme_, self.dimens_, _dismissCB, _btn1CB)

    else
        UIUtil.dismissDialog(self.noNetworkDialog_)
        self.noNetworkDialog_ = nil
    end
end

function MainScene:checkUnreadMsg()
    local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
    -- 咆哮未读
    -- roarRemindMsgFlag_

    if self.unreadFlag then
        self.unreadFlag:setVisible(count > 0 or roarRemindMsgFlag_)
    end

    if self.bottomView_ and self.bottomView_.updatePcenterNewMsgInfo then
        self.bottomView_:updatePcenterNewMsgInfo(count)
    end
end

-- 取比赛列表
function MainScene:showGetMatchWaitDialog(show)
    if show then
        if self.waitDialog_ ~= nil then
            self.waitDialog_:dismiss()
        end
        self.waitDialog_ = require("game.ui.view.ProgressDialog").new(self.theme_, self.dimens_, {
            text = "正在取比赛列表，请稍等...",
            mask = false,
            onDismissListener = function() self.waitDialog_ = nil end
            })
        self.waitDialog_:setCanceledOnTouchOutside(false)
        self.waitDialog_:show(self)
    else
        if self.waitDialog_ ~= nil then
            self.waitDialog_:dismiss()
            self.waitDialog_ = nil
        end
    end
end

function MainScene:existWaitDialog()
    if self.waitDialog_ ~= nil then
        return true
    else
        return false
    end
end

function MainScene:refreshBottomViewBtn()
    JJLog.i(TAG,"refreshBottomViewBtn")
    self:refreshMoreGameShow()
    if self.bottomView_ then
        self.bottomView_:refreshBtn()
    end
end

return MainScene
