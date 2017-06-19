local DdzGameEntry = class("DdzGameEntry");
local DdzGameScene = import(".views.DdzGameScene");
--import(".MusicAndSoundManager");
import(".controller.DdzGameManager");
function DdzGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local ddzGameManager = DdzGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(ddzGameManager);
end
function DdzGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab, "infoTab")
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():_onMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = DdzGameScene:create()
	local scene = cc.Scene:create();
	scene:addChild(sceneLayer);
	return scene;
end
function DdzGameEntry:getNeedPreloadResArray()
	-- body
	return DdzGameScene.getNeedPreloadResArray()
end

function DdzGameEntry:getVerionStr()
	return "斗地主.v6"
end

return DdzGameEntry;