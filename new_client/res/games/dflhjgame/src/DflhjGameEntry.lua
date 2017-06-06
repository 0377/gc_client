local DflhjGameEntry = class("DflhjGameEntry");
local DflhjGameScene = import(".views.DflhjGameScene");
--import(".MusicAndSoundManager");
import(".controller.DflhjGameManager");
function DflhjGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local DflhjGameManager = DflhjGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(DflhjGameManager);
end
function DflhjGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = DflhjGameScene:create()
	local scene = cc.Scene:create();
	scene:addChild(sceneLayer);
	return scene;
end
function DflhjGameEntry:getNeedPreloadResArray()
	-- body
	return DflhjGameScene.getNeedPreloadResArray()
end

function DflhjGameEntry:getVerionStr()
    return "多福老虎机.v1"
end

return DflhjGameEntry;