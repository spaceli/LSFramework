//
//  LSLocalReminder.h
//  AccountBook
//
//  Created by spaceli on 13-11-2.
//  Copyright (c) 2013年 李帅. All rights reserved.
//
/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
 
    self.window.rootViewController = ...;
 
    [LSLocalReminder setAppID:@"934378414"];
 
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [LSLocalReminder goRate];
}
*/
//请记得在AppDelegate中添加如上代码


#import <Foundation/Foundation.h>
//当前版本是否提醒过“评分”
typedef enum {
    LSRatedStatusNo = 0,
    LSRatedStatusPushed,
    LSRatedStatusNever,
    LSRatedStatusRated,
}LSRatedStatus;

@interface LSLocalReminder : NSObject

+ (void)setAppID:(NSString *)appID;//必须设置AppID

//检测是否弹用户评论。
//featureID 功能标识，例如：“AddExpenseFinished” “Close”
//canWitToClose是指是否可以等关闭后再弹，Yes表示可以等退出程序时弹，NO表示立刻弹。
+ (void)checkToShowRateFor:(NSString *)featureID waitToClose:(BOOL)canWaitToClose;

+ (void)showRateNotify;//弹评分提醒

+ (void)goRate;//跳转到评分


+ (void)setUseTimesForRate:(NSInteger)times;//计算最近多少次使用。default 10
+ (void)setRemindTimesForRate:(NSInteger)times;//最多提醒几次。default 4
+ (void)setRemindBetween:(NSInteger)minCycle and:(NSInteger)maxCycle;//使用频率在什么范围提醒。Default 10min < remind <10d

@end


@interface NSUserDefaults (LSLocalReminder)
+ (void)saveClientRated:(LSRatedStatus)status;
+ (LSRatedStatus)clientRatedStatus;

+ (void)saveIgnoreRateTimes:(int)times;
+ (int)ignoreRateTimes;

+ (void)saveNearestUseTimes:(NSArray *)times for:(NSString *)featureID;
+ (NSArray *)nearestUseTimesFor:(NSString *)featureID;

@end

