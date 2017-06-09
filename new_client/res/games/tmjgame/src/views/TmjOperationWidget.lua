-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点基础封装
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationWidget = class("TmjOperationWidget",cc.Node)
--@param operationData 操作的数据
--@param chooseFun 选中时的回调
function TmjOperationWidget:ctor(operationData,chooseFun)
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.chooseFun = chooseFun
	self.operationData = operationData 
	self.contentSize = cc.size(0,0)
	self:setName(self.__cname)
	self:initView(operationData)
	
end

function TmjOperationWidget:initView(operationData)

end


function TmjOperationWidget:getContentSize()
	return self.contentSize
end

function TmjOperationWidget:onExit()
	self.chooseFun = nil
end

return TmjOperationWidget
