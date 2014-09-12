local JJViewGroup = import("sdk.ui.JJViewGroup")
local TableListView = class("TableListView", JJViewGroup)
local TAG = "TableListView"

local JJBaseAdapter = import("sdk.ui.JJBaseAdapter")
local TableListAdapter = class("TableListAdapter", JJBaseAdapter)

local JJListCell = import("sdk.ui.JJListCell")
local TableListCell = class("TableListCell", JJListCell)
local TableView = import(".TableView")
require("game.data.match.MatchTableData")

local TABLE_COUNTS = 9

--TableListCell
function TableListCell:ctor(params, customParam)
    TableListCell.super.ctor(self)
    self.theme_ = params.theme_
    self.dimens_ = params.dimens_
    self.scene_ = params.scene_
    self.width_ = self.dimens_.width
    self.height_ = self.dimens_:getDimens(140 * 3)
    --self.cellHeight_ = self.dimens_:getDimens(140)
    self:setViewSize(self.dimens_.width, self.height_)

    local item1, item2, item3, item4, item5, item6, item7, item8, item9 = nil, nil, nil, nil, nil, nil, nil, nil, nil

    local getTableViewParam = function(pos, item)
        return {
            theme_ = self.theme_,
            dimens_ = self.dimens_,
            scene_ = self.scene_,
            position = pos,
            tourneyId_ = params.tourneyId_,
            tableInfo = item
        }
    end

    if params.item1 ~= nil then
        item1 = TableView.new(getTableViewParam(1, params.item1), customParam)
    end

    if params.item2 ~= nil then
        item2 = TableView.new(getTableViewParam(2, params.item2), customParam)
    end

    if params.item3 ~= nil then
        item3 = TableView.new(getTableViewParam(3, params.item3), customParam)
    end

    if params.item4 ~= nil then
        item4 = TableView.new(getTableViewParam(4, params.item4), customParam)
    end

    if params.item5 ~= nil then
        item5 = TableView.new(getTableViewParam(5, params.item5), customParam)
    end

    if params.item6 ~= nil then
        item6 = TableView.new(getTableViewParam(6, params.item6), customParam)
    end

    if params.item7 ~= nil then
        item7 = TableView.new(getTableViewParam(7, params.item7), customParam)
    end

    if params.item8 ~= nil then
        item8 = TableView.new(getTableViewParam(8, params.item8), customParam)
    end

    if params.item9 ~= nil then
        item9 = TableView.new(getTableViewParam(9, params.item9), customParam)
    end

    local centerx = self.dimens_.cx
    local centery = self.dimens_:getDimens(140 * 3 / 2)
    local offsetx = self.dimens_:getDimens(240)
    local offsety = self.dimens_:getDimens(140)

    local left, top = 0, 0

    top = centery + offsety

    if item1 ~= nil then
        item1:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx - offsetx
        item1:setPosition(ccp(left, top))
        item1:setScale(self.dimens_.scale_)
        self:addView(item1)
    end

    if item2 ~= nil then
        item2:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx
        item2:setPosition(ccp(left, top))
        item2:setScale(self.dimens_.scale_)
        self:addView(item2)
    end

    if item3 ~= nil then
        item3:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx + offsetx
        item3:setPosition(ccp(left, top))
        item3:setScale(self.dimens_.scale_)
        self:addView(item3)
    end

    top = centery
    if item4 ~= nil then
        item4:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx - offsetx
        item4:setPosition(ccp(left, top))
        item4:setScale(self.dimens_.scale_)
        self:addView(item4)
    end

    if item5 ~= nil then
        item5:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx
        item5:setPosition(ccp(left, top))
        item5:setScale(self.dimens_.scale_)
        self:addView(item5)
    end

    if item6 ~= nil then
        item6:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx + offsetx
        item6:setPosition(ccp(left, top))
        item6:setScale(self.dimens_.scale_)
        self:addView(item6)
    end

    top = centery - offsety
    if item7 ~= nil then
        item7:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx - offsetx
        item7:setPosition(ccp(left, top))
        item7:setScale(self.dimens_.scale_)
        self:addView(item7)
    end

    if item8 ~= nil then
        item8:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx
        item8:setPosition(ccp(left, top))
        item8:setScale(self.dimens_.scale_)
        self:addView(item8)
    end

    if item9 ~= nil then
        item9:setAnchorPoint(ccp(0.5, 0.5))
        left = centerx + offsetx
        item9:setPosition(ccp(left, top))
        item9:setScale(self.dimens_.scale_)
        self:addView(item9)
    end
end

function TableListCell:getHeight()
    return self.height_
end

function TableListCell:getWidth()
    return self.width_
end

function TableListCell:getSize()
    return CCSizeMake(self.width_, self.height_)
end

