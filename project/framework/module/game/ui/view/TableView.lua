local JJViewGroup = import("sdk.ui.JJViewGroup")
local TableView = class("TableView", JJViewGroup)

local TAG = "TableView"
local width = 190
local height = 130

TableView.tableImage_ = nil --桌子底图
TableView.playerCountLabel_ = nil --玩家人数
TableView.nameLabel_ = nil --桌子名称，第*桌

function TableView:ctor(params, customParam)
    TableView.super.ctor(self)
    self.theme_ = params.theme_
    self.dimens_ = params.dimens_
    self.tourneyId_ = params.tourneyId_
    self.data_ = params.tableInfo

    --[[    self:setBackground({
            image="img/common/common/common_alert_dialog_bg.png",
            scale9=true
        })]]
    self:setViewSize(width, height)
    self:createComponents()
    self:refresh(self.data_)
end

function TableView:createComponents()
    self.tableImage_ = jj.ui.JJImage.new({
        image = self.theme_:getImage("tableselect/bg_table.png"),
        viewSize = CCSize(width, 98),
    })

    self.tableImage_:setPosition(width / 2, 30)
    self.tableImage_:setAnchorPoint(ccp(0.5, 0))
    self.tableImage_:setTouchEnable(true)
    self.tableImage_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.tableImage_)

    self.playerCountLabel_ = jj.ui.JJLabel.new({
        text = "",
        fontSize = 20,
        singleLine = true,
        align = ui.TEXT_ALIGN_CENTER,
    })
    self.playerCountLabel_:setAnchorPoint(ccp(0.5, 0.5))
    self.playerCountLabel_:setPosition(width / 2, 80)
    self:addView(self.playerCountLabel_)

    self.nameLabel_ = jj.ui.JJLabel.new({
        text = "",
        fontSize = 20,
        singleLine = true,
        align = ui.TEXT_ALIGN_CENTER,
    })
    self.nameLabel_:setAnchorPoint(ccp(0.5, 0.5))
    self.nameLabel_:setPosition(width / 2, 20)
    self:addView(self.nameLabel_)
end

function TableView:refresh(data)
    local countstr, countcolor, fontsize = "", display.COLOR_WHITE, 20

    if (data.signupamount > 0) then
        countstr = data.signupamount .. "/" .. data.maxamount
        countcolor = display.COLOR_WHITE
        fontsize = 20
    else
        countstr = "空"
        countcolor = display.COLOR_GREEN
        fontsize = 18
    end
    self.playerCountLabel_:setText(countstr)
    self.playerCountLabel_:setColor(countcolor)
    self.playerCountLabel_:setFontSize(fontsize)

    local tablestr = "第" .. data.tableid .. "桌"
    self.nameLabel_:setText(tablestr)
end

function TableView:onClick(target)
    JJLog.i(TAG, "onClick")
    if (target == self.tableImage_) then
        MatchInfoMsg:sendGetTablePlayerInfo(self.tourneyId_, self.data_.tableid)
    end
end

return TableView