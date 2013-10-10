#import <Kiwi/Kiwi.h>
#import "NSMutableString+Ruby.h"

#pragma mark - Support

#pragma mark - Tests

/*
 -(NSString*)upperCaseStringM;
*/

SPEC_BEGIN(NSMutableStringRubySpec)

/*
 "hello".chomp!            #=> "hello"
 "hello\n".chomp!          #=> "hello"
 "hello\r\n".chomp!        #=> "hello"       FAIL (\r\n is not recognized as a single carriage return character in obj-c)
 "hello\n\r".chomp!        #=> "hello\n"
 "hello\r".chomp!          #=> "hello"
 "hello \n there".chomp!   #=> "hello \n there"
 "hello".chomp!("llo")     #=> "he"
 */
describe(@"NSMutableString chompM", ^{
  it(@"\"hello\".chomp            #=> \"hello\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello"];
    [string chompInPlace];
    [[string should] equal:@"hello"];
  });
  it(@"\"hello\n\".chomp          #=> \"hello\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello\n"];
    [string chompInPlace];
    [[string should] equal:@"hello"];
  });
  it(@"\"hello\r\n\".chomp        #=> \"hello\r\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello\r\n"];
    [string chompInPlace];
    [[string should] equal:@"hello\r"];
  });
  it(@"\"hello\n\r\".chomp        #=> \"hello\n\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello\n\r"];
    [string chompInPlace];
    [[string should] equal:@"hello\n"];
  });
  it(@"\"hello \n there\".chomp   #=> \"hello \n there\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello \n there"];
    [string chompInPlace];
    [[string should] equal:@"hello \n there"];
  });
  it(@"\"hello\".chomp(\"llo\")   #=> \"he\"", ^{
    NSMutableString *string = [NSMutableString stringWithString:@"hello"];
    [string chompInPlace:@"llo"];
    [[string should] equal:@"he"];
  });
});

/*
 "hello".delete!("l","lo")        #=> "heo"
 "hello".delete!("lo")            #=> "he"
 "hello".delete!("aeiou", "^e")   #=> "hell"
 "hello".delete!("ej-m")          #=> "ho"
 */
describe(@"NSMutableString deleteM", ^{
  
  __block NSMutableString *a = nil;
  beforeEach(^{
    a = [NSMutableString stringWithString:@"hello"];
  });
  
  it(@"a.delete(\"l\",\"lo\")           #=> \"heo\"", ^{
    [a deleteInPlace:@"l",@"lo",nil];
    [[a should] equal:@"heo"];
  });
  it(@"a.delete(\"l\")                  #=> \"he\"", ^{
    [a deleteInPlace:@"lo",nil];
    [[a should] equal:@"he"];
  });
  it(@"a.delete(\"aeiou\",\"^e\")       #=> \"hell\"", ^{
    [a deleteInPlace:@"aeiou",@"^e",nil];
    [[a should] equal:@"hell"];
  });
  it(@"a.delete(\"ej-m\")               #=> \"ho\"", ^{
    [a deleteInPlace:@"ej-m",nil];
    [[a should] equal:@"ho"];
  });
});

/*
 "hEllO".downcase!   #=> "hello"
 */
describe(@"NSMutableString lowercaseM", ^{
  it(@"a.downcase!                     #=> \"hello\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hEllO"];
    [a lowercaseInPlace];
    [[a should] equal:@"hello"];
  });
});

/*
 "hello".gsub!(%r[aeiou]/, '*')                  #=> "h*ll*"
 'hello'.gsub!(%r[eo]/, 'e' => 3, 'o' => '*')    #=> "h3ll*"
 */
describe(@"NSMutableString substituteAllM", ^{
  
  __block NSMutableString *a = nil;
  beforeEach(^{
    a = [NSMutableString stringWithString:@"hello"];
  });
  
  it(@"\"hello\".gsub!(%r[aeiou]/, '*')                  #=> \"h*ll*\"", ^{
    [a substituteAllInPlace:@"[aeiou]" with:@"*"];
    [[a should] equal:@"h*ll*"];
  });
  it(@"\"hello\".gsub!(%r[eo]/, 'e' => 3, 'o' => '*')    #=> \"h3ll*\"", ^{
    [a substituteAllInPlace:@{@"e" : @"3",
                              @"o" : @"*"}];
    [[a should] equal:@"h3ll*"];
  });
});

/*
 "  hello  ".lstrip!   #=> "hello  "
 "hello".lstrip!       #=> "hello"
 */
