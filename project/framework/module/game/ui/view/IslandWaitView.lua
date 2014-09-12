-- 岛屿赛休息
--[[ 该view一般是作为一个组件被别的view使用，
使用该view的parent必须实现下面几个方法，一般是直接调用该view对应的方法
recvAward(), updateTaskInfo(), onHematinicAck(flag), onBackPressed()
]]
local IslandWaitView = class("IslandWaitView", require("game.ui.view.JJMatchView"))
local WebViewController = require("game.ui.controller.WebViewController")

local TAG = "IslandWaitView"

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")


function IslandWaitView:ctor(viewController)
    IslandWaitView.super.ctor(self, viewController)
    self.controller = viewController
    local matchData = self.viewController_:getMatchData()
    self.data = matchData and matchData.islandData_
   
    self.nextAwardSec = 0
    self.restSec = 0
    self.awardTimeSpan = 0
    self.rankType = matchData and matchData.rankType_
    self.isRank = false
    if self.rankType == 1 and matchData.rank_ ~= 0 and matchData.leavePlayer_ ~= 0 then
        self.isRank = true
    end
    self:initView()

    self.bottleList_ = {}
    if self.data and self.data.bottles_ then
        for i=1,#self.data.bottles_ do
            local blood = self.data.bottles_[i].blood
            local cost = self.data.bottles_[i].cost
            self.bottleList_[i] = {blood,cost}
        end

        self.restSec = self.data.restTime_ or 0
        self.nextAwardSec = self.data.nextAwardLeftSecond_ or 0
        self.awardTimeSpan = self.data.awardTimeSpan_ or 0
        self:updateTaskInfo()
        self:addHPResult(true)
    end

    --岛屿赛休息界面后台回来时如果立即调用该方法会导致transferView中的self.scene_为nil而崩溃
    --self:checkTimeSpan()   
    self.checkTime = scheduler.scheduleGlobal(function() self:checkTimeSpan() end, 1)

end

