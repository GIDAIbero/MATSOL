//
//  conversor.m
//  convertirbase
//
//  Created by Alejandro Paredes Alva on 10/26/10.
//  Copyright 2010 aparedes.net. All rights reserved.
//

#import "Conversor.h"

@implementation Conversor
@synthesize toBase;
@synthesize fromBase;

- (void)setNumber:(NSString *)num{
    if (num != nil) {
        number=[NSString stringWithString:num];
    }
    else {
        number=num;
    }
}

- (NSString *)number{
	int i;
	NSString *regreso;
	if (fromBase == toBase) {
		regreso = number;
	}else if(fromBase == 10){
		NSMutableArray *num = [[NSMutableArray alloc] init];
		
		unsigned long long numberLong = strtoull([number UTF8String], NULL, 0);
		int max =  floor(log(numberLong)/log(toBase));
		for(i = 0; i<= max; i++){  
			[num addObject:[NSNumber numberWithInt:0]];
		}
		int where;
		while(numberLong > 0){
			where = log(numberLong)/log(toBase);
			[num replaceObjectAtIndex:where withObject:[NSNumber numberWithInt:[(NSNumber *)[num objectAtIndex:where] intValue] + 1]];
			numberLong = numberLong-pow(toBase,where);
		}
		NSMutableString *arreglo = [[NSMutableString alloc] initWithCapacity:max];
		
		NSString *x;
		for(i=max; i>=0; i--)
		{
            if ([[[num objectAtIndex:i] description] intValue] >= 10) {
                x = [NSString stringWithFormat:@"%c", 'A'+ [[[num objectAtIndex:i] description] intValue] - 10];
            } else {
                x = [[num objectAtIndex:i] description];
			}
			[arreglo appendString:x];
		}
		regreso = arreglo;
	}else {
		unsigned long long x;
		unsigned long long total=0;
		for(i=0.0; i<[number length]; i++){
			if([number characterAtIndex:i]>='A'){
				x = [number characterAtIndex:i]-'A'+10;
			}else {
				x = [number characterAtIndex:i]-'0';
			}
			if(x != 0)
				total += pow((unsigned long long)fromBase,[number length]-i-1)*x;
		}
		number = [NSString stringWithFormat:@"%.0llu",total];
		int backupBase = fromBase;
		fromBase = 10;
		
		#ifdef DEBUG
		NSLog(@"%@",number);
		#endif
		
		regreso = self.number;
		
		#ifdef DEBUG
		NSLog(@"%@",regreso);
		#endif
		
		fromBase = backupBase;
	}
	
	//Giantonormous Patch
	//Para hace que la interfaz sea coherente 
	if ([regreso isEqualToString:@""]) {
		return @"0";
	}
	
	return regreso;
}


@end
