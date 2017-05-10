-------------------------------------------------------------------------
-- Desc:    二人麻将 听胡信息界面
-- Author:  zengzx
-- Date:    2017.4.24
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjTingHuInfo = class("TmjTingHuInfo",cc.Layer)
local TmjCard = requireForGameLuaFile("TmjCard")
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local TmjTingHuInfoNodeCCS = requireForGameLuaFile("TmjTingHuInfoNodeCCS")

--@param huCards 胡牌的信息 数组
--@key val 牌值
--@key count 剩余的张数
--@key fan 多少番
function TmjTingHuInfo:ctor(huCards)
	self:enableNodeEvents()
	self.cards = {}
	self.startPosition = cc.p(display.width/2,250)
	self.diff = 20 --单个间隔
	self:initView(huCards)
end

function TmjTingHuInfo:initView(huCards)
	--TmjPengOperationNodeCCS
	if not huCards or not next(huCards) then
		return
	end
	for _,cardInfo in pairs(huCards) do
		
		--cardInfo.val
		--cardInfo.count
		--cardInfo.fan
		local node = TmjTingHuInfoNodeCCS:create().root
		local img = CustomHelper.seekNodeByName(node,"Image_1")
		local fnode = CustomHelper.seekNodeByName(node,"FileNode_1")
		local textRestCard = CustomHelper.seekNodeByName(node,"Text_restCard")
		local textFan = CustomHelper.seekNodeByName(node,"Text_fan")
		node.size = img:getContentSize()
		node:addTo(self)
		textRestCard:setString(string.format(Tmji18nUtils:getInstance():get('str_mjplay','restCount'),cardInfo.count or 0))
		textFan:setString(string.format(Tmji18nUtils:getInstance():get('str_mjplay','fan'),cardInfo.fan or 0))
		
		local card = TmjCard:create({val = cardInfo.val })
		card:addTo(fnode:getParent())
		card:setCardPosition(cc.p(fnode:getPositionX(),fnode:getPositionY()),true)
		card:changeState(TmjConfig.CardState.State_Down)
		card:setScale(fnode:getScale())
		fnode:removeFromParent()
		
		table.insert(self.cards,node)
	end
	self:sortCardPosition()
end
--重新设置牌的位置
function TmjTingHuInfo:sortCardPosition()
	if self.cards then
		local curpos = cc.p(self.startPosition.x,self.startPosition.y)
		local len = table.nums(self.cards)
		local size = self.cards[1].size
		local total = len*size.width + (len-1)*self.diff
		
		for i=1,len do		
			local node = self.cards[i]
			local x = self.startPosition.x - total/2 + (i-1)*size.width
			node:setPosition(cc.p(x,self.startPosition.y))			
			
		end
	
	end
end


function TmjTingHuInfo:onExit()
	TmjHelper.removeAll(self.cards)
end

function TmjTingHuInfo:touchListener(ref,eventType)
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


return TmjTingHuInfo
