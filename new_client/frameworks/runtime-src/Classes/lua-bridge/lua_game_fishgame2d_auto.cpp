#include "lua_game_fishgame2d_auto.hpp"
#include "../game/fishgame2d/fishgame2d.h"
//#include "fishgame2d.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_game_fishgame2d_FishObjectManager_GetPathManager(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_GetPathManager'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_GetPathManager'", nullptr);
            return 0;
        }
        game::fishgame2d::PathManager* ret = cobj->GetPathManager();
        object_to_luaval<game::fishgame2d::PathManager>(tolua_S, "game.fishgame2d.PathManager",(game::fishgame2d::PathManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:GetPathManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_GetPathManager'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_FindFish(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_FindFish'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned long arg0;

        ok &= luaval_to_ulong(tolua_S, 2, &arg0, "game.fishgame2d.FishObjectManager:FindFish");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_FindFish'", nullptr);
            return 0;
        }
        game::fishgame2d::Fish* ret = cobj->FindFish(arg0);
        object_to_luaval<game::fishgame2d::Fish>(tolua_S, "game.fishgame2d.Fish",(game::fishgame2d::Fish*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:FindFish",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_FindFish'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_Init(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_Init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        int arg1;
        std::string arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.FishObjectManager:Init");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "game.fishgame2d.FishObjectManager:Init");

        ok &= luaval_to_std_string(tolua_S, 4,&arg2, "game.fishgame2d.FishObjectManager:Init");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_Init'", nullptr);
            return 0;
        }
        cobj->Init(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:Init",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_Init'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_GetClientHeight(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_GetClientHeight'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_GetClientHeight'", nullptr);
            return 0;
        }
        int ret = cobj->GetClientHeight();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:GetClientHeight",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_GetClientHeight'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_IsSwitchingScene(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_IsSwitchingScene'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_IsSwitchingScene'", nullptr);
            return 0;
        }
        bool ret = cobj->IsSwitchingScene();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:IsSwitchingScene",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_IsSwitchingScene'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_MirrowShow(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_MirrowShow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_MirrowShow'", nullptr);
            return 0;
        }
        bool ret = cobj->MirrowShow();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:MirrowShow",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_MirrowShow'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_FindBullet(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_FindBullet'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned long arg0;

        ok &= luaval_to_ulong(tolua_S, 2, &arg0, "game.fishgame2d.FishObjectManager:FindBullet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_FindBullet'", nullptr);
            return 0;
        }
        game::fishgame2d::Bullet* ret = cobj->FindBullet(arg0);
        object_to_luaval<game::fishgame2d::Bullet>(tolua_S, "game.fishgame2d.Bullet",(game::fishgame2d::Bullet*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:FindBullet",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_FindBullet'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_SetGameLoaded(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_SetGameLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.FishObjectManager:SetGameLoaded");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_SetGameLoaded'", nullptr);
            return 0;
        }
        cobj->SetGameLoaded(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:SetGameLoaded",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_SetGameLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_AddFishBuff(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_AddFishBuff'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        double arg1;
        double arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.FishObjectManager:AddFishBuff");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.FishObjectManager:AddFishBuff");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.FishObjectManager:AddFishBuff");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_AddFishBuff'", nullptr);
            return 0;
        }
        cobj->AddFishBuff(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:AddFishBuff",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_AddFishBuff'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_RemoveAllBullets(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllBullets'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllBullets'", nullptr);
            return 0;
        }
        bool ret = cobj->RemoveAllBullets();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:RemoveAllBullets",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllBullets'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_SetSwitchingScene(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_SetSwitchingScene'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.FishObjectManager:SetSwitchingScene");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_SetSwitchingScene'", nullptr);
            return 0;
        }
        cobj->SetSwitchingScene(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:SetSwitchingScene",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_SetSwitchingScene'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_Clear(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_Clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_Clear'", nullptr);
            return 0;
        }
        cobj->Clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:Clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_Clear'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_IsGameLoaded(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_IsGameLoaded'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_IsGameLoaded'", nullptr);
            return 0;
        }
        bool ret = cobj->IsGameLoaded();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:IsGameLoaded",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_IsGameLoaded'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_RemoveAllFishes(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllFishes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllFishes'", nullptr);
            return 0;
        }
        bool ret = cobj->RemoveAllFishes();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:RemoveAllFishes",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_RemoveAllFishes'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_AddFish(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_AddFish'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::Fish* arg0;

        ok &= luaval_to_object<game::fishgame2d::Fish>(tolua_S, 2, "game.fishgame2d.Fish",&arg0, "game.fishgame2d.FishObjectManager:AddFish");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_AddFish'", nullptr);
            return 0;
        }
        bool ret = cobj->AddFish(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:AddFish",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_AddFish'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_TestHitFish(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_TestHitFish'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.FishObjectManager:TestHitFish");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.FishObjectManager:TestHitFish");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_TestHitFish'", nullptr);
            return 0;
        }
        int ret = cobj->TestHitFish(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:TestHitFish",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_TestHitFish'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_ConvertCoord(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_ConvertCoord'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        float* arg0;
        float* arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;

        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_ConvertCoord'", nullptr);
            return 0;
        }
        cobj->ConvertCoord(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:ConvertCoord",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_ConvertCoord'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_GetAllFishes(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_GetAllFishes'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_GetAllFishes'", nullptr);
            return 0;
        }
        cocos2d::Vector<game::fishgame2d::Fish *> ret = cobj->GetAllFishes();
        ccvector_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:GetAllFishes",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_GetAllFishes'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_AddBullet(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_AddBullet'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::Bullet* arg0;

        ok &= luaval_to_object<game::fishgame2d::Bullet>(tolua_S, 2, "game.fishgame2d.Bullet",&arg0, "game.fishgame2d.FishObjectManager:AddBullet");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_AddBullet'", nullptr);
            return 0;
        }
        bool ret = cobj->AddBullet(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:AddBullet",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_AddBullet'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.FishObjectManager:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_OnUpdate'", nullptr);
            return 0;
        }
        bool ret = cobj->OnUpdate(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:OnUpdate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_GetClientWidth(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_GetClientWidth'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_GetClientWidth'", nullptr);
            return 0;
        }
        int ret = cobj->GetClientWidth();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:GetClientWidth",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_GetClientWidth'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_ConvertDirection(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_ConvertDirection'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        float* arg0;

        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_ConvertDirection'", nullptr);
            return 0;
        }
        cobj->ConvertDirection(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:ConvertDirection",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_ConvertDirection'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_SetMirrowShow(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_SetMirrowShow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.FishObjectManager:SetMirrowShow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_SetMirrowShow'", nullptr);
            return 0;
        }
        cobj->SetMirrowShow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:SetMirrowShow",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_SetMirrowShow'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_ConvertMirrorCoord(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::FishObjectManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::FishObjectManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_FishObjectManager_ConvertMirrorCoord'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        float* arg0;
        float* arg1;

        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;

        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_ConvertMirrorCoord'", nullptr);
            return 0;
        }
        cobj->ConvertMirrorCoord(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.FishObjectManager:ConvertMirrorCoord",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_ConvertMirrorCoord'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_FishObjectManager_DestroyInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_DestroyInstance'", nullptr);
            return 0;
        }
        game::fishgame2d::FishObjectManager::DestroyInstance();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.FishObjectManager:DestroyInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_DestroyInstance'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_FishObjectManager_DestoryInstace(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_DestoryInstace'", nullptr);
            return 0;
        }
        game::fishgame2d::FishObjectManager::DestoryInstace();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.FishObjectManager:DestoryInstace",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_DestoryInstace'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_FishObjectManager_GetInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.FishObjectManager",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishObjectManager_GetInstance'", nullptr);
            return 0;
        }
        game::fishgame2d::FishObjectManager* ret = game::fishgame2d::FishObjectManager::GetInstance();
        object_to_luaval<game::fishgame2d::FishObjectManager>(tolua_S, "game.fishgame2d.FishObjectManager",(game::fishgame2d::FishObjectManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.FishObjectManager:GetInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishObjectManager_GetInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_FishObjectManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (FishObjectManager)");
    return 0;
}

int lua_register_game_fishgame2d_FishObjectManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.FishObjectManager");
    tolua_cclass(tolua_S,"FishObjectManager","game.fishgame2d.FishObjectManager","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"FishObjectManager");
        tolua_function(tolua_S,"GetPathManager",lua_game_fishgame2d_FishObjectManager_GetPathManager);
        tolua_function(tolua_S,"FindFish",lua_game_fishgame2d_FishObjectManager_FindFish);
        tolua_function(tolua_S,"Init",lua_game_fishgame2d_FishObjectManager_Init);
        tolua_function(tolua_S,"GetClientHeight",lua_game_fishgame2d_FishObjectManager_GetClientHeight);
        tolua_function(tolua_S,"IsSwitchingScene",lua_game_fishgame2d_FishObjectManager_IsSwitchingScene);
        tolua_function(tolua_S,"MirrowShow",lua_game_fishgame2d_FishObjectManager_MirrowShow);
        tolua_function(tolua_S,"FindBullet",lua_game_fishgame2d_FishObjectManager_FindBullet);
        tolua_function(tolua_S,"SetGameLoaded",lua_game_fishgame2d_FishObjectManager_SetGameLoaded);
        tolua_function(tolua_S,"AddFishBuff",lua_game_fishgame2d_FishObjectManager_AddFishBuff);
        tolua_function(tolua_S,"RemoveAllBullets",lua_game_fishgame2d_FishObjectManager_RemoveAllBullets);
        tolua_function(tolua_S,"SetSwitchingScene",lua_game_fishgame2d_FishObjectManager_SetSwitchingScene);
        tolua_function(tolua_S,"Clear",lua_game_fishgame2d_FishObjectManager_Clear);
        tolua_function(tolua_S,"IsGameLoaded",lua_game_fishgame2d_FishObjectManager_IsGameLoaded);
        tolua_function(tolua_S,"RemoveAllFishes",lua_game_fishgame2d_FishObjectManager_RemoveAllFishes);
        tolua_function(tolua_S,"AddFish",lua_game_fishgame2d_FishObjectManager_AddFish);
        tolua_function(tolua_S,"TestHitFish",lua_game_fishgame2d_FishObjectManager_TestHitFish);
        tolua_function(tolua_S,"ConvertCoord",lua_game_fishgame2d_FishObjectManager_ConvertCoord);
        tolua_function(tolua_S,"GetAllFishes",lua_game_fishgame2d_FishObjectManager_GetAllFishes);
        tolua_function(tolua_S,"AddBullet",lua_game_fishgame2d_FishObjectManager_AddBullet);
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_FishObjectManager_OnUpdate);
        tolua_function(tolua_S,"GetClientWidth",lua_game_fishgame2d_FishObjectManager_GetClientWidth);
        tolua_function(tolua_S,"ConvertDirection",lua_game_fishgame2d_FishObjectManager_ConvertDirection);
        tolua_function(tolua_S,"SetMirrowShow",lua_game_fishgame2d_FishObjectManager_SetMirrowShow);
        tolua_function(tolua_S,"ConvertMirrorCoord",lua_game_fishgame2d_FishObjectManager_ConvertMirrorCoord);
        tolua_function(tolua_S,"DestroyInstance", lua_game_fishgame2d_FishObjectManager_DestroyInstance);
        tolua_function(tolua_S,"DestoryInstace", lua_game_fishgame2d_FishObjectManager_DestoryInstace);
        tolua_function(tolua_S,"GetInstance", lua_game_fishgame2d_FishObjectManager_GetInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::FishObjectManager).name();
    g_luaType[typeName] = "game.fishgame2d.FishObjectManager";
    g_typeCast["FishObjectManager"] = "game.fishgame2d.FishObjectManager";
    return 1;
}

