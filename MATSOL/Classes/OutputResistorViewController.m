//
//  OutputResistorViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 25/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "OutputResistorViewController.h"
#pragma mark -

static NSArray *colorsArray = nil;
static float kAnimationDuration=0.35;

@interface OutputResistorViewController() {
    BOOL rotated;
    BOOL lRotated;
}
@property (nonatomic, retain) UIView *colorArray;
@end
@implementation OutputResistorViewController

@synthesize targetResistor;
@synthesize tolerance;
@synthesize sign;
@synthesize network;
@synthesize reminder;
@synthesize achieved;
@synthesize	bandArray;
@synthesize resourcesLocation;

#pragma mark Initialization
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		network=malloc(sizeof(RESIST)*5);
		resourcesLocation = nibBundleOrNil;
		//We set this to nil to guarantee no crashings
		//if a object that points to nil calls a method everything is ok :)
		_backup=nil;
		
		[self setTitle:NSLocalizedString(@"Results", @"Results string")];
	}
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	int size=0, i=0;

	//Reminder label
	[reminder setText:[NSString stringWithFormat:@"%.2f",targetResistor]];
	
	//Create the sign
	sign=[UIButton buttonWithType:UIButtonTypeCustom];
	[sign setBackgroundColor:[UIColor clearColor]];
	[sign setBackgroundImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"signW" ofType:@"png"]] forState:UIControlStateNormal];
	[sign setFrame:CGRectMake(0, 0, kSignImageWidth, kSignImageHeight)];
	[sign setHidden:YES];
	[sign addTarget:self action:@selector(signWasPressed:)  forControlEvents:UIControlEventTouchUpInside];
	
	//Create and init the resistor bands
	bandArray=[[NSMutableArray alloc] init];
    _colorArray = [[UIView alloc] initWithFrame:CGRectMake(33, 21, 81, kFirstBandHeight)];
	for (i=0; i<4; i++) {
		[bandArray insertObject:[[UIView alloc] initWithFrame:CGRectMake(4+(i*kBandOffsetX), 3, kBandWidth, kBandHeight)] atIndex:i];
		[[bandArray objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];
		[_colorArray addSubview:[bandArray objectAtIndex:i]];
	}
	[sign addSubview:_colorArray];
	//Custom for the bands settings
	[[bandArray objectAtIndex:0] setFrame:CGRectMake(0, 0, kBandWidth, kFirstBandHeight)];
	[[bandArray objectAtIndex:3] setFrame:CGRectMake(54, 0, kBandWidth, kLastBandHeight)];
	[[bandArray objectAtIndex:3] setBackgroundColor:[UIColor colorWithRed:0.85 green:0.77 blue:0.2 alpha:0.8]];
	
	//Now let's create the label
	[bandArray insertObject:[[UILabel alloc] initWithFrame:CGRectMake(0, kResistorLabelY, kSignImageWidth, kResistorLabelHeight)] atIndex:kResistorLabelPositionInArray];
	[[bandArray objectAtIndex:kResistorLabelPositionInArray] setBackgroundColor:[UIColor clearColor]];
	[[bandArray objectAtIndex:kResistorLabelPositionInArray] setTextColor:[UIColor whiteColor]];
	[[bandArray objectAtIndex:kResistorLabelPositionInArray] setAdjustsFontSizeToFitWidth:YES];
	[[bandArray objectAtIndex:kResistorLabelPositionInArray] setText:@"1000000"];
	[[bandArray objectAtIndex:kResistorLabelPositionInArray] setTextAlignment:UITextAlignmentCenter];
	[sign addSubview:[bandArray objectAtIndex:kResistorLabelPositionInArray]];
	
	//Compute Values
	#ifndef ALGORITHM_TEST
	#ifdef DEBUG
	NSLog(@"Testing the interaction");
	#endif
	size=networkCalc(network, targetResistor, tolerance);
	[self placeNetworkWithNetworkSize:size];
	#endif
	
	//All things coded under the constant ALGORITHM_TEST should
	//be gone in the next versions, this is just to test
	#ifdef ALGORITHM_TEST
	size=5;
	
	network[0].R1=111;
	network[0].R2=222;
	network[0].Req=100;
	network[0].seriesParallel=ResistorArrangeTypeSeriesFirst;
	
	network[1].R1=333;
	network[1].R2=444;
	network[1].Req=98.2;
	network[1].seriesParallel=ResistorArrangeTypeSeriesFirst;
	
	network[2].R1=555;
	network[2].R2=666;
	network[2].Req=470;
	network[2].seriesParallel=ResistorArrangeTypeSeriesFirst;
	
	network[3].R1=100;
	network[3].R2=220;
	network[3].Req=78;
	network[3].seriesParallel=ResistorArrangeTypeSeriesFirst;
	
	network[4].R1=100;
	network[4].R2=220;
	network[4].Req=78;
	network[4].seriesParallel=ResistorArrangeTypeParallel;
	
	[self placeNetworkWithNetworkSize:size];
	#endif
	
	//Let's add it @ the end to guarantee it will be on top
	[self.view addSubview:sign];
    rotated  = NO;
    lRotated = NO;
}

