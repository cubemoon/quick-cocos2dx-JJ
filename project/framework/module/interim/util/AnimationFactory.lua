local AnimationFactory = class("AnimationFactory")

function AnimationFactory:ctor()
	display.addSpriteFramesWithFile("img/interim/animate/fall_leaves.plist",
                                     "img/interim/animate/fall_leaves.png")
    display.addSpriteFramesWithFile("img/interim/animate/hit.plist",
                                     "img/interim/animate/hit.png")
    display.addSpriteFramesWithFile("img/interim/animate/hit_pillar.plist",
                                     "img/interim/animate/hit_pillar.png")
    display.addSpriteFramesWithFile("img/interim/animate/kabz.plist",
                                     "img/interim/animate/kabz.png")
    display.addSpriteFramesWithFile("img/interim/animate/kadang.plist",
                                     "img/interim/animate/kadang.png")
    display.addSpriteFramesWithFile("img/interim/animate/lottery_light.plist",
                                     "img/interim/animate/lottery_light.png")
    display.addSpriteFramesWithFile("img/interim/animate/fold.plist",
                                     "img/interim/animate/fold.png")
    display.addSpriteFramesWithFile("img/interim/animate/FourSame0.plist",
                                     "img/interim/animate/FourSame0.png")
    display.addSpriteFramesWithFile("img/interim/animate/KainSameStraight0.plist",
                                     "img/interim/animate/KainSameStraight0.png")
    display.addSpriteFramesWithFile("img/interim/animate/sameStraightAnim0.plist",
                                     "img/interim/animate/sameStraightAnim0.png")
    display.addSpriteFramesWithFile("img/interim/animate/GXZDJ0.plist",
                                     "img/interim/animate/GXZDJ0.png")
    display.addSpriteFramesWithFile("img/interim/animate/SmallAnim0.plist",
                                     "img/interim/animate/SmallAnim0.png")
    
    
end

function AnimationFactory:createFallLeaves()
	display.addSpriteFramesWithFile("img/interim/animate/fall_leaves.plist",
                                     "img/interim/animate/fall_leaves.png")
    local animation = display.getAnimationCache("fall")
    if animation == nil then
        local frames = display.newFrames("fall_%d.png", 1, 27)
        animation = display.newAnimation(frames, 1 / 27)
        display.setAnimationCache("fall", animation)
    end
    return animation
end

function AnimationFactory:createHit()
	local animation = display.getAnimationCache("hit")
    if animation == nil then
        local frames = display.newFrames("hit_%d.png", 1, 9)
        animation = display.newAnimation(frames, 0.6 / 9)
        display.setAnimationCache("hit", animation)
    end
    return animation
end

function AnimationFactory:createFivesamestraight()
    local animation = display.getAnimationCache("sameStraightAnim")
    if animation == nil then
        local frames = display.newFrames("THS_%d.png", 1, 14)
        animation = display.newAnimation(frames, 1.5 / 14)
        display.setAnimationCache("sameStraightAnim", animation)
    end
    return animation
end

function AnimationFactory:createKainSametraight()
    local animation = display.getAnimationCache("KainSameStraight")
    if animation == nil then
        local frames = display.newFrames("BG_%d.png", 1, 12)
        animation = display.newAnimation(frames, 0.6 / 12)
        display.setAnimationCache("KainSameStraight", animation)
    end
    return animation
end

function AnimationFactory:createFourSame()
    local animation = display.getAnimationCache("FourSame")
    if animation == nil then
        local frames = display.newFrames("4T_%d.png", 1, 14)
        animation = display.newAnimation(frames, 1 / 14)
        display.setAnimationCache("FourSame", animation)
    end
    return animation
end

function AnimationFactory:createCourageAnim()
    local animation = display.getAnimationCache("GXZDJ")
    if animation == nil then
        local frames = display.newFrames("GXZDJ_0000%d.png", 1, 9)
        animation = display.newAnimation(frames, 2 / 9)
        display.setAnimationCache("GXZDJ", animation)
    end
    return animation
end

function AnimationFactory:createSmallPrizeAnim()
    local animation = display.getAnimationCache("SmallPrize")
    if animation == nil then
        local frames = display.newFrames("YZXJZWYC_0000%d.png", 1, 3)
        animation = display.newAnimation(frames, 1 / 3)
        display.setAnimationCache("SmallPrize", animation)
    end
    return animation
end

function AnimationFactory:createComeOnAnim()
    local animation = display.getAnimationCache("ComeOn")
    if animation == nil then
        local frames = display.newFrames("JYZWYZ_0000%d.png", 1, 3)
        animation = display.newAnimation(frames, 1 / 3)
        display.setAnimationCache("ComeOn", animation)
    end
    return animation
end


function AnimationFactory:createHitPillar()
	local animation = display.getAnimationCache("hit_p")
    if animation == nil then
        local frames = display.newFrames("hit_p_%d.png", 1, 9)
        animation = display.newAnimation(frames, 0.6 / 9)
        display.setAnimationCache("hit_p", animation)
    end
    return animation
end

function AnimationFactory:createKabz()
	local animation = display.getAnimationCache("kabz")
    if animation == nil then
        local frames = display.newFrames("kabz_%d.png", 1, 21)
        animation = display.newAnimation(frames, 1 / 27)
        display.setAnimationCache("kabz", animation)
    end
    return animation
end

function AnimationFactory:createKadang()
	local animation = display.getAnimationCache("kadang")
    if animation == nil then
        local frames = display.newFrames("kadang_%d.png", 1, 27)
        animation = display.newAnimation(frames, 1 / 27)
        display.setAnimationCache("kadang", animation)
    end
    return animation
end

function AnimationFactory:createLotteryLight()
	local animation = display.getAnimationCache("ligtht")
    if animation == nil then
        local frames = display.newFrames("ligtht_%d.png", 1, 2)
        animation = display.newAnimation(frames, 1)
        display.setAnimationCache("ligtht", animation)
    end
    return animation
end

function AnimationFactory:createFold()
    local animation = display.getAnimationCache("fold")
    if animation == nil then
        local frames = display.newFrames("fold_%d.png", 1, 11)
        animation = display.newAnimation(frames, 0.6/11)
        display.setAnimationCache("fold", animation)
    end
    return animation
end

function AnimationFactory:createGreenFrame()
    local animation = display.getAnimationCache("green")
    local imageFile = "img/interim/animate/green_fr/green_fr_"
    local ext = ".png"
    if animation == nil then
        local array = CCArray:create()
        for i = 1, 25 do
            local fullPath = imageFile .. i .. ext
            local frame = CCSpriteFrame:create(fullPath, CCRect(0, 0, 194, 223))
            array:addObject(frame)
        end
        animation = CCAnimation:createWithSpriteFrames(array, 0.064)
        display.setAnimationCache("green", animation)
    end
    return animation
end

function AnimationFactory:createRedFrame()
    local animation = display.getAnimationCache("red")
    local imageFile = "img/interim/animate/red_fr/red_fr_"
    local ext = ".png"
    if animation == nil then
        local array = CCArray:create()
        for i = 1, 25 do
            local fullPath = imageFile .. i .. ext
            local frame = CCSpriteFrame:create(fullPath, CCRect(0, 0, 194, 223))
            array:addObject(frame)
        end
        animation = CCAnimation:createWithSpriteFrames(array, 0.064)
        display.setAnimationCache("red", animation)
    end
    return animation
end

return AnimationFactory