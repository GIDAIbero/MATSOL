//
//  MatrixSheetViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 12/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "MatrixSheetViewController.h"
#pragma mark -

@implementation MatrixSheetViewController

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
		self.title=@"MATSOL_LES";
#endif
        
		myArray=[[NSMutableArray alloc] init];
		layoutView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		container=[[UIView alloc] initWithFrame:CGRectZero];
		solveButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Solve", @"Solve string") style:UIBarButtonItemStylePlain target:self action:@selector(solveMatrix)];
		loaded = 0;
		//This method returns a retained object
        //	_loadingMessageView=[MatrixSheetViewController createWaitingView];
		
		self.navigationItem.rightBarButtonItem=solveButton;
	}
	return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil matrixSize:(int)matrix{
	if (self = [super initWithNibName:nibNameOrNil bundle:nil]) {
        // Custom initialization
		self.title=@"MATSOL";
#ifdef	DEBUG_INTERFACE
		self.title=@"MATSOL_LES";
#endif
        
        matrixSize = matrix;
		myArray=[[NSMutableArray alloc] init];
		layoutView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		container=[[UIView alloc] initWithFrame:CGRectZero];
		solveButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Solve", @"Solve string") style:UIBarButtonItemStylePlain target:self action:@selector(solveMatrix)];
		loaded = 0;
		//This method returns a retained object
		_loadingMessageView=[MatrixSheetViewController createWaitingView];
		
        self.navigationItem.rightBarButtonItem=solveButton;
        //[self creatingTextFields:nil];
        
	}
	return self;
}


- (void)viewDidLoad{
#ifdef DEBUG
	NSLog(@"Creating the matrix");
#endif
    
	//As soon as the view has loaded make it visible
	[self.view addSubview:_loadingMessageView];
	//[_loadingMessageView release];
	
	//ScrollView initializations
	layoutView.delegate=self;
	layoutView.bouncesZoom = NO;
	layoutView.backgroundColor = [UIColor clearColor];
	
	//Make the call to the methods that involve threads, here's a brief explanation
	//	1.- Calling beginTextFields: will detach a selector into another thread calling creatingTextFields:
	//	2.-	When creatingTextFields: a loop will start creating every single UITextField after each creation
	//		a method on the main thread will be called adding that UITextField to the container view
	//	3.- After all the UITextFields are created makingFirstResponder: will be called and this will cause
	//		for the "loadiing" view to dissapear & for all the UITextFields to appear.
    //  [self beginTextFields];
    
#ifdef DEBUG
    NSLog(@"LOAD");
#endif
    
}
-(void)viewDidAppear:(BOOL)animated {
#ifdef DEBUG
    NSLog(@"APPEAR");
#endif
    if (loaded == 0) {
        loaded = 1;
        [self creatingTextFields:nil];
    }
}
#pragma mark Initialization_ThreadManagement

-(void)beginTextFields{
	//[NSThread detachNewThreadSelector:@selector(creatingTextFields:) toTarget:self withObject:nil];
}

