local JJViewGroup = import("sdk.ui.JJViewGroup")
local JJButtonExt = class("JJButtonExt", JJViewGroup)

local TAG = "JJButtonExt"

--[[
    params 参数描述：
        singleLine: 单行
        font: 字体
        fontSize: 字体大小
        color: 字体颜色
        text: 内容
        align: 水平对齐
        valign: 垂直对齐
        txtLeft, txtTop: 低标文字位置， anchorpoint(0,1)算的
        txtSize: 低标文字View Size
        btnLeft, btnTop: 图片按钮位置, anchorpoint(0,1)算的
        btnSize: 图片按钮 viewSize
        scale: 缩放比
]]

function JJButtonExt:ctor(params)
    JJButtonExt.super.ctor(self, params)
    assert(type(params) == "table", "JJButtonExt.ctor invalid params")
    self.params = params
    self.scale_ = 1
    local x, y = params.btnLeft, params.btnTop
    self.btnImg_= jj.ui.JJButton.new({
         images = params.images,
         --viewSize = params.btnSize,
       })
    self.btnImg_:setAnchorPoint(ccp(0, 1))
    self.btnImg_:setPosition(x, y)

    self:addView(self.btnImg_)

    x, y = params.txtLeft, params.txtTop
    self.btnTxt_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = params.fontSize,
                        color = params.color,
                        text = params.text,
                        align = params.align,
                        viewSize = params.txtSize,
                    })
    self.btnTxt_:setAnchorPoint(ccp(0, 1))
    self.btnTxt_:setPosition(x, y)
    self:addView(self.btnTxt_)

end

function JJButtonExt:initTopRightTip()
    local w, h = self.params.viewSize.width, self.params.viewSize.height
    local theme,dimen = self.params.theme,self.params.dimen
    JJLog.i("linxh", "initTopRightTip", w, h)
    self.tipbg_= jj.ui.JJImage.new({
         image = theme:getImage("pcenter/pcenter_remind_new.png"),
         --viewSize = params.btnSize,
       })
    self.tipbg_:setAnchorPoint(ccp(0.5, 0.5))
    self.tipbg_:setPosition(w-dimen:getDimens(25), h-dimen:getDimens(13))
    self.tipbg_:setScale(self.scale_*0.8)
    self:addView(self.tipbg_)

    self.tipLabel_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = dimen:getDimens(13),
                        color = ccc3(255,255,255),
                        text = "0",
                        align = ui.TEXT_ALIGN_CENTER,
                        viewSize = CCSize(dimen:getDimens(30), dimen:getDimens(30)),
                    })
    self.tipLabel_:setAnchorPoint(ccp(0.5, 0.5))
    self.tipLabel_:setPosition(w-dimen:getDimens(25), h-dimen:getDimens(13))
    self:addView(self.tipLabel_)
end

function JJButtonExt:setScale(scale)
    self.scale_ = scale or 1
    if self.btnImg_ then self.btnImg_:setScale(self.scale_) end
end

function JJButtonExt:setId(id)
    JJButtonExt.super.setId(self, id)
    if self.btnImg_ then
        self.btnImg_:setId(id)
    end
end

function JJButtonExt:onClick(target)
    if self.onClickListener then self.onClickListener(self) end
end

function JJButtonExt:setOnClickListener(listener)
    self.onClickListener = listener

    if self.btnImg_ ~= nil then
        self.btnImg_:setOnClickListener(handler(self, self.onClick))
    end

    self:setTouchEnable(true)
    JJButtonExt.super.setOnClickListener(self, listener)
end

function JJButtonExt:setTipCount(count)
    if count > 0 and not self.tipLabel_ then
        self:initTopRightTip()
    end

    if self.tipLabel_ then
        if count > 0 then
            if self.tipbg_ then self.tipbg_:setVisible(true) end
            self.tipLabel_:setVisible(true)
            self.tipLabel_:setText(count)
        else
            if self.tipbg_ then self.tipbg_:setVisible(false) end
            self.tipLabel_:setVisible(false)
        end
    end
end

return JJButtonExt
