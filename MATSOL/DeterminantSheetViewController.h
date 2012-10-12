//
//  DeterminantSheetViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 14/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SolutionsViewController.h"
#import "myludcmp.h"
#import "MATSOLDefines.h"
#import "GIDASearchAlert.h"
#import "Parenthesis.h"


typedef enum{
	kPaddingXLeft		=	5,
	kPaddingYLeft		=	2,
	kPaddingCornerWidth	=	22,
	kPaddingCornerHeight=	51,
	kPaddingLineWidth	=	12,
	kPaddingLineHeight	=	66
}PaddingConstants;

@interface DeterminantSheetViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>{
	NSMutableArray *myArray;
	UIView *container;
	UIScrollView *layoutView;
	UIBarButtonItem *solveButton;
	
	UIView *_loadingMessageView;
	
	int matrixSize;
}

@property (retain, nonatomic) NSMutableArray *myArray;
@property (retain, nonatomic) UIView *container;
@property (retain, nonatomic) UIScrollView *layoutView;
@property (retain, nonatomic) UIBarButtonItem *solveButton;
@property (readwrite) int matrixSize;

- (void)solveMatrix;

+ (UIView *)createWaitingView;

//Thread Methods
//An explanation of this methods is made in the end of 
//viewDidLoad, just right before beginTextFields: is called
-(void)beginTextFields;
-(void)creatingTextFields:(id)sender;
-(void)endTextFields:(id)sender;
-(void)makeFirstResponder:(id)sender;

@end
