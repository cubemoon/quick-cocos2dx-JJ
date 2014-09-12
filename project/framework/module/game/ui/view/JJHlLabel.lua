local JJHlLabel = class("JJHlLabel", require("sdk.ui.JJLabel"))

local TAG = "JJHlLabel"

function JJHlLabel:ctor(params, scene,fontcolor,fonthlcolor)
    JJHlLabel.super.ctor(self, params)
    self.scene_ = scene
    self:setTouchEnable(true)
    self:setOnClickListener(function() end)

    JJLog.i(TAG, "JJHlLabel()",fontcolor,fonthlcolor)
    if fontcolor then
        self.fontColor = fontcolor
    else
        self.fontColor = ccc3(255, 255, 255)
    end

    if fonthlcolor then
        self.fontHLColor = fonthlcolor
    else
        self.fontHLColor = ccc3(166, 199, 222)
    end
end

function JJHlLabel:onTouch(event, x, y)
    JJLog.i(TAG, "onTouch() event=" .. event)
    if self == nil then
        JJLog.i(TAG, "onTouch() self.title_ == nil")
        return false
    end
    if event == "began" then
        if self:isTouchInside(x, y) then
            self:setTouchedIn(true)
            self:setColor(self.fontHLColor)
            return true
        else
            self:setTouchedIn(false)
            self:setColor(self.fontColor)
            return false
        end
    elseif event == "moved" then
        if self:isTouchedIn() then
            if not self:isTouchInside(x,y) then
              self:setTouchedIn(false)
              self:setColor(self.fontColor)
            end
        end
    elseif event == "cancelled" then
        if self:isTouchedIn() == true then
            self:setTouchedIn(false)
            self:setColor(self.fontColor)
        end
    elseif event == "ended" then
        if self:isTouchedIn() then
            if self:isTouchInside(x, y) then
                self:setTouchedIn(false)
                self:setColor(self.fontColor)
                if jj.ui.isOnClickSoundMute() ~= true then
                    self.sound_ = jj.ui.getOnClickSound()
                    if self.sound_ ~= nil then
                        audio.playSound(self.sound_)
                    else
                        JJLog.i(TAG, "sound == nil")
                    end
                end
                JJLog.i(TAG, "the onClick up")
                self.onClickListener_(self)
            end
        end
    end
end

return JJHlLabel