//
//  DecoderViewController.h
//  MATSOL
//
//  Created by GIDA01 on 10/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATSOLDefines.h"

typedef enum{
	MATSOLResistorFirstDigit=0,
	MATSOLResistorSecondDigit,
	MATSOLResistorPower,
	MATSOLResistorTolerance
}MATSOLResistorBar;

typedef enum{
	MATSOLResistorColor=0,
	MATSOLResistorString,
}MATSOLResistorColorOrString;

@interface DecoderViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
	IBOutlet UIPickerView *colorPickerView;
	IBOutlet UITextField *valueLabel;
	IBOutlet UILabel *toleranceLabel;
	IBOutlet UIImageView *resBackground;
    
	NSMutableArray *colorViewsArray;
    NSBundle *resourcesLocation;
}

@property (nonatomic, strong) IBOutlet UIPickerView *colorPickerView;
@property (nonatomic, strong) IBOutlet UITextField *valueLabel;
@property (nonatomic, strong) IBOutlet UILabel *toleranceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *resBackground;
@property (nonatomic, strong) NSMutableArray *colorViewsArray;
@property (nonatomic, strong) NSBundle *resourcesLocation;

+ (id)stringOrColorForIndex:(int)index isStringOrColor:(MATSOLResistorColorOrString)type;
+ (char *)formatForResistorValue:(float)resistance;

@end
