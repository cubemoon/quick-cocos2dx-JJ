--[[
比赛出现错误或者被服务器提出时，显示该界面
]]
local DialogConfirmWaitView = class("DialogConfirmWaitView", require("game.ui.view.JJMatchView"))

function DialogConfirmWaitView:ctor(viewController)
  DialogConfirmWaitView.super.ctor(self, viewController) 
  self:initView()
end

-- 初始化view内容
function DialogConfirmWaitView:initView()
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

  local lord = jj.ui.JJImage.new()
  lord:setPosition(self.dimens_.cx, self.dimens_.cy + self.dimens_:getDimens(120))
  lord:setScale(self.dimens_.scale_)
  self:addView(lord)
  lord:playAnimationForever(animation)

  local label = jj.ui.JJLabel.new({
    text = "正在为您智能选桌，敬请等待，精彩即刻上演...",
    fontSize = self.dimens_:getDimens(18),
    font = ui.DEFAULT_TTF_FONT,
    color = ccc3(12, 66, 112),--#FF0C4270
    singleLine = true,
  })
  label:setAnchorPoint(CCPoint(0.5, 0.5))
  label:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(10))
  self:addView(label)
end

function DialogConfirmWaitView:getAnimImages()
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

return DialogConfirmWaitView