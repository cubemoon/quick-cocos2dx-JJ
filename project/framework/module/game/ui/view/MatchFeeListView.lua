-- 报名条件界面
local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchFeeListView = class("MatchFeeListView", JJViewGroup)

-- 奖励方案界面
local JJViewGroup = import("sdk.ui.JJViewGroup")
local MatchFeeListView = class("MatchFeeListView", JJViewGroup)
local FeeListAdapter = class("FeeListAdapter", import("sdk.ui.JJBaseAdapter"))
local FeeListCell = class("FeeListCell", import("sdk.ui.JJListCell"))

local function _getShortNoteStr(str)
    local newStr = str
    if string.find(str,"扣除") ~= nil then
        newStr = string.sub(str, string.len("扣除")+1)
    end
    return newStr
end

function FeeListCell:ctor(params)
    FeeListCell.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens        
    self.width_ = params.width
    self.height_ = self.dimens_:getDimens(54)
    self.scene_ = params.scene
    self:setViewSize(self.width_, self.height_)
    self.entryFee_ = params.entryFee
    local split_h = jj.ui.JJImage.new({
            image = self.theme_:getImage("matchselect/match_item_split_h.png"),
            scale9 = true, 
            viewSize = CCSize(self.width_-self.dimens_:getDimens(20), 2)
        })
    split_h:setAnchorPoint(ccp(0, 1))
    split_h:setPosition(self.dimens_:getDimens(10), self.height_)
    self:addView(split_h)
    local entryLabel = jj.ui.JJLabel.new({
        singleLine = true,
        text = _getShortNoteStr(self.entryFee_.note_),
        fontSize = self.dimens_:getDimens(22),
        color = ccc3(105, 27, 6),
        align = ui.TEXT_ALIGN_CENTER,
        viewSize = CCSize(self.width_, self.height_-self.dimens_:getDimens(2))
    })
    entryLabel:setAnchorPoint(ccp(0, 1))
    entryLabel:setPosition(0, self.height_-self.dimens_:getDimens(2))
    if self.entryFee_.useable_ == false then
        entryLabel:setColor(ccc3(150,150,150))
    end
    self:addView(entryLabel)
end

function FeeListCell:onTouch(event, x, y)
    if event == "began" then
         -- and self.entryFee_.useable_ == false 
        if self:isTouchInside(x, y) and self.entryFee_.useable_ == true then
            self.coverLayer_ = jj.ui.JJImage.new({
                image = self.theme_:getImage("matchselect/match_item_split_h.png"),
                scale9 = true,
                viewSize = CCSize(self.width_-self.dimens_:getDimens(20), self.height_-self.dimens_:getDimens(4))
            })
            self.coverLayer_:setAnchorPoint(ccp(0, 1))
            self.coverLayer_:setPosition(self.dimens_:getDimens(10), self.height_-self.dimens_:getDimens(2))
            self:addView(self.coverLayer_)
            return true
        else
            return false
        end
    elseif event == "moved" then
        -- if not self:isTouchInside(x, y) then
        --     if self.coverLayer_ ~= nil then
        --         print("line 66")
        --         self:removeView(self.coverLayer_)
        --         self.coverLayer_ = nil
        --         self.scene_:selectEntryFeeList(self:getIdx())
        --         return true
        --     end            
        -- end
        -- or event == "cancelled" 
    elseif event == "ended" then
        if self.coverLayer_ ~= nil then
            self:removeView(self.coverLayer_)
            self.coverLayer_ = nil
            self.scene_:selectEntryFeeList(self:getIdx())
            return true
        end
    end  
end


function FeeListAdapter:ctor(params)
    FeeListAdapter.super.ctor(self)    
    local tourneyInfo = params.tourneyInfo
    self.theme_ = params.theme
    self.dimens_ = params.dimens    
    self.scene_ = params.scene
    self.width_ = params.width
    self.entryFee_ = tourneyInfo:getEntryFee()
end

function FeeListAdapter:getCount()
    if self.entryFee_ ~= nil then
        return #self.entryFee_
    else
        return 0
    end
end

function FeeListAdapter:getView(position)
    return FeeListCell.new({
        theme = self.theme_,
        dimens = self.dimens_,
        scene = self.scene_,
        entryFee = self.entryFee_[position],
        width = self.width_,
    })
end

function MatchFeeListView:ctor(params)
    MatchFeeListView.super.ctor(self)
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.scene_ = params.scene
    self.tourneyInfo_ = params.tourneyInfo
    self.width_ = params.width
    self.height_ = params.height
    self:setViewSize(params.width, self.height_)
    local tableView = jj.ui.JJListView.new({
        viewSize = CCSize(self.width_, self.height_),
        adapter = FeeListAdapter.new({
            theme = self.theme_,
            dimens = self.dimens_,
            tourneyInfo = self.tourneyInfo_,
            scene = self.scene_,
            width = self.width_,
            height = self.height_,
        }),
    })
    tableView:setAnchorPoint(ccp(0, 0))
    tableView:setPosition(0, 0)
    self:addView(tableView)

end

return MatchFeeListView