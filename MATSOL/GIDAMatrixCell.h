//
//  GIDAMatrixCell.h
//  GIDAMatrixView
//
//  Created by Alejandro Paredes Alva on 3/4/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIDAMatrixCell : UITableViewCell

- (id)initWithRowFields:(NSArray *)row reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<UITextFieldDelegate>)delegate andRowTag:(NSInteger)rowTag andMatrixSize:(NSInteger)matrixSize;
- (void)makeNextFirstResponder ;
- (void)dismissKeyboardWithTag:(NSInteger)tag ;
-(void)setPlaceholders:(NSArray *)array andRowTag:(NSInteger)rowTag;
-(void)setMatrixRow:(NSArray *)array andRowTag:(NSInteger)rowTag;

@end
