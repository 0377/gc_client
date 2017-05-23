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
	EOS_DESTORY,
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

class MyObject : public cocos2d::Node
{
protected:
	MyObject();
public:
	virtual ~MyObject();

public:
	int GetType(){ return m_nType; }

	unsigned long getId()const{ return m_nId; };
	void setId(unsigned long newId){ m_nId = newId; };


	int getState(){ return m_nState; }
	virtual void setState(int);
	
	void setTypeId(int typeId) { m_nTypeId = typeId; }
	int getTypeId() { return m_nTypeId; }

	void setManager(FishObjectManager* manager){ m_pManager = manager; }
	FishObjectManager* getManager(){ return m_pManager; }

	virtual void Clear(bool, bool noCleanNode = false);
	virtual void OnClear(bool);

	virtual bool OnUpdate(float fdt,bool shouldUpdate);

	bool InSideScreen(){ 
		return m_pPosition.x > 10 && m_pPosition.x < 1430 &&
			m_pPosition.y > 10 && m_pPosition.y < 890;
	}
	void OnMoveEnd();
		
		
	void	SetTarget(int i);
	int		GetTarget();

	MoveCompent* getMoveCompent(){ return m_pMoveCompent; }
	void	setMoveCompent(MoveCompent*);
	void	AddBuff(int buffType, float buffParam, float buffTime);
	std::vector<Buff*>&	GetBuffs(){ return m_pBuffList; }

	void	AddEffect(Effect*);

	cocos2d::Vector<MyObject*> ExecuteEffects(MyObject* pTarget, cocos2d::Vector<MyObject*>& list, bool bPretreating);

	void  registerStatusChangedHandler(int);
protected:
	int m_nType;

	unsigned long m_nId;

	cocos2d::Point m_pPosition;
	float m_fDirection;
	bool m_bInScreen;

	bool m_bDirtyPos;
	bool m_bDirtyDir;
	bool m_bDirtyInScreen;

	int m_nState;

	bool m_bDirtyState;

	int m_nTargetId;

	int m_nTypeId;
		
	std::vector<VisualNode>	m_pVisualNodeList;
	//
	//Buff*					m_pBuffList[8];

	std::vector<Buff*>		m_pBuffList;
	std::vector<Effect*>		m_pEffectList;

	MyObject* m_pOwner;

	FishObjectManager* m_pManager;
	MoveCompent* m_pMoveCompent;

	int m_handler_statusChanged;
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

	void SetBoundingBox(int);
	int GetBoundingBox();

	int GetMaxRadio(){ return m_fMaxRadio; }

	int GetFishType(){ return m_FishType; }
	void SetFishType(int i){ m_FishType = i; }

	int getRefershId(){ return m_nRefershID; }
	void setRefershId(int i){ m_nRefershID = i;  }

	void SetGoldMul(int n){ m_nGoldMul = n; }

	int GetGoldMul(){ return m_nGoldMul; }

	void SetLockLevel(int n){ m_nLockLevel = n; }
	int getLockLevel(){ return m_nLockLevel; }

	virtual void setPosition(float x, float y);
	virtual void setRotation(float rotation);

	virtual const cocos2d::Vec2& getPosition() const;
	virtual float getRotation() const;

	virtual bool OnUpdate(float fdt, bool shouldUpdate);
	virtual void OnHit();

	void setContentNode(cocos2d::Node*, cocos2d::Node*);
	void setDebugNode(cocos2d::Node*);

	void addBoundingBox(float radio,float x,float y);

	std::list<BoundingBox>& getBoundingBox() { return boundingBox; }
private:
	cocos2d::Node* m_content;
	cocos2d::Node* m_shadow;
	cocos2d::Node* m_debug;
	std::list<BoundingBox> boundingBox;

	int m_nVisualId;
	int m_nBoundingBoxId;

	int m_nRedTime;

	float m_fMaxRadio;

	int m_FishType;

	int m_nRefershID;

	int m_nGoldMul;
	int m_nLockLevel;

	float rotation;
	cocos2d::Vec2 position;

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
		 
	void	SetCannonSetType(int);
	int		GetCannonSetType();
	void	SetCannonType(int);
	int		GetCannonType();
	void	SetCatchRadio(int n);
	int		GetCatchRadio();

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


