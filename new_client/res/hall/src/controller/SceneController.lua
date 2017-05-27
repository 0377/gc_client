SceneController = class("SceneController");
--去登录场景
local LoadingScene = requireForGameLuaFile("LoadingScene");
function SceneController.goLoginScene()
	local LoginScene = requireForGameLuaFile("LoginScene");
	local loginScene = LoginScene:create();
    SceneController.goOneScene(loginScene)
end

--去大厅场景
function SceneController.goHallScene(secondLayer)
	local HallScene = requireForGameLuaFile("HallScene");
	print("SceneController.goHallScene() SceneController.goHallScene() SceneController.goHallScene()")
    local needPreloadResArray = HallScene.getNeedPreloadResArray()
    SceneController.goOneSceneWithPreloadArray(needPreloadResArray,function()
        print("hall scene preload finished")
        local hallScene = HallScene:create();
        hallScene:setSecondLayer(secondLayer)
        SceneController.goOneScene(hallScene);
    	-- hallScene:showWithScene();
    end)
end
--
function SceneController.goLaunchScene()
    CustomHelper.cleanMemeryCache()
	local LaunchScene = requireForGameLuaFile("LaunchScene");
	local launchScene = LaunchScene:create();
    SceneController.goOneScene(launchScene);
	-- launchScene:showWithScene();
end
function SceneController.goOneSceneWithPreloadArray(needArray,finishedCallback,versionStr)
    CustomHelper.cleanMemeryCache()
	local loadingLayer = LoadingScene:create(needArray,finishedCallback, versionStr)
    --进入加载场景
    local scene = cc.Scene:create()
    scene:addChild(loadingLayer)
    SceneController.goOneScene(scene)
end
function SceneController.goOneScene(scene)
    if cc.Director:getInstance():getRunningScene() then
        --todo
        cc.Director:getInstance():replaceScene(scene);
    else
        cc.Director:getInstance():runWithScene(scene);
    end
end