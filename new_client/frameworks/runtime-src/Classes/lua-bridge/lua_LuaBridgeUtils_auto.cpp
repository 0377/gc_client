#include "lua_LuaBridgeUtils_auto.hpp"
#include "../utils/HLCustomRichText.h"
//#include "HLCustomRichText.h"
#include "../utils/LuaBridgeUtils.h"
//#include "LuaBridgeUtils.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_LuaBridgeUtils_LuaBridgeUtils_getBytesDataFromFile(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:getBytesDataFromFile");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getBytesDataFromFile'", nullptr);
            return 0;
        }
        const char* ret = LuaBridgeUtils::getBytesDataFromFile(arg0);
        tolua_pushstring(tolua_S,(const char*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:getBytesDataFromFile",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getBytesDataFromFile'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToGray(lua_State* tolua_S)
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

    if (argc == 1)
    {
        cocos2d::Node* arg0;
        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaBridgeUtils:changeNodeToGray");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToGray'", nullptr);
            return 0;
        }
        LuaBridgeUtils::changeNodeToGray(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:changeNodeToGray",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToGray'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_getFilePathDirectory(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:getFilePathDirectory");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getFilePathDirectory'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::getFilePathDirectory(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:getFilePathDirectory",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getFilePathDirectory'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_getCharacterCountInUTF8String(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:getCharacterCountInUTF8String");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getCharacterCountInUTF8String'", nullptr);
            return 0;
        }
        long long ret = LuaBridgeUtils::getCharacterCountInUTF8String(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:getCharacterCountInUTF8String",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getCharacterCountInUTF8String'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToNormal(lua_State* tolua_S)
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

    if (argc == 1)
    {
        cocos2d::Node* arg0;
        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "LuaBridgeUtils:changeNodeToNormal");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToNormal'", nullptr);
            return 0;
        }
        LuaBridgeUtils::changeNodeToNormal(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:changeNodeToNormal",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToNormal'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_md5String(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:md5String");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_md5String'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::md5String(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:md5String",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_md5String'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_decompress(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:decompress");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_decompress'", nullptr);
            return 0;
        }
        bool ret = LuaBridgeUtils::decompress(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:decompress",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_decompress'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_crypto_encrypt_password(lua_State* tolua_S)
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
        std::string arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:crypto_encrypt_password");
        ok &= luaval_to_std_string(tolua_S, 3,&arg1, "LuaBridgeUtils:crypto_encrypt_password");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_crypto_encrypt_password'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::crypto_encrypt_password(arg0, arg1);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:crypto_encrypt_password",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_crypto_encrypt_password'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_md5File(lua_State* tolua_S)
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

    if (argc == 1)
    {
        std::string arg0;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:md5File");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_md5File'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::md5File(arg0);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:md5File",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_md5File'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_getMacString(lua_State* tolua_S)
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

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getMacString'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::getMacString();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:getMacString",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_getMacString'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode(lua_State* tolua_S)
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
        cocos2d::ui::Text* arg1;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_object<cocos2d::ui::Text>(tolua_S, 3, "ccui.Text",&arg1, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode'", nullptr);
            return 0;
        }
        cocos2d::ui::HLCustomRichText* ret = LuaBridgeUtils::createHLCustomRichTextWithNode(arg0, arg1);
        object_to_luaval<cocos2d::ui::HLCustomRichText>(tolua_S, "ccui.HLCustomRichText",(cocos2d::ui::HLCustomRichText*)ret);
        return 1;
    }
    if (argc == 3)
    {
        std::string arg0;
        cocos2d::ui::Text* arg1;
        cocos2d::ui::HLCustomRichText::TextHorizontalAlignment arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_object<cocos2d::ui::Text>(tolua_S, 3, "ccui.Text",&arg1, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode'", nullptr);
            return 0;
        }
        cocos2d::ui::HLCustomRichText* ret = LuaBridgeUtils::createHLCustomRichTextWithNode(arg0, arg1, arg2);
        object_to_luaval<cocos2d::ui::HLCustomRichText>(tolua_S, "ccui.HLCustomRichText",(cocos2d::ui::HLCustomRichText*)ret);
        return 1;
    }
    if (argc == 4)
    {
        std::string arg0;
        cocos2d::ui::Text* arg1;
        cocos2d::ui::HLCustomRichText::TextHorizontalAlignment arg2;
        cocos2d::ui::HLCustomRichText::TextVerticalAlignment arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_object<cocos2d::ui::Text>(tolua_S, 3, "ccui.Text",&arg1, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "LuaBridgeUtils:createHLCustomRichTextWithNode");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode'", nullptr);
            return 0;
        }
        cocos2d::ui::HLCustomRichText* ret = LuaBridgeUtils::createHLCustomRichTextWithNode(arg0, arg1, arg2, arg3);
        object_to_luaval<cocos2d::ui::HLCustomRichText>(tolua_S, "ccui.HLCustomRichText",(cocos2d::ui::HLCustomRichText*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:createHLCustomRichTextWithNode",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_showMessage(lua_State* tolua_S)
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
        const char* arg0;
        const char* arg1;
        std::string arg0_tmp; ok &= luaval_to_std_string(tolua_S, 2, &arg0_tmp, "LuaBridgeUtils:showMessage"); arg0 = arg0_tmp.c_str();
        std::string arg1_tmp; ok &= luaval_to_std_string(tolua_S, 3, &arg1_tmp, "LuaBridgeUtils:showMessage"); arg1 = arg1_tmp.c_str();
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_showMessage'", nullptr);
            return 0;
        }
        LuaBridgeUtils::showMessage(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:showMessage",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_showMessage'.",&tolua_err);
#endif
    return 0;
}
int lua_LuaBridgeUtils_LuaBridgeUtils_replaceUTF8String(lua_State* tolua_S)
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

    if (argc == 3)
    {
        std::string arg0;
        int arg1;
        std::string arg2;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "LuaBridgeUtils:replaceUTF8String");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "LuaBridgeUtils:replaceUTF8String");
        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "LuaBridgeUtils:replaceUTF8String");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_LuaBridgeUtils_LuaBridgeUtils_replaceUTF8String'", nullptr);
            return 0;
        }
        std::string ret = LuaBridgeUtils::replaceUTF8String(arg0, arg1, arg2);
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "LuaBridgeUtils:replaceUTF8String",argc, 3);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_LuaBridgeUtils_LuaBridgeUtils_replaceUTF8String'.",&tolua_err);
#endif
    return 0;
}
static int lua_LuaBridgeUtils_LuaBridgeUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (LuaBridgeUtils)");
    return 0;
}

