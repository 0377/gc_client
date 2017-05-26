-------------------------------------------------------------------------
-- Desc:    二人梭哈
-- Author:  zengzx
-- Date:    2017.5.17
-- Last: 
-- Content:  文字动画播放模型
-- Modify:
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local CharacterAnimator = class("CharacterAnimator",requireForGameLuaFile("ChatBaseAnimator"))
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")

local Chat_TextMsg = requireForGameLuaFile("Chat_TextMsgCCS")
function CharacterAnimator:ctor()
	self.super.ctor(self,SHConfig.animatorType.Character)
	
	self.chatNode = nil --聊天节点
end

function CharacterAnimator:init(aniData,playdata)
	self.super.init(self,aniData,playdata)
	local datas = string.split(aniData.content or "","|")
	if datas and table.nums(datas) >=2 then
		self.content = datas[2]
		self.soundIndex = tonumber(datas[1])
	else
		self.content = ""
		self.soundIndex = 0
	end
	self.parentNode = playdata.parentNode or display.getRunningScene()--动画播放的父节点
	self.position = playdata.position or cc.p(0,0) --动画播放的位置
	self.zorder = playdata.zorder or 10 --动画的层级
	self.flippedX = playdata.flippedX or false --是否X轴反转
	self.flippedY = playdata.flippedY or false --是否X轴反转
	self.isMan = playdata.isMan or false --是否是男的
end

function CharacterAnimator:play()
	sslog(self.logTag,"文字动画开始播放...")
	self.super.play(self)
	--播放音效
	SHConfig.playSound(self.soundIndex,self.isMan)
	
	if SHHelper.isLuaNodeValid(self.parentNode) then --这里防止节点被释放了，释放了，那么这个动画就停止播放
		sslog(self.logTag,"文字内容 %s",self.content)
		local textHandles = Chat_TextMsg:create()
		self.parentNode:addChild(textHandles.root,self.zorder)
		
		local imgBg = textHandles.root:getChildByName("Image_bg")
		imgBg:setFlippedX(self.flippedX)
		imgBg:setFlippedY(self.flippedY)
		
		--print(ToolCom:wrapString(self.content,SHConfig.characterBubbleMaxLen))
		local textContent = cc.Label:createWithSystemFont(self.content,"", 24)
		--#21504a
		textContent:setColor(cc.c3b(0x26,0x2b,0x4b))
		textContent:setAnchorPoint(cc.p(0.5,0.5))
		textContent:setScaleX(self.flippedX and -1 or 1)
		textContent:setScaleY(self.flippedY and -1 or 1)
		local textSize = textContent:getContentSize()
		local oldSize = imgBg:getContentSize()
		local newSize = textSize
		newSize.width = textSize.width+20
		newSize.height = textSize.height+40
		imgBg:setContentSize(newSize)
		local imgSize = imgBg:getContentSize()
		textContent:setPosition(cc.p(imgSize.width/2,(imgSize.height+20)/2))
		
		imgBg:addChild(textContent)
	
		textHandles.root:setPosition(self.position)
		self.chatNode = textHandles.root
		self.chatNode:runAction(transition.sequence{
			cc.DelayTime:create(5.0),
			cc.CallFunc:create(handler(self,self.stop))
		 })
	else
		self:stop()
	end
	
end

function CharacterAnimator:stop()
	self.super.stop(self)
	if SHHelper.isLuaNodeValid(self.chatNode) then
		sslog(self.logTag,"文字动画播放完毕...")
		self.chatNode:removeFromParent()
	end
end
return CharacterAnimator