-- 奖状界面
--[[ 如果重载了该view必须实现以下方法
无
]]
local DiplomaView = class("DiplomaView", require("game.ui.view.JJMatchView"))

local DynamicDisplayManager = require("game.data.config.DynamicDisplayManager")

function DiplomaView:ctor(viewController, startGameParam)
    DiplomaView.super.ctor(self, viewController)
    self.startGameParam_ = startGameParam
    if startGameParam and startGameParam.gameId_ then
        self.gameId_ = startGameParam.gameId_
        self.isLordSingle_ = (self.gameId_ == JJGameDefine.GAME_ID_LORD_SINGLE)
        if self.isLordSingle_ then
            self.resultData_ = viewController:getResultData()
        end
    end
    self.viewController_ = viewController
    self.gameId_ = self.gameId_ or self.viewController_.gameId_
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("diploma/diploma_view_bg.jpg")
    })
    bg:setPosition(self.dimens_.cx, self.dimens_.cy)
    bg:setScaleX(self.dimens_.wScale_)
    bg:setScaleY(self.dimens_.hScale_)
    self:addView(bg)

    self.diploma = require("game.ui.view.Diploma").new(self.viewController_)
    self.diploma:setAnchorPoint(CCPoint(0.5, 0.5))
    self.diploma:setPosition(self.dimens_.cx, self.dimens_.cy + self.dimens_:getDimens(40))
    --self.diploma:setScale(self.dimens_.scale_)
    self:addView(self.diploma)


    local tid = (self.startGameParam_ and self.startGameParam_.tourneyId_) or 0
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(tid)

    if tourneyInfo then
        if tourneyInfo.status_ == nil then --修正断线重连后 tourneyInfo.status_ 为nil情况
           TourneyController:checkSignupReqirement(tourneyInfo)
        end
    end

    local bSignup = tourneyInfo and
            (tourneyInfo.status_ == MatchDefine.STATUS_SIGNUPABLE
             or tourneyInfo.status_ == MatchDefine.STATUS_SIGNOUTABLE)
            and (tourneyInfo.matchconfig_ and
                    (tourneyInfo.matchconfig_.matchType == tostring(MatchDefine.MATCH_TYPE_TIMELY))
                ) or self.isLordSingle_
    --bSignup = true
    --exit
    local y = self.dimens_:getDimens(95)
    local x = (bSignup and self.dimens_.cx - self.dimens_:getDimens(220)) or (self.dimens_.cx - self.dimens_:getDimens(130))
    self.exitBtn_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("diploma/diploma_btn_red_n.png"),
            highlight = self.theme_:getImage("diploma/diploma_btn_red_d.png"),
            disable = self.theme_:getImage("diploma/diploma_btn_red_d.png")
        },
        fontSize = self.dimens_:getDimens(26),
        color = display.COLOR_WHITE,
        text = "返回大厅",
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_CENTER,
        viewSize = CCSize(self.dimens_:getDimens(180), self.dimens_:getDimens(80))
    })
    self.exitBtn_:setAnchorPoint(ccp(0.5, 1))
    self.exitBtn_:setPosition(x, y)
    --self.exitBtn_:setScale(self.dimens_.scale_)
    self.exitBtn_:setOnClickListener(handler(self, self.onClickBtn))
    self:addView(self.exitBtn_)

    --signup
    --bSignup = false
    if bSignup then
        self.signupBtn_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("diploma/diploma_btn_red_n.png"),
                highlight = self.theme_:getImage("diploma/diploma_btn_red_d.png"),
                disable = self.theme_:getImage("diploma/diploma_btn_red_d.png")
            },

            fontSize = self.dimens_:getDimens(26),
            color = display.COLOR_WHITE,
            text = "再玩一次",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(180), self.dimens_:getDimens(80))
        })
        self.signupBtn_:setAnchorPoint(ccp(0.5, 1))
        self.signupBtn_:setPosition(self.dimens_.cx, y)
        --self.signupBtn_:setScale(self.dimens_.scale_)
        self.signupBtn_:setOnClickListener(handler(self, self.onClickBtn))
        self:addView(self.signupBtn_)
    end

    --share
    local allowShare = DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_SHARE) or DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR)
    --allowShare = false
    if allowShare then
        x = (bSignup and self.dimens_.cx + self.dimens_:getDimens(220)) or (self.dimens_.cx + self.dimens_:getDimens(130))        
        self.shareBtn_ = jj.ui.JJButton.new({
            images = {
                normal = self.theme_:getImage("diploma/diploma_btn_green_n.png"),
                    highlight = self.theme_:getImage("diploma/diploma_btn_green_d.png"),
                    disable = self.theme_:getImage("diploma/diploma_btn_green_d.png")
            },
            fontSize = self.dimens_:getDimens(26),
            color = display.COLOR_WHITE,
            text = "分享好友",
            align = ui.TEXT_ALIGN_CENTER,
            valign = ui.TEXT_VALIGN_CENTER,
            viewSize = CCSize(self.dimens_:getDimens(180), self.dimens_:getDimens(80))
        })
        self.shareBtn_:setAnchorPoint(ccp(0.5, 1))
        self.shareBtn_:setPosition(x, y)
        --self.shareBtn_:setScale(self.dimens_.scale_)
        self.shareBtn_:setOnClickListener(handler(self, self.onClickBtn))
        self:addView(self.shareBtn_)
    end

    if not allowShare then 
        if self.signupBtn_ then 
            self.exitBtn_:setPositionX(self.dimens_.cx - self.dimens_:getDimens(130))
            self.signupBtn_:setPositionX(self.dimens_.cx + self.dimens_:getDimens(130))
        else
            self.exitBtn_:setPositionX(self.dimens_.cx)
        end
    elseif not bSignup and self.shareBtn_ then 
        self.exitBtn_:setPositionX(self.dimens_.cx - self.dimens_:getDimens(130))
        self.shareBtn_:setPositionX(self.dimens_.cx + self.dimens_:getDimens(130))
    end

    self:initData()
