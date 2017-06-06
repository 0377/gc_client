local BrnnGameEntry = class("BrnnGameEntry");
local BrnnGameScene = import(".views.BrnnGameScene");
--import(".MusicAndSoundManager");
import(".controller.BrnnGameManager");
function BrnnGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local brnnGameManager = BrnnGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(brnnGameManager);
end
function BrnnGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = BrnnGameScene:create()
	local scene = cc.Scene:create();
	scene:addChild(sceneLayer);
	return scene;
end
function BrnnGameEntry:getNeedPreloadResArray()
	-- body
	return BrnnGameScene.getNeedPreloadResArray()
end

function BrnnGameEntry:getVerionStr()
	return "百人牛牛.v3"
end

return BrnnGameEntry;