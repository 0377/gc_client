-------------------------------------------------------------------------
-- Desc:    二人梭哈
-- Author:  zengzx
-- Date:    2017.5.17
-- Last: 
-- Content:  聊天动画基类

-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local ChatBaseAnimator = class("ChatBaseAnimator")
local SHConfig = import("..cfg.SHConfig")
local SHHelper = import("..cfg.SHHelper")
function ChatBaseAnimator:ctor(mType)
	self.mType = mType
	self.playingState = SHConfig.animatorState.Init  --是否在播放
	self.logTag = self.__cname..".lua"
	
end
--初始化
--@param aniData 动画数据
--@param playdata 播放参数
function ChatBaseAnimator:init(aniData,playdata)
	self.aniData = aniData
	self.playdata = playdata
end
--播放动画，这是只是设置播放状态
function ChatBaseAnimator:play()
	self.playingState = SHConfig.animatorState.Playing
end

--停止，设置播放状态
function ChatBaseAnimator:stop()
	self.playingState = SHConfig.animatorState.Stoped
	SHHelper.removeAll(self.aniData)
	SHHelper.removeAll(self.playdata)
end

function ChatBaseAnimator:getType()
	return self.mType
end
function ChatBaseAnimator:getState()
	return self.playingState
end
return ChatBaseAnimator