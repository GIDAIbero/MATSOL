//
//  GIDAMatrixViewController.m
//  GIDAMatrixView
//
//  Created by Alejandro Paredes Alva on 3/3/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import "GIDAMatrixViewController.h"

//Private variables
@interface GIDAMatrixViewController () {
    //Matrix size. Max size is 26x26 (26x27 in case of Linear equations, due to the solution column)
    NSInteger matrixSize;
    
    //The tag of the textfield in use, useful to dismiss the keyboard
    NSInteger textFieldTag;
    
    //Matrix solver type
    GIDASolver solver;
    
    //Variable used for >=iPhone 5 Layout
    BOOL ip5;
}

//Matrix of place holder for the UITextFields (a1, a2, ..., b1, b2, ..., s.a, s.b, ...). Never changes
@property (retain, nonatomic) NSMutableArray *matrixPlaceHolder;
//Matrix values, user input values to process. Changes when user makes a change to the matrix
@property (retain, nonatomic) NSMutableArray *matrix;
//The UITableView to display all the UITextField rows. Also to scroll vertically.
@property (retain, nonatomic) UITableView *table;
//The UIScrollView to scroll horizontally
@property (retain, nonatomic) UIScrollView *scroll;

//Method to initialize the arrays (_matrixPlaceHolder, _matrix)
- (void)initializeArrays;
@end

@implementation GIDAMatrixViewController

- (id)initWithMatrixSize:(NSInteger)size andSolver:(GIDASolver)gidasolver {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        //Set the type of Matrix Solver the user wants to use
        solver = gidasolver;
        
        //Set the size of the matrix the user wants
        matrixSize = size;
        
        //Define if using a 4in or a 3.5in iPhone
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
        
        if (scale == 2.0f && pixelHeight == 1136.0f) {
            ip5 = YES;
        } else {
            ip5 = NO;
        }
        
        //Put the 'solve' button on the navigation bar and make its action 'solveMatrix'
		UIBarButtonItem *solveButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Solve", @"Solve string") style:UIBarButtonItemStylePlain target:self action:@selector(solveMatrix)];
		self.navigationItem.rightBarButtonItem=solveButton;
        
        [self initializeArrays];
    }
    return self;
}


//Initialize the arrays with their basic values.
//Empty string for _matrix
//a1, a2, ..., b1, b2, ... for the _matrixPlaceHolder
- (void)initializeArrays {
    //Allocate the arrays with the matrix size as capacity
    _matrixPlaceHolder = [[NSMutableArray alloc] initWithCapacity:matrixSize];
    _matrix = [[NSMutableArray alloc] initWithCapacity:matrixSize];
    
    //Variable to determine the width of the matrix.
    //If the user wants linear equations then it should have 1 more column for the solutions
    NSInteger jMax = matrixSize;
    if (solver == GIDALinearEquations) {
        jMax = matrixSize+1;
    }
    
    //Go through each row and put a new array with max capacity of jMax
    for (int i = 0; i < matrixSize; i++) {
        [_matrix insertObject:[[[NSMutableArray alloc] initWithCapacity:jMax] autorelease] atIndex:i];
        [_matrixPlaceHolder insertObject:[[[NSMutableArray alloc] initWithCapacity:jMax] autorelease] atIndex:i];
        
        //Place the initial value of the array.
        for (int j = 0; j < jMax; j++) {
            [[_matrix objectAtIndex:i] setObject:@"" atIndex:j];
            if (j < matrixSize)
                [[_matrixPlaceHolder objectAtIndex:i] setObject:[NSString stringWithFormat:@"%c%d",i+97,j+1] atIndex:j];
            else
                [[_matrixPlaceHolder objectAtIndex:i] setObject:[NSString stringWithFormat:@"s.%c",i+97] atIndex:j];
        }
    }
}


