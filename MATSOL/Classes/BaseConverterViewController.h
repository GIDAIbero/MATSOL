//
//  BaseConverterViewController.h
//  MATSOL
//
//  Created by GIDA01 on 10/26/10.
//  Copyright 2010 Ingeniería Electrónica -Universidad Iberoamericana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversor.h"
#import "MATSOLDefines.h"

typedef enum{
	MBaseConverterButtonFrom=-1,
	MBaseConverterButtonTo=-2,
	MBaseConverterButtonDelete=-3
}MBaseConverterButton;

@interface BaseConverterViewController : UIViewController<UIActionSheetDelegate, UIPickerViewDelegate>  {
	IBOutlet UILabel *fromLabel;
	IBOutlet UILabel *toLabel;
	
	IBOutlet UILabel *fromIndicator;
	IBOutlet UILabel *toIndicator;
	
	NSMutableArray *buttonsConverter;
	NSArray *_basesArray;
	Conversor *mainConverter;
	
	int _currentActionSheet;
	int _pickedBase;
    BOOL ip5;
}

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic, retain) IBOutlet UILabel *fromLabel;
@property (nonatomic, retain) IBOutlet UILabel *toLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromIndicator;
@property (nonatomic, retain) IBOutlet UILabel *toIndicator;
@property (nonatomic, retain) NSMutableArray *buttonsConverter;
@property (nonatomic, retain) Conversor *mainConverter;

-(void)typeStuff:(id)sender;
-(IBAction)fromOrTo:(id)sender;
-(void)lockButtons;

@end
