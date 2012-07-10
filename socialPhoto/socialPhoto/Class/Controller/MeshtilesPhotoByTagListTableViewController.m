//
//  MeshtilesPhotoByTagListTableViewController.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/7/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MeshtilesPhotoByTagListTableViewController.h"

#import "MeshtilesPhotoCell.h"
#import "MeshtilesPhoto.h"
#import "MeshtilesPhotoDetail.h"

@interface MeshtilesPhotoByTagListTableViewController () <UITableViewDataSource, UITableViewDelegate>


@end

@implementation MeshtilesPhotoByTagListTableViewController

@synthesize tableView         = _tableView;
@synthesize photos            = _photos;
@synthesize photosDetails     = _photosDetails;
@synthesize currentPage       = _currentPage;



#pragma mark - Helper methods

- (void)doneRefreshAndLoad {
  [self.tableView reloadData];
  
  self.tableView.isRefreshing       = NO;
  self.tableView.isLoadingNextPage  = NO;
}

- (void)displayConnectionErrorAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                  message:[NSString stringWithFormat:@"Unable to connect to network.\nCheck your network and try again!"]
                                                 delegate:self 
                                        cancelButtonTitle:@"Close" 
                                        otherButtonTitles:nil];
  [alert show];
}



#pragma mark - Setters/getters

- (RefreshableTableView *)tableView {
  if (!_tableView) {
    _tableView = [[RefreshableTableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource       = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.tableViewDelegate = self;
    _tableView.canRefresh = YES;
  }
  
  return _tableView;
}




#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return self.photosDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MeshtilesPhotoCell";
  MeshtilesPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!cell) {
    cell = [[MeshtilesPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  
  
  cell.photo = [self.photosDetails objectAtIndex:indexPath.row];
  
  return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [MeshtilesPhotoCell cellHeightForFrameWidth:tableView.bounds.size.width andPhoto:[self.photosDetails objectAtIndex:indexPath.row]];
}





#pragma mark - ViewController lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      [self.view addSubview:self.tableView];
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
