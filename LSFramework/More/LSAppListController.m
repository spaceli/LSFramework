//
//  LSAppListController.m
//  AccountBook
//
//  Created by 李帅 on 15/3/28.
//  Copyright (c) 2015年 李帅. All rights reserved.
//

#import "LSAppListController.h"

#define API @"https://coding.net/u/lishuai/p/apptest/git/raw/master/applist.json"

@implementation LSAppListController {
    NSArray *_appList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐应用";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:API]];
        _appList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appList[indexPath.row][2]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LSAppTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setAppInfo:_appList[indexPath.row]];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end



@implementation LSAppTableViewCell

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH-90, 60)];
        _nameLabel.font = Font(14);
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}
- (void)setAppInfo:(NSArray *)info {
    self.iconView.image = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:info[1]]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconView.image = icon;
        });
    });
    self.nameLabel.text = info[0];
    
}

@end