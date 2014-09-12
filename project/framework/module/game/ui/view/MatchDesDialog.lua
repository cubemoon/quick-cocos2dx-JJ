local MatchDesDialog = class("MatchDesDialog", import("sdk.ui.JJDialogBase"))

local RankListCell = class("RankListCell", import("sdk.ui.JJListCell"))
local RankListAdapter = class("RankListAdapter", require("sdk.ui.JJBaseAdapter"))
local AwardListCell = class("AwardListCell", import("sdk.ui.JJListCell"))
local AwardListAdapter = class("AwardListAdapter", require("sdk.ui.JJBaseAdapter"))

local adTheme, awardData, rankData, dimens
--[[    
]]
function MatchDesDialog:ctor(params)
    --params.viewSize = CCSize(854, 480)
    MatchDesDialog.super.ctor(self, params)
    
    adTheme = params.theme
    dimens = params.dimens
    self.matchId_= params.matchId or 0   
    
    -- 背景框 671*355
    local bg = jj.ui.JJImage.new({
        image = adTheme:getImage("common/bg_normal.jpg"),
    })
    bg:setScaleX(dimens.wScale_)
    bg:setScaleY(dimens.hScale_)
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg:setPosition(dimens.cx, dimens.cy)
    bg:setTouchEnable(true)
    bg:setOnClickListener(handler(self, function() end ))
    self:addView(bg)
   
    local lbl = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = dimens:getDimens(26),
            color = ccc3(255, 255, 255),
            text = "赛事详情",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(dimens:getDimens(140), dimens:getDimens(78))
            })
    lbl:setAnchorPoint(ccp(0.5, 1))
    lbl:setPosition(dimens.cx, dimens.top)
    self:addView(lbl)

    --back
    self.btnBack_ = jj.ui.JJButton.new({
        images = {
            normal = adTheme:getImage("common/return_btn_n.png"),
        },
    })
    self.btnBack_:setScale(dimens.scale_)
    self.btnBack_:setAnchorPoint(ccp(0, 1))
    self.btnBack_:setPosition(dimens:getDimens(15), dimens.top - dimens:getDimens(10))
    self.btnBack_:setOnClickListener(handler(self, function() 
                    if self.onCancelListener_ then self.onCancelListener_(self) end
                self:dismiss() end ))
    self:addView(self.btnBack_)

    --内容
    local w, h = dimens.width - dimens:getDimens(60), dimens.height - dimens:getDimens(192)
    bg = jj.ui.JJImage.new({
        image = adTheme:getImage("common/common_view_bg.png"),
        scale9 = true,
        viewSize = CCSize(w, h),
    })
    bg:setAnchorPoint(ccp(0.5, 0.5))   
    --bg:setScale(dimens.scale_) 
    bg:setPosition(dimens.cx, dimens.cy)
    self:addView(bg)


    self.rankListView_ = jj.ui.JJListView.new({
        viewSize = CCSize(w, h)
    })
	
    self.rankListView_:setAnchorPoint(ccp(0.5, 0.5))
    self.rankListView_:setPosition(dimens.cx, dimens.cy)
    self:addView(self.rankListView_)


    self.awardListView_ = jj.ui.JJListView.new({
        viewSize = CCSize(w, h)
    })
	
    self.awardListView_:setAnchorPoint(ccp(0.5, 0.5))
    self.awardListView_:setPosition(dimens.cx, dimens.cy)
    self:addView(self.awardListView_)


    --bottom bar
    bg = jj.ui.JJImage.new({
        image = adTheme:getImage("matchdes/match_des_bottom_bar_bg.png"),
    })
    
    bg:setAnchorPoint(ccp(0.5, 0))
    bg:setScale(dimens.scale_) 
    bg:setPosition(dimens.cx, dimens:getDimens(15))
    self:addView(bg)

    self.foucuBgL_ = jj.ui.JJImage.new({
        image = adTheme:getImage("matchdes/match_des_type_select_left_bg.png"),
    })    
    self.foucuBgL_:setAnchorPoint(ccp(1, 0))
    self.foucuBgL_:setPosition(dimens.cx, dimens:getDimens(26))
    self.foucuBgL_:setScale(dimens.scale_) 
    self:addView(self.foucuBgL_)

    self.foucuBgR_ = jj.ui.JJImage.new({
        image = adTheme:getImage("matchdes/match_des_type_select_right_bg.png"),
    })    
    self.foucuBgR_:setAnchorPoint(ccp(0, 0))
    self.foucuBgR_:setPosition(dimens.cx, dimens:getDimens(26))
    self.foucuBgR_:setScale(dimens.scale_) 
    self:addView(self.foucuBgR_)

    w, h = dimens:getDimens(184), dimens:getDimens(54)
    self.lblAward = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = dimens:getDimens(23),
            color = ccc3(255, 255, 255),
            text = "奖励方案",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(w, h)
            })
    self.lblAward:setAnchorPoint(ccp(0, 0))
    self.lblAward:setPosition(dimens.cx-w, dimens:getDimens(18))
    self.lblAward:setTouchEnable(true)
    self.lblAward:setOnClickListener(handler(self, self.onClick))
    self:addView(self.lblAward)

    self.lblRank = jj.ui.JJLabel.new({
            singleLine = true,
            fontSize = dimens:getDimens(23),
            color = ccc3(255, 255, 255),
            text = "赛场排名",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(w, h)
            })
    self.lblRank:setAnchorPoint(ccp(0, 0))
    self.lblRank:setPosition(dimens.cx, dimens:getDimens(18))
    self.lblRank:setTouchEnable(true)
    self.lblRank:setOnClickListener(handler(self, self.onClick))
    self:addView(self.lblRank)


	self:initAwardData()
	self:setAwardContent()
	self:initRankData()
	self:setRankContent()
    -- 提示文字
    if params.showAward then 
		self:_switchToAwardView()
    else        
		self:_switchToRankView()
    end
