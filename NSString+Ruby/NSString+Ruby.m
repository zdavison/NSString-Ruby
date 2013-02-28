//
//  NSString+Ruby.m
//
//  Created by Zachary Davison on 30/10/2012.
//  Copyright (c) 2012 ZD. All rights reserved.
//

/* Ruby -> Obj-C Equivalents
 
 ::try_convert
 #%               (no sensible way to implement this)
 #*             x:
 #+             :
 #<<            :
 #<=>           compare:
 #==            isEqualToString:
 #===           ==
 #=~            index:
 #[]            start:shorthand:end |> [@"string" :1:@"..":3]
                @"string"[1]
                @"string"{@"regex"}
                @"string"{@[1,3]}
 #[]=             (no mutating methods)
 #ascii_only?   isASCII:
 #bytes         bytes:
 #bytesize        
 #byteslice
 #capitalize    uppercaseString
 #casecmp       caseInsensitiveCompare:
 #center        center: 
                center:with:
 #chars         chars:
 #chomp         chomp
                chomp:
 #chop          chop
 #chr           chr
 #clear           (unnecessary in obj-c)
 #codepoints    codePoints:
 #concat        concat:
 #count         count:
 #crypt           (unsure as of yet of which method to use for this, wary of providing easily misused insecure method)
 #delete        delete:
 #downcase      lowercaseString
 #dump            (implementation very close to |inspect|, |inspect| might suffice?)
 #each_byte     bytes:
 #each_char     chars:
 #each_codepointcodepoints:
 #each_line     lines:
 #empty?        isEmpty
 #encode        
 #encoding
 #end_with?     endsWith:
 #eql?          isEqualToString:
 #force_encoding
 #getbyte
 #gsub          substituteAll:
                substituteAll:pattern
 #hash          hash
 #hex           hex
 #include?      includes:
 #index         match:
                match:offset:
 #insert        insert:string:
 #inspect       inspect
 #intern          (not viable in obj-c, Ruby specific)
 #length        length
 #lines         lines:
 #ljust         leftJustify:
                leftJustify:with:
 #lstrip        leftStrip
 #match         index:
                index:offset:
 #next
 #oct           octal
 #ord           ordinal
 #partition     partition:
 #prepend       prepend:
 #replace         (unnecessary in obj-c)
 #reverse       reverse
 #rindex        lastIndex:
                lastIndex:offset:
 #rjust         rightJustify:
                rightJustify:with:
 #rpartition    rightPartition:
 #rstrip        rightStrip
 #scan          scan:
 #setbyte
 #size          length
 #slice         start:shorthand:end |> [@"string" :1:@"..":3]
                @"string"[1]
                @"string"{@"regex"}
                @"string"{@[1,3]}
 #split         split
                split:
                split:limit:
 #squeeze       squeeze
                squeeze:
 #start_with?   startsWith:
 #strip         strip
 #sub           substituteFirst:
                substituteLast:
 #succ
 #sum           sum
                sum:
 #swapcase      swapCase
 #to_c
 #to_f          floatValue
 #to_i          intValue
 #to_r
 #to_s            (just use self)
 #to_str          (just use self)
 #to_sym          (not viable in obj-c, Ruby specific)
 #tr              (functionality is very similar to gsub for us, suggest using that instead)
 #tr_s
 #unpack
 #upcase        uppercaseString
 #upto
 #valid_encoding?
 
*/

#import "NSString+Ruby.h"

@implementation NSString (Ruby)
#pragma mark - Public Operator-likes
- (NSString*):(id)concat {
  if([concat isKindOfClass:[NSNumber class]])
    return [NSString stringWithFormat:@"%@%c",self,[concat charValue]];
  return [NSString stringWithFormat:@"%@%@",self,concat];
}

- (NSString*)x:(int)mult {
  NSString *result = @"";
  for(int i = 0; i<mult; i++) {
    result = [result:self];
  }
  return result;
}

