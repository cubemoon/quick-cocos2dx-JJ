local PersonalCenterScene = class("PersonalCenterScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "PersonalCenterScene"

local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")
local WebViewController = require("game.ui.controller.WebViewController")

function PersonalCenterScene:onDestory()
    self.scrollView_ = nil

    self.pInfoWidth_ = nil
    self.pInfoHeight_ = nil
    self.pBtnWidth_ = nil
    self.pBtnHeight_ = nil
    self.pInfoSpace_ = nil
    self.pInfoLeftOffset_  = nil

    self.pinfoGroup_ = nil
    self.headIcon_ = nil
    self.nickName_ = nil
    self.goldTitle_ = nil
    self.gold_ = nil
    self.expTitle_ = nil
    self.experience_ = nil
    self.raceScoreTitle_ = nil
    self.raceScore_ = nil
    self.qiuCardTitle_  = nil
    self.qiuCard_  = nil
    self.masterScoreTitle_ = nil
    self.masterScore_ = nil
    self.vipLevelTitle_ = nil
    self.vipLevel_ = nil

    self.growGroup_ = nil
    self.pInfoBg_ = nil

    if self.btnMenuList ~= nil then
        for _, btnMenu in ipairs(self.btnMenuList) do
            btnMenu = nil
        end
    end

    if self.viewOkScheduler then
        self.scheduler.unscheduleGlobal(self.viewOkScheduler)
        self.viewOkScheduler = nil
    end

    if self.bindNoRegDialog_ then
        local UIUtil = require("game.ui.UIUtil")
        UIUtil.dismissDialog(self.bindNoRegDialog_)
        self.bindNoRegDialog_ = nil
    end

    self:removeMsgView()

    PersonalCenterScene.super.onDestory(self)
end

function PersonalCenterScene:initView()
    PersonalCenterScene.super.initView(self)
    
    --360TODO

    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self.BTN_MENU_BASE_GROUP = 100
    self.BTN_MENU_BASE_BTN = 200

    self.BTN_MENU_GET_INVENTORY = 100
    self.BTN_MENU_ACCOUNT_QUERY = 110
    self.BTN_MENU_SECURE_CENTER = 120
    self.BTN_MENU_SAFE_BOX = 130
    self.BTN_MENU_MSG = 140
    self.BTN_MENU_WARECOMPOSE = 150

    self.scheduler = require(cc.PACKAGE_NAME..".scheduler")

    self:setBackBtn(true)
--    self:setTitle(self.theme_:getImage("pcenter/pcenter_title.png"))
    self:setTitle("个人中心")


--    self.helpBtn_ = jj.ui.JJButton.new({
--                images = {
--                     normal=self.theme_:getImage("pcenter/pcenter_btn_help_n.png"),
--                },
--            })
--    self.helpBtn_:setAnchorPoint(ccp(1, 1))
--    self.helpBtn_:setPosition(self.dimens_.right - self.dimens_:getDimens(10),
--                              self.dimens_.top - self.dimens_:getDimens(10))
--    self.helpBtn_:setScale(self.dimens_.scale_)
--    self.helpBtn_:setOnClickListener(handler(self, self.onClick))
--    self:addView(self.helpBtn_)

    self.pInfoWidth_ = self.dimens_:getDimens(230)
    self.pInfoHeight_ = self.dimens_:getDimens(400)
    self.pBtnWidth_ = self.dimens_:getDimens(170)
    self.pBtnHeight_ = self.dimens_:getDimens(130)
    self.pInfoSpace_ = self.dimens_:getDimens(5)

    self:initTopInfo()
--    self:initGrowView()
    self:initBottomView()

--    self.controller_:askGetData()
--    self:initGrowData()
    self:updateMsgNum()
end

function PersonalCenterScene:initTopInfo()
    --个人信息区
    self.pInfoLeftOffset_ = (self.dimens_.width - self:getTitleHight() - self.pInfoWidth_ - 2*self.pBtnWidth_ - 2*self.pInfoSpace_)/2
    local x = self:getTitleHight() + self.pInfoLeftOffset_
    local y = (self.dimens_.height - self.pInfoHeight_)/2

    self.pinfoGroup_ = jj.ui.JJViewGroup.new({
                        viewSize = CCSize(self.pInfoWidth_, self.pInfoHeight_)
                        })
    self.pinfoGroup_:setAnchorPoint(ccp(0, 0))
    self.pinfoGroup_:setPosition(x, y)
    self:addView(self.pinfoGroup_)

    self.pInfoBg_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("common/common_btn_bg_n.png"),
                highlight = self.theme_:getImage("common/common_btn_bg_d.png"),
                viewSize = CCSize(self.pInfoWidth_, self.pInfoHeight_),
                scale9 = true,
            },
            viewSize = CCSize(self.pInfoWidth_, self.pInfoHeight_),
        })
    self.pInfoBg_:setOnClickListener(handler(self, self.onClick))
    self.pinfoGroup_:addView(self.pInfoBg_)

     --title
    local height = self.dimens_:getDimens(25)
    local ftSize = self.dimens_:getDimens(18)
    x = self.pInfoWidth_/2
    y = self.pInfoHeight_ - self.dimens_:getDimens(35)
    self.headIcon_= jj.ui.JJImage.new({
          image = "img/figure/jj_figure_default.png",
          viewSize = CCSize(140, 140),
        })

    self.headIcon_:setAnchorPoint(ccp(0.5, 1))
    self.headIcon_:setPosition(x, y)
    self.headIcon_:setScale(self.dimens_.scale_) --140/144
    self.pinfoGroup_:addView(self.headIcon_)
    self:refreshHeadImg(UserInfo.figureId_)

    --昵称
    x, y = self.headIcon_:getPosition()
    x = self.pInfoWidth_/2
    y = y - self.dimens_:getDimens(140) - 2*self.pInfoSpace_
    self.nickName_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = UserInfo.nickname_,
                    })
    self.nickName_:setAnchorPoint(ccp(0.5, 0.5))
    self.nickName_:setPosition(x, y - height/2)
    self.pinfoGroup_:addView(self.nickName_)

    -- 金币
    height = self.dimens_:getDimens(30)
    x, y = self.nickName_:getPosition()
    x = self.dimens_:getDimens(30)
    y = y - height/2
    self.goldTitle_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("bottomview/jj_gold.png"),
    })
    self.goldTitle_:setAnchorPoint(ccp(0, 0.5))
    self.goldTitle_:setPosition(x, y - height/2)
    self.goldTitle_:setScale(self.dimens_.scale_)
    self.pinfoGroup_:addView(self.goldTitle_)

    x = x + self.dimens_:getDimens(30) + self.pInfoSpace_
    self.gold_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = tostring(UserInfo.gold_),
                     })
    self.gold_:setAnchorPoint(ccp(0, 0.5))
    self.gold_:setPosition(x, y - height/2)
    self.pinfoGroup_:addView(self.gold_)

    -- 秋卡
    x, y = self.goldTitle_:getPosition()
    y = y - height/2
    self.qiuCardTitle_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("bottomview/qiuka.png"),
        viewSize = CCSize(self.dimens_:getDimens(30), self.dimens_:getDimens(30)),
    })
    self.qiuCardTitle_:setAnchorPoint(ccp(0, 0.5))
    self.qiuCardTitle_:setPosition(x, y - height/2)
    self.qiuCardTitle_:setScale(self.dimens_.scale_)
    self.pinfoGroup_:addView(self.qiuCardTitle_)

    x = x + self.dimens_:getDimens(30) + self.pInfoSpace_
    self.qiuCard_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo:getQiuKaCount()),
                     })
    self.qiuCard_:setAnchorPoint(ccp(0, 0.5))
    self.qiuCard_:setPosition(x, y - height/2)
    self.pinfoGroup_:addView(self.qiuCard_)

    y = y - height - self.dimens_:getDimens(7)
    local div = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
        viewSize = CCSize(208, 2),
        scale9 = true,
    })
    div:setAnchorPoint(ccp(0.5, 1))
    div:setPosition(self.pInfoWidth_/2, y)
    div:setScale(self.dimens_.scale_)
    self.pinfoGroup_:addView(div)

    height = self.dimens_:getDimens(25)
    --经验
    x, y = div:getPosition()
    x = self.dimens_:getDimens(15)--x - div:getWidth()/2
    y = y - self.dimens_:getDimens(10)
    self.expTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "总经验: ",
                     })
    self.expTitle_:setAnchorPoint(ccp(0, 1))
    self.expTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.expTitle_)

    x = x + self.expTitle_:getWidth()
    self.experience_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.totalScore_),
                     })
    self.experience_:setAnchorPoint(ccp(0, 1))
    self.experience_:setPosition(x, y)
    self.pinfoGroup_:addView(self.experience_)

    -- 大师分
    x, y = self.expTitle_:getPosition()
    y = y - height
    self.masterScoreTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "大师分: ",
                     })
    self.masterScoreTitle_:setAnchorPoint(ccp(0, 1))
    self.masterScoreTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.masterScoreTitle_)

    x = x + self.masterScoreTitle_:getWidth()
    self.masterScore_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.totalMasterScore_),
                     })
    self.masterScore_:setAnchorPoint(ccp(0, 1))
    self.masterScore_:setPosition(x, y)
    self.pinfoGroup_:addView(self.masterScore_)

    --参赛积分
    x, y = self.masterScoreTitle_:getPosition()
    y = y - height
    self.raceScoreTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "参赛积分: ",
                     })
    self.raceScoreTitle_:setAnchorPoint(ccp(0, 1))
    self.raceScoreTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.raceScoreTitle_)

    x = x + self.raceScoreTitle_:getWidth()
    self.raceScore_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(253, 255, 255),
                        text = tostring(UserInfo.cert_),
                     })
    self.raceScore_:setAnchorPoint(ccp(0, 1))
    self.raceScore_:setPosition(x, y)
    self.pinfoGroup_:addView(self.raceScore_)

    -- 账户等级
    x= self.raceScoreTitle_:getPosition()
    y = y - height
    self.vipLevelTitle_ = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = ftSize,
                        color = ccc3(255, 255, 255),
                        text = "账户等级: ",
                     })
    self.vipLevelTitle_:setAnchorPoint(ccp(0, 1))
    self.vipLevelTitle_:setPosition(x, y)
    self.pinfoGroup_:addView(self.vipLevelTitle_)

    x = x + self.vipLevelTitle_:getWidth()
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
function PersonalCenterScene:refreshHeadImg(headId, update)

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

