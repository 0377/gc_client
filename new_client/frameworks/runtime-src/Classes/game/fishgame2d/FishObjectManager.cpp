#include "FishObjectManager.h"
#include "PathManager.h"
#include "MyObject.h"
#include "Effect.h"

NS_FISHGAME2D_BEGIN
FishObjectManager* FishObjectManager::m_Instance = nullptr;

FishObjectManager::FishObjectManager()
	: m_nHandlerBulletHitFish(0)
	, m_nClientWidth(1280)
	, m_nClientHeight(720)
	, m_bMorrow(false)
	, m_bLoaded(false)
	, m_bSwitchingScene(false)
	, m_pPathManager(nullptr)
{

}


FishObjectManager::~FishObjectManager()
{
	if (m_pPathManager){
		m_pPathManager->release();
		m_pPathManager = nullptr;
	}
}

void FishObjectManager::Init(int a, int b, std::string path){
	m_nClientWidth = a;
	m_nClientHeight = b;

	if (m_pPathManager == nullptr){
		m_pPathManager = PathManager::create();
		m_pPathManager->retain();
	}
}

void FishObjectManager::Clear(){
	if (m_pPathManager){
		m_pPathManager->release();
		m_pPathManager = nullptr;
	}
}

bool FishObjectManager::AddBullet(Bullet* pBullet){
	if (pBullet == nullptr)
	{
		return false;
	}

	auto itr = m_MapBullet.find(pBullet->getId());
	if (itr != m_MapBullet.end()){
		return false;
	}

	pBullet->setManager(this);

	m_MapBullet.insert(pBullet->getId(), pBullet);

	return true;
}

Bullet* FishObjectManager::FindBullet(unsigned long  id){
	auto itr = m_MapBullet.find(id);
	if (itr == m_MapBullet.end()){
		return nullptr;
	}
	return itr->second;
}

bool FishObjectManager::RemoveAllBullets(){
	for (auto& v : m_MapBullet){
		v.second->Clear(true);
	}
	m_MapBullet.clear();
	return true;
}

bool FishObjectManager::AddFish(Fish* pFish){
	if (pFish == nullptr)
	{
		return false;
	}
	auto itr = m_MapFish.find(pFish->getId());
	if (itr != m_MapFish.end()){
		return false;
	}

	pFish->setManager(this);

	m_MapFish.insert(pFish->getId(),pFish);
	return true;
}

Fish* FishObjectManager::FindFish(unsigned long id){
	auto itr = m_MapFish.find(id);
	if (itr == m_MapFish.end()){
		return nullptr;
	}
	return itr->second;
}
	
cocos2d::Vector< Fish*> FishObjectManager::GetAllFishes(){
	cocos2d::Vector< Fish*> ret;
	for (auto a : m_MapFish){
		ret.pushBack( a.second);
	}
	return ret;
}

bool FishObjectManager::RemoveAllFishes(){
	for (auto v : m_MapFish) {
		v.second->Clear(true);
		v.second->setState(EOS_DESTORED);
	}
	m_MapFish.clear();
	return true;
}

