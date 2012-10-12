//
//  SlaveViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 20/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionViewController.h"
#import "InputResistorViewController.h"
#import "DecoderViewController.h"
#import "BaseConverterViewController.h"

typedef enum{
	MATSOLLinearEquationButton=1,
	MATSOLDeterminantButton,
	MATSOLResistorButton,
	MATSOLDecoderButton,
	MATSOLBaseConverterButton
}MATSOLButtons;

typedef enum{
	FirstPage=0,
	SecondPage
}MATSOLPageName;

@interface SlaveViewController : UIViewController <UIAlertViewDelegate> {
    int pageNumber;
	int size;
	UINavigationController *fatherNavigationController;
}

@property (retain, nonatomic) UINavigationController *fatherNavigationController;
@property (readwrite) int size;

- (id)initWithPageNumber:(int)page;
- (void)placeButtonsAndSetBackgroundForIndex:(NSUInteger)index;

-(void)beginUIViewController:(id)sender;
-(void)creatingUIViewController:(id)sender;
-(void)endUIViewController:(id)viewController;

@end
