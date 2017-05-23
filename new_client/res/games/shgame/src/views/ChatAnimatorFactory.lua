-------------------------------------------------------------------------
-- Desc:    二人梭哈
-- Author:  zengzx
-- Date:    2017.5.17
-- Last: 
-- Content:  动画播放工厂
-- Modify:
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local ChatAnimatorFactory = class("ChatAnimatorFactory")
local SHConfig = import("..cfg.SHConfig")
local CharacterAnimator = requireForGameLuaFile("CharacterAnimator")
function ChatAnimatorFactory.createAnimator(aniType,animData,playData)
	local animodule = nil
	if aniType==SHConfig.animatorType.Facial then
		
	elseif aniType == SHConfig.animatorType.Character then
		animodule = CharacterAnimator:create()
	end
	if animodule then
		animodule:init(animData,playData)
	end
	animodule:play()
	return animodule
end

return ChatAnimatorFactory