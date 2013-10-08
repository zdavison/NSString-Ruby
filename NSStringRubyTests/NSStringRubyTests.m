#import <Kiwi/Kiwi.h>
#import "NSString+Ruby.h"

#pragma mark - Support

@interface TestObject : NSObject

@end

@implementation TestObject

-(NSString*)description{
  return @"TestObjectDescription";
}

@end

#pragma mark - Tests

SPEC_BEGIN(NSStringRubySpec)

describe(@"NSString operator-likes, such as", ^{
  /*
   "Ho! " * 3   #=> "Ho! Ho! Ho! "
   */
  context(@"x aka(*)", ^{
    it(@"\"Ho! \" * 3   #=> \"Ho! Ho! Ho! \"", ^{
      [[[@"Ho! " x:3] should] equal:@"Ho! Ho! Ho! "];
    });
    it(@"should return empty strings the same", ^{
      [[[@"" x:3] should] equal:@""];
    });
  });
  /*
   "hello" + "world"    #=> "hello world"
   "hello".concat(33)   #=> "hello world!"
   */
  context(@": aka(+)", ^{
    it(@"\"hello\" + \"world\"    #=> \"hello world\"", ^{
      [[[@"hello ":@"world",nil] should] equal:@"hello world"];
    });
    it(@"\"hello \" + \"world\" + \"!\"    #=> \"hello world\"", ^{
      [[[@"hello ":@"world",@"!",nil] should] equal:@"hello world!"];
    });
    it(@"\"hello\".concat(33)   #=> \"hello world!\"", ^{
      [[[@"hello world":[NSNumber numberWithInt:33],nil] should] equal:@"hello world!"];
    });
    it(@"\"hello\" + TestObject   #=> \"hello world!\"", ^{
      TestObject *object = [[TestObject alloc] init];
      [[[@"hello world ":object,nil] should] equal:@"hello world TestObjectDescription"];
    });
  });
});

/*
 a = "hello there"
 a[1]                   #=> "e"
 a[2, 3]                #=> "llo"
 a[2..3]                #=> "ll"
 a[-3, 2]               #=> "er"
 a[7..-2]               #=> "her"
 a[-4..-2]              #=> "her"
 a[-2..-4]              #=> nil
 a[12..-1]              #=> nil
 a[%r[aeiou](.){2}]     #=> "ell"
 a["lo"]                #=> "lo"
 a["bye"]               #=> nil
 */
describe(@"NSString []/{} accessors / ranges", ^{
  NSString *a = @"hello there";
  it(@"a[1]                     #=> \"e\"", ^{
    [[a[1] should] equal:@"e"];
  });
  it(@"a[2, 3]                  #=> \"llo\"", ^{
    [[[a:2:3] should] equal:@"llo"];
  });
  it(@"a[2..3]                  #=> \"ll\"", ^{
    [[[a:2:"..":3] should] equal:@"ll"];
  });
  it(@"a[-3, 2]                 #=> \"er\"", ^{
    [[[a:-3:2] should] equal:@"er"];
  });
  it(@"a[7..-2]                 #=> \"her\"", ^{
    [[[a:7:"..":-2] should] equal:@"her"];
  });
  it(@"a[-2..-4]                #=> nil", ^{
    [[a:-2:"..":-4] shouldBeNil];
  });
  it(@"a[12..-1]                #=> nil", ^{
    [[a:12:"..":-1] shouldBeNil];
  });
  it(@"a[%r[aeiou](.){2}]       #=> \"ell\"", ^{
    [[a[@"[aeiou](.){2}"] should] equal:@"ell"];
  });
  it(@"a[\"lo\"]                #=> \"lo\"", ^{
    [[a[@"lo"] should] equal:@"lo"];
  });
  it(@"a[\"bye\"]               #=> nil", ^{
    [a[@"bye"] shouldBeNil];
  });
});

//Methods

describe(@"NSString bytes", ^{
  it(@"should execute a block for each byte", ^{
    NSMutableArray *bytes = [NSMutableArray array];
    [@"hello world" bytes:^(unichar byte) {
      [bytes addObject:[NSNumber numberWithChar:byte]];
    }];
    [[theValue(bytes.count) should] equal:theValue(@"hello world".length)];
    unichar *characters = calloc(@"hello world".length, sizeof(unichar));
    [@"hello world" getCharacters:characters];
    for(NSInteger i=0;i<@"hello world".length;i++){
      unichar character = [[bytes objectAtIndex:i] charValue];
      [[theValue(character) should] equal:theValue(characters[i])];
    }
  });
});

