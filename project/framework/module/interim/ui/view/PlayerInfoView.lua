local JJViewGroup = require("sdk.ui.JJViewGroup")
local PlayerInfoView = class("PlayerInfoView", JJViewGroup)

function PlayerInfoView:ctor(parentView)
	PlayerInfoView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
    self.theme_  = parentView.theme_ 
	self:initView()
end

function PlayerInfoView:initView()
	
    function onButtonClicked(sender)
        self.parentView:showMatchDetail()
    end

    local background = jj.ui.JJImage.new({
        image = "img/interim/ui/userInfoBg.png"
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)
     
    self.bgSize = CCSizeMake(background:getViewSize().width*self.dimens_.scale_, background:getViewSize().height*self.dimens_.scale_)
    self:setAnchorPoint(ccp(0.5, 0.5))
   -- self:setViewSize(self.bgSize.width, self.bgSize.height)

    local viewSize = self.bgSize
    self.nameLabel = jj.ui.JJLabel.new({
    	fontSize = 20*self.dimens_.scale_,
        color = ccc3(255, 255, 255),
        text = "动物名称",
    })
    self.nameLabel:setAnchorPoint(ccp(0,0.5))
    self.nameLabel.name = "name"
    self.nameLabel:setPosition(self.dimens_:getDimens(-83), self.dimens_:getDimens(30))
    self:addView(self.nameLabel)

    --等级
    self.userlevel = require("interim.ui.view.InterimUserLavel").new({exp=30, 
                                                            levelColor=ccc3(136, 251, 201),
                                                            dimens=self.dimens_, theme=self.theme_})
    self.userlevel:setAnchorPoint(CCPoint(0, 1))
    self.userlevel:setPosition(self.dimens_:getDimens(-100), self.dimens_:getDimens(-20))
    self:addView(self.userlevel)
    --self.userlevel:setUserLevel(10)

    self:setTouchEnable(true)
end

function PlayerInfoView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        return true
    end
    return false
end

function PlayerInfoView:setPlayerInfo(playerInfo)
    if playerInfo == nil then
        return 
    end
    self.nameLabel:setText(playerInfo.tkInfo.nickname)

    self.userlevel:setUserLevel(playerInfo.tkInfo.matchrank)
    
end

function PlayerInfoView:show(playerInfo)
    self:setPlayerInfo(playerInfo)
    self:setVisible(true)

end

return PlayerInfoView
