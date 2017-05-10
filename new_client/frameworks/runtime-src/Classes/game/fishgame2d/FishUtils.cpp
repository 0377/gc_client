#include "FishUtils.h"
#include <math.h>

NS_FISHGAME2D_BEGIN

float FishUtils::CalcAngle(float x1, float y1, float x2, float y2){
	float x = x1 - x2;
	float y = y1 - y2;

	if (y == 0){
		if (x1 < x2){
			return M_PI_2;
		}
		else{
			return -M_PI_2;
		}
	}


	float deg = atanf(x / y);
	if (y < 0) {
		return -deg + M_PI;
	}
	else{
		return -deg;
	}
}

void FishUtils::CacLine(float x[4], float y[4], float percent, float* outX, float* outY, float* outDir){
	*outX = x[0] + (x[1] - x[0]) * percent;
	*outY = y[0] + (y[1] - y[0]) * percent;
	*outDir = FishUtils::CalcAngle(x[0], y[0], x[1], y[1]) - M_PI_2;
}

void FishUtils::CacBesier(float x[4], float y[4], int count, float per, float* outX, float* outY, float* outDir){
	if (count == 3){
		float x1 = x[0] + (x[1] - x[0]) * per;
		float x2 = x[1] + (x[2] - x[1]) * per;

		float y1 = y[0] + (y[1] - y[0]) * per;
		float y2 = y[1] + (y[2] - y[1]) * per;

		*outX = x1 + (x2 - x1) * per;
		*outY = y1 + (y2 - y1) * per;
		*outDir = FishUtils::CalcAngle(x1, y1, x2, y2) - M_PI_2;
	}
	else{
		float x1 = x[0] + (x[1] - x[0]) * per;
		float x2 = x[1] + (x[2] - x[1]) * per;
		float x3 = x[2] + (x[3] - x[2]) * per;

		float y1 = y[0] + (y[1] - y[0]) * per;
		float y2 = y[1] + (y[2] - y[1]) * per;
		float y3 = y[2] + (y[3] - y[2]) * per;

		float xx1 = x1 + (x2 - x1) * per;
		float xx2 = x2 + (x3 - x2) * per;

		float yy1 = y1 + (y2 - y1) * per;
		float yy2 = y2 + (y3 - y2) * per;

		*outX = xx1 + (xx2 - xx1) * per;
		*outY = yy1 + (yy2 - yy1) * per;
		*outDir = FishUtils::CalcAngle(xx1, yy1, xx2, yy2) - M_PI_2;
	}
}

void FishUtils::CalCircle(float centerX, float centerY, float radius, float begin, float fAngle, float fAdd, float percent, float* outX, float* outY, float* outDir){
	float absFAngle = fabs(fAngle);
	float _radius = radius * (1 + fAdd * percent * absFAngle);
	float angle = begin + percent * absFAngle;

	*outX = centerX + _radius * cosf(angle);
	*outY = centerY + _radius * sinf(angle);
	*outDir = angle + M_PI_2;
}

NS_FISHGAME2D_END
