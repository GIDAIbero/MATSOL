//
//  GIDASearchAlert.h
//  TestAlert
//
//  Created by Alejandro Paredes on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iBeroDefines.h"

@interface GIDASearchAlert : UIAlertView {
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel     *theMessage;

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle;
- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andKeyBoardType:(UIKeyboardType)uikt;
- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context 
              withRadius:(CGFloat) radius;
- (NSString *) enteredText;
- (id)initWithOutTextAreaPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andTextMessage:(NSString *)textMessage;
@end