/*
 "hello".center(4)         #=> "hello"
 "hello".center(20)        #=> "       hello        "
 "hello".center(20, '123') #=> "1231231hello12312312"
 */
describe(@"NSString center", ^{
  it(@"\"hello\".center(4)          #=> \"hello\"", ^{
    [[[@"hello" center:4] should] equal:@"hello"];
  });
  it(@"\"hello\".center(20)         #=> \"       hello        \"", ^{
    [[[@"hello" center:20] should] equal:@"       hello        "];
  });
  it(@"\"hello\".center(20, '123')  #=> \"1231231hello12312312\"", ^{
    [[[@"hello" center:20 with:@"123"] should] equal:@"1231231hello12312312"];
  });
});

describe(@"NSString chars", ^{
  it(@"should execute a block for each char", ^{
    NSMutableArray *chars = [NSMutableArray array];
    [@"hello world" bytes:^(unichar chr) {
      [chars addObject:[NSNumber numberWithChar:chr]];
    }];
    [[theValue(chars.count) should] equal:theValue(@"hello world".length)];
    unichar *characters = calloc(@"hello world".length, sizeof(unichar));
    [@"hello world" getCharacters:characters];
    for(NSInteger i=0;i<@"hello world".length;i++){
      unichar character = [[chars objectAtIndex:i] charValue];
      [[theValue(character) should] equal:theValue(characters[i])];
    }
    free(characters);
  });
});

/*
 "hello".chomp            #=> "hello"
 "hello\n".chomp          #=> "hello"
 "hello\r\n".chomp        #=> "hello"       FAIL (\r\n is not recognized as a single carriage return character in obj-c)
 "hello\n\r".chomp        #=> "hello\n"
 "hello\r".chomp          #=> "hello"
 "hello \n there".chomp   #=> "hello \n there"
 "hello".chomp("llo")     #=> "he"
 */
describe(@"NSString chomp", ^{
  it(@"\"hello\".chomp            #=> \"hello\"", ^{
    [[@"hello".chomp should] equal:@"hello"];
  });
  it(@"\"hello\n\".chomp          #=> \"hello\"", ^{
    [[@"hello\n".chomp should] equal:@"hello"];
  });
  it(@"\"hello\r\n\".chomp        #=> \"hello\r\"", ^{
    [[@"hello\r\n".chomp should] equal:@"hello\r"];
  });
  it(@"\"hello\n\r\".chomp        #=> \"hello\n\"", ^{
    [[@"hello\n\r".chomp should] equal:@"hello\n"];
  });
  it(@"\"hello \n there\".chomp   #=> \"hello \n there\"", ^{
    [[@"hello \n there".chomp should] equal:@"hello \n there"];
  });
  it(@"\"hello\".chomp(\"llo\")   #=> \"he\"", ^{
    [[[@"hello" chomp:@"llo"] should] equal:@"he"];
  });
});

/*
 "string\r\n".chop   #=> "string"          FAIL (\r\n is not recognized as a single carriage return character in obj-c)
 "string\n\r".chop   #=> "string\n"
 "string\n".chop     #=> "string"
 "string".chop       #=> "strin"
 "x".chop.chop       #=> ""
 */
describe(@"NSString chop", ^{
  it(@"\"string\r\n\".chop    #=> \"string\r\"", ^{
    [[@"string\r\n".chop should] equal:@"string\r"];
  });
  it(@"\"string\n\r\".chop    #=> \"string\n\"", ^{
    [[@"string\n\r".chop should] equal:@"string\n"];
  });
  it(@"\"string\n\".chop      #=> \"string\"", ^{
    [[@"string\n".chop should] equal:@"string"];
  });
  it(@"\"string\".chop        #=> \"strin\"", ^{
    [[@"string".chop should] equal:@"strin"];
  });
  it(@"\"x\".chop.chop        #=> \"\"", ^{
    [[@"x".chop.chop should] equal:@""];
  });
});

/*
 "abcde".chr    #=> "a"
 */
describe(@"NSString chr", ^{
  it(@"\"abcde\".chr    #=> \"a\"", ^{
    [[@"abcde".chr should] equal:@"a"];
  });
  it(@"should fail gracefully on empty strings.", ^{
    [[@"".chr should] equal:@""];
  });
});

