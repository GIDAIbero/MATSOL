//
//  MatrixSheetViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 12/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolutionsViewController.h"
#import "mygaussj.h"
#import "MATSOLDefines.h"

struct FirstSecond {
    int fst;
    int snd;
};
typedef struct FirstSecond FSTSND;

@interface MatrixSheetViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>{
	NSMutableArray *myArray;
	UIView *container;
	UIScrollView *layoutView;
	UIBarButtonItem *solveButton;
	UIView *_loadingMessageView;

    FSTSND firstResponder;
	int matrixSize;
}

@property (retain, nonatomic) NSMutableArray *myArray;
@property (retain, nonatomic) UIView *container;
@property (retain, nonatomic) UIScrollView *layoutView;
@property (retain, nonatomic) UIBarButtonItem *solveButton;
@property (readwrite) int matrixSize;

- (void)solveMatrix;

//Creator of the waiting spinner and dark view
+ (UIView *)createWaitingView;

//Thread Methods
//An explanation of this methods is made in the end of 
//viewDidLoad, just right before beginTextFields: is called
-(void)beginTextFields;
-(void)creatingTextFields:(id)sender;
-(void)endTextFields:(id)sender;
-(void)endLabels:(id)sender;
-(void)makeFirstResponder:(id)sender;
	
@end
