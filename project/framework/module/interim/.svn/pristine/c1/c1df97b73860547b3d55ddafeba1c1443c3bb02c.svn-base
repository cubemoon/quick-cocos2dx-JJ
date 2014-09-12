local JJViewGroup = require("sdk.ui.JJViewGroup")
local GameTip = class("GameTip", JJViewGroup)
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local TAG = "GameTip"

function GameTip:ctor(parent)
    GameTip.super.ctor(self)
    self.controllerView_ = parent
    self.theme_ = parent.theme_
    self.dimens_ = parent.dimens_

    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self.bgMask_:setOpacity(50) -- 完全透明
    self.bgMask_:setOnClickListener(handler(self, self.onClick))
    self.bgMask_:setVisible(false)
    self.controllerView_:addView(self.bgMask_)

    self:createComponents()

    self:setViewSize(248, 88)
    self:setAnchorPoint(CCPoint(0.5, 0.5))
    self:setPosition(self.dimens_.cx - self.dimens_:getDimens(50), self.dimens_.cy + self.dimens_:getDimens(40))
end

function GameTip:createComponents()
    local array = CCArray:create()
    for i = 1, 8 do
        array:addObject(CCSpriteFrame:create("img/interim/gametip/" .. i .. ".png", CCRect(0, 0, 82, 82)))
    end
    local animation = CCAnimation:createWithSpriteFrames(array, 0.08)

    local img = jj.ui.JJImage:new()
    img:setAnchorPoint(CCPoint(0.5, 0.5))
    img:setPosition(44, 44)
    self:addView(img)
    img:playAnimationForever(animation)

    local prompt = jj.ui.JJImage.new({
        image = "img/interim/gametip/prompt.png"
    })
    prompt:setPosition(90, 44)
    prompt:setAnchorPoint(ccp(0, 0.5))
    self:addView(prompt)

    self:setScale(self.dimens_.scale_)
end

function GameTip:showTipMessage(text, interval)
    --    text = "系统将重新调整位置，请您稍候。"
    self:unschedule()

    local tick = 2
    if (interval) then
        tick = interval
    end

    self:setVisible(true)
    self.bgMask_:setVisible(true)
    --self:startTimer(tick)
end

function GameTip:startTimer(interval)
    JJLog.i(TAG, "startTimer")
    self.scheduleHandler_ = self:schedule(handler(self, self.onTime), interval)
end

function GameTip:closeDisplay()
    JJLog.i(TAG, "closeDisplay")
    self:setVisible(false)
    self.bgMask_:setVisible(false)
    self:unschedule()
end

function GameTip:onTime()
    JJLog.i(TAG, "onTime")

    self:closeDisplay()
end

function GameTip:unschedule()
    if self.scheduleHandler_ then
        self:unschedule(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
end

function GameTip:onExit()
    self:unschedule()
end

function GameTip:onClick(target)
    if (target == self.bgMask_) then
    end
end

return GameTip