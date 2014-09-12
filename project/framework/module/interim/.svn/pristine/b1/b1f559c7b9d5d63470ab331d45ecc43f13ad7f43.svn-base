local InterimUserLevel = class("InterimUserLevel", require("sdk.ui.JJViewGroup"))


function InterimUserLevel:ctor(params)
    InterimUserLevel.super.ctor(self)
    self.params = params
    self.dimens_ = params.dimens
    self:initView()
    self:setUserLevel(params.exp)
end

function InterimUserLevel:initView()
    self.levelnum = {
        self.params.theme:getImage("common/common_level1.png"),
        self.params.theme:getImage("common/common_level2.png"),
        self.params.theme:getImage("common/common_level3.png"),
        self.params.theme:getImage("common/common_level4.png"),
        self.params.theme:getImage("common/common_level5.png"),
        self.params.theme:getImage("common/common_level6.png"),
        self.params.theme:getImage("common/common_level7.png"),
    }

    local levelLabelWidth = self.params.dimens:getDimens(50)
    local imgWidth = self.params.dimens:getDimens(15)
    -- 等级
    self.levelTip = jj.ui.JJLabel.new({
        fontSize = self.params.dimens:getDimens(16),
        color = ccc3(255, 255, 255),
        singleLine = true,
    })
    self.levelTip:setText("等级: ")
    self.levelTip:setAnchorPoint(CCPoint(0, 1))
    self.levelTip:setPosition( self.dimens_:getDimens(20), self.dimens_:getDimens(30))
    self:addView(self.levelTip)

    self.level = jj.ui.JJLabel.new({
        fontSize = self.params.dimens:getDimens(16),
        color = self.params.levelColor,
        singleLine = true,
    })
    --self.level:setText(self.params.exp)
    self.level:setAnchorPoint(CCPoint(0, 1))
    self.level:setPosition( self.dimens_:getDimens(20)+self.levelTip:getWidth(), self.dimens_:getDimens(30))
    self:addView(self.level)
    -- 等级图片
    self.lvImg = {}
    for count=1, 5 do
        local bg = jj.ui.JJImage.new()
        self.lvImg[count] = bg
        bg:setAnchorPoint(ccp(0, 1))
        bg:setPosition(self.dimens_:getDimens(20*count), self.dimens_:getDimens(0))
        bg:setVisible(false)
        bg:setScale(self.params.dimens.scale_)
        self:addView(bg)
    end

end

function InterimUserLevel:setLevelData(levelnum,levelImageCount,levlel)

    JJLog.i("linxh", "levelImageCount levlel",levelnum,levelImageCount,levlel)
    -- 等级
    self.level:setText("LV"..levlel)
    
    --隐藏等级图片
    self:restLevelImg()   
    -- 等级图片
    for index=1,levelImageCount do
        if self.lvImg[index] then 
            self.lvImg[index]:setImage(levelnum)
            --self.lvImg[index]:setScale(1.2)
            self.lvImg[index]:setVisible(true) 
        end
    end
end

function InterimUserLevel:restLevelImg()

    for count=1, 5 do
         self.lvImg[count]:setVisible(false) 
    end
end

