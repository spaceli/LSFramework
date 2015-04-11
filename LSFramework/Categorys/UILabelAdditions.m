//
//  UILabelAdditions.m
//  LSCore
//
//  Created by 李帅 on 12/31/13.
//  Copyright (c) 2013 spaceli.com. All rights reserved.
//

#import "UILabelAdditions.h"


@implementation UILabel (Keyword)

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