local PersonalInfoCenterScene = class("PersonalInfoCenterScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "PersonalInfoCenterScene"

function PersonalInfoCenterScene:onDestory()    
    self.scrollView_ = nil

    self.pinfoGroup_ = nil
    self.headIcon_ = nil
    self.headIconBtn_ = nil
    -- self.nickNameTitle_ = nil
    self.nickName_ = nil
    self.goldTitle_ = nil
    self.gold_ = nil
    self.expTitle_ = nil
    self.experience_ = nil
    self.raceScoreTitle_ = nil
    self.raceScore_ = nil
    self.btnModifyName_ = nil
    self.qiuCardTitle_  = nil
    self.qiuCard_  = nil
    self.masterScoreTitle_ = nil
    self.masterScore_ = nil
    self.vipLevelTitle_ = nil
    self.vipLevel_ = nil

    self.growGroup_ = nil
    self.pinfoScrollView_ = nil
    self.headIconBtnTitle_ = nil
    self.helpBtn_ = nil

    if self.viewOkScheduler then 
        self.scheduler.unscheduleGlobal(self.viewOkScheduler)
        self.viewOkScheduler = nil
    end

    self:showGuideToBindNoRegDialog(false)

    PersonalInfoCenterScene.super.onDestory(self)
end

function PersonalInfoCenterScene:initView()
    PersonalInfoCenterScene.super.initView(self)

    self.scrollViewIsOK = false
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)

    self.BTN_MENU_GET_INVENTORY = 100
    self.BTN_MENU_ACCOUNT_QUERY = 110
    self.BTN_MENU_SECURE_CENTER = 120
    self.BTN_MENU_SAFE_BOX = 130
    self.BTN_MENU_MSG = 140

    self.scheduler = require(cc.PACKAGE_NAME..".scheduler")

    
    self:setTitle("我的信息")
    self:setBackBtn(true)
    -- self:setTitle(self.theme_:getImage("pcenter/pcenter_title.png"))

    self:initTopInfo()
    self:initGrowView()

    self.controller_:askGetData()
    self:initGrowData()

    -- 如果没有添加growview到基类，那么自己添加
    if not self.scrollViewIsOK then
        self:addPinfoScrollView()
    end

end

function PersonalInfoCenterScene:initTopInfo()
    --个人信息区
    --个人信息显示游戏个数
    local gamenum = 0
    local wareheight = 0
    local rowHeight = 0
    if self.controller_.params_.gameNum > 0 then
        
        gamenum = self.controller_.params_.gameNum
        --个人信息显示单个游戏个人成就高度
        if self.controller_.params_.rowHeight and self.controller_.params_.rowHeight > 0 then
            rowHeight = self.dimens_:getDimens(self.controller_.params_.rowHeight)
        else
            rowHeight = self.dimens_:getDimens(100)
        end
        --个人信息显示合集游戏个人成就高度
        wareheight = rowHeight*gamenum
        
    end
    
    
    --个人信息显示大小
    local width, height = self:getContentWidth(), self:getContentHeight()
    --个人信息显示坐标位置
    local x, y =  (self.dimens_.width - self:getTitleHight())/2 + self:getTitleHight(), self.dimens_.height/2
    local scrollInfoheght = wareheight + self:getPinHeight() + self.dimens_:getDimens(15)
    local inforowheght = self.dimens_:getDimens(30)

    self.pinfoScrollView_ = jj.ui.JJScrollView.new({direction = jj.ui.JJScrollView.DIRECTION_VERTICAL,            
                                                  viewSize = CCSize(width, height + self.dimens_:getDimens(10))})
        self.pinfoScrollView_:setAnchorPoint(ccp(0.5, 0.5))
        self.pinfoScrollView_:setPosition(x, y)
        self:addView(self.pinfoScrollView_)

