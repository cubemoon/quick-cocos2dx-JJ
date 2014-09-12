--[[
    提示对话框，有标题，无警示图标
]]
local ExtendAlertDialog = class("ExtendAlertDialog", import("sdk.ui.JJDialogBase"))
local TAG = "ExtendAlertDialog"

local bgWidth = 454
local bgHeight = 303

ExtendAlertDialog.layer_ = nil

--[[
    参数
    @title: 标题
    @prompt: 提示的内容
]]
function ExtendAlertDialog:ctor(params)
    ExtendAlertDialog.super.ctor(self, params)

    self.theme_ = params.theme
    self.dimens_ = params.dimens

    local dialogBgWidth = self.dimens_:getDimens(bgWidth)
    local dialogBgHeight = self.dimens_:getDimens(bgHeight)

    self.layer_ = jj.ui.JJViewGroup.new({
            viewSize = CCSize(dialogBgWidth, dialogBgHeight),
        })
    self.layer_:setAnchorPoint(ccp(0.5, 0.5))
    self.layer_:setPosition(ccp(self.dimens_.cx, self.dimens_.cy))
    --self.layer_:setScale(self.dimens_.scale_)
    self:addView(self.layer_)

    -- 背景框
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_alert_dialog_bg.png"),
    })
    bg:setScale(self.dimens_.scale_)
    bg:setAnchorPoint(ccp(0, 0))
    bg:setPosition(0, 0)
    bg:setTouchEnable(true)
    bg:setOnClickListener(function(view) end)
    self.layer_:addView(bg)

    -- 标题
    local txt = "标题"
    if params ~= nil and params.title ~= nil then
        txt = params.title
    end
    local title = jj.ui.JJLabel.new({
        text = txt,
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(73, 63, 48),
    })
    title:setAnchorPoint(ccp(0.5, 1))
    title:setPosition(dialogBgWidth / 2, dialogBgHeight - 25)
    self.layer_:addView(title)

    -- 提示文字
    if params ~= nil and params.prompt ~= nil then
        txt = params.prompt
    end

    local prmptFontSize = self.dimens_:getDimens(22)
    if params.promptFontSize then
        prmptFontSize = self.dimens_:getDimens(params.promptFontSize)
    end

    self.prompt_ = jj.ui.JJLabel.new({
        singleLine = false,
        text = txt,
        fontSize = prmptFontSize,
        color = ccc3(113, 97, 74),
        viewSize = CCSize(self.dimens_:getDimens(400), self.dimens_:getDimens(180)),
        valign = ui.TEXT_VALIGN_TOP
    })
    self.prompt_:setAnchorPoint(ccp(0.5, 1))
    self.prompt_:setPosition(dialogBgWidth / 2, dialogBgHeight - self.dimens_:getDimens(45))
    self.layer_:addView(self.prompt_)
end

function ExtendAlertDialog:onClick(target)
    if target == self.btn1_ and self.btn1CB_ ~= nil then
        self.btn1CB_()
    elseif target == self.btn2_ and self.btn2CB_ ~= nil then
        self.btn2CB_()
    elseif target == self.btnClose_ and self.btnCloseCB_ ~= nil then
        self.btnCloseCB_()
    end
    self:dismiss()
end

--[[
    重新设置按钮区域
]]
function ExtendAlertDialog:relayoutBtn(self)
    local fontSize = self.dimens_:getDimens(26)

    self.btn1_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
        },
        fontSize = fontSize,
        color = ccc3(255, 255, 255),
        text = self.btn1Txt_,
        viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
    })
    self.btn1_:setAnchorPoint(ccp(0.5, 0))
    self.btn1_:setPosition(self.dimens_:getDimens(bgWidth/4 + 9), self.dimens_:getDimens(bgHeight/10))
    self.btn1_:setOnClickListener(handler(self, self.onClick))
    self.layer_:addView(self.btn1_)

    self.btn2_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
        },
        fontSize = fontSize,
        color = ccc3(255, 255, 255),
        text = self.btn2Txt_,
        viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
    })
    self.btn2_:setAnchorPoint(ccp(0.5, 0))
    self.btn2_:setPosition(self.dimens_:getDimens(bgWidth*3/4 - 9), self.dimens_:getDimens(bgHeight/10))
    self.btn2_:setOnClickListener(handler(self, self.onClick))
    self.layer_:addView(self.btn2_)

    self.btn3_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_firstIn_dialog_btn_n.png"),
            highlight = self.theme_:getImage("common/common_firstIn_dialog_btn_d.png"),
        },
        fontSize = fontSize,
        color = ccc3(255, 255, 255),
        text = self.btn3Txt_,
        viewSize = CCSize(self.dimens_:getDimens(396), self.dimens_:getDimens(68)),
    })
    self.btn3_:setAnchorPoint(ccp(0.5, 0))
    self.btn3_:setPosition(self.dimens_:getDimens(bgWidth/2), self.dimens_:getDimens(bgHeight/3 + 15))
    self.btn3_:setOnClickListener(handler(self, self.onClick))
    self.layer_:addView(self.btn3_)  
end

--[[
    设置按钮一
    @text: 按钮内容
    @callback: 按钮回调
]]
function ExtendAlertDialog:setButton1(text, callback)
    self.btn1Txt_ = text
    self.btn1CB_ = callback
end

--[[
    设置按钮二
    @text: 按钮内容
    @callback: 按钮回调
]]
function ExtendAlertDialog:setButton2(text, callback)
    self.btn2Txt_ = text
    self.btn2CB_ = callback
end

--[[
    设置按钮三
    @text: 按钮内容
    @callback: 按钮回调
]]
function ExtendAlertDialog:setButton3(text, callback)
    self.btn3Txt_ = text
    self.btn3CB_ = callback
end

function ExtendAlertDialog:setRelayoutBtn()
    self:relayoutBtn(self)
end

--[[
    设置关闭按钮
    @callback: 按钮回调
]]
function ExtendAlertDialog:setCloseButton(callback)
    self.btnCloseCB_ = callback

    if self.btnClose_ == nil then
        self.btnClose_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
                highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
            },
        })
        self.btnClose_:setAnchorPoint(ccp(1, 1))
        self.btnClose_:setScale(0.8 * self.dimens_.scale_)
        self.btnClose_:setPosition(self.dimens_:getDimens(bgWidth + 20) ,self.dimens_:getDimens(bgHeight + 10))
        self.btnClose_:setOnClickListener(handler(self, self.onClick))
        self.layer_:addView(self.btnClose_)
    end
end

--[[
    设置提示文字
]]
function ExtendAlertDialog:setPrompt(text)
   if self.prompt_ and text then 
       self.prompt_:setText(text)
   end
end

return ExtendAlertDialog