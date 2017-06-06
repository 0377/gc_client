#include "MyObject.h"
#include "common.h"
#include "MoveCompent.h"
//#include "MyScene.h"
#include "PathManager.h"
#include "Buff.h"
#include "Effect.h"

NS_FISHGAME2D_BEGIN

MyObject::MyObject() 
	: cocos2d::Node()
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
	, m_bMarkEffectDone(false)
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


			
		m_bDirtyPos = true;
		m_bDirtyDir = true;
		m_bDirtyInScreen = true;
	}
	else{
		ret = false;
	}
	

	return ret;
}

void MyObject::OnMoveEnd(){
	setState(EOS_DESTORY);
}

void MyObject::setState(int st){
	if (st == m_nState) {
		return;
	}

	if ((st == EOS_LIVE || st == EOS_HIT)
		&& (m_nState == EOS_LIVE || m_nState == EOS_HIT)){
		return;
	}

	if (st == EOS_DEAD)
	{
		cocos2d::Vector<MyObject*> vector;
		self:ExecuteEffects(nullptr, vector, false);
	}

	m_nState = st;
	m_bDirtyState = true;
	
#if CC_ENABLE_SCRIPT_BINDING
	cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
	_stack->pushInt(m_nState);

	int ret = _stack->executeFunctionByHandler(m_handler_statusChanged, 1);
	_stack->clean();
#endif

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

void MyObject::setMoveCompent(MoveCompent* p){
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
	if (m_bMarkEffectDone) return list;
	m_bMarkEffectDone = true;

	for (auto v : list){
		if (v->getId() == getId()){
			return list;
		}
	}
		
	if (getState() < EOS_DEAD){
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

void  MyObject::registerStatusChangedHandler(int handler) {
#if CC_ENABLE_SCRIPT_BINDING
	m_handler_statusChanged = handler;
#endif
}

void MyObject::setGamePos(float x, float y) {
	this->position.x = x;
	this->position.y = y;

	FishObjectManager::GetInstance()->ConvertCoord(&x, &y);

	this->setPosition(x, y);
}

void MyObject::setGameDir(float rotation) {
	this->rotation = rotation;


	FishObjectManager::GetInstance()->ConvertDirection(&rotation);
	this->setRotation(CC_RADIANS_TO_DEGREES(rotation));
}

const cocos2d::Vec2& MyObject::getGamePos() const {
	return this->position;
}
float MyObject::getGameDir() const {
	return this->rotation;
}

Fish::Fish() 
	: MyObject()
	, m_nRedTime(0)
	, m_fMaxRadio(0.0f)
	, m_nGoldMul(0)
	, m_content(nullptr)
	, m_shadow(nullptr)
	, m_debug(nullptr)
	, rotation(0)
	, position(0,0)
{
	m_nType = EOT_FISH;
}

Fish::~Fish(){}

void Fish::setPosition(float x, float y) {
	this->position.x = x;
	this->position.y = y;


	if (m_debug) m_debug->setPosition(x, y);
	if (m_content) m_content->setPosition(x, y);
	if (m_shadow) m_shadow->setPosition(x, y - 35);
}

void Fish::setRotation(float rotation) {
	this->rotation = rotation;

	FishObjectManager::GetInstance()->ConvertDirection(&rotation);

	if (m_debug) m_debug->setRotation(rotation);
	if (m_content) m_content->setRotation(rotation);
	if (m_shadow) m_shadow->setRotation(rotation);

}

const cocos2d::Vec2& Fish::getPosition() const {
	return this->position;
}

float Fish::getRotation() const {
	return rotation;
}

void Fish::setContentNode(cocos2d::Node* content, cocos2d::Node* shadow) {
	m_content = content;
	m_shadow = shadow;
}
void Fish::setDebugNode(cocos2d::Node* debugNode) {
	m_debug = debugNode;
}

void Fish::addBoundingBox(float radio, float x, float y) {
	boundingBox.push_back(BoundingBox(radio,x,y));

	m_fMaxRadio = fmax(m_fMaxRadio, fabs(x) + radio);
	m_fMaxRadio = fmax(m_fMaxRadio, fabs(y) + radio);
}

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
		setState(EOS_DESTORY);
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

void Bullet::setState(int st){
	MyObject::setState(st);

	if (st == EOS_HIT){
		m_hitTime = 0.5f;
	}
}

bool Bullet::OnUpdate(float fdt, bool shouldUpdate){
	// 更新被攻击效果;
	if (m_hitTime > 0){
		m_hitTime -= fdt;
		if (m_hitTime <= 0){
			setState(EOS_DEAD);
		}
	}
	if (!shouldUpdate && m_nState == EOS_DEAD){
		setState(EOS_DESTORY);
	}
	return MyObject::OnUpdate(fdt, shouldUpdate);
}
NS_FISHGAME2D_END
