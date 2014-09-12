local JJListCell = class("JJListCell", import(".JJViewGroup"))

--[[
   params: table type
       index: integer type
--]]
function JJListCell:ctor(params)
   JJListCell.super.ctor(self, params)
   self.idx_ = params and params.index
end

function JJListCell:setIdx(idx)
   self.idx_ = idx
end

function JJListCell:getIdx()
   return self.idx_
end

function JJListCell:getParentInterface()
   return self:getParentView()
end

return JJListCell
