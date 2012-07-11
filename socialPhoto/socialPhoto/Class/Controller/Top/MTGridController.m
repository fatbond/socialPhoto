//
//  MTPhotoByTagGridViewController.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTGridController.h"

#import "MTPhoto.h"
#import "MTFetcher.h"

@interface MTGridController () <MTFetcherDelegate, MTImageGridViewDatasource>


@end

@implementation MTGridController

@synthesize photos = _photos;
@synthesize currentPage = _currentPage;
@synthesize imageGridView = _imageGridView;



#pragma mark - Helper methods

- (void)displayConnectionErrorAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                  message:[NSString stringWithFormat:@"Unable to connect to network.\nCheck your network and try again!"]
                                                 delegate:self 
                                        cancelButtonTitle:@"Close" 
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)doneRefreshAndLoad {
  [self.imageGridView reloadData];
  
  self.imageGridView.isRefreshing = NO;
  self.imageGridView.isLoadingNextPage = NO;
}




#pragma mark - Setters/getters

- (MTImageGridView *)imageGridView {
  if (!_imageGridView) {
    _imageGridView = [[MTImageGridView alloc] initWithFrame:self.view.bounds];
    _imageGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _imageGridView.gridDataSource = self;
    _imageGridView.numberOfImagesPerRow = 4;
    _imageGridView.canRefresh = YES;
    _imageGridView.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                     green:234.0/255.0
                                                      blue:229.0/255.0
                                                     alpha:1.0];    
    _imageGridView.refreshHeaderView.layer.shadowOpacity = 0.5;
    _imageGridView.refreshHeaderView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
  }
  
  return _imageGridView;
}





#pragma mark - MTImageGridViewDatasource methods

- (NSURL *)imageURLAtIndex:(NSUInteger)index {
  MTPhoto *photo = [self.photos objectAtIndex:index];
  
  return photo.thumbURL;
}


- (NSUInteger)numberOfImagesInImageGridView:(MTImageGridView *)imageGridView {
  return self.photos.count;
}




#pragma mark - ViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
    [self.view addSubview:self.imageGridView];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return !(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
