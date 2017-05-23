-------------------------------------------------------------------------
-- Desc:    二人梭哈单个扑克牌
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHCard = class("SHCard",cc.Node)
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
local CardNodePath = requireForGameLuaFile("SHPokerNodeCCS")
local FileUtils = cc.FileUtils:getInstance()

function SHCard:ctor(data)
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.mState = SHConfig.CardState.State_Empty
	self.isGrayState = false --是否是灰色状态
	self:init(data)
	
end
--初始化扑克牌
function SHCard:init(data)
	self.cardInfo = data
	if self.cardInfo.val < SHConfig.CardVal.V_8 or self.cardInfo.val > SHConfig.CardVal.V_A then
		
		self.cardInfo.val = SHConfig.CardVal.V_0
		--return false
	end
	if self.cardInfo.col < SHConfig.CardColor.T_SPADE or self.cardInfo.col > SHConfig.CardColor.T_HEART then
		
		self.cardInfo.col = SHConfig.CardColor.T_NULL
		--return false
	end
	--牌的资源规则 ("sh_%d_%d.png",花色,点数) 
	local texturePath = string.format("game_res/poker/sh_%d_%d.png",self.cardInfo.col,self.cardInfo.val)
	
	if not SHHelper.isLuaNodeValid(self.node) then
		local cardNodeBundle = CardNodePath:create()
		self.node = cardNodeBundle.root
		self.animation = cardNodeBundle.animation
		self.node:addTo(self)
		self.node:runAction(self.animation)
		
	end
	
	self.faceImg = CustomHelper.seekNodeByName(self.node,"Image_face")
	self.darkImg = CustomHelper.seekNodeByName(self.node,"Image_dark")
	self.backImg = CustomHelper.seekNodeByName(self.node,"Image_back")

	
	if cc.FileUtils:getInstance():isFileExist(texturePath) then
		self.faceImg:loadTexture(texturePath)
		self:showFront(self.cardInfo.isDark)
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
function SHCard:clone()
	local card = SHCard:create(self.cardInfo)
	card.mState = self.mState
	card.scale = self:getScale()
	card:setCardPosition(self.locationPos,true)
	return card
end

--显示背面
function SHCard:showBack()
	--self.faceImg:setVisible(false)
	--self.darkImg:setVisible(false)
	--self.backImg:setVisible(true)
	self.animation:play("animation0",true)
end
--显示正面
function SHCard:showFront(isDark)
	
	if isDark==nil then
		isDark = false
	end

	if isDark then
		self:setGray()
		self.animation:play("animation3",true)
	else
		self:reSetGray()
		self.animation:play("animation2",true)
	end
	--self.faceImg:setVisible(true)
	--self.darkImg:setVisible(isDark)
	--self.backImg:setVisible(false)
	
end

--获取牌的尺寸 这里返回的尺寸和牌的状态有关
function SHCard:getContentSize()
	local contentSize = cc.size(0,0)
	if self.mState==SHConfig.CardState.State_None then
		--这个背面的
		local size = self.backImg:getContentSize()
		contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	else
		--正面 包括显示的暗拍
		local size = self.faceImg:getContentSize()
		contentSize = cc.size(size.width*self:getScale(),size.height*self:getScale())
	end
	return contentSize
end
function SHCard:setCardPosition(pos,isSet)
	
	self.locationPos = pos
	if isSet and self.locationPos then
		self:setPosition(self.locationPos)
	end
end
function SHCard:setOpacity(opacity)
	self.faceImg:setOpacity(opacity)
end

function SHCard:setGray( ... )
	-- body
	self.isGrayState = true
	self.faceImg:setColor(cc.c3b(0x7F,0x7F,0x7F))

end

function SHCard:reSetGray( ... )
	-- body
	self.isGrayState = false
	self.faceImg:setColor(cc.c3b(0xFF,0xFF,0xFF))

end

--切换状态
function SHCard:changeState(newState,param)
	if self.mState == newState then
		return
	end
	self.mState = newState
	
	local methodName = "on"..string.ucfirst(newState)
	if self[methodName] then
		self[methodName](self,param)
	end
end
function SHCard:getState()
	return self.mState
end

function SHCard:onStateNone(param)
	self:showBack()
end
function SHCard:onStateNormal(param)
	--self:showFront(false)
	sslog(self.logTag,"改变状态，亮牌")
	self.animation:play("animation1",false)
	self.animation:setFrameEventCallFunc(function (frame)
		local eventName = frame:getEvent()
		if eventName=="showOver" then
			self.animation:clearFrameEventCallFunc()
			self:showFront(false)
		end
	end)
end
function SHCard:onStateHand(param)
	--self:showFront(true)
	sslog(self.logTag,"改变状态，手牌")
	self.animation:play("animation1",false)
	self.animation:setFrameEventCallFunc(function (frame)
		local eventName = frame:getEvent()
		if eventName=="showOver" then
			self.animation:clearFrameEventCallFunc()
			self:showFront(true)
		end
	end)
end

return SHCard