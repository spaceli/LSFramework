//
//  LSDragRefreshTableViewController.m
//  iMeituan
//
//  Created by 李 帅 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LSDragRefreshTableViewController.h"

#define kLoadingMoreGap 30

@implementation LSDragRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshHeaderView = [[LSRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, 
                                                                                    self.tableView.bounds.size.width, 
                                                                                    self.tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_refreshHeaderView setState:LSRefreshStateNormal];
    [self.tableView addSubview:_refreshHeaderView];
    
}
- (void)viewDidUnload {
    self.refreshHeaderView = nil;
    [super viewDidUnload];
}

- (void)setRefreshDate:(NSDate *)refreshDate {
    _refreshDate = refreshDate;
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)doDragRefresh {
    // move to top
    if (_isLoading ) {
        return;
    }
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    [_refreshHeaderView setState:LSRefreshStateLoading];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentOffset = CGPointMake(0, -60);
    }];
    _isLoading = YES;
    [self loadDataSource:LSTableReloadTypeRefresh];
    
}
- (void)loadDataSourceDone {//这个方法需要在请求完成后调用
	_isLoading = NO;
    [_refreshHeaderView refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark Subclass rewrite

- (void)loadDataSource:(LSTableReloadType)reloadType {
	
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[super scrollViewDidScroll:scrollView];
	[_refreshHeaderView refreshScrollViewDidScroll:scrollView];
    if (_dragUpToLoadMore) {
        if (scrollView.isDragging && scrollView.contentOffset.y+scrollView.height >= scrollView.contentSize.height+kLoadingMoreGap && !_isLoading) {//加载更多方式的展示
            LSTableMoreItem *item = [self.items lastObject];
            if ([item isKindOfClass:[LSTableMoreItem class]]) {
                LSTableMoreCell *moreCell = (LSTableMoreCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]];
                moreCell.moreTextLabel.text = @"松开加载更多";
            }
        }else if (scrollView.contentOffset.y+scrollView.height < scrollView.contentSize.height+kLoadingMoreGap) {
            LSTableMoreItem *item = [self.items lastObject];
            if ([item isKindOfClass:[LSTableMoreItem class]]) {
                LSTableMoreCell *moreCell = (LSTableMoreCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]];
                if (moreCell.loading == NO) {
                    moreCell.moreTextLabel.text = @"上拉加载更多";
                }
                
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[_refreshHeaderView refreshScrollViewDidEndDragging:scrollView];
    if (_dragUpToLoadMore) {
        if (scrollView.contentOffset.y+scrollView.height > scrollView.contentSize.height+kLoadingMoreGap && !_isLoading) {//实现上拉加载更多
            LSTableMoreItem *item = [self.items lastObject];
            if ([item isKindOfClass:[LSTableMoreItem class]]) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count-1 inSection:0]];
                LSTableMoreCell *moreCell = (LSTableMoreCell *)cell;
                if (moreCell.loading == NO) {
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{//隔两秒后再检查
                        [self loadDataSource:LSTableReloadTypeMore];
                    });
                }
                moreCell.loading = YES;
            }
        }
    }
}

#pragma mark - LSRefreshTableHeaderDelegate

- (void)tableHeaderDidTriggerRefresh:(LSRefreshTableHeaderView *)view {
    _isLoading = YES;
	[self loadDataSource:LSTableReloadTypeRefresh];
}

- (BOOL)tableHeaderDataSourceIsLoading:(LSRefreshTableHeaderView *)view {
	return _isLoading;
}

- (NSDate *)tableHeaderDataSourceLastUpdated:(LSRefreshTableHeaderView *)view {
    return _refreshDate;
}

@end



////////////////////////////////////////////////////////////////////////////////////////////////////

#define FLIP_ANIMATION_DURATION 0.18f

@implementation LSRefreshTableHeaderView

