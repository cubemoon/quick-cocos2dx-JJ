local NormalRegisterScene = class("NormalRegisterScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "NormalRegisterScene"
local ERROR_COLOR = ccc3(255, 217, 0)

require("game.controller.RegisterController")

function NormalRegisterScene:onDestory()
    JJLog.i(TAG, "onDestory")
    NormalRegisterScene.super.onDestory(self)

    -- 保存编辑后的参数
    local username = nil
    local password = nil

    if self.editUserName_ ~= nil then
        username = self.editUserName_:getText()
    end
    if self.editPassword_ ~= nil then
        password = self.editPassword_:getText()
    end

    MainController:setTable(TAG, {
        username = username,
        password = password,
    })

    -- 清理句柄
    self.editUserName_ = nil
    self.imgUserName_ = nil
    self.pmUserName_ = nil

    self.editPassword_ = nil
    self.imgPassword_ = nil
    self.pmPassword_ = nil

    self.editConfirm_ = nil
    self.imgConfirm_ = nil
    self.pmConfirm_ = nil

    self.editCode_ = nil
    self.btnRegister_ = nil
    self.btnPrompt_ = nil
end

-- 更新密码提示
function NormalRegisterScene:checkPasswordConfirm()
    local password = self.editPassword_:getText()
    local confirm = self.editConfirm_:getText()

    JJLog.i(TAG, "checkPasswordConfirm", password, confirm)

    local valid, pmpsw, pmcnf = RegisterController:checkRegistePassword(password, confirm)

    JJLog.i(TAG, "checkPasswordConfirm", valid, pmpsw, pmcnf)

    if (valid) then
        self.imgPassword_:setVisible(true)
        self.imgConfirm_:setVisible(true)

        self.pmPassword_:setVisible(false)
        self.pmConfirm_:setVisible(false)
    else
        self.imgPassword_:setVisible(false)
        self.imgConfirm_:setVisible(false)

        self.pmPassword_:setVisible(true)
        self.pmConfirm_:setVisible(true)

        self.pmPassword_:setText(pmpsw)
        self.pmPassword_:setColor(ERROR_COLOR)

        self.pmConfirm_:setText(pmcnf)
        self.pmConfirm_:setColor(ERROR_COLOR)
    end
end

-- 更新用户名提示
function NormalRegisterScene:refreshLoginnamePrompt(valid, prompt, color)
    JJLog.i(TAG, "refreshLoginnamePrompt", valid, prompt, color)
    if self.imgUserName_ and self.pmUserName_ then
        if valid then
            self.imgUserName_:setVisible(true)
            self.pmUserName_:setVisible(false)
        else
            self.imgUserName_:setVisible(false)
            self.pmUserName_:setVisible(true)

            self.pmUserName_:setText(prompt)
            self.pmUserName_:setColor(color)
        end
    end
end

function NormalRegisterScene:checkUserNamePrompt(text)
    local prompt = self.controller_:checkUserName(text)
    if self.imgUserName_ and self.pmUserName_ then
        if prompt then
            self.imgUserName_:setVisible(false)
            self.pmUserName_:setText(prompt)
            self.pmUserName_:setColor(ERROR_COLOR)
            self.pmUserName_:setVisible(true)
        else
            self.imgUserName_:setVisible(false)
            self.pmUserName_:setText("正在检查用户名...")
            self.pmUserName_:setColor(ccc3(255, 255, 0))
            self.pmUserName_:setVisible(true)

            --send username verify
            LobbyMsg:sendVerifyLoginNameReq(text, nil)
        end
    end
end

function NormalRegisterScene:initView()
    NormalRegisterScene.super.initView(self)
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    --self:setTitle(self.theme_:getImage("register/register_normal_register_title.png"))
    self:setTitle("个性帐号注册")
    JJLog.i(TAG, "NormalRegisterScene:initView ", LoginController.type_)

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
    local tvStartTop = dimens.height - dimens.hScale_ * 100 -- 内容起始点
    local edAlignLeft = dimens:getDimens(375) -- 编辑框左对齐
    local pmAlignLeft = dimens:getDimens(700) -- 提示框左对齐
    local edWidth = dimens:getDimens(320)
    local edHeight = dimens:getDimens(60)
    local lineMargin =  dimens:getDimens(70) -- 两行内容的间隔
    local Holder_COLOR = ccc3(193, 193, 193)

    local y = tvStartTop -- 这一行的 Y 坐标
    -- 帐号
    local tvUserName = jj.ui.JJLabel.new({
        text = "个性帐号",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
    })
    tvUserName:setAnchorPoint(ccp(0, 0.5))
    tvUserName:setPosition(tvAlignLeft, y)
    self:addView(tvUserName)

    local edOffset = {
        paddingLeft = 10,
        paddingRight = 5
    }

    self.editUserName_ = jj.ui.JJEditBox.new({
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

                JJLog.i(TAG, "editUserName_ text = " .. input)
                if self.editUserName_  then
                    self:checkUserNamePrompt(text)
                end
            end
        end
    })

    self.editUserName_:setAnchorPoint(ccp(0, 0.5))
    self.editUserName_:setPosition(edAlignLeft, y)
    --self.editUserName_:setScale(dimens.scale_)
    self.editUserName_:setPlaceHolder("4~18位数字、字母或下划线组合")
    self.editUserName_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editUserName_:setPlaceHolderFontColor(Holder_COLOR)
    self.editUserName_:setMaxLength(18)
    self.editUserName_:setFont("宋体", edFontSize)
    self.editUserName_:setFontColor(display.COLOR_BLACK)
    self.editUserName_:setInputMode(kEditBoxInputModeSingleLine)
    self.editUserName_:setReturnType(kKeyboardReturnTypeDone)
    self:addView(self.editUserName_)

    -- 帐号验证提示
    self.imgUserName_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    self.imgUserName_:setScale(dimens.scale_)
    self.imgUserName_:setAnchorPoint(ccp(0, 0.5))
    self.imgUserName_:setPosition(pmAlignLeft, y)
    self.imgUserName_:setVisible(false)
    self:addView(self.imgUserName_)

    self.pmUserName_ = jj.ui.JJLabel.new({
        text = "用户名已存在",
        fontSize = pmFontSize,
        singleLine = false,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        color = ERROR_COLOR,
    })
    -- self.pmUserName_:setScale(dimens.scale_)
    self.pmUserName_:setAnchorPoint(ccp(0, 0.5))
    self.pmUserName_:setPosition(pmAlignLeft, y)
    self.pmUserName_:setVisible(false)
    self:addView(self.pmUserName_)

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
    -- tvPassword:setScale(dimens.scale_)
    tvPassword:setAnchorPoint(ccp(0, 0.5))
    tvPassword:setPosition(tvAlignLeft, y)
    self:addView(tvPassword)

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
                if self.editPassword_  then
                    self:checkPasswordConfirm()
                end
            end
        end
    })
    self.editPassword_:setAnchorPoint(ccp(0, 0.5))
    self.editPassword_:setPosition(edAlignLeft, y)
    -- self.editPassword_:setScale(dimens.scale_)
    self.editPassword_:setPlaceHolder("8~18位数字、字母或下划线组合")
    self.editPassword_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editPassword_:setPlaceHolderFontColor(Holder_COLOR)
    self.editPassword_:setFontColor(display.COLOR_BLACK)
    self.editPassword_:setMaxLength(18)
    self.editPassword_:setFont("宋体", edFontSize)
    self.editPassword_:setInputMode(kEditBoxInputModeSingleLine)
    self.editPassword_:setReturnType(kKeyboardReturnTypeDone)
    self.editPassword_:setInputFlag(kEditBoxInputFlagPassword)
    self:addView(self.editPassword_)

    -- 密码提示
    self.imgPassword_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    self.imgPassword_:setScale(dimens.scale_)
    self.imgPassword_:setAnchorPoint(ccp(0, 0.5))
    self.imgPassword_:setPosition(pmAlignLeft, y)
    self.imgPassword_:setVisible(false)
    self:addView(self.imgPassword_)

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
    self:addView(self.pmPassword_)

    -- 确认密码
    y = y - lineMargin
    local tvConfirm = jj.ui.JJLabel.new({
        text = "确认密码",
        fontSize = tvFontSize,
        singleLine = true,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        dimensions = tvSize,
    })
    -- tvConfirm:setScale(dimens.scale_)
    tvConfirm:setAnchorPoint(ccp(0, 0.5))
    tvConfirm:setPosition(tvAlignLeft, y)
    self:addView(tvConfirm)

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
                if self.editConfirm_  then
                    self:checkPasswordConfirm()
                end
            end
        end
    })
    self.editConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.editConfirm_:setPosition(edAlignLeft, y)
    -- self.editConfirm_:setScale(dimens.scale_)
    self.editConfirm_:setPlaceHolder("8~18位数字、字母或下划线组合")
    self.editConfirm_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editConfirm_:setPlaceHolderFontColor(Holder_COLOR)
    self.editConfirm_:setFontColor(display.COLOR_BLACK)
    self.editConfirm_:setMaxLength(18)
    self.editConfirm_:setFont("宋体", edFontSize)
    self.editConfirm_:setInputMode(kEditBoxInputModeSingleLine)
    self.editConfirm_:setReturnType(kKeyboardReturnTypeDone)
    self.editConfirm_:setInputFlag(kEditBoxInputFlagPassword)
    self:addView(self.editConfirm_)

    -- 密码确认提示
    self.imgConfirm_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("register/register_right.png"),
    })
    self.imgConfirm_:setScale(dimens.scale_)
    self.imgConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.imgConfirm_:setPosition(pmAlignLeft, y)
    self.imgConfirm_:setVisible(false)
    self:addView(self.imgConfirm_)

    self.pmConfirm_ = jj.ui.JJLabel.new({
        text = "密码最少8位",
        fontSize = pmFontSize,
        singleLine = false,
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = tvSize,
        color = ERROR_COLOR,
    })
    -- self.pmConfirm_:setScale(dimens.scale_)
    self.pmConfirm_:setAnchorPoint(ccp(0, 0.5))
    self.pmConfirm_:setPosition(pmAlignLeft, y)
    self.pmConfirm_:setVisible(false)
    self:addView(self.pmConfirm_)

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
    -- tvCode:setScale(dimens.scale_)
    tvCode:setAnchorPoint(ccp(0, 0.5))
    tvCode:setPosition(tvAlignLeft, y)
    self:addView(tvCode)

    self.editCode_ = jj.ui.JJEditBox.new({
        normal = self.theme_:getImage("common/edit_bg.png"),
        viewSize = CCSize(dimens:getDimens(180), edHeight),
        layout = edOffset,
        listener = function(event, editbox) end
    })
    self.editCode_:setAnchorPoint(ccp(0, 0.5))
    self.editCode_:setPosition(edAlignLeft, y)
    -- self.editCode_:setScale(dimens.scale_)
    self.editCode_:setPlaceHolder("输入验证码")
    self.editCode_:setPlaceHolderFont("宋体", edPlaceHolderSize)
    self.editCode_:setPlaceHolderFontColor(Holder_COLOR)
    self.editCode_:setFontColor(display.COLOR_BLACK)
    self.editCode_:setMaxLength(4)
    self.editCode_:setFont("宋体", edFontSize)
    self.editCode_:setInputMode(kEditBoxInputModeSingleLine)
    self.editCode_:setReturnType(kKeyboardReturnTypeDone)
    self:addView(self.editCode_)

    self.codeImage_ = jj.ui.JJImage.new({
        viewSize = CCSize(140, 42),
    })
    self.codeImage_:setPosition(edAlignLeft + dimens:getDimens(250), y)
    self.codeImage_:setScale(dimens.scale_ * 1.5)
    self.codeImage_:setAnchorPoint(ccp(0, 0.5))
    self.codeImage_:setTouchEnable(true)
    self.codeImage_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.codeImage_)

    -- 获取验证码提示
    self.btnPrompt_ = jj.ui.JJButton.new({
        text = "点击换一张",
        fontSize = dimens:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = CCSize(dimens:getDimens(140), dimens:getDimens(42)),
        color = ccc3(255,217,0),
    })
    self.btnPrompt_:setAnchorPoint(ccp(0, 0.5))
    self.btnPrompt_:setPosition(pmAlignLeft, y)
    -- self.btnPrompt_:setScale(dimens.scale_)
    self.btnPrompt_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnPrompt_)

    -- 注册按钮
    y = y - dimens.hScale_ * 92
    self.btnRegister_ = jj.ui.JJButton.new({
        images = {
            --normal = self.theme_:getImage("common/common_btn_long_green_n.png"),
            --highlight = self.theme_:getImage("common/common_btn_long_green_d.png"),
            normal = self.theme_:getImage("register/register_btn_small_green_n.png"),
            highlight = self.theme_:getImage("register/register_btn_small_green_d.png"),
            scale9 = true,
        },
        --text = "马上注册",
        --fontSize = 28,
        viewSize = CCSize(320 + 110, 68),
    })
    self.btnRegister_:setScale(dimens.scale_)
    self.btnRegister_:setAnchorPoint(ccp(0, 0.5))
    self.btnRegister_:setPosition(tvAlignLeft, y + self.dimens_:getDimens(5))
    self.btnRegister_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnRegister_)

    local btnText = jj.ui.JJLabel.new({
            text = "马上注册",            
            fontSize = self.dimens_:getDimens(28),
       })
    btnText:setAnchorPoint(ccp(0.5, 0.5))
    btnText:setPosition(tvAlignLeft + self.btnRegister_:getBoundingBoxWidth() * self.dimens_.scale_ / 2 , y + self.dimens_:getDimens(5) )
    self:addView(btnText)

    self:_initData()
