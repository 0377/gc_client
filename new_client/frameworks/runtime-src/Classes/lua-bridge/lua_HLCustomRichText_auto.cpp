#include "lua_HLCustomRichText_auto.hpp"
#include "../utils/HLCustomRichText.h"
//#include "HLCustomRichText.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_HLCustomRichText_HLCustomRichText_insertElement(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_insertElement'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        cocos2d::ui::HLCustomRichElement* arg0;
        int arg1;

        ok &= luaval_to_object<cocos2d::ui::HLCustomRichElement>(tolua_S, 2, "ccui.HLCustomRichElement",&arg0, "ccui.HLCustomRichText:insertElement");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "ccui.HLCustomRichText:insertElement");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_insertElement'", nullptr);
            return 0;
        }
        cobj->insertElement(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:insertElement",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_insertElement'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_enableShadow(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        cocos2d::Color4B arg0;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "ccui.HLCustomRichText:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "ccui.HLCustomRichText:enableShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "ccui.HLCustomRichText:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 3) 
    {
        cocos2d::Color4B arg0;
        cocos2d::Size arg1;
        int arg2;

        ok &=luaval_to_color4b(tolua_S, 2, &arg0, "ccui.HLCustomRichText:enableShadow");

        ok &= luaval_to_size(tolua_S, 3, &arg1, "ccui.HLCustomRichText:enableShadow");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "ccui.HLCustomRichText:enableShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'", nullptr);
            return 0;
        }
        cobj->enableShadow(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:enableShadow",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_enableShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_pushBackElement(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_pushBackElement'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ui::HLCustomRichElement* arg0;

        ok &= luaval_to_object<cocos2d::ui::HLCustomRichElement>(tolua_S, 2, "ccui.HLCustomRichElement",&arg0, "ccui.HLCustomRichText:pushBackElement");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_pushBackElement'", nullptr);
            return 0;
        }
        cobj->pushBackElement(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:pushBackElement",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_pushBackElement'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_getShowTextStr(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_getShowTextStr'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_getShowTextStr'", nullptr);
            return 0;
        }
        std::string ret = cobj->getShowTextStr();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:getShowTextStr",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_getShowTextStr'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_setVerticalSpace(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_setVerticalSpace'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "ccui.HLCustomRichText:setVerticalSpace");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_setVerticalSpace'", nullptr);
            return 0;
        }
        cobj->setVerticalSpace(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:setVerticalSpace",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_setVerticalSpace'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_setTextVerticalAlign(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_setTextVerticalAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ui::HLCustomRichText::TextVerticalAlignment arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ccui.HLCustomRichText:setTextVerticalAlign");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_setTextVerticalAlign'", nullptr);
            return 0;
        }
        cobj->setTextVerticalAlign(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:setTextVerticalAlign",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_setTextVerticalAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_getTextVerticalAlign(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_getTextVerticalAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_getTextVerticalAlign'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getTextVerticalAlign();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:getTextVerticalAlign",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_getTextVerticalAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_setShowTextStr(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_setShowTextStr'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0, "ccui.HLCustomRichText:setShowTextStr");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_setShowTextStr'", nullptr);
            return 0;
        }
        cobj->setShowTextStr(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:setShowTextStr",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_setShowTextStr'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_setTextHorizontalAlign(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_setTextHorizontalAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ui::HLCustomRichText::TextHorizontalAlignment arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ccui.HLCustomRichText:setTextHorizontalAlign");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_setTextHorizontalAlign'", nullptr);
            return 0;
        }
        cobj->setTextHorizontalAlign(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:setTextHorizontalAlign",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_setTextHorizontalAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_formatText(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_formatText'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_formatText'", nullptr);
            return 0;
        }
        cobj->formatText();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:formatText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_formatText'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_labelClicked(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_labelClicked'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::ui::LinkLabel* arg0;

        ok &= luaval_to_object<cocos2d::ui::LinkLabel>(tolua_S, 2, "ccui.LinkLabel",&arg0, "ccui.HLCustomRichText:labelClicked");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_labelClicked'", nullptr);
            return 0;
        }
        cobj->labelClicked(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:labelClicked",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_labelClicked'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_getMaxWidthForAllElement(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_getMaxWidthForAllElement'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_getMaxWidthForAllElement'", nullptr);
            return 0;
        }
        double ret = cobj->getMaxWidthForAllElement();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:getMaxWidthForAllElement",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_getMaxWidthForAllElement'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_removeElement(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif
    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);
#if COCOS2D_DEBUG >= 1
    if (!cobj)
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_removeElement'", nullptr);
        return 0;
    }
