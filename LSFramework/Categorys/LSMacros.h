//
//  LSMacros.h
//  SpaceCatalog
//
//  Created by 李 帅 on 12-5-9.
//  Copyright (c) 2012年 lishuai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(hexValue) [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:1.0]

#define CGRectMake(x,y,width,height) CGRectMake(floor(x), floor(y), floor(width), floor(height)) 

#define LSLocalizedString(s) NSLocalizedString(s,nil)?NSLocalizedString(s,nil):s

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define OS_Version [[[UIDevice currentDevice] systemVersion] floatValue]



#ifdef DEBUG
#define NSLog(s,...) NSLog(@"<%@(%d)> %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define NSDump(s) NSLog(@"%@", s)
#else
#define NSLog(s,...) 
#define NSDump(s) 
#endif

#define within_main_thread(block,...) \
if ([[NSThread currentThread] isMainThread]) { \
if (block) { \
block(__VA_ARGS__); \
} \
} else { \
if (block) { \
dispatch_async(dispatch_get_main_queue(), ^(){ \
block(__VA_ARGS__); \
}); \
} \
}

#define within_background_thread(block,...) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
block(__VA_ARGS__); \
});

//标记废弃方法
#define LS_DEPRECATED  NS_DEPRECATED_IOS(2_0, 4_0)


#pragma clang diagnostic ignored "-Warc-performSelector-leaks"