function PersonalCenterScene:initGrowView()
    --个人成就
    local width, height = self.dimens_:getDimens(700), self.dimens_:getDimens(190)
    local x, y = (self.dimens_.width - width)/2, self.dimens_.cy + self.dimens_:getDimens(40)

    self.growGroup_ = jj.ui.JJViewGroup.new({
                        background={
                            image = self.theme_:getImage("common/common_view_bg.png"),
                            scale9 = true
                        },
                        viewSize = CCSize(width, height)
                        })
    self.growGroup_:setAnchorPoint(ccp(0, 1))
    self.growGroup_:setPosition(x, y)
    self:addView(self.growGroup_)


    --local idDef = require("sdk.def.GrowWareIdDef")

    self.growList_ = {{name="经验", id=1, func = self.getExperence},
                      {name="称号", id=2, func = self.getTitle},
                      {name="胜率", id=3, func = self.getRate},
                      {name="职业积分", id=4, func = self.getMatchScore},}

    -- self.gameList_ = {{ name="经典场",
    --                     id=JJGameDefine.GAME_ID_LORD,
    --                    expId=idDef.LORD_GROW_EXPERIENCE_ID,},
    --                   {name="欢乐场",
    --                    id=JJGameDefine.GAME_ID_LORD_HL,
    --                    expId = idDef.LORDHL_GROW_EXPERIENCE_ID,},
    --                   {name="赖子场",
    --                   id=JJGameDefine.GAME_ID_LORD_LZ,
    --                   expId = idDef.LORDLZ_GROW_EXPERIENCE_ID,},
    --                   {name="二人场",
    --                   id=JJGameDefine.GAME_ID_LORD_PK,
    --                   expId = idDef.PKLORD_GROW_EXPERIENCE_ID,},}

    -- 画单元格
    --local cellHeight, cellWidth =  height/(#self.controller_.params_.games + 1), width/(#self.growList_ + 1)
    local cellHeight, cellWidth =  height/5, width/5
    local sepSizeH = CCSize(self.dimens_:getDimens(680), self.dimens_:getDimens(2))
    local sepSizeV = CCSize(self.dimens_:getDimens(2), self.dimens_:getDimens(170))
    local sepHLeft, sepVTop = (width-sepSizeH.width)/2, (height + sepSizeV.height)/2
    local cellSize, offset = CCSize(cellWidth, cellHeight), self.dimens_:getDimens(5)
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
    for col, grow in ipairs(self.growList_) do
        x = col*cellWidth
        --列标题
        local colSep = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/common_view_list_div_v.png"),
                viewSize = sepSizeV,
                scale9=true
              })
        colSep:setAnchorPoint(ccp(0, 1))
        colSep:setPosition(x, sepVTop)
        self.growGroup_:addView(colSep)

        cellParams.text = grow.name
        local colTitle = jj.ui.JJLabel.new(cellParams)
        colTitle:setAnchorPoint(ccp(0, 1))
        colTitle:setPosition(x, height)
        self.growGroup_:addView(colTitle)

        for row, game in ipairs(self.controller_.params_.games) do
            y = height - row*cellHeight
            --行标题
            if col == 1 then
                local rowSep = jj.ui.JJImage.new({
                    image = self.theme_:getImage("common/common_view_list_div_h.png"),
                    viewSize = sepSizeH,
                    scale9=true
                  })
                rowSep:setAnchorPoint(ccp(0, 1))
                rowSep:setPosition(sepHLeft, y)
                self.growGroup_:addView(rowSep)

                cellParams.text = game.name
                local rowTitle = jj.ui.JJLabel.new(cellParams)
                rowTitle:setAnchorPoint(ccp(0, 1))
                rowTitle:setPosition(sepHLeft, y)
                self.growGroup_:addView(rowTitle)
                --JJLog.i("linxh", "sepHLeft=" .. sepHLeft .. ", y=" .. y .. ", cellHeight=" .. cellHeight .. ", cellWidth=" .. cellWidth .. ", top=" )
            end

            cellParams.text = ""
            local cell = jj.ui.JJLabel.new(cellParams)
            cell:setAnchorPoint(ccp(0, 1))
            cell:setPosition(x, y)
            self.growGroup_:addView(cell)
            self.gameGrowList_[game.gameId .. grow.id] = cell
        end
    end

