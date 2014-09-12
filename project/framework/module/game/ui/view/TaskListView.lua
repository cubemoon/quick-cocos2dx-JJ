--[[
    岛屿等待 任务列表界面
]]

local TaskListView = class("TaskListView",require("sdk.ui.JJViewGroup"))
local TaskListCell = class("TaskListCell",require("sdk.ui.JJListCell"))
local TaskListAdapter = class("TaskListAdapter",require("sdk.ui.JJBaseAdapter"))

function TaskListCell:ctor(params)
    TaskListCell.super.ctor(self)
    self.dimens_ = params.dimens
    self.theme_ = params.theme
    self.width_ = params.width
    self.height_ = self.dimens_:getDimens(40)
    self:setViewSize(self.width_, self.height_)
    local fontSizeNormal = self.dimens_:getDimens(20)
    local fontSizeSmall = fontSizeNormal

    if params.sepLine then 
        self.height_ = 10
        self:setViewSize(self.width_, self.height_)
        local sepBg = jj.ui.JJImage.new({
                    image = self.theme_:getImage("common/common_view_list_div_h.png"),
                    scale9 = true,
                    viewSize = CCSize(self.width_-20, 2),
                })
        sepBg:setAnchorPoint(CCPoint(0.5, 1))
        sepBg:setPosition(self.width_/2, 4)
        self:addView(sepBg)
        return 
    end

    self.name_ = params.name
    self.award_ = params.award
    self.finishNum_ = params.finishNum
    self.totalNum_ = params.totalNum
    self.showProgress_ = params.showProgress

    local progressBar = jj.ui.JJLoadingBar.new({
        viewSize = CCSize(131,23),
        background = {image = self.theme_:getImage("game/islandwait/island_wait_task_progress_bg.png"), 
                    zorder = -1 },
        images = { progress = self.theme_:getImage("game/islandwait/island_wait_progress.png"), 
                    zorder = 1 }
    })
    progressBar:setAnchorPoint(ccp(0, 1))
    progressBar:setPosition(self.dimens_:getDimens(280), self.height_- self.dimens_:getDimens(10))
    progressBar:setScale(self.dimens_.scale_)
    self:addView(progressBar)
    progressBar:setValue(math.modf(self.finishNum_ * 100 / self.totalNum_))

    local y = self.height_-self.dimens_:getDimens(8)
    --任务名称
    local nameLabel = jj.ui.JJLabel.new({
            text = self.name_,
            singleLine = true,
            fontSize = fontSizeNormal,
            color = display.COLOR_WHITE,
            viewSize = CCSize(self.dimens_:getDimens(300),self.dimens_:getDimens(24)),
     })
    nameLabel:setAnchorPoint(ccp(0,1))
    nameLabel:setPosition(self.dimens_:getDimens(10),y)
    self:addView(nameLabel)


    --任务奖励
    local awardLabel = jj.ui.JJLabel.new({
            text = self.award_,
            singleLine = true,
            fontSize = fontSizeNormal,
            color = ccc3(255,217,0),
            viewSize = CCSize(self.dimens_:getDimens(120),self.dimens_:getDimens(24)),
     })
    awardLabel:setAnchorPoint(ccp(0,1))
    awardLabel:setPosition(self.dimens_:getDimens(130),y)
    self:addView(awardLabel)

    --任务完成百分比
    --[[local taskDecLabel = jj.ui.JJLabel.new({
            text = self.finishNum_ .. "/" .. self.totalNum_,
            singleLine = true,
            fontSize = fontSizeSmall,
            color = ccc3(255, 217, 0),
            viewSize = CCSize(120,25),
        })
    taskDecLabel:setAnchorPoint(ccp(0,1))
    taskDecLabel:setPosition(490,self.height_-8)
    self:addView(taskDecLabel)]]
    --if self.showProgress_ then 
        --[[local lbl1 = jj.ui.JJLabel.new({
                text = "(",
                singleLine = true,
                fontSize = fontSizeSmall,
                color = ccc3(189,240,255),
            })
        lbl1:setAnchorPoint(ccp(0,1))
        lbl1:setPosition(self.dimens_:getDimens(420), y)
        self:addView(lbl1)]]

        local lbl2 = jj.ui.JJLabel.new({
                text = self.finishNum_,
                singleLine = true,
                fontSize = fontSizeSmall,
                color = ccc3(255, 217, 0),
            })
        lbl2:setAnchorPoint(ccp(0,1))
        --lbl2:setPosition(lbl1:getPositionX() + lbl1:getWidth(),y)
        lbl2:setPosition(self.dimens_:getDimens(420),y)
        self:addView(lbl2)

        local lbl3 = jj.ui.JJLabel.new({
                text = "/" .. self.totalNum_ ,--.. ")",
                singleLine = true,
                fontSize = fontSizeSmall,
                color = ccc3(189,240,255),
            })
        lbl3:setAnchorPoint(ccp(0,1))
        lbl3:setPosition(lbl2:getPositionX()+ lbl2:getWidth(), y)
        self:addView(lbl3)
    --end
end


-- 游戏任务适配器
function TaskListAdapter:ctor(params)
    TaskListAdapter.super.ctor(self)
    self.taskList_ = params.taskList_
    self.theme_ = params.theme
    self.dimens_ = params.dimens
    self.width_ = params.width
    self.taskList_ = params.taskList    
end

function TaskListAdapter:getCount()
    return (self.taskList_ and #self.taskList_) or 0
end

function TaskListAdapter:getView(position)    
    local param = self.taskList_[position]
    return TaskListCell.new({
           theme = self.theme_,
           dimens = self.dimens_,
           name = param.name,
           award = param.award,
           finishNum = param.finishNum,
           totalNum = param.totalNum,
           sepLine = param.sepLine,
           showProgress = param.showProgress,
           width = self.width_
        })

end

function TaskListView:ctor(params)

    TaskListView.super.ctor(self)

    self.dimens_ = params.dimens
    self.theme_ = params.theme
    self.taskList_ = params.taskList
    self.width_ = params.width
    self.height_ = params.height
    self:setViewSize(self.width_,self.height_)
--[[
    --背景
    self.bg_ = jj.ui.JJImage.new({        
        image = "img/common/common/common_view_bg.png",
        scale9 = true,
        viewSize = CCSize(self.width_, self.height_)
    })
    self.bg_:setAnchorPoint(ccp(0.5, 0.5))
    self.bg_:setPosition(self.width_/2, self.height_/2)
    self.bg_:setTouchEnable(true)
    self.bg_:setOnClickListener(handler(self, self.onClick))
    self:addView(self.bg_)
]]
    --任务表视图
    local tableView = jj.ui.JJListView.new({

          viewSize = CCSize(self.width_,self.height_),
          adapter = TaskListAdapter.new({
               theme = self.theme_,
               dimens = self.dimens_,
               width = self.width_,
               taskList = self.taskList_,
            }),

        })


    tableView:setAnchorPoint(ccp(0.5,0.5))
    tableView:setPosition(self.width_/2,self.height_/2)
    self:addView(tableView)
end

return TaskListView