end

function NormalRegisterScene:_initData()
    local param = MainController:getTable(TAG)
    JJLog.i(TAG, "_initData", vardump(param))

    if param ~= nil then
        local name = param.username
        if self.editUserName_ ~= nil and name ~= nil and name ~= "" then
            self.editUserName_:setText(name)
            self:checkUserNamePrompt(name)
        end
        if self.editPassword_ ~= nil and param.password ~= nil then
            self.editPassword_:setText(param.password)
        end
    end

    self.controller_:resumeDisplay()
end

function NormalRegisterScene:onClick(target)
    JJLog.i(TAG, "onClick")
    if target == self.btnRegister_ then
        self.controller_:onClickRegister(self.editUserName_:getText(), self.editPassword_:getText(), self.editConfirm_:getText(), self.editCode_:getText())
    elseif target == self.codeImage_ then
        self.controller_:onClickVerifyCode()
    elseif target == self.btnPrompt_ then
        self.controller_:onClickVerifyCode()
    end
end

-- 刷新验证码
function NormalRegisterScene:refreshCodeImage(image)
    JJLog.i(TAG, "refreshCodeImage")
    if self.codeImage_ ~= nil then
        if image == nil then
            self.codeImage_:setVisible(false)
        else
            self.codeImage_:setVisible(true)
            CCTextureCache:sharedTextureCache():removeTextureForKey(image)
            local pic = CCTextureCache:sharedTextureCache():addImage(image)
            self.codeImage_:setTexture(pic)
            local textureRect = CCRectMake(0, 0, 86, 26)
            self.codeImage_:setTextureRect(textureRect)
        end
    end
