//
//  NSString+Ruby.h
//
//  Created by Zachary Davison on 30/10/2012.
//  Copyright (c) 2012 ZD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Ruby)

//Operator-likes
-(NSString*):(id)concat;
-(NSString*)x:(int)mult;

//Shorthand Accessors
-(NSString*):(int)loc:(int)len;
-(NSString*):(int)start:(char*)shorthand:(int)end;

//Ruby Methods
-(void)bytes:(void(^)(unichar))block;
- (NSString*)center:(int)amount;
- (NSString*)center:(int)amount with:(NSString*)padString;
-(void)chars:(void(^)(unichar))block;
-(NSString*)chomp;
-(NSString*)chomp:(NSString*)string;
-(NSString*)chop;
-(NSString*)chr;
-(void)codePoints:(void(^)(int))block;
- (NSString*)concat:(id)concat;
-(NSInteger)count:(NSString*)setString, ...;
-(NSString*)delete:(NSString*)first, ...;
-(BOOL)endsWith:(NSString*)first,...;
-(long)hex;
-(BOOL)includes:(NSString*)include;
-(NSInteger)index:(NSString*)pattern;
-(NSInteger)index:(NSString*)pattern offset:(int)offset;
-(NSString*)insert:(int)index string:(NSString*)string;
-(NSString*)inspect;
-(BOOL)isASCII;
-(BOOL)isEmpty;
-(NSInteger)lastIndex:(NSString*)pattern;
-(NSInteger)lastIndex:(NSString*)pattern offset:(int)offset;
-(NSString*)leftJustify:(int)amount;
-(NSString*)leftJustify:(int)amount with:(NSString*)padString;
-(NSString*)leftStrip;
-(void)lines:(void(^)(NSString*))block;
-(void)lines:(void(^)(NSString*))block separator:(NSString*)separator;
-(NSArray*)match:(NSString*)pattern;
-(NSArray*)match:(NSString*)pattern offset:(int)offset;
-(NSInteger)occurencesOf:(NSString*)subString;
-(long)octal;
-(int)ordinal;
-(NSArray*)partition:(NSString*)pattern;
-(NSString*)prepend:(NSString*)prefix;
-(NSRange)range;
-(NSString*)reverse;
-(NSInteger)rightIndex:(NSString*)pattern;
-(NSInteger)rightIndex:(NSString*)pattern offset:(int)offset;
-(NSString*)rightJustify:(int)amount;
-(NSString*)rightJustify:(int)amount with:(NSString*)padString;
-(NSArray*)rightPartition:(NSString*)pattern;
-(NSString*)rightStrip;
- (NSArray*)scan:(NSString*)pattern;
- (BOOL)startsWith:(NSString*)first,...;
- (NSString*)strip;
- (NSArray*)split;
- (NSArray*)split:(NSString*)delimiter;
- (NSArray*)split:(NSString*)delimiter limit:(int)limit;
- (NSString*)squeeze;
- (NSString*)squeeze:(NSString*)pattern;
- (NSString*)substituteFirst:(NSString*)pattern with:(NSString*)sub;
- (NSString*)substituteLast:(NSString*)pattern with:(NSString*)sub;
-(NSString*)substituteAll:(NSDictionary*)subDictionary;
-(NSString*)substituteAll:(NSString*)pattern with:(NSString*)sub;
-(int)sum;
-(int)sum:(int)bit;
-(NSString*)swapCase;

//Subscript Protocol
-(id)objectAtIndexedSubscript:(NSUInteger)index;
-(id)objectForKeyedSubscript:(id)key;

@end
