//
//  LSTableViewController.h
//  iMeituanHD
//
//  Created by 李 帅 on 12-2-29.
//  Copyright (c) 2012年 meituan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LSTableViewController;
@protocol LSTableViewControllerDelegate <NSObject>

- (void)tableController:(LSTableViewController *)controller 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
           selectedItem:(id)item forCell:(UITableViewCell *)cell;

@end

typedef enum {
    LSScrollViewDirectionUp     = 0,    //0x000
    LSScrollViewDirectionDown   = 1,    //0x001
    LSScrollViewDirectionLeft   = 2,    //0x010
    LSScrollViewDirectionRight  = 4,    //0x100
}LSScrollViewDirection;

@interface LSTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    NSMutableArray *_items;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)UITableViewStyle tableStyle;

@property (nonatomic,strong)NSMutableArray *items;//不含section信息
@property (nonatomic,strong)NSArray *sections;//section的title数组，数量可以小于items的组数
@property (nonatomic,weak)id/*<LSTableViewControllerDelegate>*/ delegate;

@property (nonatomic,assign)BOOL dragUpToHideBars;
@property (nonatomic,assign)LSScrollViewDirection scrollDirection;

- (id)initWithStyle:(UITableViewStyle)tableStyle;

- (void)setBarsHiddend:(BOOL)hidden animated:(BOOL)animated;
@end




////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LSTableItem : NSObject {
    NSString *_cellClassName;
    int _cellHeight;
    __weak id  _target;
    SEL _selectAction;
}
@property (nonatomic,copy)NSString *cellClassName;
@property (nonatomic,weak)id target;
@property (nonatomic,assign)SEL selectAction;
@property (nonatomic,assign)int cellHeight;
- (void)setSelectAction:(SEL)selectAction target:(id)target;
- (int)cellHeightWithWidth:(int)width;
@end

@interface LSTableCell : UITableViewCell {
    LSTableItem *_item;
}
@property (nonatomic,strong)LSTableItem *item;
- (id)initWithStyle:(UITableViewCellStyle)style;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LSTableTitleItem : LSTableItem {
    NSString *_title;
}
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *textColor;
- (id)initWithTitle:(NSString *)title;
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title;
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title font:(UIFont *)font;
+ (LSTableTitleItem *)itemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor;
@end

@interface LSTableTitleCell : LSTableCell 
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LSTableControlItem : LSTableItem {
    NSString *_title;
    UIControl *_control;
}
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIControl *control;
- (id)initWithTitle:(NSString *)title control:(UIControl *)control;
@end

@interface LSTableControlCell : LSTableCell {
    
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LSTableDetailItem : LSTableItem 
@property (nonatomic,strong)UIImage *icon;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,strong)UIImage *accessIcon;
- (id)initWithTitle:(NSString *)title detail:(NSString *)detail;
- (id)initWithIcon:(UIImage *)icon title:(NSString *)title detail:(NSString *)detail accessIcon:(UIImage *)accessIcon;
@end

@interface LSTableDetailCell : LSTableCell 
@property (nonatomic,strong)UIImageView *accessView;
@end


////////////////////////////////////////////////////////////////////////////////////////////////////
//用于单选的cell group
@interface LSTableRadioItem : LSTableItem
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,copy)NSString *groupName;//default is subClass's className; groupName decides which cells are in a group.
@end

@interface LSTableRadioCell : LSTableCell
- (void)setRadioSelected:(BOOL)isSelected;
@end