-------------------------------------------------------------------------
-- Desc:    二人麻将入口
-- Author:  zengzx
-- Date:    2017.4.10
-- Last: 
-- Content:  
--    
-- Copyright (c) Shusi Entertainment All right reserved.
--------------------------------------------------------------------------
local TmjGameEntry = class("TmjGameEntry")
local TmjGameScene = import(".views.TmjGameScene")
import(".controller.TmjGameManager")
import(".cfg.Tmji18nUtils")
function TmjGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()
	Tmji18nUtils:getInstance():load('cfg.TmjString', 'zh')
	GameManager:getInstance():getHallManager():setSubGameManager(TmjGameManager:getInstance())
end
function TmjGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	ssdump(infoTab,"----infoTab",3)
	local subGameManager = GameManager:getInstance():getHallManager():getSubGameManager()
	
	subGameManager:getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = TmjGameScene:create()
	local scene = cc.Scene:create()
	scene:addChild(sceneLayer)
	subGameManager:getDataManager():setGameScene(sceneLayer)
	return scene
end
function TmjGameEntry:getNeedPreloadResArray()
	-- body
	return TmjGameScene.getNeedPreloadResArray()
end

function TmjGameEntry:getVerionStr()
    return "二人麻将.v6"
end

return TmjGameEntry