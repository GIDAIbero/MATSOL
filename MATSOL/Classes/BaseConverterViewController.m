//
//  BaseConverterViewController.m
//  MATSOL
//
//  Created by GIDA01 on 10/26/10.
//  Copyright 2010 Ingeniería Electrónica -Universidad Iberoamericana. All rights reserved.
//

#import "BaseConverterViewController.h"


@implementation BaseConverterViewController
@synthesize fromLabel;
@synthesize toLabel;
@synthesize fromIndicator;
@synthesize toIndicator;
@synthesize buttonsConverter;
@synthesize mainConverter;
@synthesize backgroundImage;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        [self setTitle:NSLocalizedString(@"Base Converter", @"Base converter title")];
        
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	int i,j,k;

    [super viewDidLoad];
	
    ip5 = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale) >=1136)
        {
            NSLog(@"iPhone 5");
            ip5 = YES;
            [backgroundImage setImage:[UIImage imageNamed:@"BaseConverterBackground-568h@2x.png"]];
        } else {
            [backgroundImage setImage:[UIImage imageNamed:@"BaseConverterBackground.png"]];
        }
    }
    
	buttonsConverter=[[NSMutableArray alloc] init];
	
	//Button interface is placed trough the view
	//Look carefully for each state and it's properties
    int max = 4;
    int offset = 0;
    if (ip5) {
        max = 5;
        offset = 15;
    }
	for (j=0; j<=max; j++) {
		for(i=0;i<4;i++){
            if (ip5) {
                k = -(-i+(j*4)-17);
            } else {
                k = -(-i+(j*4)-13);
            }
			[buttonsConverter insertObject:[UIButton  buttonWithType:UIButtonTypeCustom] atIndex:(j*4)+i];
            [[buttonsConverter objectAtIndex:i+(j*4)] setFrame:CGRectMake(i*75+12,j*55+130+offset,70,50)];
			[[buttonsConverter objectAtIndex:i+(j*4)] setShowsTouchWhenHighlighted:NO];
			[[buttonsConverter objectAtIndex:i+(j*4)] setTag:k]; //tag is set for debugging issues
			[[buttonsConverter objectAtIndex:i+(j*4)] addTarget:self action:@selector(typeStuff:) forControlEvents:UIControlEventTouchUpInside];
			if (k >= 10) {
                [[buttonsConverter objectAtIndex:i+(j*4)] setTitle:[NSString stringWithFormat:@"%c",'A'+k-10] forState:UIControlStateNormal];
            } else {
                [[buttonsConverter objectAtIndex:i+(j*4)] setTitle:[NSString stringWithFormat:@"%X",k] forState:UIControlStateNormal];
            }
			[[buttonsConverter objectAtIndex:i+(j*4)] setBackgroundImage:[UIImage imageNamed:@"blackButton.png"] forState:UIControlStateNormal];

			[[buttonsConverter objectAtIndex:i+(j*4)] setBackgroundImage:[UIImage imageNamed:@"crossedBlackButton.png"] forState:UIControlStateDisabled];
			[[buttonsConverter objectAtIndex:i+(j*4)] setTitle:@"" forState:UIControlStateDisabled];
			[self.view addSubview:[buttonsConverter objectAtIndex:i+(j*4)]];
        }
	}
    i = max * 4;
    
	//definitions for specific buttons!
    if (ip5) {
        [[buttonsConverter objectAtIndex:i] setFrame:CGRectMake(12,405+offset,145,50)];
    } else {
        [[buttonsConverter objectAtIndex:i] setFrame:CGRectMake(12,350+offset,145,50)];
    }
	[[buttonsConverter objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"zeroButton.png"] forState:UIControlStateNormal];
	[[buttonsConverter objectAtIndex:i] setTag:0];
	[[buttonsConverter objectAtIndex:i] setTitle:@"0" forState:UIControlStateNormal ];
	
	[[buttonsConverter objectAtIndex:i+2] setTag:MBaseConverterButtonFrom];
    [[buttonsConverter objectAtIndex:i+2] setTitle:NSLocalizedString(@"From", @"From string") forState:UIControlStateNormal ];
	[[buttonsConverter objectAtIndex:i+2] setBackgroundImage:[UIImage imageNamed:@"brownButton.png"] forState:UIControlStateNormal];
	[[buttonsConverter objectAtIndex:i+2] removeTarget:self action:@selector(typeStuff:) forControlEvents:UIControlEventTouchUpInside];
	[[buttonsConverter objectAtIndex:i+2] addTarget:self action:@selector(fromOrTo:) forControlEvents:UIControlEventTouchUpInside];
	
	[[buttonsConverter objectAtIndex:i+3] setTag:MBaseConverterButtonTo];
	[[buttonsConverter objectAtIndex:i+3] setTitle:NSLocalizedString(@"To", @"To string") forState:UIControlStateNormal ];
	[[buttonsConverter objectAtIndex:i+3] setBackgroundImage:[UIImage imageNamed:@"brownButton.png"] forState:UIControlStateNormal];
	[[buttonsConverter objectAtIndex:i+3] removeTarget:self action:@selector(typeStuff:) forControlEvents:UIControlEventTouchUpInside];
	[[buttonsConverter objectAtIndex:i+3] addTarget:self action:@selector(fromOrTo:) forControlEvents:UIControlEventTouchUpInside];
	
	[[buttonsConverter objectAtIndex:3] setTag:MBaseConverterButtonDelete];
	[[buttonsConverter objectAtIndex:3] setTitle:@" " forState:UIControlStateNormal];
	[[buttonsConverter objectAtIndex:3] setBackgroundImage:[UIImage imageNamed:@"deleteBlackButton.png"] forState:UIControlStateNormal];
	[[buttonsConverter objectAtIndex:i+1] removeFromSuperview]; //destroying an unnecesary button
	
	//Initialize the main indicators, to change from base 10 to base 2
	mainConverter=[[Conversor alloc] init];
	[mainConverter setFromBase:10];
	[mainConverter setToBase:2];
	[mainConverter setNumber:0];
	
	//Set the UI indicators
	[[self fromIndicator] setText:NSLocalizedString(@"From: 10", @"From label")];
	[[self toIndicator] setText:NSLocalizedString(@"To: 2", @"To label")];
	
	//Update the UI
	[self lockButtons];
	
}