#pragma mark NetworkDrawing
- (void)placeNetworkWithNetworkSize:(int)networkSize{
	#ifdef DEBUG
	NSLog(@"Placing the complete network");
	#endif
	
	//General purpose object pointers
	UIImageView *resistorImage;
	UIButton *buttonLabel;
	UILabel *temp;
	
	//Variable rects, since every cicle different views are created
	CGRect resistorPlacement=CGRectMake(kResistorX, kResistorY, kImageWidth, kImageHeight);
	CGRect labelButtonPlacementTop=CGRectMake(kLabelButtonTopX, kLabelButtonTopY, kLabelButtonWidth, kLabelButtonHeight);
	CGRect labelButtonPlacementBottom=CGRectMake(kLabelButtonBottomX, kLabelButtonBottomY, kLabelButtonWidth, kLabelButtonHeight);
	
	//This accumulative vars keep track of the position for every label
	float currentResistorX=kResistorX,currentResistorY=kResistorY;
	float currentTopX=kLabelButtonTopX, currentTopY=kLabelButtonTopY;
	float currentBottomX=kLabelButtonBottomX, currentBottomY=kLabelButtonBottomY;
	float currentWireY=kWireY;
	
	//General purpose vars, accumulation keeps track of the achieved resistance
	float accumulation=0.0;
	int i=0, direction=0, totalResistors=0;
	char *pointer;
	
	//Main placement loop
	//Will place step by step a resistor picture with it's labels
	for (i=0; i<networkSize; i++) {
		//Is this sub-network a parallel network
		
		if (network[i].seriesParallel == ResistorArrangeTypeParallel) {
			#ifdef DEBUG
			NSLog(@"Parallel Arrangement");
			#endif
			
			pointer=[OutputResistorViewController formatForResistorValue:network[i].R1];
			
			//Keep track of the total equivalent value of the network
			accumulation=accumulation+network[i].Req;
			
			//Create add and alloc an image with two resistors in parallel
			resistorImage=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"presistor" ofType:@"png"]]];
			[resistorImage setFrame:resistorPlacement];
			[self.view addSubview:resistorImage];
			
			//The top label comes with every resistors arrangement			
			buttonLabel=[UIButton buttonWithType:UIButtonTypeCustom];
			[buttonLabel setTitle:[NSString stringWithFormat:@"%sΩ",pointer] forState:UIControlStateNormal];
			[buttonLabel setFrame:labelButtonPlacementTop];
			[buttonLabel setBackgroundColor:[UIColor clearColor]];
			[buttonLabel setShowsTouchWhenHighlighted:YES];
			[[buttonLabel titleLabel] setTextColor:[UIColor whiteColor]];
			[buttonLabel addTarget:self action:@selector(buttonPressed:)  forControlEvents:UIControlEventTouchUpInside];
            buttonLabel.tag = i+1;
			//Get the pointer of the label (read-only)
			temp=[buttonLabel titleLabel];
			//modify the before (read-only) property
			[temp setAdjustsFontSizeToFitWidth:YES];
			[self.view addSubview:buttonLabel];
			 
			 free(pointer);
			 pointer=[OutputResistorViewController formatForResistorValue:network[i].R2];
			
			//The bottom label only comes with a parallel arrangement
			buttonLabel=[UIButton buttonWithType:UIButtonTypeCustom];
			[buttonLabel setTitle:[NSString stringWithFormat:@"%sΩ",pointer] forState:UIControlStateNormal];
			[buttonLabel setFrame:labelButtonPlacementBottom];
			[buttonLabel setBackgroundColor:[UIColor clearColor]];
			[buttonLabel setShowsTouchWhenHighlighted:YES];
			[[buttonLabel titleLabel] setTextColor:[UIColor whiteColor]];
			[buttonLabel addTarget:self action:@selector(buttonPressed:)  forControlEvents:UIControlEventTouchUpInside];
			//Get the pointer of the label (read-only)
			temp=[buttonLabel titleLabel];
            buttonLabel.tag = 2;
			//modify the before (read-only) property
			[temp setAdjustsFontSizeToFitWidth:YES];
			[self.view addSubview:buttonLabel];
			 
			 free(pointer);

		}
		
		//Is it a series sub-network?
		//Is it the first or the second resistor in the sub-network?
		if (network[i].seriesParallel == ResistorArrangeTypeSeriesFirst || network[i].seriesParallel == ResistorArrangeTypeSeriesSecond) {
			#ifdef DEBUG
			NSLog(@"Series arrangement, R1:[%f] & R2:[%f] index:[%d]",network[i].R1,network[i].R2,i);
			#endif
			
			pointer=[OutputResistorViewController formatForResistorValue:network[i].seriesParallel==ResistorArrangeTypeSeriesFirst ? network[i].R1 : network[i].R2];
			
			//Create add and alloc an image with one resistor
			resistorImage=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"sresistor" ofType:@"png"]]]; //Señor resistor... classy
			[resistorImage setFrame:resistorPlacement];
			[self.view addSubview:resistorImage];
			
			//The top label comes with every resistors arrangement
			buttonLabel=[UIButton buttonWithType:UIButtonTypeCustom];
			//if it is the first resistor in the series network place the R1 value else the R2 value
			[buttonLabel setTitle:[NSString stringWithFormat:@"%sΩ",pointer] forState:UIControlStateNormal];
			[buttonLabel setFrame:labelButtonPlacementTop];
			[buttonLabel setBackgroundColor:[UIColor clearColor]];
			[buttonLabel setShowsTouchWhenHighlighted:YES];
			[[buttonLabel titleLabel] setTextColor:[UIColor whiteColor]];
			[buttonLabel addTarget:self action:@selector(buttonPressed:)  forControlEvents:UIControlEventTouchUpInside];
			//Get the pointer of the label (read-only)
			temp=[buttonLabel titleLabel];
			//modify the before (read-only) property
			[temp setAdjustsFontSizeToFitWidth:YES];
                buttonLabel.tag = 1;
			[self.view addSubview:buttonLabel];
			
			free(pointer);
			
			//Minus one from the flag; this will take the constant ResistorArrangemeTypeSeriesFirst
			//to the value of ResistorArrangeTypeSeriesSecond
			network[i].seriesParallel=network[i].seriesParallel-1;
			
			//If it is going to place the second in the next cycle then we will
			//have to take back i 
			if (network[i].seriesParallel == ResistorArrangeTypeSeriesSecond) {
				
				//If the second resistor is cero, we should better print nothing
				if (network[i].R2<1) {
					network[i].seriesParallel=network[i].seriesParallel-1;
				}
				
				accumulation=accumulation+network[i].Req;
				i=i-1;
			}
		}

		//The images are moving to the right
		if (direction<=2) {
			currentResistorX=currentResistorX+kImageWidth-1;
			currentTopX=currentTopX+kImageWidth-1;
			currentBottomX=currentBottomX+kImageWidth-1;
		}
		
		//The images are moving to the left
		if (direction>=3) {
			currentResistorX=currentResistorX-kImageWidth+1;
			currentTopX=currentTopX-kImageWidth+1;
			currentBottomX=currentBottomX-kImageWidth+1;
		}
		
		//We are shifting rows? well let's add offset to the resistor
		//to the LEFT
		if ((totalResistors % 6) == 2) {
			//Add the offset to create another line
			currentResistorY=currentResistorY+kRowOffset;
			currentTopY=currentTopY+kRowOffset;
			currentBottomY=currentBottomY+kRowOffset;
			
			//Go back one kImageWidth to make the network all classy
			//and fancy
			currentResistorX=currentResistorX-kImageWidth+1;
			currentTopX=currentTopX-kImageWidth+1;
			currentBottomX=currentBottomX-kImageWidth+1;
		}
		//We are shifting rows? well let's add offset to the resistor
		//to the RIGHT
		if ((totalResistors % 6) == 5) {
			//Add a little offset for the new line
			currentResistorY=currentResistorY+kRowOffset;
			currentTopY=currentTopY+kRowOffset;
			currentBottomY=currentBottomY+kRowOffset;
			
			//Align back the network
			currentResistorX=currentResistorX+kImageWidth-1;
			currentTopX=currentTopX+kImageWidth-1;
			currentBottomX=currentBottomX+kImageWidth-1;
		}
		
		if ((totalResistors % 6) == 3) {
			//Add offset to the wire
			currentWireY=currentWireY+kRowOffset;
			
			//Place the wire with the kWireXRight constant since this is going to be
			//on the right side of the screen
			resistorImage=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"wire" ofType:@"png"]]];
			[resistorImage setFrame:CGRectMake(kWireXRight, currentWireY, kWireWidth, kWireHeight)];
			[self.view addSubview:resistorImage];
			
		}
		if ( ((totalResistors % 6)) == 0 && (totalResistors!=0)) {
			//Add the offset for the wire
			currentWireY=currentWireY+kRowOffset;
			
			//Place the wire with the kWireXLeft constant since this is going to be
			//on the left side of the screen 
			resistorImage=[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"wire" ofType:@"png"]]];
			[resistorImage setFrame:CGRectMake(kWireXLeft, currentWireY, kWireWidth, kWireHeight)];
			[self.view addSubview:resistorImage];
		}
		
		//All values should be updated, this will be helpful, the values
		//are only updated once per cycle which results in less lines
		resistorPlacement=CGRectMake(currentResistorX, currentResistorY, kImageWidth, kImageHeight);
		labelButtonPlacementTop=CGRectMake(currentTopX, currentTopY, kLabelButtonWidth, kLabelButtonHeight);
		labelButtonPlacementBottom=CGRectMake(currentBottomX, currentBottomY, kLabelButtonWidth, kLabelButtonHeight);
		
		//Restart the direction counter
		if (direction>=5) {
			direction=0;
		}
		
		direction++;
		totalResistors++;
	}
	
	//Set the label for the achieved value @ the UI
	[achieved setText:[NSString stringWithFormat:@"%.2f",accumulation]];
}