end

function PersonalCenterScene:initBottomView()
    --底部按钮
     local btnList = {
                      {
                        images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_msg_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_msg_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_msg_btn_n.png"), } ,
                         text = "消息",
                         id = self.BTN_MENU_MSG,
                     },
                     {
                        images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_warecompose_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_warecompose_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_warecompose_btn_n.png"), } ,
                         text = "合成炉",
                         id = self.BTN_MENU_WARECOMPOSE,
                     },
                     {
                         images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_getgold_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_getgold_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_getgold_btn_n.png"),},
                         text = "财物领取",
                         id  = self.BTN_MENU_GET_INVENTORY
                     },
                     {
                        images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_account_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_account_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_account_btn_n.png"), },
                         text = "账单查询",
                         id = self.BTN_MENU_ACCOUNT_QUERY
                     },
                    {
                        images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_safebox_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_safebox_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_safebox_btn_n.png"),},
                         text = "保险箱",
                         id = self.BTN_MENU_SAFE_BOX
                     },
                     {
                        images = {  normal=self.theme_:getImage("pcenter/pcenter_menu_secure_btn_n.png"),
                         highlight=self.theme_:getImage("pcenter/pcenter_menu_secure_btn_n.png"),
                         disable=self.theme_:getImage("pcenter/pcenter_menu_secure_btn_n.png"),} ,
                         text = "安全中心",
                         id = self.BTN_MENU_SECURE_CENTER
                     },
                }

      if Util:isQihu360() then
          table.remove(btnList, 6)        
          table.remove(btnList, 5)            
      end

      local bWareCompose = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_WARECOMPOSE)
      if bWareCompose == false then
        table.remove(btnList, 2)
      end

      if UserInfo.isBindMobile_ then
        if bWareCompose == false then
          table.remove(btnList, 2)
        else
          table.remove(btnList, 3)
        end
      end

      self.btnMenuList = {}
      local width = self.pBtnWidth_
      local height = self.pBtnHeight_
      local txtWidth,txtHeight = self.dimens_:getDimens(100), self.dimens_:getDimens(30)
      local btnIconWidth = self.dimens_:getDimens(100)
      local btnIconHeight = self.dimens_:getDimens(100)
      local lableTop = height - btnIconHeight - self.dimens_:getDimens(3)

      local params = {    viewSize = CCSize(btnIconWidth, btnIconHeight),
                          scale = self.dimens_.scale_,

                         --btnSize = CCSize(btnWidth, btnHeight),
                         btnLeft = 0,
                         btnTop = height - self.dimens_:getDimens(10),

                         txtSize = CCSize(txtWidth, txtHeight),
                         txtLeft = 0,
                         txtTop = lableTop,
                         singleLine = true,
                         fontSize = self.dimens_:getDimens(22),
                         color = ccc3(255, 255, 255),

                         align = ui.TEXT_ALIGN_CENTER,
                         theme = self.theme_,
                         dimen = self.dimens_,
                        }

    local btnExt = require("game.ui.view.JJButtonExt")

    local xMargin = self.pInfoSpace_
    local x = self:getTitleHight() + self.pInfoLeftOffset_ + self.pInfoWidth_ + self.pInfoSpace_
    local y =  (self.dimens_.height - self.pInfoHeight_)/2
    local index = 1

    for _, btn in ipairs(btnList) do
        local startY = (self.dimens_.height - self.pInfoHeight_)/2
        if index == 1 or index == 3 or index == 5 then
            x = self:getTitleHight() + self.pInfoLeftOffset_ + self.pInfoWidth_ + self.pInfoSpace_
        else
            x = self:getTitleHight() + self.pInfoLeftOffset_ + self.pInfoWidth_ + self.pInfoSpace_ + width + xMargin
        end

        if index == 1 or index == 2 then
            y = startY + height + self.pInfoSpace_ + height + self.pInfoSpace_
        elseif index == 3 or index == 4 then
            y = startY + height + self.pInfoSpace_
        else
            y = startY
        end

        JJLog.i(TAG, "#index=", index, x, y)
        local layout = jj.ui.JJViewGroup.new({
            viewSize = CCSize(width, height),
        })
        layout:setId(btn.id + self.BTN_MENU_BASE_GROUP)
        layout:setAnchorPoint(ccp(0, 0))
        layout:setPosition(ccp(x, y))
        self:addView(layout)

        local bg = jj.ui.JJButton.new({
                images = {
                    normal = self.theme_:getImage("common/common_btn_bg_n.png"),
                    highlight = self.theme_:getImage("common/common_btn_bg_d.png"),
                    viewSize = CCSize(width, height),
                    scale9 = true,
                },
                viewSize = CCSize(width, height),
            })
        bg:setId(btn.id)
        bg:setOnClickListener(handler(self, self.onClick))
        layout:addView(bg)

