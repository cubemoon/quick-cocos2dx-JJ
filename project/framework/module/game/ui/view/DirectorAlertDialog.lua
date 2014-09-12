--[[
    不依附于 Scene 的提示框，直接加载在 Director 上
]]
local DirectorAlertDialog = class("DirectorAlertDialog")
local TAG = "DirectorAlertDialog"

DirectorAlertDialog.rootView_ = nil
DirectorAlertDialog.dialog_ = nil

--[[
    初始化
]]
local function _init(self)
    if self.rootView_ == nil then
        self.rootView_ = jj.ui.JJRootView.new({
            displayType = "director",
            display = CCDirector:sharedDirector()
        })
    end
end

--[[
    显示
    @theme
    @dimens
    @title: 标题
    @prompt: 提示的内容
    @btn1:
        @text:
        @cb:
    @btn2
]]
function DirectorAlertDialog:show(params)
    _init(self)

    self.dialog_ = require("game.ui.view.AlertDialog").new({
        title = params.title,
        prompt = params.prompt,
        theme =  params.theme,
        dimens = params.dimens,
        onDismissListener = params.onDismissListener,
    })

    if params.btn1 ~= nil then
        self.dialog_:setButton1(params.btn1.text, function()
            params.btn1.cb()
        end)
    end
    if params.btn2 ~= nil then
        self.dialog_:setButton2(params.btn2.text, function()
            params.btn2.cb()
        end)
    end

    self.dialog_:setCanceledOnTouchOutside(false)
    self.dialog_:show(self.rootView_)
end

function DirectorAlertDialog:dismiss()
    self.dialog_:dismiss()
end

function DirectorAlertDialog:setPrompt(prompt)
    self.dialog_:setPrompt(prompt)
end

return DirectorAlertDialog