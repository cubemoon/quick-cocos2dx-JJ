local JJViewGroup = require("sdk.ui.JJViewGroup")
local MenuView = class("MenuView", JJViewGroup)

function MenuView:ctor(parentView)
	MenuView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function MenuView:initView()
    
	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/menu.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)
	self.bgSize = CCSizeMake(background:getViewSize().width*self.dimens_.scale_, background:getViewSize().height*self.dimens_.scale_)
    self:setAnchorPoint(ccp(0.5, 0.5))


    self:setTouchEnable(true)

end

function MenuView:onTouchBegan(x, y)
	if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
		self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x,y))
        -- 因为美术就给提供了一张画上按钮的整图
        -- 没有单独按钮图
        -- 所以根据坐标来判断事件
        -- 1 补码
        -- 2 设置
        -- 3 托管
        -- 4 帮助
        -- 5 退出
        local event = self:checkYPosEvent(pos.y)
        if event == 1 then
            self.parentView:onMenuButtonClicked("Setting")
        elseif event == 2 then
            self.parentView:onMenuButtonClicked("Help")
        elseif event == 3 then
            self.parentView:onMenuButtonClicked("Quit")
        end
		return true
	end
	return false
end

function MenuView:checkYPosEvent(y)
    local spaceY = self.bgSize.height/3
    -- JJLog.i("spacey " .. spaceY)
    if y > spaceY * 0.5 and y < spaceY * 1.5 then
        return 1
    elseif y > spaceY * -0.5 and y < spaceY * 0.5 then
        return 2
    elseif y > spaceY * -1.5 and y < spaceY * -0.5 then
        return 3
    end
    return 0
end

function MenuView:refreshLayout()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
end

function MenuView:createButton(buttonText)
	local btn = jj.ui.JJButton.new({
        images = {
            normal = "img/interim/common/blue_button02.png",   
            highlight = "img/interim/common/yellow_button02.png",
       		scale9 = true
        },
        viewSize = CCSize(90, 50),
        fontSize = 28,
        color = ccc3(255, 255, 255),
        text = buttonText,
    })
    btn:setAnchorPoint(ccp(0.5, 0.5))
    return btn
end

return MenuView