end

-- 更新用户名提示
function NormalRegisterScene:verifyLoginname(loginname, param)
    local name = self.editUserName_:getText()

    local PARAM_OK = 0
    local PARAM_EXIST = 10
    local PARAM_INVALID = 12
    
    if (name ~= nil and loginname == name) then

        if (param == 0) then
            self:refreshLoginnamePrompt(true, nil, 0)
        else

            local prompt = nil

            if (param == PARAM_EXIST) then
                prompt = "用户名已存在"
            elseif (param == PARAM_INVALID) then
                prompt = "用户名非法"
            else
                prompt = "用户名不能使用"
            end

            self:refreshLoginnamePrompt(false, prompt, ERROR_COLOR)
        end
    end
end

-- 用于注册成功之后，清除之前的输入
function NormalRegisterScene:clearBeforeInput()

    -- 保存编辑后的参数
    local username = nil
    local password = nil
    local confirm = nil

    if self.editUserName_ ~= nil then
        username = self.editUserName_:setText("")
    end
    if self.editPassword_ ~= nil then
        password = self.editPassword_:setText("")
    end
    if self.editConfirm_ ~= nil then
        confirm = self.editConfirm_:setText("")
    end
    if self.editCode_ ~= nil then
        self.editCode_:setText("")
    end

    MainController:setTable(TAG, {
        username = username,
        password = password,
        confirm = confirm,
    })
end

return NormalRegisterScene
