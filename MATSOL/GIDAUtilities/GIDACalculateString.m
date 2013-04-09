//
//  GIDACalculateString.m
//  Demo
//
//  Created by Alejandro Paredes Alva on 2/11/13.
//  Copyright (c) 2013 Alejandro Paredes Alva. All rights reserved.
//

#import "GIDACalculateString.h"

enum {
    GIDAOperatorNone             = 0,
    GIDAOperatorOpenParentheses  = 1,
    GIDAOperatorCloseParentheses = 2,
    GIDAOperatorFraction         = 3,
    GIDAOperatorTimes            = 4,
    GIDAOperatorPlus             = 5,
    GIDAOperatorMinus            = 6
};
typedef NSUInteger GIDAOperator;

@interface GIDACalculateString ()

+(BOOL)checkFor:(char)character inThis:(NSString *)string fromThis:(int)position whereThisAre:(NSCharacterSet *)notAllowed andThisHelps:(NSCharacterSet *)toStop;
+(BOOL)checkThis:(NSString *)string atThis:(int)position ifLeftDoesNotHave:(NSCharacterSet *)leftCheck norRightHas:(NSCharacterSet *)rightCheck allowFirst:(BOOL)first;
+(int)openParenthesesFor:(NSString *)string toLocation:(int)position;
+(NSString *)fixString:(NSString *)string;
+(NSNumber *)solveString:(NSString *)string andOperator:(GIDAOperator)operator;
+(NSArray *)splitString:(NSString *)string byOperator:(GIDAOperator)operator;
+(NSArray *)splitFirstParentheses:(NSString *)string;

@end

@implementation GIDACalculateString


//String appending newString to String.
+(NSString *)stringFrom:(NSString *)string withThis:(NSString *)newString {
    return [string stringByAppendingString:newString];
}

//String by cutting at the range location and putting the newString in between.
+(NSString *)stringFrom:(NSString *)string withThis:(NSString *)newString here:(NSRange)range {
    NSString *fullString = nil;
    if ([self usingThis:string addThis:newString here:range]) {
        NSString *preString = [string substringToIndex:range.location];
        NSString *postString = [string substringFromIndex:range.location];
        fullString = [[preString stringByAppendingString:newString] stringByAppendingString:postString];
    } else {
        fullString = string;
    }
    return fullString;
}

//Check if the character at position and its left is not included in a list of characters. Each side has special characters not allowed.
+(BOOL)checkThis:(NSString *)string atThis:(int)position ifLeftDoesNotHave:(NSCharacterSet *)leftCheck norRightHas:(NSCharacterSet *)rightCheck allowFirst:(BOOL)first{
    BOOL success = YES;
    
    //Do a check to the left character.
    if (position!= 0) {
        if ([leftCheck characterIsMember:[string characterAtIndex:position-1]])
            success = NO;
    } else {
        //If the position is 0 and it is not allowed to be the first character, then say it can't be placed there.
        if (!first) {
            success = NO;
        }
    }
    
    //Do a check to the right of there the character will be. (its the position)
    if (position < [string length]) {
        if ([rightCheck characterIsMember:[string characterAtIndex:position]]) {
            success = NO;
        }
    }
    
    return success;
}

//Go from position to left and right to check if there is a character not allowed. Can use extra characters to stop search.
+(BOOL)checkFor:(char)character inThis:(NSString *)string fromThis:(int)position whereThisAre:(NSCharacterSet *)notAllowed andThisHelps:(NSCharacterSet *)toStop {
    BOOL success = YES;
    
    //Check from the begining until: the position, found a character that helps the stop or found a not allowed character.
    for (int i = position; i >= 0; i--) {
        if ([notAllowed characterIsMember:[string characterAtIndex:i]]) {
            success = NO;
            i = -1;
        } else {
            if ([toStop characterIsMember:[string characterAtIndex:i]]) {
                i = -1;
            }
        }
    }
    
    //Check to the right until: the end, found a character that helps the stop or found a not allowed character.
    for (int i = position; i < [string length]; i++) {
        if ([notAllowed characterIsMember:[string characterAtIndex:i]]) {
            success = NO;
            i = [string length];
        } else {
            if ([toStop characterIsMember:[string characterAtIndex:i]]) {
                i = [string length];
            }
        }
    }
    
    return success;
}

//Check if the string contains parentheses. Split the string with '('.
//If more than 1 object at array that means there is at least 1 parenthesis.
+(BOOL)hasParentheses:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"("];
    if ([array count] > 1) {
        return YES;
    }
    return NO;
}

