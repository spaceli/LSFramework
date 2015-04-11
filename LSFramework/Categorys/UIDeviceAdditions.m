//
//  UIDeviceAdditions.m
//  SpaceCatalog
//
//  Created by spaceli on 11-10-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceAdditions.h"
#include <sys/sysctl.h>
#include <net/if.h>
#import <sys/utsname.h>
#import <netdb.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <SystemConfiguration/CaptiveNetwork.h>



@import CoreTelephony;

@implementation UIDevice (currenDevice)

+ (NSString *)appDisplayName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
+ (NSString *)clientVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)projectName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (BOOL)isJailBroken {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    FILE *f = fopen("/bin/bash", "r");
    BOOL isJailbroken = NO;
    if (f != NULL)
    {
        //Device is jailbroken
        isJailbroken = YES;
    }
    fclose(f);
    return isJailbroken;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||
//        [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
//        return YES;
//    }
//    return NO;
}

+ (int)reboot {
	system("echo alpine | su root");
	return system("reboot");
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIDevice (network)

+ (NSString *)hostname {
    
	char baseHostName[256]; // Thanks, Gunnar Larisch
	int success = gethostname(baseHostName, 255);
	if (success != 0) return nil;
	baseHostName[255] = '\0';
	
	return [NSString stringWithFormat:@"%s.local", baseHostName];
}

+ (NSString *)IPAddressWithHost:(NSString *)theHost {
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

+ (NSString *)localIPAddress {
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	NSString *ip = nil;
    
	if (!getifaddrs(&addrs)) {
		cursor = addrs;
		while (cursor != NULL) {
            
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
                ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return ip;
    
}


+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrierName = carrier.carrierName ? carrier.carrierName : @"模拟器";
    return carrierName;
}

+ (NSString *)currentWifiName {
    NSString *wifiName = @"Not Found";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
    
    if (myArray != nil) {
        
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        
        if (myDict != nil) {
            
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            wifiName = [dict valueForKey:@"SSID"];
        }
    }
    return wifiName;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIDevice (Hardware)

+ (int) getSysInfo: (uint) typeSpecifier {
	unsigned int results;
    size_t size = sizeof(results);
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return results;
}

+ (NSString *)modelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


+ (NSNumber *) totalDiskSpace {//unsignedLongLongValue
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemSize];
}

+ (NSNumber *) freeDiskSpace {//unsignedLongLongValue
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

+ (BOOL)isiPad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? YES : NO;
}
+ (BOOL)isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0);
}
@end