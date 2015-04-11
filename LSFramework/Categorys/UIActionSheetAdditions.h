//
//  UIActionSheetAdditions.h
//  AccountBook
//
//  Created by 李帅 on 15/4/6.
//  Copyright (c) 2015年 李帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIActionSheet (LSCore) <UIActionSheetDelegate>

- (void)addTarget:(id)target action:(SEL)selector forTitle:(NSString *)title;

@end
