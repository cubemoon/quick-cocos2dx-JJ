--[[比赛中view界面基类, 目前还没有特殊要处理，
主要是为了防止未来有些公共处理需要添加，要求所有比赛中用到的view都从这个view继承
]]
local JJViewGroup = require("sdk.ui.JJViewGroup")
local JJMatchView = class("JJMatchView", JJViewGroup)

function JJMatchView:ctor(viewController)    
    JJMatchView.super.ctor(self)        

    self.viewController_ = viewController
    self.theme_ = viewController.theme_
    self.dimens_ = viewController.dimens_
end

--[[替换到当前界面时调用]]
function JJMatchView:onEnter()    
  JJLog.i("linxh", "JJMatchView:onEnter")
end

function JJMatchView:onBackPressed()
end

--[[界面进入后台]]
function JJMatchView:onPause()   
  JJLog.i("linxh", "JJMatchView:onPause") 
end

--[[界面被移除或销毁]]
function JJMatchView:onExit()   
  JJLog.i("linxh", "JJMatchView:onExit") 
end

function JJMatchView:onHideView()    
  JJLog.i("linxh", "JJMatchView:onHideView")
end

function JJMatchView:onShowView()    
  JJLog.i("linxh", "JJMatchView:onShowView")
end

function JJMatchView:setVisible(flag)
    if not flag then 
        self:onHideView() 
        JJMatchView.super.setVisible(self, false)
    else
        JJMatchView.super.setVisible(self, true)
        self:onShowView()
    end
end

return JJMatchView