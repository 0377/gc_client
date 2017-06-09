-------------------------------------------------------------------------
-- Desc:    二人麻将操作节点 碰节点
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjOperationPeng = class("TmjOperationPeng",requireForGameLuaFile("TmjOperationWidget"))
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
function TmjOperationPeng:ctor(operationData,chooseFun)
	
	TmjOperationPeng.super.ctor(self,operationData,chooseFun)
end

function TmjOperationPeng:initView(operationData)
	--TmjPengOperationNodeCCS
	local node = requireForGameLuaFile("TmjPengOperationNodeCCS"):create()
	self:addChild(node.root)
	local imgTag = CustomHelper.seekNodeByName(node.root,"Image_tag")
	CustomHelper.seekNodeByName(node.root,"Image_tag"):addTouchEventListener(handler(self,self.touchListener))
	CustomHelper.seekNodeByName(node.root,"Image_1"):addTouchEventListener(handler(self,self.touchListener))
	--Image_1
	local img = CustomHelper.seekNodeByName(node.root,"Image_1")
	for i=1,3 do
		local fnode = img:getChildByName(string.format("FileNode_%d",i))
		fnode:getContentSize()
		
		local card = TmjCard:create({val = operationData,scale = fnode:getScale()/0.6 })
		card:addTo(fnode:getParent())
		--card:setScale(fnode:getScale())
		card:changeState(TmjConfig.CardState.State_Discard)
		card:setCardPosition(cc.p(fnode:getPositionX(),fnode:getPositionY()),true)
		fnode:removeFromParent()
	end
	--Image_1
		
	local imgAn = img:getAnchorPoint()
	self.contentSize = cc.size(imgTag:getContentSize().width/2 + img:getPositionX() + (1-imgAn.x)*img:getContentSize().width,
								img:getContentSize().height)
end

function TmjOperationPeng:touchListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType == ccui.TouchEventType.ended then
		if self.chooseFun then
			self.chooseFun(TmjConfig.cardOperation.Peng,self.operationData)
		end
	end
end


return TmjOperationPeng
