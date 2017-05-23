-------------------------------------------------------------------------
-- Desc:    二人梭哈牌型展示界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHCardTypeLayer = class("SHCardTypeLayer",requireForGameLuaFile("SHPopBaseLayer"))
local SHHelper = import("..cfg.SHHelper")
local SHConfig = import("..cfg.SHConfig")

local SHCardTypeLayerNode = requireForGameLuaFile("SHCardTypeLayerCCS")
--@param handCards 手上的牌列表
function SHCardTypeLayer:ctor(handCards)
	SHCardTypeLayer.super.ctor(self)
	self:setName("SHCardTypeLayer")
	
	self.handCards = CustomHelper.copyTab(handCards)
	self:initView()
	
end

function SHCardTypeLayer:initView()
	local node = SHCardTypeLayerNode:create()
	self:addChild(node.root)
	self.rootNode = node.root
	self:refreshCardType(self.handCards)
	local Image_bg = CustomHelper.seekNodeByName(node.root,"Image_bg")
	self:popIn(Image_bg,SHConfig.Pop_Dir.Left)
end
--刷新牌型界面 需要显示哪个
--@param handCards 输入的牌数据
function SHCardTypeLayer:refreshCardType(handCards)
	local cardType = SHHelper.getCardType(handCards)
	for i=1,9 do
		local img = CustomHelper.seekNodeByName(self.rootNode,string.format("Image_%d",i))
		img:setVisible(cardType == i) --当前牌型高亮
	end
end

function SHCardTypeLayer:backListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		SHConfig.playButtonSound()
	elseif eventType==ccui.TouchEventType.ended then
		if ref:getName()=="Button_back" then
			self:removeFromParent()
		end
	end
end

function SHCardTypeLayer:onExit()
	SHCardTypeLayer.super.onExit(self)
	SHHelper.removeAll(self.handCards)
end


return SHCardTypeLayer