
local PlayScene = class("PokerSceneBase", require("game.ui.scene.JJGameSceneBase"))

function PlayScene:initView()
    PlayScene.super.initView(self)

    if self.controller_.scene_ ~= nil then 
        self.controller_:recover()
    end
end

function PlayScene:onDestory()
    self.controller_:destoryView()
    PlayScene.super.onDestory(self)    
end


return PlayScene
