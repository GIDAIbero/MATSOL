/*
 *  mygaussj.h
 *  MyGaussJordan
 *
 *  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 07/06/10.
 *  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
 *
 */

#define SWAP(a,b) {temp=(a);(a)=(b);(b)=temp;}

#ifndef STDIO
#include <stdio.h>
#define STDIO
#endif

#ifndef MATH
#include <math.h>
#define MATH
#endif

#import "MATSOLDefines.h"

typedef enum{
	UnsolvedMatrix=0,
	SolvedMatrix
}ErrorTypes;


int gaussj(float *a[], int n, float *b);