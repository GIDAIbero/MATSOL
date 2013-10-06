//
//  SlaveViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 20/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "SlaveViewController.h"
#pragma mark -

@implementation SlaveViewController

@synthesize size;
@synthesize fatherNavigationController;
@synthesize resourcesLocation;

#pragma mark ViewControllerMethods
// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    float systemVersion;

    //this small blocks controls the bundle loading
    systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >=7.0){
        resourcesLocation = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Current" withExtension:@"bundle" ]];
    }else{
        resourcesLocation = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Default" withExtension:@"bundle" ]];
        
    }
    if (self = [super initWithNibName:@"Slave" bundle:resourcesLocation]) {
        pageNumber = page;
    }
    return self;
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
	[self placeButtonsAndSetBackgroundForIndex:pageNumber];
}

#pragma mark CustomMethods
// Creates the color list the first time this method is invoked. Returns one color object from the list.
- (void)placeButtonsAndSetBackgroundForIndex:(NSUInteger)index {
	if (index==FirstPage) {
		//Create every button for the first page
		UIButton *matrixSolution=[UIButton buttonWithType:UIButtonTypeCustom];
		[matrixSolution setBackgroundColor:[UIColor clearColor]];
		[matrixSolution setBackgroundImage:[UIImage imageNamed:@"linearequationsystem.png"] forState:UIControlStateNormal];
		[matrixSolution setFrame:CGRectMake(10, 20, 80, 80)];
		[matrixSolution addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[matrixSolution setTag:MATSOLLinearEquationButton];
		[matrixSolution setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:matrixSolution];
		
		UIButton *determinant=[UIButton buttonWithType:UIButtonTypeCustom];
		[determinant setBackgroundColor:[UIColor clearColor]];
		[determinant setBackgroundImage:[UIImage imageNamed:@"determinant.png"] forState:UIControlStateNormal];
		[determinant setFrame:CGRectMake(120, 20, 80, 80)];
		[determinant addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[determinant setTag:MATSOLDeterminantButton];
		[determinant setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:determinant];
		
		UIButton *resistorCalculator=[UIButton buttonWithType:UIButtonTypeCustom];
		[resistorCalculator setBackgroundColor:[UIColor clearColor]];
		[resistorCalculator setBackgroundImage:[UIImage imageNamed:@"resistorcalculator.png"] forState:UIControlStateNormal];
		[resistorCalculator setFrame:CGRectMake(230, 20, 80, 80)];
		[resistorCalculator addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[resistorCalculator setTag:MATSOLResistorButton];
		[resistorCalculator setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:resistorCalculator];
		
		UIButton *decoder=[UIButton buttonWithType:UIButtonTypeCustom];
		[decoder setBackgroundColor:[UIColor clearColor]];
		[decoder setBackgroundImage:[UIImage imageNamed:@"decoder.png"] forState:UIControlStateNormal];
		[decoder setFrame:CGRectMake(10, 120, 80, 80)];
		[decoder addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[decoder setTag:MATSOLDecoderButton];
		[decoder setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:decoder];
		
		UIButton *baseConversion=[UIButton buttonWithType:UIButtonTypeCustom];
		[baseConversion setBackgroundColor:[UIColor clearColor]];
		[baseConversion setBackgroundImage:[UIImage imageNamed:@"baseConverter.png"] forState:UIControlStateNormal];
		[baseConversion setFrame:CGRectMake(120, 120, 80, 80)];
		[baseConversion addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[baseConversion setTag:MATSOLBaseConverterButton];
		[baseConversion setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:baseConversion];
        
	}
	if (index==SecondPage) {
		
	}
}

#pragma mark Threads
-(void)beginUIViewController:(id)sender{
#ifdef DEBUG
	NSLog(@"One button was pressed");
#endif
    //	[NSThread detachNewThreadSelector:@selector(creatingUIViewController:) toTarget:self withObject:sender];
    [self performSelector:@selector(creatingUIViewController:) withObject:sender];
}

-(void)alertOnClicked:(GIDAAlertView *)alertView {
    if ([alertView accepted]) {
        int matrixSize = [[alertView enteredText] intValue];
        if ([[alertView title] isEqualToString:NSLocalizedString(@"LinearSize",@"Linear Equation Matrix Size")]) {
            if (matrixSize > 26 || matrixSize <= 1 || [[alertView enteredText] isEqualToString:@""]) {
                GIDAAlertView *gsaExtra = [[GIDAAlertView alloc] initWithPrompt:NSLocalizedString(@"LinearSize" ,@"Linear Equation Matrix Size") cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") acceptButtonTitle:NSLocalizedString(@"Accept", @"Accept")];
                [gsaExtra setDelegate:self];
                [gsaExtra setKeyboard:UIKeyboardTypeNumberPad];
                [gsaExtra show];
            } else {
                GIDAMatrixViewController *viewController = [[GIDAMatrixViewController alloc] initWithMatrixSize:matrixSize andSolver:GIDALinearEquations];
                [self endUIViewController:viewController];
            }
        } else {
            if (matrixSize > 26 || matrixSize <= 1 || [[alertView enteredText] isEqualToString:@""]) {
                GIDAAlertView *gsaExtra = [[GIDAAlertView alloc] initWithPrompt:NSLocalizedString(@"DeterminantSize" ,@"Determinant Matrix Size") cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") acceptButtonTitle:NSLocalizedString(@"Accept", @"Accept") ];
                
                [gsaExtra setKeyboard:UIKeyboardTypeNumberPad];
                [gsaExtra show];
            } else {
                GIDAMatrixViewController *viewController = [[GIDAMatrixViewController alloc] initWithMatrixSize:matrixSize andSolver:GIDADeterminant];
                [self endUIViewController:viewController];
            }
            
        }
    }
}

-(void)creatingUIViewController:(id)sender{
	@autoreleasepool {
        
        //INSERT THE CODE FOR THE NEW THREAD RIGHT HERE
        id viewController = nil;
        
        UIButton *numb=(UIButton *)sender;
        
        if (numb.tag==MATSOLLinearEquationButton) {
#ifdef DEBUG
            NSLog(@"LES");
#endif
            GIDAAlertView *gsa = [[GIDAAlertView alloc] initWithPrompt:NSLocalizedString(@"LinearSize" ,@"Linear Equation Matrix Size") cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") acceptButtonTitle:NSLocalizedString(@"Accept", @"Accept")];
                [gsa setKeyboard:UIKeyboardTypeNumberPad];
            [gsa setDelegate:self];
            [gsa show];
            return ;
        }
        if (numb.tag==MATSOLDeterminantButton) {
#ifdef DEBUG
            NSLog(@"DET");
#endif
            GIDAAlertView *gsa = [[GIDAAlertView alloc] initWithPrompt:NSLocalizedString(@"DeterminantSize" ,@"Determinant Matrix Size")
                                                     cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel")
                                                     acceptButtonTitle:NSLocalizedString(@"Accept", @"Accept")];
            [gsa setKeyboard:UIKeyboardTypeNumberPad];
            [gsa setDelegate:self];
            [gsa show];
            return;
        }
        if (numb.tag==MATSOLResistorButton) {
#ifdef DEBUG
            NSLog(@"RES");
#endif
            viewController=[[InputResistorViewController alloc] initWithNibName:@"InputResistor" bundle:resourcesLocation];
        }
        if (numb.tag==MATSOLDecoderButton) {
#ifdef DEBUG
            NSLog(@"DEC");
#endif
            viewController=[[DecoderViewController alloc] initWithNibName:@"Decoder" bundle:resourcesLocation];
        }
        
        if(numb.tag==MATSOLBaseConverterButton){
#ifdef DEBUG
            NSLog(@"BC");
#endif
            viewController=[[BaseConverterViewController alloc] initWithNibName:@"BaseConverter" bundle:resourcesLocation];
        }
        [self performSelector:@selector(endUIViewController:) withObject:viewController];
    }
}
-(void)endUIViewController:(id)viewController{
	[fatherNavigationController pushViewController:viewController animated:YES];
}

#pragma mark MemoryManagement

@end
