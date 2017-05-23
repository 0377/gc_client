#include "lua_NetworkManager_manual.hpp"
#include "../net/NetworkManager.h"
//#include "NetworkManager.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
int lua_NetworkManager_NetworkManager_sendTCPMSgWithLength(lua_State* tolua_S)
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
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_NetworkManager_NetworkManager_sendTCPMSgWithLength'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        int arg0;
        int arg1;
        unsigned int arg3;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "NetworkManager:sendTCPMSgWithLength");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "NetworkManager:sendTCPMSgWithLength");
		ok &= luaval_to_uint32(tolua_S, 5, &arg3, "NetworkManager:sendTCPMSgWithLength");
      //  std::string arg2_tmp; ok &= luaval_to_std_string(tolua_S, 4, &arg2_tmp, "NetworkManager:sendTCPMSgWithLength"); arg2 = arg2_tmp.c_str();
		size_t length = (size_t)arg3;
		const char* pbData = lua_tolstring(tolua_S, 4, &length);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_NetworkManager_NetworkManager_sendTCPMSgWithLength'", nullptr);
            return 0;
        }
		std::string msgPbBufferStr;
		msgPbBufferStr.assign((char *)pbData, length);
		cobj->sendTCPMsg(arg0, arg1, msgPbBufferStr);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "NetworkManager:sendTCPMSgWithLength",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_NetworkManager_NetworkManager_sendTCPMSgWithLength'.",&tolua_err);
#endif

    return 0;
}
int lua_register_NetworkManager_NetworkManager_manual(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"NetworkManager");
    tolua_cclass(tolua_S,"NetworkManager","NetworkManager","cc.Node",nullptr);

    tolua_beginmodule(tolua_S,"NetworkManager");
        tolua_function(tolua_S,"sendTCPMSgWithLength",lua_NetworkManager_NetworkManager_sendTCPMSgWithLength);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(NetworkManager).name();
    g_luaType[typeName] = "NetworkManager";
    g_typeCast["NetworkManager"] = "NetworkManager";
    return 1;
}
TOLUA_API int register_all_NetworkManager_manual(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
    //
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
    tolua_beginmodule(tolua_S,"myLua");

	lua_register_NetworkManager_NetworkManager_manual(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

