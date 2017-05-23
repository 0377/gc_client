#include "lua_NetworkManager_auto.hpp"
#include "../net/NetworkManager.h"
//#include "NetworkManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_NetworkManager_NetworkManager_disconnect(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetworkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_disconnect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetworkManager:disconnect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_disconnect'", nullptr);
            return 0;
        }
        bool ret = cobj->disconnect(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:disconnect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_disconnect'.",&tolua_err);
#endif

    return 0;
}
int lua_NetworkManager_NetworkManager_sendTCPMsg(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetworkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_sendTCPMsg'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        int arg1;
        std::string arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetworkManager:sendTCPMsg");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "NetworkManager:sendTCPMsg");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "NetworkManager:sendTCPMsg");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_sendTCPMsg'", nullptr);
            return 0;
        }
        cobj->sendTCPMsg(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:sendTCPMsg",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_sendTCPMsg'.",&tolua_err);
#endif

    return 0;
}
int lua_NetworkManager_NetworkManager_getTCPConnectionStatus(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetworkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_getTCPConnectionStatus'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetworkManager:getTCPConnectionStatus");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_getTCPConnectionStatus'", nullptr);
            return 0;
        }
        int ret = cobj->getTCPConnectionStatus(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:getTCPConnectionStatus",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_getTCPConnectionStatus'.",&tolua_err);
#endif

    return 0;
}
int lua_NetworkManager_NetworkManager_init(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetworkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_init'.",&tolua_err);
#endif

    return 0;
}
int lua_NetworkManager_NetworkManager_connectTCPSocket(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (NetworkManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_connectTCPSocket'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        std::string arg0;
        std::string arg1;
        int arg2;
        double arg3;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "NetworkManager:connectTCPSocket");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "NetworkManager:connectTCPSocket");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "NetworkManager:connectTCPSocket");

        ok &= luaval_to_number(tolua_S, 5,&arg3, "NetworkManager:connectTCPSocket");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_connectTCPSocket'", nullptr);
            return 0;
        }
        bool ret = cobj->connectTCPSocket(arg0, arg1, arg2, arg3);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:connectTCPSocket",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_connectTCPSocket'.",&tolua_err);
#endif

    return 0;
}
int lua_NetworkManager_NetworkManager_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"NetworkManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_create'", nullptr);
            return 0;
        }
        NetworkManager* ret = NetworkManager::create();
        object_to_luaval<NetworkManager>(tolua_S, "NetworkManager",(NetworkManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "NetworkManager:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_create'.",&tolua_err);
#endif
    return 0;
}
int lua_NetworkManager_NetworkManager_constructor(lua_State* tolua_S)
{
    int argc = 0;
    NetworkManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_constructor'", nullptr);
            return 0;
        }
        cobj = new NetworkManager();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"NetworkManager");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:NetworkManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_NetworkManager_NetworkManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (NetworkManager)");
    return 0;
}

int lua_register_NetworkManager_NetworkManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"NetworkManager");
    tolua_cclass(tolua_S,"NetworkManager","NetworkManager","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"NetworkManager");
        tolua_function(tolua_S,"new",lua_NetworkManager_NetworkManager_constructor);
        tolua_function(tolua_S,"disconnect",lua_NetworkManager_NetworkManager_disconnect);
        tolua_function(tolua_S,"sendTCPMsg",lua_NetworkManager_NetworkManager_sendTCPMsg);
        tolua_function(tolua_S,"getTCPConnectionStatus",lua_NetworkManager_NetworkManager_getTCPConnectionStatus);
        tolua_function(tolua_S,"init",lua_NetworkManager_NetworkManager_init);
        tolua_function(tolua_S,"connectTCPSocket",lua_NetworkManager_NetworkManager_connectTCPSocket);
        tolua_function(tolua_S,"create", lua_NetworkManager_NetworkManager_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetworkManager).name();
    g_luaType[typeName] = "NetworkManager";
    g_typeCast["NetworkManager"] = "NetworkManager";
    return 1;
}
TOLUA_API int register_all_NetworkManager(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
    //
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
    tolua_beginmodule(tolua_S,"myLua");

	lua_register_NetworkManager_NetworkManager(tolua_S);

    tolua_endmodule(tolua_S);
	return 1;
}

