//
//  NSDateAdditions.h
//  iPhone
//
//  Created by spaceli on 11-11-17.
//  Copyright (c) 2011年 diandian.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (format)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString*)formatString;
+ (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)stringByFormat:(NSString *)formatString;

- (NSString *)yyyy;
- (NSString *)yyyyMMdd;

- (NSString *)HHmm;
- (NSString *)MMdd;
/**
 * 变为 MM-dd HH:mm 的格式。如11-17 17:10
 */
- (NSString *)MMddHHmm;

/**
 * 变为 yyyy-MM-dd HH:mm 的格式。如2011-11-17 17:10
 */
- (NSString *)yyyyMMddHHmm;

/**
 * 11.17 周三 17:10
 */
- (NSString *)MMddEHHmm;

/**
 * 相对时间描述，例如：5分钟前、3小时前、大于一天则按 MMddHHmm 的格式表示
 */
- (NSString *)relativeTime;
@end


@interface NSDate (Utils)

- (NSDateComponents *)components;
- (NSDate *)dateAfter7Days;
@end