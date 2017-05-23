#include "Effect.h"
#include "MathAide.h"
#include "MoveCompent.h"
#include "MyObject.h"
#include "FishObjectManager.h"

NS_FISHGAME2D_BEGIN
EffectFactory::EffectFactory() {}

EffectFactory::~EffectFactory() {}

Effect* EffectFactory::CreateEffect(int type){
	Effect* pEffect = nullptr;
	switch (type){
	case ETP_ADDMONEY: 
		pEffect = new (std::nothrow) EffectAddMoney();
		break;
	case ETP_KILL:
		pEffect = new (std::nothrow) EffectKill();
		break;
	case ETP_ADDBUFFER:
		pEffect = new (std::nothrow) EffectAddBuffer();
		break;
	case ETP_PRODUCE:
		pEffect = new (std::nothrow) EffectProduce();
		break;
	case ETP_BLACKWATER:
		pEffect = new (std::nothrow) EffectBlackWater();
		break;
	case ETP_AWARD:
		pEffect = new (std::nothrow) EffectAward();
		break;
	}
	if (pEffect){
		pEffect->SetEffectType(type);
		pEffect->autorelease();
	}
	else{
		CC_SAFE_DELETE(pEffect);
	}

	return pEffect;
}

Effect::Effect()
	: cocos2d::Ref()
	, m_nType(ETF_NONE)
{ 
	m_nParam.resize(2);
	ClearParam();
}

Effect::~Effect(){ }


void Effect::ClearParam()
{
	for (int i = 0; i < m_nParam.size(); ++i)
	{
		m_nParam[i] = 0;
	}
}

int Effect::GetParam(int pos)
{
	if (pos >= m_nParam.size()) return 0;

	return m_nParam[pos];
}

void Effect::SetParam(int pos, int p)
{
	if (pos > m_nParam.size()) return;

	m_nParam[pos] = p;
}

EffectAddMoney::EffectAddMoney()
	: Effect()
{
	m_nParam.resize(3);
	ClearParam();
	lSco = 0;
}
long EffectAddMoney::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL) return 0;

	//LONGLONG lScore = 0;
	//int mul = 1;
	//
	//if (lSco == 0)
	//{
	//	lSco = GetParam(2) > GetParam(1) ? RandInt(GetParam(1), GetParam(2)) : GetParam(1);
	//}
	//
	//if (GetParam(0) == 0)
	//{
	//	mul = 1;
	//}
	//else if (pTarget != NULL)
	//{
	//	mul = pTarget->GetScore();
	//}
	//
	//int n = -1;
	//CComEvent se;
	//se.SetID(EME_QUERY_ADDMUL);
	//se.SetParam1(0);
	//se.SetParam2(&n);
	//pSelf->ProcessCCEvent(&se);
	//
	//if (n != -1)
	//{
	//	lSco = CGameConfig::GetInstance()->nAddMulBegin;
	//
	//	if (n + lSco > GetParam(2))
	//		n = GetParam(2) - lSco;
	//
	//	if (!bPretreating)
	//		CGameConfig::GetInstance()->nAddMulCur = 0;
	//}
	//else
	//	n = 0;
	//
	//lScore = (lSco + n) * mul;
	//
	//if (pTarget->GetObjType() == EOT_BULLET && ((CBullet*)pTarget)->bDouble())
	//	lScore *= 2;
	//
	//return lScore;
	return 0;
}

EffectKill::EffectKill()
	:Effect()
{
	m_nParam.resize(3);
	ClearParam();
}