#pragma mark - Public Shorthand Accessors
- (NSString*):(int)loc:(int)len {
  return [self substringWithRange:NSMakeRange((loc > 0) ? loc:self.length - abs(loc),
                                              len)];
}

- (NSString*):(int)start:(char*)shorthand:(int)end {
  int rstart = (start > 0) ? start : self.length - abs(start);
  int rend = (end > 0) ? end : self.length - abs(end);
  if(rstart > rend)
    return nil;
  
  NSRange range =  NSMakeRange(rstart,rend-rstart);
  if(strcmp(shorthand, "...") == 0) {
    return [self substringWithRange:range];
  } else if(strcmp(shorthand, "..") == 0) {
    range.length += 1;
    return [self substringWithRange:range];
  }
  return nil;
}

#pragma mark - Public Ruby String Methods
- (void)bytes:(void (^)(unichar))block {
  unichar *characters = calloc(self.length, sizeof(unichar));
  [self getCharacters:characters];
  for(int i = 0; i<self.length; i++) {
    block(characters[i]);
  }
  free(characters);
}

- (NSString*)center:(int)amount{
  return [self center:amount with:@" "];
}

- (NSString*)center:(int)amount with:(NSString*)padString {
  if (amount <= self.length)
    return self;
  int padamount = floor((amount - self.length)/2);
  NSString *pad = @"";
  int c = 0;
  for(int i = 0;i<padamount;i++){
    pad = [NSString stringWithFormat:@"%@%c",pad,[padString characterAtIndex:c++]];
    if(c >= padString.length)
      c = 0;
  }
  NSString *result = [NSString stringWithFormat:@"%@%@%@",pad,self,pad];
  return (result.length == amount) ? result : [NSString stringWithFormat:@"%@%c",result,[padString characterAtIndex:c]];
}

- (void)chars:(void (^)(unichar))block {
  unichar *characters = calloc(self.length, sizeof(unichar));
  [self getCharacters:characters];
  for(int i = 0; i<self.length; i++) {
    unichar character = [self characterAtIndex:i];
    block(character);
  }
  free(characters);
}

- (NSString*)chomp {
  if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:self.length-1]]) {
    return [self substringWithRange:NSMakeRange(0, self.length-1)];
  }
  return self;
}

- (NSString*)chomp:(NSString*)string {
  return [self stringByReplacingOccurrencesOfString:string
          withString:@""
          options:0
          range:NSMakeRange(self.length-string.length,
                            string.length)];
}

- (NSString*)chop {
  return [self substringWithRange:NSMakeRange(0, self.length - ((self.length >0) ? 1:0))];
}

- (NSString*)chr {
  return [self substringWithRange:NSMakeRange(0, (self.length > 0) ? 1:0)];
}

- (void)codePoints:(void (^)(int))block{
  unichar *characters = calloc(self.length, sizeof(unichar));
  [self getCharacters:characters];
  for(int i = 0; i<self.length; i++) {
    int codepoint = (int)[self characterAtIndex:i];
    block(codepoint);
  }
  free(characters);
}

- (NSString*)concat:(id)concat {
  return [self stringByAppendingString:concat];
}

- (NSInteger)count:(NSString*)first, ...{
  va_list args;
  va_start(args, first);
  NSSet *comparisonSet = [self unionOfCharactersInStrings:first remaining:args];
  va_end(args);
  int count = 0;
  for(NSString *charString in comparisonSet) {
    count += [self occurencesOf:charString];
  }
  return count;
}

- (NSString*)delete:(NSString*)first, ...{
  va_list args;
  va_start(args, first);
  NSSet *comparisonSet = [self unionOfCharactersInStrings:first remaining:args];
  va_end(args);
  NSString *finalString = self;
  for(NSString *charString in comparisonSet) {
    finalString = [finalString stringByReplacingOccurrencesOfString:charString withString:@""];
  }
  return finalString;
}

