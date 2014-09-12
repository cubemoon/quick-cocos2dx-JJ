local UpgradeCheckbox = class("UpgradeCheckbox", function ()
    return display.newNode()
end)

local TAG = "UpgradeCheckbox"

--[[
-- @params
--  common    未勾选时的图片
--  select    勾选时的图片
--]]
function UpgradeCheckbox:ctor(params)
    print(TAG, "ctor IN")
    self.commonSprite = display.newSprite(params.common)
    self:addChild(self.commonSprite)
    self.selectSprite = display.newSprite(params.select)
    self:addChild(self.selectSprite)

    self:setTouchEnabled(true)
    self:addTouchEventListener(handler(self, self.onTouch))

    self.checked_ = true
    self:setChecked(self.checked_)
end

function UpgradeCheckbox:onTouch(event, x, y, prevX, prevY)
    self.checked_ = not self.checked_
    self:setChecked(self.checked_)
    return false
end

function UpgradeCheckbox:setChecked(checked)
    if self.commonSprite and self.selectSprite then
        self.commonSprite:setVisible(not checked)
        self.selectSprite:setVisible(checked)
    end
end

function UpgradeCheckbox:isChecked()
    return self.checked_
end

return UpgradeCheckbox