bool FishObjectManager::OnUpdate(float dt){
	int X_COUNT = 10;
	int Y_COUNT = 4;
	int X_INTERVAL = m_nClientWidth / X_COUNT;
	int Y_INTERVAL = m_nClientHeight / Y_COUNT;

	std::vector<Fish* > temp[4][10];

	int state;
	int fishCount = 0;
	int bulletCount = 0;

	auto i = m_MapFish.begin();
	while (i != m_MapFish.end()){
		if (i->second->OnUpdate(dt, fishCount <= 10)){
			fishCount++;
		}
		state = i->second->getState();

		// 剔除活的;
		if (state < EOS_DEAD){
			// 根据位置，插入指定范围内;
			cocos2d::Vec2 pos = i->second->getPosition();
				
			float maxRadio = i->second->getMaxRadio();
			for (int __x = (pos.x - maxRadio) / X_INTERVAL; __x <= (pos.x + maxRadio) / X_INTERVAL; __x++){
				for (int __y = (pos.y - maxRadio) / Y_INTERVAL; __y <= (pos.y + maxRadio) / Y_INTERVAL; __y++){
					if (__y >= 0 && __y < Y_COUNT && __x >= 0 && __x < X_COUNT){
						temp[__y][__x].push_back(i->second);
					}
				}
			}
		}
		// 删除死的;
		if (state == EOS_DEAD){
			i->second->Clear(false);
			i->second->setState(EOS_DESTORED);
			i = m_MapFish.erase(i);
		}
		else if (state > EOS_DEAD){
			i->second->Clear(true);
			i->second->setState(EOS_DESTORED);
			i = m_MapFish.erase(i);

		}
		else{
			i++;
		}
	}

	// 处理鱼;

	auto itrBullet = m_MapBullet.begin();
	while (itrBullet != m_MapBullet.end()){
		if (itrBullet->second->OnUpdate(dt, bulletCount <= 10)){
			bulletCount++;
		}

		state = itrBullet->second->getState();

		// 进行鱼和子弹的碰撞检测;

		if (!m_bSwitchingScene && state < EOS_DEAD){
			if (itrBullet->second->GetTarget() == 0){
				auto pos = itrBullet->second->getPosition();
				//int yInterval = pos.y / Y_INTERVAL;
				//int xInterval = pos.x / X_INTERVAL;

				/*if (yInterval >= 0 && yInterval < Y_COUNT && xInterval >= 0 && xInterval < X_COUNT){
					for (auto fish : temp[yInterval][xInterval]){
					if (BBulletHitFish(itrBullet->second, fish)){
					onActionBulletHitFish(itrBullet->second, fish);
					break;
					}
					}
					}*/

				bool catched = false;
				float maxRadio = itrBullet->second->getCatchRadio();
				for (int __x = (pos.x - maxRadio) / X_INTERVAL; __x <= (pos.x + maxRadio) / X_INTERVAL; __x++){
					for (int __y = (pos.y - maxRadio) / Y_INTERVAL; __y <= (pos.y + maxRadio) / Y_INTERVAL; __y++){
						if (__y >= 0 && __y < Y_COUNT && __x >= 0 && __x < X_COUNT){
							for (auto fish : temp[__y][__x]){
								if (BBulletHitFish(itrBullet->second, fish)){
									onActionBulletHitFish(itrBullet->second, fish);
									catched = true;
									break;
								}
							}
						}
						if (catched) break;
					}
					if (catched) break;
				}


				/*for (auto fish : m_MapFish){
					if (BBulletHitFish(itrBullet->second, fish.second)){
						onActionBulletHitFish(itrBullet->second, fish.second);
						break;
					}
				}*/
			}
			else{
				auto itr = m_MapFish.find(itrBullet->second->GetTarget());
				if (m_MapFish.end() == itr){
					itrBullet->second->SetTarget(0);
				}
				else{

					if (BBulletHitFish(itrBullet->second, itr->second)){
						onActionBulletHitFish(itrBullet->second, itr->second);
					}
				}	
			}
		}

		// 删除死的;
		if (state == EOS_DEAD){
			itrBullet->second->Clear(false);
			itrBullet->second->setState(EOS_DESTORED);
			itrBullet = m_MapBullet.erase(itrBullet);
		}
		else if (state > EOS_DEAD){
			itrBullet->second->Clear(true);
			itrBullet->second->setState(EOS_DESTORED);
			itrBullet = m_MapBullet.erase(itrBullet);

		}
		else{
			itrBullet++;
		}
	}
	return true;
}

void FishObjectManager::RegisterEffectHandler(int handler){
#if CC_ENABLE_SCRIPT_BINDING
	m_nHandlerEffect = handler;
#endif
}
	
void FishObjectManager::RegisterBulletHitFishHandler(int handler){
#if CC_ENABLE_SCRIPT_BINDING
	m_nHandlerBulletHitFish = handler;
#endif
}

void FishObjectManager::AddFishBuff(int buffType, float buffParam, float buffTime){
	for (auto& fish : m_MapFish){
		fish.second->addBuff(buffType, buffParam, buffTime);
	}
}

bool FishObjectManager::MirrowShow(){
	return m_bMorrow;
}
void FishObjectManager::SetMirrowShow(bool b){
	m_bMorrow = b;
}

void FishObjectManager::ConvertMirrorCoord(float* x, float* y){
	*x = m_nClientWidth - *x;
	*y = m_nClientHeight - *y;
}

void FishObjectManager::ConvertCoord(float* x, float * y){
	if (MirrowShow()){
		ConvertMirrorCoord(x, y);
	}
}

void FishObjectManager::ConvertDirection(float* dir){
	if (MirrowShow()){
		*dir += M_PI;
	}
}

