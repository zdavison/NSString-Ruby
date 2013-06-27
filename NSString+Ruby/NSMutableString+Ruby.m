//
//  NSMutableString+Ruby.m
//  NSString+Ruby
//
//  Created by @thingsdoer on 27/06/2013.
//  Copyright (c) 2013 ZD. All rights reserved.
//

/* Ruby -> Obj-C Equivalents
 
 #capitalize!   capitalizedStringM
 #chomp!        chompM
                chompM:
 #chop          chopM
 #delete        deleteM:
 #downcase      lowercaseStringM
 #gsub          substituteAllM:
                substituteAllM:pattern
 #lstrip        leftStripM
 #reverse       reverseM
 #rstrip        rightStripM
 #squeeze       squeezeM
                squeezeM:
 #strip         stripM
 #sub           substituteFirstM:
                substituteLastM:
 #swapcase      swapCaseM
 #upcase        uppercaseStringM
 
 */

#import "NSMutableString+Ruby.h"

@interface NSString(RubyPrivate)

NSString* _stringRepresentationOf(id<Concatenatable> object);
-(NSString*)_delete:(NSString*)first remaining:(va_list)args;

@end

@implementation NSMutableString (Ruby)

-(NSString*)capitalizedStringM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self capitalizedString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chompM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self chomp]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chompM:(NSString*)string{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self chomp:string]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)chopM{
  [self setString:[self chop]];
  return self;
}

-(NSString*)deleteM:(NSString*)first, ...{
  NSString *oldString = [NSString stringWithString:self];
  va_list args;
  va_start(args, first);
  [self setString:[self _delete:first remaining:args]];
  va_end(args);
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)lowercaseStringM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self lowercaseString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteAllM:(NSDictionary *)subDictionary{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteAll:subDictionary]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteAllM:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteAll:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)leftStripM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self leftStrip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)reverseM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self reverse]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)rightStripM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self rightStrip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)squeezeM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self squeeze]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)squeezeM:(NSString *)pattern{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self squeeze:pattern]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)stripM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self strip]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteFirstM:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteFirst:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)substituteLastM:(NSString *)pattern with:(NSString *)sub{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self substituteLast:pattern with:sub]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)swapCaseM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self swapCase]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

-(NSString*)upperCaseStringM{
  NSString *oldString = [NSString stringWithString:self];
  [self setString:[self uppercaseString]];
  if([oldString isEqualToString:self]){
    return nil;
  }else{
    return self;
  }
}

@end