-(void)creatingTextFields:(id)sender{
	CGPoint referencePoint;
	float currentX=15.0, currentY=15.0;
	int height=0, width=0;
	
    
    
	//Assign as many text fields as needed.
	for (height=0; height<matrixSize+1; height++) {
		//One Column is done? then start the next one from the top
		currentY=15;
		NSMutableArray *ma = [NSMutableArray array];
		for (width=0; width<matrixSize; width++) {
            
			UITextField *temp = [[[UITextField alloc] initWithFrame:CGRectMake(currentX, currentY, 65, 30)] autorelease];
			//Attributes for textfields that are not the solution column
			temp.borderStyle=UITextBorderStyleRoundedRect;
			temp.adjustsFontSizeToFitWidth=YES;
			temp.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:20];
			temp.textColor=[UIColor blackColor];
			temp.keyboardType=UIKeyboardTypeDecimalPad;
            
			//Attributes for textfields that are not the solution column
            UIBarButtonItem *ubbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextSomething:)];
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(previousSomething:)];
            UIBarButtonItem *lesskey = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DownIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard:)];
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *sign  = [[UIBarButtonItem alloc] initWithTitle:@"+/-" style:UIBarButtonItemStylePlain target:self action:@selector(signChange:)];
            UIBarButtonItem *fraction  = [[UIBarButtonItem alloc] initWithTitle:@"/" style:UIBarButtonItemStylePlain target:self action:@selector(fraction:)];
            UIBarButtonItem *openPar  = [[UIBarButtonItem alloc] initWithTitle:@"(" style:UIBarButtonItemStylePlain target:self action:@selector(parentheses:)];
            UIBarButtonItem *closePar  = [[UIBarButtonItem alloc] initWithTitle:@")" style:UIBarButtonItemStylePlain target:self action:@selector(parentheses:)];
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
            
            temp.inputAccessoryView = kbtb;
            temp.keyboardAppearance = UIKeyboardAppearanceAlert;
			temp.textAlignment      = UITextAlignmentRight;
			temp.returnKeyType      = UIReturnKeyNext;
			temp.delegate           = self;
            
			if (height<matrixSize) {
				temp.placeholder=[NSString stringWithFormat:@"%c%d",height+97,width+1];
			}
			else {
                //Solution column
				referencePoint=temp.center;
				referencePoint.x=referencePoint.x+10;
				temp.center=referencePoint;
				
				//Data for the solution text fields
				temp.placeholder=[NSString stringWithFormat:@"s.%c",width+97];
				temp.textColor=[UIColor redColor];
			}
			[ma insertObject:temp atIndex:width];
            [container addSubview:temp];
			//Offset for every row
			currentY=currentY+45;
		}
		[myArray insertObject:ma atIndex:height];
		//Add the offset to each column
		currentX=currentX+80;
	}
    
    Parenthesis *par = [[Parenthesis alloc] initWithFrame:CGRectMake(0,0,currentX-80,currentY) rounded:YES];
    [container addSubview:par];
    [container sendSubviewToBack:par];
    [par release];
    par = [[Parenthesis alloc] initWithFrame:CGRectMake(currentX-85, 0, 95, currentY) rounded:YES color:[UIColor redColor]];
    [container addSubview:par];
    [container sendSubviewToBack:par];
    [par release];
    [self performSelector:@selector(makeFirstResponder:)];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    layoutView.contentSize = container.frame.size;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumber *result = nil;
    NSString *solutionString = nil;
    int par = [self howManyPartenthesesInString:[textField text]];
    if (par > 0) {
        NSMutableArray *parArray = [self parenthesesNumberArrayOfString:[textField text] withParentheses:par];
        solutionString = [self solveArray:parArray];
    } else {
        solutionString = [textField text];
    }
    result = [self solveFractionsWithString:solutionString];
    [textField setText:[result stringValue]];
}

-(NSString *)solveArray:(NSMutableArray *)parArray {
    for (int i = 0; i < [parArray count]; i++) {
        if ([[parArray objectAtIndex:i] isKindOfClass:[NSMutableArray class]]) {
            NSString *toSolve = [self solveArray:[parArray objectAtIndex:i]];
            toSolve = [[self solveFractionsWithString:toSolve] stringValue];
            [parArray setObject:toSolve atIndexedSubscript:i];
        } else {
            if (i != 0 && [[parArray objectAtIndex:i] isEqualToString:@""]) {
                [parArray setObject:@"*" atIndexedSubscript:i];
            }
        }
    }
    return [parArray componentsJoinedByString:@""];
}

