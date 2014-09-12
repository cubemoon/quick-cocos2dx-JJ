local DianShuScene = class("DianShuScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "DianShuScene"

function DianShuScene:initView()
	JJLog.i(TAG,"initView")
    DianShuScene.super.initView(self)

    self:setTitle(self.theme_:getImage("charge/charge_title_dianshu.png"))
    self:setBackBtn(true)

    local label = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(28),
        color = ccc3(255, 255, 255),
        text = "        游戏点数是中国移动为用户提供的一种游戏支付行为，用户可以使用账户中的点数来购买游戏或消费游戏道具。100点等同于1元人民币，点数余额不足时购买道具将会用话费自动充值补足点数。",
        singleLine = false,
        valign = ui.TEXT_VALIGN_TOP,
        viewSize = CCSize(self.dimens_.width - self.dimens_:getDimens(40), self.dimens_.height - self.dimens_:getDimens(150)),
    })
    label:setAnchorPoint(ccp(0.5, 1))
    label:setPosition(ccp(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(120)))
    self:addView(label)
end

return DianShuScene