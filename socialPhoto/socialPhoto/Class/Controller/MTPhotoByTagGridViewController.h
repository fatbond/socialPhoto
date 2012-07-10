//
//  MTPhotoByTagGridViewController.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTImageGridView.h"

#define MAX_PAGE_ALLOWED    10

@interface MTPhotoByTagGridViewController : UIViewController

@property (strong, nonatomic) NSArray   *photos;    // of MeshtilesPhoto
@property (strong, nonatomic) MTImageGridView *imageGridView;
@property (assign, nonatomic) NSUInteger currentPage;   // count start from 1

- (void)doneRefreshAndLoad;

@end
