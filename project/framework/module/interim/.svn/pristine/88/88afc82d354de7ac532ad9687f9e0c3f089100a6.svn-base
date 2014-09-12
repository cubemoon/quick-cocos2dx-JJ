local JJViewGroup = require("sdk.ui.JJViewGroup")
local SettingView = class("SettingView", JJViewGroup)
local SwitchButton = require("interim.ui.view.SwitchButton")
local SoundManager = require("game.sound.SoundManager")

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function SettingView:ctor(parentView)
	SettingView.super.ctor(self, parentView)
	self.parentView = parentView
	self.dimens_ = parentView.dimens_
	self:initView()
end

function SettingView:initView()
	local background = jj.ui.JJImage.new({
		 image = "img/interim/ui/setting.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)
   
    self:setAnchorPoint(ccp(0.5, 0.5))

    self.bgSize = CCSizeMake(background:getViewSize().width*background:getScaleX(),
    background:getViewSize().height*background:getScaleY())
    
    local titleLabel = jj.ui.JJLabel.new({
    	fontSize = 30*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "设 置",
    })
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(0, self.dimens_:getDimens(75))
    self:addView(titleLabel)

    local label = jj.ui.JJLabel.new({
        fontSize = 30*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "音乐",
    })
    label:setAnchorPoint(ccp(0.5,0.5))
    label:setPosition(-self.dimens_:getDimens(160), 0)
    self:addView(label)

    label = jj.ui.JJLabel.new({
        fontSize = 30*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        text = "音效",
    })
    label:setAnchorPoint(ccp(0.5,0.5))
    label:setPosition(self.dimens_:getDimens(40), 0)
    self:addView(label)

    self.musicSwitch = SwitchButton.new()
    self:addView(self.musicSwitch)
    self.musicSwitch:setPosition(-self.dimens_:getDimens(70), 0)
    self.musicSwitch:setScale(self.dimens_.scale_)
    self.musicSwitch.delegate = self

    self.audioSwitch = SwitchButton.new()
    self:addView(self.audioSwitch)
    self.audioSwitch:setPosition(self.dimens_:getDimens(142), 0)
    self.audioSwitch:setScale(self.dimens_.scale_)
    self.audioSwitch.delegate = self

    self:setTouchEnable(true)
end

function SettingView:onEnter()
    self.super:onEnter()

    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    
    self.musicSwitch:setSwitchStatus(Settings:getSoundBg())
    self.audioSwitch:setSwitchStatus(Settings:getSoundEffect())
end

function SettingView:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
        -- JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 186*self.dimens_.scale_
         and pos.y > 63*self.dimens_.scale_ then
            self.parentView:hideSettingView()
            SoundManager:playEffect(INTERIM_SOUND.BUTTON)
        
        end
        return true
    end
    return false
end

function SettingView:onSwitchStatusChanged(switchButton, status)
    if switchButton == self.musicSwitch then
     --   JJLog.i("switchButton == self.musicSwitch")
        if status then
            Settings:setSoundBg(true)
            audio.playBackgroundMusic(INTERIM_SOUND.BGMUSIC, true)

        else        
            Settings:setSoundBg(false)
            audio.stopBackgroundMusic()

        end

    elseif switchButton == self.audioSwitch then
       -- JJLog.i("switchButton == self.audioSwitch")
        Settings:setSoundEffect(status)

    end
end

return SettingView
