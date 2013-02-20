//
//  DeterminantSheetViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 14/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "DeterminantSheetViewController.h"
#pragma mark -


//Just a few inline functions that are useful for the padding creation
int PaddingYRight(int size);
int PaddingYRight(int size){
	return ((size)*45)-35; 
}

int PaddingXRight(int size);
int PaddingXRight(int size){
	return ((size+1)*70)-70;
}

@implementation DeterminantSheetViewController

@synthesize myArray;
@synthesize container;
@synthesize layoutView;
@synthesize solveButton;
@synthesize matrixSize;

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		self.title=@"MATSOL";
		#ifdef	DEBUG_INTERFACE
		self.title=@"MATSOL_DET";
		#endif
		
		myArray=[[NSMutableArray alloc] init];
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
        
        if (scale == 2.0f && pixelHeight == 1136.0f) {
            ip5 = YES;
            layoutView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 592)];
        } else {
            ip5 = NO;
            layoutView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        }
		container=[[UIView alloc] initWithFrame:CGRectZero];
		solveButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Solve", @"Solve string") style:UIBarButtonItemStylePlain target:self action:@selector(solveMatrix)];
		
		//This method returns a retained object
		_loadingMessageView=[DeterminantSheetViewController createWaitingView];	
		
		self.navigationItem.rightBarButtonItem=solveButton;
	}
	return self;
}

- (void)viewDidLoad{
	#ifdef DEBUG
	NSLog(@"Creating the matrix");
	#endif
	/*
	int i=0;
	UIImageView *shape;
	*/
	//As soon as the view has loaded make it visible
	[self.view addSubview:_loadingMessageView];
	//[_loadingMessageView release];
	
	//ScrollView initializations
	layoutView.delegate=self;
	layoutView.bouncesZoom = NO;
	layoutView.backgroundColor = [UIColor clearColor];	
	
	//Add the pads to the matrix to make it fancy : P
	/*
	//LEFT SIDE
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ul.png"]];
	shape.frame=CGRectMake(kPaddingXLeft, kPaddingYLeft, kPaddingCornerWidth, kPaddingCornerHeight);
	[container addSubview:shape];
	[shape release];
	
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ll.png"]];
	shape.frame=CGRectMake(5,PaddingYRight(matrixSize), kPaddingCornerWidth, kPaddingCornerHeight);
	[container addSubview:shape];
	[shape release];
	
	//RIGHT SIDE
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ur.png"]];
	shape.frame=CGRectMake(PaddingXRight(matrixSize), kPaddingYLeft, kPaddingCornerWidth, kPaddingCornerHeight);
	[container addSubview:shape];
	[shape release];
	
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lr.png"]];
	shape.frame=CGRectMake(PaddingXRight(matrixSize), PaddingYRight(matrixSize), kPaddingCornerWidth, kPaddingCornerHeight);
	[container addSubview:shape];
	[shape release];
	
	//Add the enclosing lines in the matrix : P
	for (i=1; i<matrixSize; i++) {
		//Leftside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(kPaddingXLeft, PaddingYRight(i), kPaddingLineWidth, kPaddingLineHeight);
		[container addSubview:shape];
		[shape release];
		
		//Rightside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(((matrixSize+1)*70)-58, PaddingYRight(i), kPaddingLineWidth, kPaddingLineHeight);
		[container addSubview:shape];
		[shape release];
	}
	*/
	
}
-(void)viewDidAppear:(BOOL)animated {
    [self beginTextFields];
}
#pragma mark Initialization_ThreadManagement

-(void)beginTextFields{
	//[NSThread detachNewThreadSelector:@selector(creatingTextFields:) toTarget:self withObject:nil];
    [self creatingTextFields:nil];
}

