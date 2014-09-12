local SettingsSceneController = class("SettingsSceneController", require("game.ui.controller.JJGameSceneController"))
local config_ = require("game.settings.Settings")
local WebViewController = require("game.ui.controller.WebViewController")
require("game.sound.SoundManager")

--[[
	参数
	@params:
		@packageId
		@voiceEnable 是否显示 "游戏人声"选项，true和不传默认为显示，false为不显示
]]
function SettingsSceneController:ctor(controllerName, sceneName, theme, dimens, ...)
	SettingsSceneController.super.ctor(self, controllerName, sceneName, theme, dimens, ...)
    self:setResumeRedraw(false)
end

-- 切换帐号
function SettingsSceneController:onClickSwitchAccount()
	MainController:pushScene(self.params_.packageId, JJSceneDef.ID_JJ_LOGIN)
end

-- 关于
function SettingsSceneController:onClickAbout()
	MainController:pushScene(self.params_.packageId, JJSceneDef.ID_ABOUT)
end

-- 更多游戏
function SettingsSceneController:onClickMoreGame()
	MainController:pushScene(self.params_.packageId, JJSceneDef.ID_MORE_GAME)
end

local function getCurrentGameHelpUrl(packageid)
	local url = ""
	if device.platform == "android" then
    	local dirname = JJGameDefine:getGameDirName(packageid)
		url = "file:///android_asset/module/" .. dirname .. "/res/help/index.html"
		local filepath = device.writablePath .. "update/module/" .. dirname .. "/res/help/index.html"

		if JJFileUtil:exist(filepath) then
			url = "file://" .. filepath
		end
		JJLog.i("getCurrentGameHelpUrl data exist url=", url)
	elseif device.platform == "ios" then
		url = "file://"..CCFileUtils:sharedFileUtils():fullPathForFilename("help/index.html")
	end

	return url
end

-- 帮助
function SettingsSceneController:onClickHelp()
	-- MainController:pushScene(self.params_.packageId, JJSceneDef.ID_GAME_HELP)
	local url = getCurrentGameHelpUrl(self.params_.packageId)
	WebViewController:showActivity({
                title = "游戏帮助",
                back = true,
                sso = false,
                url = url,
                urlNoParam = true
            })
end

-- 背景音量
function SettingsSceneController:getSoundVolume()
	local volume = config_:getSoundVolume()
	if volume == -1 then
		volume = SoundManager:getSoundBgVolume()
	end
	JJLog.i("SettingsSceneController", "volume=", volume)
	return volume
end

function SettingsSceneController:setSoundVolume(volume)
	SoundManager:setSoundBgVolume(volume)
	config_:setSoundVolume(volume)
	JJLog.i("SettingsSceneController", "volume=", volume)
end

--声音开关
function SettingsSceneController:setAllSound(flag)
	config_:setSoundBg(flag)
	config_:setSoundEffect(flag)
	config_:setSoundVoice(flag)
end

function SettingsSceneController:getSound()
	return config_:getSound()
end

--背景音乐
function SettingsSceneController:setSoundBg(flag)
	config_:setSoundBg(flag)
end

function SettingsSceneController:getSoundBg()
	return config_:getSoundBg()
end

--游戏音效
function SettingsSceneController:setSoundEffect(flag)
	config_:setSoundEffect(flag)
end

function SettingsSceneController:getSoundEffect()
	return config_:getSoundEffect()
end

--游戏人声
function SettingsSceneController:setSoundVoice(flag)
	config_:setSoundVoice(flag)
end

function SettingsSceneController:getSoundVoice()
	return config_:getSoundVoice()
end

--推荐比赛
function SettingsSceneController:setRecomMatchPrompt(flag)
	config_:setRecomMatchPrompt(flag)
end

function SettingsSceneController:getRecomMatchPrompt()
	return config_:getRecomMatchPrompt()
end

-- 分享
local shareInterface = require("game.thirds.ShareInterface")
function SettingsSceneController:onClickShare()
  local description = "JJ斗地主，高手过招，精彩无限，快乐不断。最专业的平台，最丰富的奖品，百元话费、彩电、手机发不停！#JJ比赛http://www.jj.cn"
  if (MainController.packageId_ == JJGameDefine.GAME_ID_HALL) then
      description = "JJ比赛，汇集斗地主、德州扑克、麻将等多款棋牌游戏及精品单机游戏，最专业的平台，最丰富的大奖，最完善的账号体系！#JJ比赛http://www.jj.cn"
  elseif (MainController.packageId_ == JJGameDefine.GAME_ID_LORD_UNION) then
      description = "JJ斗地主，高手过招，精彩无限，快乐不断。最专业的平台，最丰富的奖品，百元话费、彩电、手机发不停！#JJ比赛http://www.jj.cn"
  elseif MainController:getCurPackageId() == JJGameDefine.GAME_ID_LORD_UNION_HL then
      description = "JJ欢乐斗地主，高手过招，精彩无限，快乐不断。最专业的平台，最丰富的奖品，百元话费、彩电、手机发不停！#JJ比赛http://www.jj.cn"
  elseif (MainController.packageId_ == JJGameDefine.GAME_ID_MAHJONG) or (MainController.packageId_ == JJGameDefine.GAME_ID_MAHJONG_TP)then
      description = "JJ麻将，国粹经典再现，不再三缺一。最专业的棋牌竞品平台，各种奖品随时赢不停！#JJ比赛http://www.jj.cn"
  end
  shareInterface:startShowShare(description, nil, 3)
end

function SettingsSceneController:showToast(txt)
    jj.ui.JJToast:show({ text = txt, dimens = self.dimens_ })
end

--意见反馈
function SettingsSceneController:onClickFeedback()
	MainController:pushScene(self.params_.packageId, JJSceneDef.ID_FEEDBACK)
end

return SettingsSceneController