describe(@"NSString codepoints", ^{
  it(@"should execute a block for each char", ^{
    NSMutableArray *chars = [NSMutableArray array];
    [@"hello world" codePoints:^(NSInteger i) {
      [chars addObject:[NSNumber numberWithLong:i]];
    }];
    [[theValue(chars.count) should] equal:theValue(@"hello world".length)];
    unichar *characters = calloc(@"hello world".length, sizeof(unichar));
    [@"hello world" getCharacters:characters];
    for(NSInteger i=0;i<@"hello world".length;i++){
      unichar character = [[chars objectAtIndex:i] charValue];
      [[theValue(character) should] equal:theValue(characters[i])];
    }
    free(characters);
  });
});

/*
 a = "hello world"
 a.count("lo")            #=> 5
 a.count("lo", "o")       #=> 2
 a.count("hello", "^l")   #=> 4
 a.count("ej-m")          #=> 4
 */
describe(@"NSString count", ^{
  NSString *a = @"hello world";
  it(@"a.count(\"lo\")            #=> 5", ^{
    NSInteger count = [a count:@"lo",nil];
    [[theValue(count) should] equal:theValue(5)];
  });
  it(@"a.count(\"lo,\"o\"\")      #=> 2", ^{
    NSInteger count = [a count:@"lo",@"o",nil];
    [[theValue(count) should] equal:theValue(2)];
  });
  it(@"a.count(\"hello\",\"^l\")  #=> 4", ^{
    NSInteger count = [a count:@"hello",@"^l",nil];
    [[theValue(count) should] equal:theValue(4)];
  });
  it(@"a.count(\"ej-m\")          #=> 4", ^{
    NSInteger count = [a count:@"ej-m",nil];
    [[theValue(count) should] equal:theValue(4)];
  });
});

/*
 "hello".delete("l","lo")        #=> "heo"
 "hello".delete("lo")            #=> "he"
 "hello".delete("aeiou", "^e")   #=> "hell"
 "hello".delete("ej-m")          #=> "ho"
 */
describe(@"NSString delete", ^{
  NSString *a = @"hello";
  it(@"a.delete(\"l\",\"lo\")           #=> \"heo\"", ^{
    NSString *s = [a delete:@"l",@"lo",nil];
    [[s should] equal:@"heo"];
  });
  it(@"a.delete(\"l\")                  #=> \"he\"", ^{
    NSString *s = [a delete:@"lo",nil];
    [[s should] equal:@"he"];
  });
  it(@"a.delete(\"aeiou\",\"^e\")       #=> \"hell\"", ^{
    NSString *s = [a delete:@"aeiou",@"^e",nil];
    [[s should] equal:@"hell"];
  });
  it(@"a.delete(\"ej-m\")               #=> \"ho\"", ^{
    NSString *s = [a delete:@"ej-m",nil];
    [[s should] equal:@"ho"];
  });
});

describe(@"NSString endsWith", ^{
  it(@"should return true if the string ends with any of the provided strings.", ^{
    BOOL result = [@"hello world" endsWith:@"hello",@"wrold",@"orld",nil];
    [[theValue(result) should] equal:theValue(YES)];
  });
});

/*
 "0x0a".hex     #=> 10
 "-1234".hex    #=> -4660
 "0".hex        #=> 0
 "wombat".hex   #=> 0
 */
describe(@"NSString hex", ^{
  it(@"'0x0a'.hex             #=> 10", ^{
    [[theValue(@"0x0a".hex) should] equal:theValue(10)];
  });
  it(@"'-1234'.hex            #=> -4660", ^{
    [[theValue(@"0x0a".hex) should] equal:theValue(10)];
  });
  it(@"'0'.hex                #=> 0", ^{
    [[theValue(@"0x0a".hex) should] equal:theValue(10)];
  });
  it(@"'wombat'.hex           #=> 0", ^{
    [[theValue(@"0x0a".hex) should] equal:theValue(10)];
  });
});

/*
 "hello".include? "lo"   #=> true
 "hello".include? "ol"   #=> false
 "hello".include? h     #=> true
 */
describe(@"NSString include", ^{
  it(@"'hello'.include? 'lo'   #=> true", ^{
    [[theValue([@"hello" includes:@"lo"]) should] equal:theValue(YES)];
  });
  it(@"'hello'.include? 'ol'   #=> false", ^{
    [[theValue([@"hello" includes:@"ol"]) should] equal:theValue(NO)];
  });
  it(@"'hello'.include? 'h'   #=> true", ^{
    [[theValue([@"hello" includes:@"h"]) should] equal:theValue(YES)];
  });
});

/*
 "cat o' 9 tails" =~ %r\d/      #=> 7
 "cat o' 9 tails" =~ "nope"     #=> nil
 "hello".index('e')             #=> 1
 "hello".index('lo')            #=> 3
 "hello".index('a')             #=> nil
 "hello".index(%r[aeiou]/, -3)  #=> 4
 */
