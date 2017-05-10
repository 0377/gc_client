#include "ExtendAction.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/CCLuaStack.h"

NS_MY_COCOS_EXT_BEGIN
FuncAction::FuncAction() : m_nHandlerInterval(0) {};

FuncAction::~FuncAction(){}

void FuncAction::update(float time){
#if CC_ENABLE_SCRIPT_BINDING
	cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
	_stack->pushObject(_target, "cocos2d.Node");
	_stack->pushFloat(time);

	int ret = _stack->executeFunctionByHandler(m_nHandlerInterval, 2);
	_stack->clean();
#endif
}

bool FuncAction::initWithDuration(float duration, int handler){
	if (ActionInterval::initWithDuration(duration))
	{
		m_nHandlerInterval = handler;

		return true;
	}

	return false;
}
NS_MY_COCOS_EXT_END
