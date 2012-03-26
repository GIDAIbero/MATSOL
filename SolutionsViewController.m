//
//  SolutionsViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 11/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "SolutionsViewController.h"
#pragma mark -

@implementation SolutionsViewController

@synthesize a;	//Equations
@synthesize b;	//Solution Vector
@synthesize size;	//Size of the matrix
@synthesize labelsArray;
@synthesize layoutView;
@synthesize container;

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title=@"MATSOL";
		#ifdef	DEBUG_INTERFACE
		self.title=@"MATSOL_SOLNS";
		#endif
		
		labelsArray=[[NSMutableArray alloc] init];
		layoutView=[[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
		container=[[UIView alloc] initWithFrame:CGRectZero];
		
		//ScrollView
		layoutView.delegate=self;
		layoutView.bouncesZoom = NO;
		layoutView.backgroundColor = [UIColor clearColor];

		[layoutView addSubview:container];
	}
    return self;
}

- (void)viewDidLoad{
	int height=0, width=0;
	UITextField *temp;
	CGPoint referencePoint;
	
	//UIImageView *shape;
	//UIImageView *help=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help.png"]];
	UIView  *help = [[UIView alloc] initWithFrame:CGRectMake(0, 386, 320, 30)];
    UILabel *wlab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 120, 30)];
    UILabel *rlab = [[UILabel alloc] initWithFrame:CGRectMake(205, 0, 120, 30)];
    UIView  *wcir = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 25, 25)];
    UIView  *rcir = [[UIView alloc] initWithFrame:CGRectMake(170, 0, 25, 25)];
    
    [wcir setBackgroundColor:[UIColor whiteColor]];
    wcir.layer.cornerRadius = 12.5;
    wcir.layer.shadowColor = [UIColor blackColor].CGColor;
    wcir.layer.shadowOpacity = 0.7f;
    wcir.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    wcir.layer.shadowRadius = 5.0f;
    wcir.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:wcir.bounds];
    wcir.layer.shadowPath = path.CGPath;
    
    [rcir setBackgroundColor:[UIColor redColor]];
    rcir.layer.cornerRadius = 12.5;
    rcir.layer.shadowColor = [UIColor blackColor].CGColor;
    rcir.layer.shadowOpacity = 0.7f;
    rcir.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    rcir.layer.shadowRadius = 5.0f;
    rcir.layer.masksToBounds = NO;
    rcir.layer.shadowPath = path.CGPath;
    
    [wlab setText:NSLocalizedString(@"Inverse Matrix",@"Inverse Matrix")];
    [wlab setTextColor:[UIColor whiteColor]];
    [wlab setBackgroundColor:[UIColor clearColor]];
    [wlab setFont:[UIFont boldSystemFontOfSize:16]];
    
    [rlab setText:NSLocalizedString(@"Solutions",@"Solutions")];
    [rlab setTextColor:[UIColor redColor]];
    [rlab setBackgroundColor:[UIColor clearColor]];
    [rlab setFont:[UIFont boldSystemFontOfSize:16]];
    
    [help addSubview:wcir];
    [help addSubview:wlab];
    [help addSubview:rcir];
    [help addSubview:rlab];
    
    [wlab release];
    [wcir release];
    [rcir release];
    [rlab release];
	//Place the help right at the top of the view
	
	[self.view addSubview:help];
	[help release];
    Parenthesis *par = [[Parenthesis alloc] initWithFrame:CGRectMake(0, 2, (size*70)+27, (size*45)+16) rounded:YES];
    [container addSubview:par];
    [par release];
    par = [[Parenthesis alloc] initWithFrame:CGRectMake((size*70)+20, 2, 125, (size*45)+16) rounded:YES color:[UIColor redColor]];
    [container addSubview:par];
    [par release];
    
    
	/*
	//Add the pads to the matrix to make it fancy : P
	//Left side corner (UPPER)
    int i=0;
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ul.png"]];
	shape.frame=CGRectMake(5, 2, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	//Left side corner (LOWER)
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ll.png"]];
	shape.frame=CGRectMake(5, ((size)*45)-35, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	//Right side corner (UPPER)
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ur.png"]];
	shape.frame=CGRectMake(((size)*70), 2, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	//Right side corner (LOWER)
	shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lr.png"]];
	shape.frame=CGRectMake(((size)*70),((size)*45)-35, 22, 51);
	[container addSubview:shape];
	[shape release];
	
	//Add the enclosing lines in the matrix : P
	for (i=1; i<size; i++) {
		//Leftside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(5, (i*45)-35, 12, 66);
		[container addSubview:shape];
		[shape release];
		
		//Rightside enclosing lines
		shape=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
		shape.frame=CGRectMake(((size+1)*70)-58, (i*45)-35, 12, 66);
		[container addSubview:shape];
		[shape release];
	}
	*/
	//Assign as many text fields as needed.
	for (height=0; height<size+1; height++) {
		[labelsArray insertObject:[[[NSMutableArray alloc] init] autorelease] atIndex:height];
		for (width=0; width<size; width++) { 
			[[labelsArray objectAtIndex:height] insertObject:[[[UILabel alloc] initWithFrame:CGRectMake(((height+1)*70)-55,((width+1)*45)-30, 65, 30)] autorelease] atIndex:width];
			temp=[[labelsArray objectAtIndex:height] objectAtIndex:width];
			
			//Attributes for textfields that are not the solution column
			temp.adjustsFontSizeToFitWidth=YES;
			temp.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:25];
			temp.textAlignment=UITextAlignmentCenter;
			temp.backgroundColor=[UIColor clearColor];
			
			if (height<size) {
				if (a[width][height]<1 || a[width][height]>-1) {
					temp.text=[NSString stringWithFormat:@"%.5f",a[width][height]];
				}
				if (a[width][height]==0) {
					temp.text=[NSString stringWithFormat:@"0"];
				}
				if (a[width][height]>1) {
					temp.text=[NSString stringWithFormat:@"%.3f",a[width][height]];
				}
				temp.textColor=[UIColor whiteColor];
			}
			else {
				
				//Data for the solution text fields
				temp.textColor=[UIColor redColor];
				
				//Formatting the string for the solutions column
				if (b[width]<1 || b[width]>-1) {
					temp.text=[NSString stringWithFormat:@"%c=%.5f",width+97,b[width]];
				}
				if (b[width]>1) {
					temp.text=[NSString stringWithFormat:@"%c=%.3f",width+97,b[width]];
				}
				temp.frame=CGRectMake(((height+1)*70)-55,((width+1)*45)-30, 95, 30);
				temp.textAlignment=UITextAlignmentLeft;
				
				//Solution column
				referencePoint=temp.center;
				referencePoint.x=referencePoint.x+20;
				temp.center=referencePoint;
			}
			
			//free the memory
			[container addSubview:temp];
		}
	}
	
	container.frame=CGRectMake(0, 0, (75*(size+1))+50,(55*size)+15);
    layoutView.contentSize = container.frame.size;
	layoutView.frame=CGRectMake(0, 0, 320, 386);
    
	//Add the scrollview to the view of the viewController
    [[self view] addSubview:layoutView];
}

#pragma mark MemoryManagement
- (void)viewDidUnload {
    [super viewDidUnload];
	labelsArray=nil;
	container=nil;
	layoutView=nil;
}

- (void)dealloc {
	free(a);
	free(b);
	
	[labelsArray release];
	[container release];
	[layoutView release];
	
	[super dealloc];
}


@end
