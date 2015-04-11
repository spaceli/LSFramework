//
//  LSAppListController.h
//  AccountBook
//
//  Created by 李帅 on 15/3/28.
//  Copyright (c) 2015年 李帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSAppListController : UITableViewController


@end


@interface LSAppTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *nameLabel;

- (void)setAppInfo:(NSArray *)info;
@end