
local JJViewGroup = import("sdk.ui.JJViewGroup")
local NoteManagerView = class("NoteManagerView", JJViewGroup)

local TAG = "NoteManagerView"

NoteManagerView.TYPE_NOTE = 0
NoteManagerView.TYPE_MSG = 1

local function _onClickMask(self)
    self:removeSelf(true)
    self.scene_:removeMsgView()
end

function NoteManagerView:ctor(params)
    NoteManagerView.super.ctor(self, params)

    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.width_ = self.dimens_:getDimens(671)
    self.height_ = self.dimens_:getDimens(355)
    local menuWidth = self.dimens_:getDimens(280)
    local marginLeft = (self.dimens_.width - self.width_)/2
    local left = marginLeft
    local marginTop = (self.dimens_.height - self.height_)/2 + self.height_
    local top = marginTop

    self:setViewSize(self.dimens_.width, self.dimens_.height)
    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self:addView(self.bgMask_)
    self.bgMask_:setOnClickListener(handler(self, _onClickMask))

    -- 背景框
    self.bg_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_dialog_small.png"),
    })
    self.bg_:setAnchorPoint(ccp(0, 1))
    self.bg_:setPosition(left, top)
    self.bg_:setScale(self.dimens_.scale_)
    self.bg_:setTouchEnable(true)
    self.bg_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.bg_)

    -- title
   self.title_ = jj.ui.JJLabel.new({
    fontSize = self.dimens_:getDimens(28),
    color = ccc3(105, 27, 0),
    text = "消 息",
    })
    self.title_:setAnchorPoint(ccp(0.5, 1))
    self.title_:setPosition(self.dimens_.cx, top - self.dimens_:getDimens(18))
    self:addView(self.title_)

   -- 关闭按钮
    self.btnClose_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_dialog_close_btn_n.png"),
            highlight = self.theme_:getImage("common/common_dialog_close_btn_d.png"),
        },
    })
    self.btnClose_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnClose_:setPosition(self.width_ + marginLeft - self.dimens_:getDimens(18), marginTop - self.dimens_:getDimens(18))
    self.btnClose_:setScale(self.dimens_.scale_)
    self.btnClose_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnClose_)
    self.type_ = self.TYPE_MSG
    self:initView()
end

function NoteManagerView:onClick(target)
    if target == self.bg_ then
    -- return true
    elseif target == self.btnClose_ then
        self:removeSelf(true)
        self.scene_:removeMsgView()
    end
end

function NoteManagerView:initView()
    local marginTop = (self.dimens_.height - self.height_)/2 + self.height_
    local top = marginTop - self.dimens_:getDimens(66)
    local left = (self.dimens_.width - self.width_)/2+self.dimens_:getDimens(9)
    local noteMsgItems = NoteManager:getItems(MainController:getCurPackageId(), UserInfo.userId_)
    if (noteMsgItems == nil) or (#noteMsgItems == 0) then --no msg show no msg info
        local prompt = jj.ui.JJLabel.new({
            fontSize = self.dimens_:getDimens(26),
            color = ccc3(169, 128, 89),
            text = "暂无新消息",
        })
        prompt:setAnchorPoint(ccp(0.5, 0.5))
        prompt:setPosition(ccp(self.dimens_.cx, self.dimens_.cy))
        self:addView(prompt)
    else
        self.contentView_ = require("game.ui.view.NoteMsgView").new({theme = self.theme_,
            dimens = self.dimens_, scene = self, width = self.dimens_:getDimens(671-17), height = self.dimens_:getDimens(270),
            items = noteMsgItems})
        self.contentView_:setAnchorPoint(ccp(0, 1))
        self.contentView_:setPosition(left, top)
        self:addView(self.contentView_)
    end
end

function NoteManagerView:refresh()
    if self.contentView_ ~= nil then
        self.contentView_:refresh()
    end
end

return NoteManagerView