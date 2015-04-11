//
//  UIButton+Utils.h
//  iMeituan
//
//  Created by jianjingbao on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (property)
@property (nonatomic,assign)NSString *title;
@property (nonatomic,assign)UIFont *titleFont;
@property (nonatomic,assign)UIColor *titleColor;

@property (nonatomic,assign)UIImage *backgroundImage;
@property (nonatomic,assign)UIImage *highlightedBackgroundImage;

@property (nonatomic,assign)UIImage *image;
@end