int lua_game_fishgame2d_FishUtils_CalcAngle(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.FishUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.FishUtils:CalcAngle");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.FishUtils:CalcAngle");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.FishUtils:CalcAngle");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "game.fishgame2d.FishUtils:CalcAngle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishUtils_CalcAngle'", nullptr);
            return 0;
        }
        double ret = game::fishgame2d::FishUtils::CalcAngle(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.FishUtils:CalcAngle",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishUtils_CalcAngle'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_FishUtils_CalCircle(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.FishUtils",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 10)
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        double arg4;
        double arg5;
        double arg6;
        float* arg7;
        float* arg8;
        float* arg9;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 6,&arg4, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 7,&arg5, "game.fishgame2d.FishUtils:CalCircle");
        ok &= luaval_to_number(tolua_S, 8,&arg6, "game.fishgame2d.FishUtils:CalCircle");
        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        #pragma warning NO CONVERSION TO NATIVE FOR float*
		ok = false;
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_FishUtils_CalCircle'", nullptr);
            return 0;
        }
        game::fishgame2d::FishUtils::CalCircle(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.FishUtils:CalCircle",argc, 10);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_FishUtils_CalCircle'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_FishUtils_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (FishUtils)");
    return 0;
}

int lua_register_game_fishgame2d_FishUtils(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.FishUtils");
    tolua_cclass(tolua_S,"FishUtils","game.fishgame2d.FishUtils","",nullptr);

    tolua_beginmodule(tolua_S,"FishUtils");
        tolua_function(tolua_S,"CalcAngle", lua_game_fishgame2d_FishUtils_CalcAngle);
        tolua_function(tolua_S,"CalCircle", lua_game_fishgame2d_FishUtils_CalCircle);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::FishUtils).name();
    g_luaType[typeName] = "game.fishgame2d.FishUtils";
    g_typeCast["FishUtils"] = "game.fishgame2d.FishUtils";
    return 1;
}

int lua_game_fishgame2d_MathAide_Combination(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MathAide",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 2)
    {
        int arg0;
        int arg1;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MathAide:Combination");
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "game.fishgame2d.MathAide:Combination");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MathAide_Combination'", nullptr);
            return 0;
        }
        int ret = game::fishgame2d::MathAide::Combination(arg0, arg1);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MathAide:Combination",argc, 2);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MathAide_Combination'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_MathAide_Factorial(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MathAide",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MathAide:Factorial");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MathAide_Factorial'", nullptr);
            return 0;
        }
        int ret = game::fishgame2d::MathAide::Factorial(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MathAide:Factorial",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MathAide_Factorial'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_MathAide_CalcAngle(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MathAide",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MathAide:CalcAngle");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MathAide:CalcAngle");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.MathAide:CalcAngle");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "game.fishgame2d.MathAide:CalcAngle");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MathAide_CalcAngle'", nullptr);
            return 0;
        }
        double ret = game::fishgame2d::MathAide::CalcAngle(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MathAide:CalcAngle",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MathAide_CalcAngle'.",&tolua_err);
#endif
    return 0;
}
int lua_game_fishgame2d_MathAide_CalcDistance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MathAide",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        double arg0;
        double arg1;
        double arg2;
        double arg3;
        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MathAide:CalcDistance");
        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MathAide:CalcDistance");
        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.MathAide:CalcDistance");
        ok &= luaval_to_number(tolua_S, 5,&arg3, "game.fishgame2d.MathAide:CalcDistance");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MathAide_CalcDistance'", nullptr);
            return 0;
        }
        double ret = game::fishgame2d::MathAide::CalcDistance(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MathAide:CalcDistance",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MathAide_CalcDistance'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_MathAide_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MathAide)");
    return 0;
}

int lua_register_game_fishgame2d_MathAide(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.MathAide");
    tolua_cclass(tolua_S,"MathAide","game.fishgame2d.MathAide","",nullptr);

    tolua_beginmodule(tolua_S,"MathAide");
        tolua_function(tolua_S,"Combination", lua_game_fishgame2d_MathAide_Combination);
        tolua_function(tolua_S,"Factorial", lua_game_fishgame2d_MathAide_Factorial);
        tolua_function(tolua_S,"CalcAngle", lua_game_fishgame2d_MathAide_CalcAngle);
        tolua_function(tolua_S,"CalcDistance", lua_game_fishgame2d_MathAide_CalcDistance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::MathAide).name();
    g_luaType[typeName] = "game.fishgame2d.MathAide";
    g_typeCast["MathAide"] = "game.fishgame2d.MathAide";
    return 1;
}

