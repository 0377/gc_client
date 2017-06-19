-------------------------------------------------------------------------
-- Desc:    二人梭哈入口
-- Author:  zengzx
-- Date:    2017.5.11
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local SHGameEntry = class("SHGameEntry")
local SHGameSceneFactory = requireForGameLuaFile("SHGameSceneFactory")
local SHGameBaseScene = requireForGameLuaFile("SHGameBaseScene")
local SHConfig = import(".cfg.SHConfig")
import(".controller.SHGameManager")
import(".cfg.SHi18nUtils")
local SHGameSceneClass = nil
function SHGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()
	SHi18nUtils:getInstance():load('cfg.SHString', 'zh')
	GameManager:getInstance():getHallManager():setSubGameManager(SHGameManager:getInstance())
end
function SHGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	ssdump(infoTab,"----infoTab",3)
	local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
	subGameManager:initDataManager(SHConfig.roomType.NORMAL)
	subGameManager:getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	
	local sceneLayer = SHGameSceneFactory.createScene(SHConfig.roomType.NORMAL)
	
	local scene = cc.Scene:create()
	scene:addChild(sceneLayer)
	subGameManager:getDataManager():setGameScene(sceneLayer)
	return scene
end
function SHGameEntry:getNeedPreloadResArray()
	-- body
	return SHGameBaseScene.getNeedPreloadResArray()
end

function SHGameEntry:getVerionStr()
    return "二人梭哈.v5"
end

return SHGameEntry