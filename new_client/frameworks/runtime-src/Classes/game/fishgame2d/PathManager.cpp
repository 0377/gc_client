//#define  _USE_MATH_DEFINES
//
#include "PathManager.h"
#include "./FishObjectManager.h"
#include "./FishUtils.h"
#include "./utils/XMLParser.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/CCLuaStack.h"
#include <math.h>

NS_FISHGAME2D_BEGIN

	PathManager::PathManager()
		: m_bLoaded(false)
		, m_loadingThread(nullptr)
		, m_loadCallback(0)
	{
	}

	PathManager::~PathManager()
	{
	}

	void PathManager::LoadData(std::string path, int load_callback){
#if CC_ENABLE_SCRIPT_BINDING
		m_loadCallback = load_callback;
#endif
		m_bLoaded = false;
		Director::getInstance()->getScheduler()->schedule(CC_SCHEDULE_SELECTOR(PathManager::loadDataAsyncCallBack), this, 0, false);

		m_strPath = path;

		//if (m_loadingThread == nullptr){
		//	m_loadingThread = new std::thread(&PathManager::loadDataAsync, this);
		//}

		loadDataAsync();
	}

	void PathManager::loadDataAsync(){
		if (LoadNormalPath(m_strPath + "/path.xml")
			&& LoadTroop(m_strPath + "/TroopSet.xml")
			&& LoadVisual(m_strPath + "/Visual.xml")
			&& LoadBoundingBox(m_strPath + "/BoundingBox.xml")
			&& LoadCannonSet(m_strPath + "/CannonSet.xml")){

			m_bLoaded = true;
		}

	}

	void PathManager::onLoadInterval(float per){
#if CC_ENABLE_SCRIPT_BINDING
			if (m_loadCallback != 0){
				float percent = per == 1 ? 1 : 0.2 + per * 0.8f;
				cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
				_stack->pushFloat(0.2 + per * 0.8f);
				int ret = _stack->executeFunctionByHandler(m_loadCallback, 1);
				_stack->clean();

				if (per == 1){
					m_loadCallback = 0;
				}
			}
#endif
	}

	void PathManager::loadDataAsyncCallBack(float dt){
		if (m_bLoaded){
			Director::getInstance()->getScheduler()->unschedule(CC_SCHEDULE_SELECTOR(PathManager::loadDataAsyncCallBack), this);

#if CC_ENABLE_SCRIPT_BINDING
			if (m_loadCallback != 0){
				cocos2d::LuaStack *_stack = cocos2d::LuaEngine::getInstance()->getLuaStack();
				_stack->pushFloat(0.2);
				int ret = _stack->executeFunctionByHandler(m_loadCallback, 1);
				_stack->clean();

				for (auto v : VisualMap){
					for (auto& image : v.second.ImageInfoDie){
						cocostudio::ArmatureDataManager::getInstance()->addArmatureFileInfoAsync (
							"fishgame2d/animation/fishes/" + image.Image + ".ExportJson",
							this, cocos2d::SEL_SCHEDULE(&PathManager::onLoadInterval));
					}

					for (auto& image : v.second.ImageInfoLive){
						cocostudio::ArmatureDataManager::getInstance()->addArmatureFileInfoAsync(
							"fishgame2d/animation/fishes/" + image.Image + ".ExportJson",
							this, cocos2d::SEL_SCHEDULE(&PathManager::onLoadInterval));
					}
				}

				for (auto v : CannonSetArray){
					for (auto cannon : v.second.cannons){
						cocostudio::ArmatureDataManager::getInstance()->addArmatureFileInfoAsync("fishgame2d/animation/" + cannon.second.net.resName + "/" + cannon.second.net.resName + ".ExportJson",
							this, cocos2d::SEL_SCHEDULE(&PathManager::onLoadInterval));

						cocostudio::ArmatureDataManager::getInstance()->addArmatureFileInfoAsync("fishgame2d/animation/" + cannon.second.bullet.resName + "/" + cannon.second.bullet.resName + ".ExportJson",
							this, cocos2d::SEL_SCHEDULE(&PathManager::onLoadInterval));
					}
				}
			}
#endif
		}
	}

	void PathManager::Clear(){
		for (auto v : VisualMap){
			for (auto& image : v.second.ImageInfoDie){
				cocostudio::ArmatureDataManager::getInstance()->removeArmatureFileInfo("fishgame2d/animation/fishes/" + image.Image + ".ExportJson");
			}

			for (auto& image : v.second.ImageInfoLive){
				cocostudio::ArmatureDataManager::getInstance()->removeArmatureFileInfo("fishgame2d/animation/fishes/" + image.Image + ".ExportJson");
			}
		}

		for (auto v : CannonSetArray){
			for (auto cannon : v.second.cannons){
				cocostudio::ArmatureDataManager::getInstance()->removeArmatureFileInfo("fishgame2d/animation/" + cannon.second.net.resName + "/" + cannon.second.net.resName + ".ExportJson");

				cocostudio::ArmatureDataManager::getInstance()->removeArmatureFileInfo("fishgame2d/animation/" + cannon.second.bullet.resName + "/" + cannon.second.bullet.resName + ".ExportJson");
			}
		}
	}

	bool PathManager::LoadNormalPath(std::string szFileName){
		XMLParser* doc = XMLParser::create();
		auto valueMap = doc->parseXML(szFileName);
		std::vector<TroopPathElement> NormalPaths;

		Value& temp = valueMap["FishPath"];
		Value& TPS = temp.asValueMap()["Path"];
		for (Value& _v : TPS.asValueVector()){
			auto& v = _v.asValueMap();

			TroopPathElement pd;
			pd.nId = v["id"].asInt();
			pd.nType = v["Type"].asInt();
			pd.nNext = v["Next"].asInt();
			pd.nDelay = v["Delay"].asInt();
			pd.nPointCount = 0;

			for (auto& _vv : v["Position"].asValueVector()){
				ValueMap vv = _vv.asValueMap();
				pd.xPos[pd.nPointCount] = vv["x"].asFloat();
				pd.yPos[pd.nPointCount] = vv["y"].asFloat();

				pd.nPointCount++;
			}
			switch (pd.nType){
			case NPT_LINE:
				pd.nPointCount = 2;
				break;
			case NPT_BEZIER:
				if (pd.xPos[4] == 0 && pd.yPos[4] == 0){
					pd.nPointCount = 3;
				}
				break;
			default:
				pd.nPointCount = 4;
				break;
			}

			NormalPaths.push_back(pd);
		}

		m_NormalPathVector.clear();
		int id = 0;
		for (auto& v : NormalPaths){
			for (int x = 0; x <= 1; x++){
				for (int y = 0; y <= 1; y++){
					for (int xy = 0; xy <= 1; xy++){
						for (int _not = 0; _not <= 1; _not++){
							std::vector<TroopPathElement> path;
							TroopPathElement ele;
							ele.nType = v.nType;
							ele.nPointCount = v.nPointCount;
							ele.nDelay = v.nDelay;
							ele.nType = v.nType;

							//ConvertPathPoint(v, x == 0, y == 0, xy == 0, _not == 0, &ele.xPos, &ele.yPos);
							ConvertPathPoint(v, x, y, xy, _not, &ele.xPos, &ele.yPos);

							path.push_back(ele);
							m_NormalPathVector[id++] = path;
						}
					}
				}
			}
		}

		for (auto v : m_NormalPathVector){
			GetPathData(v.first,false);
		}
		

		return true;
	}

	bool PathManager::LoadTroop(std::string szFileName)
	{
		XMLParser* doc = XMLParser::create();
		ValueMap valueMap = doc->parseXML(szFileName);
		std::map<int, TroopPathElement> TroopPath;

		Value TPS = valueMap["Path"];
		for (Value _v : TPS.asValueVector()){
			ValueMap v = _v.asValueMap();

			TroopPathElement pd;
			pd.nId = v["id"].asInt();
			pd.nType = v["Type"].asInt();
			pd.nNext = v["Next"].asInt();
			pd.nDelay = v["Delay"].asInt();
			pd.nPointCount = 0;

			for (Value _vv : v["Position"].asValueVector()){
				ValueMap vv = _vv.asValueMap();
				pd.xPos[pd.nPointCount] = vv["x"].asFloat();
				pd.yPos[pd.nPointCount] = vv["y"].asFloat();

				pd.nPointCount++;
			}
			switch (pd.nType){
			case NPT_LINE:
				pd.nPointCount = 2;
				break;
			case NPT_BEZIER:
				if (pd.xPos[4] == 0 && pd.yPos[4] == 0){
					pd.nPointCount = 3;
				}
				break;
			default:
				pd.nPointCount = 4;
				break;
			}

			TroopPath[pd.nId] = pd;
		}


		m_TroopPathMap.clear();
		for (auto v : TroopPath){
			std::vector<TroopPathElement> path;
			int nxt = v.first;

			do
			{
				auto sph = TroopPath[nxt];

				TroopPathElement ele;
				ele.nType = sph.nType;
				ele.nPointCount = sph.nPointCount;
				ele.nDelay = sph.nDelay;
				ele.nType = sph.nType;

				ConvertPathPoint(sph, false, false, false, false, &ele.xPos, &ele.yPos);


				path.push_back(ele);

				nxt = sph.nNext;
			} while (nxt != 0);

			m_TroopPathMap[v.first] = path;
		}

		for (auto v : m_TroopPathMap){
			GetPathData(v.first, true);
		}
		return true;
	}

	bool PathManager::LoadVisual(std::string szFileName){
		XMLParser* doc = XMLParser::create();
		ValueMap valueMap = doc->parseXML(szFileName);
		std::map<int, TroopPathElement> TroopPath;

		auto& VisualSet = valueMap["VisualSet"];
		if (VisualSet.getType() != cocos2d::Value::Type::MAP){
			return false;
		}

		auto& Visual = VisualSet.asValueMap()["Visual"];
		if (Visual.getType() != cocos2d::Value::Type::VECTOR){
			return false;
		}

		VisualMap.clear();
		for (auto& _v : Visual.asValueVector()){
			ValueMap& v = _v.asValueMap();

			VisualData vs;
			vs.nID = v["Id"].asInt();
			vs.nTypeID = v["TypeID"].asInt();
			vs.nZOrder = v["ZOrder"].asInt();

			if (v["Live"].getType() == cocos2d::Value::Type::VECTOR){
				auto& image = v["Live"].asValueVector();
				for (auto& _vv : image){
					auto& vv = _vv.asValueMap();

					VisualImage imi;
					imi.Image = vv["Image"].asString();
					imi.Name = vv["Name"].asString();
					imi.Scale = vv["Scale"].asFloat();
					imi.OffestX = vv["OffestX"].asFloat();
					imi.OffestY = vv["OffestY"].asFloat();
					imi.Direction = vv["Direction"].asFloat();
					imi.AniType = vv["AniType"].asInt();
					imi.HideShadow = vv["HideShadow"].asBool();

					vs.ImageInfoLive.push_back(imi);
				}
			}
			else if (v["Live"].getType() == cocos2d::Value::Type::MAP){
				auto& vv = v["Live"].asValueMap();

				VisualImage imi;
				imi.Image = vv["Image"].asString();
				imi.Name = vv["Name"].asString();
				imi.Scale = vv["Scale"].asFloat();
				imi.OffestX = vv["OffestX"].asFloat();
				imi.OffestY = vv["OffestY"].asFloat();
				imi.Direction = vv["Direction"].asFloat();
				imi.AniType = vv["AniType"].asInt();
				imi.HideShadow = vv["HideShadow"].asBool();

				vs.ImageInfoLive.push_back(imi);
			}
		
			if (v["Die"].getType() == cocos2d::Value::Type::VECTOR){
				auto& image = v["Die"].asValueVector();
				for (auto& _vv : image){
					auto& vv = _vv.asValueMap();

					VisualImage imi;
					imi.Image = vv["Image"].asString();
					imi.Name = vv["Name"].asString();
					imi.Scale = vv["Scale"].asFloat();
					imi.OffestX = vv["OffestX"].asFloat();
					imi.OffestY = vv["OffestY"].asFloat();
					imi.Direction = vv["Direction"].asFloat();
					imi.AniType = vv["AniType"].asInt();
					imi.HideShadow = vv["HideShadow"].asBool();

					vs.ImageInfoDie.push_back(imi);
				}
			}
			else if (v["Die"].getType() == cocos2d::Value::Type::MAP){
				auto& vv = v["Die"].asValueMap();

				VisualImage imi;
				imi.Image = vv["Image"].asString();
				imi.Name = vv["Name"].asString();
				imi.Scale = vv["Scale"].asFloat();
				imi.OffestX = vv["OffestX"].asFloat();
				imi.OffestY = vv["OffestY"].asFloat();
				imi.Direction = vv["Direction"].asFloat();
				imi.AniType = vv["AniType"].asInt();
				imi.HideShadow = vv["HideShadow"].asBool();

				vs.ImageInfoDie.push_back(imi);
			}

			VisualMap[vs.nID] = vs;
		}

		return true;
	}

	bool PathManager::LoadBoundingBox(std::string szFileName){
		XMLParser* doc = XMLParser::create();
		ValueMap valueMap = doc->parseXML(szFileName);
		std::map<int, TroopPathElement> TroopPath;

		auto& boundingBox = valueMap["BoundingBox"];
		if (boundingBox.getType() != cocos2d::Value::Type::VECTOR){
			return false;
		}

		BBXMap.clear();
		auto& nbbx = boundingBox.asValueVector();
		for (auto& _v : nbbx){
			auto& v = _v.asValueMap();
			int nID = v["id"].asInt();

			BoundingBoxData data;
			data.nId = nID;
			std::list<BoundingBox> BBList;


			auto& BB = v["BB"];
			if (BB.getType() == cocos2d::Value::Type::VECTOR){
				auto& image = BB.asValueVector();
				for (auto& _vv : image){
					auto& vv = _vv.asValueMap();

					BoundingBox b;
					b.offsetX = vv["OffestX"].asFloat();
					b.offsetY = vv["OffestY"].asFloat();
					b.rad = vv["Radio"].asFloat();

					BBList.push_back(b);
				}
			}
			else if (BB.getType() == cocos2d::Value::Type::MAP){
				auto& vv = BB.asValueMap();

				BoundingBox b;
				b.offsetX = vv["OffestX"].asFloat();
				b.offsetY = vv["OffestY"].asFloat();
				b.rad = vv["Radio"].asFloat();

				BBList.push_back(b);
			}

			data.value = BBList;
			BBXMap[nID] = data;
		}

		return true;
	}

	bool PathManager::LoadCannonSet(std::string szFileName){
		XMLParser* doc = XMLParser::create();
		ValueMap valueMap = doc->parseXML(szFileName);
		std::map<int, TroopPathElement> TroopPath;

		auto& cannonSet = valueMap["CannonSet"];
		if (cannonSet.getType() != cocos2d::Value::Type::VECTOR){
			return false;
		}
		CannonSetArray.clear();

		auto& _cannonSet = cannonSet.asValueVector();
		for (auto& _v : _cannonSet){
			auto& v = _v.asValueMap();

			CannonSet ccs;
			ccs.id = v["id"].asInt();
			ccs.nromal = v["nromal"].asInt();
			ccs.ion = v["ion"].asInt();
			ccs.dou = v["double"].asInt();


			auto& _cannon = v["CannonType"];
			if (_cannon.getType() == cocos2d::Value::Type::VECTOR){
				auto& cannon = _cannon.asValueVector();
				for (auto& _v : cannon){
					auto& v = _v.asValueMap();

					Cannon con;
					con.type = v["type"].asInt();

					auto& _gun = v["Cannon"];
					if (_gun.getType() == cocos2d::Value::Type::MAP){
						auto& gun = _gun.asValueMap();
						CannonGun cannonGun;
						cannonGun.resName = gun["ResName"].asString();
						cannonGun.Name = gun["Name"].asString();
						cannonGun.ResType = gun["ResType"].asInt();
						cannonGun.PosX = gun["PosX"].asFloat();
						cannonGun.PosY = gun["PosY"].asFloat();
						cannonGun.FireOffest = gun["FireOffest"].asFloat();
						cannonGun.type = gun["type"].asInt();

						con.gun = cannonGun;
					}

					auto& _bullet = v["Bullet"];
					if (_bullet.getType() == cocos2d::Value::Type::MAP){
						auto& bullet = _bullet.asValueMap();
						CannonBullet cannonBullet;
						cannonBullet.resName = bullet["ResName"].asString();
						cannonBullet.Name = bullet["Name"].asString();
						cannonBullet.ResType = bullet["ResType"].asInt();

						con.bullet = cannonBullet;
					}

					auto& _net = v["Net"];
					if (_net.getType() == cocos2d::Value::Type::MAP){
						auto& net = _net.asValueMap();
						CannonNet cannonNet;
						cannonNet.resName = net["ResName"].asString();
						cannonNet.Name = net["Name"].asString();
						cannonNet.ResType = net["ResType"].asInt();
						cannonNet.PosX = net["PosX"].asFloat();
						cannonNet.PosY = net["PosY"].asFloat();
						cannonNet.FireOffest = net["FireOffest"].asFloat();
						cannonNet.type = net["type"].asInt();

						con.net = cannonNet;
					}
					
					ccs.cannons[con.type] = con;
				}
			}
			CannonSetArray[ccs.id] = ccs;
		}
		return true;
	}

	void PathManager::ConvertPathPoint(TroopPathElement sp, bool xMirror, bool yMirror, bool xyMirror, bool Not, float(*outX)[4], float(*outY)[4]){
	float x[4], y[4];
	for (int i = 0; i < sp.nPointCount; i++){
		x[i] = sp.xPos[i];
		y[i] = sp.yPos[i];
	}

	if (xMirror)
	{
		if (sp.nType == NPT_CIRCLE)
		{
			x[0] = 1.0f - x[0];
			x[2] = M_PI - x[2];
			y[2] = -y[2];
		}
		else
		{
			for (int n = 0; n < sp.nPointCount; ++n)
			{
				x[n] = 1.0f - x[n];
			}
		}
	}
	if (yMirror)
	{
		if (sp.nType == NPT_CIRCLE)
		{
			y[0] = 1.0f - y[0];
			x[2] = 2 * M_PI - x[2];
			y[2] = -y[2];
		}
		else
		{
			for (int n = 0; n < sp.nPointCount; ++n)
			{
				y[n] = 1.0f - y[n];
			}
		}
	}

	if (xyMirror)
	{
		if (sp.nType == NPT_CIRCLE)
		{
			float t = x[0];
			x[0] = 1.0f - y[0];
			y[0] = 1.0f - t;
			x[2] += (float)M_PI_2;
		}
		else
		{
			for (int n = 0; n < sp.nPointCount; ++n)
			{
				float t = x[n];
				x[n] = y[n];
				y[n] = t;
			}
		}
	}

	if (Not)
	{
		if (sp.nType == NPT_CIRCLE)
		{
			x[2] += y[2];
			y[2] = -y[2];
		}
		else
		{
			for (int n = 0; n < sp.nPointCount / 2; ++n)
			{
				float t = x[n];
				x[n] = x[sp.nPointCount - 1 - n];
				x[sp.nPointCount - 1 - n] = t;

				t = y[n];
				y[n] = y[sp.nPointCount - 1 - n];
				y[sp.nPointCount - 1 - n] = t;
			}
		}
	}


	for (int n = 0; n < sp.nPointCount; ++n)
	{
		x[n] = x[n] * FishObjectManager::GetInstance()->GetClientWidth();
		y[n] = y[n] * FishObjectManager::GetInstance()->GetClientHeight();

		if (sp.nType == NPT_CIRCLE)
			break;
	}

	memcpy(*outX, x, sizeof(float) * 4);
	memcpy(*outY, y, sizeof(float) * 4);
}

	PathData PathManager::CreatePathData(std::vector<TroopPathElement> pPath){
		int duration = 0;
		std::vector<PathMoveData> pathData;

		for (auto v : pPath){
			switch (v.nType)
			{
			case NPT_LINE:{
				int tempDuration = MathAide::CalcDistance(v.xPos[0], v.yPos[0], v.xPos[1], v.yPos[1]);

				PathMoveData ele;
				ele.nType = PMT_LINE;
				memcpy(ele.xPos, v.xPos, sizeof(float) * 4);
				memcpy(ele.yPos, v.yPos, sizeof(float) * 4);
				ele.nPointCount = v.nPointCount;
				ele.nDuration = tempDuration;
				ele.nStartTime = duration;
				duration += tempDuration;
				ele.nEndTime = duration;

				pathData.push_back(ele);

				if (v.nDelay > 0){
					float tempDir = MathAide::CalcAngle(v.xPos[0], v.yPos[0], v.xPos[1], v.yPos[1]);
					tempDir = tempDir + M_PI_2;

					PathMoveData ele;
					ele.nType = PMT_STAY;
					ele.xPos[0] = v.xPos[1];
					ele.yPos[0] = v.yPos[1];
					ele.nPointCount = 1;
					ele.fDirction = tempDir;
					ele.nDuration = v.nDelay;
					ele.nStartTime = duration;
					duration += v.nDelay;
					ele.nEndTime = duration;

					pathData.push_back(ele);
				}
			};
						  break;
			case NPT_BEZIER:{
				PathMoveData ele;
				ele.nType = PMT_BEZIER;
				memcpy(ele.xPos, v.xPos, sizeof(float) * 4);
				memcpy(ele.yPos, v.yPos, sizeof(float) * 4);
				ele.nPointCount = v.nPointCount;
				ele.nDuration = 2000;
				ele.nStartTime = duration;
				duration += 2000;
				ele.nEndTime = duration;

				pathData.push_back(ele);

				if (v.nDelay > 0){
					float tempDir = MathAide::CalcAngle(v.xPos[0], v.yPos[0], v.xPos[1], v.yPos[1]);
					tempDir = tempDir + M_PI_2;

					PathMoveData ele;
					ele.nType = PMT_STAY;
					ele.xPos[0] = v.xPos[v.nPointCount - 1];
					ele.yPos[0] = v.yPos[v.nPointCount - 1];
					ele.nPointCount = 1;
					ele.fDirction = tempDir;
					ele.nDuration = v.nDelay;
					ele.nStartTime = duration;
					duration += v.nDelay;
					ele.nEndTime = duration;

					pathData.push_back(ele);
				}
			}
							break;
			case NPT_CIRCLE:{
				int nCount = v.xPos[1] * fabs(v.yPos[2]);

				PathMoveData ele;
				ele.nType = PMT_CIRCLE;
				memcpy(ele.xPos, v.xPos, sizeof(float) * 4);
				memcpy(ele.yPos, v.yPos, sizeof(float) * 4);
				ele.nPointCount = v.nPointCount;
				ele.nDuration = nCount;
				ele.nStartTime = duration;
				duration += nCount;
				ele.nEndTime = duration;

				pathData.push_back(ele);

				if (v.nDelay > 0){
					float x, y, dir;
					FishUtils::CalCircle(v.xPos[0], v.yPos[0], v.xPos[1], v.xPos[2], v.yPos[2], v.yPos[1], 1,&x,&y,&dir);

					PathMoveData ele;
					ele.nType = PMT_STAY;
					ele.xPos[0] = v.xPos[v.nPointCount - 1];
					ele.yPos[0] = v.yPos[v.nPointCount - 1];
					ele.nPointCount = 1;
					ele.fDirction = dir;
					ele.nDuration = v.nDelay;
					ele.nStartTime = duration;
					duration += v.nDelay;
					ele.nEndTime = duration;

					pathData.push_back(ele);
				}
			}
							break;
			default:
				break;
			}
		}

		PathData result;
		result.nDuration = duration;
		result.path = pathData;
		
		//for (auto path : pathData){
		//	for (int i = path.nStartTime; i < path.nEndTime; i++){
		//		float percent = MIN(1.0f, (float)(i - path.nStartTime) / (float)path.nDuration);
		//		float x(0.0f), y(0.0f), dir(0.0f);
		//
		//		switch (path.nType)
		//		{
		//		case PMT_LINE:
		//			FishUtils::CacLine(path.xPos, path.yPos, percent, &x, &y, &dir);
		//			break;
		//		case PMT_BEZIER:
		//			FishUtils::CacBesier(path.xPos, path.yPos, path.nPointCount, percent, &x, &y, &dir);
		//			break;
		//		case PMT_CIRCLE:
		//			FishUtils::CalCircle(path.xPos[0], path.yPos[0], path.xPos[1], path.xPos[2], path.yPos[2], path.yPos[1], percent, &x, &y, &dir);
		//			break;
		//		case PMT_STAY:
		//			x = path.xPos[0];
		//			y = path.yPos[0];
		//			dir = path.fDirction;
		//			break;
		//		default:
		//			break;
		//		}
		//
		//		PathDataElement ele;
		//		ele.x = x;
		//		ele.y = y;
		//		ele.dir = dir;
		//		result.pathData[i] = ele;
		//	}
		//}

		return result;
	}

	PathData* PathManager::GetPathData(int id, bool bTroop){
		if (bTroop){
			if (m_TroopPathData.find(id) == m_TroopPathData.end()){
				m_TroopPathData[id] = CreatePathData(m_TroopPathMap[id]);
			}
			return &m_TroopPathData[id];
		}

		if (m_NormalPathData.find(id) == m_NormalPathData.end()){
			m_NormalPathData[id] = CreatePathData(m_NormalPathVector[id]);
		}
		return &m_NormalPathData[id];
	}

	VisualData* PathManager::GetVisualData(int visualId){
		auto itr = VisualMap.find(visualId);
		if (itr == VisualMap.end()){
			return nullptr;
		}
		return &itr->second;
	}

	BoundingBoxData* PathManager::GetBoundingBoxData(int id){
		auto itr = BBXMap.find(id);
		if (itr == BBXMap.end()){
			return nullptr;
		}
		return &itr->second;
	}

	Cannon*	PathManager::GetCannonData(int cannonSetType, int cannonType){
		auto itr = CannonSetArray.find(cannonSetType);
		if (itr == CannonSetArray.end()){
			return nullptr;
		}

		auto& cannonSet = itr->second;

		auto itr_1 = cannonSet.cannons.find(cannonType);
		if (itr_1 == cannonSet.cannons.end()){
			return nullptr;
		}
		return &itr_1->second;
	}
	NS_FISHGAME2D_END