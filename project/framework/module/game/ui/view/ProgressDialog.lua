local ProgressDialog = class("ProgressDialog", import("sdk.ui.JJDialogBase"))
local TAG = "ProgressDialog"

ProgressDialog.layer_ = nil
local txtWidth = 280
local txtHeight = 80
local iconWidth = 42
local iconHeight = 42
local iconMargin = 18
local bgWidth = txtWidth + iconWidth + iconMargin * 2
local bgHeight = txtHeight
local iconX = iconMargin + iconWidth / 2

--[[
    参数
    @text: 提示的内容
    @close: 是否显示关闭按钮，默认显示
]]
function ProgressDialog:ctor(theme, dimens, params)
    ProgressDialog.super.ctor(self, params)

    self.theme_ = theme
    self.dimens_ = dimens

    bgWidth = txtWidth + iconWidth + iconMargin * 2
    bgHeight = txtHeight
    if self.dimens_ then
        bgWidth = self.dimens_:getDimens(bgWidth)
        bgHeight = self.dimens_:getDimens(bgHeight)
    end

    local txt = "提示"
    if params ~= nil and params.text ~= nil then
        txt = params.text
    end

    self.layer_ = jj.ui.JJViewGroup.new({
        viewSize = CCSize(bgWidth, bgHeight)
    })
    self.layer_:setAnchorPoint(ccp(0.5, 0.5))
    self.layer_:setPosition(ccp(self.dimens_.cx, self.dimens_.cy))
    -- self.layer_:setScale(self.dimens_.scale_)
    self:addView(self.layer_)

    -- 进度框
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/loading_bg.png"),
        scale9 = true,
        viewSize = CCSize(bgWidth, bgHeight),
    })
    bg:setAnchorPoint(ccp(0, 0))
    bg:setPosition(0, 0)
    self.layer_:addView(bg)

    local icon = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/loading_icon.png")
    })
    icon:setScale(self.dimens_.scale_)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(self.dimens_:getDimens(iconX), bgHeight / 2)
    icon:getImage():runAction(CCRepeatForever:create(CCRotateTo:create(1, 720)))
    self.layer_:addView(icon)

    -- 文字
    local label = jj.ui.JJLabel.new({
        text = txt,
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(255, 255, 255),
    })
    label:setAnchorPoint(ccp(0, 0.5))
    label:setPosition(self.dimens_:getDimens(iconX + iconMargin + iconWidth / 2), bgHeight / 2)
    self.layer_:addView(label)
end

--[[
    设置关闭按钮
    @callback: 按钮回调
]]
function ProgressDialog:setCloseButton(callback)
    self.btnCloseCB_ = callback

    if self.btnClose_ == nil then
        self.btnClose_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
                highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
            },
        })
        self.btnClose_:setAnchorPoint(ccp(1, 1))
        self.btnClose_:setPosition(bgWidth, bgHeight)
        self.btnClose_:setOnClickListener(handler(self, self.onClick))
        self.layer_:addView(self.btnClose_)
    end
end

function ProgressDialog:onClick(target)
    if target == self.btnClose_ and self.btnCloseCB_ ~= nil then
        self.btnCloseCB_()
    end
    self:dismiss()
end

return ProgressDialog
