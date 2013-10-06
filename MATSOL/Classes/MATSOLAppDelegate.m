//
//  MATSOLAppDelegate.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 09/06/10.
//  Copyright Polar Bears Nanotechnology Research © 2010. All rights reserved.
//

#import "MATSOLAppDelegate.h"
#import <Foundation/Foundation.h>
#pragma mark -

@implementation MATSOLAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize resourcesLocation;

#pragma mark Initialization
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//Create the main view controller, this view controller allows the
	//iPhone-ish look, if more apps are to be added, go to SlaveViewController
    
    float systemVersion;
    
    //this small blocks controls the bundle loading
    systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >=7.0){
        self.resourcesLocation = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Current" withExtension:@"bundle" ]];
        NSLog(@"loading current bundle");
    }else{
        self.resourcesLocation = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Default" withExtension:@"bundle" ]];

    }
    
    NSLog(@"%@",[[NSBundle mainBundle] pathsForResourcesOfType:@"bundle" inDirectory:@"/" ]);
	ScrollViewController *firstViewController=[[ScrollViewController alloc] initWithNibName:@"Scroll" bundle:self.resourcesLocation];
	
	//This button allows the home navigation when the bar is touched
	UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[homeButton setFrame:CGRectMake(0, 0, 95, 30)];
	[homeButton setBackgroundColor:[UIColor clearColor]];
	[homeButton setCenter:CGPointMake(160, 45)];
	[homeButton setShowsTouchWhenHighlighted:YES];
	[homeButton addTarget:self action:@selector(goToRootViewController:)  forControlEvents:UIControlEventTouchUpInside];
	
	navigationController=[[UINavigationController alloc] initWithRootViewController:firstViewController];
    [navigationController.navigationBar setTranslucent:NO];
    [navigationController.navigationBar setOpaque:YES];
    if (systemVersion >= 7.0) {
        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[self.resourcesLocation pathForResource:@"BrushedMetalBackground" ofType:@"tiff"]]]];
    } else {
        [[navigationController navigationBar] setTintColor:[UIColor darkGrayMATSOL]];
    }

	//The homeButton must be added after the navigationController
	//in order to make it work 
	//[window addSubview:navigationController.view];
	[window addSubview:homeButton];
    self.window.rootViewController = navigationController;
	[window makeKeyAndVisible];
	return YES;
}

#pragma mark ButtonMethods
- (void)goToRootViewController:(id)sender{
	[navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark MemoryManagement


@end