function IslandWaitView:initView()
    self.bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("game/islandwait/island_wait_content_bg.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(630), self.dimens_:getDimens(175)),
    })
    self.bg:setAnchorPoint(CCPoint(0.5, 0.5))
    self.bg:setPosition(self.dimens_.cx, self.dimens_.cy+self.dimens_:getDimens(30))
    self:addView(self.bg)

    self.line = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_view_list_div_h.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(630), self.dimens_:getDimens(2)),
    })
    self.line:setAnchorPoint(CCPoint(0.5, 0.5))
    self.line:setPosition(self.dimens_.cx, self.dimens_.cy+self.dimens_:getDimens(65))
    self:addView(self.line)

    --当前生命
    local ftSize, ftHeight = self.dimens_:getDimens(20), self.dimens_:getDimens(30)
    local y = self.dimens_.cy + self.dimens_:getDimens(103)
    if self.dimens_.width == 1800 and self.dimens_.height == 1080 then -- 1800*1080屏特殊处理
        y = self.dimens_.cy + self.dimens_:getDimens(111)
    end
    self.life = jj.ui.JJLabel.new({
        text = "当前生命：",
        fontSize = ftSize,
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(255, 255, 255),
        viewSize = CCSize(self.dimens_:getDimens(115), ftHeight),
    })
    self.life:setAnchorPoint(CCPoint(0, 1))
    self.life:setPosition(self.dimens_.cx - self.dimens_:getDimens(250), y)    
    self:addView(self.life)

    self.lblLife = jj.ui.JJLabel.new({
        text = self.data and self.data.life_,
        fontSize = ftSize,
        align = ui.TEXT_ALIGN_LEFT,
        valign = ui.TEXT_VALIGN_CENTER,
        color = ccc3(255, 217, 0),
        viewSize = CCSize(self.dimens_:getDimens(100), ftHeight),
    })
    self.lblLife:setAnchorPoint(CCPoint(0, 1))
    self.lblLife:setPosition(self.dimens_.cx - self.dimens_:getDimens(150), y)
    self:addView(self.lblLife)

    --可兑换金币
    if self.data and self.data.exchangeRate_ and self.data.exchangeRate_ > 0 then
        self.exchangeLab = jj.ui.JJLabel.new({
            text = "可回兑金币：",
            fontSize = ftSize,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_CENTER,
            color = ccc3(255, 255, 255),
            viewSize = CCSize(self.dimens_:getDimens(150), ftHeight),
        })
        self.exchangeLab:setAnchorPoint(CCPoint(0, 1))
        self.exchangeLab:setPosition(self.dimens_.cx + self.dimens_:getDimens(90) , y)
        self:addView(self.exchangeLab)

        self.exchangeCoin = jj.ui.JJLabel.new({
            text = self:getCoin(),
            fontSize = ftSize,
            align = ui.TEXT_ALIGN_LEFT,
            valign = ui.TEXT_VALIGN_CENTER,
            color = ccc3(255, 217, 0),
            viewSize = CCSize(self.dimens_:getDimens(120), ftHeight),
        })
        self.exchangeCoin:setAnchorPoint(CCPoint(0, 1))
        self.exchangeCoin:setPosition(self.dimens_.cx + self.dimens_:getDimens(210), y)        
        self:addView(self.exchangeCoin)
    end

    local y = self.dimens_.cy - self.dimens_:getDimens(100)
    self.btnExit = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
            disable = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
        },
        text = "退出",
        fontSize = self.dimens_:getDimens(26),
        viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
    })
    -- self.btnExit:setScale(self.dimens_.scale_)
    self.btnExit:setAnchorPoint(ccp(0.5, 0.5))
    self.btnExit:setPosition(self.dimens_.cx - self.dimens_:getDimens(220), y)
    self.btnExit:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnExit)

    self.btnAddHp = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_1_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
            disable = self.theme_:getImage("common/common_alert_dialog_btn_1_d.png"),
        },
        text = "加血",
        fontSize = self.dimens_:getDimens(26),
        viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
    })
    -- self.btnAddHp:setScale(self.dimens_.scale_)
    self.btnAddHp:setAnchorPoint(ccp(0.5, 0.5))
    self.btnAddHp:setPosition(self.dimens_.cx, y)
    self.btnAddHp:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnAddHp)

    self.btnContinue = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_alert_dialog_btn_2_n.png"),
            highlight = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png"),
            disable = self.theme_:getImage("common/common_alert_dialog_btn_2_d.png"),
        },
        text = "再来一局",
        fontSize = self.dimens_:getDimens(26),
        viewSize = CCSize(self.dimens_:getDimens(198), self.dimens_:getDimens(76)),
    })
    -- self.btnContinue:setScale(self.dimens_.scale_)
    self.btnContinue:setAnchorPoint(ccp(0.5, 0.5))
    self.btnContinue:setPosition(self.dimens_.cx + self.dimens_:getDimens(220), y)
    self.btnContinue:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnContinue)

    --下次颁奖时间
    --self.isRank = true
    if self.isRank then
        y = self.dimens_.cy - self.dimens_:getDimens(140)

        self.nextAwardTime = jj.ui.JJLabel.new({
            text = "下次颁奖时间",
            fontSize = ftSize,
            align = ui.TEXT_ALIGN_CENTER,
            color = ccc3(152, 236, 255),
        })
        self.nextAwardTime:setAnchorPoint(CCPoint(0.5, 1))
        self.nextAwardTime:setPosition(self.dimens_.cx, y)
        self.nextAwardTime:setVisible(false)
        self:addView(self.nextAwardTime)

        self.nextAwardTime:addScriptEventListener(cc.Event.EXIT_SCENE, function()
            JJLog.i(TAG, "self.nextAwardTime exit")
        end)
    end

    self:showAward()
    --self:updateTaskInfoTest()
end

