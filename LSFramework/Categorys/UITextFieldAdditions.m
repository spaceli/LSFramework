//
//  UITextFieldAdditions.m
//  quanzizhangben
//
//  Created by 李帅 on 15/4/3.
//  Copyright (c) 2015年 quanzizhangben. All rights reserved.
//

#import "UITextFieldAdditions.h"

@implementation UITextField (Keyword)

- (void)setKeywords:(NSArray *)keywordsArray withFont:(UIFont *)keywordFont {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    for (NSString *keyword in keywordsArray) {
        [text addAttribute: NSFontAttributeName value:keywordFont range:[self.text rangeOfString:keyword]];
    }
    self.attributedText = text;
}
- (void)setKeywords:(NSArray *)keywordsArray withColor:(UIColor *)keywordColor {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    for (NSString *keyword in keywordsArray) {
        [text addAttribute: NSForegroundColorAttributeName value:keywordColor range:[self.text rangeOfString:keyword]];
    }
    self.attributedText = text;
}
- (void)setKeywords:(NSArray *)keywordsArray withBackgroundColor:(UIColor *)backgroundColor {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    for (NSString *keyword in keywordsArray) {
        [text addAttribute: NSBackgroundColorAttributeName value:backgroundColor range:[self.text rangeOfString:keyword]];
    }
    self.attributedText = text;
}

@end
