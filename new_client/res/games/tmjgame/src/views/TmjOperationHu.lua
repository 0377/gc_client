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
	local doubleBtn = CustomHelper.seekNodeByName(node.root,"Button_double")
	local huBtn = CustomHelper.seekNodeByName(node.root,"Button_hu")
	local passBtn = CustomHelper.seekNodeByName(node.root,"Button_pass")
	
	doubleBtn:addTouchEventListener(handler(self,self.touchListener))
	huBtn:addTouchEventListener(handler(self,self.touchListener))
	passBtn:addTouchEventListener(handler(self,self.touchListener))
	self.contentSize = passBtn:getContentSize()
	
	--passBtn:setVisible(not operationData)
	huBtn:setVisible(operationData)
	doubleBtn:setVisible(operationData)
	
	--如果是胡，那么过和胡显示的位置往下移动，Y在过的地方
	if operationData then
		--huBtn:setPositionY(passBtn:getPositionY())
		--doubleBtn:setPositionY(passBtn:getPositionY())
	end
end
--隐藏过，并且把胡和加倍下移，这种情况只在胡的情况才有
function TmjOperationHu:ingorePassAndSetPosition()
	local doubleBtn = CustomHelper.seekNodeByName(self,"Button_double")
	local huBtn = CustomHelper.seekNodeByName(self,"Button_hu")
	local passBtn = CustomHelper.seekNodeByName(self,"Button_pass")
	if passBtn then
		passBtn:setVisible(false)
	end
	if huBtn then
		huBtn:setPositionY(passBtn:getPositionY())
	end
	if doubleBtn then
		doubleBtn:setPositionY(passBtn:getPositionY())
	end
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
