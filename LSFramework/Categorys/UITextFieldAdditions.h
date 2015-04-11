//
//  UITextFieldAdditions.h
//  quanzizhangben
//
//  Created by 李帅 on 15/4/3.
//  Copyright (c) 2015年 quanzizhangben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField (Keyword)

- (void)setKeywords:(NSArray *)keywordsArray withFont:(UIFont *)keywordFont;
- (void)setKeywords:(NSArray *)keywordsArray withColor:(UIColor *)keywordColor;
- (void)setKeywords:(NSArray *)keywordsArray withBackgroundColor:(UIColor *)backgroundColor;

@end