-(int)howManyPartenthesesInString:(NSString *)string {
    int par = 0;
    int open = 0;
    int close = 0;
    for (int i = 0; i < [string length]; i++) {
        switch ([string characterAtIndex:i]) {
            case '(':
                open ++;
                break;
            case ')':
                close ++;
                break;
            default:
                break;
        }
    }
    if (open == close)
        par = open;
    else
        par = -1;
    return par;
}
-(NSNumber *)solveFractionsWithString:(NSString *)string {
    float resultValue = 0;
    NSNumber *result = nil;
    NSArray *fractions = [string componentsSeparatedByString:@"/"];
    
    for (int i = 0; i < [fractions count]; i++) {
        NSArray *mult = [[fractions objectAtIndex:i] componentsSeparatedByString:@"*"];
        if ([mult count] > 1) {
            float tot = 1;
            for (NSString *m in mult) {
                tot *= [m floatValue];
            }
            if (i == 0) {
                resultValue = tot;
                result = [NSNumber numberWithFloat:tot];
            } else {
                if (tot != 0) {
                    resultValue = resultValue / tot;
                    result = [NSNumber numberWithFloat:resultValue];
                } else {
                    result = nil;
                    i = [fractions count];
                }
            }
        } else {
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[fractions objectAtIndex:i]];
            [f release];
            if (i == 0) {
                if ([myNumber floatValue]) {
                    resultValue = [myNumber floatValue];
                    result = myNumber;
                } else {
                    result = nil;
                    i = [fractions count];
                }
            } else {
                if ([myNumber floatValue]) {
                    if ([myNumber floatValue] == 0.0) {
                        result = nil;
                        i = [fractions count];
                    } else {
                        resultValue = resultValue  / [myNumber floatValue];
                        result = [NSNumber numberWithFloat:resultValue];
                    }
                } else {
                    result = nil;
                    i = [fractions count];
                }
            }
        }
    }
    return result;
}
-(NSMutableArray *)parenthesesNumberArrayOfString:(NSString *)string withParentheses:(int)par {
    NSMutableArray *nma = [NSMutableArray array];
    BOOL addTimes = NO;
    if (par > 0 && string) {
        if ([string characterAtIndex:0] == '-' && [string characterAtIndex:1] == '(') {
            //string = [@"(-1)" stringByAppendingString:[string substringFromIndex:1]];
            string = [string substringFromIndex:1];
            [nma addObject:@"-1"];
            //par++;
        }
        int i = 0;
        for (i = 0; i < [string length]; i++) {
            if ([string characterAtIndex:i] == '(') {
                break;
            }
        }
        if (i != 0) {
            if ([string characterAtIndex:i-1] != ')' && [string characterAtIndex:i-1] != '/') {
                addTimes = YES;
            }
        }
        [nma addObject:[string substringToIndex:i]];
        if (addTimes) {
            [nma addObject:@""];
            addTimes = NO;
        }
        string = [string substringFromIndex:i+1];
        int j = 0;
        for (i = 0; i < [string length]; i++) {
            if ([string characterAtIndex:i] == '(') {
                j++;
            } else {
                if ([string characterAtIndex:i] == ')') {
                    if (j > 0) {
                        j--;
                    } else {
                        break;
                    }
                }
            }
        }
        if (i != 0 && i+1!= [string length]) {
            if ([string characterAtIndex:i+1] != '(' && [string characterAtIndex:i+1] != '/') {
                addTimes = YES;
            }
        }
        if (par == 1){
            [nma addObject:[[self solveFractionsWithString:[string substringToIndex:i]] stringValue]];
            if (addTimes) {
                [nma addObject:@""];
            }
            [nma addObject:[string substringFromIndex:i+1]];
        } else {
            [nma addObject:[self parenthesesNumberArrayOfString:[string substringToIndex:i] withParentheses:[self howManyPartenthesesInString:[string substringToIndex:i]]]];
            if ([string length] > i+1 && [[string substringFromIndex:i+1] characterAtIndex:0] != '(' &&  [[string substringFromIndex:i+1] characterAtIndex:0] != '/') {
                [nma addObject:@""];
            }
            [nma addObject:[self parenthesesNumberArrayOfString:[string substringFromIndex:i+1] withParentheses:[self howManyPartenthesesInString:[string substringFromIndex:i+1]]]];
        }
        if ([[nma lastObject] isKindOfClass:[NSString class]]) {
            if ([[nma lastObject] isEqualToString:@""]) {
                [nma removeLastObject];
            }
        } else {
            if ([[[nma lastObject] lastObject] isEqualToString:@""]) {
                [nma removeLastObject];
            }
        }
    } else {
        [nma addObject:string];
    }
    return nma;
}

-(void)parentheses:(id)sender {
    NSString *frac;
    UITextField *text;
    int i,j;
    BOOL flag = FALSE;
    
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                
                frac = [[[myArray objectAtIndex:i] objectAtIndex:j] text];
                
                if ([[sender title] isEqualToString:@"("]) {
                    frac = [frac stringByAppendingString:@"("];
                } else {
                    if (![frac hasSuffix:@"("] && ![frac hasSuffix:@"/"]) {
                        frac = [frac stringByAppendingString:@")"];
                    }
                }
                
                text = [[myArray objectAtIndex:i] objectAtIndex:j];
                [text setText:frac];
            }
        }
    }
    
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