@synthesize delegate=_delegate;

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 28.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(30.0f, frame.size.height - 60.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"ic_pull_up.png"].CGImage;
		layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(35.0f, frame.size.height - 44.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:LSRefreshStateNormal];
		
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(tableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate tableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"上午"];
		[formatter setPMSymbol:@"下午"];
		//[formatter setDateFormat:@"MM/dd/yyyy a hh:mm"];
        [formatter setDateFormat:@"yyyy年MM月dd日 a hh:mm"];
        if ([date timeIntervalSince1970] <= 10.0f) {
            _lastUpdatedLabel.text = nil;
        }else {
            _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新: %@", [formatter stringFromDate:date]];
        }
	}else {
		_lastUpdatedLabel.text = nil;	
	}
    
}

- (void)setState:(LSRefreshState)aState{
	
	switch (aState) {
		case LSRefreshStatePulling:
			
			_statusLabel.text = NSLocalizedString(@"松开即可刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			break;
		case LSRefreshStateNormal:
			
			if (_state == LSRefreshStatePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"下拉即可刷新...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case LSRefreshStateLoading:
			
			_statusLabel.text = NSLocalizedString(@"刷新中...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == LSRefreshStateLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(tableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate tableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == LSRefreshStatePulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:LSRefreshStateNormal];
		} else if (_state == LSRefreshStateNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:LSRefreshStatePulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(tableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate tableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
		[self setState:LSRefreshStateLoading];
        
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        }];
        if ([_delegate respondsToSelector:@selector(tableHeaderDidTriggerRefresh:)]) {
			[_delegate tableHeaderDidTriggerRefresh:self];
		}
	}	
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
    [UIView animateWithDuration:0.2 animations:^{
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    }];
    
	[self setState:LSRefreshStateNormal];
    
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LSTableMoreItem

@synthesize moreText = _moreText;
- (id)initWithText:(NSString *)moreText {
    self = [super init];
    if (self) {
        self.moreText = moreText;
    }
    return self;
}
@end

@implementation LSTableMoreCell

@synthesize moreTextLabel = _moreTextLabel;
@synthesize loading = _loading;
@synthesize activeView = _activeView;


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        UIView *blueView = [[UIView alloc] init];
        blueView.backgroundColor = RGBCOLOR(65, 158, 198);
        self.backgroundView = blueView;
    }else {
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableCellBack.png"]];
    }
}

- (void)setItem:(LSTableMoreItem *)item {
    super.item = item;
    if (item.moreText) {
        self.moreTextLabel.text = item.moreText;
    }else {
        self.moreTextLabel.text = @"点击加载更多";
    }
    self.loading = NO;
}
- (void)setLoading:(BOOL)loading {
    _loading = loading;
    if (_loading) {
        [self addSubview:self.activeView];
        [_activeView startAnimating];
        
        _moreTextLabel.text = @"加载中...";
    }else {
        [_activeView removeFromSuperview];
        self.activeView = nil;
    }
}
- (UILabel *)moreTextLabel {
    if (_moreTextLabel == nil) {
        _moreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, self.item.cellHeight)];
        _moreTextLabel.font = Font(13);
        _moreTextLabel.textAlignment = NSTextAlignmentCenter;
        _moreTextLabel.backgroundColor = [UIColor clearColor];
        _moreTextLabel.numberOfLines = 0;
        _moreTextLabel.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:_moreTextLabel];
    }
    return _moreTextLabel;
}
- (UIActivityIndicatorView *)activeView {
    if (_activeView == nil) {
        _activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activeView.frame = CGRectMake(10, (self.height-15)/2, 15, 15);
    }
    return _activeView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _moreTextLabel.frame = CGRectMake(0, 0, 320, self.item.cellHeight);
    _activeView.frame = CGRectMake(10, (self.height-15)/2, 15, 15);
}
@end


////////////////////////////////////////////////////////////////////////////////////////////////////
//cell for empty table

@implementation LSEmptyTableItem

+ (LSEmptyTableItem *)itemWithTitle:(NSString *)title {
    LSEmptyTableItem *item = [[LSEmptyTableItem alloc] initWithTitle:title];
    item.cellHeight = 460-44-49-45;
    return item;
}

@end

@implementation LSEmptyTableCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
