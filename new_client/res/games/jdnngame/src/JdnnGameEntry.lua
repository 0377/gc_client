local JdnnGameEntry = class("JdnnGameEntry");
local JdnnGameScene = import(".views.JdnnGameScene");
--import(".MusicAndSoundManager");
import(".controller.JdnnGameManager");
function JdnnGameEntry:ctor()
	-- body
	MusicAndSoundManager:getInstance()

	local jdnnGameManager = JdnnGameManager:getInstance();
	
	GameManager:getInstance():getHallManager():setSubGameManager(jdnnGameManager);
end
function JdnnGameEntry:getStartScene(infoTab)
	--注册SubGameManager对象
	--ddzGameManager:
	dump(infoTab,"----infoTab")
	--JdnnGameManager:getInstance():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	--local tt = GameManager:getInstance():getHallManager():getSubGameManager()
	GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():OnMsg_EnterRoomAndSitDownInfo(infoTab)
	local sceneLayer = JdnnGameScene:create()
	local scene = cc.Scene:create();
	
	--print("--------111-------")
	scene:addChild(sceneLayer);
	return scene;
end


function JdnnGameEntry:getNeedPreloadResArray()
	-- body
	return JdnnGameScene.getNeedPreloadResArray()
	--return {}
end

function JdnnGameEntry:getVerionStr()
    return "抢庄牛牛.v8"
end

return JdnnGameEntry;