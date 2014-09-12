local WebViewScene = class("WebViewScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "WebViewScene"

function WebViewScene:ctor(controller)
    self.landScape_ = false
    WebViewScene.super.ctor(self, controller)
end

function WebViewScene:initView()
    WebViewScene.super.initView(self)

    self:setBg("img/hall/common/bg.jpg")

    if self.controller_.title_ ~= nil then
        self:setTitle(self.controller_.title_)
    elseif self.controller_.params_.title ~= nil then
        self:setTitle(self.controller_.params_.title)
    end
    if self.controller_.params_.back == true then
        self:setBackBtn(true, {
            normal = "img/hall/common/return_btn_n.png",
        })
    end

    if self.controller_.rightBtn_ == true then
        self:updateRightBtn(true)
    end
end

function WebViewScene:updateTitle(title)
    self:setTitle(title)
end

function WebViewScene:updateRightBtn(state)
    self:setRightBtn(state, {
                    normal="img/hall/common/right_btn_n.png"
                    , highlight="img/hall/common/right_btn_d.png"
                }, handler(self, self.callJSFuncByRightBtn))
end


function WebViewScene:callJSFuncByRightBtn()
    if self.controller_.menuIsShow_ == true then
        self.controller_.menuIsShow_ = false
    else
        self.controller_.menuIsShow_ = true
    end
    if device.platform == "android" then
        className = "cn/jj/base/JJActivity"
        methodName = "show_right_func_list"
        args = {}
        sig = "()V"
        luaj.callStaticMethod(className, methodName, args, sig)
    elseif device.platform == "ios" then

    end
end

return WebViewScene