describe(@"NSMutableString leftStripM", ^{
  it(@"\"  hello  \".lstrip!   #=> \"hello  \"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"  hello  "];
    [a leftStripInPlace];
    [[a should] equal:@"hello  "];
  });
  it(@"\"  hello  \".lstrip!   #=> \"hello  \"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hello"];
    [a leftStripInPlace];
    [[a should] equal:@"hello"];
  });
});

/*
 "stressed".reverse!   #=> "desserts"
 */
describe(@"NSMutableString reverseM", ^{
  it(@"\"stressed\".reverse!   #=> \"desserts\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"stressed"];
    [a reverseInPlace];
    [[a should] equal:@"desserts"];
  });
});

/*
 "  hello  ".lstrip!   #=> "hello  "
 "hello".lstrip!       #=> "hello"
 */
describe(@"NSMutableString rightStripM", ^{
  it(@"\"  hello  \".rstrip!   #=> \"hello  \"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"  hello  "];
    [a rightStripInPlace];
    [[a should] equal:@"  hello"];
  });
  it(@"\"  hello  \".rstrip!   #=> \"hello  \"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hello"];
    [a rightStripInPlace];
    [[a should] equal:@"hello"];
  });
});

/*
 "yellow moon".squeeze!                    #=> "yelow mon"
 "  now   is  the".squeeze!(" ")           #=> " now is the"
 "putters shoot balls".squeeze!("[m-z]")   #=> "puters shot balls"
 */
describe(@"NSMutableString squeezeM", ^{
  it(@"\"yellow moon\".squeeze!/, '*')                  #=> \"yelow mon\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"yellow moon"];
    [a squeezeInPlace];
    [[a should] equal:@"yelow mon"];
  });
  it(@"\"  now   is  the\".squeeze!(\" \")/, '*')                  #=> \" now is the\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"  now   is  the"];
    [a squeezeInPlace:@" "];
    [[a should] equal:@" now is the"];
  });
  it(@"\"putters shoot balls\".squeeze!(\"[m-z]\")/, '*')                  #=> \"puters shot balls\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"putters shoot balls"];
    [a squeezeInPlace:@"[m-z]"];
    [[a should] equal:@"puters shot balls"];
  });
});

/*
 "    hello    ".strip!   #=> "hello"
 "\tgoodbye\r\n".strip!   #=> "goodbye"
 */
describe(@"NSMutableString stripM", ^{
  it(@"\"    hello    \".strip!                  #=> \"hello\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"    hello    "];
    [a stripInPlace];
    [[a should] equal:@"hello"];
  });
  it(@"\"\\tgoodbye\\r\\n\".strip!               #=> \"goodbye\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"\tgoodbye\r\n"];
    [a stripInPlace];
    [[a should] equal:@"goodbye"];
  });
});

/*
 "hello".sub!(%r[aeiou]/, '*')                  #=> "h*llo"
 */
describe(@"NSString substituteFirst", ^{
  it(@"\"hello\".sub!(%r[aeiou]/, '*')                  #=> \"h*llo\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hello"];
    [a substituteFirstInPlace:@"[aeiou]" with:@"*"];
    [[a should] equal:@"h*llo"];
  });
});

/*
 NB: This doesn't actually exist in Ruby.
 "hello".sublast!(%r[aeiou]/, '*')                  #=> "h*llo"
 */
describe(@"NSMutableString substituteLast", ^{
  it(@"\"hello\".sublast!(%r[aeiou]/, '*')                  #=> \"hell*\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hello"];
    [a substituteLastInPlace:@"[aeiou]" with:@"*"];
    [[a should] equal:@"hell*"];
  });
});

/*
 "Hello".swapcase!          #=> "hELLO"
 "cYbEr_PuNk11".swapcase!   #=> "CyBeR_pUnK11"
 */
describe(@"NSMutableString swapCaseM", ^{
  it(@"\"Hello\".swapcase!                #=> \"hELLO\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"Hello"];
    [a swapcaseInPlace];
    [[a should] equal:@"hELLO"];
  });
  it(@"\"cYbEr_PuNk11\".swapcase!         #=> \"CyBeR_pUnK11\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"cYbEr_PuNk11"];
    [a swapcaseInPlace];
    [[a should] equal:@"CyBeR_pUnK11"];
  });
});

/*
 "hEllO".upcase!   #=> "hello"
 */
describe(@"NSMutableString uppercaseM", ^{
  it(@"a.upcase!                     #=> \"hello\"", ^{
    NSMutableString *a = [NSMutableString stringWithString:@"hEllO"];
    [a uppercaseInPlace];
    [[a should] equal:@"HELLO"];
  });
});

SPEC_END