//
//  OutputResistorViewController.h
//  MATSOL
//
//  Created by Yoshiki  Vázquez  Baeza & Santiago Torres Arias on 25/06/10.
//  Copyright 2010 Polar Bears Nanotechnology Research ©. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MATSOLDefines.h"
#import "rescalc.h"

@interface OutputResistorViewController : UIViewController {
	float targetResistor;
	float tolerance;
	
	RESIST *network;
	
	UIButton *sign;
	UIButton *_backup;
	NSMutableArray *bandArray;
	
	IBOutlet UILabel *reminder;
	IBOutlet UILabel *achieved;

}

//Resistor User Interface Placement Point
typedef enum{
	kImageWidth			=	85,
	kImageHeight		=	40,
	kLabelButtonWidth	=	60,
	kLabelButtonHeight	=	30,
	kWireWidth			=	7,
	kWireHeight			=	112,
	kResistorX			=	30,
	kResistorY			=	125,
	kLabelButtonTopX	=	44,
	kLabelButtonTopY	=	100,
	kLabelButtonBottomX	=	44,
	kLabelButtonBottomY	=	165,
	kWireXRight			=	277,
	kWireXLeft			=	29,
	kWireY				=	35,
	kRowOffset			=	110
}RUIPlacementPoint;

typedef enum{
	kSignImageWidth		=	130,
	kSignImageHeight	=	125,
	kSignOffsetY		=	-45
}SignPlacement;

typedef enum{
	kBandWidth			=	7,
	kBandHeight			=	24,
	kBandX				=	37,
	kBandY				=	24,
	kBandOffsetX		=	11,
	kFirstBandX			=	33,
	kFirstBandY			=	21,
	kLastBandX			=	87,
	kLastBandY			=	22,
	kFirstBandHeight	=	29,
	kLastBandHeight		=	28
}ResistorBand;

typedef enum{
	kResistorLabelX					=	13,
	kResistorLabelY					=	62,
	kResistorLabelHeight			=	33,
	kResistorLabelWidth				=	82,
	kResistorLabelPositionInArray	=	4
}ResistorLabel;

@property (readwrite) float targetResistor;
@property (readwrite) float tolerance;
@property (readwrite) RESIST *network;
@property (nonatomic, retain) UIButton *sign;
@property (nonatomic, retain) NSMutableArray *bandArray;
@property (nonatomic, retain) IBOutlet UILabel *reminder;
@property (nonatomic, retain) IBOutlet UILabel *achieved;

- (void)placeNetworkWithNetworkSize:(int)networkSize;
- (void)buttonPressed:(id)sender;
- (void)signWasPressed:(id)sender;
- (void)bandColorsForLabel:(NSString *)theValue;
+ (char *)formatForResistorValue:(float)resistance;
+ (UIColor *)bandColorForNumber:(int)index;

@end
