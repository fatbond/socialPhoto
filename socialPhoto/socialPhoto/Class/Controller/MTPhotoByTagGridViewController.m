//
//  MTPhotoByTagGridViewController.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTPhotoByTagGridViewController.h"

#import "MeshtilesPhoto.h"
#import "MeshtilesFetcher.h"

@interface MTPhotoByTagGridViewController () <MeshtilesFetcherDelegate, MTImageGridViewDatasource, MTImageGridViewDelegate>


@end

@implementation MTPhotoByTagGridViewController

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
    _imageGridView.gridDelegate = self;
    _imageGridView.gridDataSource = self;
    _imageGridView.numberOfImagesPerRow = 4;
    _imageGridView.canRefresh = YES;
  }
  
  return _imageGridView;
}

#pragma mark - MTImageGridViewDelegate methods

- (void)imageTappedAtIndex:(NSUInteger)index {
  NSLog(@"Tapped at index %d", index);
  //  
  //  MeshtilesPhotoViewController *photoVC = [[MeshtilesPhotoViewController alloc] init];
  //  photoVC.photoId = [self photoAtIndex:index].photoId; 
  //  [self.navigationController pushViewController:photoVC animated:YES];
}

#pragma mark - MTImageGridViewDatasource methods

- (NSURL *)imageURLAtIndex:(NSUInteger)index {
  MeshtilesPhoto *photo = [self.photos objectAtIndex:index];
  
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
