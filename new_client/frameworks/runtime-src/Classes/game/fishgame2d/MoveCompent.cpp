#include "MoveCompent.h"
#include <math.h>
#include "FishObjectManager.h"
#include "PathManager.h"
#include "MyObject.h"
#include "FishUtils.h"
#include "Buff.h"

NS_FISHGAME2D_BEGIN

MoveCompent::MoveCompent()
	: cocos2d::Ref()
	, m_pPosition(0,0)
	, m_fDirection(0)
	, m_fSpeed(0)
	, m_bPause(false)
	, m_nPathID(0)
	, m_bEndPath(false)
	, m_Offest(0,0)
	, m_fDelay(0.0f)
	, m_bBeginMove(false)
	, m_bRebound(false)
	, m_dwTargetID(0)
	, m_bTroop(false)
	, m_pOwner(nullptr)

{

}

void MoveCompent::OnDetach(){}

void MoveCompent::OnAttach(){
	InitMove();
}


MoveByPath::MoveByPath() 
	: MoveCompent()
{}

MoveByPath::~MoveByPath(){}

MoveByPath* MoveByPath::create(){
	MoveByPath * ret = new (std::nothrow) MoveByPath();
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

void MoveByPath::InitMove(){
	m_Elaspe = 0;
	m_LastElaspe = -1;
	//m_fDuration = 0;

	//m_pPathData = FishObjectManager::GetInstance()->GetPathManager()->GetPathData(m_nPathID, m_bTroop);
	//m_fDuration = m_pPathData.nDuration;
	m_Elaspe = 0;
	m_LastElaspe = -1;
	m_bEndPath = false;
}

void MoveByPath::setDuration(int duration) {
	m_fDuration = duration;
}
void MoveByPath::addPathMoveData(int nType, float fDirection, int nDuration, int nStartTime, int nEndTime,
	int nPointCount, float x1, float x2, float x3, float x4, float y1, float y2, float y3, float y4) {

	PathMoveData ele;
	ele.nType = nType;
	ele.xPos[0] = x1;
	ele.xPos[1] = x2;
	ele.xPos[2] = x3;
	ele.xPos[3] = x4;
	ele.yPos[0] = y1;
	ele.yPos[1] = y2;
	ele.yPos[2] = y3;
	ele.yPos[3] = y4;
	ele.nPointCount = 1;
	ele.fDirction = fDirection;
	ele.nDuration = nDuration;
	ele.nStartTime = nStartTime;
	ele.nEndTime = nEndTime;

	m_pPathData.path.push_back(ele);
}


void MoveByPath::OnUpdate(float fdt){
	if (m_pOwner == nullptr) return;
	if (m_bEndPath) {
		m_pOwner->OnMoveEnd();
		return;
	}

	// 更新加速BUFF;
	// 直接查询减少次数;
	auto& buffs = m_pOwner->GetBuffs();
	for (auto buff : buffs){
		if (buff->GetType() == EBT_CHANGESPEED){
			fdt *= buff->GetParam();
		}
	}

	// 更新与服务器同步时间;
	if (m_fDelay > 0){
		m_fDelay = m_fDelay - fdt;
		if (m_fDelay >= 0){
			m_pOwner->setGamePos(-500.0f, -500.0f);

			return;
		}
		else{
			fdt = fabs(m_fDelay);
		}
	}

	if (m_bBeginMove == false && m_Elaspe > 0){
		m_bBeginMove = true;
	}
	m_Elaspe += fdt * getSpeed();
	if (m_Elaspe < 0){
		m_pOwner->setGamePos(-500, -500);
		return;
	}

	// 计算整数用于缓存路径;
	int tempElaspe = (int)m_Elaspe;
	// 时间不脏时不更新;
	if (m_LastElaspe == tempElaspe){ return; }
	m_LastElaspe = tempElaspe;

	// 更新是否路径完成;
	if (tempElaspe >= m_fDuration){
		m_bEndPath = true;
	}

	// 读取缓存路径信息;
	// auto itr = m_pPathData->pathData.find(tempElaspe);
	// if (itr != m_pPathData->pathData.end()){
	// 	PathDataElement& ele = itr->second;
	// 	m_pOwner->SetPosition(ele.x + m_Offest.x, ele.y + m_Offest.y);
	// 	m_pOwner->SetDirection(ele.dir);
	// 	return;
	// }

	//计算路径并缓存 ;
	int index = -1;
	for (auto v : m_pPathData.path){
		index++;
		if (tempElaspe >= v.nStartTime && tempElaspe < v.nEndTime){
			break;
		}
	}
	//更新是否路径完成;
	if (tempElaspe > m_fDuration){
		index = m_pPathData.path.size() - 1;
	}

	if (index == -1) return;

	// 更新位置;
	PathMoveData path = m_pPathData.path[index];
	float percent = MIN(1.0f, (float)(tempElaspe - path.nStartTime) / (float)path.nDuration);
	float x(0.0f), y(0.0f), dir(0.0f);

	switch (path.nType)
	{
	case PMT_LINE:
		FishUtils::CacLine(path.xPos, path.yPos, percent, &x, &y, &dir);
		break;
	case PMT_BEZIER:
		FishUtils::CacBesier(path.xPos, path.yPos, path.nPointCount,percent, &x, &y, &dir);
		break;
	case PMT_CIRCLE:
		FishUtils::CalCircle(path.xPos[0], path.yPos[0], path.xPos[1], path.xPos[2], path.yPos[2], path.yPos[1], percent, &x, &y, &dir);
		break;
	case PMT_STAY:
		x = path.xPos[0];
		y =  path.yPos[0];
		dir = path.fDirction;
		break;	
	default:
		break;
	}

	// PathDataElement ele;
	// ele.x = x;
	// ele.y = y;
	// ele.dir = dir;
	// m_pPathData->pathData[tempElaspe] = ele;
		
	m_pOwner->setGamePos(x + m_Offest.x, y + m_Offest.y);;
	m_pOwner->setGameDir(-dir);
}

void MoveByPath::OnDetach(){}

MoveByDirection::MoveByDirection() 
	: MoveCompent()
	, inited_(false)
{
}

MoveByDirection::~MoveByDirection(){}

MoveByDirection* MoveByDirection::create(){
	MoveByDirection * ret = new (std::nothrow) MoveByDirection();
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

void MoveByDirection::InitMove(){

	angle_ = m_fDirection;
	dx_ = cosf(angle_ - M_PI_2);
	dy_ = sinf(angle_ - M_PI_2);
	m_bEndPath = false;

}

void MoveByDirection::OnDetach(){}

void MoveByDirection::OnUpdate(float fdt){
	if (m_pOwner == nullptr) return;

	if (m_bEndPath){
		m_pOwner->OnMoveEnd();
		return;
	}

	if (m_pOwner->GetTarget() != 0 && !FishObjectManager::GetInstance()->IsSwitchingScene())
	{
		MyObject* pObj = FishObjectManager::GetInstance()->FindFish(m_pOwner->GetTarget());
		if (pObj != nullptr && pObj->getState() < EOS_DEAD && pObj->InSideScreen())
		{
			if (inited_){
				if (MathAide::CalcDistance(pObj->getGamePos().x, pObj->getGamePos().y, m_pOwner->getGamePos().x, m_pOwner->getGamePos().y) > 10)
				{
					SetDirection(MathAide::CalcAngle(pObj->getGamePos().x, pObj->getGamePos().y, m_pOwner->getGamePos().x, m_pOwner->getGamePos().y));
					InitMove();
				}
				else
				{
					SetPosition(m_pOwner->getGamePos().x, m_pOwner->getGamePos().y);
					//SetDirection(m_pOwner->);
					return;
				}
			}
			else{
				inited_ = true;
			}
		}
		else
		{
			m_pOwner->SetTarget(0);
		}
	}

	// 更新加速BUFF;
	// 直接查询减少次数;
	auto& buffs = m_pOwner->GetBuffs();
	for (auto buff : buffs){
		if (buff->GetType() == EBT_CHANGESPEED){
			fdt *= buff->GetParam();
		}
	}

	if (m_fDelay > 0)
	{
		m_fDelay -= fdt;

		if (m_fDelay >= 0){
			return;
		}else{
			fdt = fabs(m_fDelay);
		}
	}

	if (m_bBeginMove == false)
	{
		m_bBeginMove = true;
	}


	m_pPosition.x += m_fSpeed* dx_ * fdt;
	m_pPosition.y += m_fSpeed* dy_ * fdt;


	float fWidth = FishObjectManager::GetInstance()->GetClientWidth();
	float fHeigth = FishObjectManager::GetInstance()->GetClientHeight();

	if (Rebound())
	{
		if (m_pPosition.x < 0.0f) { m_pPosition.x = 0 + (0 - m_pPosition.x); dx_ = -dx_; angle_ = -angle_; }
		if (m_pPosition.x > fWidth)  { m_pPosition.x = fWidth - (m_pPosition.x - fWidth); dx_ = -dx_; angle_ = -angle_; }

		if (m_pPosition.y < 0.0f) { m_pPosition.y = 0 + (0 - m_pPosition.y); dy_ = -dy_; angle_ = M_PI - angle_; }
		if (m_pPosition.y > fHeigth)  { m_pPosition.y = fHeigth - (m_pPosition.y - fHeigth); dy_ = -dy_; angle_ = M_PI - angle_; }
	}
	else
	{
		if (m_pPosition.x < 0 || m_pPosition.x > fWidth || m_pPosition.y < 0 || m_pPosition.y > fHeigth)
			m_bEndPath = true;
	}


	m_pOwner->setGameDir(m_pOwner->GetType() == EOT_FISH ? - angle_ + M_PI_2 : - angle_ + M_PI);
	m_pOwner->setGamePos(m_pPosition.x, m_pPosition.y);
}
NS_FISHGAME2D_END