//
//  CreditsViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 11/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATSOLDefines.h"

@protocol ShowCreditsViewControllerDelegate;

@interface CreditsViewController : UIViewController {
	id<ShowCreditsViewControllerDelegate> __weak delegate;
    IBOutlet UILabel *versionLabel;
}

@property(weak) id<ShowCreditsViewControllerDelegate> delegate;
@property(nonatomic, strong) IBOutlet UILabel *versionLabel;

-(IBAction)presionaBotonOcultaCreditos:(id)sender;

@end

@protocol ShowCreditsViewControllerDelegate <NSObject>

@optional

-(void)ocultaCreditos;

@end