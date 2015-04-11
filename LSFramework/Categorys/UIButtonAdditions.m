//
//  UIButton+Utils.m
//  iMeituan
//
//  Created by jianjingbao on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButtonAdditions.h"

@implementation UIButton (property)

- (void)setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (NSString *)title {
    return self.currentTitle;
}
- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (UIColor *)titleColor {
    return self.currentTitleColor;
}
- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}
- (UIImage *)backgroundImage {
    return [self backgroundImageForState:UIControlStateNormal];
}
- (void)setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage {
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}
- (UIImage *)highlightedBackgroundImage {
    return [self backgroundImageForState:UIControlStateHighlighted];
}
- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
- (UIImage *)image {
    return [self imageForState:UIControlStateNormal];
}
@end
