//
//  SelectionViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 09/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "SelectionViewController.h"
#pragma mark -

@implementation SelectionViewController

@synthesize matrixSize;
@synthesize button;
@synthesize _nextViewController;

#pragma mark initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title=@"MATSOL";
		#ifdef	DEBUG_INTERFACE
		self.title=@"MATSOL_SEL";
		#endif
	}
    return self;
}

- (void)viewDidLoad{
	[matrixSize setDelegate:self];
	[matrixSize becomeFirstResponder];
}

#pragma mark Setter
- (void)setPushViewController:(MViewController)type{
	_nextViewController=type;
}

#pragma mark Actions
-(IBAction)buttonPressed:(id)sender{	
	#ifdef DEBUG
	NSLog(@"Push the next view, the size of the matrix is %@",[matrixSize text]);
	#endif
	int theSize=0;
	theSize=[[matrixSize text] intValue];
	
	
	if (theSize>26 || theSize<1) {
        
		//Show an alert view the size is not valid : O
		UIAlertView *sizeAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error Title") 
														  message:NSLocalizedString(@"The size of your matrix must be either greater than 0 or less than 27", @"Error message for matrixes")
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		[sizeAlert release];
	}
	else {
		if (_nextViewController==MViewControllerLinearEquationSystem) {
			//Hide it's keyboard
			[matrixSize resignFirstResponder];
			
			//The size is valid? let's create a new viewController
			MatrixSheetViewController *viewController=[[[MatrixSheetViewController alloc] initWithNibName:@"MatrixSheet" bundle:nil] autorelease];
			viewController.matrixSize=[[matrixSize text] intValue];
			//Push the viewController
			[self.navigationController pushViewController:viewController animated:YES];			
		}
		if (_nextViewController==MViewControllerDeterminant) {
			//Hide it's keyboard
			[matrixSize resignFirstResponder];
			
			//The size is valid? let's create a new viewController
			DeterminantSheetViewController *viewController=[[[DeterminantSheetViewController alloc] initWithNibName:@"MatrixSheet" bundle:nil] autorelease];
			viewController.matrixSize=[[matrixSize text] intValue];
			//Push the viewController
			[self.navigationController pushViewController:viewController animated:YES];
		}
	}
	
}

#pragma mark UserFriendlyMethods
- (void)makeSpinners{
	UIActivityIndicatorView *creationSpinner;
	creationSpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[creationSpinner setCenter:CGPointMake(50, 50)];
	[creationSpinner startAnimating];
	
	UIView *spinnerBackground=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
	[spinnerBackground setBackgroundColor:[UIColor blackColor]];
	[spinnerBackground setAlpha:0.6];
	[spinnerBackground setCenter:[creationSpinner center]];
	
	[spinnerBackground addSubview:creationSpinner];
	[creationSpinner release];
	[self.view addSubview:spinnerBackground];
	[spinnerBackground release];
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
	
	if (intValue==0) {
		// 0 indicates the supr key
		if (cadena[0]=='0'|| cadena[0]==0) {
			return YES;
		}
		else {
			return NO;
		}
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	#ifdef DEBUG
	NSLog(@"Push the next view, the size of the matrix is [TextFieldDelegate] %@",[matrixSize text]);
	#endif
	int theSize=0;
	theSize=[[matrixSize text] intValue];
	
	
	if (theSize>26 || theSize<1) {
		//Show an alert view the size is not valid : O
		UIAlertView *sizeAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error Title")
														  message:NSLocalizedString(@"The size of your matrix must be either greater than 0 or less than 27", @"Error message for matrixes")
														 delegate:self 
												cancelButtonTitle:@"Ok" 
												otherButtonTitles:nil];
		//Display the alert dialog
		[sizeAlert show];
		[sizeAlert release];
		return NO;
	}
	else {
		if (_nextViewController==MViewControllerLinearEquationSystem) {
			//Hide it's keyboard
			[matrixSize resignFirstResponder];
			
			//The size is valid? let's create a new viewController
			MatrixSheetViewController *viewController=[[[MatrixSheetViewController alloc] initWithNibName:@"MatrixSheet" bundle:nil] autorelease];
			viewController.matrixSize=[[matrixSize text] intValue];
			//Push the viewController
			[self.navigationController pushViewController:viewController animated:YES];
			return YES;
		}
		if (_nextViewController==MViewControllerDeterminant) {
			//Hide it's keyboard
			[matrixSize resignFirstResponder];
			
			//The size is valid? let's create a new viewController
			DeterminantSheetViewController *viewController=[[[DeterminantSheetViewController alloc] initWithNibName:@"MatrixSheet" bundle:nil] autorelease];
			viewController.matrixSize=[[matrixSize text] intValue];
			//Push the viewController
			[self.navigationController pushViewController:viewController animated:YES];
			return YES;
		}
	}
	return NO;
}

#pragma mark MemoryManagement
- (void)viewDidUnload {
    [super viewDidUnload];
	matrixSize=nil;
	button=nil;
}

- (void)dealloc {
	[button release];
	[matrixSize release];	
    [super dealloc];
}


@end