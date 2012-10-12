#ifndef STDIO
#include <stdio.h>
#define STDIO
#endif

#ifndef MATH
#include <math.h>
#define MATH
#endif

#ifndef STDLIB
#include <stdlib.h>
#define STDLIB
#endif

#include "MATSOLDefines.h"

typedef struct _resist{
	float R1,R2;//these are a 2 resistance block
	char seriesParallel;//this flag indicates the configuration required between series and parallel,0 for series, 1 for parallel
	float Req;//this is the Req that holds this piece of network
}RESIST;

typedef enum{
	ResistorArrangeTypeSeriesSecond=-1,
	ResistorArrangeTypeSeriesFirst=0,
	ResistorArrangeTypeParallel=1,
}ResistorArrangeType;

//array stands for the piece of network to be modified, target is the target resistance
int resCalc(RESIST *array,float target);
int networkCalc(RESIST *network,float target,float tolerance);
