//
//  UIViewAdditions.h
//  LSiPhone
//
//  Created by spaceli on 03/08/2011.
//  Copyright 2011 diandian. All rights reserved.
//


@interface UIView(Frame)

/**
 * view.top
 */
@property (nonatomic, assign) CGFloat top;
/**
 * view.bottom
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 * view.left
 */
@property (nonatomic, assign) CGFloat left;
/**
 * view.right
 */
@property (nonatomic, assign) CGFloat right;
/**
 * view.width
 */
@property (nonatomic, assign) CGFloat width;
/**
 * view.height
 */
@property (nonatomic, assign) CGFloat height;
/**
 * view.center.x
 */
@property (nonatomic, assign) CGFloat centerX;
/**
 * view.center.y
 */
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;


@end

@interface UIView(ViewHiarachy)

@property (nonatomic,readonly)UIViewController *viewController;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView(Touch)

- (void)addTapAction:(SEL)action target:(id)target;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

//need add QuartzCore.framework
@interface UIView (CustomStyle)

- (void)addRoundCorner:(float)radius;
- (void)addBorderWithColor:(UIColor *)color width:(float) width;
- (void)addShadowWithOffset:(CGSize)offset radius:(float)radius color:(UIColor *)color  opacity:(float)opacity;

- (void)addGradientFromColor:(UIColor *)beginColor toColor:(UIColor *)endColor horizontal:(BOOL)isHorizontal;
- (void)addGradientWithColors:(NSArray *)cgColors locations:(NSArray *)locationNumbers startFrom:(CGPoint)startPoint endBy:(CGPoint)endPoint;
@end


////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (getImage) 

- (UIImage *)viewImage;

@end


@interface UIView (Walk) //遍历并执行操作
- (void)BFSWalkSubviewWithBlock:(BOOL(^)(UIView *))block;
- (void)DFSWalkSubviewWithBlock:(BOOL(^)(UIView *))block;

/**
 * 移除所有子视图。
 */
- (void)removeAllSubviews;
/**
 * 找到某个类的superview
 */
- (UIView *)findNearestSuperViewWithClass:(Class)superViewClass;
@end
