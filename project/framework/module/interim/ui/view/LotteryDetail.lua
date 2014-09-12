local JJViewGroup = require("sdk.ui.JJViewGroup")
local LotteryDetail = class("LotteryDetail", JJViewGroup)

local JJListCell = import("sdk.ui.JJListCell")
local ListCell = class("ListCell", JJListCell)

local InterimUtilDefine = require("interim.util.InterimUtilDefine")
local INTERIM_SOUND = InterimUtilDefine.INTERIM_SOUND

function ListCell:ctor(params, parentView)
    ListCell.super.ctor(self, params)
    self.TAG = "TableCell"
    self.parentView = parentView
    self.dimens_ = self.parentView.dimens_
  --  JJLog.i(self.TAG, "ctor()")

    self.index = params.index

    local viewSize = CCSize(self.parentView.bgSize.width, self.dimens_:getDimens(60))
    self:setViewSize(viewSize.width, viewSize.height)

    local indexLabel = jj.ui.JJLabel.new({
        fontSize = 18*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
    })
    indexLabel:setAnchorPoint(ccp(0.5,1))
    indexLabel:setPosition(self.dimens_:getDimens(30), viewSize.height)
    --self:addView(indexLabel)
    --indexLabel:setText(tostring(self.index))
   
    local titleLabel = jj.ui.JJLabel.new({
        fontSize = 20*self.dimens_.scale_,
        color = ccc3(253, 210, 97),
        hAlign = ui.TEXT_ALIGN_LEFT,
        singleLine = false,
        viewSize = CCSizeMake(viewSize.width*0.85, 0),
    })
    titleLabel:setAnchorPoint(ccp(0,1))
    titleLabel:setPosition(self.dimens_:getDimens(10), viewSize.height)
    self:addView(titleLabel)
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    local index = #gameData.winnerDesc + 1 - self.index
    local text = gameData.winnerDesc[index]
    text = tostring(self.index).. "、" .. text .. ";"
    titleLabel:setText(text)
end

function ListCell:onEnter()
    self.super:onEnter()
end

function ListCell:setLabelTextForIndex(label, index)
    
end

local ListAdapter = class("ListAdapter", require("sdk.ui.JJBaseAdapter"))
function ListAdapter:ctor(parentView)
    ListAdapter.super.ctor(self)
    self.parentView = parentView
    self.TAG = "ListAdapter"
    self.count_ = 12

    self.useFakeCount = false

end

function ListAdapter:getCount()
    local gameData = GameDataContainer:getGameData(INTERIM_MATCH_ID)
    -- gameData = nil
    if gameData == nil then
        self.count_ = 0
    elseif #gameData.winnerDesc > 0 then 
        self.count_ = 6     --#gameData.winnerDesc 8月12 号的新需求要求只显示6条数据
    else
        self.count_ = 0 
    end

    if self.useFakeCount == true then
        return 0
    end

    return self.count_
end

function ListAdapter:removeItem(position)
    if self.count_ > 0 then
        self.count_ = self.count_ -1 
        self:notifyDataSetChanged()
    end
    
end

function ListAdapter:getView(position)
    JJLog.i(self.TAG, "getItem() postion="..position)
    return ListCell.new({
        index=position
    }, self.parentView)
end

function LotteryDetail:ctor(parentView)
    LotteryDetail.super.ctor(self, parentView)
    self.parentView = parentView
    self.positionConfig = parentView.positionConfig
    self.dimens_ = parentView.dimens_
    self:initView()
end

function LotteryDetail:initView()

    function onButtonClicked(sender)
       
    end

    local background = jj.ui.JJImage.new({
         image = "img/interim/ui/pop_up_bg.png",
      })
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(0, 0)
    background:setScale(self.dimens_.scale_)
    self:addView(background)

    local titleBg = jj.ui.JJImage.new({
         image = "img/interim/ui/titleBg.png",
      })
    titleBg:setAnchorPoint(ccp(0.5, 0.5))
    titleBg:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(183))
    titleBg:setScale(self.dimens_.scale_)
    self:addView(titleBg)
   
    self:setAnchorPoint(ccp(0.5, 0.5))

    self.bgSize = CCSizeMake(background:getViewSize().width*self.dimens_.scale_,
    background:getViewSize().height*self.dimens_.scale_)
    
    local titleLabel = jj.ui.JJLabel.new({
        fontSize = 30*self.dimens_.scale_,
        color = ccc3(252, 217, 97),
        text = "奖励信息",
    })
    titleLabel:setAnchorPoint(ccp(0.5,0.5))
    titleLabel:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(183))
    self:addView(titleLabel)

    self:setTouchEnable(true)

    self:addListView()

end

function LotteryDetail:addListView()
    self.listviewAdapter = ListAdapter.new(self)
    self.listview = jj.ui.JJListView.new({
        viewSize = CCSize(self.dimens_:getDimens(500),self.dimens_:getDimens(300) ),
        adapter = self.listviewAdapter,
        -- background={
        --     image="img/ui/EditBoxBg.png",
        --     scale9 = true
        -- }
    })
    self.listview:setAnchorPoint(ccp(0.5,0.5))
    self.listview:setId(22)
    self.listview:setPosition(self.dimens_:getDimens(0), self.dimens_:getDimens(-35))
    self:addView(self.listview)
end

function LotteryDetail:removeListView()
    self.listview:removeSelf(false)
    self.listviewAdapter = nil
    self.listview = nil
end

function LotteryDetail:refreshListView()
    self.listview:refreshListView()
end

function LotteryDetail:onTouchBegan(x, y)
    if self:isTouchInside(x, y) == true and self.bTouchEnable_ then
        self:setTouchedIn(true)
        local pos = self:convertToNodeSpace(ccp(x, y))
      --  JJLog.i("x y " .. pos.x .. " " .. pos.y)
        if pos.x > 200*self.dimens_.scale_
         and pos.y > 150*self.dimens_.scale_ then
           self.parentView:hideLotteryDetail()
           SoundManager:playEffect(INTERIM_SOUND.BUTTON)
        
        end
        return true
    end
    return false
end

function LotteryDetail:createButton(buttonText)
   
end

function LotteryDetail:show()
    self:setVisible(true)
   -- self:removeListView()
   -- self:addListView()
    self.listviewAdapter.useFakeCount = true
    self.listview:refreshListView()
    self.listviewAdapter.useFakeCount = false
    self.listview:refreshListView()
    
    --self.listview:setContentOffset(CCSizeMake(0,0), false)
end

return LotteryDetail
