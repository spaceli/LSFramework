//
//  UIAlertViewAdditions.m
//  LSCore
//
//  Created by spaceli on 13-8-4.
//  Copyright (c) 2013年 spaceli.com. All rights reserved.
//

#import "UIAlertViewAdditions.h"


static UIAlertViewDismissBlock _dismissBlock;
static UIAlertViewCancelBlock _cancelBlock;

static UIAlertViewDismissBlock _dismissBlock;
static UIAlertViewCancelBlock _cancelBlock;

@implementation UIAlertView (BlockAddition)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)titleArray
                              dismissed:(UIAlertViewDismissBlock)dismissBlock
                               canceled:(UIAlertViewCancelBlock)cancelBlock
{
    
    return [self showAlertViewWithTitle:title message:message style:UIAlertViewStyleDefault cancelButtonTitle:cancelButtonTitle otherButtonTitles:titleArray dismissed:dismissBlock canceled:cancelBlock];
}

+ (UIAlertView *)showAlertViewWithMessage:(NSString *)message
{
    return [self showAlertViewWithTitle:nil
                                message:message
                      cancelButtonTitle:@"知道了"
                      otherButtonTitles:nil
                              dismissed:NULL
                               canceled:NULL];
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                                  style:(UIAlertViewStyle)style
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)titleArray
                              dismissed:(UIAlertViewDismissBlock)dismissBlock
                               canceled:(UIAlertViewCancelBlock)cancelBlock
{
    _cancelBlock  = [cancelBlock copy];
    
    _dismissBlock  = [dismissBlock copy];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:[self self]
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    alertView.alertViewStyle = style;
    for (NSString *buttonTitle in titleArray) {
        [alertView addButtonWithTitle:buttonTitle];
    }
    
    [alertView show];
    return alertView;
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(int)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
        }
    } else {
        if (_dismissBlock) {
            _dismissBlock(alertView,buttonIndex); // cancel button is button -1
        }
    }
}

@end




@implementation UIAlertView (targetAddition)

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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [self buttonTitleAtIndex:buttonIndex];
    if (title) {
        NSInvocation* invo = [_actionPairs objectForKey:title];
        [invo invoke];
    }
}
@end




