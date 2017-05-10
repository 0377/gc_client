#include "my-cocos-ext.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"



int lua_ccext_FuncAction_create(lua_State* tolua_S)
{
	int argc = 0;
	bool ok = true;

#if COCOS2D_DEBUG >= 1
	tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
	if (!tolua_isusertable(tolua_S, 1, "ccext.FuncAction", 0, &tolua_err)) goto tolua_lerror;
#endif

	argc = lua_gettop(tolua_S) - 1;

	if (argc == 2)
	{
		double arg0;
		int arg1;
		ok &= luaval_to_number(tolua_S, 2, &arg0, "ccext.FuncAction:create");
		// ok &= luaval_to_int32(tolua_S, 3, (int *)&arg1, "ccext.FuncAction:create");
		int handler = toluafix_ref_function(tolua_S, 3, 0);
		if (!ok)
		{
			tolua_error(tolua_S, "invalid arguments in function 'lua_ccext_FuncAction_create'", nullptr);
			return 0;
		}
		ccext::FuncAction* ret = ccext::FuncAction::create(arg0, handler);
		object_to_luaval<ccext::FuncAction>(tolua_S, "ccext.FuncAction", (ccext::FuncAction*)ret);
		return 1;
	}
	luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ccext.FuncAction:create", argc, 2);
	return 0;
#if COCOS2D_DEBUG >= 1
tolua_lerror:
	tolua_error(tolua_S, "#ferror in function 'lua_ccext_FuncAction_create'.", &tolua_err);
#endif
	return 0;
}

int lua_register_MyDownloader_FuncAction(lua_State* tolua_S)
{
	tolua_usertype(tolua_S, "ccext.FuncAction");
	tolua_cclass(tolua_S, "FuncAction", "ccext.FuncAction", "cc.ActionInterval", nullptr);

	tolua_beginmodule(tolua_S, "FuncAction");
	tolua_function(tolua_S, "create", lua_ccext_FuncAction_create);
	tolua_endmodule(tolua_S);
	std::string typeName = typeid(ccext::FuncAction).name();
	g_luaType[typeName] = "ccext.FuncAction";
	g_typeCast["FuncAction"] = "ccext.FuncAction";
	return 1;
}


int register_all_my_cocos_ext_manual(lua_State* tolua_S){
	if (NULL == tolua_S)
		return 0;

	tolua_open(tolua_S);

	tolua_module(tolua_S, "ccext", 0);
	tolua_beginmodule(tolua_S, "ccext");

	lua_register_MyDownloader_FuncAction(tolua_S);

	tolua_endmodule(tolua_S);

	return 1;
}
