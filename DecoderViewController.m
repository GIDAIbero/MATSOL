//
//  DecoderViewController.m
//  MATSOL
//
//  Created by GIDA01 on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DecoderViewController.h"


@implementation DecoderViewController

@synthesize colorPickerView;
@synthesize valueLabel;
@synthesize toleranceLabel;
@synthesize colorViewsArray;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		[self setTitle:@"Color Decoder"];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	int i=0;
	
	//Set a delegate for the label/textfield
	[valueLabel setDelegate:self];
	
	//Init the color picker view
	colorPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 216)];
	[colorPickerView setDelegate:self];
	[colorPickerView setShowsSelectionIndicator:YES];
	[self.view addSubview:colorPickerView];
	
	
	colorViewsArray=[[NSMutableArray alloc] init];
	//Color bars for the image;
	for (i=0; i<4; i++) {
		[colorViewsArray insertObject:[[UIView alloc] initWithFrame:CGRectMake(102+(i*25), 55, 15, 55)] atIndex:i];
		[[colorViewsArray objectAtIndex:i] setBackgroundColor:[UIColor blackColor]];
		[self.view addSubview:[colorViewsArray objectAtIndex:i]];
	}
	
	//Color & size adjustments 
	[[colorViewsArray objectAtIndex:3] setBackgroundColor:[UIColor whiteColor]];
	[[colorViewsArray objectAtIndex:3] setFrame:CGRectMake(230, 40, 15, 80)];
	
	//Set an initial resistor value for the decoder
	[colorPickerView selectRow:3 inComponent:0 animated:NO];
	[colorPickerView selectRow:3 inComponent:1 animated:NO];
	[colorPickerView selectRow:1 inComponent:2 animated:NO];
	[colorPickerView selectRow:1 inComponent:3 animated:NO];

	[self pickerView:colorPickerView didSelectRow:3 inComponent:2];
}

#pragma mark -
#pragma mark MemoryManagement

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.colorPickerView=nil;
	self.valueLabel=nil;
}

- (void)dealloc {
	[colorPickerView release];
	[valueLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark PickerViewMethods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	switch (component) {
		case MATSOLResistorFirstDigit:
			return 10;
		case MATSOLResistorSecondDigit:
			return 10;
		case MATSOLResistorPower:
			return 12;
		case MATSOLResistorTolerance:
			return 3;
		default:
			return 0;
	}
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	//To re-use the view first check if it is already a usable view if it is not
	//make a re-usable view out of it
	if (view==nil) {
		view=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 45)] autorelease];
		[view setBackgroundColor:[UIColor clearColor]];
		
		//Add a subview to the main view and then make reference as the last subview
		[view addSubview:[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 45)] autorelease]];
		[[[view subviews] objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
		[[[view subviews] objectAtIndex:0] setFont:[UIFont boldSystemFontOfSize:19]];
		[[[view subviews] objectAtIndex:0] setTextAlignment:UITextAlignmentCenter];		
	}
	if (component!=MATSOLResistorTolerance){
		//Add the name of the color
		#ifdef WHITE_FONTS
		if (row==9) {
			//The background color is black, so turn the text into another color
			[[[view subviews] objectAtIndex:0] setTextColor:[UIColor blackColor]];
		}else {
			[[[view subviews] objectAtIndex:0] setTextColor:[UIColor whiteColor]];
		}
		#endif
		#ifdef BLACK_FONTS
		if (row==0) {
			//The background color is black, so turn the text into another color
			[[[view subviews] objectAtIndex:0] setTextColor:[UIColor whiteColor]];
		}else {
			[[[view subviews] objectAtIndex:0] setTextColor:[UIColor blackColor]];
		}
		#endif
		[[[view subviews] objectAtIndex:0] setText:[DecoderViewController stringOrColorForIndex:row isStringOrColor:MATSOLResistorString]];
		[view setBackgroundColor:[DecoderViewController stringOrColorForIndex:row isStringOrColor:MATSOLResistorColor]];
	}
	else {
		//Add the name of the color 
		[[[view subviews] objectAtIndex:0] setText:[DecoderViewController stringOrColorForIndex:row+10 isStringOrColor:MATSOLResistorString]];
		[view setBackgroundColor:[DecoderViewController stringOrColorForIndex:row+10 isStringOrColor:MATSOLResistorColor]];	
	}
	
	return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	int firstDigit,secondDigit,power,tolerance, i=0;
	float value;
	
	//Obtaining the values
	firstDigit=[colorPickerView selectedRowInComponent:0];
	secondDigit=[colorPickerView selectedRowInComponent:1];
	power=[colorPickerView selectedRowInComponent:2];
    switch (power) {
        case 10:
            power = -1;
            break;
        case 11:
            power = -2;
            break;
        default:
            break;
    }
	tolerance=[colorPickerView selectedRowInComponent:3];
	
	#ifdef DEBUG
	NSLog(@"values for components %d %d %d %d",firstDigit,secondDigit,power,tolerance);
	#endif
	
	//Check in every component the current row and change the color in the bar 
	for (i=0; i<[colorViewsArray count]; i++) {
		//First, second and power digits are done this way
		if (i<=2) {
			[[colorViewsArray objectAtIndex:i] setBackgroundColor:[DecoderViewController stringOrColorForIndex:[colorPickerView selectedRowInComponent:i] isStringOrColor:MATSOLResistorColor]];
		}
		if (i==3) {
			//For the tolerance bar, it's a different case
			[[colorViewsArray objectAtIndex:i] setBackgroundColor:[DecoderViewController stringOrColorForIndex:([colorPickerView selectedRowInComponent:i]+10) isStringOrColor:MATSOLResistorColor]];
		}
	}
	
	value = (firstDigit*10 + secondDigit)*pow(10,power) ; 
	
	[valueLabel setText:[NSString stringWithFormat:@"%sΩ",[DecoderViewController formatForResistorValue:value]]];
	
	//Set the tolerance label
	if (tolerance == 0) {
		[toleranceLabel setText:@"± 5%"];
	}
	if (tolerance == 1) {
		[toleranceLabel setText:@"± 10%"];
	}
	if (tolerance == 2) {
		[toleranceLabel setText:@"± 0.05%"];
	}
}

