local MoreGameScene = class("MoreGameScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "MoreGameScene"
require("game.data.config.MoreGameManager")
local JJGameUtil = import("game.util.JJGameUtil")


function MoreGameScene:onDestory()
    JJLog.i(TAG, "onDestory")

    self.backBtn_ = nil
    self.btnAllGame = nil
    self.scrollView_ = nil
end

local ITEM_WITH = 184
local ITEM_HEIGHT = 390

function MoreGameScene:initView()
    JJLog.i(TAG, "initView")
    MoreGameScene.super.initView(self)

    self:setBackBtn(false)
    self:setTitle(self.theme_:getImage("moregame/more_game_title.png"))
    self:setBg(self.theme_:getImage("moregame/more_game_back.jpg"))

    local dimens = self.dimens_

    self.backBtn_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("moregame/more_game_back_n.png"),
            highlight = self.theme_:getImage("moregame/more_game_back_d.png")
        },
    })
    self.backBtn_:setAnchorPoint(ccp(0, 1))
    self.backBtn_:setPosition(self.dimens_:getDimens(15), self.dimens_.height - self.dimens_:getDimens(15))
    self.backBtn_:setScale(self.dimens_.scale_)
    self.backBtn_:setOnClickListener(function() self.controller_:onBackPressed() end)
    self:addView(self.backBtn_)

    self.btnAllGame = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("moregame/more_game_all_n.png"),
            highlight = self.theme_:getImage("moregame/more_game_all_d.png"),
        },
        viewSize = CCSize(60, 52),
    })
    self.btnAllGame:setScale(self.dimens_.scale_)
    self.btnAllGame:setAnchorPoint(ccp(1, 1))
    self.btnAllGame:setPosition(dimens.width - dimens:getDimens(15), dimens.height - dimens:getDimens(15))
    self.btnAllGame:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnAllGame)

    self.scrollView_ = jj.ui.JJScrollView.new({
        viewSize = CCSize(854, ITEM_HEIGHT),
        direction = jj.ui.JJScrollView.DIRECTION_HORIZONTAL
    })
    self.scrollView_:setPosition(0, 0)
    self.scrollView_:setScale(dimens.scale_)
    self.scrollView_:setAnchorPoint(ccp(0, 0))
    self:addView(self.scrollView_)

    self:refreshGameList()
end

function MoreGameScene:getButtonsGroup(datas)
    local len = #datas

    JJLog.i(TAG, "getButtonsGroup", len)

    local groupWidth = ITEM_WITH * len

    local viewGroup = jj.ui.JJViewGroup.new({
        viewSize = CCSize(groupWidth, ITEM_HEIGHT),
    })
    viewGroup:setAnchorPoint(ccp(0, 0))
    viewGroup:setPosition(0, 0)

    local index = 0
    for k, v in pairs(datas) do

        local img = v.ImgLocal
        if (img == nil) then --增加处理，如果没有下载下来，则使用默认图片
            img = self.theme_:getImage("moregame/more_game_default.jpg")
        end

        local button = jj.ui.JJButton.new({
            images = {
                normal = img,
            },
            viewSize = CCSize(ITEM_WITH, ITEM_HEIGHT),
        })

        JJLog.i(TAG, "ImgLocal", v.ImgLocal)

        button:setAnchorPoint(ccp(0, 0))
        button:setPosition(ccp(ITEM_WITH * index, 0))
        button:setOnClickListener(handler(self, self.onClick))
        button.game = v
        viewGroup:addView(button)

        index = index + 1
    end

    return viewGroup
end

function MoreGameScene:refreshGameList()
    JJLog.i(TAG, "refreshGameList")

    local datas = MoreGameManager:getDisplayDatas()

    local len = #datas
    JJLog.i("len =", len)

    if (len <= 0) then
        return
    end

    local viewGroup = self:getButtonsGroup(datas)
    self.scrollView_:setContentView(viewGroup)
end

function MoreGameScene:onClick(target)
    JJLog.i(TAG, "onClick")

    local game = target.game
    if (game) then
        JJLog.i("game", game.jump_name)
        self.controller_:onGameItemClick(0, game)
    elseif (target == self.btnAllGame) then
        JJLog.i("allgame")
        if JJGameUtil:isHao123(PROMOTER_ID) then
            Util:openSystemBrowser("http://m.hao123.com/n/v/jjyouxi?z=2&set=4&tn=jddz")
        else
            Util:openSystemBrowser("http://m.jj.cn")
        end
    end
end

return MoreGameScene