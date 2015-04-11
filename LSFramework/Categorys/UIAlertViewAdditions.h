//
//  UIAlertViewAdditions.h
//  LSCore
//
//  Created by spaceli on 13-8-4.
//  Copyright (c) 2013年 spaceli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (targetAddition) <UIAlertViewDelegate>

- (void)addTarget:(id)target action:(SEL)selector forTitle:(NSString *)title;

@end


#define UIAlertShow(s) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:s delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];[alert show];
#define UIAlertShowDetail(t,d) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:t message:d delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];[alert show];


typedef void (^UIAlertViewDismissBlock)(UIAlertView *alertView, int buttonIndex);
typedef void (^UIAlertViewCancelBlock)();

@interface UIAlertView (BlockAddition) <UIAlertViewDelegate>

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)titleArray
                              dismissed:(UIAlertViewDismissBlock)dismissBlock
                               canceled:(UIAlertViewCancelBlock)cancelBlock;

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                                  style:(UIAlertViewStyle)style
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)titleArray
                              dismissed:(UIAlertViewDismissBlock)dismissBlock
                               canceled:(UIAlertViewCancelBlock)cancelBlock;

@end