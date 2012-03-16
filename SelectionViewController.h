//
//  SelectionViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 09/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixSheetViewController.h"
#import "DeterminantSheetViewController.h"
#import "GIDASearchAlert.h"
#import "MATSOLDefines.h"

typedef enum{
	MViewControllerLinearEquationSystem=0,
	MViewControllerDeterminant=1
}MViewController;

@interface SelectionViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>{
	UITextField *matrixSize;
	UIButton *button;
	
	int _nextViewController;
}
- (void)makeSpinners;
- (void)setPushViewController:(MViewController)type;
- (IBAction)buttonPressed:(id)sender;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


@property (retain, nonatomic) IBOutlet UITextField *matrixSize;
@property (retain, nonatomic) IBOutlet UIButton *button;
@property (readwrite) int _nextViewController;

@end
