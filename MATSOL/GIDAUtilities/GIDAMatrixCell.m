//
//  GIDAMatrixCell.m
//  GIDAMatrixView
//
//  Created by Alejandro Paredes Alva on 3/4/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import "GIDAMatrixCell.h"

@interface GIDAMatrixCell () {
    NSInteger tfTag;
}


@end
@implementation GIDAMatrixCell

- (id)initWithRowFields:(NSArray *)row reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<UITextFieldDelegate>)delegate andRowTag:(NSInteger)rowTag andMatrixSize:(NSInteger)matrixSize {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        tfTag = 0;
        int x = 5;
        int i = 0;
        
        for (NSString *text in row) {
            UITextField *tf = nil;
            if (i < matrixSize) {
                tf = [[UITextField alloc] initWithFrame:CGRectMake(x, 7.5, 65, 30)];
            } else {
                tf = [[UITextField alloc] initWithFrame:CGRectMake(x+30, 7.5, 65, 30)];
            }
            
            tf.borderStyle=UITextBorderStyleRoundedRect;
            tf.adjustsFontSizeToFitWidth=YES;
            tf.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:20];
            tf.textColor=[UIColor blackColor];
            tf.keyboardType=UIKeyboardTypeDecimalPad;
            
            //Attributes for textfields that are not the solution column
            UIBarButtonItem *ubbi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RightIcon.png"] style:UIBarButtonItemStylePlain target:delegate action:@selector(nextSomething:)];
            UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftIcon.png"] style:UIBarButtonItemStylePlain target:delegate action:@selector(previousSomething:)];
            UIBarButtonItem *lesskey = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DownIcon.png"] style:UIBarButtonItemStylePlain target:delegate action:@selector(dismissKeyboard:)];
            [lesskey setTag:i];
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *sign  = [[UIBarButtonItem alloc] initWithTitle:@"+/-" style:UIBarButtonItemStylePlain target:delegate action:@selector(signChange:)];
            UIBarButtonItem *fraction  = [[UIBarButtonItem alloc] initWithTitle:@"/" style:UIBarButtonItemStylePlain target:delegate action:@selector(operator:)];
            UIBarButtonItem *openPar  = [[UIBarButtonItem alloc] initWithTitle:@"(" style:UIBarButtonItemStylePlain target:delegate action:@selector(operator:)];
            UIBarButtonItem *closePar  = [[UIBarButtonItem alloc] initWithTitle:@")" style:UIBarButtonItemStylePlain target:delegate action:@selector(operator:)];
            UIBarButtonItem *betweenArrowsSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [betweenArrowsSpace setWidth:18];
            UIBarButtonItem *betweenSignAndArrowSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            [betweenSignAndArrowSpace setWidth:25];
            
            UIToolbar *kbtb = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
            [kbtb setBarStyle:UIBarStyleBlackTranslucent];
            [kbtb setItems:[NSArray arrayWithObjects:lesskey,space,sign, space, fraction, space, openPar, space, closePar, space, back, betweenSignAndArrowSpace,ubbi,nil]];
            
            [ubbi release];
            [lesskey release];
            [space release];
            [sign release];
            [back release];
            [openPar release];
            [closePar release];
            
            [betweenArrowsSpace release];
            [betweenSignAndArrowSpace release];
            
            tf.inputAccessoryView = kbtb;
            tf.keyboardAppearance = UIKeyboardAppearanceAlert;
            tf.textAlignment      = UITextAlignmentRight;
            tf.returnKeyType      = UIReturnKeyNext;
            
            
            [tf setTag:(rowTag*100)+(i++)];
            [tf setDelegate:delegate];
            [tf setBackgroundColor:[UIColor whiteColor]];
            
            [tf setPlaceholder:text];
            [tf setBorderStyle:UITextBorderStyleRoundedRect];
            [[self contentView] addSubview:tf];
            x += 70;
        }
       // [self setPlaceholders:row andRowTag:rowTag andDelegate:delegate];
        [[self contentView] setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
-(void)setMatrixRow:(NSArray *)array andRowTag:(NSInteger)rowTag {
 //   NSLog(@"%d",rowTag);
    for (id view in [[self contentView] subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            NSInteger obj = [view tag] - ((int)([view tag]/100))*100;
            [view setTag:(rowTag * 100) + obj];
            if ([[array objectAtIndex:obj] isEqual:@""]) {
                [view setText:@""];
            } else {
                [view setText:[array objectAtIndex:obj]];
            }
        }
    }
}

-(void)setPlaceholders:(NSArray *)array andRowTag:(NSInteger)rowTag {
    for (id view in [[self contentView] subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            NSInteger obj = [view tag] - ((int)([view tag]/100))*100;
            [view setTag:(rowTag * 100) + obj];
            [view setPlaceholder:[array objectAtIndex:obj]];
        }
    }
}

- (void)dismissKeyboardWithTag:(NSInteger)tag {

    [[[self contentView] viewWithTag:tag] resignFirstResponder];
    
 //   [((UIBarButtonItem *)sender).target resignFirstResponder];
    //    [textField resignFirstResponder];
}

- (void)setValuesToTextFieldsWithArray:(NSArray *)array {
    for (int i = 0; i < [array count]; i++) {
        [(UITextField *)[[self contentView] viewWithTag:i] setText:[array objectAtIndex:i]];
    }
}
- (void)makeNextFirstResponder {
    tfTag ++;
    [[[self contentView] viewWithTag:tfTag] becomeFirstResponder];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
