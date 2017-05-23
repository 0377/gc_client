-------------------------------------------------------------------------
-- Desc:    二人梭哈二级基础界面
-- Author:  zengzx
-- Date:    2017.5.15
-- Last: 
-- Content:  
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHPopBaseLayer = class("SHPopBaseLayer",cc.LayerColor)
local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")

function SHPopBaseLayer:ctor()
	self.logTag = self.__cname..".lua"
	self:enableNodeEvents()
	self:setTouchEnabled(true)
	self.listenerTouch = cc.EventListenerTouchOneByOne:create()
    self.listenerTouch:setSwallowTouches(true)
    self.listenerTouch:registerScriptHandler(handler(self,self.onTouchBegin),cc.Handler.EVENT_TOUCH_BEGAN)
    self.listenerTouch:registerScriptHandler(handler(self,self.onTouchBegin),cc.Handler.EVENT_TOUCH_ENDED)
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listenerTouch, self)
end


function SHPopBaseLayer:onTouchBegin(touch,event)
  if event:getEventCode() == cc.EventCode.BEGAN then
        return true
    elseif event:getEventCode() == cc.EventCode.ENDED then
        self:close()
    end
end
--关闭
function SHPopBaseLayer:close()
	if SHHelper.isLuaNodeValid(self.popNode) then
		self:popOut()
	else
		if self.DisCallback then
            self.DisCallback()
		else			
            self:removeFromParent()
		end
	end
	
end
function SHPopBaseLayer:onEnter()
	
end
function SHPopBaseLayer:onExit()
	if self.listenerTouch and eventDispatcher then
		eventDispatcher:removeEventListener(self.listenerTouch)
	end
	self.listenerTouch = nil
end


----------------------------------------------------
--弹出效果
----------------------------------------------------
function SHPopBaseLayer:popOut()
    -- body
	local size = cc.Director:getInstance():getVisibleSize()
	local x = self.popNode:getPositionX()
	local y = self.popNode:getPositionY()
	local ConSize = self.popNode:getContentSize()

	local pos = false
	if self.popInDir == SHConfig.Pop_Dir.Up then
		pos = cc.p(x,size.height + ConSize.height/2)
	elseif self.popInDir == SHConfig.Pop_Dir.Down then
		pos = cc.p(x,-ConSize.height/2)
	elseif self.popInDir == SHConfig.Pop_Dir.Left then
		pos = cc.p(-ConSize.width,y)
	elseif self.popInDir == SHConfig.Pop_Dir.Right then
		pos = cc.p(size.width+ConSize.width/2,y)
	end

	local duration = 0.15
	if self.DisCallback then
		self.popNode:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.MoveTo:create(duration, pos)),
			cc.CallFunc:create(function ( ... )
				-- body
				self.DisCallback()
				-- self:removeFromParent()
			end)))
	else
		self.popNode:runAction(cc.Sequence:create(cc.EaseBackIn:create(cc.MoveTo:create(duration, pos)),
			 cc.CallFunc:create(function ( ... )
				-- body
				self:removeFromParent()
			end)))
	end

	

end

----------------------------------------------------
--进入效果
----------------------------------------------------
function SHPopBaseLayer:popIn( node,dir)
    -- body
    self.popNode = node
    self.popInDir = dir

    local size = cc.Director:getInstance():getVisibleSize()
    local x = node:getPositionX()
    local y = node:getPositionY()

    local ConSize = node:getContentSize()

    if dir == SHConfig.Pop_Dir.Up then
        node:setPosition(x,size.height + ConSize.height/2)
    elseif dir == SHConfig.Pop_Dir.Down then
        node:setPosition(x,-ConSize.height/2)
    elseif dir == SHConfig.Pop_Dir.Left then
        node:setPosition(-ConSize.width,y)
    elseif dir == SHConfig.Pop_Dir.Right then
        node:setPosition(size.width+ConSize.width/2,y)
    end

    local duration = 0.2
    node:runAction(cc.Sequence:create(cc.EaseBackOut:create(cc.MoveTo:create(duration, cc.p(x,y)))))
end

return SHPopBaseLayer