end

function MatchDesDialog:_switchToAwardView()
    if self.foucuBgL_ then self.foucuBgL_:setVisible(true) end
    if self.foucuBgR_ then self.foucuBgR_:setVisible(false) end
	if self.awardListView_ ~= nil then
		self.awardListView_:setVisible(true)
	end
	if self.rankListView_ ~= nil then
		self.rankListView_:setVisible(false)
	end
	
end

function MatchDesDialog:_switchToRankView()
    if self.foucuBgL_ then self.foucuBgL_:setVisible(false) end
    if self.foucuBgR_ then self.foucuBgR_:setVisible(true) end

	if self.awardListView_ ~= nil then
		self.awardListView_:setVisible(false)
	end
	if self.rankListView_ ~= nil then
		self.rankListView_:setVisible(true)
	end
end

function MatchDesDialog:setRankFoucus()
    self.showAward = false


    --if self.lblRank then self.lblRank:setColor(ccc3(51, 173, 230)) end
    --if self.lblAward then self.lblAward:setColor(ccc3(255, 255, 255)) end
    
    -- self:setRankContent()
    MatchMsg:sendGetStagePlayerOrderReq(self.matchId_)

    local ctrl = JJSDK:getTopSceneController()
    if ctrl then ctrl.showMatchDesAward = nil end
	self:_switchToRankView()
end

function MatchDesDialog:setAwardFoucus()
    self.showAward = true

    --if self.lblRank then self.lblRank:setColor(ccc3(255, 255, 255)) end
    --if self.lblAward then self.lblAward:setColor(ccc3(51, 173, 230)) end
    -- self:setAwardContent()

    local ctrl = JJSDK:getTopSceneController()
    if ctrl then ctrl.showMatchDesAward = true end

	self:_switchToAwardView()
end

--[[
    设置是否点击外部即销毁对话框

function MatchDesDialog:setCanceledOnTouchOutside(cancel)
    MatchDesDialog.super.setCanceledOnTouchOutside(self, cancel)
    self.cancel_ = cancel
end
]]

function MatchDesDialog:onClick(target)    
    if target == self.lblRank then
        self:setRankFoucus()   
    elseif target == self.lblAward then        
        self:setAwardFoucus()    
    end
