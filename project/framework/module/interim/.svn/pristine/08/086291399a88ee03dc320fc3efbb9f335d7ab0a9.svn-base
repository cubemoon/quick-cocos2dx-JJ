
local JJViewGroup = require("sdk.ui.JJViewGroup")
local BackgroundView = class("BackgroundView", JJViewGroup)
local PoolView = require("interim.ui.view.PoolView")

function BackgroundView:ctor(parentScene)
	BackgroundView.super.ctor(self)
	self.positionConfig = parentScene.positionConfig
    self.parentScene = parentScene
    self.theme_ = parentScene.theme_
    self.dimens_ = parentScene.dimens_
	self:initView()
end

function BackgroundView:initView()
	self.backgroundView = jj.ui.JJImage.new({
        image = "img/interim/ui/background.jpg",
      })
    self.backgroundView:setAnchorPoint(ccp(0.5, 0.5))
    self.backgroundView:setPosition(self.dimens_.right/2,self.dimens_.top/2)
    self:addView(self.backgroundView)
    --self.backgroundView:setScale(self.dimens_.scale_)
    self.backgroundView:setScaleX(self.dimens_.wScale_)
    self.backgroundView:setScaleY(self.dimens_.hScale_)  

    self.webSiteImage = jj.ui.JJImage.new({
        image = "img/interim/ui/wwwjjcn.png",
      })
    self.webSiteImage:setAnchorPoint(ccp(0.5, 0.5))
    self.webSiteImage:setPosition(self.dimens_.right/1.2,self.dimens_.top/5)
    self:addView(self.webSiteImage)

    self.poolView = PoolView.new(self)
    self:addView(self.poolView)
    self.poolView:setPosition(self.positionConfig.chipPool)  
    
end

function BackgroundView:updateInitCardDisplay(gameData)
    self:setPoolCoin(gameData.tableCoin)
end

function BackgroundView:setPoolCoin(coin)
    self.poolView:setCoin(coin)
end

return BackgroundView
