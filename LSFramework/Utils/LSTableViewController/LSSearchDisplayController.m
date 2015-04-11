//
//  MTSearchDisplayController.m
//  MTMessage
//
//  Created by 李帅 on 13-4-3.
//  Copyright (c) 2013年 meituan.com. All rights reserved.
//

#import "LSSearchDisplayController.h"

@implementation LSSearchDisplayController

- (id)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController {
    self = [super initWithSearchBar:searchBar contentsController:viewController];
    if (self) {
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
        self.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    }
    return self;
}

- (void)setSearchResultItems:(NSMutableArray *)searchResultItems {
    _searchResultItems = searchResultItems;
    [self.searchResultsTableView reloadData];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResultItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTableItem *item = item = [_searchResultItems objectAtIndex:indexPath.row];
    LSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellClassName];
    if (cell == nil) {
        cell = [[NSClassFromString(item.cellClassName) alloc] init];
    }
    [cell setItem:item];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTableItem *item = [_searchResultItems objectAtIndex:indexPath.row];
    return [item cellHeightWithWidth:tableView.width];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_controllerDelegate searchDisplayController:self didSelectCell:(LSTableCell *)[tableView cellForRowAtIndexPath:indexPath]];
}
@end
