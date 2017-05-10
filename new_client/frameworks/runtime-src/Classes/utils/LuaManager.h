// LuaManager.h
// RPGGame
//
// Created by qh on 15/5/23.
//
//
 
#ifndef __RPGGame__LuaManager__
#define __RPGGame__LuaManager__
 
#include "cocos2d.h"

USING_NS_CC;
using namespace std;
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
class LuaManager : public Ref
{
public:
	LuaManager();
	~LuaManager();
	static LuaManager* getInstance();
	CREATE_FUNC(LuaManager);
	virtual bool init();
    CC_SYNTHESIZE_READONLY(LuaEngine *, _luaEngine, luaEngine);
    CC_SYNTHESIZE_READONLY(lua_State *, _luaState, luaState);
	//
	void initGameLua();
private:

};
 
#endif /* defined(__RPGGame__LuaManager__) */
