//
//  CreditsViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 18/10/09.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "CreditsViewController.h"
#pragma mark -

@interface CreditsViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *bar;

@end

@implementation CreditsViewController

@synthesize delegate, versionLabel;
@synthesize resourcesLocation;

#pragma mark Actions
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        self.resourcesLocation = nibBundleOrNil;
        NSLog(@"%@",self.resourcesLocation.bundlePath);

    }
    return self;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%@",self.resourcesLocation.bundlePath);
	//Get the information from the plist
	NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];;
	NSString *hash = [dictionary objectForKey:@"GitSHA"];
	NSString *status = [dictionary objectForKey:@"GitStatus"];
	NSString *branch = [dictionary objectForKey:@"GitBranch"];
	NSString *version = [dictionary objectForKey:@"CFBundleShortVersionString"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"BrushedMetalBackground" ofType:@"png"]]]];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"MATSOLLogo" ofType:@"png"]]];
    [logo setFrame:CGRectMake(60, 30, 200, 200)];
    [self.view addSubview:logo];
	// If the current branch is master do not output any extra information but
	// the SHA, else then print SHA@BRANCH_NAME for the info in head
	NSString *head = [NSString stringWithFormat:@"%@%@", hash, ([branch isEqualToString:@"master"] ? @"" : [NSString stringWithFormat:@"@%@", branch])];

	// when status is 1 the repository has unstaged changes, therefore append a
	// star to tipify a non-clean repository, else just print the SHA1
	[versionLabel setText:[NSString stringWithFormat:@"Ver. %@ (%@%@)", version,head,([status isEqualToString:@"1"] ? @" *" : @"")]];
    
    CGFloat iosVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosVer >= 7.0) {
        CGRect frame = _bar.frame;
        frame.size.height += 20;
        [_bar setFrame:frame];
        [_bar setTintColor:[UIColor whiteColor]];
        [_bar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"BrushedMetalBackground" ofType:@"png"]]]];
        [_bar setTranslucent:NO];
    } else {
        [_bar setBackgroundColor:[UIColor darkGrayColor]];
    }

}

-(IBAction)presionaBotonOcultaCreditos:(id)sender{
	if([self.delegate respondsToSelector:@selector(ocultaCreditos)]){
		[self.delegate ocultaCreditos];
	}
}

#pragma mark MemoryManagement
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


@end