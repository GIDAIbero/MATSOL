//
//  CreditsViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 18/10/09.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "CreditsViewController.h"
#pragma mark -

@implementation CreditsViewController

@synthesize delegate, versionLabel;

#pragma mark Actions
-(void)viewDidLoad{
    [super viewDidLoad];

	//Get the information from the plist
	NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];;
	NSString *hash = [dictionary objectForKey:@"GitSHA"];
	NSString *status = [dictionary objectForKey:@"GitStatus"];
	NSString *branch = [dictionary objectForKey:@"GitBranch"];
	NSString *version = [dictionary objectForKey:@"CFBundleShortVersionString"];

	// If the current branch is master do not output any extra information but
	// the SHA, else then print SHA@BRANCH_NAME for the info in head
	NSString *head = [NSString stringWithFormat:@"%@%@", hash, ([branch isEqualToString:@"master"] ? @"" : [NSString stringWithFormat:@"@%@", branch])];

	// when status is 1 the repository has unstaged changes, therefore append a
	// star to tipify a non-clean repository, else just print the SHA1
	[versionLabel setText:[NSString stringWithFormat:@"Ver. %@ (%@%@)", version,head,([status isEqualToString:@"1"] ? @" *" : @"")]];
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