- (BOOL)endsWith:(NSString*)first,...{
  va_list args;
  va_start(args, first);
  for(NSString *arg = first; arg!=nil; arg = va_arg(args, NSString*)) {
    NSRange range = [self rangeOfString:arg];
    if(range.location + range.length == self.length)
      return true;
  }
  va_end(args);
  return false;
}

- (long)hex{
  unsigned outVal = 0;
  NSScanner* scanner = [NSScanner scannerWithString:self];
  [scanner scanHexInt:&outVal];
  return (long)outVal;
}

- (BOOL)includes:(NSString*)include{
  return [self rangeOfString:include].location != NSNotFound;
}

-(NSInteger)index:(NSString*)pattern{
  return [self index:pattern offset:0];
}

-(NSInteger)index:(NSString*)pattern offset:(int)offset{
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error){
    int loc = (offset >= 0) ? offset : self.length-abs(offset);
    int len = self.length - loc;
    NSRange range = NSMakeRange(loc,len);
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:range];
    return (result.range.length > 0) ? result.range.location : NSNotFound;
  }
  return NSNotFound;
}

- (NSString*)insert:(int)index string:(NSString*)string{
  if(index < 0)
    index = self.length - abs(index) + 1;
  else if(index >= self.length)
    index = self.length;
  return [NSString stringWithFormat:@"%@%@%@",[self substringToIndex:index],string,[self substringFromIndex:index]];
}

//TODO: performance on this is probably garbage, honestly
- (NSString*)inspect{
  NSMutableString *result = [NSMutableString stringWithString:self];
  NSRange myRange = NSMakeRange(0, [self length]);
  NSArray *toReplace = [NSArray arrayWithObjects:@"\0", @"\a", @"\b", @"\t", @"\n", @"\f", @"\r", @"\e", nil];
  NSArray *replaceWith = [NSArray arrayWithObjects:@"\\0", @"\\a", @"\\b", @"\\t", @"\\n", @"\\f", @"\\r", @"\\e", nil];
  for (int i = 0, count = [toReplace count]; i < count; ++i) {
    [result replaceOccurrencesOfString:[toReplace objectAtIndex:i] withString:[replaceWith objectAtIndex:i] options:0 range:myRange];
  }
  return [NSString stringWithFormat:@"\"%@\"",result];
}

-(BOOL)isASCII{
  unichar *characters = calloc(self.length, sizeof(unichar));
  [self getCharacters:characters];
  for(int i = 0; i<self.length; i++) {
    if(characters[i] < 32 || characters[i] > 127)
      return NO;
  }
  free(characters);
  return YES;
}

-(BOOL)isEmpty{
  return self.length == 0;
}

-(NSInteger)lastIndex:(NSString*)pattern{
  return [self lastIndex:pattern offset:0];
}

-(NSInteger)lastIndex:(NSString*)pattern offset:(int)offset{
  offset = abs(offset); //lets allow for negative and positive inputs
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error){
    NSTextCheckingResult *result = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length-offset)].lastObject;
    return (result.range.length > 0) ? result.range.location : NSNotFound;
  }
  return NSNotFound;
}

-(NSString*)leftJustify:(int)amount{
  return [self leftJustify:amount with:@" "];
}

-(NSString*)leftJustify:(int)amount with:(NSString*)padString{
  if (amount <= self.length)
    return self;
  NSString *pad = @"";
  int c = 0;
  for(int i = 0;i<amount-self.length;i++){
    pad = [NSString stringWithFormat:@"%@%c",pad,[padString characterAtIndex:c++]];
    if(c >= padString.length)
      c = 0;
  }
  NSString *result = [NSString stringWithFormat:@"%@%@",self,pad];
  return result;
}

-(NSString*)leftStrip{
  int i;
  for(i=0;i<self.length;i++){
    if(![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:i]])
      break;
  }
  return [self stringByReplacingCharactersInRange:NSMakeRange(0, i) withString:@""];
}

- (void)lines:(void (^)(NSString*))block {
  [self lines:block separator:@"\n"];
}

