local PersonalInfoCenterSceneController = class("PersonalInfoCenterSceneController", require("game.ui.controller.JJGameSceneController"))
local TAG = "PersonalInfoCenterSceneController"

PersonalInfoCenterSceneController.matchData_ = {}

--[[
    参数
    @params:
        @packageId
        @games: 支持的游戏
            @gameId:
            @name:
            @growId:
]]

--获取胜率等数据
function PersonalInfoCenterSceneController:askGetData()
    JJLog.i(TAG, "PersonalInfoCenterSceneController:askGetData")
    require("game.pb.HbaseMsg")
    if self.params_.games and #self.params_.games > 0 then
        for i=1, #self.params_.games do
            HbaseMsg:sendGetTechStatisticsReq(self.params_.games[i].gameId, UserInfo.userId_)
            HttpMsg:sendGetRankInMatchReq(self.params_.games[i].gameId, UserInfo.userId_)
            LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, self.params_.games[i].growId)
        end
    end
    --vipconfig 数据
    local gid, count = require("game/data/config/VIPConfig"):getVipGrowsInfo()
    if count == 0 then 
        LobbyMsg:sendGetSingleGrowReq(UserInfo.userId_, gid)
    end
end

function PersonalInfoCenterSceneController:handleMsg(msg)
    PersonalInfoCenterSceneController.super.handleMsg(self, msg)

    if msg.type == SDKMsgDef.TYPE_NET_MSG then
        if msg[MSG_CATEGORY] == HBASE_ACK_MSG and msg[MSG_TYPE] == HBASE_GET_TECH_STATICS_ACK then
            if not self.matchData_[msg.gameid] then
                self.matchData_[msg.gameid] = {}
            end
            self.matchData_[msg.gameid].winhand = msg.winhand
            self.matchData_[msg.gameid].totalhand = msg.totalhand

            self.scene_:refreshData()

        elseif msg[MSG_CATEGORY] == HTTP_ACK_MSG and msg[MSG_TYPE] == COMMON_HTTP_GET_RANK_IN_MACTCH_ACK then
            if not self.matchData_[msg.gameid] then
                self.matchData_[msg.gameid] = {}
            end
            self.matchData_[msg.gameid].rank = msg.rank
            self.matchData_[msg.gameid].score = msg.score
            self.scene_:refreshData()

        elseif msg[MSG_CATEGORY] == LOBBY_ACK_MSG then
            if msg[MSG_TYPE] == GETSINGLEGROW_ACK then
                self.scene_:refreshData()
            elseif msg[MSG_TYPE] == PUSHACCNUMMONEY_ACK or msg[MSG_TYPE] == PUSH_USER_MONEY_ACK then
                self.scene_:refreshData(true)
            elseif msg[MSG_TYPE] == TOURNEYSIGNUPEX_ACK then
                -- self.scene_:refreshNoteMsg()
            elseif msg[MSG_TYPE] == GETUSERALLWARE_ACK then --断线重连处理
                self:askGetData()
                self.scene_:refreshData(true, true)
            end
        end
    elseif msg.type == GameMsgDef.ID_UPDAGE_HEAD_IMG then
        self.scene_:refreshHeadImg(tonumber(msg.headId), true)
    -- elseif msg.type == GameMsgDef.ID_NOTE_MSG_READ_STATE_CHANGE then
    --     self.scene_:updateMsgNum()
    end
end

function PersonalInfoCenterSceneController:getWinRate(gameId)
    local win, total = 0, 0
    if self.matchData_ and self.matchData_[gameId] then
        win, total = self.matchData_[gameId].winhand, self.matchData_[gameId].totalhand
    end
    win = win or 0
    total = total or 0
    return win, total
end

function PersonalInfoCenterSceneController:getRankInMatchScore(gameId)
    local rank, score = 0, 0
    if self.matchData_ and self.matchData_[gameId] then
        rank, score = self.matchData_[gameId].rank, self.matchData_[gameId].score
    end
    rank = rank or 0
    score = score or 0
    return rank, score
