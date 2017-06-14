-------------------------------------------------------------------------
-- Desc:    二人梭哈
-- Author:  zengzx
-- Date:    2017.5.17
-- Last: 
-- Content:  动画播放工厂
-- Modify:
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameSceneFactory = class("SHGameSceneFactory")
local SHConfig = import("..cfg.SHConfig")
--根据房间类型创建场景
function SHGameSceneFactory.createScene(mType)
	local SHGameBaseScene = nil
	local sceneObj = nil
	if mType == SHConfig.roomType.NORMAL then
		SHGameBaseScene = requireForGameLuaFile("SHGameNormalScene")
		sceneObj = SHGameBaseScene:create()
	elseif mType == SHConfig.roomType.PRIVATE then
		SHGameBaseScene = requireForGameLuaFile("SHGamePrivateScene")
		sceneObj = SHGameBaseScene:create()
	end
	return sceneObj
end


return SHGameSceneFactory