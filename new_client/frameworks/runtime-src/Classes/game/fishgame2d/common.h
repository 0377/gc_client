#pragma once

#ifndef _FISH_GAME_COMMON_
#define  _FISH_GAME_COMMON_

#include "cocos2d.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/CCLuaStack.h"

#ifdef __cplusplus
#define NS_FISHGAME2D_BEGIN                     namespace  game { namespace fishgame2d {
#define NS_FISHGAME2D_END                       }}
#define NS_FISHGAME2D							game::fishgame2d
#define NS_FISHGAME2D_NAME						"game.fishgame2d"
#else
#define NS_FISHGAME2D_BEGIN 
#define NS_FISHGAME2D_END 
#define NS_FISHGAME2D
#define NS_FISHGAME2D_NAME						""
#endif 

NS_FISHGAME2D_BEGIN

struct ImageInfo
{
	std::string		imageName;
	std::string		aniName;
	int				aniType;
	float			offsetX;
	float			offsetY;
	float			direction;
	float			scale;
};

struct VisualNode
{
	cocos2d::Node*	target;
	cocos2d::Node*	targetShadow;
	float			scale;
	float			direction;
	float			offsetX;
	float			offsetY;

	int		nImageType;
	std::string		sAniName;

	VisualNode()
		: target(nullptr)
		, targetShadow(nullptr)
	{

	}
};



NS_FISHGAME2D_END

#endif
