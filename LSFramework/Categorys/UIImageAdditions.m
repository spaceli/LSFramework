//
//  UIImageAdditions.m
//  LSiPhone
//
//  Created by spaceli on 11-8-4.
//  Copyright 2011年 diandian. All rights reserved.
//

#import "UIImageAdditions.h"

 
#define DegreesToRadians(degrees) degrees * M_PI / 180
#define RadiansToDegrees(radians) radians * 180/M_PI

@implementation UIImage (size)


+ (CGSize)imagesSizeWithOrignWidth:(int)w height:(int)h fitInSize:(CGSize)poolSize {

    CGSize originSize = CGSizeMake(w,h);
	CGSize size = originSize;
    
    size.width = MIN(poolSize.width, originSize.width);
    
    // Spaceli
	if (originSize.width/poolSize.width < originSize.height/poolSize.height) {
        if (originSize.height > poolSize.height) {
            size.height = poolSize.height;
            size.width = (originSize.width/originSize.height) * size.height;
        }else {
            size = originSize;
        }
		
	}else {
        if (originSize.width > poolSize.width) {
            size.width = poolSize.width;
            size.height = (originSize.height/originSize.width) * size.width;
        }else {
            size = originSize;
        }		
	}
    
    return size;
}

- (UIImage*)scaleToSize:(CGSize)size
{
    if (self.size.width/size.width > self.size.height/size.height) {
        size.height = (size.width/self.size.width) *self.size.height;
    }else {
        size.width = (size.height/self.size.height) * self.size.width;
    }
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


-(UIImage *)subImageAtRect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{  
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (UIImage *)rotateImage:(UIImage *)aImage withOrientation:(UIImageOrientation)orientation {
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;

    switch(orientation)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
@end



@implementation UIImage (create)

+ (UIImage *)bigImageWithName:(NSString *)imageName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension]
                                                         ofType:[imageName pathExtension]];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
}
- (UIImage *)imageByDyeingColor:(UIColor *)color {
    CGImageRef inImageRef = [self CGImage];
	float w = CGImageGetWidth(inImageRef);
	float h = CGImageGetHeight(inImageRef);

	UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h), inImageRef);
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSourceIn);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end