-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点 杠节点
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationGang = class("TmjOperationGang",requireForGameLuaFile("TmjOperationWidget"))
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
local TmjCardTip = import("..cfg.TmjCardTip")
function TmjOperationGang:ctor(operation,operationData,chooseFun)
	if operation==TmjCardTip.CardOperation.Gang then
		self.operation = TmjConfig.cardOperation.Gang
	elseif operation==TmjCardTip.CardOperation.AnGang then
		self.operation = TmjConfig.cardOperation.AnGang
	elseif operation==TmjCardTip.CardOperation.BuGang then
		self.operation = TmjConfig.cardOperation.BuGang
	end
	
	TmjOperationGang.super.ctor(self,operationData,chooseFun)
end

function TmjOperationGang:initView(operationData)
	--TmjPengOperationNodeCCS
	local node = requireForGameLuaFile("TmjGangOperationNodeCCS"):create()
	self:addChild(node.root)
	local imgTag = CustomHelper.seekNodeByName(node.root,"Image_tag")
	CustomHelper.seekNodeByName(node.root,"Image_tag"):addTouchEventListener(handler(self,self.touchListener))
	--Image_1
	local img = CustomHelper.seekNodeByName(node.root,"Image_1")
	for i=1,4 do
		local fnode = img:getChildByName(string.format("FileNode_%d",i))
		fnode:getContentSize()
		
		local card = TmjCard:create({val = operationData })
		card:addTo(fnode:getParent())
		card:setScale(fnode:getScale())
		card:changeState(TmjConfig.CardState.State_Discard)
		card:setCardPosition(cc.p(fnode:getPositionX(),fnode:getPositionY()),true)
		fnode:removeFromParent()
	end
	local imgAn = img:getAnchorPoint()
	self.contentSize = cc.size(imgTag:getContentSize().width/2 + img:getPositionX() + (1-imgAn.x)*img:getContentSize().width,
								img:getContentSize().height)
								
end
function TmjOperationGang:touchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if self.chooseFun then
			self.chooseFun(self.operation,self.operationData)
		end
	end
end

return TmjOperationGang