JJLog.i("PersonalInfoCenterScene12 = ",width, height)
    local pinfobg = jj.ui.JJImage.new({
          image = self.theme_:getImage("common/common_btn_bg_n.png"),
          viewSize = CCSize(width, height + self.dimens_:getDimens(10)),
          scale9 = true,
        })

    pinfobg:setAnchorPoint(ccp(0.5, 0.5))
    pinfobg:setPosition(width/2, height/2 + self.dimens_:getDimens(5))
    self.pinfoScrollView_:addView(pinfobg)  

    self.pinfoGroup_ = jj.ui.JJViewGroup.new({
                        viewSize = CCSize(width, scrollInfoheght)
                        })
    self.pinfoGroup_:setAnchorPoint(ccp(0.5, 1))
    self.pinfoGroup_:setPosition(width/2, scrollInfoheght)

    x, y = self.dimens_:getDimens(30), scrollInfoheght - self.dimens_:getDimens(25)

    local headIconGroup = jj.ui.JJViewGroup.new({
                        viewSize = CCSize(self.dimens_:getDimens(140), self.dimens_:getDimens(140))
                        })
    headIconGroup:setAnchorPoint(ccp(0, 1))
    headIconGroup:setPosition(x, y)
    self.pinfoGroup_:addView(headIconGroup)

    self.headIcon_= jj.ui.JJImage.new({
          image = self.theme_:getImage("figure/jj_figure_default.png"),
        })

    self.headIcon_:setAnchorPoint(ccp(0.5, 0.5))
    self.headIcon_:setPosition(self.dimens_:getDimens(70), self.dimens_:getDimens(70))
    self.headIcon_:setScale(self.dimens_.scale_*0.97) --100/144
    headIconGroup:addView(self.headIcon_)
    self:refreshHeadImg(UserInfo.figureId_)

    self.headIconBtn_= jj.ui.JJButton.new({
         images = {
                     normal=self.theme_:getImage("ui/transparence.png"),
                     highlight=self.theme_:getImage("pcenter/pcenter_head_bg_d.png"),
                     disable=self.theme_:getImage("pcenter/pcenter_head_bg_d.png"),
                },
                viewSize = CCSize(140, 140),
       })
    self.headIconBtn_:setAnchorPoint(ccp(0.5, 0.5))
    self.headIconBtn_:setPosition(self.dimens_:getDimens(70), self.dimens_:getDimens(70))
    self.headIconBtn_:setScale(self.dimens_.scale_)
    self.headIconBtn_:setOnClickListener(handler(self, self.onClick))
    headIconGroup:addView(self.headIconBtn_)

    local modifyiconbg = jj.ui.JJImage.new({
          image = self.theme_:getImage("pcenter/pcenter_modify_head_bg.png"),
          viewSize = CCSize(140, 33),
        })

    modifyiconbg:setAnchorPoint(ccp(0.5, 0))
    modifyiconbg:setPosition(self.dimens_:getDimens(70), 0)
    modifyiconbg:setScale(self.dimens_.scale_) --100/144
    headIconGroup:addView(modifyiconbg)

    self.headIconBtnTitle_ = jj.ui.JJLabel.new({
                         fontSize = self.dimens_:getDimens(16),
                         color = ccc3(255, 255, 255),
                         text ="点击修改头像",
                         align = ui.TEXT_ALIGN_CENTER,
                         viewSize = CCSize(self.dimens_:getDimens(110), self.dimens_:getDimens(20))
                    })
    self.headIconBtnTitle_:setAnchorPoint(ccp(0.5, 0.5))
    self.headIconBtnTitle_:setPosition(self.dimens_:getDimens(70), self.dimens_:getDimens(16))
    headIconGroup:addView(self.headIconBtnTitle_)


    local ftSize = self.dimens_:getDimens(18)
    x = self.dimens_:getDimens(190)
    y = scrollInfoheght - self.dimens_:getDimens(25)
    
    self.nickName_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = UserInfo.nickname_,
                    })
    self.nickName_:setAnchorPoint(ccp(0, 1))
    self.nickName_:setPosition(x, y)
    self.pinfoGroup_:addView(self.nickName_)

    --修改昵称
        x, y = self.nickName_:getPosition()
        x = x + self.dimens_:getDimens(190)
        y = y + self.dimens_:getDimens(20)
        self.btnModifyName_ = jj.ui.JJButton.new({
             images = {
                 normal=self.theme_:getImage("pcenter/pcenter_btn_modifyname_n.png"),
                 highlight=self.theme_:getImage("pcenter/pcenter_btn_modifyname_d.png"),
                 disable=self.theme_:getImage("pcenter/pcenter_btn_modifyname_d.png"),
             },
         })
        self.btnModifyName_:setAnchorPoint(ccp(0, 1))
        self.btnModifyName_:setPosition(x, y)
        self.btnModifyName_:setScale(self.dimens_.scale_)
        self.btnModifyName_:setOnClickListener(handler(self, self.onClick))
    if not Util:isQihu360() then        
        self.pinfoGroup_:addView(self.btnModifyName_)
    end
    --help
    x, y = self.btnModifyName_:getPosition()
    x = x + self.btnModifyName_:getWidth() + self.dimens_:getDimens(40)
    self.helpBtn_ = jj.ui.JJButton.new({
                images = {
                     normal=self.theme_:getImage("pcenter/pcenter_btn_help_n.png"),
                     highlight=self.theme_:getImage("pcenter/pcenter_btn_help_p.png"),
                },
            })
    self.helpBtn_:setAnchorPoint(ccp(0, 1))
    self.helpBtn_:setPosition(x, y)
    self.helpBtn_:setScale(self.dimens_.scale_)
    self.helpBtn_:setOnClickListener(handler(self, self.onClick))
    self.pinfoGroup_:addView(self.helpBtn_)

    x, y = self.helpBtn_:getPosition()
    x = self.nickName_:getPosition()
    y = y - self.dimens_:getDimens(self.helpBtn_:getHeight())
    local div = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
          viewSize = CCSize(382, 2),
          scale9 = true,
        })

    div:setAnchorPoint(ccp(0, 0))
    div:setPosition(x, y)
    div:setScale(self.dimens_.scale_) --100/144
    self.pinfoGroup_:addView(div) 

    -- 金币
    x, y = div:getPosition()
    y = y - self.dimens_:getDimens(20)
    -- self.goldTitle_ = jj.ui.JJLabel.new({
    --                     singleLine = true,
    --                     fontSize = ftSize,
    --                     color = ccc3(255, 255, 255),
    --                     text = "金币：",
    --                  })
    self.goldTitle_ = jj.ui.JJImage.new({
                            image = self.theme_:getImage("bottomview/jj_gold.png"),
                            viewSize = CCSize(30, 30),
                        })
    self.goldTitle_:setAnchorPoint(ccp(0, 1))
    self.goldTitle_:setPosition(x, y)
    self.goldTitle_:setScale(self.dimens_.scale_)
    self.pinfoGroup_:addView(self.goldTitle_)

    x = self.goldTitle_:getPosition() + self.goldTitle_:getWidth()*self.dimens_.scale_ + self.dimens_:getDimens(5)
    self.gold_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = tostring(UserInfo.gold_),
                     })
    self.gold_:setAnchorPoint(ccp(0, 1))
    self.gold_:setPosition(x, y - self.dimens_:getDimens(5))
    self.pinfoGroup_:addView(self.gold_)

    --经验
    x, y = self.goldTitle_:getPosition()
    y = y - self.goldTitle_:getHeight()*self.dimens_.scale_ - self.dimens_:getDimens(5)
    self.expTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "总经验：",
                     })
    self.expTitle_:setAnchorPoint(ccp(0, 1))
    self.expTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.expTitle_)

    x = self.expTitle_:getPosition() + self.expTitle_:getWidth()
    self.experience_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.totalScore_),
                     })
    self.experience_:setAnchorPoint(ccp(0, 1))
    self.experience_:setPosition(x, y)
    self.pinfoGroup_:addView(self.experience_)

    --参赛积分
    x, y = self.expTitle_:getPosition()
    y = y - inforowheght
    self.raceScoreTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "参赛积分：",
                     })
    self.raceScoreTitle_:setAnchorPoint(ccp(0, 1))
    self.raceScoreTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.raceScoreTitle_)

    x = self.raceScoreTitle_:getPosition() + self.raceScoreTitle_:getWidth()
    self.raceScore_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.cert_),
                     })
    self.raceScore_:setAnchorPoint(ccp(0, 1))
    self.raceScore_:setPosition(x, y)
    self.pinfoGroup_:addView(self.raceScore_)

    -- 秋卡
    x, y = self.goldTitle_:getPosition()
    x = x + self.dimens_:getDimens(185)
    -- self.qiuCardTitle_ = jj.ui.JJLabel.new({
    --                     singleLine = true,
    --                     fontSize = ftSize,
    --                     color = ccc3(255, 255, 255),
    --                     text = "秋卡：",
    --                  })
    self.qiuCardTitle_ = jj.ui.JJImage.new({
                            image = self.theme_:getImage("bottomview/qiuka.png"),
                            viewSize = CCSize(30, 30),
                        })
    self.qiuCardTitle_:setAnchorPoint(ccp(0, 1))
    self.qiuCardTitle_:setPosition(x, y)
    self.qiuCardTitle_:setScale(self.dimens_.scale_)
    self.pinfoGroup_:addView(self.qiuCardTitle_)

    x = self.qiuCardTitle_:getPosition() + self.qiuCardTitle_:getWidth()*self.dimens_.scale_ + self.dimens_:getDimens(5)
    self.qiuCard_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo:getQiuKaCount()),
                     })
    self.qiuCard_:setAnchorPoint(ccp(0, 1))
    self.qiuCard_:setPosition(x, y - self.dimens_:getDimens(5))
    self.pinfoGroup_:addView(self.qiuCard_)

    -- 大师分
    x, y = self.qiuCardTitle_:getPosition()
    y = y - self.qiuCardTitle_:getHeight()*self.dimens_.scale_ - self.dimens_:getDimens(5)
    self.masterScoreTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "总大师分：",
                     })
    self.masterScoreTitle_:setAnchorPoint(ccp(0, 1))
    self.masterScoreTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.masterScoreTitle_)

    x = self.masterScoreTitle_:getPosition() + self.masterScoreTitle_:getWidth()
    self.masterScore_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.totalMasterScore_),
                     })
    self.masterScore_:setAnchorPoint(ccp(0, 1))
    self.masterScore_:setPosition(x, y)
    self.pinfoGroup_:addView(self.masterScore_)

    -- 账户等级
    x, y = self.masterScoreTitle_:getPosition()
    y = y - inforowheght
    self.vipLevelTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "账户等级：",
                     })
    self.vipLevelTitle_:setAnchorPoint(ccp(0, 1))
    self.vipLevelTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.vipLevelTitle_)

    x = self.vipLevelTitle_:getPosition() + self.vipLevelTitle_:getWidth()
    self.vipLevel_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = require("game/data/config/VIPConfig"):getTitle(),
                     })
    self.vipLevel_:setAnchorPoint(ccp(0, 1))
    self.vipLevel_:setPosition(x, y)
    self.pinfoGroup_:addView(self.vipLevel_)

