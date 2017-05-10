-------------------------------------------------------------------------
-- Desc:    二人麻将匹配等待界面
-- Author:  zengzx
-- Date:    2017.4.21
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjGameMatchingLayer = class("TmjGameMatchingLayer",cc.Layer)
local MathcingLayer = requireForGameLuaFile("TmjMatchingLayerCCS")
local TmjConfig = import("..cfg.TmjConfig")
function TmjGameMatchingLayer:ctor(cancelCallback)
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self.cancelCallback = cancelCallback
end

function TmjGameMatchingLayer:onEnter()
	local node = MathcingLayer:create()
	self:addChild(node.root)
	CustomHelper.seekNodeByName(self,"Button_cancel"):addTouchEventListener(function (ref,eventType)
		if eventType==ccui.TouchEventType.began then
			TmjConfig.playButtonSound()
		elseif eventType == ccui.TouchEventType.ended then
			if self.cancelCallback then
				self.cancelCallback()
			end
		end
	end)
end

return TmjGameMatchingLayer