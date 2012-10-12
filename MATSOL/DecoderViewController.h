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
	
	NSMutableArray *colorViewsArray;
}

@property (nonatomic, retain) IBOutlet UIPickerView *colorPickerView;
@property (nonatomic, retain) IBOutlet UITextField *valueLabel;
@property (nonatomic, retain) IBOutlet UILabel *toleranceLabel;
@property (nonatomic, retain) NSMutableArray *colorViewsArray;

+ (id)stringOrColorForIndex:(int)index isStringOrColor:(MATSOLResistorColorOrString)type;
+ (char *)formatForResistorValue:(float)resistance;

@end