bool FishObjectManager::BBulletHitFish(Bullet* pBullet, Fish* pFish){
	int bulletRad = pBullet->getCatchRadio();
	int maxFishRadio = pFish->getMaxRadio();
	cocos2d::Point posBullet = pBullet->getPosition();
	cocos2d::Point posFish = pFish->getPosition();

	if ((posBullet.x + bulletRad < posFish.x - maxFishRadio && posBullet.y + bulletRad < posFish.y - maxFishRadio)
		|| (posBullet.x - bulletRad > posFish.x + maxFishRadio && posBullet.y - bulletRad > posFish.y + maxFishRadio)){
		return false;
	}
	float dirFish = pFish->getRotation();
	float sinDir = sinf(dirFish);
	float cosDir = cosf(dirFish);

	auto&  pathData = pFish->getBoundingBox();
	for (auto& v : pathData){
		float x = v.offsetX * cosDir - v.offsetY * sinDir + posFish.x;
		float y = v.offsetX * sinDir + v.offsetY * cosDir + posFish.y;

		float rad = v.rad;

		float _x = x - posBullet.x;
		float _y = y - posBullet.y;
		float _dis = (rad + bulletRad);
		if (_x * _x + _y * _y <= _dis * _dis){
			return true;
		}				
	}


	return false;
}

void FishObjectManager::onActionBulletHitFish(Bullet* pBullet, Fish* pFish){
	//TODO  发送消息到Lua层;
#if CC_ENABLE_SCRIPT_BINDING
	cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
	_stack->pushObject(pBullet, "fishgame.Bullet");
	_stack->pushObject(pFish, "fishgame.Fish");

	int ret = _stack->executeFunctionByHandler(m_nHandlerBulletHitFish, 2);
	_stack->clean();
#endif
}



void swap(float *a, float *b, Fish** c, Fish** d)
{
	float tmp = *a;
	*a = *b;
	*b = tmp;

	Fish* _temp = *c;
	*c = *d;
	*d = _temp;
}

int partition(float a[], Fish* fish[], int low, int high)
{
	int privotKey = a[low];                             //基准元素  
	while (low < high){                                   //从表的两端交替地向中间扫描  
		while (low < high  && a[high] >= privotKey) --high;  //从high 所指位置向前搜索，至多到low+1 位置。将比基准元素小的交换到低端  
		swap(&a[low], &a[high],&fish[low],&fish[high]);
		while (low < high  && a[low] <= privotKey) ++low;
		swap(&a[low], &a[high], &fish[low], &fish[high]);
	}
	return low;
}


void quickSort(float a[], Fish* fish[], int low, int high){
	if (low < high){
		int privotLoc = partition(a, fish, low, high);  //将表一分为二  
		quickSort(a, fish,low, privotLoc - 1);          //递归对低子表递归排序  
		quickSort(a, fish,privotLoc + 1, high);        //递归对高子表递归排序  
	}
}

void FishObjectManager::OnActionEffect(MyObject* pSelf, MyObject* pTarget,Effect* pEffect){
#if CC_ENABLE_SCRIPT_BINDING
	cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
	_stack->pushObject(pSelf, "fishgame.MyObject");
	_stack->pushObject(pTarget, "fishgame.MyObject");
	_stack->pushObject(pEffect, "fishgame.Effect");

	int ret = _stack->executeFunctionByHandler(m_nHandlerEffect, 3);
	_stack->clean();
#endif
}
	
int	FishObjectManager::TestHitFish(float _x_, float _y_){
	float _x, _y;
	_x = _x_;
	_y = _y_;
	FishObjectManager::GetInstance()->ConvertCoord(&_x, &_y);

	static float tempDis[1024];
	static Fish* tempFish[1024];
	static int length;

	length = 0;

	auto i = m_MapFish.begin();
	while (i != m_MapFish.end()){
		auto* pFish = i->second;

		if (pFish->getLockLevel() <= 0) {
			i++;
			continue;
		}

		int maxFishRadio = pFish->getMaxRadio();
		cocos2d::Point posFish = pFish->getGamePos();

		float dirFish = pFish->getGameDir();
		float sinDir = sinf(dirFish);
		float cosDir = cosf(dirFish);

		float minDis = 0xFFFFFFFF;

		auto pathData = pFish->getBoundingBox();
		for (auto& v : pathData){
			float x = v.offsetX * cosDir - v.offsetY * sinDir + posFish.x;
			float y = v.offsetX * sinDir + v.offsetY * cosDir + posFish.y;
			float __x = x - _x;
			float __y = y - _y;
			float _dis = sqrtf(__x * __x + __y * __y) - v.rad - 30;
			minDis = MIN(_dis, minDis);
		}

		if (minDis < 0){
			tempDis[length] = minDis;
			tempFish[length] = i->second;
			length++;
		}

		i++;
	}
	
	int  nMaxLockLevel = 0;
	int index = -1;
	for (int i = 0; i < length; i++){
		if (tempFish[i]->getLockLevel() > nMaxLockLevel){
			nMaxLockLevel = tempFish[i]->getLockLevel();
			index = i;
		}

	}
	if (index != -1){
		return tempFish[index]->getId();
	}

	return -1;
}
NS_FISHGAME2D_END