int lua_game_fishgame2d_PathManager_Clear(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::PathManager* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.PathManager",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::PathManager*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_PathManager_Clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_PathManager_Clear'", nullptr);
            return 0;
        }
        cobj->Clear();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.PathManager:Clear",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_PathManager_Clear'.",&tolua_err);
#endif

    return 0;
}
static int lua_game_fishgame2d_PathManager_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (PathManager)");
    return 0;
}

int lua_register_game_fishgame2d_PathManager(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.PathManager");
    tolua_cclass(tolua_S,"PathManager","game.fishgame2d.PathManager","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"PathManager");
        tolua_function(tolua_S,"Clear",lua_game_fishgame2d_PathManager_Clear);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::PathManager).name();
    g_luaType[typeName] = "game.fishgame2d.PathManager";
    g_typeCast["PathManager"] = "game.fishgame2d.PathManager";
    return 1;
}

int lua_game_fishgame2d_MyObject_getVisualShadow(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getVisualShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getVisualShadow'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getVisualShadow();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getVisualShadow",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getVisualShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getId'", nullptr);
            return 0;
        }
        unsigned long ret = cobj->getId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_addEffect(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_addEffect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::Effect* arg0;

        ok &= luaval_to_object<game::fishgame2d::Effect>(tolua_S, 2, "game.fishgame2d.Effect",&arg0, "game.fishgame2d.MyObject:addEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_addEffect'", nullptr);
            return 0;
        }
        cobj->addEffect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:addEffect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_addEffect'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_removeAllChildren(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_removeAllChildren'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_removeAllChildren'", nullptr);
            return 0;
        }
        cobj->removeAllChildren();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:removeAllChildren",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_removeAllChildren'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setGamePos(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setGamePos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:setGamePos");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MyObject:setGamePos");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setGamePos'", nullptr);
            return 0;
        }
        cobj->setGamePos(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setGamePos",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setGamePos'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setVisualContent(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setVisualContent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "game.fishgame2d.MyObject:setVisualContent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setVisualContent'", nullptr);
            return 0;
        }
        cobj->setVisualContent(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setVisualContent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setVisualContent'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setTypeId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setTypeId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MyObject:setTypeId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setTypeId'", nullptr);
            return 0;
        }
        cobj->setTypeId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setTypeId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setTypeId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_OnMoveEnd(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_OnMoveEnd'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_OnMoveEnd'", nullptr);
            return 0;
        }
        cobj->OnMoveEnd();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:OnMoveEnd",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_OnMoveEnd'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setVisualShadow(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setVisualShadow'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "game.fishgame2d.MyObject:setVisualShadow");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setVisualShadow'", nullptr);
            return 0;
        }
        cobj->setVisualShadow(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setVisualShadow",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setVisualShadow'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_OnClear(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_OnClear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:OnClear");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_OnClear'", nullptr);
            return 0;
        }
        cobj->OnClear(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:OnClear",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_OnClear'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setState(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MyObject:setState");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setState'", nullptr);
            return 0;
        }
        cobj->setState(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setState",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setState'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setVisualDebug(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setVisualDebug'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Node* arg0;

        ok &= luaval_to_object<cocos2d::Node>(tolua_S, 2, "cc.Node",&arg0, "game.fishgame2d.MyObject:setVisualDebug");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setVisualDebug'", nullptr);
            return 0;
        }
        cobj->setVisualDebug(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setVisualDebug",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setVisualDebug'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setGameDir(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setGameDir'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:setGameDir");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setGameDir'", nullptr);
            return 0;
        }
        cobj->setGameDir(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setGameDir",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setGameDir'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getTypeId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getTypeId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getTypeId'", nullptr);
            return 0;
        }
        int ret = cobj->getTypeId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getTypeId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getTypeId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setMoveCompent(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setMoveCompent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::MoveCompent* arg0;

        ok &= luaval_to_object<game::fishgame2d::MoveCompent>(tolua_S, 2, "game.fishgame2d.MoveCompent",&arg0, "game.fishgame2d.MyObject:setMoveCompent");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setMoveCompent'", nullptr);
            return 0;
        }
        cobj->setMoveCompent(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setMoveCompent",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setMoveCompent'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_GetTarget(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_GetTarget'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_GetTarget'", nullptr);
            return 0;
        }
        int ret = cobj->GetTarget();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:GetTarget",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_GetTarget'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getGamePos(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getGamePos'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getGamePos'", nullptr);
            return 0;
        }
        const cocos2d::Vec2& ret = cobj->getGamePos();
        vec2_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getGamePos",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getGamePos'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getMoveCompent(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getMoveCompent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getMoveCompent'", nullptr);
            return 0;
        }
        game::fishgame2d::MoveCompent* ret = cobj->getMoveCompent();
        object_to_luaval<game::fishgame2d::MoveCompent>(tolua_S, "game.fishgame2d.MoveCompent",(game::fishgame2d::MoveCompent*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getMoveCompent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getMoveCompent'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setRotation(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setRotation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:setRotation");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setRotation'", nullptr);
            return 0;
        }
        cobj->setRotation(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setRotation",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setRotation'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getManager(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getManager'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getManager'", nullptr);
            return 0;
        }
        game::fishgame2d::FishObjectManager* ret = cobj->getManager();
        object_to_luaval<game::fishgame2d::FishObjectManager>(tolua_S, "game.fishgame2d.FishObjectManager",(game::fishgame2d::FishObjectManager*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getManager",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getManager'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getObjectType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getObjectType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getObjectType'", nullptr);
            return 0;
        }
        int ret = cobj->getObjectType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getObjectType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getObjectType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_addBuff(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_addBuff'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        int arg0;
        double arg1;
        double arg2;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MyObject:addBuff");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MyObject:addBuff");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.MyObject:addBuff");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_addBuff'", nullptr);
            return 0;
        }
        cobj->addBuff(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:addBuff",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_addBuff'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getState(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getState'", nullptr);
            return 0;
        }
        int ret = cobj->getState();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getState",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getState'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_executeEffects(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_executeEffects'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        game::fishgame2d::MyObject* arg0;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg1;
        bool arg2;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.MyObject:executeEffects");

        ok &= luaval_to_ccvector(tolua_S, 3, &arg1, "game.fishgame2d.MyObject:executeEffects");

        ok &= luaval_to_boolean(tolua_S, 4,&arg2, "game.fishgame2d.MyObject:executeEffects");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_executeEffects'", nullptr);
            return 0;
        }
        cocos2d::Vector<game::fishgame2d::MyObject *> ret = cobj->executeEffects(arg0, arg1, arg2);
        ccvector_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:executeEffects",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_executeEffects'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_Clear(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_Clear'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:Clear");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_Clear'", nullptr);
            return 0;
        }
        cobj->Clear(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:Clear",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_Clear'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_onUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_onUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        bool arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:onUpdate");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "game.fishgame2d.MyObject:onUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_onUpdate'", nullptr);
            return 0;
        }
        bool ret = cobj->onUpdate(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:onUpdate",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_onUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getGameDir(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getGameDir'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getGameDir'", nullptr);
            return 0;
        }
        double ret = cobj->getGameDir();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getGameDir",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getGameDir'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setPosition(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setPosition'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MyObject:setPosition");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MyObject:setPosition");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setPosition'", nullptr);
            return 0;
        }
        cobj->setPosition(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setPosition",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setPosition'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getPosition(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getPosition'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getPosition'", nullptr);
            return 0;
        }
        cocos2d::Vec2 ret = cobj->getPosition();
        vec2_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getPosition",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getPosition'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_registerStatusChangedHandler(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_registerStatusChangedHandler'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MyObject:registerStatusChangedHandler");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_registerStatusChangedHandler'", nullptr);
            return 0;
        }
        cobj->registerStatusChangedHandler(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:registerStatusChangedHandler",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_registerStatusChangedHandler'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getVisualDebug(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getVisualDebug'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getVisualDebug'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getVisualDebug();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getVisualDebug",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getVisualDebug'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getRotation(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getRotation'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getRotation'", nullptr);
            return 0;
        }
        double ret = cobj->getRotation();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getRotation",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getRotation'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_SetTarget(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_SetTarget'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MyObject:SetTarget");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_SetTarget'", nullptr);
            return 0;
        }
        cobj->SetTarget(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:SetTarget",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_SetTarget'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_getVisualContent(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_getVisualContent'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_getVisualContent'", nullptr);
            return 0;
        }
        cocos2d::Node* ret = cobj->getVisualContent();
        object_to_luaval<cocos2d::Node>(tolua_S, "cc.Node",(cocos2d::Node*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:getVisualContent",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_getVisualContent'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        unsigned long arg0;

        ok &= luaval_to_ulong(tolua_S, 2, &arg0, "game.fishgame2d.MyObject:setId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setId'", nullptr);
            return 0;
        }
        cobj->setId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_InSideScreen(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_InSideScreen'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_InSideScreen'", nullptr);
            return 0;
        }
        bool ret = cobj->InSideScreen();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:InSideScreen",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_InSideScreen'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MyObject_setManager(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MyObject* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MyObject",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MyObject*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MyObject_setManager'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::FishObjectManager* arg0;

        ok &= luaval_to_object<game::fishgame2d::FishObjectManager>(tolua_S, 2, "game.fishgame2d.FishObjectManager",&arg0, "game.fishgame2d.MyObject:setManager");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MyObject_setManager'", nullptr);
            return 0;
        }
        cobj->setManager(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MyObject:setManager",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MyObject_setManager'.",&tolua_err);
