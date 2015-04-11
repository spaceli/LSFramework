//
//  LSDragRefreshTableViewController.h
//  iMeituan
//
//  Created by 李 帅 on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@class LSRefreshTableHeaderView;
@protocol LSRefreshTableHeaderDelegate
- (void)tableHeaderDidTriggerRefresh:(LSRefreshTableHeaderView*)view;
- (BOOL)tableHeaderDataSourceIsLoading:(LSRefreshTableHeaderView*)view;
@optional
- (NSDate*)tableHeaderDataSourceLastUpdated:(LSRefreshTableHeaderView*)view;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
typedef enum {
    LSTableReloadTypeRefresh,//从网络获取,刷新
    LSTableReloadTypeMore,//加载更多，不刷新
    LSTableReloadTypeReload,//重载
}LSTableReloadType;

@interface LSDragRefreshTableViewController : LSTableViewController <LSRefreshTableHeaderDelegate> {
    BOOL _isLoading;
    BOOL _dragUpToLoadMore;
}
@property (nonatomic,strong)LSRefreshTableHeaderView *refreshHeaderView;
@property (nonatomic,strong)NSDate *refreshDate;//headerView上的更新时间，设置时会自动触发header更新

@property (nonatomic,assign)BOOL dragUpToLoadMore;//是否支持上拉加载更多，需要在items的最后加上LSTableMoreItem

- (void)doDragRefresh;//直接调用
- (void)loadDataSourceDone;//子类在数据加载完成后，直接调用

- (void)loadDataSource:(LSTableReloadType)reloadType;//子类复写，重新调用网络请求的方法

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    LSRefreshStatePulling = 0,
	LSRefreshStateNormal,
	LSRefreshStateLoading,	
}LSRefreshState;

@interface LSRefreshTableHeaderView : UIView {
	
	id __unsafe_unretained _delegate;
	LSRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView; 
}

@property(nonatomic,unsafe_unretained) id <LSRefreshTableHeaderDelegate> delegate;

- (void)setState:(LSRefreshState)aState;
- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
//加载更多的cell
@interface LSTableMoreItem : LSTableItem
@property (nonatomic,copy)NSString *moreText;
- (id)initWithText:(NSString *)moreText;
@end

@interface LSTableMoreCell : LSTableCell
@property (nonatomic,strong)UILabel *moreTextLabel;
@property (nonatomic,assign)BOOL loading;
@property (nonatomic,strong)UIActivityIndicatorView *activeView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
//cell for empty table
@interface LSEmptyTableItem : LSTableTitleItem
+ (LSEmptyTableItem *)itemWithTitle:(NSString *)title;
@end

@interface LSEmptyTableCell : LSTableTitleCell

@end
