#ifndef __luaTargPool__
#define __luaTargPool__
#include "luaTarg.h"
extern "C"{
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}
#include <iostream>
#include <vector>
using namespace std;

class luaTargPool
{
	std::vector<TArg*> ArgList;
public:
	luaTargPool(){}
	void AddArg(int64_t Value);
	void AddArg(string Str);
	void AddArg(bool Value);
	//void AddArg(NetMessage& msg);
	void Push(lua_State* L)const;
	int CallLua(lua_State* L, const char* fname, const luaTargPool& ArgPoolObj);
	~luaTargPool();
}; 

#endif