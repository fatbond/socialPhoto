//
//  MTMeshViewController.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTTopController.h"

#import "MTGridController.h"
#import "MTListViewController.h"
#import "MTMapController.h"
#import "MTTagSearchController.h"

#import "MTSearchButton.h"

#import "MTPhoto.h"
#import "MTPhotoDetail.h"
#import "MTFetcher.h"

@interface MTTopController () <MTMapControllerDelegate, MTFetcherDelegate, MTRefreshableTableViewDelegate, MTImageGridViewDelegate, MTTagSearchControllerDelegate>

@property (strong, nonatomic) MTGridController *gridViewController;
@property (strong, nonatomic) MTListViewController *listViewController;
@property (strong, nonatomic) MTMapController *mapViewController;
@property (strong, nonatomic) MTTagSearchController *tagSearchController;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *photosDetails;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) MTFetcher *meshtilesFetcher;

@property (strong, nonatomic) MTSearchButton *searchButton;

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl;
- (void)searchButtonTapped:(MTSearchButton *)searchButton;
- (void)refreshData;

@end

@implementation MTTopController

@synthesize segmentedControl = _segmentedControl;
@synthesize segmentsController = _segmentsController;
@synthesize segmentViewControllers = _segmentViewControllers;

@synthesize gridViewController = _gridViewController;
@synthesize listViewController = _listViewController;
@synthesize mapViewController = _mapViewController;
@synthesize tagSearchController = _tagSearchController;

@synthesize photos = _photos;
@synthesize photosDetails = _photosDetails;
@synthesize currentPage = _currentPage;
@synthesize meshtilesFetcher = _meshtilesFetcher;

@synthesize searchButton = _searchButton;

@synthesize userId = _userId;
@synthesize photoTag = _photoTag;

#pragma mark - Helper methods

- (void)resetSegmentedControl {
  [self.segmentedControl setImage:[UIImage imageNamed:@"header_tile_view.png"] forSegmentAtIndex:0];
  [self.segmentedControl setImage:[UIImage imageNamed:@"header_list_view.png"] forSegmentAtIndex:1];
  [self.segmentedControl setImage:[UIImage imageNamed:@"header_map_view.png"] forSegmentAtIndex:2];
}

- (void)displayConnectionErrorAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                  message:[NSString stringWithFormat:@"Unable to connect to network.\nCheck your network and try again!"]
                                                 delegate:self 
                                        cancelButtonTitle:@"Close" 
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)doneRefreshAndLoad {
  self.gridViewController.photos = self.photos;
  
  self.listViewController.photos = self.photos;
  self.listViewController.photosDetails = self.photosDetails;
  
  self.mapViewController.photos = self.photos;
  
  
  [self.gridViewController doneRefreshAndLoad];
  [self.listViewController doneRefreshAndLoad];
}

#pragma mark - Setters/getters

- (void)setPhotoTag:(NSString *)photoTag {
  _photoTag = photoTag;
  
  [self refreshData];
}

- (MTSearchButton *)searchButton {
  if (!_searchButton) {
    _searchButton = [[MTSearchButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 103)/2, (48-42)/2, 103.0, 40.0)];
    [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.searchTag = self.photoTag;
  }
  
  return _searchButton;
}

- (void)setPhotos:(NSArray *)photos {
  _photos = photos;
  
  if (_photos != nil && _photos.count > 0) {      // load detail only if the photos array have object in it
    
    // Download the detail of all photos
    NSMutableArray *photoIds = [[NSMutableArray alloc] init];
    for (MTPhoto *photo in _photos) {
      [photoIds addObject:photo.photoId];
    }
    
    [self.meshtilesFetcher getListPhotoDetailFromPhotoIds:photoIds andUserId:self.userId];
  } else {
    _photos = [[NSArray alloc] init];
    self.photosDetails = [[NSArray alloc] init];
    [self doneRefreshAndLoad];
  }
}