end

function DiplomaView:onEnter()
    DiplomaView.super.onEnter(self)
    --[[if self.rank_ and self.rank_ == 1 and not self.viewController_.shareChampion then
        --获得了冠军，弹出分享提示框
        self.viewController_:onFunction(self.viewController_.TYPE_CLICK_SHOW_CHAMPION)
    end]]
    --JJLog.i("linxh", "DiplomaView:onEnter, flag=", self.viewController_.doHonorRoomShare_, ", dlg=", self.viewController_.showDiplomaInputDlg_)
    if self.viewController_.doHonorRoomShare_ or self.viewController_.showDiplomaInputDlg_ then
        self:doHonorRoomShare()
    end
end

function DiplomaView:onExit()
    self:onBackPressed()
end

function DiplomaView:onPause()
    self:onBackPressed()
end

function DiplomaView:onBackPressed()
    local ret = false
    if self.commentInputDlg_ and self.commentInputDlg_:isShowing() then
        self:showDiplomaCommentDlg(false)
        ret = true
    elseif self.resignupDlg_ and self.resignupDlg_:isShowing() then
        -- self:showReSignupDlg(false)
        ret = true
    end
    return ret
end

function DiplomaView:initData()
    if self.isLordSingle_ then
        if self.resultData_ then
        	self.diploma:setRank(self.resultData_.rank_)
        	self.diploma:setDiplomaDesc(string.format("%s\n%s", self.resultData_.diplomaDesc_, self.resultData_.diplomaGold_))
        end
    else
        local matchData = self.viewController_:getMatchData()

        local awardData = matchData and matchData.awardData_
        if awardData then
            --排名
            self.diploma:setRank(awardData.rank_)

            --描述
            local desc = string.format("%s，恭喜您在【%s】中获得第%d名",UserInfo.nickname_,awardData.matchName_,awardData.rank_)
            if awardData.totalPlayer_ > 0 then
                desc = desc .. "(" .. awardData.rank_  .. "/"  .. awardData.totalPlayer_ .. ")"
            end
            desc = desc .. "！" .. awardData.historyNote_
            self.diploma:setDiplomaDesc(desc)

            --奖品列表
            self.diploma:setAwardGlod(awardData.awards_)

            self.rank_ = awardData.rank_
            self.matchName = awardData.matchName_
        end
    end
end

function DiplomaView:showDiplomaCommentDlg(flag)
    if flag then
        --JJLog.i("linxh", "showDiplomaCommentDlg 1")
        self.commentInputDlg_ = self.commentInputDlg_ or require("game.ui.view.DiplomaCommentDialog").new(self.viewController_,
                                {
                                    theme = self.theme_,
                                    dimens = self.dimens_,
                                    onDismissListener = function()
                                                        self.commentInputDlg_ = nil end
                                })
        self.commentInputDlg_:setOkListener(function(text)
                                            self:shareToHonorRoom(text)
                                            end)
        self.commentInputDlg_:show(self.viewController_.scene_)
    elseif self.commentInputDlg_ then
        self.commentInputDlg_:dismiss()
        self.commentInputDlg_ = nil
    end
end