-(void)fraction:(id)sender {
    NSString *frac;
    UITextField *text;
    int i,j;
    BOOL flag = FALSE;
    
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                frac = [[[myArray objectAtIndex:i] objectAtIndex:j] text];
                int last = [frac length] - 1;
                switch ([frac characterAtIndex:last]) {
                    case '(':
                        break;
                    case '/':
                        break;
                    case '.':
                        break;
                    default:
                        frac = [frac stringByAppendingString:@"/"];
                        break;
                }
                text = [[myArray objectAtIndex:i] objectAtIndex:j];
                [text setText:frac];
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
                [[[myArray objectAtIndex:i+1] objectAtIndex:j] becomeFirstResponder];
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
                [[[myArray objectAtIndex:i-1] objectAtIndex:j] becomeFirstResponder];
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
                layoutView.contentSize = CGSizeMake(container.frame.size.width, container.frame.size.height - 240);
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

-(void)endLabels:(id)sender{
	//Evertime a new text field is created this method is called on the
	//main thread so it can add that text field to the container
	[container addSubview:sender];
}

-(void)makeFirstResponder:(id)sender{
	//Make the first UITextField the first responder, then make the
	//keyboard appear
	[[[myArray objectAtIndex:0] objectAtIndex:0] becomeFirstResponder];
	firstResponder.fst = 0;
    firstResponder.snd = 0;
	//Hide the Waiting interface
    if (_loadingMessageView != nil) {
        [_loadingMessageView removeFromSuperview];
        _loadingMessageView = nil;
    }
    
	//BE CAREFUL!
	//The container size should be the last thing you set.
	//You should only add the container and the layout by the end of your code.
	container.frame = CGRectMake(0, 0, (80*(matrixSize+1))+35,(45*matrixSize)+250);
	layoutView.contentSize = container.frame.size;
	
	[layoutView addSubview:container];
	[[self view] addSubview:layoutView];
}

#pragma mark Engine
- (void)solveMatrix{
    [self nextSomething:nil];
	int i=0, j=0;
	float **a;
	float *b;
	float assign=0.0;
	int matrixState=0;
	UITextField *temp;//Every textField will pass through this var
    
	//Dynamic memory assignment
	a=(float **)malloc(sizeof(float *)*matrixSize);
    
	for (i=0; i<matrixSize; i++) {
		a[i]=malloc(sizeof(float)*matrixSize);
	}
	//an array of this size
	b=malloc(sizeof(float)*matrixSize);
	
	//Be sure both arrays are clean
	for (i=0; i<matrixSize; i++) {
		for (j=0; j<matrixSize; j++) {
			a[i][j]=0.0;
		}
		b[i]=0;
	}
	
	//Fetch all the info from the textFields
	for (i=0; i<matrixSize+1; i++) {
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
			else {
				b[j]=assign;
			}
		}
	}
	
	//Send it to gaussj & check if it's a valid matrix
	matrixState=gaussj(a,matrixSize,b);
    
	if (matrixState==SolvedMatrix) {
        
		//Display the results on the console
#ifdef DEBUG
		for (i=0; i<matrixSize; i++) {
			for (j=0; j<matrixSize; j++) {
				NSLog(@"This is the output INVERSE matrix @ [%d][%d] = %.3f\n",i,j,a[i][j]);
			}
			printf("\n");
		}
		printf("\n");
		for (i=0; i<matrixSize; i++) {
			NSLog(@"This is the output SOLUTION matrix @ [%d] = %.3f\n",i,b[i]);
		}
#endif
		
		//Time to push the next view
		SolutionsViewController *theSolutions=[[[SolutionsViewController alloc] initWithNibName:@"Solutions" bundle:nil] autorelease];
		
		//Set the attributes for the viewcontroller, it will take charge of the memory management
		theSolutions.a=a;
        theSolutions.b=b;
        theSolutions.size=matrixSize;
        
		//Push the viewController
		[[self navigationController] pushViewController:theSolutions animated:YES];
	}
	else if(matrixState==UnsolvedMatrix){
#ifdef DEBUG
		NSLog(@"No solution for this matrix.");
#endif
        
        GIDASearchAlert *matrixAlert = [[GIDASearchAlert alloc] initWithTitle:NSLocalizedString(@"Error", @"Error string")
                                                                      message:NSLocalizedString(@"Cannot solve this matrix, please try another one.", @"Can't solve matrix text")
                                                                     delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
        
		[matrixAlert show];
		[matrixAlert release];
	}
	
}
- (void)dealloc {
	[myArray release];
	[container release];
	[layoutView release];
	[solveButton release];
    [super dealloc];
}

#pragma mark TextFieldDelegateMethods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && string.length == 0) {
        return YES;
    }
    BOOL success = YES;
    
    if ([string isEqualToString:@"."]) {
        for (int i = [[textField text] length] - 1; i >= 0; i--) {
            switch ([[textField text] characterAtIndex:i]) {
                case '.':
                    success = NO;
                    i = -1;
                    break;
                case '(':
                    i = -1;
                    break;
                case ')':
                    i = -1;
                    break;
                case '/':
                    i = -1;
                    break;
                default:
                    break;
            }
        }
    }
    
    return success;
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
	
	if (strlen(placeholder)>=3) {
		//Two digits coordinate
		if (placeholder[1]=='.') {
			x=matrixSize;
			y=placeholder[2]-97;
		}
		else {
			temp[0]=placeholder[1];
			temp[1]=placeholder[2];
			temp[2]='\0';
			
			y=atoi(temp)-1;
		}
	}
    
#ifdef MOVE_VERTICAL
	y=y+1;
	if (y==matrixSize) {
		y=0;
		x=x+1;
		if (x>matrixSize) {
			x=0;
		}
	}
#endif
	
#ifdef MOVE_HORIZONTAL
	x=x+1;
	if (x>matrixSize) {
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
	return backgroundView;
}

@end
