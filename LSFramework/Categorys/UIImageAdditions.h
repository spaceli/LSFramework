//
//  UIImageAdditions.h
//  LSiPhone
//
//  Created by spaceli on 11-8-4.
//  Copyright 2011年 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (size)


+ (CGSize)imagesSizeWithOrignWidth:(int)w height:(int)h fitInSize:(CGSize)poolSize;
- (UIImage*)scaleToSize:(CGSize)size;

+ (UIImage *)rotateImage:(UIImage *)aImage withOrientation:(UIImageOrientation)orientation;
- (UIImage *)subImageAtRect:(CGRect)rect;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end

@interface UIImage (create)
+ (UIImage *)bigImageWithName:(NSString *)imageName;
- (UIImage *)imageByDyeingColor:(UIColor *)color;
@end
