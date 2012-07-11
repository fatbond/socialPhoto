//
//  MTSearchButton.m
//  socialPhoto
//
//  Created by Dung Nguyen on 7/11/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTSearchButton.h"

@interface MTSearchButton()

@property (strong, nonatomic) UILabel *searchTagLabel;
@property (strong, nonatomic) UIButton *searchButton;

- (void)searchButtonTapped:(UIButton *)searchButton;

@end

@implementation MTSearchButton

@synthesize searchTagLabel = _searchTagLabel;
@synthesize searchButton = _searchButton;
@synthesize searchTag = _searchTag;

#pragma mark - Setters/Getters

- (void)setSearchTag:(NSString *)searchTag {
  _searchTag = searchTag;
  
  self.searchTagLabel.text = _searchTag;
}

- (UILabel *)searchTagLabel {
  if (!_searchTagLabel) {
    _searchTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 103, 20)];
    _searchTagLabel.text = @"Search";
    _searchTagLabel.textAlignment = UITextAlignmentCenter;
    _searchTagLabel.textColor = [UIColor whiteColor];
    _searchTagLabel.backgroundColor = [UIColor clearColor];
    _searchTagLabel.font = [UIFont boldSystemFontOfSize:12.0];
  }
  
  return _searchTagLabel;
}

- (UIButton *)searchButton {
  if (!_searchButton) {
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = self.bounds;
    [_searchButton setImage:[UIImage imageNamed:@"btn_menu_tag_search_active.png"] forState:UIControlStateNormal];
    [_searchButton addSubview:self.searchTagLabel];
    [_searchButton addTarget:self action:@selector(searchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _searchButton;
}




#pragma mark - Target/Action

- (void)searchButtonTapped:(UIButton *)searchButton {
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}




#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, 103.0, 40.0);
    
    [self addSubview:self.searchButton];
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
