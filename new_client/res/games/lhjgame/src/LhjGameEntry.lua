local LhjGameEntry = class("LhjGameEntry");
local LhjGameScene = import(".views.LhjGameScene");
--import(".MusicAndSoundManager");
import(".controller.LhjGameManager");
function LhjGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local LhjGameManager = LhjGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(LhjGameManager);
end
function LhjGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = LhjGameScene:create()
	local scene = cc.Scene:create();
	scene:addChild(sceneLayer);
	return scene;
end
function LhjGameEntry:getNeedPreloadResArray()
	-- body
	return LhjGameScene.getNeedPreloadResArray()
end

function LhjGameEntry:getVerionStr()
    return "老虎机.v3"
end

return LhjGameEntry;