//
//  NSObjectCodingAdditions.h
//  LSCore
//
//  Created by 李帅 on 1/27/14.
//  Copyright (c) 2014 spaceli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoCoding) <NSSecureCoding>

//coding

+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

//property access

- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

//loading / saving

+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end