- (void)lines:(void (^)(NSString*))block separator:(NSString*)separator {
  NSArray *lines = [self componentsSeparatedByString:separator];
  for(NSString *line in lines) {
    block(line);
  }
}

- (NSArray*)match:(NSString*)pattern{
  return [self match:pattern offset:0];
}

- (NSArray*)match:(NSString*)pattern offset:(int)offset{
  NSMutableArray *results = [NSMutableArray array];
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(error)
    return nil;
  
  NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(offset, self.length-offset)];
  for(NSTextCheckingResult *match in matches) {
    [results addObject:[self substringWithRange:match.range]];
  }
  return results;
}

- (NSInteger)occurencesOf:(NSString*)subString {
  NSUInteger cnt = 0, length = [self length];
  NSRange range = NSMakeRange(0, length);
  while(range.location != NSNotFound)
  {
    range = [self rangeOfString:subString options:0 range:range];
    if(range.location != NSNotFound)
    {
      range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
      cnt++;
    }
  }
  return cnt;
}

- (long)octal{
  long result = strtol(self.UTF8String, NULL, 8);
  return result;
}

- (int)ordinal{
  return (int)[self characterAtIndex:0];
}

-(NSArray*)partition:(NSString*)pattern{
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(error)
    return @[];
  
  NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:self.range];
  if(!result)
    return @[self,@"",@""];
  
  NSString *first = [self substringWithRange:NSMakeRange(0, result.range.location)];
  NSString *middle = [self substringWithRange:result.range];
  NSString *last = [self substringWithRange:NSMakeRange(result.range.location+result.range.length,
                                                        self.length-(result.range.location+result.range.length))];
  return @[first,middle,last];
}

- (NSString*)prepend:(NSString*)prefix {
  return [NSString stringWithFormat:@"%@%@",prefix,self];
}

- (NSRange)range {
  return NSMakeRange(0, self.length);
}

- (NSString*)reverse{
  NSMutableString *reversedStr = [NSMutableString stringWithCapacity:self.length];
  
  for(int i=self.length-1;i>=0;i--)
    [reversedStr appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:i]]];
  
  return reversedStr;
}

-(NSInteger)rightIndex:(NSString*)pattern{
  return [self index:pattern offset:0];
}

-(NSInteger)rightIndex:(NSString*)pattern offset:(int)offset{
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error){
    int loc = (offset >= 0) ? offset : self.length-abs(offset);
    int len = self.length - loc;
    NSRange range = NSMakeRange(0,len);
    NSTextCheckingResult *result = [regex matchesInString:self options:0 range:range].lastObject;
    return (result.range.length > 0) ? result.range.location : NSNotFound;
  }
  return NSNotFound;
}

-(NSString*)rightJustify:(int)amount{
  return [self rightJustify:amount with:@" "];
}

-(NSString*)rightJustify:(int)amount with:(NSString*)padString{
  if(amount <= self.length)
    return self;
  NSString *pad = [@"" stringByPaddingToLength:amount-self.length withString:padString startingAtIndex:0];
  return [pad:self];
}

-(NSArray*)rightPartition:(NSString*)pattern{
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(error)
    return @[];
  
  NSTextCheckingResult *result = [regex matchesInString:self options:0 range:self.range].lastObject;
  if(!result)
    return @[@"",@"",self];
  
  NSString *first = [self substringWithRange:NSMakeRange(0, result.range.location)];
  NSString *middle = [self substringWithRange:result.range];
  NSString *last = [self substringWithRange:NSMakeRange(result.range.location+result.range.length,
                                                        self.length-(result.range.location+result.range.length))];
  return @[first,middle,last];
}

-(NSString*)rightStrip{
  int i;
  for(i=self.length-1;i>0;i--){
    if(![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:i]])
      break;
  }
  return [self stringByReplacingCharactersInRange:NSMakeRange(i+1, self.length-1-i) withString:@""];
}