end

function PersonalInfoCenterSceneController:showMsg()
    self.scene_:showMsg()
end

function PersonalInfoCenterSceneController:toHelpScene()
    MainController:pushScene(self.params_.packageId, JJSceneDef.ID_PERSONAL_CENTER_HELP)
end

function PersonalInfoCenterSceneController:toBindPhoneScene()
    self:toWebView("绑定手机", JJWebViewUrlDef.URL_ACCOUNT)
end

function PersonalInfoCenterSceneController:toGetInvertoryScene()
    self:toWebView("财物领取", JJWebViewUrlDef.URL_GET_LIST)
end

function PersonalInfoCenterSceneController:toSecureCenterScene()
    if self:isJJAccount() then 
        self:toWebView("安全中心", JJWebViewUrlDef.URL_ACCOUNT)
    end
end

function PersonalInfoCenterSceneController:toSafeBoxScene()
    if self:isJJAccount() then 
        self:toWebView("保险箱", JJWebViewUrlDef.URL_COFFER)
    end
end

function PersonalInfoCenterSceneController:toModifyNameScene()
    if self:isJJAccount() then 
        self:toWebView("修改昵称", JJWebViewUrlDef.URL_MODIFY_NICKNAME)
    end
end

function PersonalInfoCenterSceneController:toModifyHeadIconScene()
    if self:isJJAccount() then 
        self:toWebView("修改头像", JJWebViewUrlDef.URL_MODIFY_FIGURE, true, true,
                            handler(self, self.updateHeadImg))
    end
end

function PersonalInfoCenterSceneController:toAccountQueryScene()
    self:toWebView("账单查询", JJWebViewUrlDef.URL_MONEY_ACCOUNT)
end

function PersonalInfoCenterSceneController:toGetGoldScene()
    self:toWebView("领取财物", JJWebViewUrlDef.URL_GET_LIST)
end

function PersonalInfoCenterSceneController:toGetCardScene()
    self:toWebView("领参赛卡", JJWebViewUrlDef.URL_GET_LIST)
end

function PersonalInfoCenterSceneController:toWebView(titleStr, urlStr, isBack, isSSo, listener_)
    isBack = isBack or true
    isSSO = isSSO or true

    -- MainController:pushScene(self.params_.packageId, JJSceneDef.ID_WEB_VIEW, {
    --                             title = titleStr,
    --                             back = isBack,
    --                             sso = isSSO,
    --                             url = urlStr,
    --                             listener = listener_,
    --                         })
    require("game.ui.controller.WebViewController"):showActivity({
                                title = titleStr,
                                back = isBack,
                                sso = isSSO,
                                url = urlStr,
                            })
end

function PersonalInfoCenterSceneController:updateHeadImg(result)
    JJLog.i("linxh", "updateHeadImg")

    if result and result.headImg and result.headImg == "true" then
        --self.updateHeadImg_ = true
        HeadImgManager:delImg(UserInfo.userId_)
    end

end

--[[
    点击注册
]]
function PersonalInfoCenterSceneController:onClickRegister()
    JJLog.i(TAG, "onClickRegister")
    local id = MainController:getRegisterSceneId(self.params_.packageId)
    MainController:pushScene(self.params_.packageId, id)
end

function PersonalInfoCenterSceneController:isJJAccount()
    local ret = true
    if (LoginController.loginState_ == LoginController.STATE_LOGIN) and (LoginController.type_ == LOGIN_TYPE_NOREG) then
        self.scene_:showGuideToBindNoRegDialog(true)
        ret = false
    end
    return ret 
end

function PersonalInfoCenterSceneController:onBackPressed()
    if self.scene_ and self.scene_:onBackPressed() then
        return true
    else
        PersonalInfoCenterSceneController.super.onBackPressed(self)
    end
end

return PersonalInfoCenterSceneController