--        x = index*xMargin + (index-1)*width
        params.images =  btn.images
        params.text = btn.text

        local btnMenu = btnExt.new(params)
        btnMenu:setAnchorPoint(ccp(0.5, 0.5))
        btnMenu:setPosition(width/2, height/2)
        btnMenu:setId(btn.id + self.BTN_MENU_BASE_BTN)
        btnMenu:setScale(self.dimens_.scale_)
        btnMenu:setTouchEnable(false)
--        btnMenu:setOnClickListener(handler(self, self.onClick))
        layout:addView(btnMenu)

        self.btnMenuList[index] = bg
        index = index + 1
    end
end

function PersonalCenterScene:initGrowData()
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
function PersonalCenterScene:refreshData(bGold, bAll)
     if bAll then
        --JJLog.i("linxh", "refreshData, uid=", UserInfo.userId_, ", name=", UserInfo.nickname_)
--        self:initGrowData()
        self:refreshHeadImg(UserInfo.figureId_, true)
        self:refreshNoteMsg()

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
     else
        -- if self.gameGrowList_ and self.growList_ and self.controller_.params_.games then
        -- for _, game in ipairs(self.controller_.params_.games) do
        --     for _, grow in ipairs(self.growList_) do
        --         local cell = self.gameGrowList_[game.gameId .. grow.id]
        --         if cell then
        --             cell:setText(tostring(grow.func(self, game.gameId, game.growId)))
        --         end
        --     end
        -- end
        local vipTitle = require("game/data/config/VIPConfig"):getTitle()
        if vipTitle and self.vipLevel_ then self.vipLevel_:setText(vipTitle) end
    end
