//
//  MATSOLAppDelegate.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 09/06/10.
//  Copyright Polar Bears Nanotechnology Research © 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATSOLDefines.h"
#import "ScrollViewController.h"

@interface MATSOLAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

- (void)goToRootViewController:(id)sender;

@end

