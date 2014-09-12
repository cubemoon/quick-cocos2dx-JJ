--[[
    统一处理一些多界面公用的
]]

local UIUtil = {}
local TAG = "UIUtil"

--[[
    无网络的提示框
]]
function UIUtil.showNoNetworkDialog(scene, theme, dimens, dismissCB, btn1CB, btn2CB)
    JJLog.i(TAG, "showNoNetworkDialog")
    local dialog = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = "网络连接不上，请检查您的网络设置！",
        onDismissListener = dismissCB,
        theme = theme,
        dimens = dimens,
    })

    dialog:setButton1("网络设置", btn1CB)
    dialog:setCloseButton(btn2CB)
    dialog:setCanceledOnTouchOutside(true)

    dialog:show(scene)
    return dialog
end

--[[
    登录等待提示框
]]
function UIUtil.showLoginDialog(scene, theme, dimens, dismissCB)
    JJLog.i(TAG, "showLoginDialog")
    local dialog = require("game.ui.view.ProgressDialog").new(theme, dimens, {
        text = "正在登录，请稍候...",
        mask = false,
        onDismissListener = dismissCB
    })
    dialog:setCanceledOnTouchOutside(false)
    dialog:show(scene)
    return dialog
end

function UIUtil.dismissDialog(dialog)
    if dialog ~= nil then
        dialog:dismiss()
        dialog = nil
    end
end

-- 提示登录错误
function UIUtil.showLoginFailed(param, dimens)
    local prompt = {}
    prompt[1] = "未知失败原因！"
    prompt[2] = "客户端版本号异常！"
    prompt[3] = "服务器跳转！"
    prompt[4] = "用户名登录错误！"
    prompt[5] = "用户ID已经登录！"
    prompt[6] = "用户名密码错误！"
    prompt[8] = "系统维护，用户不能登录！"
    prompt[9] = "获取账户信息失败！"
    prompt[99] = "网络连接失败，请检查您的网络设置！"

    local txt = prompt[param]
    if txt == nil then
        txt = "未知失败原因！"
    end

    txt = txt .. "(" .. param .. ")"

    jj.ui.JJToast:show({ text = txt, dimens = dimens })
end

--[[
    提示等待框
    @prompt: 提示文字
    @scene: 依附的界面
    @theme
    @dimens
    @dismissCB: 消失的回调
    @canceloutside: 点击外部是否取消
    @mask: 是否有遮罩
]]
function UIUtil.showProgressDialog(params)
    local dialog = require("game.ui.view.ProgressDialog").new(params.theme, params.dimens, {
        text = params.prompt,
        mask = params.mask,
        onDismissListener = params.dismissCB
    })
    if params.canceloutside == nil then
        params.canceloutside = false
    end
    dialog:setCanceledOnTouchOutside(params.canceloutside)
    dialog:show(params.scene)
    return dialog
end

--[[
    退出提示
]]
function UIUtil.showExitAppDialog(params)
    local dialog = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = "您确认要退出吗？",
        onDismissListener = params.dismissCB,
        theme = params.theme,
        dimens = params.dimens,
        backKey = true,
    })

    dialog:setButton1("确认", function() MainController:exit() end)
    dialog:setCloseButton(params.dismissCB)
    dialog:setCanceledOnTouchOutside(true)

    dialog:show(params.scene)
    return dialog
end

--[[
    免注册登录注册引导
]]
function UIUtil.showGuideToBindNoRegDialog(params)
    local dialog = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = params.prompt,
        onDismissListener = params.dismissCB,
        theme = params.theme,
        dimens = params.dimens,
    })

    local bt1text = "以后再说"
    if (params.btn1Txt) then
        bt1text = params.btn1Txt
    end
    if (params.isExitFlag == true) then
        dialog:setButton1(bt1text, params.btn1CB)
    else
        dialog:setCloseButton(params.btn1CB)
    end
    dialog:setButton2("马上注册", params.btn2CB)
--    dialog:setCanceledOnTouchOutside(true)

    dialog:show(params.scene)
    return dialog
end

return UIUtil