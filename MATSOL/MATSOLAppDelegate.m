//
//  MATSOLAppDelegate.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 09/06/10.
//  Copyright Polar Bears Nanotechnology Research © 2010. All rights reserved.
//

#import "MATSOLAppDelegate.h"
#pragma mark -

@implementation MATSOLAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark Initialization
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//Create the main view controller, this view controller allows the
	//iPhone-ish look, if more apps are to be added, go to SlaveViewController
	ScrollViewController *firstViewController=[[ScrollViewController alloc] initWithNibName:@"Scroll" bundle:nil];
	
	//This button allows the home navigation when the bar is touched
	UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[homeButton setFrame:CGRectMake(0, 0, 95, 30)];
	[homeButton setBackgroundColor:[UIColor clearColor]];
	[homeButton setCenter:CGPointMake(160, 45)];
	[homeButton setShowsTouchWhenHighlighted:YES];
	[homeButton addTarget:self action:@selector(goToRootViewController:)  forControlEvents:UIControlEventTouchUpInside];
	
	navigationController=[[UINavigationController alloc] initWithRootViewController:firstViewController];
    [[navigationController navigationBar] setTintColor:[UIColor darkGrayMATSOL]];
    
	[firstViewController release];
	//The homeButton must be added after the navigationController
	//in order to make it work 
	[window addSubview:navigationController.view];
	[window addSubview:homeButton];
	[window makeKeyAndVisible];
	return YES;
}

#pragma mark ButtonMethods
- (void)goToRootViewController:(id)sender{
	[navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark MemoryManagement
- (void)dealloc {
    navigationController = nil;
	[navigationController release];
    [window release];
	
    [super dealloc];
}


@end