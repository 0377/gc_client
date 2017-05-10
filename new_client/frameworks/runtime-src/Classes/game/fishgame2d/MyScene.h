#pragma once

#ifndef _FISH_GAME_SCENE_
#define _FISH_GAME_SCENE_


#include "./common.h"
#include "editor-support/spine/spine.h"

NS_FISHGAME2D_BEGIN

enum LayerZOrder
{
	START = -2,
	STATIC_BACKGROUND,			//背景;
	OBJECT_EFFECT_DOWN,			//效果;
	OBJECT_FISH_SHADOW,			//鱼的阴影;
	OBJECT_FISH,				//鱼;
	OBJECT_FISH_TEST,			//鱼;
	STATIC_WATER,				//水纹;
	STATIC_SWITCH_BACKGROUND,	//切换场景背景;
	STATIC_SWITCH_WATER,		//切换场景水纹;
	STATIC_SWITCH_WAVE,			//切换场景波浪;
	OBJECT_BULLET,				//子弹;
	OBJECT_BULLET_DIE,			//子弹死亡效果,单独一层视觉效果好点;
	OBJECT_EFFECT_UP,			//效果;
	TOP_UI,						//UI;
	BOUNDING_BOX,				//绑定盒;
	LAYER_LOADING,				//资源加载层;
	LAYER_TEST,					//测试;
	END,
};


class MyObject;
class Fish;
class Bullet;
class MyScene;

class MyScene : public cocos2d::Scene
{
private:
	bool AddFish(Fish*, std::vector<VisualNode>*);
	bool AddBullet(Bullet*, std::vector<VisualNode>*);
public:
	bool AddMyObject(MyObject*, std::vector<VisualNode>*);
private:
	MyScene();

	spSkeletonData* getSkeletonData(std::string);

	cocos2d::Layer*		m_pLayerBullet;
	cocos2d::Layer*		m_pLayerBulletDie; 
	cocos2d::Layer*		m_pLayerFish;

	std::map<std::string, spSkeletonData*> m_mapSkeletonCache;
	std::map<std::string, spAtlas*> m_mapAtlas;
public:		
	~MyScene();
	CREATE_FUNC(MyScene);
		
	static cocos2d::Node* CreateFishNode(MyScene*,int);

	static cocos2d::Node* CreateTestFishNode(MyScene*, int,int,bool);
};

NS_FISHGAME2D_END

#endif // !_FISH_GAME_SCENE_