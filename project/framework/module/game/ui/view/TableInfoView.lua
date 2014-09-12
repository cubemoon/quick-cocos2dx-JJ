local JJViewGroup = require("sdk.ui.JJViewGroup")
local TableInfoView = class("TableInfoView", JJViewGroup)
local TAG = "TableInfoView"

local function _onClickMask(self)
    self:close()
end

function TableInfoView:ctor(parent, tourneyid, tableid)
    TableInfoView.super.ctor(self)
    self.scene_ = parent
    self.dimens_ = parent.dimens_
    self.theme_ = parent.theme_

    self.tourneiId_ = tourneyid
    self.tableid_ = tableid
    self:initView()
end

function TableInfoView:initView()

    -- 遮罩
    -- 背景遮罩
    self.bgMask_ = require("game.ui.view.JJFullScreenMask").new()
    self.bgMask_:setOpacity(0) -- 完全透明
    self:addView(self.bgMask_)
    self.bgMask_:setOnClickListener(handler(self, _onClickMask))

    -- 背景
    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_alert_dialog_bg.png"),
    })
    bg:setAnchorPoint(ccp(0.5, 0.5))
    bg:setPosition(self.dimens_.cx, self.dimens_.cy)
    bg:setScale(self.dimens_.scale_)
    bg:setTouchEnable(true)
    bg:setOnClickListener(handler(self, self.onClick))
    self:addView(bg)

    local bgWidth, bgHeight = self.dimens_:getDimens(476), self.dimens_:getDimens(276)

    --标题
    self.title = jj.ui.JJLabel.new({
        fontSize = self.dimens_:getDimens(24),
        color = ccc3(107, 65, 25),
        singleLine = true,
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_CENTER,
        viewSize = CCSize(bgWidth - self.dimens_:getDimens(80), self.dimens_:getDimens(30))
    })
    self.title:setText("第" .. self.tableid_ .. "桌")
    self.title:setAnchorPoint(CCPoint(0.5, 1))
    self.title:setPosition(self.dimens_.cx, self.dimens_.top - math.modf((self.dimens_.height - bgHeight) / 2) - self.dimens_:getDimens(8))
    self:addView(self.title)

    --内容
    self:createListView(self.dimens_)

    self.btnSign_ = jj.ui.JJButton.new({
        images = {
            normal = self.theme_:getImage("common/common_signup_small_btn_n.png"),
            highlight = self.theme_:getImage("common/common_signup_small_btn_d.png"),
            scale9 = true,
        },
        text = "加入",
        fontSize = 28,
        viewSize = CCSize(125, 68),
    })
    self.btnSign_:setScale(self.dimens_.scale_)
    self.btnSign_:setAnchorPoint(ccp(0.5, 0.5))
    self.btnSign_:setPosition(self.dimens_.cx, self.dimens_.cy - self.dimens_:getDimens(90))
    self.btnSign_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.btnSign_)
end

function TableInfoView:refresh()
    if self.listAdapter_ then
        self.listAdapter_:notifyDataSetChanged()
    end
end

function TableInfoView:singup()
    local tourneyInfo = TourneyController:getTourneyInfoByTourneyId(self.tourneiId_)
    if (tourneyInfo) then
        local gameId = tonumber(tourneyInfo.matchconfig_ and tourneyInfo.matchconfig_.gameId)
        local tourneyId = tourneyInfo.tourneyId_
        local matchPoint = self.tableid_
        LobbyDataController:signupMatch(gameId, tourneyId, matchPoint, 0, 0, 0)
    end
end

function TableInfoView:onClick(target)
    JJLog.i(TAG, "onClick")
    if target == self.btnSign_ then
        self:singup()
        self:close()
    end
end

function TableInfoView:close()
    self.scene_:closeTableInfo()
end

-------------------------------------------------------------------------------------------------------
local JJListCell = import("sdk.ui.JJListCell")
local ListCell = class("ListCell", JJListCell)

function ListCell:ctor(params)
    ListCell.super.ctor(self, params)

    local index = params.index
    local scene_ = params.scene_
    local mytheme = scene_.theme_
    local mydimens = scene_.dimens_

    local datas = params.listData
    local size = #datas

    local width, height = 400, 30
    local namewidth, scorewidth = 300, 100
    self:setViewSize(mydimens:getDimens(width), mydimens:getDimens(height))

    if (size <= 0) or index > size then
        return
    end

    local data = datas[index]

    --创建昵称label显示
    local nameLabel = jj.ui.JJLabel.new({
        text = data.nickname,
        fontSize = mydimens:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = CCSize(mydimens:getDimens(namewidth), mydimens:getDimens(height)),
        dimensions = CCSize(mydimens:getDimens(namewidth), mydimens:getDimens(height)),
        color = ccc3(107, 65, 25),
    })
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(0, mydimens:getDimens(height) / 2)
    self:addView(nameLabel)

    --创建昵称label显示
    local nameLabel = jj.ui.JJLabel.new({
        text = data.score,
        fontSize = mydimens:getDimens(20),
        align = ui.TEXT_ALIGN_LEFT,
        viewSize = CCSize(mydimens:getDimens(scorewidth), mydimens:getDimens(height)),
        dimensions = CCSize(mydimens:getDimens(scorewidth), mydimens:getDimens(height)),
        color = ccc3(107, 65, 25),
    })
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(mydimens:getDimens(namewidth), mydimens:getDimens(height / 2))
    self:addView(nameLabel)
end

-----------------------------------------------------------------------------------------------------
local ListAdapter = class("ListAdapter", require("sdk.ui.JJBaseAdapter"))
function ListAdapter:ctor(params)
    ListAdapter.super.ctor(self)
    self.TAG = "ListAdapter"
    self.scene_ = params.scene_
    self.tourneiId_ = params.tourneiId_
    self.tableid_ = params.tableid_
end

function ListAdapter:getCount()
    local len = 0
    local datas = MatchTableData:getPlayersDisplay(self.tourneiId_, self.tableid_)

    len = #datas
    return len
end

function ListAdapter:getView(position)
    local datas = MatchTableData:getPlayersDisplay(self.tourneiId_, self.tableid_)

    return ListCell.new({
        index = position,
        listData = datas,
        scene_ = self.scene_,
    })
end

------------------------------------------------------------------------------------------------------------
function TableInfoView:createListView(dimens)
    local listHeight = dimens:getDimens(150)

    local params = {
        tourneiId_ = self.tourneiId_,
        tableid_ = self.tableid_,
        scene_ = self.scene_
    }
    self.listAdapter_ = ListAdapter.new(params)
    self.listView_ = jj.ui.JJListView.new({
        viewSize = CCSize(dimens:getDimens(400), listHeight),
        adapter = self.listAdapter_,
    })

    self.listView_:setAnchorPoint(ccp(0.5, 1))
    self.listView_:setPosition(ccp(dimens.cx, dimens.height - (dimens.height - dimens:getDimens(276)) / 2 - dimens:getDimens(45)))
    self:addView(self.listView_)
end

function TableInfoView:getListHeight()
    local height = 0

    local datas = MatchTableData:getPlayersDisplay(self.tourneiId_, self.tableid_)

    height = #datas * self.dimens_:getDimens(30)

    -- 动态设置ListView的高度
    if height > self.dimens_:getDimens(200) then
        height = self.dimens_:getDimens(200)
    end
    return height
end

return TableInfoView