//Release all objects
- (void)dealloc {
    [_matrixPlaceHolder removeAllObjects];
    [_matrixPlaceHolder release];
    [_matrix removeAllObjects];
    [_matrix release];
    
    for (id view in [_scroll subviews]) {
        if ([view isKindOfClass:[Parenthesis class]]) {
            [view removeFromSuperview];
            [view release];
        }
    }
    
    [_scroll release];
    [_table release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scroll = [[UIScrollView alloc] init];
    [_scroll setPagingEnabled:YES];
    [_scroll setBackgroundColor:[UIColor clearColor]];
    _table = [[UITableView alloc] init];
    [_table setDataSource:self];
    [_table setDelegate:self];
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_table setBackgroundColor:[UIColor clearColor]];
    [_scroll addSubview:_table];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BrushedMetalBackground.png"]]];
    
    [self setViewsDimensionsFullScreen:YES];
    
    [self.view addSubview:_scroll];
    
}

- (void)setViewsDimensionsFullScreen:(BOOL)fullScreen {
    NSInteger height = (matrixSize * 45);
    if (fullScreen) {
        if (ip5) {
            if (height >= 504)
                height = 504;
        } else {
            if (height >= 416) {
                height = 416;
            }
        }
    } else {
        if (ip5) {
            if (height >= 258)
                height = 258;
        } else {
            if (height >= 170) {
                height = 170;
            }
        }
    }
    if (_scroll.frame.size.height != height) {
        NSInteger width = 70;
        if (solver == GIDALinearEquations){
            width = width*(matrixSize+1);
        } else {
            width = width*(matrixSize);
        }

        [_scroll setFrame:CGRectMake(0, 0, 320, height)];
        [_scroll setContentSize:CGSizeMake(width + 65, height)];
        [_table setFrame:CGRectMake(15, 0, width + 45, height)];
        
        for (id view in [_scroll subviews]) {
            if ([view isKindOfClass:[Parenthesis class]]) {
                [view removeFromSuperview];
            }
        }
        
        if (solver == GIDALinearEquations) {
            width = width - 70;
            Parenthesis *par = [[Parenthesis alloc] initWithFrame:CGRectMake(0,-5,width+32.5,height+10) rounded:YES];
            [_scroll addSubview:par];
            [_scroll sendSubviewToBack:par];
            [par release];
            par = [[Parenthesis alloc] initWithFrame:CGRectMake(width+28.5, -5, 110, height+10) rounded:YES color:[UIColor redColor]];
            [_scroll addSubview:par];
            [_scroll sendSubviewToBack:par];
            [par release];
        } else {
            Parenthesis *par = [[Parenthesis alloc] initWithFrame:CGRectMake(0,-5,width+32.5,height+10) rounded:NO];
            [_scroll addSubview:par];
            [_scroll sendSubviewToBack:par];
            [par release];
        }
    }
}

- (void)previousSomething:(id)sender {
    NSInteger tag = textFieldTag-1;
    NSInteger row = ((int)(textFieldTag/100))-1;
    NSInteger dif = tag - ((row+1)*100);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (dif < 0) {
        if (row == 0) {
            row = matrixSize-1;
        } else {
            row--;
        }
        indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        tag = matrixSize + (row+1)*100;
    }
    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_scroll setContentOffset:CGPointMake((tag - (row+1)*100)*60, 0)];
    [[[(GIDAMatrixCell *)[_table cellForRowAtIndexPath:indexPath] contentView] viewWithTag:tag] becomeFirstResponder];
}

- (void)nextSomething:(id)sender {
    NSInteger tag = textFieldTag+1;
    NSInteger row = ((int)(tag/100))-1;
    NSInteger dif = tag - ((row+1)*100);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    if (dif > matrixSize) {
        row ++;
        if (row >= matrixSize) {
            row = 0;
        }
        indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        tag = (row+1)*100;
    }
    
    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_scroll setContentOffset:CGPointMake((tag - (row+1)*100)*60, 0)];
    [[[(GIDAMatrixCell *)[_table cellForRowAtIndexPath:indexPath] contentView] viewWithTag:tag] becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSNumber *result = nil;
    result = [GIDACalculateString solveString:[textField text]];
    [textField setText:[result stringValue]];
    if ([result stringValue]) {
        NSInteger tag = textFieldTag;
        NSInteger row = ((int)(tag/100))-1;
        [[_matrix objectAtIndex:row] setObject:[result stringValue] atIndex:(tag - (row+1)*100)];
    }
}

