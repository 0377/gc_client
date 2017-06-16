#pragma once

#ifndef _MY_OBJECT_H_
#define _MY_OBJECT_H_

#include <set>
#include <list>
#include <map>
#include <memory>
#include <string.h>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "common.h"

#include "FishObjectManager.h"
#include "PathManager.h"

NS_FISHGAME2D_BEGIN

enum ObjType{
	EOT_NONE = 0,
	EOT_FISH,
	EOT_BULLET,
};

enum ObjState
{
	EOS_INIT = 0,
	EOS_LIVE,
	EOS_HIT,
	EOS_DEAD,
	EOS_DESTORED,
};

enum SpecialFishType
{
	ESFT_NORMAL = 0,
	ESFT_KING,
	ESFT_KINGANDQUAN,
	ESFT_SANYUAN,
	ESFT_SIXI,
	ESFT_MAX,
};

enum ObjAnimationType{
	EOAT_NONE = 0,
	EOAT_FRAME,			// 
	EOAT_SKELETON,		//
};

class MoveCompent;
class Buff;
class Effect;
class MyObjectVisualNode;
struct VisualNode;

class MyObject : public cocos2d::Ref
{
protected:
	MyObject();
public:
	virtual ~MyObject();

public:
	int getObjectType(){ return m_nType; }

	unsigned long getId()const{ return m_nId; };
	void setId(unsigned long newId){ m_nId = newId; };


	int getState(){ return m_nState; }
	virtual void setState(int);
	
	void setTypeId(int typeId) { m_nTypeId = typeId; }
	int getTypeId() { return m_nTypeId; }

	void setManager(FishObjectManager* manager){ m_pManager = manager; }
	FishObjectManager* getManager(){ return m_pManager; }

	virtual void Clear(bool);
	virtual void OnClear(bool);

	virtual bool onUpdate(float fdt,bool shouldUpdate);

	bool InSideScreen(){ 
		return position.x > 10 && position.x < 1430 &&
			position.y > 10 && position.y < 890;
	}
	void OnMoveEnd();
		
		
	void	SetTarget(int i);
	int		GetTarget();

	MoveCompent* getMoveCompent(){ return m_pMoveCompent; }
	void	setMoveCompent(MoveCompent*);
	void	addBuff(int buffType, float buffParam, float buffTime);
	std::vector<Buff*>&	GetBuffs(){ return m_pBuffList; }

	void	addEffect(Effect*);

	cocos2d::Vector<MyObject*> executeEffects(MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);

	void  registerStatusChangedHandler(int);



	virtual void setGamePos(float x, float y);
	virtual void setGameDir(float rotation);

	virtual const cocos2d::Vec2& getGamePos() const;
	virtual float getGameDir() const;


	virtual void setPosition(float x, float y);
	virtual cocos2d::Vec2 getPosition();
	
	virtual void setRotation(float f);
	virtual float getRotation();
protected:
	int m_nType;
	unsigned long m_nId;

	cocos2d::Vec2 m_pPosition;
	float m_fDirection;
	bool m_bInScreen;

	bool m_bDirtyPos;
	bool m_bDirtyDir;
	bool m_bDirtyInScreen;

	int m_nState;

	bool m_bDirtyState;

	int m_nTargetId;

	int m_nTypeId;

	bool m_bMarkEffectDone;

	std::vector<Buff*>		m_pBuffList;
	std::vector<Effect*>		m_pEffectList;

	MyObject* m_pOwner;

	FishObjectManager* m_pManager;
	MoveCompent* m_pMoveCompent;

	int m_handler_statusChanged;



	float rotation;
	cocos2d::Vec2 position;
public:
	virtual void removeAllChildren();

	virtual void  setVisualContent(cocos2d::Node*);
	virtual void  setVisualShadow(cocos2d::Node*);
	virtual void  setVisualDebug(cocos2d::Node*);

	virtual cocos2d::Node* getVisualContent() { return m_pContent; }
	virtual cocos2d::Node* getVisualShadow() { return m_pShadow; }
	virtual cocos2d::Node* getVisualDebug() { return m_pDebug; }
protected:
	cocos2d::Node* m_pContent;
	cocos2d::Node* m_pShadow;
	cocos2d::Node* m_pDebug;
};

class Fish : public MyObject
{
protected:
	Fish();
public:
	virtual ~Fish();


	static Fish* create(){
		Fish * ret = new (std::nothrow) Fish();
		if (ret)
		{
			ret->autorelease(); 
		}
		else
		{
			CC_SAFE_DELETE(ret);
		}
		return ret;
	}

	int getMaxRadio(){ return m_fMaxRadio; }

	int getFishType(){ return m_FishType; }
	void setFishType(int i){ m_FishType = i; }

	int getRefershId(){ return m_nRefershID; }
	void setRefershId(int i){ m_nRefershID = i;  }

	void setGoldMul(int n){ m_nGoldMul = n; }

	int getGoldMul(){ return m_nGoldMul; }

	void setLockLevel(int n){ m_nLockLevel = n; }
	int getLockLevel(){ return m_nLockLevel; }

	void setVisualId(int n) { m_nVisualId = n; }
	int getVisualId() { return m_nVisualId; }

	virtual void	setState(int);
	virtual bool OnUpdate(float fdt, bool shouldUpdate);

	void addBoundingBox(float radio,float x,float y);

	std::list<BoundingBox>& getBoundingBox() { return boundingBox; }
private:
	std::list<BoundingBox> boundingBox;

	int m_nRedTime;

	float m_fMaxRadio;

	int m_FishType;

	int m_nRefershID;

	int m_nGoldMul;
	int m_nLockLevel;

	int m_nVisualId;
};
class Bullet : public MyObject
{
protected:
	Bullet();
public:
	virtual ~Bullet();

	static Bullet* create(){
		Bullet * ret = new (std::nothrow) Bullet();
		if (ret)
		{
			ret->autorelease();
		}
		else
		{
			CC_SAFE_DELETE(ret);
		}
		return ret;
	}
		 
	void	setCannonSetType(int);
	int		getCannonSetType();
	void	setCannonType(int);
	int		getCannonType();
	void	setCatchRadio(int n);
	int		getCatchRadio();

	virtual void	setState(int);
	virtual bool	OnUpdate(float fdt, bool shouldUpdate);
private:
	int m_nCannonSetType;
	int m_nCannonType;
	int m_nCatchRadio;

	float m_hitTime;
};

NS_FISHGAME2D_END

#endif


