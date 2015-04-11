//
//  UIWindowAddition.m
//  LSiPhone
//
//  Created by spaceli on 04/08/2011.
//  Copyright 2011 diandian. All rights reserved.
//

#import "UIWindowAddition.h"


@implementation UIWindow (Responder)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}


@end
