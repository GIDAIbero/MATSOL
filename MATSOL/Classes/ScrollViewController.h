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

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (retain, nonatomic) UIBarButtonItem *creditsButton;

- (void)credits;
- (IBAction)changePage:(id)sender;
@end
