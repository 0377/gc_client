local TestGameEntry = class("TestGameEntry");
local TestGameSceneLayer = import(".views.TestGameScene");
import(".controller.TestGameManager");
--在切换场景之前会调用，用于游戏初始化
function TestGameEntry:ctor()

end
--获取进入游戏场景需要预加载的资源数组，每个元素为完整路径
function TestGameEntry:getNeedPreloadResArray()
	-- body
	return {}
end
--在loading资源完成后调用
function TestGameEntry:getStartScene()
	--注册SubGameManager对象
	local testGameManager = TestGameManager:getInstance();
	GameManager:getInstance():getHallManager():setSubGameManager(testGameManager);
	local sceneLayer = TestGameSceneLayer:create();
	--创建一个scene
	local scene = cc.Scene:create();
	scene:addChild(sceneLayer);
	return scene;
end
return TestGameEntry;