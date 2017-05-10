-------------------------------------------------------------------------
-- Desc:    二人麻将番型信息界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjFanXinInfoLayer = class("TmjFanXinInfoLayer",cc.Layer)
local TmjHelper = import("..cfg.TmjHelper")
local TmjConfig = import("..cfg.TmjConfig")

local TmjFanXinInfoLayerNode = requireForGameLuaFile("TmjFanXInfoLayerCCS")
function TmjFanXinInfoLayer:ctor()
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self:initView()
	self:initCheckGroup()
end

function TmjFanXinInfoLayer:initView()
	local node = TmjFanXinInfoLayerNode:create()
	self:addChild(node.root)
	self.node = node.root
	--ScrollView_content
	CustomHelper.seekNodeByName(self.node,"Button_back"):addTouchEventListener(handler(self,self.backListener))
	self.scrollView = CustomHelper.seekNodeByName(self.node,"ScrollView_content")
	self.scrollView:setScrollBarEnabled(false)
	
	
	self.imgSlider = CustomHelper.seekNodeByName(self.node,"Image_slider")
	self.imgBar = CustomHelper.seekNodeByName(self.node,"Image_bar")
	self.imgBar:addTouchEventListener(handler(self,self.barListener))
	
	self.barPosYLimit = {
		15,471.5
	}
end

function TmjFanXinInfoLayer:initCheckGroup()
	--Panel_buttons
	local pannelGroup = CustomHelper.seekNodeByName(self.node,"Panel_buttons")
	
	TmjHelper.removeAll(self.checkGroups)
	TmjHelper.removeAll(self.groupPercents)
	self.checkGroups = {}
	self.groupPercents = {}
	local count = pannelGroup:getChildrenCount()
	for index = 1,count do
		local checkbox = pannelGroup:getChildByName(string.format("CheckBox_%d",index))
		if checkbox then
			checkbox:addEventListener(handler(self,self.checkListener))
		end
		checkbox:setTag(index)
		self.checkGroups[index] = checkbox
		
	end
	self.groupPercents = {
		0,19,30,39,47,56,64,66,71,79,85,94,
	}
end

-- ccui.CheckBoxEventType     selected = 0,   unselected = 1,
function TmjFanXinInfoLayer:checkListener(ref,eventType)
	--checkbox:setEnabled(not ref:getSelected())
	self:setCheckIndex(ref:getTag())
	-- self.scrollView
	self.scrollView:jumpToPercentVertical(self.groupPercents[ref:getTag()])
end

function TmjFanXinInfoLayer:backListener(ref,eventType)
	if eventType==ccui.TouchEventType.began then
		TmjConfig.playButtonSound()
	elseif eventType==ccui.TouchEventType.ended then
		if ref:getName()=="Button_back" then
			self:removeFromParent()
		end
	end
end

function TmjFanXinInfoLayer:setCheckIndex(index)
	for i,checkbox in pairs(self.checkGroups) do
		checkbox:setSelected(i==index)
		checkbox:setEnabled(i~=index)
	end
end


function TmjFanXinInfoLayer:onExit()
	TmjHelper.removeAll(self.groupPercents)
	TmjHelper.removeAll(self.checkGroups)
	TmjHelper.removeAll(self.barPosYLimit)
end

function TmjFanXinInfoLayer:barListener(ref,eventType)
	
	if eventType == ccui.TouchEventType.began then
		--ref:getTouchBeganPosition()
		local pos = self:convertSliderPosition(ref:getTouchBeganPosition())
		ref:setPositionY(pos.y)
		local percent = self:convertScrollPercent(pos.y)
		self.scrollView:jumpToPercentVertical(percent)
		
		self:setCheckIndex(self:getGroupIndex(percent))
	elseif eventType == ccui.TouchEventType.moved then	
		local pos = self:convertSliderPosition(ref:getTouchMovePosition())
		ref:setPositionY(pos.y)
		local percent = self:convertScrollPercent(pos.y)
		self.scrollView:jumpToPercentVertical(percent)
		self:setCheckIndex(self:getGroupIndex(percent))
	elseif eventType == ccui.TouchEventType.ended then
		
	elseif eventType == ccui.TouchEventType.canceled then
		--
	end
end
--通过百分比，获取当前是在那个番型上
function TmjFanXinInfoLayer:getGroupIndex(percent)
	local index = #self.groupPercents
	for i=#self.groupPercents,1,-1 do
		if self.groupPercents[i]< percent  then
			break
		else
			index = i
		end
	end
	return index
end
--通过位置 转换scrollview的显示百分比
function TmjFanXinInfoLayer:convertScrollPercent(posy)
	return 100 - 100*(posy - self.barPosYLimit[1])/(self.barPosYLimit[2] - self.barPosYLimit[1])
end

function TmjFanXinInfoLayer:convertSliderPosition(pos)
	
	local newpos = self.imgSlider:convertToNodeSpace(pos)
	if newpos.y < self.barPosYLimit[1] then
		newpos.y = self.barPosYLimit[1]
	elseif newpos.y > self.barPosYLimit[2] then
		newpos.y = self.barPosYLimit[2]
	end
	return newpos	
end

return TmjFanXinInfoLayer