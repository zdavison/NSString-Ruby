NSString+Ruby
====================

Intro
---------------------
NSString+Ruby is an attempt to improve NSString by porting Ruby String methods onto a category on NSString. 
This means you can use the majority of Ruby String methods in obj-c, with the exception of a few unnecessary, 
unimplimented (as of yet), and mutating methods (Mutation of strings is not the objective-c 'way', so we don't do it here).

Differences / Important notes
---------------------
Changes have been made to method names, mostly to line up with traditional objective-c naming conventions, the rule
generally being that all shorthand words have been extended to their full equivalent (eg: rStrip is rightStrip)

Blocks are available for some methods, and not others, mostly for language paradigm reasons.

Operator overloading has been mimicked to the best of our ability, using clever shorthand and unnamed methods,
the equivalent of the concatenation operator (+), would be (:) in NSString+Ruby, as follows:

```ruby
"hello" + "world"
```

```objective-c
[@"hello ":@"world"];
```

This is still a little ugly, but is the least amount of code you'd need to write in obj-c to do concatenation now.

Array/index style accessors are provided through:

```objective-c
-(id)objectAtIndexedSubscript:(NSUInteger)index;
-(id)objectForKeyedSubscript:(id)key;
```

...and provide for the majority of Ruby style functionality, the following, for example, all work:

```ruby
 a = "hello there"
 a[1]                   #=> "e"
 a[2, 3]                #=> "llo"
 a[-3, 2]               #=> "er"
 a[2..3]                #=> "ll"
 a[7..-2]               #=> "her"
 a[-4..-2]              #=> "her"
 a[-2..-4]              #=> nil
 a[12..-1]              #=> nil
 a[%r[aeiou](.){2}]     #=> "ell"
 a["lo"]                #=> "lo"
 a["bye"]               #=> nil
```

```objective-c
NSString *a = @"hello there";
a[1];                   // "e"
a[2,3];                 // "llo"
a[-3, 2]               #=> "er"
```

Ranges are provided through C-string shorthand, allowing you to write the following:

```objective-c
NSString *a = @"hello there";
a[2:"..":3];            // "ll"
a[7:"..":-2];           // "her"
a[-4:"..":-2]           // "her"
a[-2:"..":-4]           // nil
a[12:"..":-1]           // nil
```

Regex matching also works, and is provided as the primary means of matching, almost anything that takes a string
can take a regex pattern.

```objective-c
NSString *a = @"hello there";
a[@"[aeiou](.){2}"]     // ell
a["lo"]                 // lo
a["bye"]                // nil
```

Installation
---------------------
Clone the repository, and add the following files to your project:

```
NSString+Ruby.h 
NSString+Ruby.m
```

Tests
---------------------
Tests are provided through Kiwi ( https://github.com/allending/Kiwi ), and are largely reproduced from the Ruby String
Reference page ( http://www.ruby-doc.org/core-1.9.3/String.html#method-i-split ), some methods may be changed slightly
in how they function, but for the most part the goal is to ape Ruby behaviour.

Method List
---------------------
Here is a full equivalence list of methods provided (Notes are provided in brackets for when things are purposefully
not implemented, blank lines will be implemented in future versions)

```ruby
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
 
```
