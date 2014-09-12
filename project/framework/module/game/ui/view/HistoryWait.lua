-- 断线重连
--[[ 如果重载了该view必须实现以下方法
无
]]
local HistoryWait = class("HistoryWait", require("game.ui.view.JJMatchView"))

function HistoryWait:ctor(viewController)
	HistoryWait.super.ctor(self, viewController)
	
	local bg = jj.ui.JJImage.new({
	    image = self.theme_:getImage("common/bg_normal.jpg")
	  })
	  bg:setAnchorPoint(ccp(0.5, 0.5))
	  bg:setPosition(self.dimens_.cx, self.dimens_.cy)
	  bg:setScaleX(self.dimens_.wScale_)
	  bg:setScaleY(self.dimens_.hScale_)
	  self:addView(bg)

	
	local prompt = jj.ui.JJLabel.new({
		text = "正在恢复比赛，请等待...",
		fontSize = self.dimens_:getDimens(24),
		align = ui.TEXT_ALIGN_CENTER,
		valign = ui.TEXT_VALIGN_CENTER,
		color = ccc3(255, 255, 255),
		viewSize = CCSize(0, self.dimens_:getDimens(60))
		})
	prompt:setAnchorPoint(CCPoint(0.5, 0.5))
	prompt:setPosition(self.dimens_.cx,self.dimens_.cy)
	self:addView(prompt)
end

return HistoryWait