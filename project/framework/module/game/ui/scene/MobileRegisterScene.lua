local MobileRegisterScene = class("MobileRegisterScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "MobileRegisterScene"
local ERROR_COLOR = ccc3(255, 217, 0)
local TIMEOUT = 30

--账号类型
local TK_ACCSTYLE_ENUM_RESERVE     = 0  --保留
local TK_ACCSTYLE_ENUM_GENERAL     = 1  --用户自定义
local TK_ACCSTYLE_ENUM_MOBILE      = 2  --手机号码
local TK_ACCSTYLE_ENUM_MAIL        = 3  --邮箱
local TK_ACCSTYLE_ENUM_SYSAUTO     = 4  --系统自动
local TK_ACCSTYLE_ENUM_SPCIALCODE  = 5   --特征码

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
require("game.controller.RegisterController")

function MobileRegisterScene:onDestory()
    JJLog.i(TAG, "onDestory")
    MobileRegisterScene.super.onDestory(self)

    -- 保存编辑后的参数
    local mobile = nil
    local code = nil
    local password = nil
    if self.editMobileNumber_ ~= nil then
        mobile = self.editMobileNumber_:getText()
    end
    if self.editCode_ ~= nil then
        code = self.editCode_:getText()
    end
    if self.editPassword_ ~= nil then
        password = self.editPassword_:getText()
    end

    MainController:setTable(TAG, {
        mobile = mobile,
        code = code,
        password = password,
        codeTime = self.getCodeTime
    })

    self:StopTimer()

    -- 清理句柄
    self.editMobileNumber_ = nil
    self.imgMobile_ = nil
    self.pmMobileNumber_ = nil

    self.editPassword_ = nil
    self.imgPassword_ = nil
    self.pmPassword_ = nil

    --self.editConfirm_ = nil
    --self.imgConfirm_ = nil
    --self.pmConfirm_ = nil

    self.editCode_ = nil
    self.btnRegister_ = nil
    self.scrollView_ = nil

    self.btVerifyCode_ = nil
    self.btnPrompt_ = nil
end

function MobileRegisterScene:checkPasswordConfirm()
    local password = self.editPassword_:getText()
    --local confirm = self.editConfirm_:getText()

    JJLog.i(TAG, "checkPasswordConfirm", password, confirm)

    local valid, pmpsw, pmcnf = RegisterController:checkRegistePassword(password, password)

    JJLog.i(TAG, "checkPasswordConfirm", valid, pmpsw, pmcnf)

    if (valid) then
        self.imgPassword_:setVisible(true)
        --self.imgConfirm_:setVisible(true)

        self.pmPassword_:setVisible(false)
       -- self.pmConfirm_:setVisible(false)
    else
        self.imgPassword_:setVisible(false)
       -- self.imgConfirm_:setVisible(false)

        self.pmPassword_:setVisible(true)
      --  self.pmConfirm_:setVisible(true)

        self.pmPassword_:setText(pmpsw)
        self.pmPassword_:setColor(ERROR_COLOR)

      --  self.pmConfirm_:setText(pmcnf)
     --   self.pmConfirm_:setColor(ERROR_COLOR)
    end
end

function MobileRegisterScene:checkMobilePrompt(text)
    if (RegisterController:isMobileNumber(text)) then
        self.imgMobile_:setVisible(true)     -- lifeng
        self.pmMobileNumber_:setVisible(false)

        --验证手机号是否注册过 暂时屏蔽 lifeng
       -- LobbyMsg:sendVerifyLoginNameExistReq(text, nil,TK_ACCSTYLE_ENUM_MOBILE)
    else
        self.imgMobile_:setVisible(false)
        if text == "" then
            self.pmMobileNumber_:setText("手机号不能为空")
        else
            self.pmMobileNumber_:setText("请输入正确的手机号")
        end
        self.pmMobileNumber_:setVisible(true)
    end    
end

function MobileRegisterScene:initView()
    MobileRegisterScene.super.initView(self)
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
   -- self:setTitle(self.theme_:getImage("register/register_mobile_register_title.png"))
    self:setTitle("手机号注册")
    JJLog.i(TAG, "initView")

    local dimens = self.dimens_
    local scale = dimens.scale_
    local tvFontSize = dimens:getDimens(24)
    local edFontSize = dimens:getDimens(18)
    local edPlaceHolderSize = dimens:getDimens(20)
    local pmFontSize = dimens:getDimens(16)
    local tvWidth = dimens:getDimens(155)
    local tvHeight = dimens:getDimens(80)
    local tvSize = CCSizeMake(tvWidth, tvHeight)
    local tvAlignLeft = dimens:getDimens(270) -- 标识左对齐
    local tvStartTop = dimens:getDimens(480) - dimens:getDimens(120) -- 内容起始点
    local edAlignLeft = dimens:getDimens(375) -- 编辑框左对齐
    local pmAlignLeft = dimens:getDimens(700) -- 提示框左对齐
    local edWidth = dimens:getDimens(320)
    local edHeight = dimens:getDimens(60)
    local lineMargin =  dimens:getDimens(70) -- 两行内容的间隔
    local Holder_COLOR = ccc3(193, 193, 193)

    local y = tvStartTop -- 这一行的 Y 坐标

    local width, height = dimens:getDimens(854), dimens:getDimens(440)
    local x = (dimens.width - dimens:getDimens(width)) / 2

    local viewGroup = jj.ui.JJViewGroup.new({
        viewSize = CCSize(width, height),
    })
    self.scrollView_ = viewGroup
    self.scrollView_:setAnchorPoint(ccp(0.5, 1))
    self.scrollView_:setPosition(dimens.cx, dimens.top - dimens:getDimens(50))
    --self.scrollView_:setScale(dimens.scale_)
    self:addView(self.scrollView_)
    --self.scrollView_:setContentView(viewGroup)

    local swOffset = (dimens:getDimens(854) - width) / 2
    tvAlignLeft = tvAlignLeft - swOffset
    edAlignLeft = edAlignLeft - swOffset
    y = height

    local edOffset = {
        paddingLeft = 10,
        paddingRight = 5
    }

    -- 提示
    --    local prompt = jj.ui.JJLabel.new({
    --        fontSize = 20,
    --        color = ccc3(255, 255, 255),
    --        text = "通过手机号注册升级帐号后将自动保留所有财物和账户信息，手机号登录安全又方便，还可多端登录。",
    --        viewSize = CCSize(width * 0.8, 100),
    --    })
    --    prompt:setAnchorPoint(ccp(0.5, 1))
    --    prompt:setPosition(width / 2, y)
    --    --prompt:setScale(self.dimens_.scale_)
    --    viewGroup:addView(prompt)

    --y = y - lineMargin * 1.6
    y = tvStartTop

    -- 手机号
    local tvMobileNumber = jj.ui.JJLabel.new({
        text = "手机号码",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
    })
    --tvMobileNumber:setScale(self.dimens_.scale_)
    tvMobileNumber:setAnchorPoint(ccp(0, 0.5))
    tvMobileNumber:setPosition(tvAlignLeft, y)
    viewGroup:addView(tvMobileNumber)

    self.editMobileNumber_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(edWidth, edHeight),
        layout = edOffset,
        listener = function(event, editbox)
            if event == "ended" then

                local text = editbox:getText()
                local input = "input is nil"
                if (text) then
                    input = text
                end
                JJLog.i(TAG, "editMobileNumber_ text = " .. input)
                if self.editMobileNumber_ then
                    self:checkMobilePrompt(text)
                end
            end
        end
    })
    self.editMobileNumber_:setAnchorPoint(ccp(0, 0.5))
    self.editMobileNumber_:setPosition(edAlignLeft, y)
    --self.editMobileNumber_:setScale(self.dimens_.scale_)
    self.editMobileNumber_:setPlaceHolder("输入手机号码")
    self.editMobileNumber_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editMobileNumber_:setPlaceHolderFontColor(Holder_COLOR)
    self.editMobileNumber_:setMaxLength(11)
    self.editMobileNumber_:setFont("宋体", edFontSize)
    self.editMobileNumber_:setFontColor(display.COLOR_BLACK)
    self.editMobileNumber_:setInputMode(kEditBoxInputModeSingleLine)
    self.editMobileNumber_:setReturnType(kKeyboardReturnTypeDone)
    viewGroup:addView(self.editMobileNumber_)

    -- 手机号验证提示	
    self.imgMobile_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    self.imgMobile_:setScale(self.dimens_.scale_)
    self.imgMobile_:setAnchorPoint(ccp(0, 0.5))
    self.imgMobile_:setPosition(pmAlignLeft, y)
    self.imgMobile_:setVisible(false)
    viewGroup:addView(self.imgMobile_)

    self.pmMobileNumber_ = jj.ui.JJLabel.new({
        text = "请输入正确的手机号",
        fontSize = pmFontSize,
        singleLine = false,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        color = ERROR_COLOR,
    })
    --self.pmMobileNumber_:setScale(self.dimens_.scale_)
    self.pmMobileNumber_:setAnchorPoint(ccp(0, 0.5))
    self.pmMobileNumber_:setPosition(pmAlignLeft, y)
    self.pmMobileNumber_:setVisible(false)
    viewGroup:addView(self.pmMobileNumber_)

    -- 验证码
    y = y - lineMargin
    local tvCode = jj.ui.JJLabel.new({
        text = "验证码",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        dimensions = tvSize,
    })
    --tvCode:setScale(self.dimens_.scale_)
    tvCode:setAnchorPoint(ccp(0, 0.5))
    tvCode:setPosition(tvAlignLeft, y)
    viewGroup:addView(tvCode)

    self.editCode_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(dimens:getDimens(190), edHeight),
        layout = edOffset,
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "editCode_ text = " .. input)
            end
        end
    })
    self.editCode_:setAnchorPoint(ccp(0, 0.5))
    self.editCode_:setPosition(edAlignLeft, y)
    --self.editCode_:setScale(self.dimens_.scale_)
    self.editCode_:setPlaceHolder("输入验证码")
    self.editCode_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editCode_:setPlaceHolderFontColor(Holder_COLOR)
    self.editCode_:setMaxLength(4)
    self.editCode_:setFont("宋体", edFontSize)
    self.editCode_:setFontColor(display.COLOR_BLACK)
    self.editCode_:setInputMode(kEditBoxInputModeNumeric)
    self.editCode_:setReturnType(kKeyboardReturnTypeDone)
    viewGroup:addView(self.editCode_)

    --common_btn_get_smscode_disable
    self.btVerifyCode_ = jj.ui.JJButton.new({
        singleLine = false,
        fontSize = dimens:getDimens(20),
        images = {
            normal = self.theme_:getImage("common/common_btn_get_smscode_n.png"),
            highlight = self.theme_:getImage("common/common_btn_get_smscode_d.png"),
            scale9 = true,
            viewSize = CCSize(dimens:getDimens(120), dimens:getDimens(60)),
        },
        viewSize = CCSize(dimens:getDimens(120), dimens:getDimens(60)),
        text = "获取验证码",
        align = ui.TEXT_ALIGN_CENTER,
    })
    self.btVerifyCode_:setPosition(edAlignLeft + dimens:getDimens(200), y)
    --self.btVerifyCode_:setScale(dimens.scale_)
    self.btVerifyCode_:setAnchorPoint(ccp(0, 0.5))
    self.btVerifyCode_:setTouchEnable(true)
    self.btVerifyCode_:setOnClickListener(handler(self, self.onClick))
    viewGroup:addView(self.btVerifyCode_)

    -- 获取验证码提示
    self.btnPrompt_ = jj.ui.JJButton.new({
        text = "收不到验证码？",
        fontSize = dimens:getDimens(20),
        viewSize = CCSize(dimens:getDimens(140), dimens:getDimens(42)),
        color = ERROR_COLOR,
    })
    self.btnPrompt_:setAnchorPoint(ccp(0, 0.5))
    self.btnPrompt_:setPosition(edAlignLeft + dimens:getDimens(200) + dimens:getDimens(130), y)
    --self.btnPrompt_:setScale(dimens.scale_)
    self.btnPrompt_:setVisible(false)
    self.btnPrompt_:setOnClickListener(handler(self, self.onClick))
    viewGroup:addView(self.btnPrompt_)

    y = y - lineMargin
    -- 密码
    local tvPassword = jj.ui.JJLabel.new({
        text = "输入密码",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        dimensions = tvSize,
    })
    --tvPassword:setScale(dimens.scale_)
    tvPassword:setAnchorPoint(ccp(0, 0.5))
    tvPassword:setPosition(tvAlignLeft, y)
    viewGroup:addView(tvPassword)

    self.editPassword_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(edWidth, edHeight),
        layout = edOffset,
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "editPassword_ text = " .. input)
                if self.editPassword_ then
                    self:checkPasswordConfirm()
                end
            end
        end
    })
    self.editPassword_:setAnchorPoint(ccp(0, 0.5))
    self.editPassword_:setPosition(edAlignLeft, y)
    --self.editPassword_:setScale(dimens.scale_)
    self.editPassword_:setPlaceHolder("8~18位数字、字母或下划线组合")
    self.editPassword_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editPassword_:setPlaceHolderFontColor(Holder_COLOR)
    self.editPassword_:setMaxLength(18)
    self.editPassword_:setFont("宋体", edFontSize)
    self.editPassword_:setFontColor(display.COLOR_BLACK)
    self.editPassword_:setInputMode(kEditBoxInputModeSingleLine)
    self.editPassword_:setReturnType(kKeyboardReturnTypeDone)
    self.editPassword_:setInputFlag(kEditBoxInputFlagPassword)
    viewGroup:addView(self.editPassword_)

    -- 密码提示
    self.imgPassword_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    self.imgPassword_:setScale(dimens.scale_)
    self.imgPassword_:setAnchorPoint(ccp(0, 0.5))
    self.imgPassword_:setPosition(pmAlignLeft, y)
    self.imgPassword_:setVisible(false)
    viewGroup:addView(self.imgPassword_)

   
    self.pmPassword_ = jj.ui.JJLabel.new({
        text = "密码最少8位",
        fontSize = pmFontSize,
        singleLine = false,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        color = ERROR_COLOR,
    })
    -- self.pmPassword_:setScale(dimens.scale_)
    self.pmPassword_:setAnchorPoint(ccp(0, 0.5))
    self.pmPassword_:setPosition(pmAlignLeft, y)
    self.pmPassword_:setVisible(false)
    viewGroup:addView(self.pmPassword_)


    -- 确认密码
    y = y - lineMargin/2

 --[[   local tvConfirm = jj.ui.JJLabel.new({
        text = "再次输入:",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_RIGHT,
        viewSize = tvSize,
        dimensions = tvSize,
    })
    --tvConfirm:setScale(dimens.scale_)
    tvConfirm:setAnchorPoint(ccp(1, 0.5))
    tvConfirm:setPosition(tvAlignLeft, y)
    viewGroup:addView(tvConfirm)

    self.editConfirm_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(edWidth, edHeight),
        layout = edOffset,
        listener = function(event, editbox)
            if event == "ended" then
                local text = editbox:getText()

                local input = "input is nil"
                if (text) then
                    input = text
                end

                JJLog.i(TAG, "editConfirm_ text = " .. input)
                self:checkPasswordConfirm()
            end
        end
    })
    self.editConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.editConfirm_:setPosition(edAlignLeft, y)
    --self.editConfirm_:setScale(dimens.scale_)
    self.editConfirm_:setPlaceHolder("8~18位数字、字母或下划线组合")
    self.editConfirm_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editConfirm_:setPlaceHolderFontColor(Holder_COLOR)
    self.editConfirm_:setMaxLength(18)
    self.editConfirm_:setFont("宋体", edFontSize)
    self.editConfirm_:setFontColor(display.COLOR_BLACK)
    self.editConfirm_:setInputMode(kEditBoxInputModeSingleLine)
    self.editConfirm_:setReturnType(kKeyboardReturnTypeDone)
    self.editConfirm_:setInputFlag(kEditBoxInputFlagPassword)
    viewGroup:addView(self.editConfirm_)


    -- 密码确认提示
    self.imgConfirm_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    --self.imgConfirm_:setScale(dimens.scale_)
    self.imgConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.imgConfirm_:setPosition(pmAlignLeft, y)
    self.imgConfirm_:setVisible(false)
    viewGroup:addView(self.imgConfirm_)

    self.pmConfirm_ = jj.ui.JJLabel.new({
        text = "密码最少8位",
        fontSize = pmFontSize,
        singleLine = false,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        color = ERROR_COLOR,
    })
    --self.pmConfirm_:setScale(dimens.scale_)
    self.pmConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.pmConfirm_:setPosition(pmAlignLeft, y)
    self.pmConfirm_:setVisible(false)
    viewGroup:addView(self.pmConfirm_)
]]
    -- 注册按钮
    y = y - lineMargin
    self.btnRegister_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("register/register_btn_small_green_n.png"),
            highlight = self.theme_:getImage("register/register_btn_small_green_d.png"),
            scale9 = true,
        },
        text = "马上注册",
        fontSize = dimens:getDimens(28),
        viewSize = CCSize(edWidth + dimens:getDimens(110), dimens:getDimens(68)),
    })
    --self.btnRegister_:setScale(dimens.scale_)
    self.btnRegister_:setAnchorPoint(ccp(0, 0.5))
    self.btnRegister_:setPosition(tvAlignLeft, y - dimens:getDimens(10))
    self.btnRegister_:setOnClickListener(handler(self, self.onClick))
    viewGroup:addView(self.btnRegister_)
    
    self:_initData()
