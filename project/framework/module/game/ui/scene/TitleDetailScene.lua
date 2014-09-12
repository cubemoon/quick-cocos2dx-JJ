local TitleDetailScene = class("TitleDetailScene", import("game.ui.scene.JJGameSceneBase"))

local JJListCell = import("sdk.ui.JJListCell")
local TitleListCell = class("TitleListCell", JJListCell)
local TitleListAdapter = class("TitleListAdapter", require("sdk.ui.JJBaseAdapter"))

--[[
  不同的游戏显示需要重载TitleDetailScene:getCellProperty&TitleListCell:getCellText
]]

function TitleDetailScene:initView()    
    TitleDetailScene.super.initView(self)    

    --self:setTitle(self.theme_:getImage("title/title_detail_title.png"))   
    self:setThemeStyle(self.THEME_LANDSCAPE_SYTLE)
    self:setBackBtn(true)
    self:setTitle("称号体系")

    local title = "称号"
    if self.controller_.params_.title ~= nil then
        title = self.controller_.params_.title
    end

    self.cellProperty_ = self:getCellProperty(self.controller_.params_.gameId, title)
    self:initTitle()   
    self:initTitleCell()                                                  
end

function TitleDetailScene:getCellProperty(gameID, title)
    return {gameId = gameID,
              rowHeight = self.dimens_:getDimens(40), rowWidth = self.dimens_:getDimens(620), 
              sepHeight = self.dimens_:getDimens(2), sepWidth = self.dimens_:getDimens(2),
              colList = {{name = title, width=self.dimens_:getDimens(160)},
                         {name = "经验", width=self.dimens_:getDimens(75)},
                         {name = "大师分", width=self.dimens_:getDimens(75)},
                         {name = "战功", width=self.dimens_:getDimens(75)},
                         {name = "其它要求", width=self.dimens_:getDimens(245)}}
            }
end

function TitleDetailScene:initTitle()
    local x, y = self.dimens_:getDimens(200), self.dimens_.top - self.dimens_:getDimens(45)
    local colList = self.cellProperty_.colList
    local height = self.cellProperty_.rowHeight
    local sepWidth = self.cellProperty_.sepWidth

    local lable = nil 
    local colSep = nil    

    local bg = jj.ui.JJImage.new({
        image = self.theme_:getImage("common/common_btn_bg_n.png"),
        scale9 = true,
        viewSize = CCSize(self.dimens_:getDimens(640), y - self.dimens_:getDimens(20)),
    })
    bg:setAnchorPoint(ccp(0, 1))
    bg:setPosition(x - self.dimens_:getDimens(10), y + self.dimens_:getDimens(10))
    self:addView(bg)

    for _, col in ipairs(colList) do
        lable = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = self.dimens_:getDimens(20),
                        color = ccc3(255, 217, 0),
                        text = col.name,
                        align = ui.TEXT_ALIGN_CENTER,
                        viewSize = CCSize(col.width, height)
                    })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(x, y)
        self:addView(lable)

        x = x + col.width
        colSep = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/common_view_list_div_v.png"),
                viewSize = CCSize(sepWidth, height),
                scale9=true
              })
        --colSep:setScale(self.dimens_.scale_)
        colSep:setAnchorPoint(ccp(0, 1))
        colSep:setPosition(x, y)
        self:addView(colSep)

        x = x + sepWidth
    end
    --移除最后一个分割线
    self:removeView(colSep)
    colSep = nil

    x, y = self.dimens_:getDimens(200), y - height + self.cellProperty_.sepHeight
    local rowSep = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/common_view_list_div_h.png"),
                viewSize = CCSize(self.cellProperty_.rowWidth, self.cellProperty_.sepHeight),
                scale9=true
              })
    --rowSep:setScale(self.dimens_.scale_)
    rowSep:setAnchorPoint(ccp(0, 1))
    rowSep:setPosition(x, y)
    self:addView(rowSep)

end    

function TitleDetailScene:initTitleCell()
    local titleHeight = self.cellProperty_.rowHeight+self.cellProperty_.sepHeight       
    self.tableView = jj.ui.JJListView.new({
        viewSize = CCSize(self.cellProperty_.rowWidth, self.dimens_.height - self.dimens_:getDimens(85) - titleHeight),
        adapter = TitleListAdapter.new(self.theme_, self.dimens_, self.controller_.expTitle_, self.cellProperty_, self),
    })
    self.tableView:setAnchorPoint(ccp(0, 0))
    self.tableView:setPosition(self.dimens_:getDimens(200), self.dimens_:getDimens(40))
    self:addView(self.tableView)