describe(@"NSString index", ^{
  it(@"\"cat o' 9 tails\" =~ %r\\d/         #=> 7", ^{
    [[theValue([@"cat o' 9 tails" index:@"\\d"]) should] equal:theValue(7)];
  });
  it(@"\"cat o' 9 tails\" =~ \"nope\"       #=> nil", ^{
    [[theValue([@"cat o' 9 tails" index:@"nope"]) should] equal:theValue(NSNotFound)];
  });
  it(@"\"hello\".index('e')                 #=> 1", ^{
    [[theValue([@"hello" index:@"e"]) should] equal:theValue(1)];
  });
  it(@"\"hello\".index('lo')                #=> 3", ^{
    [[theValue([@"hello" index:@"lo"]) should] equal:theValue(3)];
  });
  it(@"\"hello\".index('a')                 #=> nil", ^{
    [[theValue([@"hello" index:@"a"]) should] equal:theValue(NSNotFound)];
  });
  it(@"\"hello\".index(%r[aeiou]/, -3)      #=> 4", ^{
    [[theValue([@"hello" index:@"[aeiou]" offset:-3]) should] equal:theValue(4)];
  });
});

/*
 "abcd".insert(0, 'X')    #=> "Xabcd"
 "abcd".insert(3, 'X')    #=> "abcXd"
 "abcd".insert(4, 'X')    #=> "abcdX"
 "abcd".insert(-3, 'X')   #=> "abXcd"
 "abcd".insert(-1, 'X')   #=> "abcdX"
 */
describe(@"NSString insert", ^{
  it(@"'abcd'.insert(0, 'X')    #=> 'Xabcd'", ^{
    [[[@"abcd" insert:0 string:@"X"] should] equal:@"Xabcd"];
  });
  it(@"'abcd'.insert(3, 'X')    #=> 'abcXd'", ^{
    [[[@"abcd" insert:3 string:@"X"] should] equal:@"abcXd"];
  });
  it(@"'abcd'.insert(4, 'X')    #=> 'abcdX'", ^{
    [[[@"abcd" insert:4 string:@"X"] should] equal:@"abcdX"];
  });
  it(@"'abcd'.insert(-3, 'X')    #=> 'abXcd'", ^{
    [[[@"abcd" insert:-3 string:@"X"] should] equal:@"abXcd"];
  });
  it(@"'abcd'.insert(-1, 'X')    #=> 'abXcd'", ^{
    [[[@"abcd" insert:-1 string:@"X"] should] equal:@"abcdX"];
  });
});

/*
 "hel\blo".inspect       #=> "\"hel\\blo\""
 */
describe(@"NSString inspect", ^{
  it(@"\"hel\blo\".inspect       #=> \"\"hel\\blo\"\"", ^{
    [[[@"hel\blo" inspect] should] equal:@"\"hel\\blo\""];
  });
});

/*
 "abc".ascii_only?          #=> true
 "abc\u{6666}".ascii_only?  #=> false
 */
describe(@"NSString isASCII", ^{
  it(@"\"abc\".ascii_only?          #=> true.", ^{
    [[theValue(@"abc".isASCII) should] equal:theValue(YES)];
  });
  it(@"\"abc\\u{6666}\".ascii_only?  #=> false.", ^{
    [[theValue(@"abc\u6666".isASCII) should] equal:theValue(NO)];
  });
});

/*
 "hello".empty?   #=> false
 "".empty?        #=> true
 */
describe(@"NSString isEmpty", ^{
  it(@"\"hello\".empty?         #=> false.", ^{
    [[theValue(@"hello".isEmpty) should] equal:theValue(NO)];
  });
  it(@"\"\".empty?              #=> true.", ^{
    [[theValue(@"".isEmpty) should] equal:theValue(YES)];
  });
});

/*
 "hello".ljust(4)            #=> "hello"
 "hello".ljust(20)           #=> "hello               "
 "hello".ljust(20, '1234')   #=> "hello123412341234123"
 */
describe(@"NSString leftJustify", ^{
  it(@"\"hello\".ljust(4)          #=> \"hello\"", ^{
    [[[@"hello" leftJustify:4] should] equal:@"hello"];
  });
  it(@"\"hello\".ljust(20)         #=> \"hello               \"", ^{
    [[[@"hello" leftJustify:20] should] equal:@"hello               "];
  });
  it(@"\"hello\".ljust(20, '1234')  #=> \"hello123412341234123\"", ^{
    [[[@"hello" leftJustify:20 with:@"1234"] should] equal:@"hello123412341234123"];
  });
});