-(void)creatingTextFields:(id)sender{
	//A pool should always be created when using threads
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int height=0, width=0;
	for (height=0; height<matrixSize; height++) {
		NSMutableArray *ma = [NSMutableArray array];
		for (width=0; width<matrixSize; width++) {
			UITextField *temp = [[UITextField alloc] initWithFrame:CGRectMake(((height+1)*70)-55,((width+1)*45)-30, 65, 30)];
            
			//Attributes for textfields that are not the solution column
            UIBarButtonItem *ubbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextSomething:)];
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousSomething:)];
            UIBarButtonItem *lesskey = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DownIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)];
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *sign  = [[UIBarButtonItem alloc] initWithTitle:@"+/-" style:UIBarButtonItemStylePlain target:self action:@selector(signChange:)];
            UIBarButtonItem *fraction  = [[UIBarButtonItem alloc] initWithTitle:@"/" style:UIBarButtonItemStylePlain target:self action:@selector(operator:)];
            UIBarButtonItem *openPar  = [[UIBarButtonItem alloc] initWithTitle:@"(" style:UIBarButtonItemStylePlain target:self action:@selector(operator:)];
            UIBarButtonItem *closePar  = [[UIBarButtonItem alloc] initWithTitle:@")" style:UIBarButtonItemStylePlain target:self action:@selector(operator:)];
            UIBarButtonItem *betweenArrowsSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [betweenArrowsSpace setWidth:18];
            UIBarButtonItem *betweenSignAndArrowSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [betweenSignAndArrowSpace setWidth:25];
            
            UIToolbar *kbtb = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)] autorelease];
            [kbtb setBarStyle:UIBarStyleBlackTranslucent];
            [kbtb setItems:[NSArray arrayWithObjects:lesskey,space,sign, space, fraction, space, openPar, space, closePar, space, back, betweenSignAndArrowSpace,ubbi,nil]];
            
            [ubbi release];
            [lesskey release];
            [space release];
            [sign release];
            [back release];
            [openPar release];
            [closePar release];
            
            [betweenArrowsSpace release];
            [betweenSignAndArrowSpace release];            
            temp.inputAccessoryView        = kbtb;
            
			temp.borderStyle               = UITextBorderStyleRoundedRect;
			temp.adjustsFontSizeToFitWidth = YES;
			temp.font                      = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:20];
			temp.textColor                 = [UIColor blackColor];
			temp.keyboardType              = UIKeyboardTypeDecimalPad;
            temp.keyboardAppearance        = UIKeyboardAppearanceAlert;
            temp.returnKeyType             = UIReturnKeyNext;
			temp.textAlignment             = UITextAlignmentRight;
			//These three properties are important to later use the delegate methods
			//and make input easier
			temp.delegate=self;
			temp.placeholder=[NSString stringWithFormat:@"%c%d",height+1+96,width+1];
			temp.returnKeyType=UIReturnKeyNext;
			
			//free the memory on the other thread
			//[self performSelectorOnMainThread:@selector(endTextFields:) withObject:temp waitUntilDone:NO];
            [container addSubview:temp];
            //[[myArray objectAtIndex:height] insertObject:temp atIndex:width];
            [ma insertObject:temp atIndex:width];
		}
        [myArray insertObject:ma atIndex:height];
	}	
	//Is it done, well let's call it a thread and close this shit now!
	//[self performSelectorOnMainThread:@selector(makeFirstResponder:) withObject:nil waitUntilDone:NO];
	[self makeFirstResponder:nil];
	//Release the pool

    Parenthesis *par = [[Parenthesis alloc] initWithFrame:CGRectMake(0,0,((matrixSize+1)*70)-45,((matrixSize+1)*45)-30)];
    [container addSubview:par];
    [container sendSubviewToBack:par];
    [par release];
    
    [pool release];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumber *result = nil;
    
    result = [GIDACalculateString solveString:[textField text]];
    [textField setText:[result stringValue]];
}

-(void)moveTextField:(UITextField *)text toX:(int)x andY:(int)y {
    CGPoint point = layoutView.contentOffset;
    
    if (x <= 2) {
        point.x = 0;
    }else {
        if (x == [myArray count] - 1) {
            point.x = [text frame].origin.x-220;
        } else {
            point.x = (x-2)*70;
        }
    }
    
    if (ip5) {
        if  (y >= 5){
            point.y = (y-4)*45;
        } else {
            point.y = 0;
        }
    } else {
        
        if  (y >= 3){
            point.y = (y-2)*45;
        }
    }
    
    layoutView.contentOffset = point;
}


-(void)signChange:(id)sender {
    UITextField *text;
    int i,j;
    BOOL flag = FALSE;
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                text = [[myArray objectAtIndex:i] objectAtIndex:j];
                NSString *textString = [text text];
                if ([textString length] > 0) {
                    if ([textString characterAtIndex:0] != '-') {
                        textString = [@"-" stringByAppendingString:textString];
                    } else {
                        textString = [textString substringFromIndex:1];
                    }
                }
                [text setText:textString];
                flag = TRUE;
            }
        }
    }
}

-(void)operator:(id)sender {
    NSString *exp;
    UITextField *text;
    int i,j;
    BOOL flag = FALSE;
    
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                text = [[myArray objectAtIndex:i] objectAtIndex:j];
                NSRange range = [[text valueForKey:@"selectionRange"] rangeValue];
                exp = [GIDACalculateString stringFrom:[text text] withThis:[sender title] here:range];
                [text setText:exp];
            }
        }
    }
}

