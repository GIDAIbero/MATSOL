//
//  GIDASearchAlert.m
//  TestAlert
//
//  Created by Alejandro Paredes on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
///

#import "GIDASearchAlert.h"

@implementation GIDASearchAlert
@synthesize textField;
@synthesize theMessage;

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:UITextAlignmentCenter];
        [theTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [self addSubview:theTextField];
        
        self.textField = theTextField;
        [theTextField release];
        
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
            [self setTransform:translate];
        }
    }
    return self;
}

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andKeyBoardType:(UIKeyboardType) uikt {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setTextAlignment:UITextAlignmentCenter];
        [theTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
        [theTextField setKeyboardType:uikt];
        [self addSubview:theTextField];
        
        self.textField = theTextField;
        [theTextField release];
        
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
            [self setTransform:translate];
        }
    }
    return self;
}



- (id)initWithOutTextAreaPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andTextMessage:(NSString *)textMessage {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    if (self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
        [label setBackgroundColor:[UIColor clearColor]];       
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setText:textMessage];
        [self addSubview:label];
        theMessage = label;
        [label release];
        // if not >= 4.0
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if (![sysVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending) {
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
            [self setTransform:translate];
        }
    }
    return self;
}

- (void)show {
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText {
    return textField.text;
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}

- (void) layoutSubviews {
	for (UIView *sub in [self subviews])
	{
		if([sub class] == [UIImageView class] && sub.tag == 0)
		{
			[sub removeFromSuperview];
			break;
		}
	}
} 

- (void)drawRect:(CGRect)rect
{	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextClearRect(context, rect);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.8); 
	CGContextSetLineWidth(context, 2.0);
    UIColor *fillColor = [UIColor blackColor];
    UIColor *borderColor = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8];
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);

	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, 
                                 rect.origin.y + backOffset, 
                                 rect.size.width - backOffset*2, 
                                 rect.size.height - backOffset*2);
    
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);

	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1, 
                                 backRect.origin.y + backOffset-1, 
                                 backRect.size.width - (backOffset-1)*2, 
                                 backRect.size.height - (backOffset-1)*2);
    
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);

	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, 
                                                        components, locations, num_locations);
    
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2), 
                                 rect.size.width/2);
    
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
    
	CGContextSetAlpha(context, 0.8); 
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
    
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context 
              withRadius:(CGFloat) radius
{
	CGContextBeginPath (context);
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
    
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect);
    
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}
@end