end

function MobileRegisterScene:_initData()
    local param = MainController:getTable(TAG)
    JJLog.i(TAG, "_initData", vardump(param))
    if param ~= nil then
        local mobile = param.mobile
        if self.editMobileNumber_ ~= nil and mobile ~= nil and mobile ~= "" then
            self.editMobileNumber_:setText(mobile)
            self:checkMobilePrompt(mobile)
        end

        if self.editCode_ ~= nil and param.code ~= nil then
            self.editCode_:setText(param.code)
        end

        if self.editPassword_ ~= nil and param.password ~= nil then
            self.editPassword_:setText(param.password)
        end

        self.getCodeTime = param.codeTime
        if (self.getCodeTime) then
            self:controlVerifyCode()
        end

    end

    self.controller_:resumeDisplay()
end

function MobileRegisterScene:TimerTick()
    if (self.getCodeTime) then
        local current = JJTimeUtil:getCurrentSecond()
        local expend = current - self.getCodeTime
        local timeout = toint(TIMEOUT - expend)

        if (timeout > 0) then
            self.btVerifyCode_:setText("再次获取\r\n验证码(" .. timeout .. "s)")
        else
            self:StopTimerAndEnable()
        end
    else
        self:StopTimerAndEnable()
    end
end

function MobileRegisterScene:controlVerifyCode()
    JJLog.i(TAG, "controlVerifyCode")
    self.btVerifyCode_:setEnable(false)

    self:TimerTick() --先刷新一次
    self.scheduleHandler_ = scheduler.scheduleGlobal(handler(self, self.TimerTick), 1)
