--[[
    弹出框的基类，截取所有的触屏消息
]]
local UpgradeDialogBase = class("UpgradeDialogBase", function ()
    return display.newNode()
end)

local TAG = "UpgradeDialogBase"

UpgradeDialogBase.ID_CLOSE = 1 -- 关闭
UpgradeDialogBase.ID_YES = 2 -- 确认
UpgradeDialogBase.ID_NO = 3 -- 否认

--[[
    params
    @mask: 是否有遮罩
    @cancelOutSide: 是否点击外部消失，设置为 true 需要重载 checkTouchIn 函数
]]
function UpgradeDialogBase:ctor(params)

    local noResponseLayer = display.newLayer()
    self:addChild(noResponseLayer)

    local function onTouchNoRespondLayer(event,x,y)
        if(event=="began") then
            if params ~= nil and params.cancelOutSide == true and self.checkTouchIn ~= nil then
                if not self:checkTouchIn(x, y) then
                    self:removeSelf(true)
                end
            end
            return true
        end
    end
    --noResponseLayer:registerScriptTouchHandler(onTouchNoRespondLayer, false, -128, true)
    noResponseLayer:addTouchEventListener(onTouchNoRespondLayer)
    noResponseLayer:setTouchEnabled(true)

    -- 遮罩
    if params ~= nil and params.mask == true then
        local mask = display.newColorLayer(ccc4(0, 0, 0, 100))
        self:addChild(mask)
    end
end

--[[
    设置回调
    @listener: 参数为按钮的编号 id
]]
function UpgradeDialogBase:setListener(listener)
    self.listener_ = listener
end

--[[
    点击按钮
    @id: 按钮的定义
]]
function UpgradeDialogBase:onClick(id)
    if self.listener_ ~= nil then
        self.listener_(id)
    end
    self:removeSelf(true)
end

return UpgradeDialogBase
