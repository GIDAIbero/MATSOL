//
//  InputResistorViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 25/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "InputResistorViewController.h"
#pragma mark -

@implementation InputResistorViewController

@synthesize targetResistance;
@synthesize tolerance;

#pragma mark Initialization
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setTitle:NSLocalizedString(@"Custom Resistor", @"Custom resistor view controller title")];
	
	//Assign this objects to implement the delegate methods
	[targetResistance setDelegate:self];
	[tolerance setDelegate:self];
	
	[targetResistance setTag:MTargetResistanceTextField];
	[tolerance setTag:MToleranceTextField];
	
	[targetResistance setPlaceholder:@""];
	[tolerance setPlaceholder:@""];
	
	[targetResistance setText:@"672"];
	[tolerance setText:@"1"];
	
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goNext:)];
    UIBarButtonItem *spa = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *tool      = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,30)];
    [tool setItems:[NSArray arrayWithObjects:spa,bbi, nil]];
    [tool setBarStyle:UIBarStyleBlackTranslucent];
    [targetResistance setInputAccessoryView:tool];
	[targetResistance setKeyboardType:UIKeyboardTypeDecimalPad];
    [targetResistance setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    [tolerance setInputAccessoryView:tool];
	[tolerance setKeyboardType:UIKeyboardTypeNumberPad];
    [tolerance setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
	[targetResistance becomeFirstResponder];
    
}

#pragma mark MemoryManagement
- (void)viewDidUnload {
    [super viewDidUnload];
	targetResistance=nil;
	tolerance=nil;
}


#pragma mark TextFieldDelegateMethods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	const char *cadena;
	int intValue=0;
	
	#ifdef DEBUG
	NSLog(@"This is the new string [NSString]: %@",string);
	#endif 
	
	//Get the C string to compare
	cadena=[string cStringUsingEncoding:NSUTF16StringEncoding];
	intValue=[string intValue];
	
	//Is it the targetResistanceTextField, then allow float values
	if (textField.tag==MTargetResistanceTextField) {
		if (intValue==0) {
			// 0 indicates the supr key
			if (cadena[0]=='0'|| cadena[0]==0 || cadena[0]=='.') {
				return YES;
			}
			else {
				return NO;
			}
		}
		return YES;
	}
	if (textField.tag==MToleranceTextField) {
		if (intValue==0) {
			// 0 indicates the supr key
			if (cadena[0]=='0'|| cadena[0]==0 || cadena[0]=='.') {
				return YES;
			}
			else {
				return NO;
			}
		}
		return YES;
	}
	
	//Just allow it
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
	float resistorValue=[[targetResistance text] floatValue];
	float toleranceValue=[[tolerance text] floatValue];
	
    #ifdef DEBUG
	NSLog(@"Tolerance: [%d] & Target: [%.4f]",toleranceValue,resistorValue);
    #endif
	
	if (resistorValue<1.0) {
		//Show an alert view the size is not valid : O
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
                                                                  message:NSLocalizedString(@"The resistor value should be greater or equal to 1.", @"Resistor label for error 1")
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		
		return NO;
	}
	
	if (resistorValue>=6800000.0) {
		//Show an alert view the size is not valid : O
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string")
                                                                  message:NSLocalizedString(@"The resistor value should be less than 6800000.", @"Resistor label for error 68000000")
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		
		return NO;
	}
	
	if (toleranceValue<=0 || toleranceValue>100) {
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
														  message:NSLocalizedString(@"The tolerance should be greater than 0 or less than 100.", @"Error label for the tolerance")
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		return NO;
	}
	[targetResistance resignFirstResponder];
	[tolerance resignFirstResponder];
	
	OutputResistorViewController *viewController=[[OutputResistorViewController alloc] initWithNibName:@"OutputResistor" bundle:nil];
	[viewController setTargetResistor:resistorValue];
	[viewController setTolerance:toleranceValue];
	[[self navigationController] pushViewController:viewController animated:YES];
	
	return YES;
}

- (void)goNext:(id)sender {

	float resistorValue=[[targetResistance text] floatValue];
	float toleranceValue=[[tolerance text] floatValue];
	
	#ifdef DEBUG
	NSLog(@"Tolerance: [%d] & Target: [%.4f]",toleranceValue,resistorValue);
	#endif
	
	if (resistorValue<1.0) {
		//Show an alert view the size is not valid : O
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
                                                                  message:NSLocalizedString(@"The resistor value should be greater or equal to 1.", @"Resistor label for error 1")
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		
		return;
	}
	
	if (resistorValue>=6800000.0) {
		//Show an alert view the size is not valid : O
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
                                                                  message:NSLocalizedString(@"The resistor value should be less than 6800000.", @"Resistor label for error 68000000")
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		
		return;
	}
	
	if (toleranceValue<=0 || toleranceValue>100) {
		GIDAAlertView *sizeAlert=[[GIDAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
                                                                  message:NSLocalizedString(@"The tolerance should be greater than 0 or less than 100.", @"Error label for the tolerance")
                                                                 delegate:self 
                                                        cancelButtonTitle:@"Ok" 
                                                        otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		return;
	}
	[targetResistance resignFirstResponder];
	[tolerance resignFirstResponder];
	
	OutputResistorViewController *viewController=[[OutputResistorViewController alloc] initWithNibName:@"OutputResistor" bundle:nil];
	[viewController setTargetResistor:resistorValue];
	[viewController setTolerance:toleranceValue];
	[[self navigationController] pushViewController:viewController animated:YES];
}

@end
