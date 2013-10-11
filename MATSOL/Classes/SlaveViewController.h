//
//  SlaveViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 20/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputResistorViewController.h"
#import "DecoderViewController.h"
#import "BaseConverterViewController.h"
#import "GIDAMatrixViewController.h"

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

@interface SlaveViewController : UIViewController <GIDAAlertViewDelegate> {
    int pageNumber;
	int size;
	UINavigationController *fatherNavigationController;
    NSBundle *resourcesLocation;
}

@property (strong, nonatomic) UINavigationController *fatherNavigationController;
@property (readwrite) int size;
@property (nonatomic, strong) NSBundle *resourcesLocation;

- (id)initWithPageNumber:(int)page;
- (void)placeButtonsAndSetBackgroundForIndex:(NSUInteger)index;

-(void)beginUIViewController:(id)sender;
-(void)creatingUIViewController:(id)sender;
-(void)endUIViewController:(id)viewController;

@end
