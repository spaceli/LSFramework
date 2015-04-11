//
//  DDList.h
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"


@interface DDList : UITableViewController {
	NSString		*_searchText;
	NSString		*_selectedText;
	NSArray         *_resultList;
}

@property (weak) id <PassValueDelegate> delegate;

- (void)updateRowsWith:(NSArray *)rows;

@end