#endif

    return 0;
}
static int lua_game_fishgame2d_MyObject_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MyObject)");
    return 0;
}

int lua_register_game_fishgame2d_MyObject(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.MyObject");
    tolua_cclass(tolua_S,"MyObject","game.fishgame2d.MyObject","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MyObject");
        tolua_function(tolua_S,"getVisualShadow",lua_game_fishgame2d_MyObject_getVisualShadow);
        tolua_function(tolua_S,"getId",lua_game_fishgame2d_MyObject_getId);
        tolua_function(tolua_S,"addEffect",lua_game_fishgame2d_MyObject_addEffect);
        tolua_function(tolua_S,"removeAllChildren",lua_game_fishgame2d_MyObject_removeAllChildren);
        tolua_function(tolua_S,"setGamePos",lua_game_fishgame2d_MyObject_setGamePos);
        tolua_function(tolua_S,"setVisualContent",lua_game_fishgame2d_MyObject_setVisualContent);
        tolua_function(tolua_S,"setTypeId",lua_game_fishgame2d_MyObject_setTypeId);
        tolua_function(tolua_S,"OnMoveEnd",lua_game_fishgame2d_MyObject_OnMoveEnd);
        tolua_function(tolua_S,"setVisualShadow",lua_game_fishgame2d_MyObject_setVisualShadow);
        tolua_function(tolua_S,"OnClear",lua_game_fishgame2d_MyObject_OnClear);
        tolua_function(tolua_S,"setState",lua_game_fishgame2d_MyObject_setState);
        tolua_function(tolua_S,"setVisualDebug",lua_game_fishgame2d_MyObject_setVisualDebug);
        tolua_function(tolua_S,"setGameDir",lua_game_fishgame2d_MyObject_setGameDir);
        tolua_function(tolua_S,"getTypeId",lua_game_fishgame2d_MyObject_getTypeId);
        tolua_function(tolua_S,"setMoveCompent",lua_game_fishgame2d_MyObject_setMoveCompent);
        tolua_function(tolua_S,"GetTarget",lua_game_fishgame2d_MyObject_GetTarget);
        tolua_function(tolua_S,"getGamePos",lua_game_fishgame2d_MyObject_getGamePos);
        tolua_function(tolua_S,"getMoveCompent",lua_game_fishgame2d_MyObject_getMoveCompent);
        tolua_function(tolua_S,"setRotation",lua_game_fishgame2d_MyObject_setRotation);
        tolua_function(tolua_S,"getManager",lua_game_fishgame2d_MyObject_getManager);
        tolua_function(tolua_S,"getObjectType",lua_game_fishgame2d_MyObject_getObjectType);
        tolua_function(tolua_S,"addBuff",lua_game_fishgame2d_MyObject_addBuff);
        tolua_function(tolua_S,"getState",lua_game_fishgame2d_MyObject_getState);
        tolua_function(tolua_S,"executeEffects",lua_game_fishgame2d_MyObject_executeEffects);
        tolua_function(tolua_S,"Clear",lua_game_fishgame2d_MyObject_Clear);
        tolua_function(tolua_S,"onUpdate",lua_game_fishgame2d_MyObject_onUpdate);
        tolua_function(tolua_S,"getGameDir",lua_game_fishgame2d_MyObject_getGameDir);
        tolua_function(tolua_S,"setPosition",lua_game_fishgame2d_MyObject_setPosition);
        tolua_function(tolua_S,"getPosition",lua_game_fishgame2d_MyObject_getPosition);
        tolua_function(tolua_S,"registerStatusChangedHandler",lua_game_fishgame2d_MyObject_registerStatusChangedHandler);
        tolua_function(tolua_S,"getVisualDebug",lua_game_fishgame2d_MyObject_getVisualDebug);
        tolua_function(tolua_S,"getRotation",lua_game_fishgame2d_MyObject_getRotation);
        tolua_function(tolua_S,"SetTarget",lua_game_fishgame2d_MyObject_SetTarget);
        tolua_function(tolua_S,"getVisualContent",lua_game_fishgame2d_MyObject_getVisualContent);
        tolua_function(tolua_S,"setId",lua_game_fishgame2d_MyObject_setId);
        tolua_function(tolua_S,"InSideScreen",lua_game_fishgame2d_MyObject_InSideScreen);
        tolua_function(tolua_S,"setManager",lua_game_fishgame2d_MyObject_setManager);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::MyObject).name();
    g_luaType[typeName] = "game.fishgame2d.MyObject";
    g_typeCast["MyObject"] = "game.fishgame2d.MyObject";
    return 1;
}

int lua_game_fishgame2d_Fish_getFishType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getFishType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getFishType'", nullptr);
            return 0;
        }
        int ret = cobj->getFishType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getFishType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getFishType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_getVisualId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getVisualId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getVisualId'", nullptr);
            return 0;
        }
        int ret = cobj->getVisualId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getVisualId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getVisualId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setFishType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setFishType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setFishType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setFishType'", nullptr);
            return 0;
        }
        cobj->setFishType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setFishType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setFishType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setLockLevel(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setLockLevel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setLockLevel");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setLockLevel'", nullptr);
            return 0;
        }
        cobj->setLockLevel(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setLockLevel",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setLockLevel'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_getMaxRadio(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getMaxRadio'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getMaxRadio'", nullptr);
            return 0;
        }
        int ret = cobj->getMaxRadio();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getMaxRadio",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getMaxRadio'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_getLockLevel(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getLockLevel'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getLockLevel'", nullptr);
            return 0;
        }
        int ret = cobj->getLockLevel();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getLockLevel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getLockLevel'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_getGoldMul(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getGoldMul'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getGoldMul'", nullptr);
            return 0;
        }
        int ret = cobj->getGoldMul();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getGoldMul",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getGoldMul'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        bool arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.Fish:OnUpdate");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "game.fishgame2d.Fish:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_OnUpdate'", nullptr);
            return 0;
        }
        bool ret = cobj->OnUpdate(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:OnUpdate",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setVisualId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setVisualId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setVisualId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setVisualId'", nullptr);
            return 0;
        }
        cobj->setVisualId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setVisualId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setVisualId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_getRefershId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_getRefershId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_getRefershId'", nullptr);
            return 0;
        }
        int ret = cobj->getRefershId();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:getRefershId",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_getRefershId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setRefershId(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setRefershId'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setRefershId");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setRefershId'", nullptr);
            return 0;
        }
        cobj->setRefershId(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setRefershId",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setRefershId'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_addBoundingBox(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_addBoundingBox'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        double arg0;
        double arg1;
        double arg2;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.Fish:addBoundingBox");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.Fish:addBoundingBox");

        ok &= luaval_to_number(tolua_S, 4,&arg2, "game.fishgame2d.Fish:addBoundingBox");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_addBoundingBox'", nullptr);
            return 0;
        }
        cobj->addBoundingBox(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:addBoundingBox",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_addBoundingBox'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setGoldMul(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setGoldMul'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setGoldMul");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setGoldMul'", nullptr);
            return 0;
        }
        cobj->setGoldMul(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setGoldMul",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setGoldMul'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_setState(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Fish* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Fish*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Fish_setState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Fish:setState");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_setState'", nullptr);
            return 0;
        }
        cobj->setState(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Fish:setState",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_setState'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Fish_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.Fish",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Fish_create'", nullptr);
            return 0;
        }
        game::fishgame2d::Fish* ret = game::fishgame2d::Fish::create();
        object_to_luaval<game::fishgame2d::Fish>(tolua_S, "game.fishgame2d.Fish",(game::fishgame2d::Fish*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.Fish:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Fish_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_Fish_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Fish)");
    return 0;
}

