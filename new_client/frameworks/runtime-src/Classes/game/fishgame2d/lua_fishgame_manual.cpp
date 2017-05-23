#include "fishgame2d.h"


#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int tolua_fishgame_FishObjectManager_RegisterBulletHitFishHandler(lua_State* tolua_S)
{
	int argc = 0;
	NS_FISHGAME2D::FishObjectManager* cobj = nullptr;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertype(tolua_S, 1, "game.fishgame2d.FishObjectManager", 0, &tolua_err)) goto tolua_lerror;
#endif

	cobj = (NS_FISHGAME2D::FishObjectManager*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
	if (!cobj)
	{
		tolua_error(tolua_S, "invalid 'cobj' in function 'tolua_fishgame_FishObjectManager_RegisterBulletHitFishHandler'", nullptr);
		return 0;
	}
#endif

	argc = lua_gettop(tolua_S) - 1;
	if (argc == 1)
	{
		int handler = toluafix_ref_function(tolua_S, 2, 0);
		cobj->RegisterBulletHitFishHandler(handler);
		return 0;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:RegisterBulletHitFishHandler", argc, 1);
	return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'tolua_fishgame_FishObjectManager_RegisterBulletHitFishHandler'.", &tolua_err);
#endif

	return 0;
}

int tolua_fishgame_FishObjectManager_RegisterEffectHandler(lua_State* tolua_S)
{
	int argc = 0;
	NS_FISHGAME2D::FishObjectManager* cobj = nullptr;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertype(tolua_S, 1, "game.fishgame2d.FishObjectManager", 0, &tolua_err)) goto tolua_lerror;
#endif

	cobj = (NS_FISHGAME2D::FishObjectManager*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
	if (!cobj)
	{
		tolua_error(tolua_S, "invalid 'cobj' in function 'tolua_fishgame_FishObjectManager_RegisterEffectHandler'", nullptr);
		return 0;
	}
#endif

	argc = lua_gettop(tolua_S) - 1;
	if (argc == 1)
	{
		int handler = toluafix_ref_function(tolua_S, 2, 0);
		cobj->RegisterEffectHandler(handler);
		return 0;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:RegisterEffectHandler", argc, 1);
	return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'tolua_fishgame_FishObjectManager_RegisterEffectHandler'.", &tolua_err);
#endif

	return 0;
}

int tolua_fishgame_PathManager_LoadData(lua_State* tolua_S)
{
	int argc = 0;
	NS_FISHGAME2D::PathManager* cobj = nullptr;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertype(tolua_S, 1, "game.fishgame2d.PathManager", 0, &tolua_err)) goto tolua_lerror;
#endif

	cobj = (NS_FISHGAME2D::PathManager*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
	if (!cobj)
	{
		tolua_error(tolua_S, "invalid 'cobj' in function 'tolua_fishgame_PathManager_LoadData'", nullptr);
		return 0;
	}
#endif

	argc = lua_gettop(tolua_S) - 1;
	if (argc == 2)
	{
		std::string arg1_tmp; 
		ok &= luaval_to_std_string(tolua_S, 2, &arg1_tmp, "game.fishgame2d.PathManager:LoadData");

		int handler = toluafix_ref_function(tolua_S, 3, 0);
		cobj->LoadData(arg1_tmp, handler);
		return 0;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "fishgame.PathManager:LoadData", argc, 1);
	return 0;

#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'tolua_fishgame_PathManager_LoadData'.", &tolua_err);
#endif

	return 0;
}


int tolua_fishgame_MyObject_registerStatusChangedHandler(lua_State* tolua_S)
{
	int argc = 0;
	NS_FISHGAME2D::MyObject* cobj = nullptr;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertype(tolua_S, 1, "game.fishgame2d.MyObject", 0, &tolua_err)) goto tolua_lerror;
#endif

	cobj = (NS_FISHGAME2D::MyObject*)tolua_tousertype(tolua_S, 1, 0);

#if COCOS2D_DEBUG >= 1
	if (!cobj)
	{
		tolua_error(tolua_S, "invalid 'cobj' in function 'tolua_fishgame_MyObject_registerStatusChangedHandler'", nullptr);
		return 0;
	}
#endif

	argc = lua_gettop(tolua_S) - 1;
	if (argc == 1)
	{
		int handler = toluafix_ref_function(tolua_S, 2, 0);
		cobj->registerStatusChangedHandler(handler);
		return 0;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject::registerStatusChangedHandler", argc, 1);
	return 0;

#if COCOS2D_DEBUG >= 1
	tolua_lerror:
				tolua_error(tolua_S, "#ferror in function 'tolua_fishgame_MyObject_registerStatusChangedHandler'.", &tolua_err);
#endif

	return 0;
}


static int extendFishObjectManager(lua_State* tolua_S)
{
	tolua_usertype(tolua_S, "game.fishgame2d.FishObjectManager");
	tolua_cclass(tolua_S, "FishObjectManager", "game.fishgame2d.FishObjectManager", "cc.Ref", nullptr);

	tolua_beginmodule(tolua_S, "FishObjectManager");
		tolua_function(tolua_S, "RegisterBulletHitFishHandler", tolua_fishgame_FishObjectManager_RegisterBulletHitFishHandler);
		tolua_function(tolua_S, "RegisterEffectHandler", tolua_fishgame_FishObjectManager_RegisterEffectHandler);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(game::fishgame2d::FishObjectManager).name();
	g_luaType[typeName] = "game.fishgame2d.FishObjectManager";
	g_typeCast["FishObjectManager"] = "game.fishgame2d.FishObjectManager";
	return 1;
}

static int extendPathManager(lua_State* tolua_S)
{
	tolua_usertype(tolua_S, "game.fishgame2d.PathManager");
	tolua_cclass(tolua_S, "PathManager", "game.fishgame2d.PathManager", "cc.Ref", nullptr);

	tolua_beginmodule(tolua_S, "PathManager");
	tolua_function(tolua_S, "LoadData", tolua_fishgame_PathManager_LoadData);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(NS_FISHGAME2D::PathManager).name();
	g_luaType[typeName] = "game.fishgame2d.PathManager";
	g_typeCast["PathManager"] = "game.fishgame2d.PathManager";
	return 1;
}

static int extendMyObject(lua_State* tolua_S) {
	tolua_usertype(tolua_S, "game.fishgame2d.MyObject");
	tolua_cclass(tolua_S, "MyObject", "game.fishgame2d.MyObject", "cc.Node", nullptr);

	tolua_beginmodule(tolua_S, "MyObject");
	tolua_function(tolua_S, "registerStatusChangedHandler", tolua_fishgame_MyObject_registerStatusChangedHandler);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(NS_FISHGAME2D::MyObject).name();
	g_luaType[typeName] = "game.fishgame2d.MyObject";
	g_typeCast["MyObject"] = "game.fishgame2d.MyObject";
	return 1;
}


int register_all_fishgame_manual(lua_State* tolua_S){
	if (NULL == tolua_S)
		return 0;

	extendFishObjectManager(tolua_S);
	extendPathManager(tolua_S);
	extendMyObject(tolua_S);
	return 1;
}
