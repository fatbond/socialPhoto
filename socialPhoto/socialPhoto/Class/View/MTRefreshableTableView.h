//
//  RefreshableTableView.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/7/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"


@protocol MTRefreshableTableViewDelegate;

@interface MTRefreshableTableView : UITableView

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingNextPage;
@property (nonatomic, assign) BOOL haveNextPage;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, assign) id <MTRefreshableTableViewDelegate> refreshDelegate;
@property (nonatomic, assign) id <UITableViewDelegate> tableViewDelegate;

@property (strong, nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

@end

@protocol MTRefreshableTableViewDelegate

- (BOOL)refreshableTableViewWillRefreshData:(MTRefreshableTableView *)tableView;        // must set isRefreshing back to NO when finished
- (BOOL)refreshableTableViewWillLoadNextPage:(MTRefreshableTableView *)tableView;       // must set isLoadingNextPage back to NO when finished   

@end