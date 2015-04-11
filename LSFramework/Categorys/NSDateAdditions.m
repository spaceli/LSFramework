//
//  NSDateAdditions.m
//  iPhone
//
//  Created by spaceli on 11-11-17.
//  Copyright (c) 2011年 diandian.com. All rights reserved.
//

#import "NSDateAdditions.h"

@implementation NSDate (format)

- (NSDateFormatter *)sharedFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

+(NSDate *)dateWithString:(NSString *)dateString format:(NSString*)formatString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone =  [NSTimeZone defaultTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:dateString];
    
    NSDate *dateTime = [formatter dateFromString:formatString];
    
    return dateTime;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    [formatter setTimeZone:timeZone];
//    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
//    NSDate *dateTime = [formatter dateFromString:@"Mon Sep 21 21:10:35 +0800 2009"];
    if (!dateString || dateString.length<10) {
        return nil;
    }
    struct tm tm;
    time_t t;
    dateString=[dateString substringFromIndex:4];
    strptime([dateString cStringUsingEncoding:NSUTF8StringEncoding], "%b %d %H:%M:%S %z %Y", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:t];
    
    return dateTime;
    
}

- (NSString *)stringByFormat:(NSString *)formatString {
	[self.sharedFormatter setDateFormat:formatString];
    return [self.sharedFormatter stringFromDate:self];
}

- (NSString *)yyyy {
    return [self stringByFormat:@"yyyy"];
}
- (NSString *)yyyyMMdd {
    return [self stringByFormat:@"yyyy.MM.dd"];
}
- (NSString *)HHmm {
    return [self stringByFormat:@"HH:mm"];
}
- (NSString *)MMdd {
    return [self stringByFormat:@"MM.dd"];
}
- (NSString *)MMddHHmm {
    return [self stringByFormat:@"MM-dd HH:mm"];
}
- (NSString *)yyyyMMddHHmm {
    return [self stringByFormat:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)MMddEHHmm {
    NSDateComponents *co = self.components;
    NSArray *weekday = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *string = [NSString stringWithFormat:@"%ld.%ld %@ %ld:%ld%ld",co.month,co.day,weekday[co.weekday-1],co.hour,co.minute/10,co.minute%10];
    return string;
}

- (NSString *)relativeTime {
    NSTimeInterval interval = -[self timeIntervalSinceNow];
    if (interval < 60) {
        return [NSString stringWithFormat:@"%.f秒前",interval];
    }else if (interval < 60*60) {
        return [NSString stringWithFormat:@"%.f分钟前",interval/60];
    }else if (interval < 60*60*24) {
        return [NSString stringWithFormat:@"%.f小时前",interval/60/60];
    }
    return [self MMddHHmm];
}


@end

@implementation NSDate (Utils)

- (NSDateComponents *)components {
    NSUInteger unitFlags = 2047;
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
}

- (NSDate *)dateAfter7Days {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    components.day += 8;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}
@end


@implementation NSDate (China)

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅",    @"丁卯",    @"戊辰",    @"己巳",    @"庚午",    @"辛未",    @"壬申",    @"癸酉",
                             @"甲戌",    @"乙亥",    @"丙子",    @"丁丑", @"戊寅",    @"己卯",    @"庚辰",    @"辛己",    @"壬午",    @"癸未",
                             @"甲申",    @"乙酉",    @"丙戌",    @"丁亥",    @"戊子",    @"己丑",    @"庚寅",    @"辛卯",    @"壬辰",    @"癸巳",
                             @"甲午",    @"乙未",    @"丙申",    @"丁酉",    @"戊戌",    @"己亥",    @"庚子",    @"辛丑",    @"壬寅",    @"癸丑",
                             @"甲辰",    @"乙巳",    @"丙午",    @"丁未",    @"戊申",    @"己酉",    @"庚戌",    @"辛亥",    @"壬子",    @"癸丑",
                             @"甲寅",    @"乙卯",    @"丙辰",    @"丁巳",    @"戊午",    @"己未",    @"庚申",    @"辛酉",    @"壬戌",    @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    
    return chineseCal_str;
}

@end