long EffectKill::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL) return 0;

	// if (!bPretreating)
	// 	RaiseEvent("AddChain", this, pSelf);

	auto* pMgr = pSelf->getManager();
	if (pMgr != NULL)
	{
		auto ifs = pMgr->BeginFish();
		while (ifs != pMgr->EndFish())
		{
			MyObject* pObj = ifs->second;
			MoveCompent* pMove = pObj->getMoveCompent();
			if (pObj->getId() != pSelf->getId() && pMove)
			{
				if (GetParam(0) == 0 && pObj->InSideScreen() && pMove->HasBeginMove())//参数１为０时表示杀死全部的鱼
				{
					FishObjectManager::GetInstance()->OnActionEffect(pSelf, pObj, this);

					pObj->ExecuteEffects(pTarget, list, bPretreating);
				}
				else if (GetParam(0) == 1 && pObj->InSideScreen() && pMove->HasBeginMove())//参数１为１时表示杀死指定范围内的鱼，参数２表示半径
				{
					if (MathAide::CalcDistance(pSelf->getPosition().x, pSelf->getPosition().y, pObj->getPosition().x, pObj->getPosition().y) <= GetParam(1)){
						FishObjectManager::GetInstance()->OnActionEffect(pSelf, pObj, this);
						pObj->ExecuteEffects(pTarget, list, bPretreating);
					}
				}
				else if (GetParam(0) == 2 && pObj->InSideScreen() && pObj->getMoveCompent()->HasBeginMove())//参数１为２时表示杀死指定类型的鱼，参数２表示指定类型
				{
					if (pObj->getTypeId() == GetParam(1) && ((Fish*)pObj)->GetFishType() == ESFT_NORMAL){
						FishObjectManager::GetInstance()->OnActionEffect(pSelf, pObj, this);
						pObj->ExecuteEffects(pTarget, list, bPretreating);
					}
				}
				else if (GetParam(0) == 3)//参数１为３时表示杀死同一批次刷出来的鱼。
				{
					if (((Fish*)pObj)->getRefershId() == ((Fish*)pSelf)->getRefershId()){
						FishObjectManager::GetInstance()->OnActionEffect(pSelf, pObj, this);
						pObj->ExecuteEffects(pTarget, list, bPretreating);
					}
				}
			}
			++ifs;
		}
	}

	//if (score / pTarget->GetScore() > GetParam(2))
	//	score = pTarget->GetScore() * GetParam(2);

	return 0;
}

EffectAddBuffer::EffectAddBuffer()
	:Effect()
{
	m_nParam.resize(5);
	ClearParam();
}

long EffectAddBuffer::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL || bPretreating) return 0;

	// RaiseEvent("AddBuffer", this, pSelf);

	auto* pMgr = pSelf->getManager();
	if (pMgr != NULL)
	{
		auto ifs = pMgr->BeginFish();
		while (ifs != pMgr->EndFish())
		{
			MyObject* pObj = (MyObject*)ifs->second;

			if (pObj != pSelf && pObj->getId() != pSelf->getId() /* && pObj->InSideScreen()*/)
			{
				if (GetParam(0) == 0)//参数１为０时表示全部的鱼
				{
					pObj->AddBuff(GetParam(2), GetParam(3), GetParam(4));
				}
				else if (GetParam(0) == 1)//参数１为１时表示指定范围内的鱼，参数２表示半径
				{
					if (MathAide::CalcDistance(pSelf->getPosition().x, pSelf->getPosition().y, pObj->getPosition().x, pObj->getPosition().y) <= GetParam(1))
						pObj->AddBuff(GetParam(2), GetParam(3), GetParam(4));
				}
				else if (GetParam(0) == 2)//参数１为２时表示指定类型的鱼，参数２表示指定类型
				{
					if (pObj->getTypeId() == GetParam(1))
						pObj->AddBuff(GetParam(2), GetParam(3), GetParam(4));
				}
			}

			++ifs;
		}
	}

	return 0;
}

EffectProduce::EffectProduce()
	:Effect()
{
	m_nParam.resize(4);
	ClearParam();
}

long EffectProduce::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL || bPretreating) return 0;

	// EffectProduce* test = new EffectProduce();
	// int index = 0;
	// for (auto i : m_nParam){
	// 	test->SetParam(index++, i);
	// }
	// 
	// MyPoint* temp = new MyPoint;
	// *temp = pTarget->GetPosition();
	// 
	// RaiseEvent("ProduceFish", test, pSelf, temp);

	return 0;
}

EffectBlackWater::EffectBlackWater()
	: Effect()
{
	m_nParam.resize(0);
	m_nParam.clear();
}

long EffectBlackWater::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL || bPretreating) return 0;

	// RaiseEvent("BlackWater", this, pSelf);

	return 0;
}

EffectAward::EffectAward() 
	: Effect()
{
	m_nParam.resize(4);
	ClearParam();
}

long EffectAward::Execute(MyObject* pSelf, MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating)
{
	if (pSelf == NULL) return 0;

	// LONGLONG lScore = 0;
	// 
	// if (GetParam(1) == 0 && bPretreating)
	// {
	// 	if (GetParam(2) == 0)
	// 		lScore = GetParam(3);
	// 	else if (pTarget != NULL)
	// 		lScore = pTarget->GetScore() * GetParam(3);
	// }
	// 
	// if (!bPretreating)
	// 	RaiseEvent("AdwardEvent", this, pSelf, pTarget);
	// 
	return 0;
}
NS_FISHGAME2D_END