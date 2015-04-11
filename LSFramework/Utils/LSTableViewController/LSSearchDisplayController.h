//
//  MTSearchDisplayController.h
//  MTMessage
//
//  Created by 李帅 on 13-4-3.
//  Copyright (c) 2013年 meituan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSTableViewController.h"
@protocol LSSearchDisplayControllerDelegate;

@interface LSSearchDisplayController : UISearchDisplayController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *searchResultItems;
@property (nonatomic,weak)id<LSSearchDisplayControllerDelegate> controllerDelegate;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol LSSearchDisplayControllerDelegate <NSObject>

@required
- (void)searchDisplayController:(LSSearchDisplayController *)controller didSelectCell:(LSTableCell *)cell;
@end