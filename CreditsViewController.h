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
	id<ShowCreditsViewControllerDelegate> delegate;
    IBOutlet UILabel *versionLabel;
}

@property(assign) id<ShowCreditsViewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel *versionLabel;

-(IBAction)presionaBotonOcultaCreditos:(id)sender;

@end

@protocol ShowCreditsViewControllerDelegate <NSObject>

@optional

-(void)ocultaCreditos;

@end