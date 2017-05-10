#ifndef __EXTENT_ACTION_h__
#define __EXTENT_ACTION_h__

#include "cocos2d.h"
#include "my-cocos-ext.h"


using namespace std;

NS_MY_COCOS_EXT_BEGIN

class FuncAction : public cocos2d::ActionInterval
{
protected:
	FuncAction();
public:
	virtual ~FuncAction();

	static FuncAction* create(float duration, int intervalHandler){
		FuncAction* funcAction = new (std::nothrow) FuncAction();
		funcAction->initWithDuration(duration, intervalHandler);
		funcAction->autorelease();

		return funcAction;
	}

	virtual void update(float time);

private:
	virtual bool initWithDuration(float duration, int handler);

	int m_nHandlerInterval;
};

NS_MY_COCOS_EXT_END


#endif