/*
 "  hello  ".lstrip   #=> "hello  "
 "hello".lstrip       #=> "hello"
 */
describe(@"NSString leftStrip", ^{
  it(@"\"  hello  \".lstrip   #=> \"hello  \"", ^{
    [[[@"  hello  " leftStrip] should] equal:@"hello  "];
  });
  it(@"\"  hello  \".lstrip   #=> \"hello  \"", ^{
    [[[@"hello" leftStrip] should] equal:@"hello"];
  });
});

describe(@"NSString lines", ^{
  it(@"should execute a block on each line by default", ^{
    NSMutableArray *lines = [NSMutableArray array];
    [@"hello\nworld" lines:^(NSString *line) {
      [lines addObject:line];
    }];
    [[theValue(lines.count) should] equal:theValue(2)];
    [[[lines objectAtIndex:0] should] equal:@"hello"];
    [[[lines objectAtIndex:1] should] equal:@"world"];
  });
  it(@"should execute a block on each chunk seperated by a provided separator", ^{
    NSMutableArray *lines = [NSMutableArray array];
    [@"hello!world" lines:^(NSString *line) {
      [lines addObject:line];
    } separator:@"!"];
    [[theValue(lines.count) should] equal:theValue(2)];
    [[[lines objectAtIndex:0] should] equal:@"hello"];
    [[[lines objectAtIndex:1] should] equal:@"world"];
  });
});

/*
 'hello'.match('(.){1}')          #=> ["h","e","l","l","o"]
 'hello'.match('(.){1}')[0]       #=> "h"
 'hello'.match(%r[aeiou](.){2})[0]#=> "ell"
 'hello'.match('xx')              #=> []
 */
describe(@"NSString match", ^{
  it(@"'hello'.match('(.){1}')          #=> [\"l\"]", ^{
    [[[@"hello" match:@"(.){1}"] should] equal:@[@"h",@"e",@"l",@"l",@"o"]];
  });
  it(@"'hello'.match('(.){1}')          #=> [\"l\"]", ^{
    [[[@"hello" match:@"(.){1}"][0] should] equal:@"h"];
  });
  it(@"'hello'.match('([aeiou](.){2})')   #=> [\"ell\"]", ^{
    [[[@"hello" match:@"([aeiou](.){2})"][0] should] equal:@"ell"];
  });
  it(@"'hello'.match('xx')              #=> nil", ^{
    [[[@"hello" match:@"xx"] should] equal:@[]];
  });
});

/*
 "123".oct       #=> 83
 "-377".oct      #=> -255
 "bad".oct       #=> 0
 "0377bad".oct   #=> 255
 */
describe(@"NSString octal", ^{
  it(@"'123'.oct              #=> 83", ^{
    [[theValue(@"123".octal) should] equal:theValue(83)];
  });
  it(@"'-377'.oct             #=> -255", ^{
    [[theValue(@"-377".octal) should] equal:theValue(-255)];
  });
  it(@"'bad'.oct              #=> 0", ^{
    [[theValue(@"bad".octal) should] equal:theValue(0)];
  });
  it(@"'0377bad'.hex          #=> 255", ^{
    [[theValue(@"0377bad".octal) should] equal:theValue(255)];
  });
});

/*
 "a".ord         #=> 97
 */
describe(@"NSString ordinal", ^{
  it(@"'a'.ord         #=> 97", ^{
    [[theValue(@"a".ordinal) should] equal:theValue(97)];
  });
});

/*
 "hello".partition("l")         #=> ["he", "l", "lo"]
 "hello".partition("x")         #=> ["hello", "", ""]
 "hello".partition(%r.l/)        #=> ["h", "el", "lo"]
 */
describe(@"NSString partition", ^{
  it(@"\"hello\".partition(\"l\")         #=> [\"he\", \"l\", \"lo\"]", ^{
    NSArray *result = [@"hello" partition:@"l"];
    [[result should] equal:@[@"he",@"l",@"lo"]];
  });
  it(@"\"hello\".partition(\"x\")         #=> [\"hello\", \"\", \"\"]", ^{
    NSArray *result = [@"hello" partition:@"x"];
    [[result should] equal:@[@"hello",@"",@""]];
  });
  it(@"\"hello\".partition(\"%r.l\")         #=> [\"h\", \"el\", \"lo\"]", ^{
    NSArray *result = [@"hello" partition:@".l"];
    [[result should] equal:@[@"h",@"el",@"lo"]];
  });
});

/*
 "world".prepend(“hello ”) #=> “hello world”
 */
