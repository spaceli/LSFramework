//
//  UIDeviceAdditions.h
//  SpaceCatalog
//
//  Created by spaceli on 11-10-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIDevice (currenDevice)

+ (NSString *)appDisplayName;
+ (NSString *)clientVersion;

+ (NSString *)projectName;

+ (BOOL)isJailBroken;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////


@interface UIDevice (network)

+ (NSString *)hostname;//主机名称
+ (NSString *)IPAddressWithHost:(NSString *)theHost;
+ (NSString *)localIPAddress;//局域网IP

+ (NSString *)carrierName;

+ (NSString *)currentWifiName;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIDevice (Hardware)

+ (NSString *)modelName;
+ (NSNumber *)totalDiskSpace;//unsignedLongLongValue
+ (NSNumber *)freeDiskSpace;//unsignedLongLongValue
+ (BOOL)isiPad;

@end