#endif
    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 1) {
            cocos2d::ui::HLCustomRichElement* arg0;
            ok &= luaval_to_object<cocos2d::ui::HLCustomRichElement>(tolua_S, 2, "ccui.HLCustomRichElement",&arg0, "ccui.HLCustomRichText:removeElement");

            if (!ok) { break; }
            cobj->removeElement(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 1) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "ccui.HLCustomRichText:removeElement");

            if (!ok) { break; }
            cobj->removeElement(arg0);
            lua_settop(tolua_S, 1);
            return 1;
        }
    }while(0);
    ok  = true;
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n",  "ccui.HLCustomRichText:removeElement",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_removeElement'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_getTextHorizontalAlign(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (cocos2d::ui::HLCustomRichText*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_HLCustomRichText_HLCustomRichText_getTextHorizontalAlign'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_getTextHorizontalAlign'", nullptr);
            return 0;
        }
        int ret = (int)cobj->getTextHorizontalAlign();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:getTextHorizontalAlign",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_getTextHorizontalAlign'.",&tolua_err);
#endif

    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"ccui.HLCustomRichText",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_create'", nullptr);
            return 0;
        }
        cocos2d::ui::HLCustomRichText* ret = cocos2d::ui::HLCustomRichText::create();
        object_to_luaval<cocos2d::ui::HLCustomRichText>(tolua_S, "ccui.HLCustomRichText",(cocos2d::ui::HLCustomRichText*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "ccui.HLCustomRichText:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_create'.",&tolua_err);
#endif
    return 0;
}
int lua_HLCustomRichText_HLCustomRichText_constructor(lua_State* tolua_S)
{
    int argc = 0;
    cocos2d::ui::HLCustomRichText* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_HLCustomRichText_HLCustomRichText_constructor'", nullptr);
            return 0;
        }
        cobj = new cocos2d::ui::HLCustomRichText();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"ccui.HLCustomRichText");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "ccui.HLCustomRichText:HLCustomRichText",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_HLCustomRichText_HLCustomRichText_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_HLCustomRichText_HLCustomRichText_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (HLCustomRichText)");
    return 0;
}

int lua_register_HLCustomRichText_HLCustomRichText(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"ccui.HLCustomRichText");
    tolua_cclass(tolua_S,"HLCustomRichText","ccui.HLCustomRichText","ccui.ScrollView",nullptr);

    tolua_beginmodule(tolua_S,"HLCustomRichText");
        tolua_function(tolua_S,"new",lua_HLCustomRichText_HLCustomRichText_constructor);
        tolua_function(tolua_S,"insertElement",lua_HLCustomRichText_HLCustomRichText_insertElement);
        tolua_function(tolua_S,"enableShadow",lua_HLCustomRichText_HLCustomRichText_enableShadow);
        tolua_function(tolua_S,"pushBackElement",lua_HLCustomRichText_HLCustomRichText_pushBackElement);
        tolua_function(tolua_S,"getShowTextStr",lua_HLCustomRichText_HLCustomRichText_getShowTextStr);
        tolua_function(tolua_S,"setVerticalSpace",lua_HLCustomRichText_HLCustomRichText_setVerticalSpace);
        tolua_function(tolua_S,"setTextVerticalAlign",lua_HLCustomRichText_HLCustomRichText_setTextVerticalAlign);
        tolua_function(tolua_S,"getTextVerticalAlign",lua_HLCustomRichText_HLCustomRichText_getTextVerticalAlign);
        tolua_function(tolua_S,"setShowTextStr",lua_HLCustomRichText_HLCustomRichText_setShowTextStr);
        tolua_function(tolua_S,"setTextHorizontalAlign",lua_HLCustomRichText_HLCustomRichText_setTextHorizontalAlign);
        tolua_function(tolua_S,"formatText",lua_HLCustomRichText_HLCustomRichText_formatText);
        tolua_function(tolua_S,"labelClicked",lua_HLCustomRichText_HLCustomRichText_labelClicked);
        tolua_function(tolua_S,"getMaxWidthForAllElement",lua_HLCustomRichText_HLCustomRichText_getMaxWidthForAllElement);
        tolua_function(tolua_S,"removeElement",lua_HLCustomRichText_HLCustomRichText_removeElement);
        tolua_function(tolua_S,"getTextHorizontalAlign",lua_HLCustomRichText_HLCustomRichText_getTextHorizontalAlign);
        tolua_function(tolua_S,"create", lua_HLCustomRichText_HLCustomRichText_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(cocos2d::ui::HLCustomRichText).name();
    g_luaType[typeName] = "ccui.HLCustomRichText";
    g_typeCast["HLCustomRichText"] = "ccui.HLCustomRichText";
    return 1;
}
TOLUA_API int register_all_HLCustomRichText(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	//
	//tolua_module(tolua_S,"myLua",0);
	//tolua_beginmodule(tolua_S,"myLua");
	//
    tolua_module(tolua_S,"myLua",0);
	tolua_beginmodule(tolua_S,"myLua");

	lua_register_HLCustomRichText_HLCustomRichText(tolua_S);

    tolua_endmodule(tolua_S);
    
	return 1;
}

