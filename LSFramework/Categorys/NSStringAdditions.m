//
//  NSStringAdditions.m
//  LSiPhone
//
//  Created by spaceli on 11-8-2.
//  Copyright 2011年 diandian. All rights reserved.
//

#import "NSStringAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Commen)

- (NSString *)append:(NSString *)string {
    return [NSString stringWithFormat:@"%@%@",self,string];
}
+ (NSString *)stringFromFile:(NSString *)fileName {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *text  = [NSString stringWithContentsOfFile:fileName encoding:enc error:nil];
    return text;
}
- (long)longValue {
    return (long)[self longLongValue];
}
- (NSString *)stringValue {
    return self;
}
@end


@implementation NSString (parse) 

- (NSString*)stringByRemovingHTMLTags {
    return nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSComparisonResult)versionStringCompare:(NSString *)other {
    NSArray *oneComponents = [self componentsSeparatedByString:@"."];
    NSArray *twoComponents = [other componentsSeparatedByString:@"."];
    
    //比较主版本号
    int one = [[oneComponents objectAtIndex:0] intValue];
    int two = [[twoComponents objectAtIndex:0] intValue];
    if (one < two) {
        return NSOrderedAscending;
    }else if (one > two) {
        return NSOrderedDescending;
    }
    
    //比较次版本号
    one = [[oneComponents objectAtIndex:1] intValue];
    two = [[twoComponents objectAtIndex:1] intValue];
    if (one < two) {
        return NSOrderedAscending;
    }else if (one > two) {
        return NSOrderedDescending;
    }
    
    //比较长度
    if ([oneComponents count] < [twoComponents count]) {
        return NSOrderedDescending;        
    } else if ([oneComponents count] > [twoComponents count]) {
        return NSOrderedAscending;        
    } 
    
    if (oneComponents.count == 2) {//版本号只有两位
        return NSOrderedSame;
    }else {//版本号有三位，比较第三位
        one = [[oneComponents objectAtIndex:2] intValue];
        two = [[twoComponents objectAtIndex:2] intValue];
        if (one < two) {
            return NSOrderedAscending;
        }else if (one > two) {
            return NSOrderedDescending;
        }
    }    
    return NSOrderedSame;
}

- (NSString *)URLEncodedString
{
    CFStringRef r = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    NSString *result = CFBridgingRelease(r);
	return result;
}

- (NSString*)URLDecodedString
{
	CFStringRef r = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    NSString *result = CFBridgingRelease(r);
	return result;
}

- (NSDictionary *)parseURLParams {
    NSMutableDictionary *paragrmsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *pagramArray = [self componentsSeparatedByString:@"&"];
    for (NSString *pagramString in pagramArray) {
        NSArray *pagramValueAndName = [pagramString componentsSeparatedByString:@"="];
        if ([pagramValueAndName count] >= 2) {
            NSString *name = [pagramValueAndName objectAtIndex:0];
            NSString *value = [pagramValueAndName objectAtIndex:1];
            
            if (name && value) {
                [paragrmsDict setObject:value forKey:name];
            }
        }
    }
    
    return paragrmsDict;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
    // Create pointer to the string as UTF8
    const char* ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return output;
}

@end
NSString *toMoneyString(float m){
    BOOL isNegative = (m <= -0.005);
    m = fabsf(m);
    NSString *str = nil;
    if (((int)((m+0.005)*100))%10 != 0) {
        str = [NSString stringWithFormat:@"%.2f",m+0.001];
    }else if (((int)((m+0.005)*10))%10 != 0) {
        str = [NSString stringWithFormat:@"%.1f",m];
    }else {
        str = [NSString stringWithFormat:@"%.0f",m];
    }
    if (isNegative) {
        str = [NSString stringWithFormat:@"-%@",str];
    }
    return str;
}


@implementation NSString (drawing)

- (CGFloat)heightWithFont:(UIFont *)font limitByWidth:(float)width {
//    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail].height;
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:nil context:NULL].size.height;
}

- (int)totalLinesWithFont:(UIFont *)font limitByWidth:(float)width{
    NSString *tmpStr = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    int lines = 0;
    NSArray *strArray = [tmpStr componentsSeparatedByString:@"\n"];
    if ([strArray count] > 1) {
        for (NSString *str in strArray) {
            if (![str isEqualToString:@""]) {
                lines = lines + [str linesWithFont:font limitByWidth:width];
            }
        }
    }else {
        lines = ceil([self sizeWithAttributes:@{NSFontAttributeName:font}].width/width);
    }
    return lines;
}

- (int)linesWithFont:(UIFont *)font limitByWidth:(float)width {
    int lines = ceil([self sizeWithAttributes:@{NSFontAttributeName:font}].width/width);
    return lines;
}

/**统计feed字数(中文为两个字符、英文及符号为一个字符)
 */
- (int)wordCount{
    int i,l=0,a=0,b=0;
    NSUInteger n=[self length];
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}


- (NSString *)stringByLimitLength:(NSUInteger)length withString:(NSString *)replaceString lineBreakMode:(NSLineBreakMode)model{
    NSString *limitString = nil;
    if ([self length] > length-replaceString.length) {
        switch (model) {
            case NSLineBreakByTruncatingHead:
                limitString = [self stringByReplacingCharactersInRange:NSMakeRange(0, length) withString:replaceString];
                break;
            case NSLineBreakByTruncatingTail:
                limitString = [self stringByReplacingCharactersInRange:NSMakeRange(length-replaceString.length, self.length) withString:replaceString];
                break;    
            default:
                limitString = [self stringByReplacingCharactersInRange:NSMakeRange(length/2, self.length-length-replaceString.length) withString:replaceString];
                break;
        }
        
    }
    return limitString;
}
@end


@implementation NSString (init)

+ (NSString *)stringWithInt:(int)intValue {
    return [NSString stringWithFormat:@"%d",intValue];
}
+ (NSString *)stringWithFloat:(float)floatValue {
    return [NSString stringWithFormat:@"%.2f",floatValue];
}
@end



@implementation NSString (match)

- (BOOL)fuzzyMatching:(NSString *)pattern {
    if (pattern.length == 0) {
        return YES;
    }
    unsigned long index = [self rangeOfString:[pattern substringToIndex:1]].location;
    if (index != NSNotFound) {
        if (self.length-index-1 >= pattern.length-1) {
            return [[self substringFromIndex:index+1] fuzzyMatching:[pattern substringFromIndex:1]];
        }
    }
    return NO;
}

@end


@implementation NSString (MimeType)

- (NSString *)mimeType {
    NSString *extension = [self.pathExtension lowercaseString];NSDump(extension);
    if ([extension isEqualToString:@"html"]) {
        return @"text/html";
    }else if ([extension isEqualToString:@"css"]) {
        return @"text/css";
    }else if ([extension isEqualToString:@"js"]) {
        return @"text/javascript";
    }else if ([extension isEqualToString:@"png"]) {
        return @"image/png";
    }else if ([extension isEqualToString:@"jpg"]) {
        return @"image/jpeg";
    }else if ([extension isEqualToString:@"gif"]) {
        return @"image/gif";
    }else if ([extension isEqualToString:@"plist"]) {
        return @"text/xml";
    }
    return nil;
}

@end