function IslandWaitView:showAward()
    local matchData = self.viewController_:getMatchData()
    local ad = matchData and matchData.awardData_
    --[[ad = {}
    ad.rank_ = 2
    ad.totalPlayer_ = 96
    ad.matchName_ = "jj比赛"
    ad.awards_ ={{amount=1,type="金币"}, {amount=2,type="金币"}, {amount=3,type="金币"}
                 ,{amount=4,type="金币"}, {amount=5,type="金币"}, {amount=6,type="金币"}}]]
    if ad and ad.rank_ and not self.scrollGrp then
        if self.nextAwardTime then self.nextAwardTime:setVisible(false) end

        local count = (ad.awards_ and #ad.awards_) or 0
        count = count + 1
        local height = count * 30
        self.scrollGrp = jj.ui.JJScrollView.new({direction = jj.ui.JJScrollView.DIRECTION_VERTICAL,
            viewSize = CCSize(self.dimens_:getDimens(630), self.dimens_:getDimens(68))})
        self.scrollGrp:setAnchorPoint(ccp(0.5, 1))
        self.scrollGrp:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(165))
        self:addView(self.scrollGrp)

        local grp = jj.ui.JJViewGroup.new({viewSize=CCSize(self.dimens_:getDimens(630), 
                                                            self.dimens_:getDimens(height))})
        --grp:setScale(self.dimens_.scale_)

        --奖品描述
        local desc = "恭喜您在【" .. (ad.matchName_ or "") ..  "】中获得第“" .. ( ad.rank_ or "") .. "”名"
        desc = desc .. "(" .. ad.rank_ .. "/" .. ad.totalPlayer_ .. ")"
        if ad.awards_ and #ad.awards_ > 0 then
            desc = desc .. "奖品如下："
        end

        local x, y = self.dimens_:getDimens(10), self.dimens_:getDimens(height)
        local lbl = jj.ui.JJLabel.new({
            text = desc,
            fontSize = self.dimens_:getDimens(17),
            align = ui.TEXT_ALIGN_LEFT,
            color = ccc3(255, 255, 0),
        })
        lbl:setAnchorPoint(CCPoint(0, 1))
        lbl:setPosition(x, y)
        grp:addView(lbl)

        --TODO 这部分MatchAwardData解析还有问题，先不出现
        if ad.awards_ and #ad.awards_ > 0 then
            self.awards_ = ad.awards_
            local ware
            for i, item in ipairs(ad.awards_) do
                y = y - self.dimens_:getDimens(23)
                ware = WareInfoManager:getWareItem(item.wareId)

                lbl = jj.ui.JJLabel.new({
                    fontSize = self.dimens_:getDimens(17),
                    align = ui.TEXT_ALIGN_LEFT,
                    color = ccc3(255, 255, 0),
                })
                lbl:setAnchorPoint(CCPoint(0, 1))
                lbl:setPosition(x, y)
                grp:addView(lbl)
                if ware and ware.reward > 0 then --可兑奖
                    desc = "★" .. item.amount .. "  " .. item.type .. "（点击可直接兑奖）"
                    lbl:setText(desc)
                    lbl:setTouchEnable(true)
                    lbl:setOnClickListener(function()
                        -- MainController:pushScene(CURRENT_PACKAGE_ID, JJSceneDef.ID_WEB_VIEW,
                        --                                                     {title = "兑奖中心", back = true, sso = true,
                        --                                                     url = JJWebViewUrlDef.URL_EXCHANGE
                        --                                                      })
                        WebViewController:showActivity({title = "兑奖中心", back = true, sso = true,
                            url = JJWebViewUrlDef.URL_EXCHANGE
                        })
                    end)
                else
                    desc = "★" .. item.amount .. "  " .. item.type
                    lbl:setText(desc)
                    --是否有说明
                    if item.merit and string.len(item.merit) > 0 then
                        lbl:setId(item)
                        lbl:setTouchEnable(true)
                        lbl:setOnClickListener(handler(self, self.onClickAwardItem))
                    end
                end
            end
        end

        self.scrollGrp:setContentView(grp)
    end
