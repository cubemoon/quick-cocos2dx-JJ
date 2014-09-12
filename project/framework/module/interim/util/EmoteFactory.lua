local EmoteFactory = class("EmoteFactory")

function EmoteFactory:ctor()
	display.addSpriteFramesWithFile("img/interim/emote/emote_1.plist",
                                     "img/interim/emote/emote_1.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_2.plist",
                                     "img/interim/emote/emote_2.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_3.plist",
                                     "img/interim/emote/emote_3.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_4.plist",
                                     "img/interim/emote/emote_4.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_5.plist",
                                     "img/interim/emote/emote_5.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_6.plist",
                                     "img/interim/emote/emote_6.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_7.plist",
                                     "img/interim/emote/emote_7.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_8.plist",
                                     "img/interim/emote/emote_8.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_9.plist",
                                     "img/interim/emote/emote_9.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_10.plist",
                                     "img/interim/emote/emote_10.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_11.plist",
                                     "img/interim/emote/emote_11.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_12.plist",
                                     "img/interim/emote/emote_12.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_13.plist",
                                     "img/interim/emote/emote_13.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_14.plist",
                                     "img/interim/emote/emote_14.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_15.plist",
                                     "img/interim/emote/emote_15.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_16.plist",
                                     "img/interim/emote/emote_16.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_17.plist",
                                     "img/interim/emote/emote_17.png")
    display.addSpriteFramesWithFile("img/interim/emote/emote_18.plist",
                                     "img/interim/emote/emote_18.png")
end

function EmoteFactory:createEmoteByID(id)

	if id == 1 then
        return self:createEmote_1()
    elseif id == 2 then
        return self:createEmote_2()
    elseif id == 3 then
        return self:createEmote_3()
    elseif id == 4 then
        return self:createEmote_4()
    elseif id == 5 then
        return self:createEmote_5()
    elseif id == 6 then
        return self:createEmote_6()
    elseif id == 7 then
        return self:createEmote_7()
    elseif id == 8 then
        return self:createEmote_8()
    elseif id == 9 then
        return self:createEmote_9()
    elseif id == 10 then
        return self:createEmote_10()
    elseif id == 11 then
        return self:createEmote_11()
    elseif id == 12 then
        return self:createEmote_12()
    elseif id == 13 then
        return self:createEmote_13()
    elseif id == 14 then
        return self:createEmote_14()
    elseif id == 15 then
        return self:createEmote_15()
    elseif id == 16 then
        return self:createEmote_16()
    elseif id == 17 then
        return self:createEmote_17()
    elseif id == 18 then
        return self:createEmote_18()
    end

    return nil
end

function EmoteFactory:createEmote_1()
    display.addSpriteFramesWithFile("img/interim/emote/emote_1.plist",
                                     "img/interim/emote/emote_1.png")
    local animation = display.getAnimationCache("emote_1")
    if animation == nil then
        local frames = display.newFrames("emote_1_%d.png", 1, 13)
        animation = display.newAnimation(frames, 1 / 13)
        display.setAnimationCache("emote_1", animation)
    end
    return animation
end

function EmoteFactory:createEmote_2()
    display.addSpriteFramesWithFile("img/interim/emote/emote_2.plist",
                                     "img/interim/emote/emote_2.png")
    local animation = display.getAnimationCache("emote_2")
    if animation == nil then
        local frames = display.newFrames("emote_2_%d.png", 1, 11)
        animation = display.newAnimation(frames, 1 / 11)
        display.setAnimationCache("emote_2", animation)
    end
    return animation
end

function EmoteFactory:createEmote_3()
    display.addSpriteFramesWithFile("img/interim/emote/emote_3.plist",
                                     "img/interim/emote/emote_3.png")
    local animation = display.getAnimationCache("emote_3")
    if animation == nil then
        local frames = display.newFrames("emote_3_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_3", animation)
    end
    return animation
end

function EmoteFactory:createEmote_4()
    display.addSpriteFramesWithFile("img/interim/emote/emote_4.plist",
                                     "img/interim/emote/emote_4.png")
    local animation = display.getAnimationCache("emote_4")
    if animation == nil then
        local frames = display.newFrames("emote_4_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_4", animation)
    end
    return animation
end

function EmoteFactory:createEmote_5()
    display.addSpriteFramesWithFile("img/interim/emote/emote_5.plist",
                                     "img/interim/emote/emote_5.png")
    local animation = display.getAnimationCache("emote_5")
    if animation == nil then
        local frames = display.newFrames("emote_5_%d.png", 1, 8)
        animation = display.newAnimation(frames, 1 / 8)
        display.setAnimationCache("emote_5", animation)
    end
    return animation
end

