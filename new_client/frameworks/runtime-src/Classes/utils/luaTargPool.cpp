#include "luaTargPool.h"
#include "cocos2d.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

void luaTargPool::AddArg(int64_t Value)
{
	TArgInt* pObj = new TArgInt(Value);
	ArgList.push_back(pObj);
}
void luaTargPool::AddArg(string Str)
{
	TArgStr* pObj = new TArgStr(Str);
	ArgList.push_back(pObj);
}
void luaTargPool::AddArg(bool Value)
{
	TArgBool* pObj = new TArgBool(Value);
	ArgList.push_back(pObj);
}
//void luaTargPool::AddArg(NetMessage& msg)
//{
//	TArgMessage *pObj = new TArgMessage(msg);
//	ArgList.push_back(pObj);
//}
void luaTargPool::Push(lua_State* L)const
{
	for (size_t i = 0; i < ArgList.size(); i++)
	{   
		ArgList[i]->pushvalue(L);
	}
}
luaTargPool::~luaTargPool()
{
	for (size_t i = 0; i < ArgList.size(); i++)
	{
		delete ArgList[i];
	}
	ArgList.clear();
}
int luaTargPool::CallLua(lua_State* L, const char* fname, const luaTargPool& ArgPoolObj)
{
	this->Push(L);
	return cocos2d::LuaEngine::getInstance()->executeGlobalFunction(fname);
}