end

function IslandWaitView:onExit()
    self.destroyed = true

    if self.checkTime then
        scheduler.unscheduleGlobal(self.checkTime)
        self.checkTime = nil
    end

    if self.awardDlg then
        self.awardDlg:dismiss()
        self.awardDlg = nil
    end
end

function IslandWaitView:checkTimeSpan()
    if not self.destroyed then
        self:setTime()
        local ld = self.viewController_:getGameData()
        if self.awardTimeSpan and ld and ld:getWaitState() == JJGameStateDefine.WAIT_STATE_ISLAND
            and self.data and self.data.startTime_ and self.data.startTime_ > 0 then
            local dif = JJTimeUtil:getCurrentSecond() - self.data.startTime_
            if self.restSec <= dif then
                if self.checkTime then
                    scheduler.unscheduleGlobal(self.checkTime)
                    self.checkTime = nil
                end
                self.viewController_:exitMatch(true)
            end
        end
    end
end

function IslandWaitView:setTime()
    if self.nextAwardTime and self.data and self.data.startTime_ > 0 and not self.destroyed then
        local dif = math.modf(JJTimeUtil:getCurrentSecond() - self.data.startTime_)
        if self.awardTimeSpan ~= 0 then
            while self.nextAwardSec <= dif do
                self.nextAwardSec = self.nextAwardSec + self.awardTimeSpan
            end
            if self.isRank then
                self.nextAwardTime:setVisible(true)
                self.nextAwardTime:setText("下次颁奖时间 " .. JJTimeUtil:formatTimeString(self.nextAwardSec - dif))
            end
        else
            self.nextAwardTime:setVisible(false)
        end
    end
end

function IslandWaitView:getCurrentLife()
    local matchData = self.viewController_:getMatchData()
    self.data = matchData and matchData.islandData_
    return self.data and self.data.life_
end

