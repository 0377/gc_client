local HallInit = class("HallInit")
requireForGameLuaFile("HallGameConfig");
requireForGameLuaFile("HallSoundConfig")
requireForGameLuaFile("HallUtils");
requireForGameLuaFile("MyToastLayer")
requireForGameLuaFile("VersionModel")
-- HallInit:start();
function HallInit:start()
	SceneController.goLoginScene();
end
return HallInit;