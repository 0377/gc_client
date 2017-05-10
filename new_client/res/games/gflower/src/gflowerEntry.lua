local gflowerEntry = class("gflowerEntry");
local GFlowerGameSceneLayer = requireForGameLuaFile("GFlowerGameScene");
requireForGameLuaFile("GFlowerGameManager");

function gflowerEntry:ctor()
	-- body
	--MusicAndSoundManager:getInstance()
	local gflowerGameManager = GFlowerGameManager:getInstance();
	GameManager:getInstance():getHallManager():setSubGameManager(gflowerGameManager);
end

function gflowerEntry:getStartScene(infoTab)

    --dump(infoTab, "----------------------------------------------------------------------------进入炸金花")
    GameManager:getInstance():getHallManager():getSubGameManager():getDataManager():_onMsg_EnterRoomAndSitDownInfo(infoTab)

    local sceneLayer = GFlowerGameSceneLayer:getInstance(true)
    local scene = cc.Scene:create();
    scene:addChild(sceneLayer);

    return scene;
end

function gflowerEntry:getNeedPreloadResArray()
    -- body
    return GFlowerGameSceneLayer.getNeedPreloadResArray()
end

return gflowerEntry

-----------------------------------------------------------------------------------------------------------