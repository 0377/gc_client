#pragma once
#ifndef __fishgame_utils_h__
#define __fishgame_utils_h__

#include "./common.h"

NS_FISHGAME2D_BEGIN

class FishUtils
{
public:
	static float CalcAngle(float x1, float y1, float x2, float y2);

	static void CacLine(float x[4], float y[4], float percent, float* outX, float* outY, float* outDir);

	static void CacBesier(float x[4], float y[4], int count, float per, float* outX, float* outY, float* outDir);

	static void CalCircle(float centerX, float centerY, float radius, float begin, float fAngle, float fAdd, float percent, float* outX, float* outY, float* outDir);

private:

};

NS_FISHGAME2D_END

#endif // __fishgame_utils_h__