int lua_register_game_fishgame2d_Fish(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.Fish");
    tolua_cclass(tolua_S,"Fish","game.fishgame2d.Fish","game.fishgame2d.MyObject",nullptr);

    tolua_beginmodule(tolua_S,"Fish");
        tolua_function(tolua_S,"getFishType",lua_game_fishgame2d_Fish_getFishType);
        tolua_function(tolua_S,"getVisualId",lua_game_fishgame2d_Fish_getVisualId);
        tolua_function(tolua_S,"setFishType",lua_game_fishgame2d_Fish_setFishType);
        tolua_function(tolua_S,"setLockLevel",lua_game_fishgame2d_Fish_setLockLevel);
        tolua_function(tolua_S,"getMaxRadio",lua_game_fishgame2d_Fish_getMaxRadio);
        tolua_function(tolua_S,"getLockLevel",lua_game_fishgame2d_Fish_getLockLevel);
        tolua_function(tolua_S,"getGoldMul",lua_game_fishgame2d_Fish_getGoldMul);
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_Fish_OnUpdate);
        tolua_function(tolua_S,"setVisualId",lua_game_fishgame2d_Fish_setVisualId);
        tolua_function(tolua_S,"getRefershId",lua_game_fishgame2d_Fish_getRefershId);
        tolua_function(tolua_S,"setRefershId",lua_game_fishgame2d_Fish_setRefershId);
        tolua_function(tolua_S,"addBoundingBox",lua_game_fishgame2d_Fish_addBoundingBox);
        tolua_function(tolua_S,"setGoldMul",lua_game_fishgame2d_Fish_setGoldMul);
        tolua_function(tolua_S,"setState",lua_game_fishgame2d_Fish_setState);
        tolua_function(tolua_S,"create", lua_game_fishgame2d_Fish_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::Fish).name();
    g_luaType[typeName] = "game.fishgame2d.Fish";
    g_typeCast["Fish"] = "game.fishgame2d.Fish";
    return 1;
}

int lua_game_fishgame2d_Bullet_setCatchRadio(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_setCatchRadio'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Bullet:setCatchRadio");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_setCatchRadio'", nullptr);
            return 0;
        }
        cobj->setCatchRadio(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:setCatchRadio",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_setCatchRadio'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_getCannonSetType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_getCannonSetType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_getCannonSetType'", nullptr);
            return 0;
        }
        int ret = cobj->getCannonSetType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:getCannonSetType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_getCannonSetType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_getCatchRadio(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_getCatchRadio'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_getCatchRadio'", nullptr);
            return 0;
        }
        int ret = cobj->getCatchRadio();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:getCatchRadio",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_getCatchRadio'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        bool arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.Bullet:OnUpdate");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "game.fishgame2d.Bullet:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_OnUpdate'", nullptr);
            return 0;
        }
        bool ret = cobj->OnUpdate(arg0, arg1);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:OnUpdate",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_setCannonSetType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_setCannonSetType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Bullet:setCannonSetType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_setCannonSetType'", nullptr);
            return 0;
        }
        cobj->setCannonSetType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:setCannonSetType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_setCannonSetType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_getCannonType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_getCannonType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_getCannonType'", nullptr);
            return 0;
        }
        int ret = cobj->getCannonType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:getCannonType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_getCannonType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_setCannonType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_setCannonType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Bullet:setCannonType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_setCannonType'", nullptr);
            return 0;
        }
        cobj->setCannonType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:setCannonType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_setCannonType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_setState(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Bullet* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Bullet*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Bullet_setState'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Bullet:setState");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_setState'", nullptr);
            return 0;
        }
        cobj->setState(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Bullet:setState",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_setState'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Bullet_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.Bullet",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Bullet_create'", nullptr);
            return 0;
        }
        game::fishgame2d::Bullet* ret = game::fishgame2d::Bullet::create();
        object_to_luaval<game::fishgame2d::Bullet>(tolua_S, "game.fishgame2d.Bullet",(game::fishgame2d::Bullet*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.Bullet:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Bullet_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_Bullet_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Bullet)");
    return 0;
}

int lua_register_game_fishgame2d_Bullet(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.Bullet");
    tolua_cclass(tolua_S,"Bullet","game.fishgame2d.Bullet","game.fishgame2d.MyObject",nullptr);

    tolua_beginmodule(tolua_S,"Bullet");
        tolua_function(tolua_S,"setCatchRadio",lua_game_fishgame2d_Bullet_setCatchRadio);
        tolua_function(tolua_S,"getCannonSetType",lua_game_fishgame2d_Bullet_getCannonSetType);
        tolua_function(tolua_S,"getCatchRadio",lua_game_fishgame2d_Bullet_getCatchRadio);
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_Bullet_OnUpdate);
        tolua_function(tolua_S,"setCannonSetType",lua_game_fishgame2d_Bullet_setCannonSetType);
        tolua_function(tolua_S,"getCannonType",lua_game_fishgame2d_Bullet_getCannonType);
        tolua_function(tolua_S,"setCannonType",lua_game_fishgame2d_Bullet_setCannonType);
        tolua_function(tolua_S,"setState",lua_game_fishgame2d_Bullet_setState);
        tolua_function(tolua_S,"create", lua_game_fishgame2d_Bullet_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::Bullet).name();
    g_luaType[typeName] = "game.fishgame2d.Bullet";
    g_typeCast["Bullet"] = "game.fishgame2d.Bullet";
    return 1;
}

