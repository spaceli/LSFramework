//
//  UILabelAdditions.h
//  LSCore
//
//  Created by 李帅 on 12/31/13.
//  Copyright (c) 2013 spaceli.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UILabel (Keyword)

- (void)setKeywords:(NSArray *)keywordsArray withFont:(UIFont *)keywordFont;
- (void)setKeywords:(NSArray *)keywordsArray withColor:(UIColor *)keywordColor;
- (void)setKeywords:(NSArray *)keywordsArray withBackgroundColor:(UIColor *)backgroundColor;
@end