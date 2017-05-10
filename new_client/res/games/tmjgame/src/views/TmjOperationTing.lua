-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点 听节点
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationTing = class("TmjOperationTing",requireForGameLuaFile("TmjOperationWidget"))
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
function TmjOperationTing:ctor(operationData,chooseFun)
	
	TmjOperationTing.super.ctor(self,operationData,chooseFun)
end

function TmjOperationTing:initView(operationData)
	--TmjPengOperationNodeCCS
	local node = requireForGameLuaFile("TmjTingOperationNodeCCS"):create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(node.root,"Button_ting"):addTouchEventListener(handler(self,self.touchListener))
	self.contentSize = CustomHelper.seekNodeByName(node.root,"Button_ting"):getContentSize()
	
end

function TmjOperationTing:touchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
			if self.chooseFun then
				self.chooseFun(self.operationData)
			end
--[[		if self.chooseFun then
			self.chooseFun(TmjConfig.cardOperation.Ting,chooseIndex)
		end--]]
	end
end


return TmjOperationTing
