-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点 胡牌节点
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationHu = class("TmjOperationHu",requireForGameLuaFile("TmjOperationWidget"))
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
function TmjOperationHu:ctor(operationData,chooseFun)
	
	TmjOperationHu.super.ctor(self,operationData,chooseFun)
end

function TmjOperationHu:initView(operationData)
	--TmjPengOperationNodeCCS
	local node = requireForGameLuaFile("TmjBundleNodeCCS"):create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(node.root,"Button_double"):addTouchEventListener(handler(self,self.touchListener))
	CustomHelper.seekNodeByName(node.root,"Button_hu"):addTouchEventListener(handler(self,self.touchListener))
	CustomHelper.seekNodeByName(node.root,"Button_pass"):addTouchEventListener(handler(self,self.touchListener))
	self.contentSize = CustomHelper.seekNodeByName(node.root,"Button_pass"):getContentSize()
	
	CustomHelper.seekNodeByName(node.root,"Button_hu"):setVisible(operationData)
	CustomHelper.seekNodeByName(node.root,"Button_double"):setVisible(operationData)
end

function TmjOperationHu:touchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		local chooseIndex = 3 --默认是过
		if ref:getName()=="Button_hu" then
			chooseIndex = 1 --
		elseif ref:getName()=="Button_double" then
			chooseIndex = 2
		elseif ref:getName()=="Button_pass" then
			chooseIndex = 3 --默认是过
		end
		if self.chooseFun then
			self.chooseFun(TmjConfig.cardOperation.Hu,chooseIndex)
		end
	end
end


return TmjOperationHu
