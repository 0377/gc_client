#include "lua_MyDownloader_manual.hpp"
#include "../net/MyDownloader.h"
//#include "MyDownloader.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
#include "scripting/lua-bindings/manual/CCLuaStack.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
int lua_MyDownloader_MyAsset_setStoragePath(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_setStoragePath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyAsset:setStoragePath");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_setStoragePath'", nullptr);
            return 0;
        }
        cobj->setStoragePath(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:setStoragePath",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_setStoragePath'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_setSrcUrl(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_setSrcUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyAsset:setSrcUrl");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_setSrcUrl'", nullptr);
            return 0;
        }
        cobj->setSrcUrl(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:setSrcUrl",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_setSrcUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_getCustomId(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_getCustomId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_getCustomId'", nullptr);
            return 0;
        }
        std::string ret = cobj->getCustomId();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:getCustomId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_getCustomId'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_getSrcUrl(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_getSrcUrl'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_getSrcUrl'", nullptr);
            return 0;
        }
        std::string ret = cobj->getSrcUrl();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:getSrcUrl",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_getSrcUrl'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_setDownloadeTimes(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_setDownloadeTimes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "MyAsset:setDownloadeTimes");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_setDownloadeTimes'", nullptr);
            return 0;
        }
        cobj->setDownloadeTimes(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:setDownloadeTimes",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_setDownloadeTimes'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_getStoragePath(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_getStoragePath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_getStoragePath'", nullptr);
            return 0;
        }
        std::string ret = cobj->getStoragePath();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:getStoragePath",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_getStoragePath'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_getDownloadeTimes(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_getDownloadeTimes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_getDownloadeTimes'", nullptr);
            return 0;
        }
        int ret = cobj->getDownloadeTimes();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:getDownloadeTimes",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_getDownloadeTimes'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_init(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_init'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_setGroup(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_setGroup'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyAsset:setGroup");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_setGroup'", nullptr);
            return 0;
        }
        cobj->setGroup(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:setGroup",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_setGroup'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_setCustomId(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_setCustomId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "MyAsset:setCustomId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_setCustomId'", nullptr);
            return 0;
        }
        cobj->setCustomId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:setCustomId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_setCustomId'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_getGroup(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyAsset*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyAsset_getGroup'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_getGroup'", nullptr);
            return 0;
        }
        std::string ret = cobj->getGroup();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:getGroup",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_getGroup'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyAsset_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyAsset",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_create'", nullptr);
            return 0;
        }
        MyAsset* ret = MyAsset::create();
        object_to_luaval<MyAsset>(tolua_S, "MyAsset",(MyAsset*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyAsset:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_create'.",&tolua_err);
#endif
    return 0;
}
int lua_MyDownloader_MyAsset_constructor(lua_State* tolua_S)
{
    int argc = 0;
    MyAsset* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyAsset_constructor'", nullptr);
            return 0;
        }
        cobj = new MyAsset();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"MyAsset");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyAsset:MyAsset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyAsset_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_MyDownloader_MyAsset_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MyAsset)");
    return 0;
}

int lua_register_MyDownloader_MyAsset(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MyAsset");
    tolua_cclass(tolua_S,"MyAsset","MyAsset","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MyAsset");
        tolua_function(tolua_S,"new",lua_MyDownloader_MyAsset_constructor);
        tolua_function(tolua_S,"setStoragePath",lua_MyDownloader_MyAsset_setStoragePath);
        tolua_function(tolua_S,"setSrcUrl",lua_MyDownloader_MyAsset_setSrcUrl);
        tolua_function(tolua_S,"getCustomId",lua_MyDownloader_MyAsset_getCustomId);
        tolua_function(tolua_S,"getSrcUrl",lua_MyDownloader_MyAsset_getSrcUrl);
        tolua_function(tolua_S,"setDownloadeTimes",lua_MyDownloader_MyAsset_setDownloadeTimes);
        tolua_function(tolua_S,"getStoragePath",lua_MyDownloader_MyAsset_getStoragePath);
        tolua_function(tolua_S,"getDownloadeTimes",lua_MyDownloader_MyAsset_getDownloadeTimes);
        tolua_function(tolua_S,"init",lua_MyDownloader_MyAsset_init);
        tolua_function(tolua_S,"setGroup",lua_MyDownloader_MyAsset_setGroup);
        tolua_function(tolua_S,"setCustomId",lua_MyDownloader_MyAsset_setCustomId);
        tolua_function(tolua_S,"getGroup",lua_MyDownloader_MyAsset_getGroup);
        tolua_function(tolua_S,"create", lua_MyDownloader_MyAsset_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MyAsset).name();
    g_luaType[typeName] = "MyAsset";
    g_typeCast["MyAsset"] = "MyAsset";
    return 1;
}

