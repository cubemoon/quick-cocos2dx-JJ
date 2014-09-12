--[[
    提示对话框，有标题，无警示图标
]]
local AlertDialog = class("AlertDialog", import("sdk.ui.JJDialogBase"))
local TAG = "AlertDialog"

local bgWidth = 454
local bgHeight = 303

AlertDialog.layer_ = nil

--[[
    参数
    @title: 标题
    @prompt: 提示的内容
]]
function AlertDialog:ctor(params)
    AlertDialog.super.ctor(self, params)

    self.theme_ = params.theme
    self.dimens_ = params.dimens

    bgWidth = 454
    bgHeight = 303
    bgWidth = self.dimens_:getDimens(bgWidth)
    bgHeight = self.dimens_:getDimens(bgHeight)

    self.layer_ = jj.ui.JJViewGroup.new({
            viewSize = CCSize(bgWidth, bgHeight),
        })
    self.layer_:setAnchorPoint(ccp(0.5, 0.5))
    self.layer_:setPosition(ccp(self.dimens_.cx, self.dimens_.cy))
    -- self.layer_:setScale(self.dimens_.scale_)
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
        fontSize = self.dimens_:getDimens(28),
        color = ccc3(73, 63, 48),
    })
    title:setAnchorPoint(ccp(0.5, 1))
    title:setPosition(bgWidth / 2, bgHeight - self.dimens_:getDimens(36))
    self.layer_:addView(title)

    -- 提示文字
    if params ~= nil and params.prompt ~= nil then
        txt = params.prompt
    end

    local prmptFontSize = self.dimens_:getDimens(22)
    if(params.promptFontSize) then
        prmptFontSize = self.dimens_:getDimens(params.promptFontSize)
    end

    self.prompt_ = jj.ui.JJLabel.new({
        singleLine = false,
        text = txt,
        fontSize = prmptFontSize,
        color = ccc3(113, 97, 74),
        viewSize = CCSize(self.dimens_:getDimens(400), self.dimens_:getDimens(160)),
        valign = ui.TEXT_VALIGN_TOP
    })
    self.prompt_:setAnchorPoint(ccp(0.5, 1))
    self.prompt_:setPosition(bgWidth / 2, bgHeight - self.dimens_:getDimens(80))
    self.layer_:addView(self.prompt_)
end

function AlertDialog:onClick(target)
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
function _relayoutBtn(self)
    local count = 0 -- 按钮数量
    if self.btn1Txt_ ~= nil then
        count = count + 1
    end
    if self.btn2Txt_ ~= nil then
        count = count + 1
    end

    if self.btn1_ ~= nil then
        self.layer_:removeView(self.btn1_)
    end

    if self.btn2_ ~= nil then
        self.layer_:removeView(self.btn2_)
    end

    local btnY = self.dimens_:getDimens(70)
    local fontSize = self.dimens_:getDimens(30)
    local btnSize = CCSize()
    if count == 1 then

        if self.btn1Txt_ ~= nil then
            self.btn1_ = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("common/common_btn_long_green_n.png"),
                    highlight = self.theme_:getImage("common/common_btn_long_green_d.png"),
                },
                fontSize = fontSize,
                color = ccc3(255, 255, 255),
                text = self.btn1Txt_,
                viewSize = CCSize(self.dimens_:getDimens(234), self.dimens_:getDimens(68)),
            })
            self.btn1_:setAnchorPoint(ccp(0.5, 0.5))
            self.btn1_:setPosition(bgWidth / 2, btnY)
            self.btn1_:setOnClickListener(handler(self, self.onClick))
            self.layer_:addView(self.btn1_)
        else
            self.btn2_ = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("common/common_btn_long_green_n.png"),
                    highlight = self.theme_:getImage("common/common_btn_long_green_d.png"),
                },
                fontSize = fontSize,
                color = ccc3(255, 255, 255),
                text = self.btn2Txt_,
                viewSize = CCSize(self.dimens_:getDimens(234), self.dimens_:getDimens(68)),
            })
            self.btn2_:setAnchorPoint(ccp(0.5, 0.5))
            self.btn2_:setPosition(bgWidth / 2, btnY)
            self.btn2_:setOnClickListener(handler(self, self.onClick))
            self.layer_:addView(self.btn2_)
        end

    elseif count == 2 then

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
        self.btn1_:setAnchorPoint(ccp(0, 0.5))
        self.btn1_:setPosition(self.dimens_:getDimens(24), btnY)
        self.btn1_:setOnClickListener(handler(self, self.onClick))
        self.layer_:addView(self.btn1_)

        self.btn2_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_alert_dialog_btn_2_n.png"),
                highlight = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png"),
            },
            fontSize = fontSize,
            color = ccc3(255, 255, 255),
            text = self.btn2Txt_,
            viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
        })
        self.btn2_:setAnchorPoint(ccp(0, 0.5))
        self.btn2_:setPosition(self.dimens_:getDimens(233), btnY)
        self.btn2_:setOnClickListener(handler(self, self.onClick))
        self.layer_:addView(self.btn2_)
    end
end

--[[
    设置按钮一
    @text: 按钮内容
    @callback: 按钮回调
]]
function AlertDialog:setButton1(text, callback)
    self.btn1Txt_ = text
    self.btn1CB_ = callback
    _relayoutBtn(self)
end

--[[
    设置按钮二
    @text: 按钮内容
    @callback: 按钮回调
]]
function AlertDialog:setButton2(text, callback)
    self.btn2Txt_ = text
    self.btn2CB_ = callback
    _relayoutBtn(self)
end

--[[
    设置关闭按钮
    @callback: 按钮回调
]]
function AlertDialog:setCloseButton(callback)
    self.btnCloseCB_ = callback

    if self.btnClose_ == nil then
        self.btnClose_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
                highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
            },
        })
        self.btnClose_:setAnchorPoint(ccp(0.5, 0.5))
        self.btnClose_:setScale(0.8 * self.dimens_.scale_)
        self.btnClose_:setPosition(bgWidth - self.dimens_:getDimens(24), bgHeight - self.dimens_:getDimens(24))
        self.btnClose_:setOnClickListener(handler(self, self.onClick))
        self.layer_:addView(self.btnClose_)
    end
end

--[[
    设置提示文字
]]
function AlertDialog:setPrompt(text)
   if self.prompt_ and text then 
       self.prompt_:setText(text)
   end
end

return AlertDialog