-(void)signChange:(id)sender {
    NSInteger tag = textFieldTag;
    NSInteger row = ((int)(tag/100))-1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    UITextField *text = (UITextField *)[(GIDAMatrixCell *)[_table cellForRowAtIndexPath:indexPath] viewWithTag:tag];
    NSString *textString = [text text];
    if ([textString length] > 0) {
        if ([textString characterAtIndex:0] != '-') {
            textString = [@"-" stringByAppendingString:textString];
        } else {
            textString = [textString substringFromIndex:1];
        }
    }
    [text setText:textString];
    
}

-(void)operator:(id)sender {
    NSInteger tag = textFieldTag;
    NSInteger row = ((int)(tag/100))-1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSString *exp;
    UITextField *text = (UITextField *)[(GIDAMatrixCell *)[_table cellForRowAtIndexPath:indexPath] viewWithTag:tag];
    
    NSRange range = [[text valueForKey:@"selectionRange"] rangeValue];
    exp = [GIDACalculateString stringFrom:[text text] withThis:[sender title] here:range];
    [text setText:exp];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setViewsDimensionsFullScreen:NO];
    textFieldTag = [textField tag];
    NSInteger tag = textFieldTag;
    NSInteger row = ((int)(tag/100))-1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self setViewsDimensionsFullScreen:NO];
}
- (void)dismissKeyboard:(id)sender {
    NSInteger tag = textFieldTag;
    NSInteger row = ((int)(tag/100))-1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    [(GIDAMatrixCell *)[_table cellForRowAtIndexPath:indexPath] dismissKeyboardWithTag:textFieldTag];
    [self setViewsDimensionsFullScreen:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    for (id view in [_scroll subviews]) {
        if ([view isKindOfClass:[Parenthesis class]]) {
            [view removeFromSuperview];
            [view release];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}
-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return matrixSize;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"GIDAMatrixCell";
    
    //Ask for the cell at the begining then just reference this pointer
    GIDAMatrixCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    //There's not a cell in the queue of reusable cells, create one
    if (cell == nil){
		cell = [[[GIDAMatrixCell alloc] initWithRowFields:[_matrixPlaceHolder objectAtIndex:indexPath.row] reuseIdentifier:kCellID andDelegate:self andRowTag:indexPath.row+1 andMatrixSize:matrixSize] autorelease];
	} else {
        //If there is a cell we can use, we must update the place holders.
        [cell setPlaceholders:[_matrixPlaceHolder objectAtIndex:indexPath.row] andRowTag:indexPath.row+1];
    }
    
    //Always update the matrix values as we don't know if the reused cell has any previous values
    [cell setMatrixRow:[_matrix objectAtIndex:indexPath.row] andRowTag:indexPath.row+1];
    
    //Do not let the user select the cell
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark Engine
//When `solve` button is clicked choose the appropiate matrix solver to use.
- (void)solveMatrix{
    switch (solver) {
        case GIDALinearEquations:
            [self solveLinear];
            break;
        case GIDADeterminant:
            [self solveDeterminant];
            break;
        default:
            break;
    }
}

-(void)solveDeterminant {[self nextSomething:nil];
	int i=0, j=0, wasSolved=-11;
	float **a;
	float d=0;
	float assign=0.0;
	NSString *temp; //Every value will pass through this var
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
			temp=[[_matrix objectAtIndex:i] objectAtIndex:j];
#ifdef DEBUG
			NSLog(@"In the position [%d][%d] the value is %f",i,j,[temp floatValue]);
#endif
			
			assign=[temp floatValue];
			//Pass it to the matrix
			if (i<matrixSize) {
				a[i][j]=assign;
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

- (void)solveLinear {
    [self nextSomething:nil];
	int i=0, j=0;
	float **a;
	float *b;
	float assign=0.0;
	int matrixState=0;
	NSString *temp;//Every textField will pass through this var
    
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
	for (i=0; i<matrixSize; i++) {
		for (j=0; j<matrixSize+1; j++) {
			temp=[[_matrix objectAtIndex:i] objectAtIndex:j];
#ifdef DEBUG
			NSLog(@"In the position [%d][%d] the value is %f",j,i,[temp floatValue]);
#endif
			
			assign=[temp floatValue];
			//Pass it to the matrix
			if (j<matrixSize) {
				a[i][j]=assign;
			}
			else {
				b[i]=assign;
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
@end
