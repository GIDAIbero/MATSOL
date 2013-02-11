/*
 *  ludcmp.c
 *  
 *
 *  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on  on 13/06/10.
 *  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
 *
 */

#include "myludcmp.h"

int ludcmp(float **a, int n, float *d){
	int i,imax=-1,j,k;
	float big,dum,sum,temp;
	float *vv;
	
	vv=(float *)malloc((unsigned) (n)*sizeof(float));

	*d=1.0;
	for (i=1;i<=n;i++) {
		big=0.0;
		for (j=1;j<=n;j++)
			if ((temp=fabs(a[i-1][j-1])) > big) big=temp;
		if (big == 0.0){
			#ifdef DEBUG	
			printf("Singular matrix in routine ludcmp");
			#endif
            free(vv);
			return DeterminantErrorCantSolve;
		}
		vv[i]=1.0/big;
	}
	for (j=1;j<=n;j++) {
		for (i=1;i<j;i++) {
			sum=a[i-1][j-1];
			for (k=1;k<i;k++) sum -= a[i-1][k-1]*a[k-1][j-1];
			a[i-1][j-1]=sum;
		}
		big=0.0;
		for (i=j;i<=n;i++) {
			sum=a[i-1][j-1];
			for (k=1;k<j;k++)
				sum -= a[i-1][k-1]*a[k-1][j-1];
			a[i-1][j-1]=sum;
			if ( (dum=vv[i]*fabs(sum)) >= big) {
				big=dum;
				imax=i;
			}
		}
		if (j != imax) {
			for (k=1;k<=n;k++) {
				dum=a[imax-1][k-1];
				a[imax-1][k-1]=a[j-1][k-1];
				a[j-1][k-1]=dum;
			}
			*d = -(*d);
			vv[imax]=vv[j];
		}
		if (a[j-1][j-1] == 0.0) a[j-1][j-1]=TINY;
		if (j != n) {
			dum=1.0/(a[j-1][j-1]);
			for (i=j+1;i<=n;i++) a[i-1][j-1] *= dum;
		}
	}
	free(vv);
	return DeterminantErrorEverythingOk;
}

#undef TINY