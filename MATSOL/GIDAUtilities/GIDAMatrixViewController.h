//
//  GIDAMatrixViewController.h
//  GIDAMatrixView
//
//  Created by Alejandro Paredes Alva on 3/3/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIDAMatrixCell.h"
#import "SolutionsViewController.h"
#import "mygaussj.h"
#import "MATSOLDefines.h"
#import "GIDAAlertView.h"
#import "Parenthesis.h"
#import "GIDACalculateString.h"
#import "myludcmp.h"


enum {
    GIDALinearEquations = 0,
    GIDADeterminant     = 1
};
typedef NSUInteger GIDASolver;

@interface GIDAMatrixViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (id)initWithMatrixSize:(NSInteger)size andSolver:(GIDASolver)solver;
@end