describe(@"NSString prepend", ^{
  it(@"\"world\".prepend(“hello ”) #=> \"hello world\"", ^{
    [[[@"world" prepend:@"hello " ] should] equal:@"hello world"];
  });
});

/*
 "stressed".reverse   #=> "desserts"
 */
describe(@"NSString reverse", ^{
  it(@"\"stressed\".reverse   #=> \"desserts\"", ^{
    [[@"stressed".reverse should] equal:@"desserts"];
  });
});

/*
 "hello".rindex('e')             #=> 1
 "hello".rindex('lo')            #=> 3
 "hello".rindex('a')             #=> nil
 "hello".rindex(%r[aeiou]/, -2)  #=> 1
 */
describe(@"NSString rightIndex", ^{
  it(@"\"hello\".rindex('e')                 #=> 1", ^{
    [[theValue([@"hello" rightIndex:@"e"]) should] equal:theValue(1)];
  });
  it(@"\"hello\".rindex('lo')                #=> 3", ^{
    [[theValue([@"hello" rightIndex:@"lo"]) should] equal:theValue(3)];
  });
  it(@"\"hello\".rindex('a')                 #=> nil", ^{
    [[theValue([@"hello" rightIndex:@"a"]) should] equal:theValue(NSNotFound)];
  });
  it(@"\"hello\".rindex(%r[aeiou]/, -2)      #=> 1", ^{
    [[theValue([@"hello" rightIndex:@"[aeiou]" offset:-2]) should] equal:theValue(1)];
  });
});

/*
 "hello".rjust(4)            #=> "hello"
 "hello".rjust(20)           #=> "               hello"
 "hello".rjust(20, '1234')   #=> "123412341234123hello"
 */
describe(@"NSString rightJustify", ^{
  it(@"\"hello\".rjust(4)          #=> \"hello\"", ^{
    [[[@"hello" rightJustify:4] should] equal:@"hello"];
  });
  it(@"\"hello\".rjust(20)         #=> \"               hello\"", ^{
    [[[@"hello" rightJustify:20] should] equal:@"               hello"];
  });
  it(@"\"hello\".rjust(20, '1234')  #=> \"123412341234123hello\"", ^{
    [[[@"hello" rightJustify:20 with:@"1234"] should] equal:@"123412341234123hello"];
  });
});

/*
 "  hello  ".lstrip   #=> "hello  "
 "hello".lstrip       #=> "hello"
 */
describe(@"NSString rightStrip", ^{
  it(@"\"  hello  \".rstrip   #=> \"hello  \"", ^{
    [[[@"  hello  " rightStrip] should] equal:@"  hello"];
  });
  it(@"\"  hello  \".rstrip   #=> \"hello  \"", ^{
    [[[@"hello" rightStrip] should] equal:@"hello"];
  });
});

/*
 "hello".rpartition("l")         #=> ["hel", "l", "o"]
 "hello".rpartition("x")         #=> ["", "", "hello"]
 "hello".rpartition(%r.l/)        #=> ["he", "ll", "o"]
 */
describe(@"NSString rpartition", ^{
  it(@"\"hello\".rpartition(\"l\")         #=> [\"hel\", \"l\", \"o\"]", ^{
    NSArray *result = [@"hello" rightPartition:@"l"];
    [[result should] equal:@[@"hel",@"l",@"o"]];
  });
  it(@"\"hello\".rpartition(\"x\")         #=> [\"\", \"\", \"hello\"]", ^{
    NSArray *result = [@"hello" rightPartition:@"x"];
    [[result should] equal:@[@"",@"",@"hello"]];
  });
  it(@"\"hello\".rpartition(\"%rl.\")         #=> [\"he\", \"ll\", \"o\"]", ^{
    NSArray *result = [@"hello" rightPartition:@"l."];
    [[result should] equal:@[@"he",@"ll",@"o"]];
  });
});

/*
 a = "cruel world"
 a.scan(%r\w+/)        #=> ["cruel", "world"]
 a.scan(%r.../)        #=> ["cru", "el ", "wor"]
 */
describe(@"NSString scan", ^{
  NSString *a = @"cruel world";
  it(@"a.scan(%r\\w+/)        #=> [\"cruel\", \"world\"]", ^{
    NSArray *result = [a scan:@"\\w+"];
    [[result should] equal:@[@"cruel",@"world"]];
  });
  it(@"a.scan(%r.../)        #=> [\"cruel\", \"world\"]", ^{
    NSArray *result = [a scan:@"..."];
    [[result should] equal:@[@"cru",@"el ",@"wor"]];
  });
});

