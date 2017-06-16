#include "MyObject.h"
#include "common.h"
#include "MoveCompent.h"
//#include "MyScene.h"
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
	, m_bMarkEffectDone(false)

	, m_pContent(nullptr)
	, m_pShadow(nullptr)
	, m_pDebug(nullptr)
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
}

void MyObject::Clear(bool bForce){
	if (bForce) {
		if (m_pContent) m_pContent->removeFromParentAndCleanup(true);
		if (m_pShadow) m_pShadow->removeFromParentAndCleanup(true);
		if (m_pDebug) m_pDebug->removeFromParentAndCleanup(true);

		m_pContent = nullptr;
		m_pShadow = nullptr;
		m_pDebug = nullptr;
	}
	else {
		if (m_pContent) m_pContent->runAction(cocos2d::Sequence::createWithTwoActions(
			cocos2d::DelayTime::create(m_nType == EOT_FISH ? 3 : 1), cocos2d::CallFuncN::create([](cocos2d::Node* sender) {
			sender->removeFromParentAndCleanup(true);
		})));
		if (m_pShadow) m_pShadow->runAction(cocos2d::Sequence::createWithTwoActions(
			cocos2d::DelayTime::create(m_nType == EOT_FISH ? 3 : 1), cocos2d::CallFuncN::create([](cocos2d::Node* sender) {
			sender->removeFromParentAndCleanup(true);
		})));
		if (m_pDebug)m_pDebug->runAction(cocos2d::Sequence::createWithTwoActions(
			cocos2d::DelayTime::create(m_nType == EOT_FISH ? 3 : 1), cocos2d::CallFuncN::create([](cocos2d::Node* sender) {
			sender->removeFromParentAndCleanup(true);
		})));

		m_pContent = nullptr;
		m_pShadow = nullptr;
		m_pDebug = nullptr;
	}

	OnClear(bForce);
}

void MyObject::OnClear(bool){ }

bool MyObject::onUpdate(float dt, bool shouldUpdate){
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
		&& m_bInScreen 
		&& m_bDirtyState ){
		m_bDirtyState = false;


		this->removeAllChildren();
#if CC_ENABLE_SCRIPT_BINDING
		cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
		_stack->pushInt(m_nState);

		int ret = _stack->executeFunctionByHandler(m_handler_statusChanged, 1);
		_stack->clean();
#endif	


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
	setState(EOS_DESTORED);
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
		self:executeEffects(nullptr, vector, false);
	}

	m_nState = st;
	m_bDirtyState = true;

	if (st == EOS_DESTORED) {
#if CC_ENABLE_SCRIPT_BINDING
		cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
		_stack->pushInt(m_nState);

		int ret = _stack->executeFunctionByHandler(m_handler_statusChanged, 1);
		_stack->clean();
#endif	
	}
}

void MyObject::addBuff(int buffType, float buffParam, float buffTime){
	auto* pBuff = Buff::create(buffType, buffParam, buffTime);
	if (pBuff != nullptr)
	{
		pBuff->retain();
		m_pBuffList.push_back(pBuff);
	}
}

void MyObject::addEffect(Effect* effect){
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
	m_pMoveCompent->setOwner(this);
	m_pMoveCompent->OnAttach();
}

void MyObject::SetTarget(int i){ m_nTargetId = i; }

int MyObject::GetTarget(){
	return m_nTargetId;
}

cocos2d::Vector<MyObject*> MyObject::executeEffects(MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating){
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
			if (v->getEffectType() == ETP_KILL){
				int a = 1;
			}
			v->execute(this, pTarget, list, bPretreating);
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

void MyObject::setPosition(float x, float y) { 
	if (m_pPosition.x == x && m_pPosition.y == y) {
		return;
	}

	// 检测是否在屏幕内;
	if (x < -100 || y < -100 || x > 1540 || y > 1000) {
		if (m_bInScreen) {
			OnMoveEnd();
		}
		m_bInScreen = false;
	}
	else {
		m_bInScreen = true;
	}

	m_pPosition.x = x; m_pPosition.y = y;

	if (m_pDebug) m_pDebug->setPosition(x, y);
	if (m_pContent) m_pContent->setPosition(x, y);
	if (m_pShadow) m_pShadow->setPosition(x, y - 35);
}

cocos2d::Vec2 MyObject::getPosition() { return m_pPosition; }

void MyObject::setRotation(float f) { 
	m_fDirection = f; 

	FishObjectManager::GetInstance()->ConvertDirection(&f);

	if (m_pDebug) m_pDebug->setRotation(f);
	if (m_pContent) m_pContent->setRotation(f);
	if (m_pShadow) m_pShadow->setRotation(f);
}

float MyObject::getRotation() { return m_fDirection; }

void MyObject::removeAllChildren() {
	if (m_pContent != nullptr) m_pContent->removeFromParent();
	if (m_pShadow != nullptr) m_pShadow->removeFromParent();
	if (m_pDebug != nullptr) m_pDebug->removeFromParent();

	m_pContent = nullptr;
	m_pShadow = nullptr;
	m_pDebug = nullptr;
}

void  MyObject::setVisualContent(cocos2d::Node* node) {
	if (m_pContent != nullptr) m_pContent->removeFromParent();
	m_pContent = node;

	if (m_pContent) {
		m_pContent->setPosition(m_pPosition);
		m_pContent->setRotation(m_fDirection);
	}
}

void  MyObject::setVisualShadow(cocos2d::Node* node) {
	if (m_pShadow != nullptr) m_pShadow->removeFromParent();
	m_pShadow = node;

	if (m_pShadow) {
		m_pShadow->setPosition(m_pPosition.x, m_pPosition.y - 35);
		m_pShadow->setRotation(m_fDirection);
	}	
}

void  MyObject::setVisualDebug(cocos2d::Node* node) {
	if (m_pDebug != nullptr) m_pDebug->removeFromParent();
	m_pDebug = node;

	if (m_pDebug) {
		m_pDebug->setPosition(m_pPosition);
		m_pDebug->setRotation(m_fDirection);
	}
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

void Fish::addBoundingBox(float radio, float x, float y) {
	boundingBox.push_back(BoundingBox(radio,x,y));

	m_fMaxRadio = fmax(m_fMaxRadio, fabs(x) + radio);
	m_fMaxRadio = fmax(m_fMaxRadio, fabs(y) + radio);
}

void Fish::setState(int st) {
	MyObject::setState(st);
}

bool Fish::OnUpdate(float fdt, bool shouldUpdate){
	if (!shouldUpdate && m_nState == EOS_DEAD){
		setState(EOS_DESTORED);
	}
	return MyObject::onUpdate(fdt, shouldUpdate);
}

Bullet::Bullet() 
	: MyObject()
	, m_nCatchRadio(30)
	, m_hitTime(0.0f)
{
	m_nType = EOT_BULLET;
}
	
Bullet::~Bullet(){}

void Bullet::setCannonSetType(int n){
	m_nCannonSetType = n;
}

int	Bullet::getCannonSetType(){ return m_nCannonSetType; }

void Bullet::setCannonType(int n){
	m_nCannonType = n;
}

int	Bullet::getCannonType(){ return m_nCannonType; }

void Bullet::setCatchRadio(int n){ m_nCatchRadio = n; }

int	Bullet::getCatchRadio(){ return m_nCatchRadio; }

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
		setState(EOS_DESTORED);
	}
	return MyObject::onUpdate(fdt, shouldUpdate);
}
NS_FISHGAME2D_END