#pragma mark MemoryManagement
- (void)viewDidUnload{
	[super viewDidUnload];
	self.reminder=nil;
	self.achieved=nil;
	self.sign=nil;
	self.bandArray=nil;
} 

- (void)dealloc {
	free(network);
}

#pragma mark ButtonMethodsAndColorCodeDrawing
- (void)buttonPressed:(id)sender{
	
	UIButton *touched=(UIButton *)sender;
	
	#ifdef DEBUG
	NSLog(@"Button Pressed with value %@",[[touched titleLabel] text]);
	#endif
	
		
	//Let's just show the button when a different button calls for it
	//If the same button is calling it again and again the sign will only be
	//shown and set once
	if (touched.center.y!=(sign.center.y-kSignOffsetY) || touched.center.x!=sign.center.x) {
		
		//First, show backup in case it exists it will show the last hidden button
		//Then, back up the new touched button into _backup
		[_backup setHidden:NO];
		_backup=touched;
		
		//Show the sign
		[sign setHidden:NO];
		
		//Place the view at the center of the resistor label
		[sign setCenter:CGPointMake(touched.center.x, touched.center.y)];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        if (touched.tag == 2) {
            transform = CGAffineTransformRotate(transform, M_PI);
            rotated = YES;
        } else {
            rotated = NO;
        }
		//Make the view 10 times smaller
		[sign setTransform:transform];
  

        //Anitmations for iOS 4
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5) {
            [UIView beginAnimations:@"Animated Sign showing" context:nil];
            [UIView setAnimationDuration:kAnimationDuration];
            
            //Make it ten times bigger and add the offset to the 'y' coordinate
            [sign setTransform:CGAffineTransformScale(sign.transform, 10, 10)];
            [sign setCenter:CGPointMake(touched.center.x, touched.center.y+kSignOffsetY)];
            
            //Hide the label/button
            [_backup setHidden:YES];
            
            [UIView commitAnimations];
        }
        else if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5){
            [UIView animateWithDuration:kAnimationDuration animations:^{
                //Make it ten times bigger and add the offset to the 'y' coordinate
                [sign setTransform:CGAffineTransformScale(sign.transform, 10, 10)];
                [sign setCenter:CGPointMake(touched.center.x, touched.center.y+kSignOffsetY)];
     
                //Hide the label/button
                [_backup setHidden:YES];
                
            }];
        }
        if (touched.tag == 2) {
            CGRect frame = sign.frame;
            frame.origin.y += 80;
            sign.frame = frame;
        }
		
		//Coloring the bands and setting the label
		[self bandColorsForLabel:[[touched titleLabel] text]];
	}	
}

