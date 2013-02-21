/*
 *  ludcmp.h
 *  
 *
 *  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 13/06/10.
 *  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
 *
 */

#ifndef STDIO
#include <stdio.h>
#define STDIO
#endif

#ifndef MATH
#include <math.h>
#define MATH
#endif

#ifndef UNISTD
#include <unistd.h>
#define UNISTD
#endif

#ifndef STDLIB
#include <stdlib.h>
#define STDLIB
#endif

#import "MATSOLDefines.h"

#ifndef LUDCMP_ERRORS
typedef enum{
	DeterminantErrorCantSolve=0,
	DeterminantErrorEverythingOk,
}DeterminantError;
#define LUDCMP_ERRORS
#endif

#define TINY 1.0e-20

int ludcmp(float **a, int n, float *d);