--TableListAdapter
function TableListAdapter:ctor(params, customParam)
    TableListAdapter.super.ctor(self)
    self.theme_ = params.theme_
    self.dimens_ = params.dimens_
    self.scene_ = params.scene_
    self.tourneyId_ = params.tourneyId_

    self.customParam_ = customParam
    self.tourneylist_ = MatchTableData:getTableDatas(self.tourneyId_)
end

function TableListAdapter:getCount()
    local itemList = MatchTableData:getTableDatas(self.tourneyId_)

    local count = 0
    if itemList ~= nil then
        count = math.ceil(#itemList / TABLE_COUNTS)
    end

    JJLog.i(TAG, "getCount() ", count)
    return count
end

function TableListAdapter:getView(position)
    local itemList = MatchTableData:getTableDatas(self.tourneyId_)

    local listCellParam = {
        theme_ = self.theme_,
        dimens_ = self.dimens_,
        scene_ = self.scene_,
        position = position,
        tourneyId_ = self.tourneyId_,
        item1 = itemList[(position - 1) * TABLE_COUNTS + 1],
        item2 = itemList[(position - 1) * TABLE_COUNTS + 2],
        item3 = itemList[(position - 1) * TABLE_COUNTS + 3],
        item4 = itemList[(position - 1) * TABLE_COUNTS + 4],
        item5 = itemList[(position - 1) * TABLE_COUNTS + 5],
        item6 = itemList[(position - 1) * TABLE_COUNTS + 6],
        item7 = itemList[(position - 1) * TABLE_COUNTS + 7],
        item8 = itemList[(position - 1) * TABLE_COUNTS + 8],
        item9 = itemList[(position - 1) * TABLE_COUNTS + 9],
    }

    return TableListCell.new(listCellParam, self.customParam_)
end

function TableListAdapter:getItemId(position)
    return position
end

--TableListAdapter
function TableListView:ctor(params, customParam)
    TableListView.super.ctor(self)
    self.theme_ = params.theme_
    self.dimens_ = params.dimens_
    self.scene_ = params.scene_
    self.tourneyId_ = params.tourneyId_

    self.customParam_ = customParam
    self:setViewSize(self.dimens_.width, self.dimens_.height)
    self.items_ = MatchTableData:getTableDatas(self.tourneyId_)

    self.identityImage_ = {}

    local left, top = 0, 0

    local adapterParams = {
        theme_ = self.theme_,
        dimens_ = self.dimens_,
        scene_ = params.scene_,
        tourneyId_ = params.tourneyId_,
    }

    self.galleryView_ = jj.ui.JJGalleryView.new({
        viewSize = CCSize(self.dimens_.width, self.dimens_:getDimens(140 * 3)),
        adapter = TableListAdapter.new(adapterParams, self.customParam_)
    })
    self.galleryView_:setAnchorPoint(ccp(0, 0.5))
    self.galleryView_:setPosition(0, self.dimens_.cy)
    self.galleryView_:setOnItemSelectedListener(handler(self, self.onItemSelected))
    self:addView(self.galleryView_)

    top = self.dimens_:getDimens(15)
    if self.items_ then
        local count = math.ceil(#self.items_ / TABLE_COUNTS)
        local width = count * (self.dimens_:getDimens(12)) + (count - 1) * (self.dimens_:getDimens(10))
        local viewGroup = jj.ui.JJViewGroup.new({
            viewSize = CCSize(width, self.dimens_:getDimens(14))
        })
        viewGroup:setAnchorPoint(ccp(0.5, 0.5))
        viewGroup:setPosition(self.dimens_.cx, top)
        for i = 1, count do
            left = (i - 1) * self.dimens_:getDimens(10 + 12)
            self.identityImage_[i] = jj.ui.JJImage.new({
                image = self.theme_:getImage("tableselect/point_normal.png"),
            })
            self.identityImage_[i]:setAnchorPoint(ccp(0, 0))
            self.identityImage_[i]:setPosition(left, 0)
            self.identityImage_[i]:setScale(self.dimens_.scale_)
            viewGroup:addView(self.identityImage_[i])
        end
        self:setIdentity(1)
        if count > 1 then
            self:addView(viewGroup)
        end
    end
end

function TableListView:onItemSelected(list, child, childIndex, childId)
    self:setIdentity(childIndex)
end

function TableListView:setIdentity(index)
    local count = math.ceil(#self.items_ / TABLE_COUNTS)
    if count > 1 then
        if self.identityImage_[index] then
            for i = 1, count do
                if index == i then
                    self.identityImage_[index]:setImage(self.theme_:getImage("tableselect/point_index.png"), false)
                else
                    self.identityImage_[i]:setImage(self.theme_:getImage("tableselect/point_normal.png"), false)
                end
            end
        end
    end
end

function TableListView:refresh()
    self.galleryView_:refreshGalleryView()
end

return TableListView
