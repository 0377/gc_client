#pragma once

#ifndef __PATH_MANAGER_H__
#define __PATH_MANAGER_H__

#include "common.h"
#include "cocos2d.h"

#include "MovePoint.h"
#include <vector>
#include <list>
#include <map>
#include <math.h>

#include "MathAide.h"
#include "BezierCurve.h"

#define  PTCOUNT   4

#define SMALL_PATH		1
#define BIG_PATH		2
#define HUGE_PATH		4


NS_FISHGAME2D_BEGIN

enum PathMoveType
{
	PMT_LINE = 0,
	PMT_BEZIER,
	PMT_CIRCLE,
	PMT_STAY,
};

struct PathMoveData
{
	int			nType;
	float		xPos[4];
	float		yPos[4];
	int			nPointCount;
	float		fDirction;
	int			nDuration;
	int			nStartTime;
	int			nEndTime;
};



enum NormalPathType
{
	NPT_LINE = 0,
	NPT_BEZIER,
	NPT_CIRCLE,
};


struct TroopPathElement
{
	int				nId;
	int				nType;
	int				nPointCount;
	float			xPos[4];
	float			yPos[4];
	int				nNext;
	int				nDelay;
};

struct PathDataElement
{
	float		x;
	float		y;
	float		dir;
	float		dirDeg;
};

struct PathData
{
	int			nDuration;
	std::vector<PathMoveData>		path;
	std::map<int, PathDataElement>  pathData;
};

struct VisualImage
{
	std::string			Image;
	std::string			Name;
	float				Scale;
	float				OffestX;
	float				OffestY;
	float				Direction;
	int					AniType;
	bool				HideShadow;
};

struct VisualData
{
	int		nID;
	int		nTypeID;
	int		nZOrder;
	std::list<VisualImage>	ImageInfoLive;
	std::list<VisualImage>	ImageInfoDie;
};

enum VisualAniType{
	VAT_FRAME = 0,
	VAT_SKELETON,

};

struct BoundingBox
{
	float offsetX;
	float offsetY;
	float rad;

	BoundingBox(){}

	BoundingBox(float radio, float x, float y) {
		this->rad = radio;
		this->offsetX = x;
		this->offsetY = y;
	}
};

struct BoundingBoxData
{
	int		nId;
	std::list<BoundingBox> value;
};

struct CannonGun
{
	std::string		resName;
	std::string		Name;
	int				ResType;
	float			PosX;
	float			PosY;
	float			FireOffest;
	int				type;
};

struct CannonBullet
{
	std::string		resName;
	std::string		Name;
	int				ResType;
};
struct CannonNet
{
	std::string		resName;
	std::string		Name;
	int				ResType;
	float			PosX;
	float			PosY;
	float			FireOffest;
	int				type;
};

struct Cannon
{
	int				type;
	CannonGun		gun;
	CannonBullet	bullet;
	CannonNet		net;
};

struct CannonSet
{
	int			id;
	int			nromal;
	int			ion;
	int			dou;

	std::map<int, Cannon> cannons;
};

class PathManager : public cocos2d::Ref
{
protected:
	PathManager();
public:

	static PathManager* create(){
		PathManager* m_Instance = new (std::nothrow) PathManager();
		if (m_Instance){
			m_Instance->autorelease();
		}
		else{
			CC_SAFE_DELETE(m_Instance);
		}
		return m_Instance;
	}

	virtual ~PathManager();

	void	LoadData(std::string path, int load_callback);
	void	Clear();

	PathData		CreatePathData(std::vector<TroopPathElement> pPath);
	PathData*		GetPathData(int id, bool bTroop);

	VisualData*		GetVisualData(int);
	BoundingBoxData* GetBoundingBoxData(int);
	Cannon*			GetCannonData(int, int);
private:
	bool LoadNormalPath(std::string szFileName);
	bool LoadTroop(std::string szFileName);
	bool LoadVisual(std::string szFileName);
	bool LoadBoundingBox(std::string szFileName);
	bool LoadCannonSet(std::string szFileName);

	void ConvertPathPoint(TroopPathElement sp, bool xMirror, bool yMirror, bool xyMirror, bool Not, float(*outX)[4], float(*outY)[4]);

	void loadDataAsync();
	void loadDataAsyncCallBack(float dt);


	std::map<int, std::vector<TroopPathElement>> m_NormalPathVector;
	std::map<int, std::vector<TroopPathElement>> m_TroopPathMap;

	std::map<int, PathData> m_TroopPathData;
	std::map<int, PathData> m_NormalPathData;

	std::map<int, VisualData> VisualMap;
	std::map<int, BoundingBoxData> BBXMap;
	std::map<int, CannonSet> CannonSetArray;

	bool	m_bLoaded;

	std::string		m_strPath;
	std::thread*	m_loadingThread;
	int				m_loadCallback;


	void onLoadInterval(float);
};

NS_FISHGAME2D_END

#endif