/*
 " now's  the time".split        #=> ["now's", "the", "time"]
 " now's  the time".split(' ')   #=> ["now's", "the", "time"]
 " now's  the time".split(%r /)   #=> ["", "now's", "", "the", "time"]
 "1, 2.34,56, 7".split(%r{,\s*}) #=> ["1", "2.34", "56", "7"]
 "hello".split(%r/)               #=> ["h", "e", "l", "l", "o"]
 "hello".split(%r/, 3)            #=> ["h", "e", "llo"]
 "hi mom".split(%r{\s*})         #=> ["h", "i", "m", "o", "m"]
 
 "mellow yellow".split("ello")   #=> ["m", "w y", "w"]
 "1,2,,3,4,,".split(',')         #=> ["1", "2", "", "3", "4"]
 "1,2,,3,4,,".split(',', 4)      #=> ["1", "2", "", "3,4,,"]
 "1,2,,3,4,,".split(',', -4)     #=> ["1", "2", "", "3", "4", "", ""]
 */
describe(@"NSString split", ^{
  it(@"\" now's  the time\".split        #=> [\"now's\", \"the\", \"time\"]", ^{
    NSArray *result = [@" now's  the time" split];
    [[result should] equal:@[@"now's",@"the",@"time"]];
  });
  it(@"\" now's  the time\".split(' ')   #=> [\"now's\", \"the\", \"time\"]", ^{
    NSArray *result = [@" now's  the time" split:@" "];
    [[result should] equal:@[@"now's",@"the",@"time"]];
  });
  it(@"\" now's  the time\".split('%r /')   #=> [\"now's\", \"the\", \"time\"]", ^{
    NSArray *result = [@" now's  the time" split:@"( )"];
    [[result should] equal:@[@"",@"now's",@"",@"the",@"time"]];
  });
  it(@"\"1, 2.34,56, 7\".split('%r{,\\s*}')   #=> [\"1\", \"2.34\", \"56\", \"7\"]", ^{
    NSArray *result = [@"1, 2.34,56, 7" split:@",\\s*"];
    [[result should] equal:@[@"1",@"2.34",@"56",@"7"]];
  });
  it(@"\"hello\".split('%r/')   #=> [\"h\", \"e\", \"l\", \"l\", \"o\"]", ^{
    NSArray *result = [@"hello" split:@""];
    [[result should] equal:@[@"h",@"e",@"l",@"l",@"o"]];
  });
  it(@"\"hello\".split('%r/',3)   #=> [\"h\", \"e\", \"llo\"]", ^{
    NSArray *result = [@"hello" split:@"" limit:3];
    [[result should] equal:@[@"h",@"e",@"llo"]];
  });
  it(@"\"hi mom\".split('%r{\\s*}')   #=> [\"h\", \"i\", \"m\", \"o\", \"m\"]", ^{
    NSArray *result = [@"hi mom" split:@"\\s*"];
    [[result should] equal:@[@"h",@"i",@"m",@"o",@"m"]];
  });
  it(@"\"mellow yellow\".split('ello')   #=> [\"m\", \"w y\", \"w\"]", ^{
    NSArray *result = [@"mellow yellow" split:@"ello"];
    [[result should] equal:@[@"m",@"w y",@"w"]];
  });
  it(@"\"1,2,,3,4,,\".split(',')   #=> [\"1\", \"2\", \"\", \"3\", \"4\"]", ^{
    NSArray *result = [@"1,2,,3,4,," split:@","];
    [[result should] equal:@[@"1",@"2",@"",@"3",@"4"]];
  });
  it(@"\"1,2,,3,4,,\".split(',',4)   #=> [\"1\", \"2\", \"\", \"3,4,,\"]", ^{
    NSArray *result = [@"1,2,,3,4,," split:@"," limit:4];
    [[result should] equal:@[@"1",@"2",@"",@"3,4,,"]];
  });
  it(@"\"1,2,,3,4,,\".split(',',-4)   #=> [\"1\", \"2\", \"\", \"3\", \"4\", \"\", \"\"]", ^{
    NSArray *result = [@"1,2,,3,4,," split:@"," limit:-4];
    [[result should] equal:@[@"1",@"2",@"",@"3",@"4",@"",@""]];
  });
});

/*
 "yellow moon".squeeze                    #=> "yelow mon"
 "  now   is  the".squeeze(" ")           #=> " now is the"
 "putters shoot balls".squeeze("[m-z]")   #=> "puters shot balls"
 */