end

-- 刷新用户头像
function PersonalInfoCenterScene:refreshHeadImg(headId, update)

    JJLog.i(TAG, "refreshHeadImg headId = ", headId, " type headId = ", type(headId))

    if headId == UserInfo.figureId_ and self.headIcon_ ~= nil then
        local path = HeadImgManager:getImg(UserInfo.userId_, headId)
        if path ~= nil then
            local pic = CCTextureCache:sharedTextureCache():addImage(path)
            -- 如需要更新，需要从新创建一下头像缓存
            if update and pic then
                CCTextureCache:sharedTextureCache():removeTexture(pic)
                pic = CCTextureCache:sharedTextureCache():addImage(path)
            end
            if pic then
                self.headIcon_:setTexture(pic)
            end
        end
    end
end

function PersonalInfoCenterScene:initGrowView()
    --个人成就
    local gamenum = 0
    local growInfoHeight = 0
    local rowHeight = 0
    if self.controller_.params_.gameNum > 0 then
        
        gamenum = self.controller_.params_.gameNum
        --个人信息显示单个游戏个人成就高度
        if self.controller_.params_.rowHeight and self.controller_.params_.rowHeight > 0 then
            rowHeight = self.dimens_:getDimens(self.controller_.params_.rowHeight)
        else
            rowHeight = self.dimens_:getDimens(100)
        end
        --个人信息显示合集游戏个人成就高度
        growInfoHeight = rowHeight*gamenum
        
    end    

    JJLog.i(TAG, "initGrowView gamenum=", gamenum)

    -- 单个游戏信息占用总宽度
    local width = self:getContentWidth() - self.dimens_:getDimens(40)
    -- 计算整个Scrollview的高度
    local scrollInfoheght = growInfoHeight + self:getPinHeight() + self.dimens_:getDimens(15)
    -- 计算Growview坐标
    local x, y = width/2, scrollInfoheght - self:getPinHeight()


    if gamenum > 0 and self.controller_.params_.games then
        self.growGroup_ = jj.ui.JJViewGroup.new({
                            viewSize = CCSize(width, growInfoHeight)
                            })
        self.growGroup_:setAnchorPoint(ccp(0.5, 1))
        self.growGroup_:setPosition(x, y)
        

        self.growList_ = {{name="称号：", id=2, func = self.getTitle},
                          {name="经验：", id=1, func = self.getExperence},
                          {name="胜率：", id=3, func = self.getRate},
                          {name="职业积分：", id=4, func = self.getMatchScore},}

        local gameParams = {
                            singleLine = true,
                            fontSize = self.dimens_:getDimens(20),
                            color = ccc3(255, 217, 0),
                            viewSize = cellSize,
                            align = ui.TEXT_ALIGN_LEFT,
                            valign = ui.TEXT_VALIGN_CENTER,
                        }
        local cellParams = {
                            singleLine = true,
                            fontSize = self.dimens_:getDimens(18),
                            color = ccc3(255, 255, 255),
                            viewSize = cellSize,
                            align = ui.TEXT_ALIGN_CENTER,
                            valign = ui.TEXT_VALIGN_CENTER,
                        }

        -- 生成单元格
        self.gameGrowList_ = {}

        for row, game in ipairs(self.controller_.params_.games) do
        
            y = growInfoHeight - rowHeight*(row - 1)

            local div = jj.ui.JJImage.new({
                  image = self.theme_:getImage("common/common_view_list_div_h.png"),
                  viewSize = CCSize(550, 2),
                  scale9 = true,
                })

            div:setAnchorPoint(ccp(0.5, 1))
            div:setPosition(x + self.dimens_:getDimens(20), y)
            div:setScale(self.dimens_.scale_) --100/144
            self.growGroup_:addView(div) 


            gameParams.text = game.name
            local rowTitle = jj.ui.JJLabel.new(gameParams)
            rowTitle:setAnchorPoint(ccp(0, 1))
            rowTitle:setPosition(self.dimens_:getDimens(20), y - self.dimens_:getDimens(15))
            self.growGroup_:addView(rowTitle)
            
            local rowlabley = y - self.dimens_:getDimens(45)

            for col, grow in ipairs(self.growList_) do

                cellParams.text = grow.name

                if col == 2 or col == 4 then
                    rowlablex = rowlablex + self.dimens_:getDimens(300)
                else
                    rowlablex = self.dimens_:getDimens(20)
                end

                if col == 3 then
                    rowlabley = rowlabley - self.dimens_:getDimens(25)
                end

                local colTitle = jj.ui.JJLabel.new(cellParams)
                colTitle:setAnchorPoint(ccp(0, 1))
                colTitle:setPosition(rowlablex, rowlabley)
                self.growGroup_:addView(colTitle)

                cellParams.text = ""
                local cell = jj.ui.JJLabel.new(cellParams)
                cell:setAnchorPoint(ccp(0, 1))
                cell:setPosition(rowlablex + self.dimens_:getDimens(100), rowlabley)
                self.growGroup_:addView(cell)
                self.gameGrowList_[game.gameId .. grow.id] = cell
            end
        
        end
        
        self:addPinfoScrollView(self.growGroup_)
    end
