//
//  LSURLCache.h
//  SpaceCatalog
//
//  Created by spaceli on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 全局文件缓存
 */
@interface LSURLCache : NSURLCache {
    NSString*             _name;
    NSString*             _cachePath;
}
@property (nonatomic, copy) NSString* cachePath;

+ (LSURLCache*)cacheWithName:(NSString*)name;
+ (LSURLCache*)sharedCache;

- (id)initWithName:(NSString*)name;

+ (void)setSharedCache:(LSURLCache*)cache;

- (float)cacheSize;//cache容量，单位是M
/**
 * 计算cachePath
 */
+ (NSString*)cachePathWithName:(NSString*)name;

- (NSString *)keyForURL:(NSString*)URL;

- (NSString*)cachePathForURL:(NSString*)URL;

- (NSString*)cachePathForKey:(NSString*)key;

/**
 * 缓存文件是否存在
 */
- (BOOL)hasDataForURL:(NSString*)URL;

- (BOOL)hasDataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge;

/**
 * 获取缓存
 */
- (NSData*)dataForURL:(NSString*)URL;

- (NSData*)dataForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge
            timestamp:(NSDate**)timestamp;

- (NSData*)dataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge
            timestamp:(NSDate**)timestamp;

/**
 * 保存
 */
- (void)storeData:(NSData*)data forURL:(NSString*)URL;
- (void)storeData:(NSData*)data forKey:(NSString*)key;

/**
 * 删除cache
 */
- (void)removeURL:(NSString*)URL;

- (void)removeKey:(NSString*)key;

- (void)removeAll;

/**
 * 删除过期缓存
 * param:expirationAge 
 */
- (void)cleanFilesExpired:(NSTimeInterval)expirationAge;


#pragma mark -
#pragma mark For Webcache

+ (void)becomeSharedURLCache;

@end
