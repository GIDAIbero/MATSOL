//
//  Parenthesis.m
//  MATSOL
//
//  Created by Alejandro Paredes Alva on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parenthesis.h"

@implementation Parenthesis

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        round = NO;
        pColor = [UIColor whiteColor];
        [self setBackgroundColor:[UIColor clearColor]];

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame rounded:(BOOL)willBeRound {
    self = [super initWithFrame:frame];
    if (self) {
        round = willBeRound;
        pColor = [UIColor whiteColor];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame rounded:(BOOL)willBeRound color:(UIColor *)withColor {
    self = [super initWithFrame:frame];
    if (self) {
        round = willBeRound;
        pColor = withColor;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGFloat y = self.frame.size.height;
    CGFloat x = self.frame.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,pColor.CGColor);
    if (round) {
        CGContextMoveToPoint(context, 12.5, 10);
        CGContextAddCurveToPoint(context, 12.5, 10,2.5, y/2, 12.5, y-10);
        CGContextMoveToPoint(context, x-12.5, 10);
        CGContextAddCurveToPoint(context, x-12.5, 10, x-2.5, y/2, x-12.5, y-10);
    } else  {
        CGContextMoveToPoint(context, 10, 20);
        CGContextAddArcToPoint(context, 10, 10, 30, 10, 10);
        CGContextMoveToPoint(context, 10, 20);
        CGContextAddLineToPoint(context, 10, y - 20);
        CGContextAddArcToPoint(context, 10, y - 10, 30, y - 10, 10);
        CGContextMoveToPoint(context, x-10, 20);
        CGContextAddArcToPoint(context, x-10, 10, x-30, 10, 10);
        CGContextMoveToPoint(context, x-10, 20);
        CGContextAddLineToPoint(context, x - 10, y - 20);
        CGContextAddArcToPoint(context, x-10, y - 10, x-30, y - 10, 10);
        
    }
    CGContextStrokePath(context);
}


@end
