//
//  LSURLCache.m
//  SpaceCatalog
//
//  Created by spaceli on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LSURLCache.h"
//#import "LSNetworkAdditions.h"

static LSURLCache*          gSharedCache = nil;
static NSMutableDictionary* gNamedCaches = nil;


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSURLCache

@synthesize cachePath         = _cachePath;


- (id)initWithName:(NSString*)name {
    if (self = [super init]) {
        _name             = [name copy];
        _cachePath        = [LSURLCache cachePathWithName:name];
    }
    return self;
}

- (id)init {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];    
    NSString *bundleName = [info objectForKey:@"CFBundleExecutable"];
    if (self = [self initWithName:bundleName]) {
    }
    
    return self;
}


+ (LSURLCache*)cacheWithName:(NSString*)name {
    if (nil == gNamedCaches) {
        gNamedCaches = [[NSMutableDictionary alloc] init];
    }
    LSURLCache* cache = [gNamedCaches objectForKey:name];
    if (nil == cache) {
        cache = [[LSURLCache alloc] initWithName:name];
        [gNamedCaches setObject:cache forKey:name];
    }
    return cache;
}


+ (LSURLCache*)sharedCache {
    if (nil == gSharedCache) {
        gSharedCache = [[LSURLCache alloc] init];
    }
    return gSharedCache;
}

+ (void)setSharedCache:(LSURLCache*)cache {
    if (gSharedCache != cache) {
        gSharedCache = cache;
    }
}

- (float)cacheSize {
    float sizeM = 0;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *files = [fm contentsOfDirectoryAtPath:_cachePath error:nil];
    for (NSString *aFile in files) {
        NSString *fullPath = [_cachePath stringByAppendingPathComponent:aFile];
        NSDictionary* attrs = [fm attributesOfItemAtPath:fullPath error:nil];
        sizeM += [attrs fileSize]/1000.0/1000.0; 
    }
    
    return sizeM;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)createPathIfNecessary:(NSString*)path {
    BOOL succeeded = YES;
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        succeeded = [fm createDirectoryAtPath: path
                  withIntermediateDirectories: YES
                                   attributes: nil
                                        error: nil];
    }
    
    return succeeded;
}

+ (NSString*)cachePathWithName:(NSString*)name {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath = [paths objectAtIndex:0];
//    NSString* cachesPath = NSTemporaryDirectory();
    NSString* cachePath = [cachesPath stringByAppendingPathComponent:name];
    
    [self createPathIfNecessary:cachesPath];
    [self createPathIfNecessary:cachePath];
    
    return cachePath;
}


#pragma mark -
#pragma mark Public

- (NSString *)keyForURL:(NSString*)URL {
    return [URL md5Hash];
}

- (NSString*)cachePathForURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    return [self cachePathForKey:key];
}

- (NSString*)cachePathForKey:(NSString*)key {
    return [_cachePath stringByAppendingPathComponent:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForURL:(NSString*)URL {
    NSString* filePath = [self cachePathForURL:URL];
    NSFileManager* fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:filePath];
}

- (NSData*)dataForURL:(NSString*)URL {
    return [self dataForURL:URL expires:1.0/0.0 timestamp:nil];
}

- (NSData*)dataForURL:(NSString*)URL expires:(NSTimeInterval)expirationAge timestamp:(NSDate**)timestamp {
    NSString* key = [self keyForURL:URL];
    return [self dataForKey:key expires:expirationAge timestamp:timestamp];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasDataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
        NSDate* modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (NSData*)dataForKey:(NSString*)key expires:(NSTimeInterval)expirationAge timestamp:(NSDate**)timestamp {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSDictionary* attrs = [fm attributesOfItemAtPath:filePath error:nil];
        NSDate* modified = [attrs objectForKey:NSFileModificationDate];
        if ([modified timeIntervalSinceNow] < -expirationAge) {
            return nil;
        }
        if (timestamp) {
            *timestamp = modified;
        }
        
        return [NSData dataWithContentsOfFile:filePath];
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)storeData:(NSData*)data forURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    [self storeData:data forKey:key];
}


- (void)storeData:(NSData*)data forKey:(NSString*)key {
    
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filePath contents:data attributes:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeURL:(NSString*)URL {
    NSString* key = [self keyForURL:URL];
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (filePath && [fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}

- (void)removeKey:(NSString*)key {
    NSString* filePath = [self cachePathForKey:key];
    NSFileManager* fm = [NSFileManager defaultManager];
    if (filePath && [fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}

- (void)removeAll{
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:_cachePath error:nil];
    [LSURLCache createPathIfNecessary:_cachePath];
}

- (void)cleanFilesExpired:(NSTimeInterval)expirationAge {
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_cachePath]) {
        NSArray *files = [fm contentsOfDirectoryAtPath:_cachePath error:nil];
        for (NSString *aFile in files) {
            NSString *fullPath = [_cachePath stringByAppendingPathComponent:aFile];
            NSDictionary* attrs = [fm attributesOfItemAtPath:fullPath error:nil];
            NSDate* modified = [attrs objectForKey:NSFileModificationDate];
            if ([modified timeIntervalSinceNow] < -expirationAge) {
                [fm removeItemAtPath:fullPath error:nil];
            } 
        }
    }
}

#pragma mark -
#pragma mark For Webcache

+ (void)becomeSharedURLCache {
    [NSURLCache setSharedURLCache:[LSURLCache sharedCache]];
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSString *urlString = [[request URL] absoluteString];
	
    NSData *data = [self dataForURL:urlString];
    if (data) {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                             MIMEType:[urlString mimeType]
                                                expectedContentLength:[data length]
                                                     textEncodingName:nil];
        return [[NSCachedURLResponse alloc] initWithResponse:response data:data];        
    }
    
	return [super cachedResponseForRequest:request];
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    NSString *urlString = [[request URL] absoluteString];
    if (urlString.mimeType) {
        [self storeData:cachedResponse.data forURL:urlString];
    }
    
    [super storeCachedResponse:cachedResponse forRequest:request];
}
@end
