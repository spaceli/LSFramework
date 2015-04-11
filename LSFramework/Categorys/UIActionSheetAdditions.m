//
//  UIActionSheetAdditions.m
//  AccountBook
//
//  Created by 李帅 on 15/4/6.
//  Copyright (c) 2015年 李帅. All rights reserved.
//

#import "UIActionSheetAdditions.h"

@implementation UIActionSheet (LSCore)

static NSMutableDictionary *_actionPairs = nil;

- (void)addTarget:(id)target action:(SEL)selector forTitle:(NSString *)title {
    if (_actionPairs == nil) {
        _actionPairs = [[NSMutableDictionary alloc] init];
    }
    
    self.delegate = self;
    NSMethodSignature *sig = [target methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:target];
        [invo setSelector:selector];
        if (sig.numberOfArguments > 2) {
            [invo setArgument:&title atIndex:2];
        }
        [_actionPairs setObject:invo forKey:title];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [self buttonTitleAtIndex:buttonIndex];
    NSInvocation* invo = [_actionPairs objectForKey:title];
    [invo invoke];
}



@end
