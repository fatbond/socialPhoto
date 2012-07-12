//
//  MTMeshViewController.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTSegmentsController.h"
#import "MTLoginController.h"

#define MAX_PAGE_ALLOWED  10

@interface MTTopController : UINavigationController

@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *segmentViewControllers;
@property (strong, nonatomic) MTSegmentsController *segmentsController;

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *photoTag;

@end
