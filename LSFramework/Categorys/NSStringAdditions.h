//
//  NSStringAdditions.h
//  LSiPhone
//
//  Created by spaceli on 11-8-2.
//  Copyright 2011年 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Commen)
- (NSString *)append:(NSString *)string;
+ (NSString *)stringFromFile:(NSString *)fileName;//gb
- (long)longValue;
- (NSString *)stringValue;
@end

@interface NSString (parse)

/**
 * Returns a string with all HTML tags removed.
 */
- (NSString*)stringByRemovingHTMLTags;

/**
 * Compares two strings expressing software versions.
 *   "3.0" = "3.0"
 *   "3.0" > "2.5"
 *   "3.1" > "3.0"
 *   "3.02" < "3.03"
 *   "3.0.2" < "3.0.3"
 */
- (NSComparisonResult)versionStringCompare:(NSString *)other;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
- (NSDictionary *)parseURLParams;//把url中的参数转成NSDictionary
@property (nonatomic, readonly) NSString* md5Hash;

@end

NSString *toMoneyString(float m);

@interface NSString (drawing)

- (int)wordCount;

- (CGFloat)heightWithFont:(UIFont *)font limitByWidth:(float)width;
- (int)linesWithFont:(UIFont *)font limitByWidth:(float)width;
- (int)totalLinesWithFont:(UIFont *)font limitByWidth:(float)width;

- (NSString *)stringByLimitLength:(NSUInteger)length withString:(NSString *)replaceString lineBreakMode:(NSLineBreakMode)model;

@end

@interface NSString (init)
+ (NSString *)stringWithInt:(int)intValue;
+ (NSString *)stringWithFloat:(float)floatValue;
@end

@interface NSString (match)
- (BOOL)fuzzyMatching:(NSString *)pattern;
@end

@interface NSString (MimeType)
- (NSString *)mimeType;
@end
