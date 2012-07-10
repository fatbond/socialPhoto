//
//  MTSegmentsController.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSegmentsController : NSObject

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UINavigationController *navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)viewControllers;

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl;


@end
