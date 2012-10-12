/*********************************************************************************************
 +Rescalc.c
 +Version: 0.4
 +Authors: Santiago "Piernas Rapidas" Torres Arias, Yoshiki "RiataExacta" Vazquez Baeza
 +Changes in version 0.4:
 -Attempted to add a floating point-precision to the tolerance value
 
 
 +Changes in version 0.3:
 -Fixed the comercial values found (added such validation).
 ~If a commercial value is found, series parallel's value will be 2.
 -Added validations to avoid lowerProposal to be indexed as Array[-1];
 ~the function will return a -1 if lower proposal exists, thus making it not elegible for the algorithm's dissertion
 -Added a lightweight piece of code that will check wether there is a stupid series that will fullfil the target.
 ~stupid series configuration stands for a X2 resistance series.
 -both functions now return an integer
 -all text outputs are now concealed in the preprocessor's conditional compiling under the label of DEBUG
 -added a piece of code with a criteria that will determine if a solution with a series node is efficient in a way that R2 does not exceed
 the target:
 ~for example, for a 7ohm resistor, it will not series 6.8 with 1.0ohm
 -the tolerance handler will overwrite the tolerance if it is lesser than 1 ohm this will avoid the algorithm to iterate endlessly
 -WARNING @ Line 151, there's a patch of the size of Texas.
 +Date: Aug 23 2010
 ***********************************************************************************************/

#include "resCalc.h"


int networkCalc(RESIST *network,float target,float tolerance){//this is the main handler for this application
	
	float  actualValue=0;//these refer to the target resistance and the temporal value for the result of the network
	int    i=0;//tollerance defines how far from the target will the user allow the network to be
	float targetTolerance = (target*tolerance)/100;
	
	#ifdef DEBUG
	printf("values into the function are %f %f",target,tolerance);
	printf("target Tolerance %f",targetTolerance);
	#endif
	if(targetTolerance < 1)
		targetTolerance =1;
	
	for(i=0;i<5;i++){//this is the main loop, that will call to the calculation of pieces of networks
		resCalc(&network[i],target-actualValue);
		actualValue+=network[i].Req;
		#ifdef DEBUG
		printf("actual value stands for.%f\nand Req for this round is: %f\n",actualValue,network[i].Req);
		#endif
		if(actualValue>(target-targetTolerance) && actualValue<(target+targetTolerance)){
			#ifdef DEBUG
			puts("value found!!!");
			#endif 
			break;
		}
	}
	return i+1;
}

int resCalc(RESIST *array,float target){
	float values[] = {  1,     1.2,     1.5,     1.8,     2.2,     2.7,     3.3,     4.7,     5.1,     5.6,     6.8,     8.2,
		10,     12 ,     15 ,     18 ,     22 ,     27 ,     33 ,     47 ,     51 ,     56 ,     68 ,     82 ,
		100,    120 ,    150 ,    180 ,    220 ,    270 ,    330 ,    470 ,    510 ,    560 ,    680 ,    820 ,
		1000,   1200 ,   1500 ,   1800 ,   2200 ,   2700 ,   3300 ,   4700 ,   5100 ,   5600 ,   6800 ,   8200 ,
		10000,  12000 ,  15000 ,  18000 ,  22000 ,  27000 ,  33000 ,  47000 ,  51000 ,  56000 ,  68000 ,  82000 ,
		100000, 120000 , 150000 , 180000 , 220000 , 270000 , 330000 , 470000 , 510000 , 560000 , 680000 , 820000 ,
		1000000,1200000 ,1500000 ,1800000 ,2200000 ,2700000 ,3300000 ,4700000 ,5100000 ,5600000 ,6800000 ,8200000 ,
	};//initializes the comercial values array, can be updated and will be automatically supported 
	
	
	float  upperProposal,lowerProposal;// this refers to the comercial values that approach the most.
	float  targetSolution,newSolution;
	int    totalValues=(sizeof(values)/sizeof(float));//this counts the length of the array, len function cant be used somehow.
	int    i=0,j,k=-1;//counter =D
	#ifdef DEBUG		
	printf("\nConstants size is---->%d\n",totalValues);
	#endif
	
	for(i=0;i<totalValues;i++){//this block is meant to find the resistances that approach the most to the target
		if(values[i]>=target){
			upperProposal=values[i];
			if(i>1)
				lowerProposal=values[i-1];
			else
				lowerProposal=-1;
			break;
		}
		if(values[i]*2 == target){
			array->R1=values[i];
			array->seriesParallel=0;
			array->R2=values[i];
			array->Req=target;
			#ifdef DEBUG
			printf("Stupid series solution! %f\n",values[i]);
			#endif
			return 0;
		}
	}
	#ifdef DEBUG
	printf("\nValues found %f, %f\n",upperProposal,lowerProposal);
	#endif
	if(upperProposal==target || lowerProposal == target){
		#ifdef DEBUG
		printf("comercial value found %f",target);
		#endif
		array->R2=target;
		array->seriesParallel=-1;
		array->Req=target;
	}
	
	
	else if(upperProposal-target<target-lowerProposal){
		#ifdef DEBUG
		printf("upper proposal was chosen-> %f\nlower proposals difference is %f\n",(upperProposal-target),(target-lowerProposal));
		#endif
		array->R1=upperProposal;//the first resistance will take the place of the upperProposal
		array->seriesParallel=1;//1 means parallel configuration for this node is enabled
		targetSolution=1/(1/upperProposal+1/values[i]);
		for(j=i;j<totalValues;j++){
			newSolution=1/(1/upperProposal+1/values[j]);
			if(newSolution>targetSolution && newSolution<target){
				targetSolution=newSolution;
				k=j;
				#ifdef DEBUG
				printf("\nParallel solution found at %f",newSolution);
				#endif
			}
		}
		array->Req=targetSolution;
		array->R2=values[k];
		#ifdef DEBUG
		printf("\n\n---------------------------------\nsolution is: %f,with the parallel of %f and %f\n-------------------------\n\n",targetSolution,array->R1,array->R2);
		#endif
	}
	else{
		#ifdef DEBUG
		printf("lower proposal was chosen-> %f\nupper proposals difference is %f\n",(target-lowerProposal),(upperProposal-target));
		#endif
		array->R1=lowerProposal;//the first resistance will take the place of the lower proposal.
		array->seriesParallel=0;//this means a series configuration for this node is enabled
		targetSolution=lowerProposal;
		for(j=i;j>=0;j--){
			newSolution=lowerProposal+values[j];
			if(newSolution>targetSolution && newSolution<target){
				targetSolution=newSolution;
				k=j;
				#ifdef DEBUG
				printf("\nSeries solution found at %f",newSolution);
				#endif
			}
		}
		if(k>=0)
			array->R2=values[k];
		array->Req=targetSolution;
		
		//WARNING: GIANTONORMOUS PATCH
		//corrects the case when the system puts a series of 0 & something else.
		//must be gone for the next version.
		if (array->R2 < 1.0) {
			array->seriesParallel=-1;
			array->R2=array->R1;
			array->R1=0.0;
		}
		
		#ifdef DEBUG
		printf("\n\n----------------------\nBig Series solution is: %.3f, with the series of %.3f and %.3f\n----------------------\n\n",targetSolution,array->R1,array->R2);
		#endif
	}
	return 0;
}
