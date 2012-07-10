//
//  RefreshableTableView.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/7/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RefreshableTableViewDelegate;

@interface RefreshableTableView : UITableView

@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingNextPage;
@property (nonatomic, assign) BOOL haveNextPage;
@property (nonatomic, assign) BOOL canRefresh;
@property (nonatomic, assign) id <RefreshableTableViewDelegate> refreshDelegate;
@property (nonatomic, assign) id <UITableViewDelegate> tableViewDelegate;

@end

@protocol RefreshableTableViewDelegate

- (BOOL)refreshableTableViewWillRefreshData:(RefreshableTableView *)tableView;        // must set isRefreshing back to NO when finished
- (BOOL)refreshableTableViewWillLoadNextPage:(RefreshableTableView *)tableView;       // must set isLoadingNextPage back to NO when finished   

@end