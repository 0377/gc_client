#include "MyObject.h"
#include "common.h"
#include "MoveCompent.h"
#include "MyScene.h"
#include "PathManager.h"
#include "Buff.h"
#include "Effect.h"

NS_FISHGAME2D_BEGIN

MyObject::MyObject() 
	: cocos2d::Ref()
	, m_nType(EOT_NONE)
	, m_nId(0)
	, m_fDirection(0.0f)
	, m_bInScreen(false)
	, m_bDirtyPos(false)
	, m_bDirtyDir(false)
	, m_bDirtyInScreen(false)
	, m_nState(EOS_INIT)
	, m_bDirtyState(false)
	, m_pOwner(nullptr)
	, m_pManager(nullptr)
	, m_pMoveCompent(nullptr)
	, m_nTargetId(0)
{}

MyObject::~MyObject(){
	

	if (m_pMoveCompent != nullptr){
		if (m_pMoveCompent->getReferenceCount() > 1) {
			int a = m_pMoveCompent->getReferenceCount();
			int b = 1;
		}
		m_pMoveCompent->release();
	}

	for (auto v : m_pEffectList){
		v->release();
	}
	m_pEffectList.clear();

	for (auto v : m_pBuffList){
		v->release();
	}
	m_pBuffList.clear();
		
	for (auto& v : m_pVisualNodeList){
		if (v.target) v.target->removeFromParentAndCleanup(true);
		if (v.targetShadow) v.targetShadow->removeFromParentAndCleanup(true);
		v.target = nullptr;
		v.targetShadow = nullptr;
	}
	m_pVisualNodeList.clear();
}

void MyObject::Clear(bool bForce, bool noCleanNode){
	if (bForce){
		for (auto& v : m_pVisualNodeList){
			if (v.target) v.target->removeFromParentAndCleanup(true);
			if (v.targetShadow) v.targetShadow->removeFromParentAndCleanup(true);
			v.target = nullptr;
			v.targetShadow = nullptr;
		}
		m_pVisualNodeList.clear();
	}
	else{
		for (auto& v : m_pVisualNodeList){
			if (v.target) v.target->runAction(cocos2d::Sequence::createWithTwoActions(
				cocos2d::DelayTime::create(m_nType == EOT_FISH ? 3 : 1), cocos2d::CallFuncN::create([](cocos2d::Node* sender){
				sender->removeFromParentAndCleanup(true);
			})));
			if (v.targetShadow) v.targetShadow->runAction(cocos2d::Sequence::createWithTwoActions(
				cocos2d::DelayTime::create(m_nType == EOT_FISH ? 3 : 1), cocos2d::CallFuncN::create([](cocos2d::Node* sender){
				sender->removeFromParentAndCleanup(true);
			})));

			v.target = nullptr;
			v.targetShadow = nullptr;
		}
		m_pVisualNodeList.clear();
	}
	OnClear(bForce);
}

void MyObject::OnClear(bool){ }

bool MyObject::OnUpdate(float dt, bool shouldUpdate){
	bool ret = shouldUpdate;

	if (m_pMoveCompent != nullptr){
		m_pMoveCompent->OnUpdate(dt);
	}
	auto it = m_pBuffList.begin();
	while (it != m_pBuffList.end())
	{
		if (!(*it)->OnUpdate(dt))
		{
			(*it)->release();
			it = m_pBuffList.erase(it);
			continue;
		}
		++it;
	}


	// 更新状态和显示;
	if (shouldUpdate
		&& m_pManager != nullptr
		&& m_bInScreen 
		&& m_bDirtyState 
		&& FishObjectManager::GetInstance()->IsGameLoaded()){
		m_bDirtyState = false;

		for (auto& v : m_pVisualNodeList){
			if (v.target) v.target->removeFromParentAndCleanup(true);
			if (v.targetShadow) v.targetShadow->removeFromParentAndCleanup(true);
			v.target = nullptr;
			v.targetShadow = nullptr;
		}
		m_pVisualNodeList.clear();

		MyScene* scene = (MyScene*)cocos2d::Director::getInstance()->getRunningScene();
		if (scene != nullptr){
			scene->AddMyObject(this, &m_pVisualNodeList);
		}

			
		m_bDirtyPos = true;
		m_bDirtyDir = true;
		m_bDirtyInScreen = true;
	}
	else{
		ret = false;
	}

	// 更新位置;
	if (m_bDirtyPos || m_bDirtyDir || m_bDirtyInScreen){
		float x, y, dir, sinDir, cosDir;
		dir = m_fDirection;

		if (m_bDirtyDir){
			FishObjectManager::GetInstance()->ConvertDirection(&dir);
		}

		if (m_bDirtyPos){
			x = m_pPosition.x;
			y = m_pPosition.y;
			FishObjectManager::GetInstance()->ConvertCoord(&x, &y);

			sinDir = sinf(dir);
			cosDir = cosf(dir);
		}

		for (auto& i : m_pVisualNodeList)
		{
			if (m_bDirtyPos){
				float __x = i.offsetX * cosDir - i.offsetY * sinDir + x;
				float __y = i.offsetX * sinDir + i.offsetY * cosDir + y;

				if (i.targetShadow) i.targetShadow->setPosition(__x, __y - 30);
				if (i.target) i.target->setPosition(__x, __y);
			}
			if (m_bDirtyDir){
				float __dir = CC_RADIANS_TO_DEGREES(-dir + i.direction);

				if (i.targetShadow) i.targetShadow->setRotation(__dir);
				if (i.target) i.target->setRotation(__dir);
			}
			if (m_bDirtyInScreen){
				if (i.targetShadow) i.targetShadow->setVisible(m_bInScreen);
				if (i.target) i.target->setVisible(m_bInScreen);
			}
		}
		m_bDirtyPos = false;
		m_bDirtyDir = false;
		m_bDirtyInScreen = false;
	}

	return ret;
}

