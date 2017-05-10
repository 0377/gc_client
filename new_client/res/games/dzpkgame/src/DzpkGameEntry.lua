local DzpkGameEntry = class("DzpkGameEntry");
local DzpkGameScene = import(".views.DzpkGameScene");
--import(".MusicAndSoundManager");
import(".controller.DzpkGameManager");
function DzpkGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local dzpkGameManager = DzpkGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(dzpkGameManager);
end
function DzpkGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	--DzpkGameManager:getInstance():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	--local tt = GameManager:getInstance():getHallManager():getSubGameManager()
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = DzpkGameScene:create()
	local scene = cc.Scene:create();
	
	--print("--------111-------")
	scene:addChild(sceneLayer);
	return scene;
end
function DzpkGameEntry:getNeedPreloadResArray()
	-- body
	return DzpkGameScene.getNeedPreloadResArray()
	--return {}
end
return DzpkGameEntry;