function IslandWaitView:updateTaskInfo()
    self.taskData = {}
    local md = self.viewController_:getMatchData()
    local show1, show2, show3 = 0, 0, 0
    if md then
        local index = 1
        local awardList = md.gameCountAwardInfo_
        if awardList then
            --先找秋卡
            for i, ad in ipairs(awardList) do
                if ad.name_ ~= "积分加倍" then
                    local st, et = string.find(ad.note_, "秋卡")
                    if st and et then 
                        local finishCount = md.finishCount%ad.rulers_[1].max_
                        local strCCAward = nil                           
                        st, et = string.find(ad.note_, "%d+")
                        if st and et then 
                            st, et = string.find(ad.note_, "%d+", et+1)
                            if st and et then                                     
                                strCCAward = string.sub(ad.note_, st)
                            end
                        end

                        self.taskData[index] = {
                            name = ad.rulers_[1].max_ .. "副牌奖励：",
                            award = strCCAward or ad.note_,
                            finishNum = finishCount, --已完成任务数
                            totalNum = ad.rulers_[1].max_,  --总任务数
                            --showProgress = true,
                        }
                        index = index + 1
                        show2 = show2 + 1
                        if show2 == 2 then break end
                    end
                end
            end

            if show2 < 2 then 
                for i, ad in ipairs(awardList) do
                    if ad.name_ ~= "积分加倍" then
                        local st, et = string.find(ad.note_, "秋卡")
                        if not st then 
                            local finishCount = md.finishCount%ad.rulers_[1].max_
                            local strCCAward = nil                           
                            st, et = string.find(ad.note_, "%d+")
                            if st and et then 
                                st, et = string.find(ad.note_, "%d+", et+1)
                                if st and et then                                     
                                    strCCAward = string.sub(ad.note_, st)
                                end
                            end

                            self.taskData[index] = {
                                name = ad.rulers_[1].max_ .. "副牌奖励：",
                                award = strCCAward or ad.note_,
                                finishNum = finishCount, --已完成任务数
                                totalNum = ad.rulers_[1].max_,  --总任务数
                                --showProgress = true,
                            }
                            index = index + 1
                            show2 = show2 + 1
                            if show2 == 2 then break end
                        end
                    end
                end
            end
           --[[ if index > 1 then --添加分割线
                self.taskData[index] = {sepLine=true}
                index = index + 1
                show1 = 1
            end]]
        end

        local nWin = md.CVWin_
        awardList = md.cvAwardList_
        local count = 1
        if awardList then            
            for i, ad in ipairs(awardList) do
                if ad.count_ > nWin or count == #awardList then
                    self.taskData[index] = {
                        name = string.format("%d连胜奖励：", ad.count_),
                        award = ad.name_,
                        finishNum = nWin, --已完成任务数
                        totalNum = ad.count_,  --总任务数
                    }
                    index = index + 1
                    show3 = show3 + 1
                    if index > 3 then break end
                end
                count = count + 1
            end
        end
    end
  
    local showList = nil

    --if show1 > 0 then
        if show2 == 0 then --没有定副
            if show3 > 1 then
                showList = {self.taskData[1],self.taskData[2]}
            elseif show3 == 1 then 
                showList = {self.taskData[1]}
            end
        else --连胜，定副            
            if show2 == 2 then 
                if show3 == 0 then --显示2个定副
                    showList = {self.taskData[2],self.taskData[1]}
                else  --连胜，定副
                    showList = {self.taskData[3], self.taskData[1]}
                end
            elseif show2 == 1 then 
                if show3 == 0 then --显示1个定副
                    showList = {self.taskData[1]}
                else  --连胜，定副
                    showList = {self.taskData[2], self.taskData[1]}
                end
            end
        end
    --else
    --    showList = {self.taskData[1],self.taskData[2]}
    --end

    if #self.taskData > 0 then
        if self.tableView then self:removeView(self.tableView) end
        self.tableView = require("game.ui.view.TaskListView").new({
            theme = self.theme_,
            dimens = self.dimens_,
            taskList = showList,
            width = self.dimens_:getDimens(530),
            height = self.dimens_:getDimens(110),
        })
        self.tableView:setAnchorPoint(ccp(0.5,0.5))
        --self.tableView:setScale(self.dimens_.scale_)
        self.tableView:setPosition(self.dimens_.cx, self.dimens_.cy-self.dimens_:getDimens(10))
        self:addView(self.tableView)
        if not self.bg:isVisible() then
            self.tableView:setVisible(false)
        end
    end
end
--[[
function IslandWaitView:updateTaskInfoTest()
self.taskData = {}
local index = 1
self.taskData[index] = {
name = "每完成1局获得2秋卡",
award = "",
finishNum = 1, --已完成任务数
totalNum = 2,  --总任务数
}
index = index + 1

if index > 1 then --添加分割线
self.taskData[index] = {sepLine=true}
index = index + 1
end

self.taskData[index] = {
name = string.format("%d连胜奖励：", 1),
award = "2金币",
finishNum = 1, --已完成任务数
totalNum = 1,  --总任务数
}
index = index + 1
self.taskData[index] = {
name = string.format("%d连胜奖励：", 2),
award = "4金币",
finishNum = 1, --已完成任务数
totalNum = 2,  --总任务数
}

if #self.taskData > 0 then
if self.tableView then self:removeView(self.tableView) end
self.tableView = require("game.ui.view.TaskListView").new({
theme = self.theme_,
dimens = self.dimens_,
taskList = {self.taskData[1],self.taskData[2],self.taskData[3],self.taskData[4]},
width = 530,
height = 110,
})
self.tableView:setAnchorPoint(ccp(0.5,0.5))
self.tableView:setScale(self.dimens_.scale_)
self.tableView:setPosition(self.dimens_.cx, self.dimens_.cy+self.dimens_:getDimens(5))
self:addView(self.tableView)
if not self.bg:isVisible() then
self.tableView:setVisible(false)
end
end
end]]

