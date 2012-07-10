//
//  RefreshableTableView.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/7/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTRefreshableTableView.h"

#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface MTRefreshableTableView() <EGORefreshTableFooterDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation MTRefreshableTableView

@synthesize refreshFooterView = _refreshFooterView;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize isRefreshing      = _isRefreshing;
@synthesize isLoadingNextPage = _isLoadingNextPage;
@synthesize haveNextPage      = _haveNextPage;
@synthesize refreshDelegate   = _refreshDelegate;
@synthesize canRefresh        = _canRefresh;
@synthesize tableViewDelegate = _tableViewDelegate;

#pragma mark - Setters/getters

- (void)setCanRefresh:(BOOL)canRefresh {
  _canRefresh = canRefresh;
  
  if (_canRefresh == YES) {
    [self addSubview:self.refreshHeaderView];
  } else {
    [self.refreshHeaderView removeFromSuperview];
  }
}

- (void)setIsRefreshing:(BOOL)isRefreshing {
  if (isRefreshing == NO) {
    self.refreshFooterView.frame = CGRectMake(0.0f,
                                              MAX(self.contentSize.height, self.bounds.size.height),
                                              self.bounds.size.width,
                                              self.bounds.size.height);
    
    if (_isRefreshing != isRefreshing) {
      [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
  }
  
  _isRefreshing = isRefreshing;
}

- (void)setIsLoadingNextPage:(BOOL)isLoadingNextPage {
  if (isLoadingNextPage == NO) {        
    self.refreshFooterView.frame = CGRectMake(0.0f,
                                              MAX(self.contentSize.height, self.bounds.size.height),
                                              self.bounds.size.width,
                                              self.bounds.size.height);        
    
    if (_isLoadingNextPage != isLoadingNextPage) {
      [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
  }
  
  _isLoadingNextPage = isLoadingNextPage;
}


- (void)setHaveNextPage:(BOOL)haveNextPage {
  if (_haveNextPage != haveNextPage) {
    if (haveNextPage == YES) {
      [self addSubview:self.refreshFooterView];
    } else {
      [self.refreshFooterView removeFromSuperview];        // hide it if don't have next page to load
    }
  }
  
  _haveNextPage = haveNextPage;
}

- (EGORefreshTableHeaderView *)refreshHeaderView {
  if (!_refreshHeaderView) {
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                     0.0f - self.bounds.size.height, 
                                                                                     self.bounds.size.width,
                                                                                     self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
  }
  
  return _refreshHeaderView;
}

- (EGORefreshTableFooterView *)refreshFooterView {
  if (!_refreshFooterView) {
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                     MAX(self.contentSize.height, self.bounds.size.height),
                                                                                     self.bounds.size.width,
                                                                                     self.bounds.size.height)];
    _refreshFooterView.delegate = self;
  }
  
  return _refreshFooterView;
}





#pragma mark - TableView lifecycle


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      [self addSubview:self.refreshHeaderView];
      self.haveNextPage = NO;
      self.canRefresh = YES;
      self.delegate = (id <UITableViewDelegate>)self;
      self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
  
  if (!self.isLoadingNextPage && self.canRefresh) {  // allow refreshing only when not loading next page
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
  }
  
  if (!self.isRefreshing && self.haveNextPage) {      // allow load next page only when not refreshing & haveNextPage to load
    [self.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
  }
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  // same as in scrollViewDidScroll:
  
  
  if (!self.isLoadingNextPage && self.canRefresh) {
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
  }
  
  if (!self.isRefreshing && self.haveNextPage) {
    [self.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
  }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
  if (view == self.refreshHeaderView) {
    self.isRefreshing = [self.refreshDelegate refreshableTableViewWillRefreshData:self];
  }
  
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
  if (view == self.refreshHeaderView) {
    return self.isRefreshing; // should return if data source model is reloading
  }
  
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
  
	return [NSDate date]; // should return date data source was last changed
  
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view {
  self.isLoadingNextPage = [self.refreshDelegate refreshableTableViewWillLoadNextPage:self];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view {
  return self.isLoadingNextPage;
  
}

- (NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view {
  return [NSDate date];
}

@end