end

function PersonalCenterScene:getExperence(gameId, growId)
    return UserInfo:getGrowCount(growId)
end

function PersonalCenterScene:getTitle(gameId)
	if self.controller_.params_ and self.controller_.params_.titleDef then
	    return self.controller_.params_.titleDef:getTitle(gameId)
	else
		return ""
	end
end

function PersonalCenterScene:getRate(gameId)
    local win, total = self.controller_:getWinRate(gameId)
    local rate = 0
    if win > 0 and total > 0 then
        rate = string.format("%.2f%%", (win*100)/total)
    end
    return rate
end

function PersonalCenterScene:getMatchScore(gameId)
    local rank, score = self.controller_:getRankInMatchScore(gameId)
    return score
end

function PersonalCenterScene:onClick(target)

    -- 名词解释
    if target == self.helpBtn_ then
        self.controller_:toHelpScene()
    elseif target == self.pInfoBg_ then
        self.controller_:toModifyHeadIconScene()
    else
        local id = target:getId()
        for _, btn in ipairs(self.btnMenuList) do
            if id == btn:getId() then
                self:onClickMenu(id)
                break
            end
        end
    end
end

function PersonalCenterScene:onViewSizeChange()
    PersonalCenterScene.super.onViewSizeChange(self)
    --BUG7966 进入‘安全中心’快速触点返回键，会回到‘财务领取’界面
    if not self.viewOkScheduler then
        self.viewOkScheduler = self.scheduler.performWithDelayGlobal(function() self.viewOk = true end , 0.5)
    end
