//
//  ScrollViewController.m
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 20/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import "ScrollViewController.h"
#pragma mark -

static NSUInteger kNumberOfPages = NUMBER_OF_MENU_PAGES;

@interface ScrollViewController (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation ScrollViewController

@synthesize scrollView; 
@synthesize pageControl;
@synthesize viewControllers;
@synthesize creditsButton;

#pragma mark Initialization
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		[self setTitle:@"MATSOL"];
		
        #ifdef	DEBUG_INTERFACE
		[self setTitle:@"MATSOL_MENU"];
		#endif
		
        creditsButton=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", @"About string") style:UIBarButtonItemStyleBordered target:self action:@selector(credits)];
		[[self navigationItem] setLeftBarButtonItem:creditsButton];        
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Set some colors
	[scrollView setBackgroundColor:[UIColor clearColor]];
	[pageControl setBackgroundColor:[UIColor colorWithRed:.161 green:.161 blue:0.161 alpha:0.6]];	
	
	// view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
	[controllers release];
	
    // a page is the width of the scroll view
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setScrollsToTop:NO];
    [[self scrollView] setDelegate:self];
    
    [[self pageControl] setNumberOfPages:kNumberOfPages];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] setHidesForSinglePage:YES];


    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];    
}


#pragma mark CreditsViewControllerMethods
-(void)credits{
	CreditsViewController *creditsViewController=[[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
	creditsViewController.title=NSLocalizedString(@"About", @"About string");
	creditsViewController.delegate=self;
	[self presentModalViewController:creditsViewController animated:YES];
	[creditsViewController release];
}

//CREDITS -> HIDE CREDITS
-(void)ocultaCreditos{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark MemoryManagement
- (void)viewDidUnload {
    [super viewDidUnload];
	viewControllers=nil;
	scrollView=nil;
	pageControl=nil;
	creditsButton=nil;
}

- (void)dealloc {
    [viewControllers release];
    [scrollView release];
    [pageControl release];
	[creditsButton release];
    [super dealloc];
}

#pragma mark ScrollViewDelegateMethods
- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return; //Nowhere to go
    if (page >= kNumberOfPages) return;//Nowhere to go
	
    // replace the placeholder if necessary
    SlaveViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[SlaveViewController alloc] initWithPageNumber:page];
		[controller setFatherNavigationController:self.navigationController];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	
    // add the controller's view to the scroll view
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
