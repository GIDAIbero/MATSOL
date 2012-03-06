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
		layoutView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
		container=[[UIView alloc] initWithFrame:CGRectZero];
		solveButton=[[UIBarButtonItem alloc] initWithTitle:@"Solve" style:UIBarButtonItemStylePlain target:self action:@selector(solveMatrix)];
		
		//This method returns a retained object
		_loadingMessageView=[MatrixSheetViewController createWaitingView];	
		
		self.navigationItem.rightBarButtonItem=solveButton;
	}
	return self;
}

- (void)viewDidLoad{
	#ifdef DEBUG
	NSLog(@"Creating teh matrix");
	#endif
		
	//As soon as the view has loaded make it visible
	[self.view addSubview:_loadingMessageView];
	//[_loadingMessageView release];
	
	//ScrollView initializations
	layoutView.delegate=self;
	layoutView.bouncesZoom = NO;
	layoutView.backgroundColor = [UIColor clearColor];
	
	int i=0;
	UIImageView *shape;
	
	//Add the pads to the matrix to make it fancy : P
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ul.png"]];
	shape.frame=CGRectMake(5, 2, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ll.png"]];
	shape.frame=CGRectMake(5, ((matrixSize)*45)-35, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ur.png"]];
	shape.frame=CGRectMake(((matrixSize+1)*120), 2, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lr.png"]];
	shape.frame=CGRectMake(((matrixSize+1)*120), ((matrixSize)*45)-35, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	//Add the enclosing lines in the matrix : P
	for (i=1; i<matrixSize; i++) {
		//Leftside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(5, (i*45)-35, 12, 66);
		[container addSubview:shape];
		[shape release];
		
		//Rightside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(((matrixSize+1)*120)+12, (i*45)-35, 12, 66);
		[container addSubview:shape];
		[shape release];
	}
	
	//Make the call to the methods that involve threads, here's a brief explanation
	//	1.- Calling beginTextFields: will detach a selector into another thread calling creatingTextFields:
	//	2.-	When creatingTextFields: a loop will start creating every single UITextField after each creation
	//		a method on the main thread will be called adding that UITextField to the container view
	//	3.- After all the UITextFields are created makingFirstResponder: will be called and this will cause
	//		for the "loadiing" view to dissapear & for all the UITextFields to appear.
	[self beginTextFields];
	
}

#pragma mark Initialization_ThreadManagement

-(void)beginTextFields{
	[NSThread detachNewThreadSelector:@selector(creatingTextFields:) toTarget:self withObject:nil];
}

-(void)creatingTextFields:(id)sender{
	//A pool should always be created when using threads
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//UITextField *temp;
	//UILabel *dummies=nil;
	CGPoint referencePoint;
	float currentX=15.0, currentY=15.0;
	int height=0, width=0;
	
	//Assign as many text fields as needed.
	for (height=0; height<matrixSize+1; height++) {
		//[myArray insertObject:[[NSMutableArray alloc] init] atIndex:height];
		//One Column is done? then start the next one from the top
		currentY=15;
		NSMutableArray *ma = [NSMutableArray array];
		for (width=0; width<matrixSize; width++) {
			//[[myArray objectAtIndex:height] insertObject:[[UITextField alloc] initWithFrame:CGRectMake(currentX,currentY, 65, 30)] atIndex:width];
            //[ma insertObject:[[UITextField alloc] initWithFrame:CGRectMake(currentX, currentY, 65, 30)] atIndex:width];
			//temp=[[myArray objectAtIndex:height] objectAtIndex:width];
			UITextField *temp = [[UITextField alloc] initWithFrame:CGRectMake(currentX, currentY, 65, 30)];
			//Attributes for textfields that are not the solution column
			temp.borderStyle=UITextBorderStyleRoundedRect;
			temp.adjustsFontSizeToFitWidth=YES;
			temp.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:20];
			temp.textColor=[UIColor blackColor];
			temp.keyboardType=UIKeyboardTypeDecimalPad;
            UIBarButtonItem *ubbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextSomething:)];
            UIBarButtonItem *lesskey = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIToolbar *kbtb = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)] autorelease];
            [kbtb setBarStyle:UIBarStyleBlackTranslucent];
            [kbtb setItems:[NSArray arrayWithObjects:space,ubbi,lesskey,nil]];
            temp.inputAccessoryView = kbtb;
            temp.keyboardAppearance        = UIKeyboardAppearanceAlert;
			temp.textAlignment=UITextAlignmentRight;
			temp.returnKeyType=UIReturnKeyNext;
			temp.delegate=self;
            
			[ubbi release];
            [lesskey release];
            [space release];
			if (height<matrixSize) {
				temp.placeholder=[NSString stringWithFormat:@"%c%d",height+97,width+1];
				
				UILabel *dummies=[[[UILabel alloc] initWithFrame:CGRectMake(currentX+75, currentY-5, 65, 45)] autorelease];
                if ((matrixSize-1) == height) {
                    [dummies setText:[NSString stringWithFormat:@"%c =",height+97]];
                } else {
                    [dummies setText:[NSString stringWithFormat:@"%c+",height+97]];
                }
				
				[dummies setBackgroundColor:[UIColor clearColor]];
				[dummies setTextColor:[UIColor yellowColor]];
				[dummies setAdjustsFontSizeToFitWidth:YES];
				[dummies setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:25]];
				[dummies setTextAlignment:UITextAlignmentLeft];
                [container addSubview:dummies];
              //  [dummies release];
			}
			else {//Solution column
				referencePoint=temp.center;
				referencePoint.x=referencePoint.x+40;
				temp.center=referencePoint;
				
				//Data for the solution text fields
				temp.placeholder=[NSString stringWithFormat:@"s.%c",width+97];
				temp.textColor=[UIColor redColor];
			}
			[ma insertObject:temp atIndex:width];
            
            [container addSubview:temp];
			//Offset for every row
			currentY=currentY+45;
			
			//free the memory on the other thread
			//[self performSelectorOnMainThread:@selector(endTextFields:) withObject:temp waitUntilDone:NO];
			//[self performSelectorOnMainThread:@selector(endLabels:) withObject:dummies waitUntilDone:NO];
		}
		[myArray insertObject:ma atIndex:height];
		//Add the offset to each column
		currentX=currentX+120;
	}	
	[self performSelectorOnMainThread:@selector(makeFirstResponder:) withObject:nil waitUntilDone:NO];

	//Release the pool
    [pool release];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
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

