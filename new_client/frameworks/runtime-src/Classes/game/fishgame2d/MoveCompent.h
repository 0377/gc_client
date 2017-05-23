#pragma once

#ifndef __MOVE_COMPENT_H__
#define __MOVE_COMPENT_H__

#include "cocos2d.h"
#include "./common.h"
#include "PathManager.h"

NS_FISHGAME2D_BEGIN

enum MoveCompentType
{
	EMCT_PATH,
	EMCT_DIRECTION,
	EMCT_TARGET,
};

class MyObject;
class MoveCompent : public cocos2d::Ref
{
protected:
	MoveCompent();
public:
		
	virtual ~MoveCompent(){}


	void setSpeed(float sp){ m_fSpeed = sp; }
	float getSpeed(){ return m_fSpeed; }

	void setPause(bool bPause = true){ m_bPause = bPause; }
	bool isPaused(){ return m_bPause; }


	void setPathID(int pid, bool bt = false){ m_nPathID = pid; m_bTroop = bt; }
	int getPathID(){ return m_nPathID; }

	bool bTroop(){ return m_bTroop; }
	virtual void InitMove() = 0;

	bool IsEndPath(){ return m_bEndPath; }
	void SetEndPath(bool be){ m_bEndPath = be; }

	const cocos2d::Point& getOffest(){ return m_Offest; }
	void setOffest(cocos2d::Point& pt){ m_Offest = pt; }


	void SetDelay(float f){ m_fDelay = f; }
	float GetDelay(){ return m_fDelay; }

	bool HasBeginMove(){ return m_bBeginMove; }

	bool Rebound(){ return m_bRebound; }
	void SetRebound(bool b){ m_bRebound = b; }

	void SetPosition(float x, float y){ m_pPosition.x = x; m_pPosition.y = y; }
	void SetDirection(float dir){ m_fDirection = dir; }

	virtual void OnDetach();


	void SetOwner(MyObject* owner){ m_pOwner = owner; }
	MyObject* GetOwner(){
		return m_pOwner;
	}

	void OnAttach();
	virtual void OnUpdate(float dt) = 0;


protected:
	cocos2d::Point	m_pPosition;
	float			m_fDirection;

	float		m_fSpeed;
	bool		m_bPause;
	int			m_nPathID;
	bool		m_bEndPath;
	cocos2d::Point		m_Offest;
	float		m_fDelay;
	bool		m_bBeginMove;
	bool		m_bRebound;
	unsigned long		m_dwTargetID;
	bool		m_bTroop;

	MyObject* m_pOwner;
};

class MoveByPath : public MoveCompent
{
protected:
	MoveByPath();
public:
	virtual ~MoveByPath();

	static MoveByPath* create();
	virtual void OnUpdate(float dt);

	void setDuration(int);
	void addPathMoveData(int nType, float fDirection, int nDuration, int nStartTime, int nEndTime,
		int nPointCount, float x1, float x2, float x3, float x4, float y1, float y2, float y3, float y4);



	virtual void InitMove();
	virtual void OnDetach();
protected:
	float				m_Elaspe;
	int					m_fDuration;
	int					m_LastElaspe;

	PathData			m_pPathData;

};

class MoveByDirection : public MoveCompent
{
protected:
	MoveByDirection();
public:
	virtual ~MoveByDirection();

	static MoveByDirection* create();
	virtual void OnUpdate(float dt);

	virtual void InitMove();
	virtual void OnDetach();

protected:
	float	angle_;
	float	dx_;
	float	dy_;

	bool	inited_;
};
NS_FISHGAME2D_END

#endif

