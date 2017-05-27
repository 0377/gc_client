local QznnGameEntry = class("QznnGameEntry");
local QznnGameScene = import(".views.QznnGameScene");
--import(".MusicAndSoundManager");
import(".controller.QznnGameManager");
function QznnGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local qznnGameManager = QznnGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(qznnGameManager);
end
function QznnGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	--QznnGameManager:getInstance():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	--local tt = GameManager:getInstance():getHallManager():getSubGameManager()
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = QznnGameScene:create()
	local scene = cc.Scene:create();
	
	--print("--------111-------")
	scene:addChild(sceneLayer);
	return scene;
end


function QznnGameEntry:getNeedPreloadResArray()
	-- body
	return QznnGameScene.getNeedPreloadResArray()
	--return {}
end

function QznnGameEntry:getVerionStr()
    return "抢庄牛牛.v2"
end

return QznnGameEntry;