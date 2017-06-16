#pragma once

#ifndef _FISH_GAME_EFFECT_
#define _FISH_GAME_EFFECT_


#include "./common.h"
#include <vector>


NS_FISHGAME2D_BEGIN

enum EffectType{
	ETF_NONE = -1,
	ETP_ADDMONEY, // 增加金币
	ETP_KILL, //杀死其它鱼
	ETP_ADDBUFFER, //增加BUFFER
	ETP_PRODUCE, //生成其它鱼
	ETP_BLACKWATER, //乌贼喷墨汁效果
	ETP_AWARD, //抽奖
};

class MyObject;

class Effect;
class EffectAddMoney;
class EffectKill;
class EffectAddBuffer;
class EffectProduce;
class EffectBlackWater;
class EffectAward;

class EffectFactory //: public Singleton<EffectFactory>
{
protected:
	EffectFactory();
	virtual ~EffectFactory();

	//friend class Singleton<EffectFactory>;
	//friend class std::auto_ptr<EffectFactory>;

public:
	static Effect* CreateEffect(int);
};

class Effect : public cocos2d::Ref{
protected:
	Effect();
public:
	virtual ~Effect();

	int getEffectType(){ return m_nType; }
	void setEffectType(int etp){ m_nType = etp; }

	int getParam(int pos);
	void setParam(int pos, int p);

	void clearParam();

	int getParamSize(){ return m_nParam.size(); }

	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating) = 0;

protected:
	int			m_nType;
	std::vector<int>	m_nParam;
};

//增加金币
//参数１为０时表示增加固定的金币数，参数２表示钱数
//参数１为１时表示增加一定倍数的钱数，参数２表示倍数
class EffectAddMoney : public Effect {
public:
	EffectAddMoney();
	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
	long lSco;
};

//杀死杀死其它鱼
//参数１为０时表示杀死全部的鱼
//参数１为１时表示杀死指定范围内的鱼，参数２表示半径
//参数１为２时表示杀死指定类型的鱼，参数２表示指定类型
//参数１为３时表示杀死同一批次刷出来的鱼。
class EffectKill : public Effect {
public:
	EffectKill();
	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
};

//增加ＢＵＦＦ
//参数１表示要增加的ＢＵＦＦ的范围， ０表示全部的鱼,１表示范围内的鱼,２表示指定类型的鱼
//参数１为１时表示杀死指定范围内的鱼，参数２表示半径;参数１为２时表示指定类型的鱼，参数２表示指定类型
//参数３表示要增加的ＢＵＦＦＥＲ类型
//参数４表示要增加的ＢＵＦＦＥＲ的参数
//参数５表示要增加的ＢＵＦＦＥＲ的时长
class EffectAddBuffer : public Effect {
public:
	EffectAddBuffer();
	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
};

//生成鱼
//参数１表示要生成的鱼的ＩＤ
//参数２表示要生成的鱼的批次
//参数３表示每个批次要生成的鱼的数量
//参数４表示每个批次之间的时间间隔
class EffectProduce : public Effect {
public:
	EffectProduce();
	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
};

//乌贼墨汁效果
class EffectBlackWater : public Effect {
public:
	EffectBlackWater();
	virtual	long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
};

//抽奖效果展示
//参数１表示奖项, 0-7
//参数２表示实际效果 ０加金币　　１加ＢＵＦＦＥＲ
//参数３ 在加金币时　３为０表示加固定的钱，参数４表示钱的数量
//					 ３为１表示加倍返钱，参数４表示钱的倍数
//在加ＢＵＦＦＥＲ时　３表示ＢＵＦＦＥＲ类型　４表示ＢＵＦＦＥＲ时间
class EffectAward : public Effect {
public:
	EffectAward();
	virtual long execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);
};
NS_FISHGAME2D_END

#endif