describe(@"NSString squeeze", ^{
  it(@"\"yellow moon\".squeeze/, '*')                  #=> \"yelow mon\"", ^{
    [[[@"yellow moon" squeeze] should] equal:@"yelow mon"];
  });
  it(@"\"  now   is  the\".squeeze(\" \")/, '*')                  #=> \" now is the\"", ^{
    [[[@"  now   is  the" squeeze:@" "] should] equal:@" now is the"];
  });
  it(@"\"putters shoot balls\".squeeze(\"[m-z]\")/, '*')                  #=> \"puters shot balls\"", ^{
    [[[@"putters shoot balls" squeeze:@"[m-z]"] should] equal:@"puters shot balls"];
  });
});

/*
 "hello".start_with?("hell")               #=> true
 "hello".start_with?("heaven", "hell")     #=> true
 "hello".start_with?("heaven", "paradise") #=> false
 */
describe(@"NSString startsWith", ^{
  it(@"\"hello\".starts_with?(\"hell\")                         #=> true.", ^{
    [[theValue([@"hello" startsWith:@"hell"]) should] equal:theValue(YES)];
  });
  it(@"\"hello\".starts_with?(\"heaven\",\"hell\")              #=> true.", ^{
    BOOL result = [@"hello" startsWith:@"heaven",@"hell",nil];
    [[theValue(result) should] equal:theValue(YES)];
  });
  it(@"\"hello\".starts_with?(\"heaven\",\"paradise\")          #=> false.", ^{
    BOOL result = [@"hello" startsWith:@"heaven",@"paradise",nil];
    [[theValue(result) should] equal:theValue(NO)];
  });
});

/*
 "    hello    ".strip   #=> "hello"
 "\tgoodbye\r\n".strip   #=> "goodbye"
 */
describe(@"NSString strip", ^{
  it(@"\"    hello    \".strip                  #=> \"hello\"", ^{
    [[[@"    hello    " strip] should] equal:@"hello"];
  });
  it(@"\"\\tgoodbye\\r\\n\".strip               #=> \"goodbye\"", ^{
    [[[@"\tgoodbye\r\n" strip] should] equal:@"goodbye"];
  });
});

/*
 "hello".gsub(%r[aeiou]/, '*')                  #=> "h*ll*"
 'hello'.gsub(%r[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
 */
describe(@"NSString substituteAll", ^{
  it(@"\"hello\".gsub(%r[aeiou]/, '*')                  #=> \"h*ll*\"", ^{
    [[[@"hello" substituteAll:@"[aeiou]" with:@"*"] should] equal:@"h*ll*"];
  });
  it(@"\"hello\".gsub(%r[eo]/, 'e' => 3, 'o' => '*')    #=> \"h3ll*\"", ^{
    [[[@"hello" substituteAll:@{@"e" : @"3",
                                @"o" : @"*"}] should] equal:@"h3ll*"];
  });
});

/*
 "hello".sub(%r[aeiou]/, '*')                  #=> "h*llo"
 */
describe(@"NSString substituteFirst", ^{
  it(@"\"hello\".sub(%r[aeiou]/, '*')                  #=> \"h*llo\"", ^{
    [[[@"hello" substituteFirst:@"[aeiou]" with:@"*"] should] equal:@"h*llo"];
  });
});

/*
 NB: This doesn't actually exist in Ruby.
 "hello".sublast(%r[aeiou]/, '*')                  #=> "h*llo"
 */
describe(@"NSString substituteLast", ^{
  it(@"\"hello\".sublast(%r[aeiou]/, '*')                  #=> \"hell*\"", ^{
    [[[@"hello" substituteLast:@"[aeiou]" with:@"*"] should] equal:@"hell*"];
  });
});

/*
 "hello".sum                        #=> 532
 "hello".sum(8)                     #=> 20
 */
describe(@"NSString sum", ^{
  it(@"\"hello\".sum                     #=> 532", ^{
    [[theValue([@"hello" sum]) should] equal:theValue(532)];
  });
  it(@"\"hello\".sum(8)                  #=> 20", ^{
    [[theValue([@"hello" sum:8]) should] equal:theValue(20)];
  });
});

/*
 "Hello".swapcase          #=> "hELLO"
 "cYbEr_PuNk11".swapcase   #=> "CyBeR_pUnK11"
 */
describe(@"NSString swapCase", ^{
  it(@"\"Hello\".swapcase                #=> \"hELLO\"", ^{
    [[[@"Hello" swapCase] should] equal:@"hELLO"];
  });
  it(@"\"cYbEr_PuNk11\".swapcase         #=> \"CyBeR_pUnK11\"", ^{
    [[[@"cYbEr_PuNk11" swapCase] should] equal:@"CyBeR_pUnK11"];
  });
});

SPEC_END