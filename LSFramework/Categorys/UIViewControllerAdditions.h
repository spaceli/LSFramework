//
//  UIViewControllerAdditions.h
//  SpaceCatalog
//
//  Created by 李 帅 on 12-5-21.
//  Copyright (c) 2012年 lishuai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (navigation)

- (UINavigationController *)defaultNavigationController;

- (UIViewController*)preViewController;

@end
