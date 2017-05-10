////
#ifndef MATH_AIDE_H_
#define MATH_AIDE_H_

#include "common.h"

#include "MovePoint.h"

NS_FISHGAME2D_BEGIN
class MathAide
{
public:
	static int Factorial(int number);
	static int Combination(int count, int r);
	static float CalcDistance(float x1, float y1, float x2, float y2);
	static float CalcAngle(float x1, float y1, float x2, float y2);
	static void BuildLinear(float initX[], float initY[], int initCount, std::vector<MyPoint>& TraceVector, float fDistance);
	static void BuildLinear(float initX[], float initY[], int initCount, MovePoints& TraceVector, float fDistance);
	static void BuildBezier(float initX[], float initY[], int initCount, MovePoints& TraceVector, float fDistance);
	static void BuildCircle(float centerX, float centerY, float radius, MovePoints& FishPos, int FishCount);
	static MyPoint GetRotationPosByOffest(float xPos, float yPos, float xOffest, float yOffest, float dir, float fHScale = 1.0f, float fVScale = 1.0f);
	static void BuildCirclePath(float centerX, float centerY, float radius, MovePoints& FishPos, float begin, float fAngle, int nStep = 1, float fAdd = 0);
};
NS_FISHGAME2D_END


static unsigned int g_seed = 0;
//static void RandSeed(int seed)
//{
//	if (!seed) g_seed = GetTickCount();
//	else g_seed = seed;
//}

static int RandInt(int min, int max)
{
	if (min == max) return min;

	g_seed = 214013 * g_seed + 2531011;

	return min + (g_seed ^ g_seed >> 15) % (max - min);
}

static float RandFloat(float min, float max)
{
	if (min == max) return min;

	g_seed = 214013 * g_seed + 2531011;

	return min + (g_seed >> 16) * (1.0f / 65535.0f) * (max - min);
}

#endif // MATH_AIDE_H_
