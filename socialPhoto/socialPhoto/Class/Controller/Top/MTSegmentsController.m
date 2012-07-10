//
//  MTSegmentsController.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTSegmentsController.h"

@implementation MTSegmentsController

@synthesize viewControllers = _viewControllers;
@synthesize navigationController = _navigationController;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers {
  if (self = [super init]) {
    self.navigationController = aNavigationController;
    self.viewControllers = theViewControllers;
  }
  return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
  NSUInteger index = aSegmentedControl.selectedSegmentIndex;
  UIViewController * incomingViewController = [self.viewControllers objectAtIndex:index];
  
  NSArray * theViewControllers = [NSArray arrayWithObject:incomingViewController];
  [self.navigationController setViewControllers:theViewControllers animated:NO];
  
  incomingViewController.navigationItem.titleView = aSegmentedControl;
}

@end
