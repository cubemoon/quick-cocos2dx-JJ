-- 报名等待界面
local JJViewGroup = require("sdk.ui.JJViewGroup")
local InterimRoundWaitView = class("InterimRoundWaitView", JJViewGroup)
--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local strPrompt = {
    "如果您想赢小奖品，建议参加\"5元充值卡比赛\"",
    "建议用wifi或较稳定的网络参加比赛",
    "JJ为玩家朋友提供的丰厚奖品，全部免费报名哦",
    "观察对手的打牌方式，会很有帮助",
    "比赛中超时，会进入不出牌的托管状态",
    "如果您是新手玩家建议您体验\"新手免费锦标赛\"",
    "如果您喜欢我们的游戏，一定要分享给您其他的朋友哦",
    "在报名时点击比赛信息会显示当前比赛详情"
  }

function InterimRoundWaitView:ctor(viewController)
  InterimRoundWaitView.super.ctor(self)
  self.viewController_ = viewController
  self.dimens_ = viewController.dimens_ 
  self:initView()
  self.count = 1
  self.scheduler_ = self:schedule(function() self:updateAnimation() end, 0.3)
  JJLog.i("*****************InterimRoundWaitView:ctor")
end

-- 初始化view内容
function InterimRoundWaitView:initView()

  local bg = jj.ui.JJImage.new({
    image = "img/interim/loading/loading_bg.png"
  })
  bg:setAnchorPoint(ccp(0.5, 0.5))
  bg:setPosition(self.dimens_.cx, self.dimens_.cy)
  bg:setScaleX(self.dimens_.wScale_)
  bg:setScaleY(self.dimens_.hScale_)
  self:addView(bg)

  local logo = jj.ui.JJImage.new({
    image = "img/interim/loading/loading_logo.png"
  })
  logo:setAnchorPoint(ccp(0.5, 0.5))
  logo:setPosition(self.dimens_.cx-self.dimens_:getDimens(17), self.dimens_.cy+self.dimens_:getDimens(50))
  logo:setScaleX(self.dimens_.wScale_)
  logo:setScaleY(self.dimens_.hScale_)
  self:addView(logo)

  self.pokerIconSmall = {}
  for i=1,6 do
      local l = i
      if l >= 5 then
         l = l - 4
      end
      self.pokerIconSmall[i] = jj.ui.JJImage.new({
          image = string.format("img/interim/loading/loading_%d_big.png",l),
      })
      self.pokerIconSmall[i]:setAnchorPoint(ccp(0.5, 0.5))
      self.pokerIconSmall[i]:setPosition(self.dimens_.cx-self.dimens_:getDimens(155)+i*self.dimens_:getDimens(42), self.dimens_:getDimens(95))
      self.pokerIconSmall[i]:setScale(self.dimens_.scale_*0.7)
      self:addView(self.pokerIconSmall[i])
  end

  self.pokerIconBig = {}
  for i=1,6 do
      local l = i
      if l >= 5 then
         l = l - 4
      end
      self.pokerIconBig[i] = jj.ui.JJImage.new({
          image = string.format("img/interim/loading/loading_%d_big.png",l),
      })
      self.pokerIconBig[i]:setAnchorPoint(ccp(0.5, 0.5))
      self.pokerIconBig[i]:setPosition(self.dimens_.cx-self.dimens_:getDimens(155)+i*self.dimens_:getDimens(42), self.dimens_:getDimens(95))
      self.pokerIconBig[i]:setScale(self.dimens_.scale_)
      self:addView(self.pokerIconBig[i])
      self.pokerIconBig[i]:setVisible(false)
  end

  local loadingLabel = jj.ui.JJLabel.new({
        text = "Loading...",
        singleLine = true,
        fontSize = 18,
        color = ccc3(236,182,106),
        viewSize = CCSize(120,25),
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_ALIGN_CENTER, 
  })
  loadingLabel:setAnchorPoint(ccp(0.5,0.5))
  loadingLabel:setPosition(self.dimens_.cx,self.dimens_:getDimens(55))
  loadingLabel:setScale(self.dimens_.scale_)
  self:addView(loadingLabel)

  local tipBg = jj.ui.JJImage.new({
    image = "img/interim/loading/loading_tip.png"
  })
  tipBg:setAnchorPoint(ccp(0.5, 0))
  tipBg:setPosition(self.dimens_.cx, 0)
  tipBg:setScale(self.dimens_.scale_)
  self:addView(tipBg)

  self.tipLabel = jj.ui.JJLabel.new({
        text = "如果您想赢小奖品，建议参加5元充值卡比赛",
        singleLine = true,
        fontSize = 18,
        color = ccc3(236,182,106),
        viewSize = CCSize(854,25),
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_ALIGN_CENTER, 
  })
  self.tipLabel:setAnchorPoint(ccp(0.5,0))
  self.tipLabel:setPosition(self.dimens_.cx,self.dimens_:getDimens(3))
  self.tipLabel:setScale(self.dimens_.scale_)
  self:addView(self.tipLabel)
end

function InterimRoundWaitView:updateTipLabel()
     local index = math.random(1,#strPrompt)
     if self.currentLabeIdx then
        if self.currentLabeIdx == index then
           index = index + 1
           if index > #strPrompt then
              index = 1
           end
        end
     end
     self.currentLabeIdx = index
     self.tipLabel:setText(strPrompt[index])
end

function InterimRoundWaitView:hideAllPokerIconBig()
    for i=1,6 do
        self.pokerIconBig[i]:setVisible(false)
    end
end

function InterimRoundWaitView:updateAnimation()
   self.count = self.count + 1
   if self.count > 6 then
      self.count = 1
   end

   if self.count%6 == 0 then
      self:updateTipLabel()
   end

   self:hideAllPokerIconBig()
   self.pokerIconBig[self.count]:setVisible(true)
end

function InterimRoundWaitView:stopAnimation()
    if self.scheduler_ then
        self:unschedule(self.scheduler_)
        self.scheduler_ = nil
    end
end

function InterimRoundWaitView:onExit()
    self:stopAnimation()
end

return InterimRoundWaitView