function IslandWaitView:getCoin()
    local matchData = self.viewController_:getMatchData()
    self.data = matchData and matchData.islandData_

    if self.data and (self.data.exchangeRate_ and self.data.exchangeRate_ > 0) and (self.data.life_ and self.data.life_ >= 0) then
        JJLog.i("lifeng", "getCoin",self.data.exchangeRate_,self.data.life_)
        return math.floor(tonumber(self.data.life_/self.data.exchangeRate_))
    else
        return 0
    end
end

function IslandWaitView:showAllUiInfo(flag)
    self.bg:setVisible(flag)
    self.life:setVisible(flag)
    self.lblLife:setVisible(flag)
    if self.nextAwardTime then self.nextAwardTime:setVisible(flag) end
    if self.tableView then self.tableView:setVisible(flag) end
    self.btnExit:setVisible(flag)
    self.btnAddHp:setVisible(flag)
    self.btnContinue:setVisible(flag)
    self.line:setVisible(flag)
    if self.exchangeLab then self.exchangeLab:setVisible(flag) end
    if self.exchangeCoin then self.exchangeCoin:setVisible(flag) end
    if self.scrollGrp then self.scrollGrp:setVisible(flag) end
    if flag then self.addHpView_ = nil end
end

function IslandWaitView:onClickAwardItem(target)
    local item = target and target:getId()
    if item then
        self.awardDlg = require("game.ui.view.AlertDialog").new({
            title = item.type,
            prompt = item.merit,
            onDismissListener = function() self.awardDlg = nil end,
            dimens = self.dimens_,
            theme = self.theme_
        })

        self.awardDlg:setButton1("确定")
        self.awardDlg:show(self.viewController_.scene_)
    end
end

function IslandWaitView:askLeaveIsland()
    local prompt_ = "您确定要退出比赛吗？"
    local matchData = self.viewController_:getMatchData()
    self.data = matchData and matchData.islandData_

    if self:getCoin()>0 then
        prompt_ = string.format("您确定要退出比赛吗？您现在的生命值%d可兑换%d个%s。",self.data.life_,self:getCoin(),"金币")
    end
    self.dialogLeaveIsland = require("game.ui.view.AlertDialog").new({
        title = "提示",
        prompt = prompt_,
        onDismissListener = function () self.dialogLeaveIsland = nil end,
        dimens = self.dimens_,
        theme = self.theme_
    })
    self.dialogLeaveIsland:setButton1("确认", function ()
        self.viewController_:exitMatch(true)
    end)
    --self.dialogLeaveIsland:setButton2("取消", function ()  end)
    self.dialogLeaveIsland:setCloseButton(function () end)
    self.dialogLeaveIsland:show(self)
end

function IslandWaitView:onBackPressed()
    local ret = false
    if self.dialogAddHp and self.dialogAddHp:isShowing() then
        self.dialogAddHp:dismiss()
        self.dialogAddHp = nil
        ret = true
    elseif self.addHpView_ and self.addHpView_:isVisible() then
        self:removeView(self.addHpView_)
        self:showAllUiInfo(true)
        self.addHpView_ = nil
        ret = true
    elseif self.dialogLeaveIsland and self.dialogLeaveIsland:isShowing() then
        self.dialogLeaveIsland:dismiss()
        self.dialogLeaveIsland = nil
        ret = true
    else
        self:askLeaveIsland()
        ret = true
    end
    return ret
end