end

function PersonalInfoCenterScene:initGrowData()
    if self.gameGrowList_ ~= nil and self.growList_ ~= nil and self.controller_.params_.games ~= nil then
        for _, game in ipairs(self.controller_.params_.games) do
            for _, grow in ipairs(self.growList_) do
                local cell = self.gameGrowList_[game.gameId .. grow.id]
                if cell ~= nil then
                    cell:setText(tostring(grow.func(self, game.gameId, game.growId)))
                end
            end
        end
    end
end

--[[
bGold=true: 只刷新金币
bAll=true:刷新所有数据
default bGold=nil and bAll=nil: 刷新中间表格数据
]]
function PersonalInfoCenterScene:refreshData(bGold, bAll)
     if bAll then 
        --JJLog.i("linxh", "refreshData, uid=", UserInfo.userId_, ", name=", UserInfo.nickname_)
        self:initGrowData()
        self:refreshHeadImg(UserInfo.figureId_, true)
        -- self:refreshNoteMsg()
        
        if self.nickName_ then self.nickName_:setText(UserInfo.nickname_) end
        if self.gold_ then self.gold_:setText(tostring(UserInfo.gold_)) end
        if self.experience_ then self.experience_:setText(tostring(UserInfo.totalScore_)) end
        if self.raceScore_ then self.raceScore_:setText(tostring(UserInfo.cert_)) end
        if self.qiuCard_ then self.qiuCard_:setText(tostring(UserInfo:getQiuKaCount())) end
        if self.masterScore_ then self.masterScore_:setText(tostring(UserInfo.totalMasterScore_)) end
        local vipTitle = require("game/data/config/VIPConfig"):getTitle()
        if vipTitle and self.vipLevel_ then self.vipLevel_:setText(vipTitle) end
     elseif bGold then
        if self.gold_ then self.gold_:setText(tostring(UserInfo.gold_)) end
     elseif self.gameGrowList_ and self.growList_ and self.controller_.params_.games then
        for _, game in ipairs(self.controller_.params_.games) do
            for _, grow in ipairs(self.growList_) do
                local cell = self.gameGrowList_[game.gameId .. grow.id]
                if cell then
                    cell:setText(tostring(grow.func(self, game.gameId, game.growId)))
                end
            end
        end
        local vipTitle = require("game/data/config/VIPConfig"):getTitle()
        if vipTitle and self.vipLevel_ then self.vipLevel_:setText(vipTitle) end
    end
