//
//  ScrollViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 20/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlaveViewController.h"
#import "CreditsViewController.h"
#import "MATSOLDefines.h"

@interface ScrollViewController : UIViewController <UIScrollViewDelegate, ShowCreditsViewControllerDelegate>{
	UIScrollView *scrollView;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	UIBarButtonItem *creditsButton;
	
    BOOL pageControlUsed;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (strong, nonatomic) UIBarButtonItem *creditsButton;

- (void)credits;
- (IBAction)changePage:(id)sender;
@end
