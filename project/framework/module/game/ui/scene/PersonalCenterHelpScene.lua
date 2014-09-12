local PersonalCenterHelpScene = class("PersonalCenterHelpScene", import("game.ui.scene.JJGameSceneBase"))

function PersonalCenterHelpScene:initView()
    PersonalCenterHelpScene.super.initView(self)
   
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle("名词解释")
    --self:setTitle(self.theme_:getImage("pcenter/pcenter_help_title.png"))

    --local width, height = self.dimens_:getDimens(800), self.dimens_:getDimens(400)
    --local x, y = self.dimens_:getDimens(240), self.dimens_.top - self.dimens_:getDimens(60)
    local width, height = self:getContentWidth(), self:getContentHeight()
    local x, y =  (self.dimens_.width - self:getTitleHight())/2 + self:getTitleHight(), self.dimens_.height/2
    local y_height = 0

    self.scrollView_ = jj.ui.JJScrollView.new({direction = jj.ui.JJScrollView.DIRECTION_VERTICAL,            
                                                  viewSize = CCSize(width, height + self.dimens_:getDimens(20))})
        self.scrollView_:setAnchorPoint(ccp(0.5, 0.5))
        self.scrollView_:setPosition(x, y)
        self:addView(self.scrollView_)

    local infobg = jj.ui.JJImage.new({
          image = self.theme_:getImage("common/common_btn_bg_n.png"),
          viewSize = CCSize(width, height + self.dimens_:getDimens(10)),
          scale9 = true,
        })

    infobg:setAnchorPoint(ccp(0.5, 0.5))
    infobg:setPosition(width/2, height/2 + self.dimens_:getDimens(5))
    self.scrollView_:addView(infobg) 

    self.infoGroup_ = jj.ui.JJViewGroup.new({
        viewSize = CCSize(width, height + self.dimens_:getDimens(80) ),
    })
    self.infoGroup_:setAnchorPoint(ccp(0.5, 1))
    self.infoGroup_:setPosition(width/2, height + self.dimens_:getDimens(80))
    
--[[
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_btn_bg_n.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(600), y - self.dimens_:getDimens(10)),
    })
    bg:setAnchorPoint(ccp(0, 1))
    bg:setPosition(x - self.dimens_:getDimens(40), y + self.dimens_:getDimens(30))
    self:addView(bg)
]]
    local x = self.dimens_:getDimens(40)
    local y = self:getContentHeight() - self.dimens_:getDimens(10)
    local paramsTitle = {
        fontSize = self.dimens_:getDimens(22),
        -- align = ui.TEXT_ALIGN_LEFT,
        color = ccc3(255, 217, 0)
    }
    local params = {
        fontSize = self.dimens_:getDimens(18),
        singleLine = false,
        viewSize = CCSize(self.dimens_:getDimens(500), self.dimens_:getDimens(80)),
        -- align = ui.TEXT_ALIGN_LEFT,
        color = ccc3(255, 255, 255)
    }

    paramsTitle.text = "秋卡："                        
    local label_ = jj.ui.JJLabel.new(paramsTitle)
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y = y - y_height/3                    
    params.text = "秋卡是一种道具，攒够一定数量可在合成炉合成话费、手机、数码时尚产品等奖品哦。"
    label_ = jj.ui.JJLabel.new(params)
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y =  y - y_height                        
    paramsTitle.text = "职业积分："                      
    local label_ = jj.ui.JJLabel.new(paramsTitle)
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y = y - y_height/3                      
    params.text = "职业积分是根据您参与不同级别的比赛获得一定名次给予对应的积分，积分总和越高您的排名会越高。"
    label_ = jj.ui.JJLabel.new(params)
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y = y - y_height                         
    paramsTitle.text = "胜率："                        
    local label_ = jj.ui.JJLabel.new(paramsTitle)
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y = y - y_height                     
    params.text = "胜率统计是2013.4.1开始的哦。"
    label_ = jj.ui.JJLabel.new({
        text = params.text,
        fontSize = self.dimens_:getDimens(18),
        singleLine = false,
        color = ccc3(255, 255, 255)
        })
    label_:setAnchorPoint(ccp(0, 1))    
    label_:setPosition(x, y)
    self.infoGroup_:addView(label_)

    y_height = label_:getBoundingBoxHeight()
    y = y - y_height - self.dimens_:getDimens(10)                      
    local btnParams = {
        fontSize = self.dimens_:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        color = ccc3(255, 217, 0)
    }

    for i=1, #self.controller_.params_.games do
        y = y - y_height - self.dimens_:getDimens(10)
        btnParams.text = self.controller_.params_.games[i].name
        local btn = jj.ui.JJButton.new(btnParams)
        btn:setAnchorPoint(ccp(0, 1))  
        btn:setPosition(x, y)
        btn:setId(self.controller_.params_.games[i].gameId)
        btn:setOnClickListener(handler(self, self.onClick))
        self.infoGroup_:addView(btn)
    end
    self.scrollView_:addView(self.infoGroup_)
end

function PersonalCenterHelpScene:onClick(target)
    if target then         
        self.controller_:toTitleScene(target:getId())
    end
end

return PersonalCenterHelpScene
