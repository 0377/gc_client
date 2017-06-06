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
local SHGameScene = import(".views.SHGameScene")
import(".controller.SHGameManager")
import(".cfg.SHi18nUtils")
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
	
	subGameManager:getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = SHGameScene:create()
	local scene = cc.Scene:create()
	scene:addChild(sceneLayer)
	subGameManager:getDataManager():setGameScene(sceneLayer)
	return scene
end
function SHGameEntry:getNeedPreloadResArray()
	-- body
	return SHGameScene.getNeedPreloadResArray()
end

function SHGameEntry:getVerionStr()
    return "二人梭哈.v3"
end

return SHGameEntry