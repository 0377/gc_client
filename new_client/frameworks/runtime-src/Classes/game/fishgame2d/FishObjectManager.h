#pragma once
#ifndef __FishObjectManager_h__
#define __FishObjectManager_h__


#include "cocos2d.h"
#include "cocos-ext.h"
#include "./common.h"

NS_FISHGAME2D_BEGIN

class MyObject;
class Bullet;
class Fish;
class Effect;
class PathManager;

class FishObjectManager : public cocos2d::Ref
{
private:
	FishObjectManager();

	static FishObjectManager* m_Instance;
public:
	~FishObjectManager();

	static FishObjectManager* GetInstance(){
		if (m_Instance == nullptr){
			m_Instance = new (std::nothrow) FishObjectManager();
			if (m_Instance){
				m_Instance->autorelease();
				m_Instance->retain();
			}
			else{
				CC_SAFE_DELETE(m_Instance);
			}
		}
		return m_Instance;
	}

	static void DestroyInstance(){
		if (m_Instance){
			m_Instance->release();
			m_Instance = nullptr;
		}
	}

	static void DestoryInstace(){
		if (m_Instance != NULL){
			m_Instance->release();
			m_Instance = NULL;
		}
	}

	void Init(int, int,std::string);
	void Clear();
	bool AddBullet(Bullet* pBullet);
	Bullet* FindBullet(unsigned long  id);
	bool RemoveAllBullets(bool);
	bool AddFish(Fish* pFish);
	Fish* FindFish(unsigned long);

	cocos2d::Vector<Fish* > GetAllFishes();

	bool RemoveAllFishes(bool);
	bool OnUpdate(float dt);

	void RegisterBulletHitFishHandler(int);
	void RegisterEffectHandler(int);


	void AddFishBuff(int buffType, float buffParam, float buffTime);

		
	bool MirrowShow();
	void SetMirrowShow(bool);

	void ConvertMirrorCoord(float*, float*);

	void ConvertCoord(float*, float*);
	void ConvertDirection(float*);

	void SetGameLoaded(bool b){ m_bLoaded = b; }
	bool IsGameLoaded(){ return m_bLoaded; }


	void	SetSwitchingScene(bool b){ m_bSwitchingScene = b; }
	bool	IsSwitchingScene(){ return m_bSwitchingScene; }


	int		GetClientWidth(){ return m_nClientWidth; }
	int		GetClientHeight(){ return m_nClientHeight; }

	cocos2d::Map< unsigned long, Fish*>::iterator BeginFish(){ return m_MapFish.begin(); }

	cocos2d::Map< unsigned long, Fish*>::iterator EndFish(){ return m_MapFish.end(); }


	int		TestHitFish(float x, float y);
private:
	bool BBulletHitFish(Bullet* pBullet,Fish* pFish);
	void onActionBulletHitFish(Bullet* pBullet, Fish* pFish);

public:
	void OnActionEffect(MyObject* pSelf, MyObject* pTarget, Effect* pEffect);

	PathManager* GetPathManager() { return m_pPathManager; }
private:
	int m_nClientWidth;
	int m_nClientHeight; 

	int		m_nHandlerBulletHitFish; 
	int		m_nHandlerEffect;

	cocos2d::Map< unsigned long, Bullet*>	m_MapBullet;
	cocos2d::Map< unsigned long, Fish*>		m_MapFish;


	std::mutex m_lock;
	//std::mutex m_lock;

	bool m_bMorrow;
	bool m_bLoaded;
	bool m_bSwitchingScene;

	PathManager* m_pPathManager;
};

NS_FISHGAME2D_END

#endif // __FishObjectManager_h__