function InterimUserLevel:setUserLevel(matchRank)
    JJLog.i("setUserLevel********************matchRank" .. matchRank)
    if (matchRank <= 900) then
        self:setLevelData(self.levelnum[1], 1, 1)
    elseif (matchRank > 900 and matchRank <= 2200) then
        self:setLevelData(self.levelnum[1], 2, 2)
    elseif (matchRank > 2200 and matchRank <= 4000) then
        self:setLevelData(self.levelnum[1], 3, 3)
    elseif (matchRank > 4000 and matchRank <= 6500) then
        self:setLevelData(self.levelnum[1], 4, 4)
    elseif (matchRank > 6500 and matchRank <= 10000) then
        self:setLevelData(self.levelnum[1], 5, 5)

    elseif (matchRank > 10000 and matchRank <= 14000) then
        self:setLevelData(self.levelnum[2], 1, 6)
    elseif (matchRank > 14000 and matchRank <= 20000) then
        self:setLevelData(self.levelnum[2], 2, 7)
    elseif (matchRank > 20000 and matchRank <= 28000) then
        self:setLevelData(self.levelnum[2], 3, 8)
    elseif (matchRank > 28000 and matchRank <= 38000) then
        self:setLevelData(self.levelnum[2], 4, 9)
    elseif (matchRank > 38000 and matchRank <= 50000) then
        self:setLevelData(self.levelnum[2], 5, 10)
    
    elseif (matchRank > 50000 and matchRank <= 70000) then
        self:setLevelData(self.levelnum[3], 1, 11)
    elseif (matchRank > 70000 and matchRank <= 100000) then
        self:setLevelData(self.levelnum[3], 2, 12)
    elseif (matchRank > 100000 and matchRank <= 140000) then
        self:setLevelData(self.levelnum[3], 3, 13)
    elseif (matchRank > 140000 and matchRank <= 190000) then
        self:setLevelData(self.levelnum[3], 4, 14)
    elseif (matchRank > 190000 and matchRank <= 250000) then
        self:setLevelData(self.levelnum[3], 5, 15)
    
    elseif (matchRank > 250000 and matchRank <= 320000) then
        self:setLevelData(self.levelnum[4], 1, 16)
    elseif (matchRank > 320000 and matchRank <= 430000) then
        self:setLevelData(self.levelnum[4], 2, 17)
    elseif (matchRank > 430000 and matchRank <= 580000) then
        self:setLevelData(self.levelnum[4], 3, 18)
    elseif (matchRank > 580000 and matchRank <= 770000) then
        self:setLevelData(self.levelnum[4], 4, 19)
    elseif (matchRank > 770000 and matchRank <= 1000000) then
        self:setLevelData(self.levelnum[4], 5, 20)
    
    elseif (matchRank > 1000000 and matchRank <= 1300000) then
        self:setLevelData(self.levelnum[5], 1, 21)
    elseif (matchRank > 1300000 and matchRank <= 1650000) then
        self:setLevelData(self.levelnum[5], 2, 22)
    elseif (matchRank > 1650000 and matchRank <= 2050000) then
        self:setLevelData(self.levelnum[5], 3, 23)
    elseif (matchRank > 2050000 and matchRank <= 2500000) then
        self:setLevelData(self.levelnum[5], 4, 24)
    elseif (matchRank > 2500000 and matchRank <= 3000000) then
        self:setLevelData(self.levelnum[5], 5, 25)
    
    elseif (matchRank > 3000000 and matchRank <= 3800000) then
        self:setLevelData(self.levelnum[6], 1, 26)
    elseif (matchRank > 3800000 and matchRank <= 4900000) then
        self:setLevelData(self.levelnum[6], 2, 27)
    elseif (matchRank > 4900000 and matchRank <= 6300000) then
        self:setLevelData(self.levelnum[6], 3, 28)
    elseif (matchRank > 6300000 and matchRank <= 8000000) then
        self:setLevelData(self.levelnum[6], 4, 29)
    elseif (matchRank > 8000000 and matchRank <= 10000000) then
        self:setLevelData(self.levelnum[6], 5, 30)
    
    elseif (matchRank > 10000000 and matchRank <= 13000000) then
        self:setLevelData(self.levelnum[7], 1, 31)
    elseif (matchRank > 13000000 and matchRank <= 16500000) then
        self:setLevelData(self.levelnum[7], 2, 32)
    elseif (matchRank > 16500000 and matchRank <= 20000000) then
        self:setLevelData(self.levelnum[7], 3, 33)
    elseif (matchRank > 20000000 and matchRank <= 24000000) then
        self:setLevelData(self.levelnum[7], 4, 34)
    elseif (matchRank > 24000000 and matchRank <= 30000000) then
        self:setLevelData(self.levelnum[7], 5, 35)
    else
        self:setLevelData(self.levelnum[7], 5, 35)         --等级图像显示最高35级
    end

end
return InterimUserLevel