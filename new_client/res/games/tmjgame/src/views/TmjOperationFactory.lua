-------------------------------------------------------------------------
-- Desc:    二人麻将 出牌操作提示 管理工厂
-- Author:  zengzx
-- Date:    2017.4.28
-- Last: 
-- Content:  
--    1.根据操作类型 创建操作节点组合UI
--	  2.听牌的时候，需要特殊处理，点击听牌的时候不发送命令执行完毕
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
TmjOperationFactory = class("TmjOperationFactory")
local TmjOperationChi = requireForGameLuaFile("TmjOperationChi")
local TmjOperationGang = requireForGameLuaFile("TmjOperationGang")
local TmjOperationPeng = requireForGameLuaFile("TmjOperationPeng")
local TmjOperationHu = requireForGameLuaFile("TmjOperationHu")
local TmjOperationTing = requireForGameLuaFile("TmjOperationTing")

local TmjHelper = import("..cfg.TmjHelper")
local TmjConfig = import("..cfg.TmjConfig")
local TmjCardTip = import("..cfg.TmjCardTip")

function TmjOperationFactory:ctor()
	self.logTag = self.__cname..".lua"
	self.operationPanel = {}
	self.blockWidget = nil
	self.tingCancelBtn = nil --听取消按钮
end
--设置开始的位置
function TmjOperationFactory:setStartPos(position)
	self.startPosition = position
end

--创建操作节点
--@param parentNode 父节点
--@param operation TmjConfig.cardOperation 中的操作类型
--@param operationData 操作可选的数据展示
--@param chooseFun 选择回调
function TmjOperationFactory:createOperationWidget(parentNode,operation,operationData,chooseFun)
	local TmjOperationWidget = nil
	parentNode = parentNode or display.getRunningScene()
	--self:clearOperation()
	if operation==TmjCardTip.CardOperation.Chi then
		TmjOperationWidget = TmjOperationChi:create(operationData,chooseFun)
	elseif operation==TmjCardTip.CardOperation.Peng then
		TmjOperationWidget = TmjOperationPeng:create(operationData,chooseFun)
	elseif operation==TmjCardTip.CardOperation.Gang or operation==TmjCardTip.CardOperation.AnGang
	or operation==TmjCardTip.CardOperation.BuGang then
		TmjOperationWidget = TmjOperationGang:create(operation,operationData,chooseFun)
	elseif operation==TmjCardTip.CardOperation.Hu then
		TmjOperationWidget = TmjOperationHu:create(operationData,chooseFun)
	elseif operation == TmjCardTip.CardOperation.Ting then
		TmjOperationWidget = TmjOperationTing:create(operationData,function (result)
			self:setOperationVisible(false)
			self:showTingCancel(parentNode)
			if chooseFun then
				chooseFun(TmjConfig.cardOperation.Ting,result)
			end
		end)
	end
	
--[[	if not TmjHelper.isLuaNodeValid(self.blockWidget) then
		self.blockWidget = ccui.Widget:create()
		self.blockWidget:setAnchorPoint(cc.p(0.5,0.5))
		self.blockWidget:setContentSize(cc.size(display.width,self.startPosition.y ))
		self.blockWidget:setTouchEnabled(true)
		self.blockWidget:addTo(parentNode,TmjConfig.LayerOrder.GAME_OPERATION_LAYER)
		self.blockWidget:setPosition(cc.p(display.width/2,self.startPosition.y/2 ))
	end--]]
	--TmjConfig.LayerOrder.GAME_OPERATION_LAYER
	if TmjOperationWidget then
		parentNode:addChild(TmjOperationWidget,TmjConfig.LayerOrder.GAME_OPERATION_LAYER)
		self.operationPanel = self.operationPanel or {}
		table.insert(self.operationPanel,TmjOperationWidget)
		self:sortOperationPosition()
	end
	
end
--取消听的时候 回调
function TmjOperationFactory:setCancelTingFun(cancelFun)
	self.tingCancelFun = cancelFun
end
--显示取消听的界面
function TmjOperationFactory:showTingCancel(parentNode)
	local node = requireForGameLuaFile("TmjTingCancelNodeCCS"):create()
	self.tingCancelBtn = node.root
	parentNode:addChild(node.root,10)
	local btnTingCancel = CustomHelper.seekNodeByName(node.root,"Button_ting_cancel")
	node.root:setPosition(cc.pSub(self.startPosition,cc.p(btnTingCancel:getContentSize().width,0)))
	CustomHelper.seekNodeByName(node.root,"Button_ting_cancel"):addTouchEventListener(function (ref,eventType)
		if eventType==ccui.TouchEventType.began then
			TmjConfig.playButtonSound()
		elseif eventType == ccui.TouchEventType.ended then
			self:setOperationVisible(true)
			self.tingCancelBtn = nil
			node.root:removeFromParent()
			if self.tingCancelFun then
				self.tingCancelFun()
			end
		end
	end)
	
end

--设置操作的显示情况
function TmjOperationFactory:setOperationVisible(visible)
	if TmjHelper.isLuaNodeValid(self.blockWidget) then
		self.blockWidget:setVisible(visible)
	end
	if self.operationPanel then
		table.walk(self.operationPanel,function (TmjOperationWidget,i)
			if TmjHelper.isLuaNodeValid(TmjOperationWidget) then
				TmjOperationWidget:setVisible(visible)
			end
		end)
	end
	
end

--对操作节点进行位置排序
function TmjOperationFactory:sortOperationPosition()
	local curpos = cc.p(self.startPosition.x,self.startPosition.y)
	local len = table.nums(self.operationPanel)
	for i=len,1,-1 do
		local TmjOperationWidget = self.operationPanel[i]
		--ssdump(TmjOperationWidget:getContentSize(),TmjOperationWidget.__cname..".lua 尺寸")
		TmjOperationWidget:setPosition(cc.pSub(curpos,cc.p(TmjOperationWidget:getContentSize().width,0)))
		--ssdump(curpos,TmjOperationWidget.logTag.."设置他的位置")
		curpos.x = curpos.x - TmjOperationWidget:getContentSize().width
		
	end
	
	
end

--清除操作
function TmjOperationFactory:clearOperation()
	if self.operationPanel then
		table.walk(self.operationPanel,function (TmjOperationWidget,k)
			if TmjHelper.isLuaNodeValid(TmjOperationWidget) then
				TmjOperationWidget:removeFromParent()
			end
		end)
	end
	TmjHelper.removeAll(self.operationPanel)
	if TmjHelper.isLuaNodeValid(self.blockWidget) then
		self.blockWidget:removeFromParent()
		self.blockWidget = nil
	end
	if TmjHelper.isLuaNodeValid(self.tingCancelBtn) then
		self.tingCancelBtn:removeFromParent()
	end
end
TmjOperationFactory.instance = nil
function TmjOperationFactory:getInstance()
	if TmjOperationFactory.instance == nil then
		TmjOperationFactory.instance = TmjOperationFactory:create()
	end
	return TmjOperationFactory.instance
end

return TmjOperationFactory