int lua_MyDownloader_MyDownloader_reset(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_reset'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyDownloader_reset'", nullptr);
            return 0;
        }
        cobj->reset();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:reset",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_reset'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_startDownload(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_startDownload'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        MyAsset* arg0;

        ok &= luaval_to_object<MyAsset>(tolua_S, 2, "MyAsset",&arg0, "MyDownloader:startDownload");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyDownloader_startDownload'", nullptr);
            return 0;
        }
        cobj->startDownload(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:startDownload",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_startDownload'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_addFinishedCallback(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_addFinishedCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
		LUA_FUNCTION handler = (toluafix_ref_function(tolua_S, 2, 0));
		cobj->addFinishedCallback([=](MyAsset *asset){
			LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
			/*			stack->pushObject(sender, "cc.Ref");*/
			stack->pushObject(asset, "myLua.MyAsset");
			stack->executeFunctionByHandler(handler, 1);
			stack->clean();
		});
		ScriptHandlerMgr::getInstance()->addCustomHandler((void*)cobj, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:addFinishedCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_addFinishedCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_addErrorCallback(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_addErrorCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
		//手动添加的代码
		LUA_FUNCTION handler = (toluafix_ref_function(tolua_S, 2, 0));
		cobj->addErrorCallback([=](MyAsset *asset, const std::string &errorStr){
			LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
			/*			stack->pushObject(sender, "cc.Ref");*/
			stack->pushObject(asset, "myLua.MyAsset");
			stack->pushString(errorStr.c_str());
			stack->executeFunctionByHandler(handler, 2);
			stack->clean();
		});
		ScriptHandlerMgr::getInstance()->addCustomHandler((void*)cobj, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:addErrorCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_addErrorCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_init(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyDownloader_init'", nullptr);
            return 0;
        }
        bool ret = cobj->init();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_init'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_addProgressCallback(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (MyDownloader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_MyDownloader_MyDownloader_addProgressCallback'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
		//手动添加的代码
		LUA_FUNCTION handler = (toluafix_ref_function(tolua_S, 2, 0));
		cobj->addProgressCallback([=](MyAsset *asset, float total, float downloaded){
			LuaStack* stack = LuaEngine::getInstance()->getLuaStack();
			/*			stack->pushObject(sender, "cc.Ref");*/
			stack->pushObject(asset, "myLua.MyAsset");
			stack->pushFloat(total);
			stack->pushFloat(downloaded);
			stack->executeFunctionByHandler(handler, 3);
			stack->clean();
		});
		ScriptHandlerMgr::getInstance()->addCustomHandler((void*)cobj, handler);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:addProgressCallback",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_addProgressCallback'.",&tolua_err);
#endif

    return 0;
}
int lua_MyDownloader_MyDownloader_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"MyDownloader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyDownloader_create'", nullptr);
            return 0;
        }
        MyDownloader* ret = MyDownloader::create();
        object_to_luaval<MyDownloader>(tolua_S, "MyDownloader",(MyDownloader*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "MyDownloader:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_create'.",&tolua_err);
#endif
    return 0;
}
int lua_MyDownloader_MyDownloader_constructor(lua_State* tolua_S)
{
    int argc = 0;
    MyDownloader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_MyDownloader_MyDownloader_constructor'", nullptr);
            return 0;
        }
        cobj = new MyDownloader();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"MyDownloader");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "MyDownloader:MyDownloader",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_MyDownloader_MyDownloader_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_MyDownloader_MyDownloader_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MyDownloader)");
    return 0;
}

int lua_register_MyDownloader_MyDownloader(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"MyDownloader");
    tolua_cclass(tolua_S,"MyDownloader","MyDownloader","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MyDownloader");
        tolua_function(tolua_S,"new",lua_MyDownloader_MyDownloader_constructor);
        tolua_function(tolua_S,"reset",lua_MyDownloader_MyDownloader_reset);
        tolua_function(tolua_S,"startDownload",lua_MyDownloader_MyDownloader_startDownload);
        tolua_function(tolua_S,"addFinishedCallback",lua_MyDownloader_MyDownloader_addFinishedCallback);
        tolua_function(tolua_S,"addErrorCallback",lua_MyDownloader_MyDownloader_addErrorCallback);
        tolua_function(tolua_S,"init",lua_MyDownloader_MyDownloader_init);
        tolua_function(tolua_S,"addProgressCallback",lua_MyDownloader_MyDownloader_addProgressCallback);
        tolua_function(tolua_S,"create", lua_MyDownloader_MyDownloader_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(MyDownloader).name();
    g_luaType[typeName] = "MyDownloader";
    g_typeCast["MyDownloader"] = "MyDownloader";
    return 1;
}
TOLUA_API int register_all_MyDownloader(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	//
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
	tolua_beginmodule(tolua_S,"myLua");

	lua_register_MyDownloader_MyDownloader(tolua_S);
	lua_register_MyDownloader_MyAsset(tolua_S);

    tolua_endmodule(tolua_S);
    
	return 1;
}