#pragma mark -
#pragma mark Buttons Utilities

-(void)typeStuff:(id)sender{
	UIButton *whoAmI=(UIButton *)sender;
	
	NSString *temp;

	temp =fromLabel.text;
	
  	if(whoAmI.tag == -3){
		if ([temp length]>1) {
			[fromLabel setText:[NSString stringWithCharacters:(unichar *)[temp cStringUsingEncoding:NSUnicodeStringEncoding] length:[temp length]-1]];
		}
		else {
			[fromLabel setText:@"0"];
		}

	}
	else {
		if([temp length]==1 && [temp characterAtIndex:0] == '0'){
			[fromLabel setText:[NSString stringWithFormat:@"%c",[[whoAmI currentTitle] characterAtIndex:0]]];
		}
		else{
			[fromLabel setText:[fromLabel.text stringByAppendingString:[whoAmI currentTitle]]];
		}
	}

	[mainConverter setNumber:[fromLabel text]];
	[toLabel setText:[mainConverter number]];
	
	#ifdef DEBUG
	NSLog(@"Values for MainConverter From Base: [%d] To Base: [%d] Input: [%@] Output: [%@]",[mainConverter fromBase],[mainConverter toBase],[fromLabel text],[mainConverter number]);
	NSLog(@"Who am I: %d",whoAmI.tag);
	NSLog(@"My Title: %c",[[whoAmI currentTitle] characterAtIndex:0]);
	#endif
}

