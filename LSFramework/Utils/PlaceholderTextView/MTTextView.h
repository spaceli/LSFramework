//
//  UIPlaceHolderTextView.h
//  iMeituan
//
//  Created by lin yu on 11-12-7.
//  Copyright (c) 2011年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
    int _movedPix;
}

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;
- (void)designatePlaceholder:(NSString *)string;

@end