end

function PersonalInfoCenterScene:getExperence(gameId, growId)
    return UserInfo:getGrowCount(growId)
end

function PersonalInfoCenterScene:getTitle(gameId)
	if self.controller_.params_ and self.controller_.params_.titleDef then
	    return self.controller_.params_.titleDef:getTitle(gameId) 
	else
		return ""
	end 
end

function PersonalInfoCenterScene:getRate(gameId)
    local win, total = self.controller_:getWinRate(gameId)
    local rate = 0
    if win > 0 and total > 0 then
        rate = string.format("%.2f%%", (win*100)/total)
    end
    return rate
end

function PersonalInfoCenterScene:getMatchScore(gameId)
    local rank, score = self.controller_:getRankInMatchScore(gameId)
    return score
end

function PersonalInfoCenterScene:onClick(target)

    -- 名词解释
    if target == self.helpBtn_ then
        self.controller_:toHelpScene()
    elseif target == self.headIconBtn_ then
        self.controller_:toModifyHeadIconScene(JJGameDefine.GAME_ID_LORD_UNION)
    elseif target == self.btnModifyName_ then
        self.controller_:toModifyNameScene(JJGameDefine.GAME_ID_LORD_UNION)
    end
end

function PersonalInfoCenterScene:onViewSizeChange()
    PersonalInfoCenterScene.super.onViewSizeChange(self)
    --BUG7966 进入‘安全中心’快速触点返回键，会回到‘财务领取’界面
    if not self.viewOkScheduler then 
        self.viewOkScheduler = self.scheduler.performWithDelayGlobal(function() self.viewOk = true end , 0.5)
    end
