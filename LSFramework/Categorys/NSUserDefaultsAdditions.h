//
//  MTUserDefault.h
//  MTMessage
//
//  Created by 李帅 on 12-12-25.
//  Copyright (c) 2012年 meituan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (LSCore)
//basic
+ (void)setObject:(id)object forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;

+ (void)cleanAll;
@end