end

function PersonalCenterScene:onEnterTransitionFinish()
    PersonalCenterScene.super.onEnterTransitionFinish(self)
    self.viewOk = true
end

function PersonalCenterScene:onEnterBackground()
    PersonalCenterScene.super.onEnterBackground(self)
    self.viewOk = false
end

function PersonalCenterScene:onClickMenu(menuId)
    if menuId and self.viewOk then
        if menuId == self.BTN_MENU_GET_INVENTORY then
            self.controller_:toGetInvertoryScene(JJGameDefine.GAME_ID_LORD_UNION)
        elseif menuId == self.BTN_MENU_ACCOUNT_QUERY then
            self.controller_:toAccountQueryScene(JJGameDefine.GAME_ID_LORD_UNION)
        elseif menuId == self.BTN_MENU_SECURE_CENTER then
            self.controller_:toSecureCenterScene(JJGameDefine.GAME_ID_LORD_UNION)
        elseif menuId == self.BTN_MENU_SAFE_BOX then
            self.controller_:toSafeBoxScene(JJGameDefine.GAME_ID_LORD_UNION)
        elseif menuId == self.BTN_MENU_MSG then
            self:showMsg(true)
        elseif menuId == self.BTN_MENU_WARECOMPOSE then
            self:warecomposeBtnOnClick()
        end
    end
end

--[[刷新私信提醒]]
function PersonalCenterScene:updateMsgNum()
    local count = NoteManager:getUnreadCount(MainController:getCurPackageId(), UserInfo.userId_)
    local msggroup = self:getViewById(self.BTN_MENU_MSG + self.BTN_MENU_BASE_GROUP)
    if msggroup ~= nil then
        local msgBtn = msggroup:getViewById(self.BTN_MENU_MSG + self.BTN_MENU_BASE_BTN)
        JJLog.i(TAG, "updateMsgNum=", msgBtn, count)
        if msgBtn then msgBtn:setTipCount(count) end
    end
end

function PersonalCenterScene:showMsg(show)
    if show then
        if self.NoteManagerView_ == null then
            self.NoteManagerView_ = import("game.ui.view.NoteManagerView").new({theme = self.theme_,
                dimens = self.dimens_, scene = self})
            self.NoteManagerView_:setAnchorPoint(ccp(0.5, 0.5))
            self.NoteManagerView_:setPosition(self.dimens_.cx, self.dimens_.cy)
            self:addView(self.NoteManagerView_)
        else
            if self.NoteManagerView_ then
                self.NoteManagerView_:setVisible(true)
            end
        end
    else
        if self.NoteManagerView_ then
            self.NoteManagerView_:setVisible(false)
        end
    end
end

function PersonalCenterScene:removeMsgView()
    if self.NoteManagerView_ ~= nil then
        self.NoteManagerView_ = nil
    end
end

function PersonalCenterScene:refreshNoteMsg()
    if self.NoteManagerView_ ~= nil then
        self.NoteManagerView_:refresh()
    end
end

function PersonalCenterScene:warecomposeBtnOnClick()
    JJLog.i(TAG, "_onClick, btnWarecompose_")
    if MainController:isLogin() then
        WebViewController:showActivity({
            title = "合成炉",
            back = true,
            sso = true,
            url = JJWebViewUrlDef.URL_COMPOSE
        })
    else
        if self.scene_ and self.scene_.controller_ and self.scene_.controller_.startLogin ~= nil then
            self.scene_.controller_:startLogin()
        end
    end
end

--[[
    免注册登录注册引导
]]
function PersonalCenterScene:showGuideToBindNoRegDialog(show)
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

function PersonalCenterScene:onBackPressed()
    if self.bindNoRegDialog_ then
        self:showGuideToBindNoRegDialog(false)
        return true
    elseif self.NoteManagerView_ and self.NoteManagerView_:isVisible()then
        self:showMsg(false)
        return true
    else
        return false
    end
end

return PersonalCenterScene