end

function PersonalInfoCenterScene:onEnterTransitionFinish()
    PersonalInfoCenterScene.super.onEnterTransitionFinish(self)
    self.viewOk = true  
end

function PersonalInfoCenterScene:onEnterBackground()
    PersonalInfoCenterScene.super.onEnterBackground(self)
    self.viewOk = false 
end

--[[
    免注册登录注册引导
]]
function PersonalInfoCenterScene:showGuideToBindNoRegDialog(show)
    JJLog.i(TAG, "showGuideToBindNoRegDialog IN! and show : ", show)
     if show then
        local function onClick()
            JJLog.i(TAG, "showGuideToBindNoRegDialog, onClick, onClickRegister")
            self.controller_:onClickRegister()
        end

        local function closeDialog()
            self.bindNoRegDialog_ = nil
        end

        self.bindNoRegDialog_ = require("game.ui.UIUtil").showGuideToBindNoRegDialog({
            btn1CB = nil,
            btn2CB = onClick,
            dismissCB = closeDialog,
            theme = self.theme_,
            dimens = self.dimens_,
            scene = self,
            prompt = "来宾帐号不支持该功能哦，快注册升级为JJ帐号吧，JJ帐号会自动保留您当前的所有财物和账户信息，方便又安全。",
        })

    else
        if self.bindNoRegDialog_ then
            local UIUtil = require("game.ui.UIUtil") 
            UIUtil.dismissDialog(self.bindNoRegDialog_)
            self.bindNoRegDialog_ = nil
        end
    end
end

-- 获取个人信息高度 头像，昵称等待
function PersonalInfoCenterScene:getPinHeight()
    return self.dimens_:getDimens(185)
end

-- 子类完成成就view后添加到基类中
function PersonalInfoCenterScene:addPinfoScrollView(view)
    if view then
        self.pinfoGroup_:addView(view)
        self.pinfoScrollView_:setContentView(self.pinfoGroup_)
    else
        self.pinfoScrollView_:setContentView(self.pinfoGroup_)
    end
    self.scrollViewIsOK = true
end

function PersonalInfoCenterScene:onBackPressed()
    if self.bindNoRegDialog_ then
        self:showGuideToBindNoRegDialog(false)
        return true
    else
        return false
    end
end

return PersonalInfoCenterScene