- (NSArray*)scan:(NSString*)pattern{
  NSMutableArray *strings = [NSMutableArray array];
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(error)
    return @[];
  
  NSArray *results = [regex matchesInString:self options:0 range:self.range];
  for(NSTextCheckingResult *result in results){
    [strings addObject:[self substringWithRange:result.range]];
  }
  return [NSArray arrayWithArray:strings];
}

- (BOOL)startsWith:(NSString*)first,...{
  va_list args;
  va_start(args, first);
  for(NSString *arg = first; arg!=nil; arg = va_arg(args, NSString*)) {
    if([self rangeOfString:arg].location == 0)
      return true;
  }
  va_end(args);
  return false;
}

- (NSString*)strip{
  return [[self leftStrip] rightStrip];
}

- (NSArray*)split{
  return [self split:@" "];
}

- (NSArray*)split:(NSString*)delimiter{
  return [self split:delimiter limit:INT_MAX];
}

- (NSArray*)split:(NSString*)delimiter limit:(int)limit{
  NSString *str = self;
  
  //if limit is negative, dont suppress fields and return all fields
  if(limit < 0)
    limit = INT_MAX - 1;

  NSMutableArray *strings = [NSMutableArray array];
  //if splitting on nothing, just split every character
  if(delimiter.length == 0){
    for(int i=0;i<MIN(limit-1,str.length);i++){
      [strings addObject:[NSString stringWithFormat:@"%c",[str characterAtIndex:i]]];
    }
    if(strings.count < str.length)
      [strings addObject:[str substringWithRange:NSMakeRange(strings.count, str.length-strings.count)]];
    return strings;
  }
  
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:delimiter
                                                                    options:0
                                                                      error:&error];
  if(error)
    return @[];
  
  //remove leading/trailing/continuous whitespace if we're splitting on whitespace
  if([delimiter isEqualToString:@" "])
    str = [[self strip] squeeze];
  
  NSArray *matches = [regex matchesInString:str options:0 range:str.range];
  int loc = 0;
  for(NSTextCheckingResult *result in matches){
    NSString *s = [str substringWithRange:NSMakeRange(loc, result.range.location-loc)];
    if(result.range.length > 0 || s.length > 0)
      [strings addObject:s];
    loc = result.range.location + result.range.length;
    if(strings.count >= limit-1)
      break;
  }
  NSString *s = [str substringWithRange:NSMakeRange(loc, str.length-loc)];
  if(s.length > 0 || limit == INT_MAX - 1)
    [strings addObject:s];
  
  //if limit isn't specified, suppress trailing nulls
  if(limit == INT_MAX && [[strings lastObject] length] == 0)
    [strings removeLastObject];
  return strings;
}

- (NSString*)squeeze{
  return [self squeeze:@"."];
}

- (NSString*)squeeze:(NSString*)pattern{
  NSMutableString *s = [NSMutableString string];
  NSString *wrapped = [NSString stringWithFormat:@"(%@)\\1+",pattern];
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:wrapped
                                                                    options:0
                                                                      error:&error];
  if(error)
    return nil;
  NSArray *matches = [regex matchesInString:self options:0 range:self.range];
  int loc = 0;
  for(NSTextCheckingResult *result in matches){
    [s appendString:[self substringWithRange:NSMakeRange(loc, result.range.location-loc)]];
    loc = result.range.location + result.range.length;
    [s appendFormat:@"%c",[self characterAtIndex:result.range.location]];
  }
  [s appendString:[self substringWithRange:NSMakeRange(loc, self.length-loc)]];
  return s;
}

- (NSString*)substituteFirst:(NSString*)pattern with:(NSString*)sub {
  NSString *result = self;
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error) {
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:self.range];
    result = [result stringByReplacingCharactersInRange:match.range withString:sub];
  }
  return result;
}

- (NSString*)substituteLast:(NSString*)pattern with:(NSString*)sub {
  NSString *result = self;
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error) {
    NSTextCheckingResult *match = [regex matchesInString:self options:0 range:self.range].lastObject;
    result = [result stringByReplacingCharactersInRange:match.range withString:sub];
  }
  return result;
}