- (void)setCurrentPage:(NSUInteger)currentPage {
  _currentPage = currentPage;
  self.gridViewController.currentPage = _currentPage;
  self.listViewController.currentPage = _currentPage;
}

- (MTFetcher *)meshtilesFetcher {
  if (!_meshtilesFetcher) {
    _meshtilesFetcher = [[MTFetcher alloc] init];
    _meshtilesFetcher.delegate = self;
  }
  
  return _meshtilesFetcher;
}

- (MTTagSearchController *)tagSearchController {
  _tagSearchController = [[MTTagSearchController alloc] init];
  _tagSearchController.tagDelegate = self;
  
  return _tagSearchController;
}

- (MTGridController *)gridViewController {
  if (!_gridViewController) {
    _gridViewController = [[MTGridController alloc] init];
    _gridViewController.title = @"Grid";
    _gridViewController.imageGridView.refreshDelegate = self;
    _gridViewController.imageGridView.gridDelegate = self;
  }
  
  return _gridViewController;
}

- (MTListViewController *)listViewController {
  if (!_listViewController) {
    _listViewController = [[MTListViewController alloc] init];
    _listViewController.title = @"List";
    _listViewController.tableView.refreshDelegate = self;
  }
  
  return _listViewController;
}

- (MTMapController *)mapViewController {
  if (!_mapViewController) {
    _mapViewController = [[MTMapController alloc] init];
    _mapViewController.title = @"Map";
      _mapViewController.delegate = self;
  }
  
  return _mapViewController;
}

- (UISegmentedControl *)segmentedControl {
  if (!_segmentedControl) {
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:nil];
    [_segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"header_tile_view.png"] atIndex:0 animated:NO];
    [_segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"header_list_view.png"] atIndex:1 animated:NO];
    [_segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"header_map_view.png"] atIndex:2 animated:NO];
    _segmentedControl.frame = CGRectMake(0, 0, 216.0, 26.0);
    
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [_segmentedControl addTarget:self 
                          action:@selector(indexDidChangeForSegmentedControl:) 
                forControlEvents:UIControlEventValueChanged];
  }
  
  return _segmentedControl;
}

- (MTSegmentsController *)segmentsController {
  if (!_segmentsController) {
    _segmentsController = [[MTSegmentsController alloc] initWithNavigationController:self viewControllers:self.segmentViewControllers];
  }
  
  return _segmentsController;
}

- (NSArray *)segmentViewControllers {
  if (!_segmentViewControllers) {
    
    _segmentViewControllers = [NSArray arrayWithObjects:self.gridViewController, self.listViewController, self.mapViewController, nil];
  }
  
  return _segmentViewControllers;
}




#pragma mark - Target/Action