#pragma mark -
#pragma mark Primitives
+ (id)stringOrColorForIndex:(int)index isStringOrColor:(MATSOLResistorColorOrString)type{
	if (type == MATSOLResistorString) {
		return [[NSArray arrayWithObjects:NSLocalizedString(@"Black", @"Black string"),NSLocalizedString(@"Brown", @"Brown string"),NSLocalizedString(@"Red", @"Red string")
                 ,NSLocalizedString(@"Orange", @"Orange string"),NSLocalizedString("Yellow", @"Yellow string"),NSLocalizedString(@"Green", @"Green string")
                 ,NSLocalizedString(@"Blue", @"Blue string"),NSLocalizedString(@"Violet", @"Violet string"),NSLocalizedString(@"Gray", @"Gray string")
                 ,NSLocalizedString(@"White", @"White string"),NSLocalizedString(@"Gold", @"Gold string"),NSLocalizedString(@"Silver", @"Silver string")
                 ,NSLocalizedString(@"Gray", @"Gray string"),nil] objectAtIndex:index];
	}
	if (type == MATSOLResistorColor) {
		return [[NSArray arrayWithObjects:[UIColor blackColor],[UIColor brownColor],[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],
				 [UIColor greenColor],[UIColor blueColor],[UIColor purpleColor],[UIColor grayColor],[UIColor whiteColor], [UIColor colorWithRed:0.85 green:0.77 blue:0.48 alpha:1],
				 [UIColor lightGrayColor],[UIColor grayColor],nil] objectAtIndex:index];
	}
	return nil;
}

#pragma mark Formatter
+ (char *)formatForResistorValue:(float)resistance{
	char *formatedString, suffix;
	int i=0;
	
	//Let's size it 25, though it is almost imposible for that to happen
	formatedString=malloc(sizeof(char)*25);
	
	//Clean this string
	for(i=0;i<25;i++){
		formatedString[i]='\0';
	}
	
	//Is it plain with no suffix
	if (resistance<1000) {
		//Resistance stays the same
		suffix=' ';
	}
	//Is it in the order of K's
	if (resistance>=1000 && resistance<1000000) {
		resistance=resistance/1000;
		suffix='K';
	}
	//It's in the order of M's
	if (resistance>=1000000 && resistance<1000000000) {
		resistance=resistance/1000000;
		suffix='M';
	}
	
	if (resistance>=1000000000){
		resistance=resistance/1000000000;
		suffix='G';
	}
	//Print out the string as it comes.
	//The thing is 56.0 KΩ looks awful
	//	So that's why that little conditional is in there it would only add a .0 to the
	//	number in case it is greater than 10.
	sprintf(formatedString,(resistance<10?"%.1f%c":"%.0f%c"),resistance,suffix);
	
	return formatedString;
} 


@end