-(void)dismissKeyboard:(id)sender {
    int i,j;
    BOOL flag = FALSE;
    for (i = 0;!flag && i< [myArray count]; i++) {
        for (j = 0;!flag && j< [[myArray objectAtIndex:i] count]; j++) {
            if ([[[myArray objectAtIndex:i] objectAtIndex:j] isFirstResponder]) {
                //NSLog(@"Found first responder at %d\t%d",i,j);
                [[[myArray objectAtIndex:i] objectAtIndex:j] resignFirstResponder];
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
	[_loadingMessageView removeFromSuperview];
	
	//BE CAREFUL!
	//The container size should be the last thing you set.
	//You should only add the container and the layout by the end of your code.
	container.frame = CGRectMake(0, 0, (120*(matrixSize+1))+35,(45*matrixSize)+20);
	layoutView.contentSize = container.frame.size;
	
	[layoutView addSubview:container];
	[self.view addSubview:layoutView];
	
	//[container release];
	//[layoutView release];
}

#pragma mark Engine
- (void)solveMatrix{
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
		//Display the Results
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
		
		//Set the attributes for the viewcontroller
		theSolutions.a=a;
		theSolutions.b=b;
		theSolutions.size=matrixSize;
		
		//Push the viewController
		[self.navigationController pushViewController:theSolutions animated:YES];		
	}
	else if(matrixState==UnsolvedMatrix){
		#ifdef DEBUG
		NSLog(@"No solution for this matrix.");
		#endif
		UIAlertView *matrixAlert=[[UIAlertView alloc] initWithTitle:@"ERROR!" 
															message:@"There's no solution for this matrix, try another one."
														   delegate:self 
												  cancelButtonTitle:@"ok" 
												  otherButtonTitles:nil];
		//Display the alert dialog
		[matrixAlert show];
		[matrixAlert release];
	}
	
}

#pragma mark MemoryManagement 
- (void)viewDidUnload {
    [super viewDidUnload];
/*	myArray=nil;
	container=nil;
	layoutView=nil;
	solveButton=nil; */
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
	
	const char *cadena;
	int intValue=0;
	
	#ifdef DEBUG
	NSLog(@"This is the new string %@",string);
	#endif 
	
	//Get the C string to compare
	cadena=[string cStringUsingEncoding:NSUTF16StringEncoding];
	intValue=[string intValue];
	
	if (intValue==0) {
		// 0 indicates the supr key
		if ([string isEqual:@"-"] || [string isEqual:@"."] || [string isEqual:@"0"] || cadena[0]==0) {
			return YES;
		}
		else {
			return NO;
		}
	}

	return YES;
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
	UIView *backgroundView=[[[UIView alloc] initWithFrame:CGRectMake(30, 30, 260, 260)] autorelease];
	UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	UILabel *message=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
	
	//Set the label attributes
	[message setText:@"Loading ..."];
	[message setTextColor:[UIColor whiteColor]];
	[message setBackgroundColor:[UIColor clearColor]];
	[message setTextAlignment:UITextAlignmentCenter];
	
	//Set the background attributes
	[backgroundView setBackgroundColor:[UIColor blackColor]];
	[backgroundView setAlpha:0.8];
	
	//Once the spinner is part of the view set it's center
	[backgroundView addSubview:spinner];
	[spinner setCenter:CGPointMake(130, 130)];
	[spinner startAnimating];
	[spinner release];
	
	//Now add the message to the background view
	[backgroundView addSubview:message];
	[message setCenter:CGPointMake(130, 190)];
	[message release];
	
	//The view is returned as a retained object
	return backgroundView;
}

@end