function IslandWaitView:onClick(target)
    if target == self.btnContinue then
        self.controller:showProgressDlg(true,"组桌中，请稍候...")
        MatchMsg:sendContinueReq(self.viewController_:getMatchId(), UserInfo.userId_)        
    elseif target == self.btnExit then
        self:askLeaveIsland()
    elseif target == self.btnAddHp then
        if #self.bottleList_>0 then
            self:showAllUiInfo(false)
            self.addHpView_ = require("game.ui.view.AddHpView").new({
                theme = self.theme_,
                dimens = self.dimens_,
                width = self.dimens_:getDimens(600),
                height = self.dimens_:getDimens(280),
                life = self:getCurrentLife(),
                bottleList = self.bottleList_,
                parent = self,
            })
            self.addHpView_:setAnchorPoint(ccp(0.5,0.5))
            self.addHpView_:setPosition(self.dimens_.cx, self.dimens_.cy-self.dimens_:getDimens(20))
            self:addView(self.addHpView_)
        end
    end
end



function IslandWaitView:addHpViewOnClick(target)
    local targetId = target:getId()
    if targetId and self.data and self.data.bottles_ 
        and #self.data.bottles_ >= targetId and self.data.bottles_[targetId] then
        self.cost_ = self.data.bottles_[targetId].cost
        local blood_ = self.data.bottles_[targetId].blood
        self.orgGold_= UserInfo.gold_

        if UserInfo.gold_ >= self.cost_ then
            local prompt_ = string.format("您确定要花费%d个%s购买%d生命值吗？",self.cost_,"金币",blood_)
            self.dialogAddHp = require("game.ui.view.AlertDialog").new({
                title = "提示",
                prompt = prompt_,
                onDismissListener = function () self.dialogAddHp = nil end,
                dimens = self.dimens_,
                theme = self.theme_
            })
            self.dialogAddHp:setButton1("确认", function ()
                local matchId = self.viewController_:getMatchId()
                local addHp = self.data.bottles_[targetId].blood
                MatchMsg:sendHematinicReq(matchId, UserInfo.userId_, addHp)
            end)
            --self.dialogAddHp:setButton2("取消", function ()  end)
            self.dialogAddHp:setCloseButton(function () end)
            self.dialogAddHp:show(self)
        else
            local prompt_ = string.format("您当前不足%d个%s，不能购买生命值！",self.cost_,"金币")
            self.dialogAddHp = require("game.ui.view.AlertDialog").new({
                title = "提示",
                prompt = prompt_,
                onDismissListener = function () self.dialogAddHp = nil end,
                dimens = self.dimens_,
                theme = self.theme_
            })
            self.dialogAddHp:setCloseButton(function () end)
            --self.dialogAddHp:setButton1("确认", function ()  end)
            self.dialogAddHp:setButton1("充值", function () 
                local pcm = require("game.data.config.PayConfigManager")
                PayDef:chargeBtnHandler(pcm:getParam())
            end)
            self.dialogAddHp:show(self)
        end
    end
end

function IslandWaitView:refreshMoney()
    if self.addHpView_ then
        self.addHpView_:refreshMoney()
    end
end

function IslandWaitView:addHPResult(result)
    if result then
        local matchData = self.viewController_:getMatchData()
        self.data = matchData and matchData.islandData_

        local currentHp = self.data and self.data.life_

        if currentHp then           
            self.lblLife:setText(self.data.life_)
            if self.exchangeCoin then
                self.exchangeCoin:setText(self:getCoin())
            end
            if self.addHpView_ then
                self.addHpView_:setLife(self.data.life_)
                self.addHpView_:refreshMoney(self.orgGold_ - self.cost_)
            end
        end

        if self.addHpView_ then
            self.addHpView_:removeSelf(true)
            self:showAllUiInfo(true)
            self.addHpView_ = nil
        end
    end
end


function IslandWaitView:recvAward()
    self.nextAwardSec = self.nextAwardSec + self.awardTimeSpan
    self:showAward()
end

function IslandWaitView:onHematinicAck(flag)
    if flag then
        jj.ui.JJToast:show({ text = "加血成功！" ,dimens = self.dimens_})
    else
        jj.ui.JJToast:show({ text = "加血失败！" ,dimens = self.dimens_})
    end

    self:addHPResult(flag)
end

return IslandWaitView