end

function TitleDetailScene:refresh()
    if self.tableView then         
        self.tableView:getAdapter():refreshTitle(self.controller_.params_.gameId)
        self.tableView:refreshListView()
    end
end    

function TitleDetailScene:getCellText(data, index)
    local text = nil
    if index == 1 then --称号
        text = data.title
    elseif index == 2 then --经验
        if data.experience >= 30000 then 
            local exp = math.modf(data.experience/10000)
            text = exp .. "万"
        else 
            text = data.experience
        end
    elseif index == 3 then --大师分
        if data.masterScore ~= 0 then 
            text = data.masterScore
        end
    elseif index == 4 then --战功
        if data.feat ~= 0 then 
            text = data.feat
        end
    elseif index == 5 then --其它要求
        if data.cert ~= 0 then
            text = "需\"" .. self.controller_.titleDef_:getCertName(0, data.cert) .. "\""
        end
    end

    return text
end

function TitleListCell:ctor(params)
    TitleListCell.super.ctor(self, params)   

    local cell = params.cellProperty
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.data_ = params.cellData
    self:setViewSize(cell.rowWidth, cell.rowHeight)

    local x, y = 0, self:getViewSize().height
    
    --高亮背景
    if params.scene_:getCellText(self.data_, 1) == params.selfTitle then
        local bg = jj.ui.JJImage.new({
                image = self.theme_:getImage("pcenter/pcenter_item_highlight_bg.png"),
                viewSize = CCSize(cell.rowWidth, cell.rowHeight-cell.sepHeight),
                scale9=true
              })
        bg:setAnchorPoint(ccp(0.5, 0))
        bg:setPosition(cell.rowWidth/2, cell.sepHeight)
        self:addView(bg)
    end

    local lable = nil 
    local colSep = nil    
    
    for index, col in ipairs(cell.colList) do
        lable = jj.ui.JJLabel.new({
                        singleLine = true,
                        fontSize = self.dimens_:getDimens(20),
                        color = ccc3(255, 255, 255),
                        text = params.scene_:getCellText(self.data_, index),
                        align = ui.TEXT_ALIGN_CENTER,
                        viewSize = CCSize(col.width, cell.rowHeight)
                    })
        lable:setAnchorPoint(ccp(0, 1))
        lable:setPosition(x, y)        
        self:addView(lable)
        
        x = x + col.width
        colSep = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/common_view_list_div_v.png"),
                viewSize = CCSize(cell.sepWidth, cell.rowHeight),
                scale9=true
              })
        --colSep:setScale(self.dimens_.scale_)
        colSep:setAnchorPoint(ccp(0, 1))
        colSep:setPosition(x, y)
        self:addView(colSep)

        x = x + cell.sepWidth
    end
    --移除最后一个分割线
    self:removeView(colSep)
    colSep = nil
    
    x, y = 0, cell.sepHeight
    local rowSep = jj.ui.JJImage.new({
                image = self.theme_:getImage("common/common_view_list_div_h.png"),
                viewSize = CCSize(cell.rowWidth, cell.sepHeight),
                scale9=true
              })    
    rowSep:setAnchorPoint(ccp(0, 1))
    rowSep:setPosition(x, y)
    --rowSep:setScale(self.dimens_.scale_)
    self:addView(rowSep)    
end

function TitleListAdapter:ctor(theme, dimens, title, cellProperty, scene)
    TitleListAdapter.super.ctor(self)
    self.theme_ = theme
    self.dimens_ = dimens
    self.cellProperty_ = cellProperty
    self.title_ =  title
    self.scene_ = scene
    self.data_ = self.scene_.controller_.titleDef_:getTitleData(cellProperty.gameId)    
end

function TitleListAdapter:refreshTitle(gameId)
    self.title_ = self.scene_.controller_.titleDef_:getTitle(gameId)
end

function TitleListAdapter:getCount()
   local count = 0
   if self.data_ then 
       count = #self.data_
   end   
   return count
end

function TitleListAdapter:getView(position)
    return TitleListCell.new({
        theme = self.theme_,
        dimens = self.dimens_,
        index=position,
        cellProperty = self.cellProperty_,
        cellData = self.data_[position],
        selfTitle = self.title_,
        scene_ = self.scene_,
    })
end


return TitleDetailScene