- (NSString*)substituteAll:(NSDictionary*)subDictionary {
  NSString *result = self;
  for(NSString *key in [subDictionary allKeys]) {
    NSRange range = [self rangeOfString:key];
    if(range.location != NSNotFound)
      result = [result stringByReplacingOccurrencesOfString:key withString:[subDictionary objectForKey:key]];
  }
  return result;
}

- (NSString*)substituteAll:(NSString*)pattern with:(NSString*)sub {
  NSString *result = self;
  NSError *error = nil;
  NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                    options:0
                                                                      error:&error];
  if(!error) {
    NSArray *matches = [regex matchesInString:self options:0 range:self.range];
    for(NSTextCheckingResult *match in matches) {
      result = [result stringByReplacingCharactersInRange:match.range withString:sub];
    }
  }
  return result;
}

- (int)sum{
  return [self sum:16];
}

- (int)sum:(int)bit{
  __block int total = 0;
  [self chars:^(unichar c) {
    total += (int)c;
  }];
  return (total % (int)pow(2, bit-1));
}

- (NSString*)swapCase{
  unichar *s = calloc(self.length, sizeof(unichar));
  [self getCharacters:s];
  for(int i=0;i<self.length;i++){
    if(s[i] >= 64 && s[i] <= 90)
      s[i] = s[i] + 32;
    else if(s[i] >= 97 && s[i] <= 122)
      s[i] = s[i] - 32;
  }
  return [NSString stringWithCharacters:s length:self.length];
}

#pragma mark - Subscript Protocol Methods

- (id)objectAtIndexedSubscript:(NSUInteger)index {
  if(index > self.length-1)
    return nil;
  unichar character = [self characterAtIndex:index];
  return [NSString stringWithCharacters:&character length:1];
}

- (id)objectForKeyedSubscript:(id)key {
  if([key isKindOfClass:[NSString class]]) { //if it's a string, assume a regex.
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:key
                                   options:0
                                   error:&error];
    if(error)
      return nil;
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:self.range];
    if(result)
      return [self substringWithRange:result.range];
  } else if([key isKindOfClass:[NSArray class]]) {
    int loc = [key[0] intValue];
    int len = [key[1] intValue];
    return [self substringWithRange:NSMakeRange((loc > 0) ? loc:self.length - abs(loc),
                                                len)];
  }
  return nil;
}

#pragma mark - Helper Methods
- (NSSet*)unionOfCharactersInStrings:(NSString*)first remaining:(va_list)va_list {
  NSMutableArray *sets = [NSMutableArray array];
  NSMutableSet *negateSet = [NSMutableSet set];
  for(NSString *arg = first; arg!=nil; arg = va_arg(va_list, NSString*)) {
    NSMutableSet *argSet = [NSMutableSet set];
    NSString *cleanedArg = [arg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    unichar *characters = calloc(cleanedArg.length, sizeof(unichar));
    [cleanedArg getCharacters:characters];
    if(characters[0] == '^') {
      for(int i = 1; i<cleanedArg.length; i++) {
        [negateSet addObject:[NSString stringWithCharacters:&characters[i] length:1]];
      }
    } else{
      for(int i = 0; i<cleanedArg.length; i++) {
        if(characters[i] == '-') {
          for(int j = characters[i-1]; j<characters[i+1]; j++) {
            unichar c = (unichar)j;
            [argSet addObject:[NSString stringWithCharacters:&c length:1]];
          }
        } else{
          [argSet addObject:[NSString stringWithCharacters:&characters[i] length:1]];
        }
      }
      [sets addObject:argSet];
    }
    free(characters);
  }
  va_end(va_list);
  NSMutableSet *comparisonSet = [sets objectAtIndex:0];
  for(NSMutableSet *set in sets) {
    [comparisonSet intersectSet:set];
  }
  [comparisonSet minusSet:negateSet];
  return comparisonSet;
}

@end