-(IBAction)fromOrTo:(id)sender{
	UIButton *whoAmI=(UIButton *)sender;
	
	//Add a bunch of NewLines to the title to fit the base into the action sheet
	NSString *stringOffset=@"\n\n\n\n\n\n\n\n\n\n\n\n";
	NSString *titleString=[NSString stringWithFormat:@"%@%@", stringOffset, NSLocalizedString(@"Select a Base", @"")];

	#ifdef DEBUG
	NSLog(@"Tag of the button pressed: %d",whoAmI.tag);
	#endif
	
	//Initialize the bases array
	if (_basesArray==nil) {
        if (ip5) {
            _basesArray=[[NSArray alloc] initWithObjects:
                         NSLocalizedString(@"Binary (2)", @"Binary string"),
                         NSLocalizedString(@"Ternary (3)", @"Ternary string"),
                         NSLocalizedString(@"Quaternary (4)", @"Quaternary string"),
                         NSLocalizedString(@"Quinary (5)", @"Quinary string"),
                         NSLocalizedString(@"Senary (6)", @"Senary string"),
                         NSLocalizedString(@"Septenary (7)", @"Septenary string"),
                         NSLocalizedString(@"Ocatal (8)", @"Octal string"),
                         NSLocalizedString(@"Nonary (9)", @"Nonary string"),
                         NSLocalizedString(@"Decimal (10)", @"Decimal string"),
                         NSLocalizedString(@"Undecimal (11)", @"Undecimal string"),
                         NSLocalizedString(@"Duodecimal (12)", @"Duodecimal string"),
                         NSLocalizedString(@"Tridecimal (13)", @"Tridecimal string"),
                         NSLocalizedString(@"Tetradecimal (14)", @"Tetradecimal string"),
                         NSLocalizedString(@"Pentadecimal (15)", @"Pentadecimal string"),
                         NSLocalizedString(@"Hexadecimal (16)", @"Hexadecimal string"),
                         @"Septendecimal (17)",
                         @"Decennoctal (18)",
                         @"Decennoval (19)",
                         @"Vigesimal (20)",
                         nil];
        } else {
            _basesArray=[[NSArray alloc] initWithObjects:NSLocalizedString(@"Binary (2)", @"Binary string"), NSLocalizedString(@"Ternary (3)", @"Ternary string"),
                     NSLocalizedString(@"Quaternary (4)", @"Quaternary string"), NSLocalizedString(@"Quinary (5)", @"Quinary string"), NSLocalizedString(@"Senary (6)", @"Senary string"), NSLocalizedString(@"Sevenary (7)", @"Sevenary string"),
                     NSLocalizedString(@"Ocatal (8)", @"Octal string"), NSLocalizedString(@"Nonary (9)", @"Nonary string"), NSLocalizedString(@"Decimal (10)", @"Decimal string"),
                     NSLocalizedString(@"Undecimal (11)", @"Undecimal string"), NSLocalizedString(@"Duodecimal (12)", @"Duodecimal string"), NSLocalizedString(@"Tridecimal (13)", @"Tridecimal string"),
                     NSLocalizedString(@"Tetradecimal (14)", @"Tetradecimal string"), NSLocalizedString(@"Pentadecimal (15)", @"Pentadecimal string"), NSLocalizedString(@"Hexadecimal (16)", @"Hexadecimal string"),nil];
        }
	}
	
	//Init the Action sheet
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Select", @"Select tag button"), nil];
	[actionSheet showInView:self.view];
	[actionSheet setDelegate:self];
	
	//Customize the DatePicker
	UIPickerView *basePicker = [[UIPickerView alloc] init];
	[basePicker setShowsSelectionIndicator:YES];
	[basePicker setDelegate:self];
	
	#ifdef DEBUG
	NSLog(@"Current From: [%d] Current To: [%d]",[mainConverter toBase],[mainConverter fromBase]);
	#endif
	
	if (whoAmI.tag == MBaseConverterButtonTo) {
		[basePicker selectRow:[mainConverter toBase]-2 inComponent:0 animated:NO];
		
		//If we don't do this, crazy things happen, all we are doing is re-selecting the
		//same base as the one that was already selected to ensure that a base is selected at least
		[self pickerView:basePicker didSelectRow:[mainConverter toBase]-2 inComponent:0];

	}
	if (whoAmI.tag == MBaseConverterButtonFrom) {
		[basePicker selectRow:[mainConverter fromBase]-2 inComponent:0 animated:NO];
		
		//If we don't do this, crazy things happen, all we are doing is re-selecting the
		//same base as the one that was already selected to ensure that a base is selected at least
		[self pickerView:basePicker didSelectRow:[mainConverter fromBase]-2 inComponent:0];
	}
	
	//Add the date picker and show the action sheet
	[actionSheet addSubview:basePicker];
	[basePicker release];
	
	//Set the indicator to update the values
	_currentActionSheet=whoAmI.tag;
}

