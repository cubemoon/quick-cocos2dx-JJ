local ContactUsScene = class("ContactUsScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "ContactUsScene"


function ContactUsScene:initView()
    ContactUsScene.super.initView(self)

    self:setTitle(self.theme_:getImage("charge/charge_title_contact_us.png"))
    self:setBackBtn(true)

    local label = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(28),
        color = ccc3(255, 255, 255),
        text = "24小时服务热线：010-62981235 \n\n也可以通过咆哮提问区进行提问，我们会尽快解决您的问题！",
    })
    label:setAnchorPoint(ccp(0.5, 1))
    label:setPosition(ccp(self.dimens_.cx, self.dimens_.height - self.dimens_:getDimens(120)))
    self:addView(label)
end

return ContactUsScene
