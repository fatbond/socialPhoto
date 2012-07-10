//
//  MTImageGridView.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/10/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTImageGridView.h"

#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"

#define CELL_RATIO    18.75

@interface MTImageGridView() <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) double imagesSpace;
@property (assign, nonatomic) double imageSize;
@property (assign, nonatomic) double imageRowRatio;

- (NSInteger)indexOfImageAtIndexPath:(NSIndexPath *)indexPath andHorizontalIndex:(NSInteger)horizontalIndex;
- (void)loadImageButtonOfCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex;
- (UIButton *)imageButtonForCellAtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex;

@end

@implementation MTImageGridView

@synthesize gridDelegate          = _gridDelegate;
@synthesize gridDataSource        = _gridDataSource;
@synthesize numberOfImagesPerRow  = _numberOfImagesPerRow;
@synthesize imagesSpace           = _imagesSpace;
@synthesize imageSize             = _imageSize;
@synthesize imageRowRatio         = _imageRowRatio;


#pragma mark - Setters/getters

- (double)imageRowRatio {
  return CELL_RATIO;
}

- (void)setNumberOfImagesPerRow:(NSUInteger)numberOfCellsPerRow {
  _numberOfImagesPerRow = numberOfCellsPerRow;
  
  self.imagesSpace = self.frame.size.width / (self.imageRowRatio * _numberOfImagesPerRow + _numberOfImagesPerRow + 1); 
  
}

- (void)setImagesSpace:(double)cellSpace {
  _imagesSpace = cellSpace;
  
  self.imageSize = _imagesSpace * self.imageRowRatio;
}



#pragma mark - Action

- (void)imageTapped:(UIButton *)sender {    
  
  NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)sender.superview.superview];
  
  [self.gridDelegate imageTappedAtIndex:[self indexOfImageAtIndexPath:indexPath andHorizontalIndex:sender.tag-1]];
}


#pragma mark - TableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return (ceil([self.gridDataSource numberOfImagesInImageGridView:self] /(double)self.numberOfImagesPerRow));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ImageGridCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    for (NSInteger i=0; i<self.numberOfImagesPerRow; i++) {
      [cell.contentView addSubview:[self imageButtonForCellAtIndexPath:indexPath atHorizontalIndex:i]];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  for (NSInteger i=0; i<self.numberOfImagesPerRow; i++) {
    [self loadImageButtonOfCell:cell AtIndexPath:indexPath atHorizontalIndex:i];
  }
  
  return cell;
  
}



#pragma mark - TableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self indexOfImageAtIndexPath:indexPath andHorizontalIndex:self.numberOfImagesPerRow] >= [self.gridDataSource numberOfImagesInImageGridView:self]) {
    return (self.imageSize + self.imagesSpace*2);
  }
  return (self.imagesSpace + self.imageSize);
}



#pragma mark - Helper methods

- (UIButton *)imageButtonForCellAtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex {
  UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
  imageButton.frame = CGRectMake(self.imagesSpace + horizontalIndex * (self.imageSize + self.imagesSpace),
                                 self.imagesSpace, 
                                 self.imageSize, 
                                 self.imageSize);
  
  imageButton.tag = horizontalIndex + 1;
  imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageButton.imageView.clipsToBounds = YES;
  imageButton.layer.cornerRadius = 5.0f;
  imageButton.imageView.layer.cornerRadius = imageButton.layer.cornerRadius;
  
  return imageButton;
}

- (void)loadImageButtonOfCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex {
  UIButton *imageButton = (UIButton *)[cell.contentView viewWithTag:(horizontalIndex + 1)];
  
  [imageButton setImage:nil forState:UIControlStateNormal];
  imageButton.backgroundColor = [UIColor clearColor];
  [imageButton removeTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
  
  
  if ([self indexOfImageAtIndexPath:indexPath andHorizontalIndex:horizontalIndex] < [self.gridDataSource numberOfImagesInImageGridView:self]) {
    
    // Set its appearance
    imageButton.backgroundColor = [UIColor grayColor];
    
    // Load it
    [imageButton setImageWithURL:[self.gridDataSource imageURLAtIndex:[self indexOfImageAtIndexPath:indexPath andHorizontalIndex:horizontalIndex]]
                placeholderImage:nil 
                         success:^(UIImage *image){
                           // Do fade & clear border animation  
                           imageButton.imageView.alpha = 0.0f;
                           [UIView animateWithDuration:1.0f 
                                                 delay:0.0f 
                                               options:UIViewAnimationOptionAllowUserInteraction 
                                            animations:^{
                                              imageButton.imageView.alpha=1.0f;
                                            } 
                                            completion:nil];
                         }
                         failure:^(NSError *error) {
                           [self.gridDelegate didFailedLoadingImageAtIndex:[self indexOfImageAtIndexPath:indexPath 
                                                                                      andHorizontalIndex:horizontalIndex]];
                         }];                
    
    
    // Add target/action
    [imageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (NSInteger)indexOfImageAtIndexPath:(NSIndexPath *)indexPath andHorizontalIndex:(NSInteger)horizontalIndex {
  return (indexPath.row * self.numberOfImagesPerRow + horizontalIndex);
}



#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.delegate = self;
    self.dataSource = self;
  }
  return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
