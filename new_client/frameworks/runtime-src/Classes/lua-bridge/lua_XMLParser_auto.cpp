#include "lua_XMLParser_auto.hpp"
#include "../utils/XMLParser.h"
//#include "XMLParser.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_XMLParser_XMLParser_init(lua_State* tolua_S)
{
    int argc = 0;
    XMLParser* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"XMLParser",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (XMLParser*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_XMLParser_XMLParser_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "XMLParser:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_XMLParser_XMLParser_init'.",&tolua_err);
#endif

    return 0;
}
int lua_XMLParser_XMLParser_parseXML(lua_State* tolua_S)
{
    int argc = 0;
    XMLParser* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"XMLParser",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (XMLParser*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_XMLParser_XMLParser_parseXML'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "XMLParser:parseXML");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_parseXML'", nullptr);
            return 0;
        }
        cocos2d::ValueMap ret = cobj->parseXML(arg0);
        ccvaluemap_to_luaval(tolua_S, ret);
        return 1;
    }
    if (argc == 2) 
    {
        std::string arg0;
        std::string arg1;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "XMLParser:parseXML");

        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "XMLParser:parseXML");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_parseXML'", nullptr);
            return 0;
        }
        cocos2d::ValueMap ret = cobj->parseXML(arg0, arg1);
        ccvaluemap_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "XMLParser:parseXML",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_XMLParser_XMLParser_parseXML'.",&tolua_err);
#endif

    return 0;
}
int lua_XMLParser_XMLParser_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"XMLParser",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_create'", nullptr);
            return 0;
        }
        XMLParser* ret = XMLParser::create();
        object_to_luaval<XMLParser>(tolua_S, "XMLParser",(XMLParser*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "XMLParser:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_XMLParser_XMLParser_create'.",&tolua_err);
#endif
    return 0;
}
int lua_XMLParser_XMLParser_updateArmatureGLProgram(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"XMLParser",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        cocostudio::Armature* arg0;
        cocos2d::GLProgram* arg1;
        ok &= luaval_to_object<cocostudio::Armature>(tolua_S, 2, "ccs.Armature",&arg0, "XMLParser:updateArmatureGLProgram");
        ok &= luaval_to_object<cocos2d::GLProgram>(tolua_S, 3, "cc.GLProgram",&arg1, "XMLParser:updateArmatureGLProgram");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_updateArmatureGLProgram'", nullptr);
            return 0;
        }
        XMLParser::updateArmatureGLProgram(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "XMLParser:updateArmatureGLProgram",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_XMLParser_XMLParser_updateArmatureGLProgram'.",&tolua_err);
#endif
    return 0;
}
int lua_XMLParser_XMLParser_constructor(lua_State* tolua_S)
{
    int argc = 0;
    XMLParser* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_XMLParser_XMLParser_constructor'", nullptr);
            return 0;
        }
        cobj = new XMLParser();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"XMLParser");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "XMLParser:XMLParser",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_XMLParser_XMLParser_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_XMLParser_XMLParser_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (XMLParser)");
    return 0;
}

int lua_register_XMLParser_XMLParser(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"XMLParser");
    tolua_cclass(tolua_S,"XMLParser","XMLParser","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"XMLParser");
        tolua_function(tolua_S,"new",lua_XMLParser_XMLParser_constructor);
        tolua_function(tolua_S,"init",lua_XMLParser_XMLParser_init);
        tolua_function(tolua_S,"parseXML",lua_XMLParser_XMLParser_parseXML);
        tolua_function(tolua_S,"create", lua_XMLParser_XMLParser_create);
        tolua_function(tolua_S,"updateArmatureGLProgram", lua_XMLParser_XMLParser_updateArmatureGLProgram);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(XMLParser).name();
    g_luaType[typeName] = "XMLParser";
    g_typeCast["XMLParser"] = "XMLParser";
    return 1;
}
TOLUA_API int register_all_XMLParser(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	//
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
	tolua_beginmodule(tolua_S,"myLua");

	lua_register_XMLParser_XMLParser(tolua_S);

    tolua_endmodule(tolua_S);
    
	return 1;
}