//How many parentheses are left open from begining of string to position.
+(int)openParenthesesFor:(NSString *)string toLocation:(int)position {
    int open = 0;
    int close = 0;
    
    for (int i = 0; i < position; i++) {
        switch ([string characterAtIndex:i]) {
            case '(':
                open++;
                break;
            case ')':
                close++;
                break;
        }
    }
    
    return open - close;
}

//call the same function but with the position at the end. Use this if it is always at the end.
//If not use the same but with aroundThis:range.
+(BOOL)usingThis:(NSString *)string addThis:(NSString *)newString {
    return [self usingThis:string addThis:newString here:(NSMakeRange(0, [string length]))];
}

//Check if the newString is a valid string or character to add to the string in the range position.
+(BOOL)usingThis:(NSString *)string addThis:(NSString *)newString here:(NSRange)range {
    BOOL success = YES;
    
    //if newString is empty then it means it wants to delete.
    //As default all deletions are allowed.
    if ([newString length] == 0) {
        return YES;
    }
    
    //Selecting several characters to delete and insert new character at position.
    //Cut string, remove the middle part and put together the sides.
    if (range.length > 0) {
        NSString *preString = [string substringToIndex:range.location];
        NSString *postString = [string substringFromIndex:range.location+range.length];
        string = [preString stringByAppendingString:postString];
    }
    
    //If the newString has more than one character.
    //Go through each character checking if it is allowed in the string.
    //If the character is allowed it is appended to the string to continue checking the next character.
    if ([newString length] > 1) {
        range.length = 0;
        for (int i = 0; i < [newString length]; i++) {
            if ([self usingThis:string addThis:[NSString stringWithFormat:@"%c",[newString characterAtIndex:i]] here:range]) {
                string = [string stringByAppendingFormat:@"%c",[newString characterAtIndex:i]];
                range.location ++;
            } else {
                success = NO;
                i = [newString length];
            }
        }
    } else {
        //newString is of 1 character.
        
        //If its the first character to input, check if it is an allowed character.
        //Allowed characters as first character of input are '.', '-', '(' and numbers from 0 to 9.
        if ([string length] == 0 || range.location == 0) {
            if ([newString characterAtIndex:0] == '.' || [newString characterAtIndex:0] == '-' || [newString characterAtIndex:0] == '(' || ([newString characterAtIndex:0] >= '0' && [newString characterAtIndex:0] <= '9')) {
                success = YES;
            } else {
                success = NO;
            }
        } else {
            NSCharacterSet *notAllowed;
            NSCharacterSet *toStop;
            NSCharacterSet *left;
            NSCharacterSet *right;
            
            //Depending on the character to add differend operations are handled.
            switch ([newString characterAtIndex:0]) {
                case '.':
                    //The user is not allowed to put only ONE '.' in a series of numbers in between operators.
                    notAllowed = [NSCharacterSet characterSetWithCharactersInString:@"."];
                    toStop = [NSCharacterSet characterSetWithCharactersInString:@"()/+-*"];
                    success = [self checkFor:'.' inThis:string fromThis:range.location-1 whereThisAre:notAllowed andThisHelps:toStop];
                    break;
                case '+':
                    //The user is not allowed to put a '+' sign when on the left there is a  '(', '+', '-', '*', or '/'.
                    //To the right of a '+' sign there can not be a ')', '+', '-', '*', or '/'.
                    left = [NSCharacterSet characterSetWithCharactersInString:@"(+-*/"];
                    right = [NSCharacterSet characterSetWithCharactersInString:@"+-*/)"];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:NO];
                    break;
                case '-':
                    //The user is not allowed to put a '+' sign when on the left there is a '-'.
                    //To the right of a '-' sign there can not be a ')', '+', '-', '*', or '/'.
                    left = [NSCharacterSet characterSetWithCharactersInString:@"-"];
                    right = [NSCharacterSet characterSetWithCharactersInString:@"+-*/)"];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:YES];
                    break;
                case '*':
                    //The user is not allowed to put a '*' sign when on the left there is a  '(', '+', '-', '*', or '/'.
                    //To the right of a '*' sign there can not be a ')', '+', '-', '*', or '/'.
                    left = [NSCharacterSet characterSetWithCharactersInString:@"(+-*/"];
                    right = [NSCharacterSet characterSetWithCharactersInString:@"+-*/)"];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:NO];
                    break;
                case '/':
                    //The user is not allowed to put a '/' sign when on the left there is a  '(', '+', '-', '*', or '/'.
                    //To the right of a '/' sign there can not be a ')', '+', '-', '*', or '/'.
                    left = [NSCharacterSet characterSetWithCharactersInString:@"(+-*/"];
                    right = [NSCharacterSet characterSetWithCharactersInString:@"+*/)"];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:NO];
                    break;
                case '(':
                    //To put a '(', there can not be a ')', '+', '-', '*', or '/' to the right.
                    //There is no limitation to the left. '(' can go after any character
                    left = [NSCharacterSet characterSetWithCharactersInString:@""];
                    right = [NSCharacterSet characterSetWithCharactersInString:@"+*/)"];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:NO];
                    break;
                case ')':
                    //To put a ')', there can not be a ')', '+', '-', '*', or '/' to the left.
                    //There is no limitation to the right. ')' can go before any character.
                    //Except if there is no open parentheses from the begining of the string to its position.
                    left = [NSCharacterSet characterSetWithCharactersInString:@"(+-*/"];
                    right = [NSCharacterSet characterSetWithCharactersInString:@""];
                    success = [self checkThis:string atThis:range.location ifLeftDoesNotHave:left norRightHas:right allowFirst:NO];
                    if (success) {
                        if ([self openParenthesesFor:string toLocation:range.location] <= 0) {
                            success = NO;
                        }
                    }
                    break;
                default:
                    //Numbers can go anywhere.
                    success = YES;
                    break;
            }
        }
    }
    return success;
}

