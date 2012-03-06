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

#pragma mark ViewControllerMethods
// Load the view nib and initialize the pageNumber ivar.
- (id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"Slave" bundle:nil]) {
        pageNumber = page;
    }
    return self;
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
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
		[matrixSolution setFrame:CGRectMake(20, 20, 80, 80)];
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
		[resistorCalculator setFrame:CGRectMake(220, 20, 80, 80)];
		[resistorCalculator addTarget:self action:@selector(beginUIViewController:)  forControlEvents:UIControlEventTouchUpInside];
		[resistorCalculator setTag:MATSOLResistorButton];
		[resistorCalculator setShowsTouchWhenHighlighted:YES];
		[self.view addSubview:resistorCalculator];
		
		UIButton *decoder=[UIButton buttonWithType:UIButtonTypeCustom];
		[decoder setBackgroundColor:[UIColor clearColor]];
		[decoder setBackgroundImage:[UIImage imageNamed:@"decoder.png"] forState:UIControlStateNormal];
		[decoder setFrame:CGRectMake(20, 120, 80, 80)];
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
	[NSThread detachNewThreadSelector:@selector(creatingUIViewController:) toTarget:self withObject:sender];
}

-(void)creatingUIViewController:(id)sender{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//INSERT THE CODE FOR THE NEW THREAD RIGHT HERE
    id viewController = nil;
	
	UIButton *numb=(UIButton *)sender;
	
	if (numb.tag==MATSOLLinearEquationButton) {
		#ifdef DEBUG
		NSLog(@"LES");
		#endif
		viewController=[[[SelectionViewController alloc] initWithNibName:@"Selection" bundle:nil] autorelease];
		[viewController setPushViewController:MViewControllerLinearEquationSystem];
	}
	if (numb.tag==MATSOLDeterminantButton) {
		#ifdef DEBUG
		NSLog(@"DET");
		#endif
		viewController=[[[SelectionViewController alloc] initWithNibName:@"Selection" bundle:nil] autorelease];
		[viewController setPushViewController:MViewControllerDeterminant];
	}
	if (numb.tag==MATSOLResistorButton) {
		#ifdef DEBUG
		NSLog(@"RES");
		#endif	
		viewController=[[[InputResistorViewController alloc] initWithNibName:@"InputResistor" bundle:nil] autorelease];
	}
	if (numb.tag==MATSOLDecoderButton) {
		#ifdef DEBUG
		NSLog(@"DEC");
		#endif	
		viewController=[[[DecoderViewController alloc] initWithNibName:@"Decoder" bundle:nil] autorelease];
	}
	
	if(numb.tag==MATSOLBaseConverterButton){
		#ifdef DEBUG
		NSLog(@"BC");
		#endif
		viewController=[[[BaseConverterViewController alloc] initWithNibName:@"BaseConverter" bundle:nil] autorelease];
	}
	[self performSelectorOnMainThread:@selector(endUIViewController:) withObject:viewController waitUntilDone:NO];
    [pool release];
}
-(void)endUIViewController:(id)viewController{
	[fatherNavigationController pushViewController:viewController animated:YES];

}

#pragma mark MemoryManagement
- (void)dealloc {
	[fatherNavigationController release];
    [super dealloc];
}

@end