-(void)nextSomething:(id)sender {
    int i,j;
    BOOL flag = FALSE;
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                //NSLog(@"Found first responder at %d\t%d",i,j);
                [[[myArray objectAtIndex:i] objectAtIndex:j] resignFirstResponder];
                //i = i+1;
                if (j+1 == [[myArray objectAtIndex:i] count] && i+1 == [myArray count]) {
                    i = -1;
                    j = 0;
                } else if (i+1 >= [myArray count]) {
                    i = -1;
                    j = j+1;
                }
                i++;
                [self moveTextField:[[myArray objectAtIndex:i] objectAtIndex:j] toX:i andY:j];
                [[[myArray objectAtIndex:i] objectAtIndex:j] becomeFirstResponder];
                flag = TRUE;
            }
        }
    }
}

-(void)previousSomething:(id)sender {
    int i,j;
    BOOL flag = FALSE;
    int maxi = [myArray count];
    int maxj = [[myArray objectAtIndex:0] count];
    for (i = 0;!flag && i< maxi; i++) {
        for (j = 0;!flag && j< maxj; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                //NSLog(@"Found first responder at %d\t%d",i,j);
                [[[myArray objectAtIndex:i] objectAtIndex:j] resignFirstResponder];
                //i = i+1;
                if (j == 0 && i == 0) {
                    i = maxi;
                    j = maxj-1;
                } else if (i == 0) {
                    i = maxi;
                    j = j-1;
                }
                i--;
                [self moveTextField:[[myArray objectAtIndex:i] objectAtIndex:j] toX:i andY:j];
                [[[myArray objectAtIndex:i] objectAtIndex:j] becomeFirstResponder];
                flag = TRUE;
            }
        }
    }
}

-(void)dismissKeyboard:(id)sender {
    int i,j;
    BOOL flag = FALSE;
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                //NSLog(@"Found first responder at %d\t%d",i,j);
                [[[myArray objectAtIndex:i] objectAtIndex:j] resignFirstResponder];
                if (ip5) {
                    layoutView.contentSize = CGSizeMake(container.frame.size.width, container.frame.size.height - 250);
                } else {
                    layoutView.contentSize = CGSizeMake(container.frame.size.width, container.frame.size.height - 240);
                }
                flag = TRUE;
            }
        }
    }
}

-(void)endTextFields:(id)sender{
	//Evertime a new text field is created this method is called on the 
	//main thread so it can add that text field to the container
	[container addSubview:sender];
	[sender release];
}

-(void)makeFirstResponder:(id)sender{
	//Make the first UITextField the first responder, then make the
	//keyboard appear
	[[[myArray objectAtIndex:0] objectAtIndex:0] becomeFirstResponder];
	
	//Hide the Waiting interface
	if (_loadingMessageView != nil) {
        [_loadingMessageView removeFromSuperview];
        _loadingMessageView = nil;
    }
	
	//BE CAREFUL!
	//The container size should be the last thing you set.
	//You should only add the container and the layout by the end of your code.
	if (ip5) {
        container.frame = CGRectMake(0, 0, (80*(matrixSize+1))+35,(45*matrixSize)+350);
    } else {
        container.frame = CGRectMake(0, 0, (80*(matrixSize+1))+35,(45*matrixSize)+250);
    }
    NSLog(@"Container: Height %f\tWidth %f", container.frame.size.height,container.frame.size.width);
	layoutView.contentSize = container.frame.size;
	[layoutView addSubview:container];
	[self.view addSubview:layoutView];
}


