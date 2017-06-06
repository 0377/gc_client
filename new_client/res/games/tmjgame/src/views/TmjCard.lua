-------------------------------------------------------------------------
-- Desc:    二人麻将单个麻将牌
-- Author:  zengzx
-- Date:    2017.4.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjCard = class("TmjCard",cc.Node)
local TmjConfig = import("..cfg.TmjConfig")
local TmjHelper = import("..cfg.TmjHelper")
local CardNodePath = requireForGameLuaFile("TmjCardNodeCCS")
local FileUtils = cc.FileUtils:getInstance()
local chooseUpDiff = cc.p(0,30) --选中时位置差
function TmjCard:ctor(data)
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.mState = TmjConfig.CardState.State_None
	--cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/cardplist.plist")
	self:init(data)
	self.isGrayState = false --是否是灰色状态 灰色的时候不能被选中
end
--初始化麻将牌
function TmjCard:init(data)
	self.cardInfo = data
	if self.cardInfo.val < TmjConfig.Card.R_0 or self.cardInfo.val > TmjConfig.Card.R_Chry then
		
		self.cardInfo.val = TmjConfig.Card.R_0
		--return false
	end
	local texturePath = string.format("game_res/cards/mj_%d.png",self.cardInfo.val)
	
	if not TmjHelper.isLuaNodeValid(self.node) then
		local cardNodeBundle = CardNodePath:create()
		self.node = cardNodeBundle.root
		self.animation = cardNodeBundle.animation
		self.node:addTo(self)
		self.node:runAction(self.animation)
		
	end
	self.animation:play("animation0",true)
	
	self.faceImg = CustomHelper.seekNodeByName(self.node,"Image_card")
	self.cardImg = CustomHelper.seekNodeByName(self.node,"cardImg")

	self.faceImg_1 = CustomHelper.seekNodeByName(self.node,"Image_card_1")
	self.cardImg_1 = CustomHelper.seekNodeByName(self.node,"cardImg_1")
	
	self.backImg = CustomHelper.seekNodeByName(self.node,"Image_back")
	
	self.tingImg = CustomHelper.seekNodeByName(self.node,"Image_ting")
	
	if cc.FileUtils:getInstance():isFileExist(texturePath) then
		self.cardImg:loadTexture(texturePath)
		self.cardImg_1:loadTexture(texturePath)
	else --不存在的牌都显示背面
		self:showBack()
	end
	if data.scale then
		self:setScale(data.scale)
	end
	if data.position then
		self:setCardPosition(data.position,false)
	end
	local mState = data.state or self.mState
	self:changeState(mState)
	return true
end
--克隆一张牌
function TmjCard:clone()
	local card = TmjCard:create(self.cardInfo)
	card.mState = self.mState
	card:setCardPosition(self.locationPos,true)
	return card
end

--显示背面
function TmjCard:showBack()
	self.animation:play("animation0",true)
end
--显示正面
function TmjCard:showFront()
	--self.backImg:setVisible(false)
	--self.faceImg:setVisible(true)
	self.animation:play("animation1",true)
end
--获取牌的尺寸 这里返回的尺寸和牌的状态有关
function TmjCard:getContentSize()
	local contentSize = cc.size(0,0)
	if self.mState==TmjConfig.CardState.State_None then
		--这个牌
		local size = self.backImg:getContentSize()
		contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	elseif self.mState == TmjConfig.CardState.State_Up or
		self.mState == TmjConfig.CardState.State_Down then
			--手上牌的尺寸
			local size = self.faceImg:getContentSize()
			contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	elseif self.mState == TmjConfig.CardState.State_Discard then
			--打出去牌的尺寸
		local size = self.faceImg_1:getContentSize()
		contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	elseif self.mState == TmjConfig.CardState.State_Extra then
		--额外牌的尺寸
		local size = self.faceImg_1:getContentSize()
		contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	end
	return contentSize
end
function TmjCard:setCardPosition(pos,isSet)
	self.locationPos = pos
	if isSet and self.locationPos then
		self:setPosition(self.locationPos)
	end
end
function TmjCard:setOpacity(opacity)
	self.faceImg:setOpacity(opacity)
end

function TmjCard:setGray( ... )
	-- body
	self.isGrayState = true
	self.faceImg:setColor(cc.c3b(0x7F,0x7F,0x7F))
	self.cardImg:setColor(cc.c3b(0x7F,0x7F,0x7F))
	self.faceImg_1:setColor(cc.c3b(0x7F,0x7F,0x7F))
	self.cardImg_1:setColor(cc.c3b(0x7F,0x7F,0x7F))
end

function TmjCard:reSetGray( ... )
	-- body
	self.isGrayState = false
	self.faceImg:setColor(cc.c3b(0xFF,0xFF,0xFF))
	self.cardImg:setColor(cc.c3b(0xFF,0xFF,0xFF))
	self.faceImg_1:setColor(cc.c3b(0xFF,0xFF,0xFF))
	self.cardImg_1:setColor(cc.c3b(0xFF,0xFF,0xFF))
end

--切换状态
function TmjCard:changeState(newState,param)
	if self.mState == newState then
		return
	end
	self.mState = newState
	
	local methodName = "on"..string.ucfirst(newState)
	if self[methodName] then
		self[methodName](self,param)
	end
end
function TmjCard:getState()
	return self.mState
end
--判断是否触摸到当前牌
function TmjCard:isContainsTouch(touchPos)
	--灰色牌，不能被选中
	if self.isGrayState then
		return false
	end
	--打出去的牌不响应触摸事件
	if TmjConfig.CardState.State_Discard == self.mState
	or TmjConfig.CardState.State_None == self.mState then
		return false
	end
	
	local point = touchPos
	--转化成节点坐标系
	local nodePoint = self:convertToNodeSpace(point)
	local rect = self.faceImg:getBoundingBox()

	if cc.rectContainsPoint(rect, nodePoint) then
		return true
    end

	return false
end
function TmjCard:moveToPosition(worldPos)
	
end
--是否显示听图标
function TmjCard:setTingTag(isShow)
	self.tingImg:setVisible(isShow)
end
function TmjCard:onStateNone(param)
	self:setScale(0.9)
	self.animation:play("animation0",true)
end

function TmjCard:onStateDiscard(param)
	--self:setPosition(display.center)
	self:setScale(0.6)
	self.animation:play("animation2",true)
end

function TmjCard:onStateDown(param)
	self:setPosition(self.locationPos)
	self:setScale(1)
	self.animation:play("animation1",true)
end

function TmjCard:onStateUp(param)
	self:setPosition(cc.pAdd(self.locationPos,chooseUpDiff))
	self:setScale(1)
	self.animation:play("animation1",true)
end
--牌状态 吃，碰，刚
function TmjCard:onStateExtra(param)
	self:setScale(1)
	self.animation:play("animation2",true)
end
return TmjCard