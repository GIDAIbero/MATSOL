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
    [versionLabel setText:[NSString stringWithFormat:@"Ver. %@ (%@)",MATSOL_VERSION, MATSOL_BUILD]];
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

- (void)dealloc {
    [versionLabel release];
    [super dealloc];
}

@end