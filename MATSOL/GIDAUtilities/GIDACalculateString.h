//
//  GIDACalculateString.h
//  Demo
//
//  Created by Alejandro Paredes Alva on 2/11/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIDACalculateString : NSObject

+(BOOL)usingThis:(NSString *)string addThis:(NSString *)newString;
+(BOOL)usingThis:(NSString *)string addThis:(NSString *)newString here:(NSRange)range;

+(NSString *)stringFrom:(NSString *)string withThis:(NSString *)newString;
+(NSString *)stringFrom:(NSString *)string withThis:(NSString *)newString here:(NSRange)range;

+(NSNumber *)solveString:(NSString *)string;

@end
