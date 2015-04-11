//
//  LSLocalReminder.m
//  AccountBook
//
//  Created by spaceli on 13-11-2.
//  Copyright (c) 2013年 李帅. All rights reserved.
//

#import "LSLocalReminder.h"
#import "NSUserDefaultsAdditions.h"


@implementation LSLocalReminder

static NSString *_appID = nil;
static NSInteger _useTimesForRate = 10;
static NSInteger _remindTimesForRate = 4;
static NSInteger _minCycle = 60*10;
static NSInteger _maxCycle = 60*60*24*10;

static BOOL _willShowLocalNotification = NO;

+ (void)setAppID:(NSString *)appID {
    _appID = appID;
}

+ (void)setUseTimesForRate:(NSInteger)times {
    _useTimesForRate = times;
}
+ (void)setRemindTimesForRate:(NSInteger)times {
    _remindTimesForRate = times;
}
+ (void)setRemindBetween:(NSInteger)minCycle and:(NSInteger)maxCycle {
    _minCycle = minCycle;
    _maxCycle = maxCycle;
}


+ (void)checkToShowRateFor:(NSString *)featureID waitToClose:(BOOL)canWaitToClose {
    NSAssert(_appID!=nil, @"appID不能为空");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (OS_Version >= 8) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
    });
    
    if (_willShowLocalNotification) {//要等到退出程序时弹
        return;
    }
    LSRatedStatus currentStatus = [NSUserDefaults clientRatedStatus];
    if (currentStatus==LSRatedStatusRated || currentStatus==LSRatedStatusNever) {
        return;
    }
    
    if (currentStatus == LSRatedStatusPushed) {//用户忽略
        
        int times = [NSUserDefaults ignoreRateTimes];
        times ++;
        if (times >= _remindTimesForRate) {//忽略评分几次，不再弹
            [NSUserDefaults saveClientRated:LSRatedStatusNever];
        }else {//清除状态，再给一次机会
            [NSUserDefaults saveIgnoreRateTimes:times];
            [NSUserDefaults saveNearestUseTimes:[NSArray array] for:featureID];
            [NSUserDefaults saveClientRated:LSRatedStatusNo];
        }
    }
    _willShowLocalNotification = NO;
    
    NSMutableArray *newArray = nil;
    NSArray *oldArray = [NSUserDefaults nearestUseTimesFor:featureID];
    if (oldArray == nil) {
        newArray = [NSMutableArray array];
    }else {
        newArray = [NSMutableArray arrayWithArray:oldArray];
    }
    
    NSNumber *time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [newArray insertObject:time atIndex:0];
    
    NSInteger t = _useTimesForRate;//计算最近几次
    if (newArray.count >= t+1) {
        double min=0,max=0;
        int total=0,avg=0;
        for (int i=0;i<t;i++) {
            double gap = [[newArray objectAtIndex:i] doubleValue]-[[newArray objectAtIndex:i+1] doubleValue];
            if (min == 0) {
                min = gap;
            }else if (min > gap){
                min = gap;
            }
            if (max < gap) {
                max = gap;
            }
            total += gap;
        }
        total = total - min - max;
        avg = total/(t-2);
        if (avg>_minCycle && avg<_maxCycle) {//打开频率
            [NSUserDefaults saveClientRated:LSRatedStatusPushed];//改变状态
            
            if (canWaitToClose &&
                (OS_Version<8 || [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone)) {
                _willShowLocalNotification = YES;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
            }else {
                [self showRateNotify];
            }
            
        }
        [newArray removeLastObject];
    }
    [NSUserDefaults saveNearestUseTimes:newArray for:featureID];
}


+ (void)showRateNotify {
    NSAssert(_appID!=nil, @"appID不能为空");
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = @"亲爱的，给我个好评吧~";
        localNotif.alertAction = LSLocalizedString(@"没问题");
        //    localNotif.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }else {
        [UIAlertView showAlertViewWithTitle:@"亲爱的，给我个好评吧~" message:nil
                          cancelButtonTitle:@"残忍拒绝"
                          otherButtonTitles:@[@"支持一下"]
                                  dismissed:^(UIAlertView *alertView, int buttonIndex) {
                                      if (buttonIndex == 1) {
                                          [self goRate];
                                      }
                                  } canceled:^{
                                      
                                  }];
    }
    
}

+ (void)goRate {
    NSAssert(_appID!=nil, @"appID不能为空");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSUserDefaults saveClientRated:LSRatedStatusRated];//改变状态
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",_appID];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    });
    
}

+ (void)applicationDidEnterBackground {
    if (_willShowLocalNotification) {
        [self showRateNotify];
        _willShowLocalNotification = NO;
    }
}
@end

#define kClientRateLog            @"kClientRateLog"
#define kIgnoreRateTimes        @"kIgnoreRateTimes"
#define KNearestUseTimes        @"KNearestUseTimes"
@implementation NSUserDefaults (LSLocalReminder)

//客户端否提醒过“评分”
+ (void)saveClientRated:(LSRatedStatus)status {
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[self objectForKey:kClientRateLog]];
    [info setObject:@(status) forKey:[UIDevice clientVersion]];
    [self setObject:info forKey:kClientRateLog];
}
+ (LSRatedStatus)clientRatedStatus {
    LSRatedStatus status = [[[self objectForKey:kClientRateLog] objectForKey:[UIDevice clientVersion]] intValue];
    return status;
}

+ (void)saveIgnoreRateTimes:(int)times {
    NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:times] forKey:[UIDevice clientVersion]];
    [self setObject:info forKey:kIgnoreRateTimes];
}
+ (int)ignoreRateTimes {
    return [[[self objectForKey:kIgnoreRateTimes] objectForKey:[UIDevice clientVersion]] intValue];
}

+ (void)saveNearestUseTimes:(NSArray *)times for:(NSString *)featureID {
    NSMutableDictionary *features = [NSMutableDictionary dictionaryWithDictionary:[self objectForKey:KNearestUseTimes]];
    [features setObject:times forKey:featureID];
    [self setObject:features forKey:KNearestUseTimes];
}
+ (NSArray *)nearestUseTimesFor:(NSString *)featureID {
    NSDictionary *features = [self objectForKey:KNearestUseTimes];
    return features[featureID];
}


@end