int lua_game_fishgame2d_MoveCompent_bTroop(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_bTroop'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_bTroop'", nullptr);
            return 0;
        }
        bool ret = cobj->bTroop();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:bTroop",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_bTroop'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setPause(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setPause'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setPause'", nullptr);
            return 0;
        }
        cobj->setPause();
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setPause");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setPause'", nullptr);
            return 0;
        }
        cobj->setPause(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setPause",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setPause'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_HasBeginMove(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_HasBeginMove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_HasBeginMove'", nullptr);
            return 0;
        }
        bool ret = cobj->HasBeginMove();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:HasBeginMove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_HasBeginMove'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_getPathID(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_getPathID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_getPathID'", nullptr);
            return 0;
        }
        int ret = cobj->getPathID();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:getPathID",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_getPathID'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setDelay(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setDelay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setDelay");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setDelay'", nullptr);
            return 0;
        }
        cobj->setDelay(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setDelay",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setDelay'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_OnUpdate'", nullptr);
            return 0;
        }
        cobj->OnUpdate(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:OnUpdate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_IsEndPath(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_IsEndPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_IsEndPath'", nullptr);
            return 0;
        }
        bool ret = cobj->IsEndPath();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:IsEndPath",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_IsEndPath'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setRebound(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setRebound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setRebound");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setRebound'", nullptr);
            return 0;
        }
        cobj->setRebound(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setRebound",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setRebound'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_Rebound(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_Rebound'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_Rebound'", nullptr);
            return 0;
        }
        bool ret = cobj->Rebound();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:Rebound",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_Rebound'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_OnDetach(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_OnDetach'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_OnDetach'", nullptr);
            return 0;
        }
        cobj->OnDetach();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:OnDetach",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_OnDetach'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_InitMove(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_InitMove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_InitMove'", nullptr);
            return 0;
        }
        cobj->InitMove();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:InitMove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_InitMove'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setSpeed(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setSpeed");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setSpeed'", nullptr);
            return 0;
        }
        cobj->setSpeed(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setSpeed",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setOffest(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setOffest'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Point arg0;

        ok &= luaval_to_point(tolua_S, 2, &arg0, "game.fishgame2d.MoveCompent:setOffest");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setOffest'", nullptr);
            return 0;
        }
        cobj->setOffest(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setOffest",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setOffest'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setPosition(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setPosition'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        double arg0;
        double arg1;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setPosition");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MoveCompent:setPosition");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setPosition'", nullptr);
            return 0;
        }
        cobj->setPosition(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setPosition",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setPosition'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_getOffest(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_getOffest'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_getOffest'", nullptr);
            return 0;
        }
        const cocos2d::Point& ret = cobj->getOffest();
        point_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:getOffest",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_getOffest'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_getDelay(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_getDelay'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_getDelay'", nullptr);
            return 0;
        }
        double ret = cobj->getDelay();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:getDelay",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_getDelay'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_getSpeed(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_getSpeed'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_getSpeed'", nullptr);
            return 0;
        }
        double ret = cobj->getSpeed();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:getSpeed",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_getSpeed'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setDirection(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setDirection'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:setDirection");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setDirection'", nullptr);
            return 0;
        }
        cobj->setDirection(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setDirection",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setDirection'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_OnAttach(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_OnAttach'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_OnAttach'", nullptr);
            return 0;
        }
        cobj->OnAttach();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:OnAttach",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_OnAttach'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_getOwner(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_getOwner'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_getOwner'", nullptr);
            return 0;
        }
        game::fishgame2d::MyObject* ret = cobj->getOwner();
        object_to_luaval<game::fishgame2d::MyObject>(tolua_S, "game.fishgame2d.MyObject",(game::fishgame2d::MyObject*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:getOwner",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_getOwner'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setOwner(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setOwner'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        game::fishgame2d::MyObject* arg0;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.MoveCompent:setOwner");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setOwner'", nullptr);
            return 0;
        }
        cobj->setOwner(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setOwner",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setOwner'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_isPaused(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_isPaused'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_isPaused'", nullptr);
            return 0;
        }
        bool ret = cobj->isPaused();
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:isPaused",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_isPaused'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_setPathID(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_setPathID'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MoveCompent:setPathID");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setPathID'", nullptr);
            return 0;
        }
        cobj->setPathID(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    if (argc == 2) 
    {
        int arg0;
        bool arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MoveCompent:setPathID");

        ok &= luaval_to_boolean(tolua_S, 3,&arg1, "game.fishgame2d.MoveCompent:setPathID");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_setPathID'", nullptr);
            return 0;
        }
        cobj->setPathID(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:setPathID",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_setPathID'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveCompent_SetEndPath(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveCompent* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveCompent",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveCompent*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveCompent_SetEndPath'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        bool arg0;

        ok &= luaval_to_boolean(tolua_S, 2,&arg0, "game.fishgame2d.MoveCompent:SetEndPath");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveCompent_SetEndPath'", nullptr);
            return 0;
        }
        cobj->SetEndPath(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveCompent:SetEndPath",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveCompent_SetEndPath'.",&tolua_err);
#endif

    return 0;
}
static int lua_game_fishgame2d_MoveCompent_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MoveCompent)");
    return 0;
}

int lua_register_game_fishgame2d_MoveCompent(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.MoveCompent");
    tolua_cclass(tolua_S,"MoveCompent","game.fishgame2d.MoveCompent","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"MoveCompent");
        tolua_function(tolua_S,"bTroop",lua_game_fishgame2d_MoveCompent_bTroop);
        tolua_function(tolua_S,"setPause",lua_game_fishgame2d_MoveCompent_setPause);
        tolua_function(tolua_S,"HasBeginMove",lua_game_fishgame2d_MoveCompent_HasBeginMove);
        tolua_function(tolua_S,"getPathID",lua_game_fishgame2d_MoveCompent_getPathID);
        tolua_function(tolua_S,"setDelay",lua_game_fishgame2d_MoveCompent_setDelay);
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_MoveCompent_OnUpdate);
        tolua_function(tolua_S,"IsEndPath",lua_game_fishgame2d_MoveCompent_IsEndPath);
        tolua_function(tolua_S,"setRebound",lua_game_fishgame2d_MoveCompent_setRebound);
        tolua_function(tolua_S,"Rebound",lua_game_fishgame2d_MoveCompent_Rebound);
        tolua_function(tolua_S,"OnDetach",lua_game_fishgame2d_MoveCompent_OnDetach);
        tolua_function(tolua_S,"InitMove",lua_game_fishgame2d_MoveCompent_InitMove);
        tolua_function(tolua_S,"setSpeed",lua_game_fishgame2d_MoveCompent_setSpeed);
        tolua_function(tolua_S,"setOffest",lua_game_fishgame2d_MoveCompent_setOffest);
        tolua_function(tolua_S,"setPosition",lua_game_fishgame2d_MoveCompent_setPosition);
        tolua_function(tolua_S,"getOffest",lua_game_fishgame2d_MoveCompent_getOffest);
        tolua_function(tolua_S,"getDelay",lua_game_fishgame2d_MoveCompent_getDelay);
        tolua_function(tolua_S,"getSpeed",lua_game_fishgame2d_MoveCompent_getSpeed);
        tolua_function(tolua_S,"setDirection",lua_game_fishgame2d_MoveCompent_setDirection);
        tolua_function(tolua_S,"OnAttach",lua_game_fishgame2d_MoveCompent_OnAttach);
        tolua_function(tolua_S,"getOwner",lua_game_fishgame2d_MoveCompent_getOwner);
        tolua_function(tolua_S,"setOwner",lua_game_fishgame2d_MoveCompent_setOwner);
        tolua_function(tolua_S,"isPaused",lua_game_fishgame2d_MoveCompent_isPaused);
        tolua_function(tolua_S,"setPathID",lua_game_fishgame2d_MoveCompent_setPathID);
        tolua_function(tolua_S,"SetEndPath",lua_game_fishgame2d_MoveCompent_SetEndPath);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::MoveCompent).name();
    g_luaType[typeName] = "game.fishgame2d.MoveCompent";
    g_typeCast["MoveCompent"] = "game.fishgame2d.MoveCompent";
    return 1;
}

int lua_game_fishgame2d_MoveByPath_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByPath* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByPath*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByPath_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveByPath:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_OnUpdate'", nullptr);
            return 0;
        }
        cobj->OnUpdate(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByPath:OnUpdate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByPath_OnDetach(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByPath* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByPath*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByPath_OnDetach'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_OnDetach'", nullptr);
            return 0;
        }
        cobj->OnDetach();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByPath:OnDetach",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_OnDetach'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByPath_setDuration(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByPath* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByPath*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByPath_setDuration'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MoveByPath:setDuration");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_setDuration'", nullptr);
            return 0;
        }
        cobj->setDuration(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByPath:setDuration",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_setDuration'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByPath_addPathMoveData(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByPath* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByPath*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByPath_addPathMoveData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 14) 
    {
        int arg0;
        double arg1;
        int arg2;
        int arg3;
        int arg4;
        int arg5;
        double arg6;
        double arg7;
        double arg8;
        double arg9;
        double arg10;
        double arg11;
        double arg12;
        double arg13;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 3,&arg1, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_int32(tolua_S, 6,(int *)&arg4, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_int32(tolua_S, 7,(int *)&arg5, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 8,&arg6, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 9,&arg7, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 10,&arg8, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 11,&arg9, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 12,&arg10, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 13,&arg11, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 14,&arg12, "game.fishgame2d.MoveByPath:addPathMoveData");

        ok &= luaval_to_number(tolua_S, 15,&arg13, "game.fishgame2d.MoveByPath:addPathMoveData");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_addPathMoveData'", nullptr);
            return 0;
        }
        cobj->addPathMoveData(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByPath:addPathMoveData",argc, 14);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_addPathMoveData'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByPath_InitMove(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByPath* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByPath*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByPath_InitMove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_InitMove'", nullptr);
            return 0;
        }
        cobj->InitMove();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByPath:InitMove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_InitMove'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByPath_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MoveByPath",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByPath_create'", nullptr);
            return 0;
        }
        game::fishgame2d::MoveByPath* ret = game::fishgame2d::MoveByPath::create();
        object_to_luaval<game::fishgame2d::MoveByPath>(tolua_S, "game.fishgame2d.MoveByPath",(game::fishgame2d::MoveByPath*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MoveByPath:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByPath_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_MoveByPath_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MoveByPath)");
    return 0;
}