void MyObject::OnMoveEnd(){
	SetState(EOS_DESTORY);
}

void MyObject::SetPosition(float x, float y){
	if (m_pPosition.x == x && m_pPosition.y == y) {
		return;
	}
	m_pPosition.x = x;
	m_pPosition.y = y;
	m_bDirtyPos = true;

	// 检测是否在屏幕内;
	if (x < -100 || y < -100 || x > 1540 || y > 1000) {
		if (m_bInScreen){
			OnMoveEnd();
		}
		m_bInScreen = false;
	}
	else{
		m_bInScreen = true;
	}
}

void  MyObject::SetDirection(float dir){
	if (m_fDirection == dir){
		return;
	}
	m_fDirection = dir;
	m_bDirtyDir = true;
}

void MyObject::SetState(int st){
	if (st == m_nState) {
		return;
	}

	if ((st == EOS_LIVE || st == EOS_HIT)
		&& (m_nState == EOS_LIVE || m_nState == EOS_HIT)){
		return;
	}

	m_nState = st;
	m_bDirtyState = true;

}

void MyObject::AddBuff(int buffType, float buffParam, float buffTime){
	auto* pBuff = Buff::create(buffType, buffParam, buffTime);
	if (pBuff != nullptr)
	{
		pBuff->retain();
		m_pBuffList.push_back(pBuff);
	}
}

void MyObject::AddEffect(Effect* effect){
	if (effect != nullptr){
		effect->retain();
		m_pEffectList.push_back(effect);
	}
}

void MyObject::SetMoveCompent(MoveCompent* p){
	if (!p){ return; }
	if (m_pMoveCompent != nullptr){
		m_pMoveCompent->OnDetach();
		m_pMoveCompent->release();
	}

    m_pMoveCompent = p;
	m_pMoveCompent->retain();
	m_pMoveCompent->SetOwner(this);
	m_pMoveCompent->OnAttach();
}

void MyObject::SetTarget(int i){ m_nTargetId = i; }

int MyObject::GetTarget(){
	return m_nTargetId;
}

cocos2d::Vector<MyObject*> MyObject::ExecuteEffects(MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating){
	for (auto v : list){
		if (v->GetId() == GetId()){
			return list;
		}
	}
		
	if (GetState() < EOS_DEAD){
		list.pushBack(this);

		for (auto v : m_pEffectList){
			if (v->GetEffectType() == ETP_KILL){
				int a = 1;
			}
			v->Execute(this, pTarget, list, bPretreating);
		}
	}

	return list;
}

Fish::Fish() 
	: MyObject()
	, m_nRedTime(0)
	, m_fMaxRadio(0.0f)
	, m_nGoldMul(0)
{
	m_nType = EOT_FISH;
}

Fish::~Fish(){}

void Fish::SetBoundingBox(int id){
	m_nBoundingBoxId = id;

	auto boxId = GetBoundingBox();
	auto* pathData = FishObjectManager::GetInstance()->GetPathManager()->GetBoundingBoxData(boxId);
	if (pathData != nullptr){
		for (auto v : pathData->value){
			m_fMaxRadio = fmax(m_fMaxRadio, fabs(v.offsetX) + v.rad);
			m_fMaxRadio = fmax(m_fMaxRadio, fabs(v.offsetY) + v.rad);
		}
	}
}

int Fish::GetBoundingBox(){
	return m_nBoundingBoxId;
}

bool Fish::OnUpdate(float fdt, bool shouldUpdate){
	// 更新被攻击效果;
	if (m_nRedTime > 0){
		m_nRedTime--;
		if (m_nRedTime == 0){
			for (auto& v : m_pVisualNodeList){
				if (v.target) v.target->setColor(cocos2d::Color3B(0xFF, 0xFF, 0xFF));
			}
		}
	}
			
	if (!shouldUpdate && m_nState == EOS_DEAD){
		SetState(EOS_DESTORY);
	}
	return MyObject::OnUpdate(fdt, shouldUpdate);
}

void Fish::OnHit(){
	for (auto& v : m_pVisualNodeList){
		if (v.target) v.target->setColor(cocos2d::Color3B(0xFF, 0x11, 0));
	}
			
	m_nRedTime = 5;
}

Bullet::Bullet() 
	: MyObject()
	, m_nCatchRadio(30)
	, m_hitTime(0.0f)
{
	m_nType = EOT_BULLET;
}
	
Bullet::~Bullet(){}

void Bullet::SetCannonSetType(int n){
	m_nCannonSetType = n;
}

int	Bullet::GetCannonSetType(){ return m_nCannonSetType; }

void Bullet::SetCannonType(int n){
	m_nCannonType = n;
}

int	Bullet::GetCannonType(){ return m_nCannonType; }

void Bullet::SetCatchRadio(int n){ m_nCatchRadio = n; }

int	Bullet::GetCatchRadio(){ return m_nCatchRadio; }

void Bullet::SetState(int st){
	MyObject::SetState(st);

	if (st == EOS_HIT){
		m_hitTime = 0.5f;
	}
}

bool Bullet::OnUpdate(float fdt, bool shouldUpdate){
	// 更新被攻击效果;
	if (m_hitTime > 0){
		m_hitTime -= fdt;
		if (m_hitTime <= 0){
			SetState(EOS_DEAD);
		}
	}
	if (!shouldUpdate && m_nState == EOS_DEAD){
		SetState(EOS_DESTORY);
	}
	return MyObject::OnUpdate(fdt, shouldUpdate);
}
NS_FISHGAME2D_END
