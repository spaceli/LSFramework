//
//  MTUserDefault.m
//  MTMessage
//
//  Created by 李帅 on 12-12-25.
//  Copyright (c) 2012年 meituan.com. All rights reserved.
//

#import "NSUserDefaultsAdditions.h"

@implementation NSUserDefaults (LSCore)

+ (void)setObject:(id)object forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)cleanAll {
    [NSUserDefaults resetStandardUserDefaults];
}
@end


