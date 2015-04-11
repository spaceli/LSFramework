//
//  ABMoreViewController.m
//  AccountBook
//
//  Created by spaceli on 13-11-2.
//  Copyright (c) 2013年 李帅. All rights reserved.
//

#import "ABMoreViewController.h"
#import "LSAppListController.h"

#import "LSLocalReminder.h"

@implementation ABMoreViewController

- (void)loadView {
    self.view = [[UIScrollView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多功能";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    if(IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    int y = 60;
    int gap = 25;
    UIButton *button = nil;
    
    button = [self produceButtonWithTitle:@"推荐APP"];
    [button addTarget:self action:@selector(seeOtherApps) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(SCREEN_WIDTH/2, y);
    y += button.height + gap;
    
    button = [self produceButtonWithTitle:@"到AppStore鼓励一下"];
    [button addTarget:self action:@selector(rate) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(SCREEN_WIDTH/2, y);
    y += button.height + gap;
    
    button = [self produceButtonWithTitle:@"在微博上联系作者"];
    [button addTarget:self action:@selector(seeAuthor) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(SCREEN_WIDTH/2, y);
    y += button.height + gap;
    
    
    
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 20)];
    copyRightLabel.text = [NSString stringWithFormat:@"%@ v%@",[UIDevice appDisplayName],[UIDevice clientVersion]];
    copyRightLabel.backgroundColor = [UIColor clearColor];
    copyRightLabel.textColor = [UIColor grayColor];
    copyRightLabel.font = Font(12);
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyRightLabel];
    
    y += 30;
    ((UIScrollView *)self.view).contentSize = CGSizeMake(SCREEN_WIDTH, y);

}


- (UIButton *)produceButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 260, 70);
    button.backgroundColor = RGBACOLOR(245, 245, 245, 0.8);
    button.titleColor = [UIColor orangeColor];
    button.title = title;
    button.titleLabel.font = Font(16);
    [self.view addSubview:button];
    
    return button;
}


- (void)seeAuthor {
    NSString *url = @"sinaweibo://userinfo?uid=1842042487";
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) {
        url = @"http://weibo.com/lishuaispace";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)rate {
    [LSLocalReminder goRate];
}
- (void)seeOtherApps {
    LSAppListController *controller = [[LSAppListController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
@end
