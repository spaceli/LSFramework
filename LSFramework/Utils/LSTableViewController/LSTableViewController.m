//
//  LSTableViewController.m
//  iMeituanHD
//
//  Created by 李 帅 on 12-2-29.
//  Copyright (c) 2012年 meituan. All rights reserved.
//

#import "LSTableViewController.h"

@implementation LSTableViewController

- (id)initWithStyle:(UITableViewStyle)tableStyle {
    self = [super init];
    self.tableStyle = tableStyle;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableStyle];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sections) {
        return _items.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sections) {
        NSArray *aSection = [_items objectAtIndex:section];
        return aSection.count;
    }
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTableItem *item = nil;
    if (_sections) {
        item = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        item = [_items objectAtIndex:indexPath.row];
    }
    LSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellClassName];
    if (cell == nil) {
        cell = [[NSClassFromString(item.cellClassName) alloc] init];
    }
    [cell setItem:item];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count > section) {
        return [_sections objectAtIndex:section];
    }
    return nil;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSTableItem *item = nil;
    if (_sections) {
        item = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        item = [_items objectAtIndex:indexPath.row];
    }
    return [item cellHeightWithWidth:tableView.width];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LSTableItem *item = nil;
    if (_sections) {
        item = [[_items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        item = [_items objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (item.target && item.selectAction && [item.target respondsToSelector:item.selectAction]) {
        [item.target performSelector:item.selectAction withObject:item];
    }else if (_delegate && [_delegate respondsToSelector:@selector(tableController:didSelectRowAtIndexPath:selectedItem:forCell:)]) {
        [_delegate tableController:self didSelectRowAtIndexPath:indexPath selectedItem:item forCell:selectedCell];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static int lastContentOffsetY;
    if (scrollView.contentOffset.y > lastContentOffsetY) {
        _scrollDirection = LSScrollViewDirectionDown;
    }else if (scrollView.contentOffset.y < lastContentOffsetY) {
        _scrollDirection = LSScrollViewDirectionUp;
    }
    lastContentOffsetY = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_dragUpToHideBars) {
        if (_scrollDirection == LSScrollViewDirectionUp) {
            [self setBarsHiddend:NO animated:YES];
        }else if (_scrollDirection == LSScrollViewDirectionDown) {
            [self setBarsHiddend:YES animated:YES];
        }
    }
}
- (void)setBarsHiddend:(BOOL)hidden animated:(BOOL)animated {
//    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
    [UIApplication sharedApplication].statusBarHidden = hidden;
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
//    [self.tabBarController setTabBarHidden:hidden animated:animated];
}
@end




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSTableItem

- (id)init {
    self = [super init];
    if (self) {
        _cellHeight = 44;
    }
    return self;
}
- (void)setSelectAction:(SEL)selectAction target:(id)target {
    _target = target;
    _selectAction = selectAction;
}
- (int)cellHeightWithWidth:(int)width {
    return _cellHeight;
}
- (NSString *)cellClassName {
    if (_cellClassName == nil) {
        _cellClassName = [[[[self class] description] stringByReplacingOccurrencesOfString:@"Item" withString:@"Cell"] copy];
    }
    return _cellClassName;
}
@end

@implementation LSTableCell

- (id)initWithStyle:(UITableViewCellStyle)style {
    self = [super initWithStyle:style reuseIdentifier:[[self class] description]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (id)init {
    return [self initWithStyle:UITableViewCellStyleDefault];
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSTableTitleItem

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    
    return self;
}
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title font:Font(14)];
}
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title font:(UIFont *)font {
    LSTableTitleItem *item = [[self alloc] initWithTitle:title];
    item.font = font;
    return item;
}
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    LSTableTitleItem *item = [LSTableTitleItem itemWithTitle:title font:font];
    item.textColor = textColor;
    return item;
}
@end

@implementation LSTableTitleCell

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault];
    return self;
}
- (void)setItem:(LSTableItem *)item {
    super.item = item;
    self.textLabel.text = ((LSTableTitleItem *)item).title;
    self.textLabel.font = ((LSTableTitleItem *)item).font;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSTableControlItem

- (id)initWithTitle:(NSString *)title control:(UIControl *)control {
    self = [super init];
    if (self) {
        _title = [title copy];
        _control = control;
    }
    return self;
}

@end

@implementation LSTableControlCell

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault];
    return self;
}
- (void)setItem:(LSTableItem *)item {
    super.item = item;
    LSTableControlItem *controlItem = (LSTableControlItem *)item;
    self.textLabel.text = controlItem.title;
    if ([self viewWithTag:100]) {
        [[self viewWithTag:100] removeFromSuperview];
    } 
    controlItem.control.tag = 100;
    [self addSubview:controlItem.control];
    self.textLabel.font = BoldFont(16);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *control = [self viewWithTag:100];
    control.right = self.width-40;
    control.top = 10;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSTableDetailItem

- (id)initWithTitle:(NSString *)title detail:(NSString *)detail {
    return [self initWithIcon:nil title:title detail:detail accessIcon:nil];
}
- (id)initWithIcon:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail accessIcon:(UIImage *)accessIcon {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.detail = detail;
        self.accessIcon = accessIcon;
    }
    return self;
}

@end

@implementation LSTableDetailCell
@synthesize accessView = _accessView;
- (id)init {
    return [super initWithStyle:UITableViewCellStyleValue1];
}
- (void)setItem:(LSTableItem *)item {
    super.item = item;
    LSTableDetailItem *detailItem = (LSTableDetailItem *)item;

    self.imageView.image = detailItem.icon;
    self.textLabel.text = detailItem.title;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.text = detailItem.detail;
    if (detailItem.accessIcon) {
        self.accessView.image = detailItem.accessIcon;
        self.accessView.bounds = CGRectMake(0, 0, detailItem.accessIcon.size.width, detailItem.accessIcon.size.height);
        self.accessView.center = CGPointMake(320-20, item.cellHeight/2);
        self.detailTextLabel.right = self.accessView.left-2;
    }
}
- (UIImageView *)accessView {
    if (_accessView == nil) {
        _accessView = [[UIImageView alloc] init];
        [self addSubview:_accessView];
    }
    return _accessView;
}
@end

