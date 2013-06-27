//
//  NSMutableString+Ruby.h
//  NSString+Ruby
//
//  Created by @thingsdoer on 27/06/2013.
//  Copyright (c) 2013 ZD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Ruby.h"

@interface NSMutableString (Ruby)

//Ruby Methods
-(NSString*)chompM;
-(NSString*)deleteM:(NSString*)first, ...;
-(NSString*)lowercaseStringM;
-(NSString*)substituteAllM:(NSDictionary *)subDictionary;
-(NSString*)substituteAllM:(NSString *)pattern with:(NSString *)sub;
-(NSString*)leftStripM;
-(NSString*)reverseM;
-(NSString*)rightStripM;
-(NSString*)squeezeM;
-(NSString*)squeezeM:(NSString *)pattern;
-(NSString*)stripM;
-(NSString*)substituteFirstM:(NSString *)pattern with:(NSString *)sub;
-(NSString*)substituteLastM:(NSString *)pattern with:(NSString *)sub;
-(NSString*)swapCaseM;
-(NSString*)upperCaseStringM;

@end
