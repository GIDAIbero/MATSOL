//
//  Parenthesis.h
//  MATSOL
//
//  Created by Alejandro Paredes Alva on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Parenthesis : UIView {
    BOOL round;
    UIColor *pColor;
}

-(id)initWithFrame:(CGRect)frame rounded:(BOOL)willBeRound ;
-(id)initWithFrame:(CGRect)frame rounded:(BOOL)willBeRound color:(UIColor *)withColor;
@end
