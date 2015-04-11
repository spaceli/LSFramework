//
//  UIWindowAddition.h
//  LSiPhone
//
//  Created by spaceli on 04/08/2011.
//  Copyright 2011 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIWindow (Responder)

/**
 * Searches the view hierarchy recursively for the first responder, starting with this window.
 */
- (UIView*)findFirstResponder;

/**
 * Searches the view hierarchy recursively for the first responder, starting with topView.
 */
- (UIView*)findFirstResponderInView:(UIView*)topView;

@end
