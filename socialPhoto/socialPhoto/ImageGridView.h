//
//  GridView.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageGridViewDelegate;
@protocol ImageGridViewDataSource;

@interface ImageGridView : UIView

@property (unsafe_unretained, nonatomic) id delegate;
@property (unsafe_unretained, nonatomic) id dataSource;

@property (assign, nonatomic) NSUInteger numberOfImagesPerRow;

@end

@protocol ImageGridViewDelegate

- (void)imageTappedAtIndex:(NSUInteger)index;

@optional
- (void)didFailedLoadingImageAtIndex:(NSUInteger)index;

@end


@protocol ImageGridViewDataSource

- (NSInteger)numberOfImagesInImageGridView:(ImageGridView *)imageGridView;
- (UIView *)imageGridView:(ImageGridView *)imageGridView viewForGridAtIndex:(NSUInteger)index;
- (NSURL *)imageURLAtIndex:(NSUInteger)index;


@end