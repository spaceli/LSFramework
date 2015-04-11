//
//  UIViewControllerAdditions.m
//  SpaceCatalog
//
//  Created by 李 帅 on 12-5-21.
//  Copyright (c) 2012年 lishuai.com. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (navigation)

- (UINavigationController *)defaultNavigationController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self;
    }else if (self.navigationController) {
        return self.navigationController;
    }
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
    return navController;
}

- (UIViewController*)preViewController{
    
    //通过parentViewController来判断
    if (self.parentViewController) {
        //push 页面
        if (self.navigationController) {
            NSUInteger nowIndex = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
            if (nowIndex  >= 1) {
                return [self.navigationController.viewControllers objectAtIndex:nowIndex -1];
            }
        }
        
        return nil;
    }else{
        //present的页面
        //return self.presentingViewController;
        //present出来的页面暂时无法访问上一个页面，暂不处理
    }
    
    return nil;
}

@end