-(void)lockButtons{
	int i=0;
	UIButton *temp;
    int max = 16;
	if (ip5) {
        max = 20;
    }
    
	for (i=0; i<max; i++) {
		//Disable these buttons
		if (i>=[mainConverter fromBase]) {
			temp=(UIButton *)[[self view] viewWithTag:i];
			[temp setEnabled:NO];
			temp=nil;
		}//Enable these buttons
		else {
			temp=(UIButton *)[[self view] viewWithTag:i];
			[temp setEnabled:YES];
			temp=nil;	
		}
		
	}
}

#pragma mark -
#pragma mark UIPickerViewDelegateMethods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	//We only have one component in our picker view
	//in this case is the component of with all the 
	//available
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	//How many rows do we have? I don't know let's ask the array
	
	switch (component){
		case 0:
			return [_basesArray count];
		default:
			return 0;
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	//Each row will get it's title with each array
	switch (component) {
		case 0:
			return [_basesArray objectAtIndex:row];
		default:
			break;
	}
	
	//Return an empty string
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	//If the PickerView is scrolled, this method will be called.
	_pickedBase=row+2;
}

#pragma mark -
#pragma mark UI actionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	#ifdef DEBUG
	NSLog(@"Button Pressed in the Action Sheet, the selected base is %d",_pickedBase);
	#endif
	
	int oldFromBase=0, oldToBase=0;
	
	oldFromBase=[mainConverter fromBase];
	oldToBase=[mainConverter toBase];
	
	if (_currentActionSheet == MBaseConverterButtonTo) {
		[mainConverter setToBase:_pickedBase];
		[toIndicator setText:[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"To", @"To string"),_pickedBase]];
		//Updating the "to base" then convert the base
		[mainConverter setNumber:[fromLabel text]];
		[toLabel setText:[NSString stringWithFormat:@"%@",[mainConverter number]]];
		
	}
	if (_currentActionSheet == MBaseConverterButtonFrom) {
		//Changing from, then convert the current from to the new base
		[mainConverter setToBase:_pickedBase];
		[mainConverter setFromBase:oldFromBase];		
		[mainConverter setNumber:[[self fromLabel] text]];
		[fromLabel setText:[NSString stringWithFormat:@"%@",[mainConverter number]]];
		
		//Set the base values to the default
		[mainConverter setFromBase:_pickedBase];
		[mainConverter setToBase:oldToBase];
		
		[fromIndicator setText:[NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"From", @"From string"),_pickedBase]];
		[self lockButtons];
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)viewDidUnload {
    [self setBackgroundImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.fromLabel=nil;
	self.toLabel=nil;
	self.fromIndicator=nil;
	self.toIndicator=nil;
}

- (void)dealloc {	
	[buttonsConverter release];
	[mainConverter release];
	[fromLabel release];
	[toLabel release];
	[fromIndicator release];
	[toIndicator release];
    [_basesArray release];
    
    [backgroundImage release];
    [super dealloc];
}


@end
