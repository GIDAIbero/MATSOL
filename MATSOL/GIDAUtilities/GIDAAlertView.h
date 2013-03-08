//
//  GIDASearchAlert.h 2011/10/28 to 2013/02/27
//  GIDAAlertView.h since 2013/02/27
//  TestAlert
//
//  Created by Alejandro Paredes on 10/28/11.
//
// Following methods are inspired in Yoshiki Vázquez Baeza work on previous versions
// of GIDAAlertView.
// - (id)initWithMessage:(NSString *)someMessage andAlertImage:(UIImage *)someImage;
// - (id) initWithSpinnerAndMessage:(NSString *)message;
// - (void)presentAlertFor:(float)seconds;
// - (void)presentAlertWithSpinnerAndHideAfterSelector:(SEL)selector from:(id)sender;
//

#import <UIKit/UIKit.h>

@interface GIDAAlertView : UIAlertView

- (id)initWithMessage:(NSString *)someMessage andAlertImage:(UIImage *)someImage;
- (id)initWithSpinnerAndMessage:(NSString *)message;
- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle;
- (id)initWithOutTextAreaPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andTextMessage:(NSString *)textMessage;
- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle andKeyBoardType:(UIKeyboardType) uikt ;

- (void)presentAlertFor:(float)seconds;
- (void)presentAlertWithSpinnerAndHideAfterSelector:(SEL)selector from:(id)sender withObject:(id)object;

- (void)setColor:(UIColor *)color;
- (NSString *)enteredText;
- (NSString *)getTheMessage;
@end
