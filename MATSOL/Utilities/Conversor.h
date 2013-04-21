//
//  conversor.h
//  convertirbase
//
//  Created by Alejandro Paredes Alva on 10/26/10.
//  Copyright 2010 aparedes.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MATSOLDefines.h"

@interface Conversor : NSObject {
	int fromBase;
	int toBase;
	NSString *number;
}

@property int fromBase;
@property int toBase;
@property (nonatomic, strong) NSString *number;

@end