//Fix the string in case the string presents operation simplifications.
//First replace with keywords so that no error is done when replacing.
//Replace keywords with correct syntax.
+(NSString *)fixString:(NSString *)string {
    NSMutableString *mutable = [NSMutableString stringWithString:string];
    
    //---THIS COULD BE OPTIMIZED?? ---//
    [mutable replaceOccurrencesOfString:@")(" withString:@"CO"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"--" withString:@"MM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"-(" withString:@"BM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@")-" withString:@"CM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"(-" withString:@"OM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"*-" withString:@"TM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"/-" withString:@"FM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"+-" withString:@"PM"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"-"  withString:@"+-"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"MM" withString:@"+"    options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"PM" withString:@"+-"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"FM" withString:@"/-"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"TM" withString:@"*-"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"OM" withString:@"(-"   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"CM" withString:@")+-"  options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"BM" withString:@"-1*(" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    [mutable replaceOccurrencesOfString:@"CO" withString:@")*("   options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    
    return mutable;
}

//Split in string in 3 parts.
//Before the first parentheses
//The parentheses, between open and close.
//After the parentheses.
//If all string is the parentheses then it is put in the middle and empty trings on the sides.
+(NSArray *)splitFirstParentheses:(NSString *)string {
    int i = 0;
    NSArray *parentheses = nil;
    
    //Look for the first '('
    for (i = 0; i < [string length]; i++) {
        if ([string characterAtIndex:i] == '(') {
            break;
        }
    }
    NSString *pre = [string substringToIndex:i];
    
    //Did it find a '('
    if (i == [string length]) {
        //Did not find a '(', put string in the middle.
        parentheses = [NSArray arrayWithObjects:@"",pre, @"", nil];
    } else {
        //Did find a '('.
        //If the there is a number before '(', then append to pre a '*'. (As it is a simplification)
        if (i != 0) {
            if ([string characterAtIndex:i-1] >= '0' && [string characterAtIndex:i-1] <= '9') {
                pre = [pre stringByAppendingString:@"*"];
            }
        }
        //par is string where the parentheses is. (without the parentheses)
        NSString *par = [string substringFromIndex:i+1];
        
        //Look for the close parentheses. Use open in case there are subparentheses inside.
        int open = 0;
        for (i = 0; i < [par length]; i++) {
            if ([par characterAtIndex:i] == '('){
                open ++;
            } else {
                
                if ([par characterAtIndex:i] == ')') {
                    if (open == 0) {
                        break;
                    } else {
                        open --;
                    }
                }
            }
        }
        
        NSString *post = @"";
        //If the last character of par is ) then remove it and have post be "".
        //If it is not. Cut the string and put the ending part in post.
        if (i < [par length] - 1){
            post = [par substringFromIndex:i+1];
            if ([post characterAtIndex:0] >= '0' && [post characterAtIndex:0] <= '9') {
                post = [@"*" stringByAppendingString:post];
            }
        }
        par = [par substringToIndex:i];
        
        parentheses = [NSArray arrayWithObjects:pre, par, post, nil];
    }
    return parentheses;
}

//Split a string based on its GIDAOperator.
//Only exception is parentheses and minus.
//Minus does not require spliting as it is considered a negative adition.
//For parentheses call splitFirstPArentheses.
+(NSArray *)splitString:(NSString *)string byOperator:(GIDAOperator)operator {
    NSArray *split = nil;
    switch (operator) {
        case GIDAOperatorOpenParentheses:
            split = [self splitFirstParentheses:string];
            break;
        case GIDAOperatorPlus:
            split = [string componentsSeparatedByString:@"+"];
            break;
        case GIDAOperatorTimes:
            split = [string componentsSeparatedByString:@"*"];
            break;
        case GIDAOperatorFraction:
            split = [string componentsSeparatedByString:@"/"];
            break;
        default:
            break;
    }
    return split;
}

//Solve string based on operator.
+(NSNumber *)solveString:(NSString *)string andOperator:(GIDAOperator)operator {
    float total = 0;
    NSNumber *number = nil;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *temp = nil;
    
    //Split the string based on the GIDAOperator.
    NSArray *split = [self splitString:string byOperator:operator];
    
    //Go through the split string. 
    for (int i = 0; i < [split count]; i++) {
        switch (operator) {
            case GIDAOperatorPlus:
                //Plus operation.
                if (i == 0 && [[split objectAtIndex:i] isEqualToString:@""]){
                } else {
                    //Try to format to a number.
                    temp = [formatter numberFromString:[split objectAtIndex:i]];
                    if (temp) {
                        //If it was a number add it to the total, and update number.
                        total += [temp floatValue];
                        number = [NSNumber numberWithFloat:total];
                    } else {
                        //If not a number maybe it has '*' or '/'. So try with '*'
                        number = [self solveString:[split objectAtIndex:i] andOperator:GIDAOperatorTimes];
                        if (!number) {
                            //Not a number then abort
                            i = [split count];
                        } else {
                            //Add the value returned to total, and update number.
                            total += [number floatValue];
                            number = [NSNumber numberWithFloat:total];
                        }
                    }
                }
                break;
            case GIDAOperatorTimes:
                //Times operator. (Make total 1.0, to be able to do the mutliplications.
                if (i == 0) {
                    total = 1.0;
                }
                
                //Try to format the split string.
                temp = [formatter numberFromString:[split objectAtIndex:i]];
                if (temp) {
                    //It is a number, then multiply it to total, and update number
                    total *= [temp floatValue];
                    number = [NSNumber numberWithFloat:total];
                } else {
                    //Not a number but it could still be an operation, try with '/'.
                    number = [self solveString:[split objectAtIndex:i] andOperator:GIDAOperatorFraction];
                    if (!number) {
                        //Still not a number, abort!!
                        i = [split count];
                    } else {
                        //It was a fraction so we can mutiply the value returned and update number.
                        total *= [number floatValue];
                        number = [NSNumber numberWithFloat:total];
                    }
                }
                break;
            case GIDAOperatorFraction:
                //Fraction operation.
                //Check if the split is a number.
                temp = [formatter numberFromString:[split objectAtIndex:i]];
                if (temp) {
                    //It is a number.
                    //If it is the begining of the split then use the number as total, and update number.
                    if (i == 0) {
                        total = [temp floatValue];
                        number = [NSNumber numberWithFloat:total];
                    } else {
                        //It is not the first value of the array, and the division number is different than zero.
                        //(Division by 0 are considered not valid)
                        if ([temp floatValue] != 0.0) {
                            //Divide the total, and update number.
                            total /= [temp floatValue];
                            number = [NSNumber numberWithFloat:total];
                        } else {
                            //Terminate iteration and number is nil, to represent a nonvalid result.
                            i = [split count];
                            number = nil;
                        }
                    }
                } else {
                    //Not a number so lets stop and say number is nil.
                    i = [split count];
                    number = nil;
                }
                break;
            default:
                //Anyother operator just stop.
                i = [split count];
                number = nil;
                break;
        }
    }
    
    //Return the number. It could be an NSNumber or nil.
    return number;
}


//Solve the NSString.
//With a string, solve its content if it is an operation if it is not a valid operation returns nil.
+(NSNumber *)solveString:(NSString *)string {
    NSNumber *result = nil;
    
    //Check if it is a valid expression based on parenthesis.
    //If it was the same open as close parentheses it is considered valid.
    if ([self openParenthesesFor:string toLocation:[string length]] == 0) {
        //Fix the string. String might need some help to process eg. )( should be )*(
        string = [self fixString:string];
        
        //Check if the string has parentheses 
        if ([self hasParentheses:string]) {
            //Try to obtain a special array with the middle object is the string to process
            //When done, concatenate all other objects and try to solve recursively.
            NSMutableArray *parentheses = [NSMutableArray arrayWithArray:[self splitString:string byOperator:GIDAOperatorOpenParentheses]];
            if (parentheses) {
                NSNumber *par = [self solveString:[parentheses objectAtIndex:1]];
                if (par) {
                    [parentheses setObject:[par stringValue] atIndexedSubscript:1];
                    string = [parentheses componentsJoinedByString:@""];
                    result = [self solveString:string];
                }
            }
        } else {
            //Start solving based on +, then, * then /.
            result = [self solveString:string andOperator:GIDAOperatorPlus];
        }
    }
    
    return result;
}


@end
