//
//  GridView.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageGridView.h"

#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIButton+WebCache.h"

#define CellRatio  18.75

@interface ImageGridView() <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) double imagesSpace;
@property (assign, nonatomic) double imageSize;
@property (assign, nonatomic) double imageRowRatio;

- (NSInteger)indexOfImageAtIndexPath:(NSIndexPath *)indexPath andHorizontalIndex:(NSInteger)horizontalIndex;
- (UIButton *)imageButtonForCellAtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex;
- (void)loadImageButtonOfCell:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath atHorizontalIndex:(NSInteger)horizontalIndex;

@end

@implementation ImageGridView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize tableView = _tableView;
@synthesize numberOfImagesPerRow = _numberOfImagesPerRow;
@synthesize imagesSpace = _imagesSpace;
@synthesize imageSize = _imageSize;
@synthesize imageRowRatio = _imageRowRatio;

#pragma mark - Setters/getters


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (double)imageRowRatio {
    return CellRatio;
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    [self.delegate imageTappedAtIndex:[self indexOfImageAtIndexPath:indexPath andHorizontalIndex:sender.tag-1]];
}

#pragma mark - TableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return (ceil([self.delegate numberOfImagesInImageGridView:self] /(double)self.numberOfImagesPerRow));
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self indexOfImageAtIndexPath:indexPath andHorizontalIndex:self.numberOfImagesPerRow] >= [self.delegate numberOfImagesInImageGridView:self]) {
        return (self.imageSize + self.imagesSpace*2);
    }
    return (self.imagesSpace + self.imageSize);
}

#pragma mark - TableViewDelegate methods

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
    
    
    if ([self indexOfImageAtIndexPath:indexPath andHorizontalIndex:horizontalIndex] < [self.delegate numberOfImagesInImageGridView:self]) {
        
        // Set its appearance
        imageButton.backgroundColor = [UIColor grayColor];
        
        // Load it
        [imageButton setImageWithURL:[self.delegate imageURLAtIndex:[self indexOfImageAtIndexPath:indexPath andHorizontalIndex:horizontalIndex]]
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
                                 [self.delegate didFailedLoadingImageAtIndex:[self indexOfImageAtIndexPath:indexPath 
                                                                                        andHorizontalIndex:horizontalIndex]];
                             }];                
        
        
        // Add target/action
        [imageButton addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSInteger)indexOfImageAtIndexPath:(NSIndexPath *)indexPath andHorizontalIndex:(NSInteger)horizontalIndex {
    return (indexPath.row * self.numberOfImagesPerRow + horizontalIndex);
}

#pragma mark - View life cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.tableView];
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