- (void)signWasPressed:(id)sender{
	//Hide the view, the center is to make it easier to identify
	//when a view must be animated again
	[_backup setHidden:NO];
	[sign setHidden:YES];
	[sign setCenter:CGPointMake(0,0)];

}

- (void)bandColorsForLabel:(NSString *)theValue{
	NSString *medium=[theValue stringByReplacingOccurrencesOfString:@"Ω" withString:@""];
	NSString *temp;
	float numeric = 0;
	const char *myString, *format;
	//Initialized @ -1 to make the algorithm flow, cause you know arrays in C start @ 0
	int counter=-1;
	
	format=[medium cStringUsingEncoding:NSASCIIStringEncoding];
	medium = [medium stringByAppendingString:@"Ω"];
	if (format[strlen(format)-1]==' ') {
		temp=[theValue stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		//This value becomes useful as a float
		numeric=[temp floatValue];
		//Take the string and remove the Ω character in it then set it as the text on the label
		[[bandArray objectAtIndex:kResistorLabelPositionInArray] setText:medium];
		
		//Print the converted value into a C string
		myString=[[NSString stringWithFormat:@"%f",numeric] cStringUsingEncoding:NSASCIIStringEncoding];
		
		if (numeric<10.0) {
			//Set the first band color
			//Basically for the first two bands we take the ASCII value & take that color from the
			//colors array
			[[bandArray objectAtIndex:0] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[0]-48]];
			//Set the second band color
			[[bandArray objectAtIndex:1] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[2]-48]];
			//Set the third band color
			[[bandArray objectAtIndex:2] setBackgroundColor:[OutputResistorViewController bandColorForNumber:10]];
		
			return;
		}
		
	}	
	if (format[strlen(format)-1]=='K') {
		temp=[theValue stringByReplacingOccurrencesOfString:@"K" withString:@""];
		counter=counter+3;
		
		//This value becomes useful as a float
		numeric=[temp floatValue];
		//Take the string and remove the Ω character in it then set it as the text on the label
		[[bandArray objectAtIndex:kResistorLabelPositionInArray] setText:medium];
		
		//Print the converted value into a C string
		myString=[[NSString stringWithFormat:@"%f",numeric] cStringUsingEncoding:NSASCIIStringEncoding];
		
		#ifdef DEBUG
		NSLog(@"Converted and divided string is: [%s] first band: [%d] second band: [%d]",myString,myString[0]-48,myString[2]-48);
		#endif
		
		if (numeric<10.0) {
			//Set the first band color
			//Basically for the first two bands we take the ASCII value & take that color from the
			//colors array
			[[bandArray objectAtIndex:0] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[0]-48]];
			//Set the second band color
			[[bandArray objectAtIndex:1] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[2]-48]];
			//Set the third band color
			[[bandArray objectAtIndex:2] setBackgroundColor:[OutputResistorViewController bandColorForNumber:counter]];
			
			return;
		}
		
	}	
	if (format[strlen(format)-1]=='M') {
		temp=[theValue stringByReplacingOccurrencesOfString:@"M" withString:@""];
		counter=counter+6;
		
		//This value becomes useful as a float
		numeric=[temp floatValue];
		//Take the string and remove the Ω character in it then set it as the text on the label
		[[bandArray objectAtIndex:kResistorLabelPositionInArray] setText:medium];
		
		//Print the converted value into a C string
		myString=[[NSString stringWithFormat:@"%f",numeric] cStringUsingEncoding:NSASCIIStringEncoding];
		
		#ifdef DEBUG
		NSLog(@"Converted and divided string is: [%s] first band: [%d] second band: [%d]",myString,myString[0]-48,myString[2]-48);
		#endif
		
		if (numeric<10.0) {
			//Set the first band color
			//Basically for the first two bands we take the ASCII value & take that color from the
			//colors array
			[[bandArray objectAtIndex:0] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[0]-48]];
			//Set the second band color
			[[bandArray objectAtIndex:1] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[2]-48]];
			//Set the third band color
			[[bandArray objectAtIndex:2] setBackgroundColor:[OutputResistorViewController bandColorForNumber:counter]];
			
			return;
		}		
	}
    if ((rotated && !lRotated) || (!rotated && lRotated)) {
        UILabel *lab = ((UILabel *)[bandArray objectAtIndex:kResistorLabelPositionInArray]);
        lab.transform = CGAffineTransformRotate(lab.transform,M_PI);
        CGRect frame = _colorArray.frame;
        if (!rotated) {
        frame.origin.x = 33;
        } else {
            frame.origin.x = 13;
        }
        _colorArray.transform = CGAffineTransformRotate(_colorArray.transform,M_PI);
        _colorArray.frame = frame;
         if (!lRotated) {
            lRotated = YES;
        } else {
            lRotated = NO;
        }
    }

	//Divide, until you get a value that is less than 10 so that we can know the
	//value for the third band
	do{
		numeric=numeric/10;
		counter=counter+1;
	}while (numeric>=10);
	
	//Print the converted value into a C string
	myString=[[NSString stringWithFormat:@"%f",numeric] cStringUsingEncoding:NSASCIIStringEncoding];
	
	#ifdef DEBUG
	NSLog(@"#GENERAL# Converted and divided string is: [%s] first band: [%d] second band: [%d]",myString,myString[0]-48,myString[2]-48);
	#endif
	
	//Set the first band color
	//Basically for the first two bands we take the ASCII value & take that color from the
	//colors array
	[[bandArray objectAtIndex:0] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[0]-48]];
	//Set the second band color
	[[bandArray objectAtIndex:1] setBackgroundColor:[OutputResistorViewController bandColorForNumber:myString[2]-48]];
	//Set the third band color
	[[bandArray objectAtIndex:2] setBackgroundColor:[OutputResistorViewController bandColorForNumber:counter]];
	
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
	if (resistance>=1000000) {
		resistance=resistance/1000000;
		suffix='M';
	}
	//Print out the string as it comes.
	//The thing is 56.0 KΩ looks awful
	//	So that's why that little conditional is in there it would only add a .0 to the
	//	number in case it is greater than 10.
	sprintf(formatedString,(resistance<10?"%.1f%c":"%.0f%c"),resistance,suffix);

	return formatedString;
} 

#pragma mark ColorGetterMethod
+ (UIColor *)bandColorForNumber:(int)index{
	//Init the colors array just the first time 
	if (colorsArray == nil) {
        colorsArray = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor brownColor], 
					   [UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor],  
					   [UIColor blueColor], [UIColor purpleColor], [UIColor grayColor], [UIColor whiteColor], 
					   [UIColor colorWithRed:0.85 green:0.77 blue:0.48 alpha:1], nil];
						//The last color is gold
		
    }
	
	return [colorsArray objectAtIndex:index];
}

@end