function DiplomaView:shareToHonorRoom(strComment)
    self.viewController_.showedHonor = true
    --JJLog.i("linxh", "shareToHonorRoom")
    --local test = [[<Award MaxPlayer="96" GameId="1001" Comment="我刚赢了500元话费，快来关注我吧" NickName="jlin_lxh" MatchName="斗地主免费赢1元手机充值卡" MPID="438" TourneyID="1168860" MatchID="1197871245" UserID="184728997" Rank="1" MatchBeginTime="(14-04-03 16:43)" PlayerAmount="96"> <M ID="金币"  V="50" /> <S ID="经验"  V="200" /> <H Note="恭喜！您在本赛事中曾荣获过1次“冠军”，加油！(14-04-03 16:59)" /> </Award>]]
    --local RoarInterface = require("game.thirds.RoarInterface")
    --RoarInterface:postGloryReq(tostring(test), 1, 1)
    --jj.ui.JJToast:show({text="奖状已晒到荣誉室，可进入“咆哮”选择“荣誉室”查看！",dimens = self.dimens_})

    local matchData = self.viewController_:getMatchData()
    local awardData = matchData and matchData.awardData_

    if awardData and awardData.xml then
        strComment = strComment or ""
        local strInsert = string.format(" MaxPlayer=\"%d\" GameId=\"%d\" Comment=\"%s\" NickName=\"%s\" ",
                                         awardData.totalPlayer_, self.gameId_, strComment, awardData.nickName_)
        local strContent = string.gsub(awardData.xml, " ", strInsert, 1)
        --JJLog.i("linxh", "shareToHonorRoom, context=", strContent)
        local RoarInterface = require("game.thirds.RoarInterface")
        RoarInterface:postGloryReq(strContent, 1, awardData.rank_)
        --askSendRoar
        jj.ui.JJToast:show({text="奖状已晒到荣誉室，可进入“咆哮”选择“荣誉室”查看！",dimens = self.dimens_})
    end
end

function DiplomaView:onHonorRoomShare()
    --JJLog.i("linxh", "onHonorRoomShare")
    self.viewController_.doHonorRoomShare_ = true
end

function DiplomaView:doHonorRoomShare()
    --JJLog.i("linxh", "doHonorRoomShare")
    self.viewController_.doHonorRoomShare_ = nil
    if self.viewController_.showedHonor then
        --JJLog.i("linxh", "doHonorRoomShare 1")
        jj.ui.JJToast:show({text="您已经晒过奖状！",dimens = self.dimens_})
    else
        --JJLog.i("linxh", "doHonorRoomShare 2")
        self:showDiplomaCommentDlg(true)
    end
end

function DiplomaView:onShare()
    if self.onSharing then return end

    self.onSharing = true
    --self.rank_ = 1
    local desc
    if self.isLordSingle_ then
        desc = self.resultData_.diplomaDesc_
    else
        local rk = string.format("第%d名", self.rank_)
        if self.rank_ == 1 then rk = "冠军" end
        local award = self.diploma:getFirstAward()

        if award and string.len(award) > 0 then
            desc = string.format("我刚刚在%s--%s中获得了%s，赢得了%s，太给力啦！#JJ比赛http://www.jj.cn",
                                  self:getGameName(), self.matchName, rk, award)
        else
            desc = string.format("我刚刚在%s--%s中获得了%s，太给力啦！#JJ比赛http://www.jj.cn",
                                  self:getGameName(), self.matchName, rk)
        end
    end
    local img = self.diploma:snapImage()
    require("game.thirds.ShareInterface"):startShowShare(desc, img, 1, handler(self, self.onHonorRoomShare), self.isLordSingle_, DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_ROAR))
    --require("game.thirds.ShareInterface"):startShowShare(desc, img, 1, handler(self, self.onHonorRoomShare), self.isLordSingle_, true)
    self.onSharing = false
end

function DiplomaView:getGameName()
    local str = ""
    if RUNNING_MODE == RUNNING_MODE_HALL then
        str = "JJ比赛"
    else
        str = require("game.util.JJGameUtil"):getGameName(MainController:getCurPackageId())
    end
    return str
end

function DiplomaView:onClickBtn(target)
    if target == self.signupBtn_ then
        self.viewController_:reSignupMatch()
    elseif target == self.exitBtn_ then
        self.viewController_:exitMatch(true)
    elseif target == self.shareBtn_ then
        if DynamicDisplayManager:canDisplay(DynamicDisplayManager.DISPLAY_TYPE_SHARE) == false then
            --self:onShare()
            self:doHonorRoomShare()
            self:onHonorRoomShare()
        else
            self:onShare()
        end
    end
end

return DiplomaView