#include "lua-bridge/lua_LuaBridgeUtils_manual.hpp"
#include "utils/HLCustomRichText.h"
#include "utils/LuaBridgeUtils.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_LuaBridgeUtils_LuaBridgeUtils_decompressAsync(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"LuaBridgeUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        std::string arg0;
        int arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:decompressAsync");
		arg1 = toluafix_ref_function(tolua_S, 3, 0);
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_decompressAsync'", nullptr);
            return 0;
        }
        bool ret = LuaBridgeUtils::decompressAsync(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:decompressAsync",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_decompressAsync'.",&tolua_err);
#endif
    return 0;
}

int lua_register_LuaBridgeUtils_LuaBridgeUtils_manual(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaBridgeUtils");
    tolua_cclass(tolua_S,"LuaBridgeUtils","LuaBridgeUtils","",nullptr);

    tolua_beginmodule(tolua_S,"LuaBridgeUtils");
        tolua_function(tolua_S,"decompressAsync", lua_LuaBridgeUtils_LuaBridgeUtils_decompressAsync);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaBridgeUtils).name();
    g_luaType[typeName] = "LuaBridgeUtils";
    g_typeCast["LuaBridgeUtils"] = "LuaBridgeUtils";
    return 1;
}
TOLUA_API int register_all_LuaBridgeUtils_manual(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"myLua",0);
	tolua_beginmodule(tolua_S,"myLua");

	lua_register_LuaBridgeUtils_LuaBridgeUtils_manual(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

