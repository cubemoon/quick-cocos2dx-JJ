-- 局间等待界面
--[[ 如果重载了该view必须实现以下方法
无
]]
local RoundWaitView = class("RoundWaitView", require("game.ui.view.JJMatchView"))

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")

function RoundWaitView:ctor(viewController)
  RoundWaitView.super.ctor(self, viewController)
  --self.frameIndex_ = 1
  self.scheduleHandler_ = nil
  --self.imageId_ = {}
  --self.imageSprite_ = {}
  self:initView()
end

-- 初始化view内容
function RoundWaitView:initView()

  --背景
  local bg = jj.ui.JJImage.new({
    image = self.theme_:getImage("common/bg_normal.jpg")
  })
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(self.dimens_.cx, self.dimens_.cy)
  bg:setScaleX(self.dimens_.wScale_)
  bg:setScaleY(self.dimens_.hScale_)
  self:addView(bg)

  -- 动画
  self.animImages = self:getAnimImages()
  local array = CCArray:create()
  for k, img in pairs(self.animImages) do
    array:addObject(CCSpriteFrame:create(img, CCRect(0, 0, 180, 223)))
  end
  local animation = CCAnimation:createWithSpriteFrames(array, 0.08)

  local lord = jj.ui.JJImage.new({image = self.animImages[1]})
  lord:setPosition(self.dimens_.cx, self.dimens_.cy + self.dimens_:getDimens(120))
  lord:setScale(self.dimens_.scale_)
  self:addView(lord)
  lord:playAnimationForever(animation)

  local label = jj.ui.JJLabel.new({
    text = "正在为您智能选桌，敬请等待，精彩即刻上演...",
    fontSize = self.dimens_:getDimens(20),
    font = ui.DEFAULT_TTF_FONT,
    color = ccc3(12, 66, 112),--#FF0C4270
    singleLine = true,
  })
  label:setAnchorPoint(CCPoint(0.5, 0.5))
  --label:setScale(self.dimens_.scale_)
  label:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(10))
  self:addView(label)

  -- 提示语
  self.strPrompt = self:getPrompts()

  self.prompt = jj.ui.JJLabel.new({
    text = self.strPrompt[1],
    singleLine = true,
    fontSize = self.dimens_:getDimens(20),
    color = ccc3(255, 255, 255),
    text = self.strPrompt[math.random(8)],
    viewSize = CCSize(self.dimens_.width, self.dimens_:getDimens(79)),
    align = ui.TEXT_ALIGN_CENTER,
    background = {
      image = self.theme_:getImage("switchtogame/prompt_bg.png"),
      scale9 = true,
    }
  })
  self.prompt:setAnchorPoint(ccp(0.5, 1))
  self.prompt:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(35))
  self:addView(self.prompt)

  --按钮
  local btnWidth, bthHeight = self.dimens_:getDimens(234), self.dimens_:getDimens(68)
  local marginBtn = self.dimens_:getDimens(40)

  local allowRoar = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR)
  if allowRoar then
    self.btnRoar = jj.ui.JJButton.new({
      images = {
        normal = self.theme_:getImage("common/common_btn_long_blue_n.png"),
        highlight = self.theme_:getImage("common/common_btn_long_blue_d.png"),
      },
      fontSize = self.dimens_:getDimens(26),
      color = display.COLOR_WHITE,
      text = "咆哮",
      align = ui.TEXT_ALIGN_CENTER,
      valign = ui.TEXT_VALIGN_CENTER,
      viewSize = CCSize(btnWidth, bthHeight)
    })
    self.btnRoar:setAnchorPoint(ccp(0, 0))
    --self.btnRoar:setScale(self.dimens_.scale_)
    self.btnRoar:setPosition(self.dimens_.cx - marginBtn / 2 - btnWidth,
                        self.dimens_.bottom + self.dimens_:getDimens(30))
    self.btnRoar:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnRoar)
  end


  self.btnMatchDes = jj.ui.JJButton.new({
    images = {
      normal = self.theme_:getImage("common/common_btn_long_blue_n.png"),
      highlight = self.theme_:getImage("common/common_btn_long_blue_d.png"),
    },
    fontSize = self.dimens_:getDimens(26),
    color = display.COLOR_WHITE,
    text = "赛事详情",
    align = ui.TEXT_ALIGN_CENTER,
    valign = ui.TEXT_VALIGN_CENTER,
    viewSize = CCSize(btnWidth, bthHeight)
  })
  if allowRoar then
      self.btnMatchDes:setAnchorPoint(ccp(0, 0))
      self.btnMatchDes:setPosition(self.dimens_.cx + marginBtn / 2,
                         self.dimens_.bottom + self.dimens_:getDimens(30))
  else
      self.btnMatchDes:setAnchorPoint(ccp(0.5, 0))
      self.btnMatchDes:setPosition(self.dimens_.cx,
                         self.dimens_.bottom + self.dimens_:getDimens(30))
  end

  --self.btnMatchDes:setScale(self.dimens_.scale_)
  self.btnMatchDes:setOnClickListener(handler(self, self.onClick))
  self:addView(self.btnMatchDes)

  --local card = require("lordunion.util.card")
  --card:setOrginal(48)
  --JJLog.i("linxh", "card is " .. card:getCardImg())
end

function RoundWaitView:onExit()
    if self.scheduleHandler_ then
      scheduler.unscheduleGlobal(self.scheduleHandler_)
      self.scheduleHandler_ = nil
    end
end

function RoundWaitView:onEnter()
    if self.scheduleHandler_ then
        scheduler.unscheduleGlobal(self.scheduleHandler_)
        self.scheduleHandler_ = nil
    end
    self.scheduleHandler_ = scheduler.scheduleGlobal(function() self:updatePrompt() end, 5)
end

function RoundWaitView:updatePrompt()
  if self.prompt then
      self.prompt:setText(self.strPrompt[math.random(#self.strPrompt)])
  end
end

function RoundWaitView:onClick(target)
  if target == self.btnRoar then
      local RoarInterface = require("game.thirds.RoarInterface")
      RoarInterface:enteRoar(0)
  elseif target == self.btnMatchDes then
      self.viewController_:showMatchDesDlg(true)
  end
end

function RoundWaitView:getAnimImages()
  return {self.theme_:getImage("switchtogame/loading1.png"),
          self.theme_:getImage("switchtogame/loading2.png"),
          self.theme_:getImage("switchtogame/loading3.png"),
          self.theme_:getImage("switchtogame/loading4.png"),
          self.theme_:getImage("switchtogame/loading5.png"),
          self.theme_:getImage("switchtogame/loading6.png"),
          self.theme_:getImage("switchtogame/loading7.png"),
          self.theme_:getImage("switchtogame/loading8.png"),
          self.theme_:getImage("switchtogame/loading9.png"),
          self.theme_:getImage("switchtogame/loading10.png"),
        }
end

function RoundWaitView:getPrompts()
  return {
    [[如果您想赢小奖品，建议参加"5元充值卡比赛"]],
    [[建议用wifi或较稳定的网络参加比赛]],
    [[JJ为玩家朋友提供的丰厚奖品，全部免费报名哦]],
    [[左右滑动可以提起多张牌，记得去试试哦]],
    [[比赛中超时，会进入不出牌的托管状态]],
    [[如果您是新手玩家建议您体验"新手训练场"]],
    [[如果您喜欢我们的游戏，一定要分享给您其他的朋友哦]],
    [[锦标赛中点击赛况区域会显示当前比赛详情]],
  }
end

return RoundWaitView