function EmoteFactory:createEmote_6()
    display.addSpriteFramesWithFile("img/interim/emote/emote_6.plist",
                                     "img/interim/emote/emote_6.png")
    local animation = display.getAnimationCache("emote_6")
    if animation == nil then
        local frames = display.newFrames("emote_6_%d.png", 1, 11)
        animation = display.newAnimation(frames, 1 / 11)
        display.setAnimationCache("emote_6", animation)
    end
    return animation
end

function EmoteFactory:createEmote_7()
    display.addSpriteFramesWithFile("img/interim/emote/emote_7.plist",
                                     "img/interim/emote/emote_7.png")
    local animation = display.getAnimationCache("emote_7")
    if animation == nil then
        local frames = display.newFrames("emote_7_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_7", animation)
    end
    return animation
end

function EmoteFactory:createEmote_8()
    display.addSpriteFramesWithFile("img/interim/emote/emote_8.plist",
                                     "img/interim/emote/emote_8.png")
    local animation = display.getAnimationCache("emote_8")
    if animation == nil then
        local frames = display.newFrames("emote_8_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_8", animation)
    end
    return animation
end

function EmoteFactory:createEmote_9()
    display.addSpriteFramesWithFile("img/interim/emote/emote_9.plist",
                                     "img/interim/emote/emote_9.png")
    local animation = display.getAnimationCache("emote_9")
    if animation == nil then
        local frames = display.newFrames("emote_9_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_9", animation)
    end
    return animation
end

function EmoteFactory:createEmote_10()
    display.addSpriteFramesWithFile("img/interim/emote/emote_10.plist",
                                     "img/interim/emote/emote_10.png")
    local animation = display.getAnimationCache("emote_10")
    if animation == nil then
        local frames = display.newFrames("emote_10_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_10", animation)
    end
    return animation
end

function EmoteFactory:createEmote_11()
    display.addSpriteFramesWithFile("img/interim/emote/emote_11.plist",
                                     "img/interim/emote/emote_11.png")
    local animation = display.getAnimationCache("emote_11")
    if animation == nil then
        local frames = display.newFrames("emote_11_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_11", animation)
    end
    return animation
end

function EmoteFactory:createEmote_12()
    display.addSpriteFramesWithFile("img/interim/emote/emote_12.plist",
                                     "img/interim/emote/emote_12.png")
    local animation = display.getAnimationCache("emote_12")
    if animation == nil then
        local frames = display.newFrames("emote_12_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_12", animation)
    end
    return animation
end

function EmoteFactory:createEmote_13()
    display.addSpriteFramesWithFile("img/interim/emote/emote_13.plist",
                                     "img/interim/emote/emote_13.png")
    local animation = display.getAnimationCache("emote_13")
    if animation == nil then
        local frames = display.newFrames("emote_13_%d.png", 1, 13)
        animation = display.newAnimation(frames, 1 / 13)
        display.setAnimationCache("emote_13", animation)
    end
    return animation
end

function EmoteFactory:createEmote_14()
    display.addSpriteFramesWithFile("img/interim/emote/emote_14.plist",
                                     "img/interim/emote/emote_14.png")
    local animation = display.getAnimationCache("emote_14")
    if animation == nil then
        local frames = display.newFrames("emote_14_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_14", animation)
    end
    return animation
end

function EmoteFactory:createEmote_15()
    display.addSpriteFramesWithFile("img/interim/emote/emote_15.plist",
                                     "img/interim/emote/emote_15.png")
    local animation = display.getAnimationCache("emote_15")
    if animation == nil then
        local frames = display.newFrames("emote_15_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_15", animation)
    end
    return animation
end

function EmoteFactory:createEmote_16()
    display.addSpriteFramesWithFile("img/interim/emote/emote_16.plist",
                                     "img/interim/emote/emote_16.png")
    local animation = display.getAnimationCache("emote_16")
    if animation == nil then
        local frames = display.newFrames("emote_16_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_16", animation)
    end
    return animation
end

function EmoteFactory:createEmote_17()
    display.addSpriteFramesWithFile("img/interim/emote/emote_17.plist",
                                     "img/interim/emote/emote_17.png")
    local animation = display.getAnimationCache("emote_17")
    if animation == nil then
        local frames = display.newFrames("emote_17_%d.png", 1, 12)
        animation = display.newAnimation(frames, 1 / 12)
        display.setAnimationCache("emote_17", animation)
    end
    return animation
end

function EmoteFactory:createEmote_18()
    display.addSpriteFramesWithFile("img/interim/emote/emote_18.plist",
                                     "img/interim/emote/emote_18.png")
    local animation = display.getAnimationCache("emote_18")
    if animation == nil then
        local frames = display.newFrames("emote_18_%d.png", 1, 19)
        animation = display.newAnimation(frames, 1 / 19)
        display.setAnimationCache("emote_18", animation)
    end
    return animation
end

return EmoteFactory