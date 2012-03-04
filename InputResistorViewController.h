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

typedef enum{
	MTargetResistanceTextField=0,
	MToleranceTextField
}MTextFields;

@interface InputResistorViewController : UIViewController <UITextFieldDelegate>{
	IBOutlet UITextField *targetResistance;
	IBOutlet UITextField *tolerance;
}

@property (retain, nonatomic) IBOutlet UITextField *targetResistance;
@property (retain, nonatomic) IBOutlet UITextField *tolerance;

@end
