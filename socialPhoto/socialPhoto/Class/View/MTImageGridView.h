//
//  MTImageGridView.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTRefreshableTableView.h"

@protocol MTImageGridViewDelegate;
@protocol MTImageGridViewDatasource;

@interface MTImageGridView : MTRefreshableTableView

@property (unsafe_unretained, nonatomic) id <MTImageGridViewDelegate> gridDelegate;
@property (unsafe_unretained, nonatomic) id <MTImageGridViewDatasource> gridDataSource;

@property (assign, nonatomic) NSUInteger numberOfImagesPerRow;

@end


@protocol MTImageGridViewDelegate

- (void)imageTappedAtIndex:(NSUInteger)index;

@optional
- (void)didFailedLoadingImageAtIndex:(NSUInteger)index;


@end




@protocol MTImageGridViewDatasource

- (NSUInteger)numberOfImagesInImageGridView:(MTImageGridView *)imageGridView;
- (NSURL *)imageURLAtIndex:(NSUInteger)index;

@end