end

function MatchDesDialog:initRankData()
    local md = StartedMatchManager:getMatch(self.matchId_) 
    rankData = {}   
    if md and md.gamePlayers_ and #md.gamePlayers_ > 0 then
        --title
        rankData[1] ={str1="名次",str2="积分",str3="昵称",}        
        local item
        for i, player in ipairs(md.gamePlayers_) do
            item = {}
            item.str1 = string.format("第%d名", player.rank_+1)
            item.str3 = player.nickName_
            --if player.out_ then
            --    item.str2 = "出局"
            --    item.out = true
            --else
                item.str2 = tostring(player.score_)
            --end
            item.deskMate = player.deskMate_
            
            rankData[i+1] = item
        end
    else
        rankData[1] ={str1="正在获取排名数据，请稍候..."}
    end 

     --[[rankData[1] ={str1="名次",str2="积分",str3="昵称",}
     rankData[2] ={str1="15",str2="3000",str3="jlin_lxh",}
     rankData[3] ={str1="300",str2="-300",str3="新手123", deskMate=true}
     rankData[4] ={str1="7",str2="5500",str3="妖刀不老",}]]

end 

function MatchDesDialog:setRankContent()    
    if self.rankListView_ and not self.showAward then 
        self:initRankData()
        self.rankListView_:setAdapter(RankListAdapter)
    end
end

function MatchDesDialog:initAwardData()
    local md = StartedMatchManager:getMatch(self.matchId_)    
    local tourneyInfo = md and TourneyController:getTourneyInfoByTourneyId(md.tourneyId_)
    local mc = tourneyInfo and tourneyInfo.matchconfig_
    awardData = {}
    if mc and mc.awards then
        for i, ad in ipairs(mc.awards) do 
            awardData[i] = {}
            if ad.position and string.len(ad.position) > 0 then 
                awardData[i].str1 = string.format("第%s名", ad.position)
                awardData[i].str2 = ad.desc
            else
                awardData[i].str1 = ad.desc              
            end
        end
    end

    --[[awardData[1] = {str1="第一名", str2="100金币"}
    awardData[2] = {str1="第二名", str2="8个足球（1个足球=400金币 1个篮球+1个足球=1000金币）"}
    awardData[3] = {str1="第三名", str2="10金币"}
    awardData[4] = {str1="所有参赛者2金币"}]]
end

function MatchDesDialog:setAwardContent()    
    if self.awardListView_ then 
        self.awardListView_:setAdapter(AwardListAdapter)
    end
end

--=================================================--
function AwardListCell:ctor(params)
    AwardListCell.super.ctor(self, params) 
    local h =  dimens:getDimens(40)
    self:setViewSize(dimens.width - dimens:getDimens(60), h)
    
    local cc, width = ccc3(189, 240, 255), dimens.width - dimens:getDimens(60)
    if not params.data.str2 then 
        cc = ccc3(255, 210, 0)
        width = dimens:getDimens(700)
    end
    local lable = jj.ui.JJLabel.new({
                        singleLine = false,
                        fontSize = dimens:getDimens(18),
                        color = cc,
                        text = params.data.str1,
                        align = ui.TEXT_ALIGN_LEFT,
                        valign = ui.TEXT_VALIGN_CENTER,
                        viewSize = CCSize(width, h)
                    })
    lable:setAnchorPoint(ccp(0, 1))
    lable:setPosition(dimens:getDimens(30), dimens:getDimens(40))        
    self:addView(lable)
    
    if params.data.str2 then
        lable = jj.ui.JJLabel.new({
                        singleLine = false,
                        fontSize = dimens:getDimens(18),
                        color = cc,
                        text = params.data.str2,
                        align = ui.TEXT_ALIGN_LEFT,
                        valign = ui.TEXT_VALIGN_CENTER,
                        viewSize = CCSize(dimens:getDimens(500), h)
                    })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(dimens:getDimens(200), dimens:getDimens(40))        
        self:addView(lable)
    end    

    local rowSep = jj.ui.JJImage.new({
                image = adTheme:getImage("common/common_view_list_div_h.png"),
                viewSize = CCSize(dimens.width - dimens:getDimens(70), dimens:getDimens(2)),
                scale9=true
              })    
    rowSep:setAnchorPoint(ccp(0, 1))
    rowSep:setPosition(dimens:getDimens(5), dimens:getDimens(2))
    self:addView(rowSep)    
