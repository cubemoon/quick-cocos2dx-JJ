Settings = {}

local SOUND_VOLUME = "sound_volume" -- 游戏音量大小
local SOUND_BG = "sound_bg" -- 背景音
local SOUND_EFFECT = "sound_effect" -- 音效
local SOUND_VOICE = "sound_voice" -- 人声
local CONFIG_RECOM_MATCH_PROPMT = "recom_match_prompt" --推荐比赛提醒
local FIRST_USE = "first_use" -- 首次使用

local CONFIG_NO_REG_LOGIN_COUNT = "noreg_login_count" --免注册登录次数
local CONFIG_HALL_LOGIN_COUNT = "noreg_hall_login_count" --登录大厅次数
local CONFIG_NO_REG_LOGIN_GOLD_PROMPT = "noreg_login_gold_prompt" --免注册登录金币超过2000提示
local CONFIG_NO_REG_LOGIN_Charge_PROMPT = "noreg_login_charge_prompt" -- 免注册登录充值提示
local CONFIG_NO_REG_LOGIN_ExchangePrize_PROMPT = "noreg_login_exchangeprize_prompt" --免注册登录兑奖提示

local CONFIG_RANKING_SEND_FLOWER_GUIDE_COUNT = "ranking_sendflower_guide_times";--送花提示,次数
local CONFIG_RANKING_SEND_FLOWER_DATE = "ranking_sendflower_date";--送花提示，时间

-- 0.0f <= volume <= 1.0f
function Settings:setSoundVolume(volume)
	CCUserDefault:sharedUserDefault():setFloatForKey(SOUND_VOLUME, volume)
	CCUserDefault:sharedUserDefault():flush()
end

function Settings:getSoundVolume()
	return CCUserDefault:sharedUserDefault():getFloatForKey(SOUND_VOLUME, 0.5)
end

function Settings:setSoundBg(flag)
	CCUserDefault:sharedUserDefault():setBoolForKey(SOUND_BG, flag)
	CCUserDefault:sharedUserDefault():flush()
end

function Settings:getSoundBg()
	return CCUserDefault:sharedUserDefault():getBoolForKey(SOUND_BG, true)
end

function Settings:setSoundEffect(flag)
  CCUserDefault:sharedUserDefault():setBoolForKey(SOUND_EFFECT, flag)
  CCUserDefault:sharedUserDefault():flush()
  local bMute = false
  if flag ~= true then
	  bMute = true
  end

  jj.ui.setOnClickSoundMute(bMute)
end

function Settings:getSoundEffect()
  return CCUserDefault:sharedUserDefault():getBoolForKey(SOUND_EFFECT, true)
end

function Settings:setSoundVoice(flag)
  CCUserDefault:sharedUserDefault():setBoolForKey(SOUND_VOICE, flag)
  CCUserDefault:sharedUserDefault():flush()
end

function Settings:getSoundVoice()
	return CCUserDefault:sharedUserDefault():getBoolForKey(SOUND_VOICE, true)
end

function Settings:setRecomMatchPrompt(flag)
  CCUserDefault:sharedUserDefault():setBoolForKey(CONFIG_RECOM_MATCH_PROPMT, flag)
  CCUserDefault:sharedUserDefault():flush()
end

function Settings:getRecomMatchPrompt()
   return CCUserDefault:sharedUserDefault():getBoolForKey(CONFIG_RECOM_MATCH_PROPMT, true)
end

function Settings:setFirstUse(flag)
  CCUserDefault:sharedUserDefault():setBoolForKey(FIRST_USE, flag)
  CCUserDefault:sharedUserDefault():flush()
end

function Settings:getFirstUse()
   return CCUserDefault:sharedUserDefault():getBoolForKey(FIRST_USE, true)
end

function Settings:setNoRegLoginCount(count)
   CCUserDefault:sharedUserDefault():setIntegerForKey(CONFIG_NO_REG_LOGIN_COUNT, count)
   CCUserDefault:sharedUserDefault():flush()
end

function Settings:getNoRegLoginCount()
    return CCUserDefault:sharedUserDefault():getIntegerForKey(CONFIG_NO_REG_LOGIN_COUNT, 0)
end

function Settings:setHallLoginCount(count)
   CCUserDefault:sharedUserDefault():setIntegerForKey(CONFIG_HALL_LOGIN_COUNT, count)
   CCUserDefault:sharedUserDefault():flush()
end

function Settings:getHallLoginCount()
    return CCUserDefault:sharedUserDefault():getIntegerForKey(CONFIG_HALL_LOGIN_COUNT, 0)
end

function Settings:setNoRegGoldPrompt(prompt)
    CCUserDefault:sharedUserDefault():setBoolForKey(CONFIG_NO_REG_LOGIN_GOLD_PROMPT, prompt)
    CCUserDefault:sharedUserDefault():flush()
end

function Settings:getNoRegGoldPrompt()
    return CCUserDefault:sharedUserDefault():getBoolForKey(CONFIG_NO_REG_LOGIN_GOLD_PROMPT, false)
end

function Settings:setNoRegChargePrompt(prompt)
    CCUserDefault:sharedUserDefault():setBoolForKey(CONFIG_NO_REG_LOGIN_Charge_PROMPT, prompt)
    CCUserDefault:sharedUserDefault():flush()
end

function Settings:getNoRegChargePrompt()
    return CCUserDefault:sharedUserDefault():getBoolForKey(CONFIG_NO_REG_LOGIN_Charge_PROMPT, false)
end

function Settings:setNoRegExchangePrompt(prompt)
    CCUserDefault:sharedUserDefault():setBoolForKey(CONFIG_NO_REG_LOGIN_ExchangePrize_PROMPT, prompt)
    CCUserDefault:sharedUserDefault():flush()
end

function Settings:getNoRegExchangePrompt()
    return CCUserDefault:sharedUserDefault():getBoolForKey(CONFIG_NO_REG_LOGIN_ExchangePrize_PROMPT, false)
end

function Settings:setRankSendFlowerCounts(flag)
  CCUserDefault:sharedUserDefault():setIntegerForKey(CONFIG_RANKING_SEND_FLOWER_GUIDE_COUNT, flag)
  CCUserDefault:sharedUserDefault():flush()
end

function Settings:getRankSendFlowerCounts()
   return CCUserDefault:sharedUserDefault():getIntegerForKey(CONFIG_RANKING_SEND_FLOWER_GUIDE_COUNT, 0)
end

function Settings:setRankSendFlowerDate(flag)
  CCUserDefault:sharedUserDefault():setStringForKey(CONFIG_RANKING_SEND_FLOWER_DATE, flag)
  CCUserDefault:sharedUserDefault():flush()
end

function Settings:getRankSendFlowerDate()
   return CCUserDefault:sharedUserDefault():getStringForKey(CONFIG_RANKING_SEND_FLOWER_DATE, "2013-01-01")
end

return Settings