end

function MobileRegisterScene:StopTimer()
    if self.scheduleHandler_ then
        scheduler.unscheduleGlobal(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
end

function MobileRegisterScene:StopTimerAndEnable()
    self.getCodeTime = nil --超时清除时间
    self.btVerifyCode_:setText("获取验证码")
    self.btVerifyCode_:setEnable(true)

    self:StopTimer()
end

function MobileRegisterScene:onClick(target)
    JJLog.i(TAG, "onClick")
    if target == self.btnRegister_ then
        self.controller_:onClickMobileRegister(self.editMobileNumber_:getText(), self.editPassword_:getText(), self.editCode_:getText())
    elseif target == self.btVerifyCode_ then
        local send = self.controller_:onClickGetSmsCode(self.editMobileNumber_:getText())
        if (send) then --如果发送成功才控制
            self.getCodeTime = JJTimeUtil:getCurrentSecond()
            self:controlVerifyCode()
        end
    elseif target == self.btnPrompt_ then
        JJLog.i(TAG, "btnPrompt_")
        self.controller_:onClickGetSmsPrompt()
    end
end

-- 用于注册成功之后，清除之前的输入
function MobileRegisterScene:clearBeforeInput()

    -- 保存编辑后的参数
    local mobile = nil
    local code = nil
    local password = nil

    if self.editMobileNumber_ ~= nil then
        self.editMobileNumber_:setText("")
    end
    if self.editPassword_ ~= nil then
        self.editPassword_:setText("")
    end
    if self.editCode_ ~= nil then
        self.editCode_:setText("")
    end
    --[[
    if self.editConfirm_ ~= nil then
        self.editConfirm_:setText("")
    end
]]
    MainController:setTable(TAG, {
        mobile = mobile,
        code = code,
        password = password,
    })
end

-- 用于注册成功之后，清除之前的输入
function MobileRegisterScene:verifyLoginnameExist(loginname, param, type) 
    local TK_ACK_USRREG_USEREXIST = 11
    local TK_ACK_USRREG_LOGINNAME_LAWLESS = 12
    local TK_ACK_USRREG_LOGINNAME_LAWLESSNUMBER = 13

    JJLog.i("loginname12 = ",loginname,param,type)

        if param == 0 then
            self:refreshLoginnameExistPrompt(true, null, 0)
        else
            local prompt = nil
            if param == TK_ACK_USRREG_USEREXIST then
                prompt = "抱歉,该手机被人使用了！"
            elseif param == TK_ACK_USRREG_LOGINNAME_LAWLESS then
                prompt = "手机号不合法,请重新输入！"
            elseif param == TK_ACK_USRREG_LOGINNAME_LAWLESSNUMBER then
                prompt = "手机号不合法,请重新输入！"
            else
                prompt = "手机号无效,请重新输入!"
            end

            self:refreshLoginnameExistPrompt(false, prompt, ERROR_COLOR)
        end
end

function MobileRegisterScene:refreshLoginnameExistPrompt(valid, prompt, color) 
    JJLog.i(TAG, "refreshLoginnamePrompt", valid, prompt, color)

    if valid then
        self.imgMobile_:setVisible(true)
        self.pmMobileNumber_:setVisible(false)
    else
        self.imgMobile_:setVisible(false)
        self.pmMobileNumber_:setVisible(true)

        self.pmMobileNumber_:setText(prompt)
        self.pmMobileNumber_:setColor(color)
    end
end

return MobileRegisterScene