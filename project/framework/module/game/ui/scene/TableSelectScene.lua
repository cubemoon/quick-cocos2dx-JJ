local TableSelectScene = class("TableSelectScene", import("game.ui.scene.JJGameSceneBase"))
local TAG = "TableSelectScene"
local TableListView = require("game.ui.view.TableListView")
local TableInfoView = require("game.ui.view.TableInfoView")
require("game.data.match.MatchTableData")

-- 声明控件句柄
TableSelectScene.tableListView_ = nil
TableSelectScene.tableInfoDialog_ = nil

function TableSelectScene:onDestory()
    JJLog.i(TAG, "onDestory")
    TableSelectScene.super.onDestory(self)

    -- 清理句柄
    self.tableListView_ = nil
    self.tableInfoDialog_ = nil
end

function TableSelectScene:initView()
    TableSelectScene.super.initView(self)
    self:setBg(self.theme_:getImage("matchselect/bg.jpg"))
    self:setBackBtn(true)

    self:_createView()
    self:_initData()
end

function TableSelectScene:_createView()
    JJLog.i(TAG, "_createView", vardump(self.theme_))
    local dimens = self.dimens_
    local theme = self.theme_

    local params = {
        theme_ = self.theme_,
        dimens_ = self.dimens_,
        scene_ = self,
        tourneyId_ = MatchTableData:getCurrentTourneyid()
    }
    self.tableListView_ = TableListView.new(params, nil)
    self:addView(self.tableListView_, -100)
end

function TableSelectScene:_initData()
    JJLog.i(TAG, "_initData")
end

function TableSelectScene:onClick(target)
    JJLog.i(TAG, "onClick")
end

function TableSelectScene:showTableInfo(ack)
    if (self.tableInfoDialog_) then
        self.tableInfoDialog_:refresh()
    else
        JJLog.i(TAG, "showTableInfo")
        self.tableInfoDialog_ = TableInfoView.new(self, ack.tourneyid, ack.tableid)
        self:addView(self.tableInfoDialog_)
    end
end

function TableSelectScene:closeTableInfo()
    if (self.tableInfoDialog_) then
        self:removeView(self.tableInfoDialog_)
        self.tableInfoDialog_ = nil
    end
end

return TableSelectScene