end

function AwardListAdapter:ctor()
    AwardListAdapter.super.ctor(self)
end

function AwardListAdapter:getCount()
   return ((awardData and #awardData) or 0)
end

function AwardListAdapter:getView(position)
    return AwardListCell.new({
        data = awardData[position],
    })
end

--=================================================--

function RankListCell:ctor(params)
    RankListCell.super.ctor(self, params)   
    local w, h =  dimens.width - dimens:getDimens(60), dimens:getDimens(40)
    self:setViewSize(w, h)

    local lable
    if params.count == 1 then
        --只有一条，说明是等待更新状态
        lable = jj.ui.JJLabel.new({
                            singleLine = true,
                            fontSize = dimens:getDimens(18),
                            color = ccc3(255, 210, 0),
                            text = params.data.str1,
                            align = ui.TEXT_VALIGN_CENTER,
                            valign = ui.TEXT_VALIGN_CENTER,
                            viewSize = CCSize(w, h)
                        })
            lable:setAnchorPoint(ccp(0.5, 1))
            lable:setPosition(dimens.cx, h)        
            self:addView(lable)
    else      
        --标题
        local cc = ccc3(189, 240, 255)
        if params.index == 1 then  
            cc = ccc3(0, 175, 181)
        elseif params.data.deskMate then
            if params.index == 2 then --self
                cc = ccc3(255, 217, 0)
            else
                cc = ccc3(255, 255, 255)
            end
        --elseif params.data.out then
        --    cc = ccc3(255, 244, 141)
        end

        lable = jj.ui.JJLabel.new({
                            singleLine = true,
                            fontSize = dimens:getDimens(18),
                            color = cc,
                            text = params.data.str1,
                            align = ui.TEXT_ALIGN_LEFT,
                            valign = ui.TEXT_VALIGN_CENTER,
                            viewSize = CCSize(dimens:getDimens(150), h)
                        })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(dimens:getDimens(30), h)        
        self:addView(lable)

        lable = jj.ui.JJLabel.new({
                            singleLine = true,
                            fontSize = dimens:getDimens(18),
                            color = cc,
                            text = params.data.str2,
                            align = ui.TEXT_ALIGN_LEFT,
                            valign = ui.TEXT_VALIGN_CENTER,
                            viewSize = CCSize(dimens:getDimens(150), h)
                        })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(dimens:getDimens(180), dimens:getDimens(40))        
        self:addView(lable)

        lable = jj.ui.JJLabel.new({
                            singleLine = true,
                            fontSize = dimens:getDimens(18),
                            color = cc,
                            text = params.data.str3,
                            align = ui.TEXT_ALIGN_LEFT,
                            valign = ui.TEXT_VALIGN_CENTER,
                            viewSize = CCSize(dimens:getDimens(400), h)
                        })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(dimens:getDimens(330), h)        
        self:addView(lable)       
    end

    local rowSep = jj.ui.JJImage.new({
                image = adTheme:getImage("common/common_view_list_div_h.png"),
                viewSize = CCSize(dimens.width - dimens:getDimens(70), dimens:getDimens(2)),
                scale9=true
              })    
    rowSep:setAnchorPoint(ccp(0, 1))
    rowSep:setPosition(dimens:getDimens(5), dimens:getDimens(2))
    self:addView(rowSep)    
end

function RankListAdapter:ctor()
    RankListAdapter.super.ctor(self)
end

function RankListAdapter:getCount()  
   return ((rankData and #rankData) or 0)   
end

function RankListAdapter:getView(position)
    return RankListCell.new({
        data = rankData[position],
        count = #rankData,
        index = position
    })
end


return MatchDesDialog