int lua_register_game_fishgame2d_MoveByPath(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.MoveByPath");
    tolua_cclass(tolua_S,"MoveByPath","game.fishgame2d.MoveByPath","game.fishgame2d.MoveCompent",nullptr);

    tolua_beginmodule(tolua_S,"MoveByPath");
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_MoveByPath_OnUpdate);
        tolua_function(tolua_S,"OnDetach",lua_game_fishgame2d_MoveByPath_OnDetach);
        tolua_function(tolua_S,"setDuration",lua_game_fishgame2d_MoveByPath_setDuration);
        tolua_function(tolua_S,"addPathMoveData",lua_game_fishgame2d_MoveByPath_addPathMoveData);
        tolua_function(tolua_S,"InitMove",lua_game_fishgame2d_MoveByPath_InitMove);
        tolua_function(tolua_S,"create", lua_game_fishgame2d_MoveByPath_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::MoveByPath).name();
    g_luaType[typeName] = "game.fishgame2d.MoveByPath";
    g_typeCast["MoveByPath"] = "game.fishgame2d.MoveByPath";
    return 1;
}

int lua_game_fishgame2d_MoveByDirection_OnUpdate(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByDirection* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByDirection",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByDirection*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByDirection_OnUpdate'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        double arg0;

        ok &= luaval_to_number(tolua_S, 2,&arg0, "game.fishgame2d.MoveByDirection:OnUpdate");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByDirection_OnUpdate'", nullptr);
            return 0;
        }
        cobj->OnUpdate(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByDirection:OnUpdate",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByDirection_OnUpdate'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByDirection_OnDetach(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByDirection* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByDirection",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByDirection*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByDirection_OnDetach'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByDirection_OnDetach'", nullptr);
            return 0;
        }
        cobj->OnDetach();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByDirection:OnDetach",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByDirection_OnDetach'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByDirection_InitMove(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::MoveByDirection* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.MoveByDirection",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::MoveByDirection*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_MoveByDirection_InitMove'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByDirection_InitMove'", nullptr);
            return 0;
        }
        cobj->InitMove();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.MoveByDirection:InitMove",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByDirection_InitMove'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_MoveByDirection_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.MoveByDirection",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_MoveByDirection_create'", nullptr);
            return 0;
        }
        game::fishgame2d::MoveByDirection* ret = game::fishgame2d::MoveByDirection::create();
        object_to_luaval<game::fishgame2d::MoveByDirection>(tolua_S, "game.fishgame2d.MoveByDirection",(game::fishgame2d::MoveByDirection*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.MoveByDirection:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_MoveByDirection_create'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_MoveByDirection_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (MoveByDirection)");
    return 0;
}

int lua_register_game_fishgame2d_MoveByDirection(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.MoveByDirection");
    tolua_cclass(tolua_S,"MoveByDirection","game.fishgame2d.MoveByDirection","game.fishgame2d.MoveCompent",nullptr);

    tolua_beginmodule(tolua_S,"MoveByDirection");
        tolua_function(tolua_S,"OnUpdate",lua_game_fishgame2d_MoveByDirection_OnUpdate);
        tolua_function(tolua_S,"OnDetach",lua_game_fishgame2d_MoveByDirection_OnDetach);
        tolua_function(tolua_S,"InitMove",lua_game_fishgame2d_MoveByDirection_InitMove);
        tolua_function(tolua_S,"create", lua_game_fishgame2d_MoveByDirection_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::MoveByDirection).name();
    g_luaType[typeName] = "game.fishgame2d.MoveByDirection";
    g_typeCast["MoveByDirection"] = "game.fishgame2d.MoveByDirection";
    return 1;
}

int lua_game_fishgame2d_EffectFactory_CreateEffect(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"game.fishgame2d.EffectFactory",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 1)
    {
        int arg0;
        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.EffectFactory:CreateEffect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectFactory_CreateEffect'", nullptr);
            return 0;
        }
        game::fishgame2d::Effect* ret = game::fishgame2d::EffectFactory::CreateEffect(arg0);
        object_to_luaval<game::fishgame2d::Effect>(tolua_S, "game.fishgame2d.Effect",(game::fishgame2d::Effect*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "game.fishgame2d.EffectFactory:CreateEffect",argc, 1);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectFactory_CreateEffect'.",&tolua_err);
#endif
    return 0;
}
static int lua_game_fishgame2d_EffectFactory_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectFactory)");
    return 0;
}

int lua_register_game_fishgame2d_EffectFactory(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectFactory");
    tolua_cclass(tolua_S,"EffectFactory","game.fishgame2d.EffectFactory","",nullptr);

    tolua_beginmodule(tolua_S,"EffectFactory");
        tolua_function(tolua_S,"CreateEffect", lua_game_fishgame2d_EffectFactory_CreateEffect);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectFactory).name();
    g_luaType[typeName] = "game.fishgame2d.EffectFactory";
    g_typeCast["EffectFactory"] = "game.fishgame2d.EffectFactory";
    return 1;
}

int lua_game_fishgame2d_Effect_getEffectType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_getEffectType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_getEffectType'", nullptr);
            return 0;
        }
        int ret = cobj->getEffectType();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:getEffectType",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_getEffectType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_setParam(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_setParam'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 2) 
    {
        int arg0;
        int arg1;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Effect:setParam");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "game.fishgame2d.Effect:setParam");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_setParam'", nullptr);
            return 0;
        }
        cobj->setParam(arg0, arg1);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:setParam",argc, 2);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_setParam'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.Effect:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.Effect:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.Effect:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.Effect:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_setEffectType(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_setEffectType'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Effect:setEffectType");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_setEffectType'", nullptr);
            return 0;
        }
        cobj->setEffectType(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:setEffectType",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_setEffectType'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_getParamSize(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_getParamSize'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_getParamSize'", nullptr);
            return 0;
        }
        int ret = cobj->getParamSize();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:getParamSize",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_getParamSize'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_clearParam(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_clearParam'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_clearParam'", nullptr);
            return 0;
        }
        cobj->clearParam();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:clearParam",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_clearParam'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_Effect_getParam(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::Effect* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.Effect",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::Effect*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_Effect_getParam'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "game.fishgame2d.Effect:getParam");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_Effect_getParam'", nullptr);
            return 0;
        }
        int ret = cobj->getParam(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.Effect:getParam",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_Effect_getParam'.",&tolua_err);
#endif

    return 0;
}
static int lua_game_fishgame2d_Effect_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Effect)");
    return 0;
}

int lua_register_game_fishgame2d_Effect(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.Effect");
    tolua_cclass(tolua_S,"Effect","game.fishgame2d.Effect","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"Effect");
        tolua_function(tolua_S,"getEffectType",lua_game_fishgame2d_Effect_getEffectType);
        tolua_function(tolua_S,"setParam",lua_game_fishgame2d_Effect_setParam);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_Effect_execute);
        tolua_function(tolua_S,"setEffectType",lua_game_fishgame2d_Effect_setEffectType);
        tolua_function(tolua_S,"getParamSize",lua_game_fishgame2d_Effect_getParamSize);
        tolua_function(tolua_S,"clearParam",lua_game_fishgame2d_Effect_clearParam);
        tolua_function(tolua_S,"getParam",lua_game_fishgame2d_Effect_getParam);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::Effect).name();
    g_luaType[typeName] = "game.fishgame2d.Effect";
    g_typeCast["Effect"] = "game.fishgame2d.Effect";
    return 1;
}

int lua_game_fishgame2d_EffectAddMoney_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAddMoney* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectAddMoney",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectAddMoney*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectAddMoney_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectAddMoney:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectAddMoney:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectAddMoney:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectAddMoney:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAddMoney_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAddMoney:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAddMoney_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectAddMoney_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAddMoney* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAddMoney_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectAddMoney();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectAddMoney");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAddMoney:EffectAddMoney",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAddMoney_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectAddMoney_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectAddMoney)");
    return 0;
}

