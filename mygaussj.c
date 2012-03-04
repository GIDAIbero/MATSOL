/*
 *  mygaussj.c
 *  MyGaussJordan
 *
 *  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 07/06/10.
 *  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
 *
 *	Linear equation solution by Gauss-Jordan elimination. 
 *	a[0..n-1][0..n-1] is the input matrix. b[0..n-1] is input
 *	containing the right-hand side vectors. On output a is
 *	replaced by its matrix inverse, and b is replaced by the 
 *	corresponding set of solution vectors 
 */

#include "mygaussj.h"

int gaussj(float *a[], int n, float *b){
	int indxc[n+1],indxr[n+1],ipiv[n+1];
	int i,icol,irow,j,k,l,ll;
	float big,dum,pivinv,temp;
	
	for (j=1;j<=n;j++) ipiv[j]=0;
	for (i=1;i<=n;i++) {
		big=0.0;
		for (j=1;j<=n;j++)
			if (ipiv[j] != 1)
				for (k=1;k<=n;k++) {
					if (ipiv[k] == 0) {
						if (fabs(a[j-1][k-1]) >= big) {
							big=fabs(a[j-1][k-1]);
							irow=j;
							icol=k;
						}
					} else if (ipiv[k] > 1) {
						#ifdef DEBUG
						printf("gaussj: Singular Matrix-1");
						#endif
						return UnsolvedMatrix;
					}
				}
		
		++(ipiv[icol]);
		if (irow != icol) {
			for (l=1;l<=n;l++) SWAP(a[irow-1][l-1],a[icol-1][l-1])
				SWAP(b[irow-1],b[icol-1])
				}
		indxr[i]=irow;
		indxc[i]=icol;
		if (a[icol-1][icol-1] == 0.0) {
			#ifdef DEBUG
			printf("gaussj: Singular Matrix-2");
			#endif
			return UnsolvedMatrix;
		}
		pivinv=1.0/a[icol-1][icol-1];
		a[icol-1][icol-1]=1.0;
		for (l=1;l<=n;l++) a[icol-1][l-1] *= pivinv;
		b[icol-1] *= pivinv;
		for (ll=1;ll<=n;ll++)
			if (ll != icol) {
				dum=a[ll-1][icol-1];
				a[ll-1][icol-1]=0.0;
				for (l=1;l<=n;l++) a[ll-1][l-1] -= a[icol-1][l-1]*dum;
				b[ll-1] -= b[icol-1]*dum;
			}
	}
	
	for (l=n;l>=1;l--) {
		if (indxr[l] != indxc[l])
			for (k=1;k<=n;k++)
				SWAP(a[k-1][indxr[l]-1],a[k-1][indxc[l]-1]);
	}
	
	return SolvedMatrix;
}