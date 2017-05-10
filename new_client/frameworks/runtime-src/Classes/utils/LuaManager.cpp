#include "LuaManager.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "3rd/pbc-cloud/pbc-lua.h"
#include "3rd/cjson/lua_extensions.h"
#include "3rd/lsqlite3/lua_extensions_more.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"
#include "lua_module_register.h"
#include "lua-bridge/lua_NetworkManager_auto.hpp"
#include "lua-bridge/lua_LuaBridgeUtils_auto.hpp"
#include "lua-bridge/lua_LuaBridgeUtils_manual.hpp"
#include "lua-bridge/lua_MyDownloader_manual.hpp"
#include "lua-bridge/lua_game_fishgame2d_auto.hpp"
#include "game/fishgame2d/lua_fishgame_manual.h"
#include "lua-bridge/lua_XMLParser_auto.hpp"
#include "my-cocos-ext/lua_my_cocos_ext_manual.h"
#include "lua-bridge/lua_HLCustomRichText_auto.hpp"
static LuaManager* _luaManager = nullptr;
LuaManager* LuaManager::getInstance()
{
	if (_luaManager == nullptr)
	{
		_luaManager = new LuaManager();
	}
	return _luaManager;
}

LuaManager::LuaManager()
{
	init();
}
 
LuaManager::~LuaManager()
{

}
 
bool LuaManager::init()
{
	_luaEngine = LuaEngine::getInstance();
	_luaState = _luaEngine->getLuaStack()->getLuaState();
	ScriptEngineManager::getInstance()->setScriptEngine(_luaEngine);

	return true;
}


 
#pragma mark - 注册相关lua
void LuaManager::initGameLua()
{

	lua_module_register(_luaState);
	//networkNetManager register to lua
	register_all_NetworkManager(_luaState);
	//LuaBridgeUtils
	register_all_LuaBridgeUtils(_luaState);
	register_all_LuaBridgeUtils_manual(_luaState);
	//downloader 
	register_all_MyDownloader(_luaState);

	// 注册自定义扩展;6
	register_all_my_cocos_ext_manual(_luaState);
	register_all_game_fishgame2d(_luaState);
	register_all_fishgame_manual(_luaState);
	register_all_XMLParser(_luaState);
	//注册lsqlite3
	luaopen_lua_extensions_more(_luaState);
	register_all_HLCustomRichText(_luaState);
	//注册云风pbc lua
	luaopen_protobuf_c(_luaState);
	//注册cjson
	luaopen_lua_extensions_cjson(_luaState);
}