int lua_register_game_fishgame2d_EffectAddMoney(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectAddMoney");
    tolua_cclass(tolua_S,"EffectAddMoney","game.fishgame2d.EffectAddMoney","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectAddMoney");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectAddMoney_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectAddMoney_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectAddMoney).name();
    g_luaType[typeName] = "game.fishgame2d.EffectAddMoney";
    g_typeCast["EffectAddMoney"] = "game.fishgame2d.EffectAddMoney";
    return 1;
}

int lua_game_fishgame2d_EffectKill_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectKill* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectKill",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectKill*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectKill_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectKill:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectKill:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectKill:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectKill:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectKill_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectKill:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectKill_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectKill_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectKill* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectKill_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectKill();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectKill");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectKill:EffectKill",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectKill_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectKill_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectKill)");
    return 0;
}

int lua_register_game_fishgame2d_EffectKill(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectKill");
    tolua_cclass(tolua_S,"EffectKill","game.fishgame2d.EffectKill","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectKill");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectKill_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectKill_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectKill).name();
    g_luaType[typeName] = "game.fishgame2d.EffectKill";
    g_typeCast["EffectKill"] = "game.fishgame2d.EffectKill";
    return 1;
}

int lua_game_fishgame2d_EffectAddBuffer_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAddBuffer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectAddBuffer",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectAddBuffer*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectAddBuffer_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectAddBuffer:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectAddBuffer:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectAddBuffer:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectAddBuffer:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAddBuffer_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAddBuffer:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAddBuffer_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectAddBuffer_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAddBuffer* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAddBuffer_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectAddBuffer();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectAddBuffer");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAddBuffer:EffectAddBuffer",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAddBuffer_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectAddBuffer_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectAddBuffer)");
    return 0;
}

int lua_register_game_fishgame2d_EffectAddBuffer(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectAddBuffer");
    tolua_cclass(tolua_S,"EffectAddBuffer","game.fishgame2d.EffectAddBuffer","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectAddBuffer");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectAddBuffer_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectAddBuffer_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectAddBuffer).name();
    g_luaType[typeName] = "game.fishgame2d.EffectAddBuffer";
    g_typeCast["EffectAddBuffer"] = "game.fishgame2d.EffectAddBuffer";
    return 1;
}

int lua_game_fishgame2d_EffectProduce_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectProduce* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectProduce",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectProduce*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectProduce_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectProduce:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectProduce:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectProduce:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectProduce:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectProduce_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectProduce:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectProduce_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectProduce_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectProduce* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectProduce_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectProduce();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectProduce");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectProduce:EffectProduce",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectProduce_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectProduce_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectProduce)");
    return 0;
}

int lua_register_game_fishgame2d_EffectProduce(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectProduce");
    tolua_cclass(tolua_S,"EffectProduce","game.fishgame2d.EffectProduce","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectProduce");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectProduce_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectProduce_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectProduce).name();
    g_luaType[typeName] = "game.fishgame2d.EffectProduce";
    g_typeCast["EffectProduce"] = "game.fishgame2d.EffectProduce";
    return 1;
}

int lua_game_fishgame2d_EffectBlackWater_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectBlackWater* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectBlackWater",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectBlackWater*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectBlackWater_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectBlackWater:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectBlackWater:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectBlackWater:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectBlackWater:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectBlackWater_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectBlackWater:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectBlackWater_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectBlackWater_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectBlackWater* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectBlackWater_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectBlackWater();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectBlackWater");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectBlackWater:EffectBlackWater",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectBlackWater_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectBlackWater_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectBlackWater)");
    return 0;
}

int lua_register_game_fishgame2d_EffectBlackWater(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectBlackWater");
    tolua_cclass(tolua_S,"EffectBlackWater","game.fishgame2d.EffectBlackWater","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectBlackWater");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectBlackWater_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectBlackWater_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectBlackWater).name();
    g_luaType[typeName] = "game.fishgame2d.EffectBlackWater";
    g_typeCast["EffectBlackWater"] = "game.fishgame2d.EffectBlackWater";
    return 1;
}

int lua_game_fishgame2d_EffectAward_execute(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAward* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"game.fishgame2d.EffectAward",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (game::fishgame2d::EffectAward*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_game_fishgame2d_EffectAward_execute'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 4) 
    {
        game::fishgame2d::MyObject* arg0;
        game::fishgame2d::MyObject* arg1;
        cocos2d::Vector<game::fishgame2d::MyObject *> arg2;
        bool arg3;

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 2, "game.fishgame2d.MyObject",&arg0, "game.fishgame2d.EffectAward:execute");

        ok &= luaval_to_object<game::fishgame2d::MyObject>(tolua_S, 3, "game.fishgame2d.MyObject",&arg1, "game.fishgame2d.EffectAward:execute");

        ok &= luaval_to_ccvector(tolua_S, 4, &arg2, "game.fishgame2d.EffectAward:execute");

        ok &= luaval_to_boolean(tolua_S, 5,&arg3, "game.fishgame2d.EffectAward:execute");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAward_execute'", nullptr);
            return 0;
        }
        long ret = cobj->execute(arg0, arg1, arg2, arg3);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAward:execute",argc, 4);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAward_execute'.",&tolua_err);
#endif

    return 0;
}
int lua_game_fishgame2d_EffectAward_constructor(lua_State* tolua_S)
{
    int argc = 0;
    game::fishgame2d::EffectAward* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_game_fishgame2d_EffectAward_constructor'", nullptr);
            return 0;
        }
        cobj = new game::fishgame2d::EffectAward();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"game.fishgame2d.EffectAward");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "game.fishgame2d.EffectAward:EffectAward",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_game_fishgame2d_EffectAward_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_game_fishgame2d_EffectAward_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (EffectAward)");
    return 0;
}

int lua_register_game_fishgame2d_EffectAward(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"game.fishgame2d.EffectAward");
    tolua_cclass(tolua_S,"EffectAward","game.fishgame2d.EffectAward","game.fishgame2d.Effect",nullptr);

    tolua_beginmodule(tolua_S,"EffectAward");
        tolua_function(tolua_S,"new",lua_game_fishgame2d_EffectAward_constructor);
        tolua_function(tolua_S,"execute",lua_game_fishgame2d_EffectAward_execute);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(game::fishgame2d::EffectAward).name();
    g_luaType[typeName] = "game.fishgame2d.EffectAward";
    g_typeCast["EffectAward"] = "game.fishgame2d.EffectAward";
    return 1;
}
TOLUA_API int register_all_game_fishgame2d(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
    //
	//tolua_module(tolua_S,"game.fishgame2d",0);
	//tolua_beginmodule(tolua_S,"game.fishgame2d");
	//
    tolua_module(tolua_S,"game",0);
    tolua_beginmodule(tolua_S,"game");
    tolua_module(tolua_S,"fishgame2d",0);
    tolua_beginmodule(tolua_S,"fishgame2d");

	lua_register_game_fishgame2d_MoveCompent(tolua_S);
	lua_register_game_fishgame2d_MoveByDirection(tolua_S);
	lua_register_game_fishgame2d_FishObjectManager(tolua_S);
	lua_register_game_fishgame2d_MyObject(tolua_S);
	lua_register_game_fishgame2d_Bullet(tolua_S);
	lua_register_game_fishgame2d_Effect(tolua_S);
	lua_register_game_fishgame2d_EffectProduce(tolua_S);
	lua_register_game_fishgame2d_Fish(tolua_S);
	lua_register_game_fishgame2d_EffectKill(tolua_S);
	lua_register_game_fishgame2d_PathManager(tolua_S);
	lua_register_game_fishgame2d_MoveByPath(tolua_S);
	lua_register_game_fishgame2d_FishUtils(tolua_S);
	lua_register_game_fishgame2d_MathAide(tolua_S);
	lua_register_game_fishgame2d_EffectAddBuffer(tolua_S);
	lua_register_game_fishgame2d_EffectAward(tolua_S);
	lua_register_game_fishgame2d_EffectAddMoney(tolua_S);
	lua_register_game_fishgame2d_EffectFactory(tolua_S);
	lua_register_game_fishgame2d_EffectBlackWater(tolua_S);

    tolua_endmodule(tolua_S);
    tolua_endmodule(tolua_S);
	return 1;
}

