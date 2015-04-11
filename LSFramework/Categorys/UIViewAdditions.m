//
//  UIViewAdditions.m
//  LSiPhone
//
//  Created by spaceli on 03/08/2011.
//  Copyright 2011 diandian. All rights reserved.
//

#import "UIViewAdditions.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView(Frame)

- (void)setTop:(CGFloat)t
{
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b
{
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l
{
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r
{
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)w
{
    self.frame = CGRectMake(self.left, self.top, w, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h
{
    self.frame = CGRectMake(self.left, self.top, self.width, h);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
}


@end


@implementation UIView (ViewHiarachy)
- (UIViewController*)viewController {
	for (UIView* next = self; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView (Touch)
@implementation UIView (Touch)

- (void)addTapAction:(SEL)action target:(id)target {
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView (CustomStyle)

@implementation UIView (CustomStyle)

- (void)addRoundCorner:(float)radius {    
    [[self layer] setCornerRadius:radius];
}

- (void)addBorderWithColor:(UIColor *)color width:(float) width {
    [[self layer] setBorderWidth:width];
    [[self layer] setBorderColor:[color CGColor]];
}

- (void)addShadowWithOffset:(CGSize)offset radius:(float)radius color:(UIColor *)color  opacity:(float)opacity {
    [[self layer] setShadowOffset:offset];
    [[self layer] setShadowOpacity:opacity];
    [[self layer] setShadowRadius:radius];
    [[self layer] setShadowColor:color.CGColor];
    [[self layer] setMasksToBounds:NO];
}

- (void)addGradientFromColor:(UIColor *)beginColor toColor:(UIColor *)endColor horizontal:(BOOL)isHorizontal {
    CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)beginColor.CGColor,(id)endColor.CGColor, nil];
    [self.layer addSublayer:gradient];
}
- (void)addGradientWithColors:(NSArray *)cgColors locations:(NSArray *)locationNumbers startFrom:(CGPoint)startPoint endBy:(CGPoint)endPoint {
    CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = self.bounds;
	gradient.colors = cgColors;
    gradient.locations = locationNumbers;
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    [self.layer addSublayer:gradient];
}
@end


////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (getImage)

- (UIImage *)viewImage {
    UIGraphicsBeginImageContext(CGSizeMake(self.width, self.height)); 
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end


@implementation UIView (Walk)

- (void)BFSWalkSubviewWithBlock:(BOOL(^)(UIView *))block
{
    if (block) {
        for (UIView *view in self.subviews) {
            if (block(view)) {
                return;
            }
        }
        for (UIView *view in self.subviews) {
            [view BFSWalkSubviewWithBlock:block];
        }
    }
}

- (void)DFSWalkSubviewWithBlock:(BOOL(^)(UIView *))block
{
    if (block) {
        for (UIView *view in self.subviews) {
            if (block(view)) {
                return;
            }
            [view DFSWalkSubviewWithBlock:block];
        }
    }
}
- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (UIView *)findNearestSuperViewWithClass:(Class)superViewClass
{
    UIView *view = self.superview;
    while (view) {
        if ([view isKindOfClass:superViewClass]) {
            return view;
        }
        view = view.superview;
    }
    return nil;
}
@end