#pragma mark Engine
- (void)solveMatrix{
    [self nextSomething:nil];
	int i=0, j=0, wasSolved=-11;
	float **a;
	float d=0;
	float assign=0.0;
	UITextField *temp;//Every textField will pass through this var
    GIDASearchAlert *determinantValue = nil;
	
	//Dynamic memory assignment
	a=(float **)malloc(sizeof(float *)*matrixSize);
	
	for (i=0; i<matrixSize; i++) {
		a[i]=malloc(sizeof(float)*matrixSize);
	}
	
	//Be sure both arrays are clean
	for (i=0; i<matrixSize; i++) {
		for (j=0; j<matrixSize; j++) {
			a[i][j]=0.0;
		}
	}
	
	//Fetch all the info from the textFields
	for (i=0; i<matrixSize; i++) {
		for (j=0; j<matrixSize; j++) {
			temp=[[myArray objectAtIndex:i] objectAtIndex:j];
			#ifdef DEBUG
			NSLog(@"In the position [%d][%d] the value is %f",j,i,[[temp text] floatValue]);
			#endif
			
			assign=[[temp text] floatValue];
			//Pass it to the matrix
			if (i<matrixSize) {
				a[j][i]=assign;
			}
		}
	}
	
	//Send it to ludcmp & check if it's a valid matrix
	wasSolved=ludcmp(a, matrixSize, &d);
	
	if (wasSolved==DeterminantErrorCantSolve) {
        determinantValue = [[GIDASearchAlert alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string") 
                                                          message:NSLocalizedString(@"Can't solve this determinant, sorry.", @"Can't solve this determinant text") 
                                                         delegate:self cancelButtonTitle:@"Ok" 
                                                otherButtonTitles:nil];
    }
	else if ((wasSolved=DeterminantErrorEverythingOk)) {
		for(j=1;j<=matrixSize;j++) {
			d *= a[j-1][j-1];
		}
		
		#ifdef DEBUG
		NSLog(@"The determinant value is %f\n",d);
		#endif
		determinantValue = [[GIDASearchAlert alloc] 
            initWithTitle:NSLocalizedString(@"Done!", @"Done string") 
            message:[NSString stringWithFormat:@"%@: %.5f", 
               NSLocalizedString(@"The value of the determinant for that matrix is", @"Solution text determinant"),d] 
            delegate:self 
            cancelButtonTitle:@"Ok" 
            otherButtonTitles:nil];
	}
    //Display the alert dialog
    [determinantValue show];
    [determinantValue release];
}

#pragma mark MemoryManagement 
- (void)viewDidUnload {
    [super viewDidUnload];
	/*myArray=nil;
	container=nil;
	layoutView=nil;
	solveButton=nil;
	_loadingMessageView=nil;*/
}

- (void)dealloc {
	[myArray release];
	[container release];
	[layoutView release];
	[solveButton release];
	//[_loadingMessageView release];
    [super dealloc];
}


#pragma mark TextFieldDelegateMethods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    int i,j;
    BOOL flag = FALSE;
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                [self moveTextField:[[myArray objectAtIndex:i] objectAtIndex:j] toX:i andY:j];
                flag = TRUE;
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && string.length == 0) {
        return YES;
    }
        
    return [GIDACalculateString usingThis:[textField text] addThis:string here:range];
}

//Let's switch from text field to text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//It's easier to manipulate it as a simple C string
	//We are going to use ASCII encoding since the it's just a letter and a number
	const char *placeholder=[[textField placeholder] cStringUsingEncoding:NSASCIIStringEncoding];
	char  temp[3];
	int x=0, y=0;
	#ifdef DEBUG
	NSLog(@"The current placeholder is: [%s] & the NSSring value is: [%@]",placeholder,[textField placeholder]);
	NSLog(@"The int values are placeholder[0]: %d placeholder[1]: %d with a length of: %d",placeholder[0],placeholder[1],strlen(placeholder));
	#endif
	
	x=placeholder[0]-97;
	
	if(strlen(placeholder)==2){
		//One digit coordinate
		y=placeholder[1]-49;
	}
	
	if (strlen(placeholder)==3) {
		//Two digits coordinate
		temp[0]=placeholder[1];
		temp[1]=placeholder[2];
		temp[2]='\0';
		
		y=atoi(temp)-1;
	}
	
	
	#ifdef MOVE_VERTICAL
	y=y+1;
	if (y==matrixSize) {
		y=0;
		x=x+1;
		if (x==matrixSize) {
			x=0;
		}
	}	
	#endif
	
	#ifdef MOVE_HORIZONTAL
	x=x+1;
	if (x==matrixSize) {
		x=0;
		y=y+1;
		if (y==matrixSize) {
			y=0;
		}
	}	
	#endif
	
	//In this case since this is the determinant ViewController navigation can be done
	//easily just with 2 coordinates
	[[[myArray objectAtIndex:x] objectAtIndex:y] becomeFirstResponder];
	
	return YES;
}

#pragma mark WaitingMethods
+ (UIView *)createWaitingView{
    UIView *backgroundView=[[[UIView alloc] initWithFrame:CGRectMake(60, 90, 200, 200)] autorelease];
	UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	UILabel *message=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
	
	//Set the label attributes
	[message setText:NSLocalizedString(@"Loading ...", @"Loading string")];
	[message setTextColor:[UIColor whiteColor]];
	[message setBackgroundColor:[UIColor clearColor]];
	[message setTextAlignment:UITextAlignmentCenter];
	
	//Set the background attributes
	[backgroundView setBackgroundColor:[UIColor blackColor]];
	[backgroundView setAlpha:0.7];
    backgroundView.layer.cornerRadius = 20;
	
	//Once the spinner is part of the view set it's center
	[backgroundView addSubview:spinner];
	[spinner setCenter:CGPointMake(100, 80)];
	[spinner startAnimating];
	[spinner release];
	
	//Now add the message to the background view
	[backgroundView addSubview:message];
	[message setCenter:CGPointMake(100, 140)];
	[message release];
	
	//The view is returned as a retained object
	return backgroundView;}


@end
