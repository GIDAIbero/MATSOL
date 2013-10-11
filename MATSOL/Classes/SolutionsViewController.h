//
//  SolutionsViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 11/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MATSOLDefines.h"
#import "Parenthesis.h"

@interface SolutionsViewController : UIViewController <UIScrollViewDelegate>{
	
	float **a;
	float *b;
	int size;
	NSMutableArray *labelsArray;
	UIScrollView *layoutView;
	UIView *container;
    BOOL ip5;
    
    NSBundle *resourcesLocation;
}

@property (readwrite) float **a;
@property (readwrite) float *b;
@property (readwrite) int size;
@property (strong, nonatomic) NSMutableArray *labelsArray;
@property (strong, nonatomic) UIScrollView *layoutView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSBundle *resourcesLocation;
@end