- (void)searchButtonTapped:(MTSearchButton *)searchButton {
  
  [self pushViewController:self.tagSearchController animated:YES];
  
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl {
  if (segmentedControl == self.segmentedControl) {
    
    // Display proper image for the segments
    [self resetSegmentedControl];
    switch(segmentedControl.selectedSegmentIndex) {
      case 0:
        [segmentedControl setImage:[UIImage imageNamed:@"header_tile_view_active.png"] forSegmentAtIndex:0];
        break;
      case 1:
        [segmentedControl setImage:[UIImage imageNamed:@"header_list_view_active.png"] forSegmentAtIndex:1];
        break;
      case 2:
        [segmentedControl setImage:[UIImage imageNamed:@"header_map_view_active.png"] forSegmentAtIndex:2];
        break;
    }
    
    // Insert the searchButton to proper viewController
    [((UIViewController *)[self.segmentViewControllers objectAtIndex:segmentedControl.selectedSegmentIndex]).view addSubview:self.searchButton];
    
    [self.segmentsController indexDidChangeForSegmentedControl:segmentedControl];
  }
}



#pragma mark - TagSearchControllerDelegate methods

- (void)didFinishedSearchingWithTag:(NSString *)photoTag {
  NSLog(@"Search for %@", photoTag);
  
  self.searchButton.searchTag = photoTag;
  self.photoTag = photoTag;
  
  self.segmentedControl.selectedSegmentIndex = 0;
  [self indexDidChangeForSegmentedControl:self.segmentedControl];
}

#pragma mark - MTImageGridViewDelegate methods

- (void)imageTappedAtIndex:(NSUInteger)index {
  [self.listViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
  self.segmentedControl.selectedSegmentIndex = 1;
  [self indexDidChangeForSegmentedControl:self.segmentedControl];
}

#pragma mark - MTMapControllerDelegate methods
- (void)imageTappedAtIndexMap:(NSUInteger)index
{
    [self.listViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.segmentedControl.selectedSegmentIndex = 1;
    [self indexDidChangeForSegmentedControl:self.segmentedControl];
}


#pragma mark - Data loading

- (void)refreshData {
  self.photos = nil;
  self.gridViewController.imageGridView.haveNextPage = NO;
  self.listViewController.tableView.haveNextPage = NO;
  
  self.currentPage = 0;
  [self.meshtilesFetcher getListUserPhotoByTags:self.photoTag 
                                      andUserId:self.userId 
                                    atPageIndex:self.currentPage+1];
}

- (void)loadNextPage {
  [self.meshtilesFetcher getListUserPhotoByTags:self.photoTag 
                                      andUserId:self.userId 
                                    atPageIndex:self.currentPage+1];
}




#pragma mark - MeshtilesFetcherDelegate methods

- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetListUserPhoto:(NSArray *)photos {
  if (fetcher == self.meshtilesFetcher) {
    // merge the before photo array with the newly fetched array
    
    NSMutableArray *mergePhotos = [[NSMutableArray alloc] init];
    [mergePhotos addObjectsFromArray:self.photos];
    [mergePhotos addObjectsFromArray:photos];
    
    self.photos = mergePhotos;
    
    if (photos.count > 0) {
      self.currentPage++;
      
      if (self.currentPage < MAX_PAGE_ALLOWED) {
        self.gridViewController.imageGridView.haveNextPage = YES;
        self.listViewController.tableView.haveNextPage = YES;
      }
    } else {
      self.gridViewController.imageGridView.haveNextPage = NO;
      self.listViewController.tableView.haveNextPage = NO;
    }
  }
}

- (void)meshtilesFetcherDidFailedGetListUserPhoto:(MTFetcher *)fetcher {
  if (fetcher == self.meshtilesFetcher) {
    [self displayConnectionErrorAlert];
    
    [self doneRefreshAndLoad];
  }
}

- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetListPhotoDetailFromPhotoIds:(NSArray *)photosDetails {
  if (fetcher == self.meshtilesFetcher) {
    self.photosDetails = photosDetails;
    
    [self doneRefreshAndLoad];
  }
}

- (void)meshtilesFetcherDidFailedGetListPhotoDetailFromPhotoIds:(MTFetcher *)fetcher {
  if (fetcher == self.meshtilesFetcher) {
    [self displayConnectionErrorAlert];
  }
}



#pragma mark - RefreshableTableViewDelegate

- (BOOL)refreshableTableViewWillRefreshData:(MTRefreshableTableView *)tableView {
  
  [self refreshData];
  
  
  return YES;
}

- (BOOL)refreshableTableViewWillLoadNextPage:(MTRefreshableTableView *)tableView {
  
  [self loadNextPage];
  
  
  return YES;
}



#pragma mark - ViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    
    // Using predefined data for now
    self.userId = MeshtilesUserId;
    self.photoTag = @"Cat";
      
    // Set default userID and taf
    self.userId = [MTLoginController getUserID];
    self.photoTag = @"Sexy";
    
    // Setting the navigation bar color
    self.navigationBar.barStyle = UIBarStyleBlack;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  self.segmentedControl.selectedSegmentIndex = 0;
  [self indexDidChangeForSegmentedControl:self.segmentedControl];
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
