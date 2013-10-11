//
//  InputResistorViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 25/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATSOLDefines.h"
#import "OutputResistorViewController.h"
#import "GIDAAlertView.h"

typedef enum{
	MTargetResistanceTextField=0,
	MToleranceTextField
}MTextFields;

@interface InputResistorViewController : UIViewController <UITextFieldDelegate>{
	IBOutlet UITextField *targetResistance;
	IBOutlet UITextField *tolerance;
    NSBundle *resourcesLocation;
}

@property (strong, nonatomic) IBOutlet UITextField *targetResistance;
@property (strong, nonatomic) IBOutlet UITextField *tolerance;
@property (strong, nonatomic) NSBundle *resourcesLocation;
@end