int lua_register_LuaBridgeUtils_LuaBridgeUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"LuaBridgeUtils");
    tolua_cclass(tolua_S,"LuaBridgeUtils","LuaBridgeUtils","",nullptr);

    tolua_beginmodule(tolua_S,"LuaBridgeUtils");
        tolua_function(tolua_S,"getBytesDataFromFile", lua_LuaBridgeUtils_LuaBridgeUtils_getBytesDataFromFile);
        tolua_function(tolua_S,"changeNodeToGray", lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToGray);
        tolua_function(tolua_S,"getFilePathDirectory", lua_LuaBridgeUtils_LuaBridgeUtils_getFilePathDirectory);
        tolua_function(tolua_S,"getCharacterCountInUTF8String", lua_LuaBridgeUtils_LuaBridgeUtils_getCharacterCountInUTF8String);
        tolua_function(tolua_S,"changeNodeToNormal", lua_LuaBridgeUtils_LuaBridgeUtils_changeNodeToNormal);
        tolua_function(tolua_S,"md5String", lua_LuaBridgeUtils_LuaBridgeUtils_md5String);
        tolua_function(tolua_S,"decompress", lua_LuaBridgeUtils_LuaBridgeUtils_decompress);
        tolua_function(tolua_S,"crypto_encrypt_password", lua_LuaBridgeUtils_LuaBridgeUtils_crypto_encrypt_password);
        tolua_function(tolua_S,"md5File", lua_LuaBridgeUtils_LuaBridgeUtils_md5File);
        tolua_function(tolua_S,"getMacString", lua_LuaBridgeUtils_LuaBridgeUtils_getMacString);
        tolua_function(tolua_S,"createHLCustomRichTextWithNode", lua_LuaBridgeUtils_LuaBridgeUtils_createHLCustomRichTextWithNode);
        tolua_function(tolua_S,"showMessage", lua_LuaBridgeUtils_LuaBridgeUtils_showMessage);
        tolua_function(tolua_S,"replaceUTF8String", lua_LuaBridgeUtils_LuaBridgeUtils_replaceUTF8String);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(LuaBridgeUtils).name();
    g_luaType[typeName] = "LuaBridgeUtils";
    g_typeCast["LuaBridgeUtils"] = "LuaBridgeUtils";
    return 1;
}
TOLUA_API int register_all_LuaBridgeUtils(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
    //
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
    tolua_beginmodule(tolua_S,"myLua");

	lua_register_LuaBridgeUtils_LuaBridgeUtils(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

