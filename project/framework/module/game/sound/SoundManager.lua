SoundManager = {}
local audio = require("framework.audio")
require("game.settings.Settings")

--[[
    得到背景音量
]]
function SoundManager:getSoundBgVolume()
    return audio.getBackgroundMusicVolume()
end

function SoundManager:setSoundBgVolume(volume)
    audio.setBackgroundMusicVolume(volume)
end

--[[
    预加载背景音
    @filename：文件路径
]]
function SoundManager:preLoadBg(filename)
    self:setSoundBgVolume(Settings:getSoundVolume())
    audio.preloadBackgroundMusic(filename)
end

--[[
    预加载音效
    @files：文件路径列表
]]
function SoundManager:preLoadEffect(files)
    for i,v in pairs(files) do
        audio.preloadEffect(v)
    end
end

--[[
    取消加载音效
    @files: 文件路径列表
]]
function SoundManager:unloadEffect(files)
    for i,v in pairs(files) do
        audio.unloadSound(v)
    end    
end

--[[
    播放背景音
    @filename：文件路径
]]
function SoundManager:playBg(filename)
    if Settings:getSoundBg() and Util:isAppActive() then
        audio.playBackgroundMusic(filename, true)
    end
end

--[[
    停止播放背景音
    @filename：文件路径
]]
function SoundManager:stopBg()
    audio.stopBackgroundMusic(true)
end

function SoundManager:pauseBg()
    audio.pauseMusic()
end

function SoundManager:resumeBg()
    audio.resumeMusic()
end

--[[
    播放音效
    @filename：文件路径
]]
function SoundManager:playEffect(filename)
    if Settings:getSoundEffect() and Util:isAppActive() then
        audio.playEffect(filename, false)
    end
end

--[[
    播放人声
    @filename：文件路径
]]
function SoundManager:playVoice(filename)
    JJLog.i("SoundManager", "playVoice filename=",filename)
    if Settings:getSoundVoice() and Util:isAppActive() then
        audio.playEffect(filename, false)
    end
end

--[[
    背景音是否正在播放
]]
function SoundManager:isBGSoundPlaying()
    return audio.isMusicPlaying()
end


return SoundManager