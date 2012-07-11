//
//  MeshtilesPhotoCell.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "MTPhotoCell.h"

#import <QuartzCore/QuartzCore.h>


#define IMAGE_BUTTON_WIDTH_RATIO      300.0/320.0
#define USER_NAME_BUTTON_WIDTH_RATIO  125.0/320.0
#define USER_IMAGE_BUTTON_WIDTH_RATIO 50.0/320.0
#define TIME_POST_LABEL_WIDTH_RATIO   100.0/320.0

@interface MTPhotoCell() 

@property (readonly, nonatomic) CGFloat viewSpacing;
@property (readonly, nonatomic) CGFloat imageButtonWidth;
@property (readonly, nonatomic) CGFloat userImageButtonWidth;
@property (readonly, nonatomic) CGFloat userNameButtonWidth;
@property (readonly, nonatomic) CGFloat timePostLabelWidth;
@property (readonly, nonatomic) CGFloat captionLabelWidth;

@property (strong, nonatomic)   UILabel *timePostLabel;
@property (strong, nonatomic)   UILabel *captionLabel;

+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime;

@end

@implementation MTPhotoCell

@synthesize imageButton     = _imageButton;
@synthesize photo           = _photo;
@synthesize userImageButton = _userImageButton;
@synthesize userNameButton  = _userNameButton;
@synthesize timePostLabel   = _timePostLabel;
@synthesize captionLabel    = _captionLabel;


#pragma mark - Setters/getters

- (CGFloat)timePostLabelWidth {
  return self.frame.size.width * TIME_POST_LABEL_WIDTH_RATIO;
}

- (CGFloat)viewSpacing {
  return self.frame.size.width*(1-IMAGE_BUTTON_WIDTH_RATIO)/2;
}

- (CGFloat)imageButtonWidth {
  return self.frame.size.width * IMAGE_BUTTON_WIDTH_RATIO;
}

- (CGFloat)userImageButtonWidth {
  return self.frame.size.width * USER_IMAGE_BUTTON_WIDTH_RATIO;
}

- (CGFloat)userNameButtonWidth {
  return self.frame.size.width * USER_NAME_BUTTON_WIDTH_RATIO;
}

- (CGFloat)captionLabelWidth {
  return (self.frame.size.width - self.userImageButton.frame.origin.x - self.userImageButton.frame.size.width - 2*[self viewSpacing]);
}

- (UILabel *)captionLabel {
  if (!_captionLabel) {
    _captionLabel = [[UILabel alloc] init];
    _captionLabel.textColor = [UIColor colorWithRed:131.0/255.0 
                                               green:130.0/255.0
                                                blue:128.0/255.0
                                               alpha:1.0];
    _captionLabel.font = [UIFont systemFontOfSize:13.0];
    _captionLabel.numberOfLines = 0;
    _captionLabel.lineBreakMode = UILineBreakModeWordWrap;
    _captionLabel.backgroundColor = [UIColor clearColor];
  }
  
  return _captionLabel;
}

- (UILabel *)timePostLabel {
  if (!_timePostLabel) {
    _timePostLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userNameButton.frame.origin.x + 
                                                              self.userNameButton.frame.size.width + 
                                                               [self viewSpacing], 
                                                              self.imageButton.frame.origin.y +
                                                              self.imageButton.frame.size.height +
                                                               [self viewSpacing],
                                                              [self timePostLabelWidth], 
                                                               15.0)];
    _timePostLabel.textAlignment = UITextAlignmentRight;
    _timePostLabel.textColor = [UIColor colorWithRed:131.0/255.0 
                                               green:130.0/255.0
                                                blue:128.0/255.0
                                               alpha:1.0];
    _timePostLabel.font = [UIFont systemFontOfSize:13.0];
    _timePostLabel.backgroundColor = [UIColor clearColor];
  }
  
  return _timePostLabel;
}

- (UIButton *)userNameButton {
  if (!_userNameButton) {
    _userNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _userNameButton.frame = CGRectMake(self.userImageButton.bounds.size.width + self.viewSpacing*2,
                                       self.imageButton.bounds.size.height + self.viewSpacing*2,
                                       self.userNameButtonWidth,
                                       15.0);
    _userNameButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    _userNameButton.contentVerticalAlignment    = UIControlContentVerticalAlignmentTop;
    [_userNameButton setTitleColor:[UIColor colorWithRed:30.0/255.0 green:70.0/255.0 blue:158.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    _userNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
  }
  
  return _userNameButton;
}

- (MTWebImageButton *)imageButton {
  if (!_imageButton) {
    _imageButton = [[MTWebImageButton alloc] initWithFrame:CGRectMake(self.viewSpacing, 
                                                                    self.viewSpacing,
                                                                    self.imageButtonWidth,
                                                                    self.imageButtonWidth)];
    _imageButton.haveProgressHUD = YES;
  }
  
  return _imageButton;
}

- (MTWebImageButton *)userImageButton {
  if (!_userImageButton) {
    _userImageButton = [[MTWebImageButton alloc] initWithFrame:CGRectMake(self.viewSpacing, 
                                                                        self.frame.size.width, 
                                                                        self.userImageButtonWidth, 
                                                                        self.userImageButtonWidth)];
  }
                        
  return _userImageButton;
                        
}

- (void)setPhoto:(MTPhotoDetail *)photo {
  _photo = photo;
    
  self.imageButton.imageURL     = _photo.photoURL;
  self.userImageButton.imageURL = _photo.user.imageURL;
  [self.userNameButton setTitle:_photo.user.userName forState:UIControlStateNormal];
  self.timePostLabel.text       = [NSString stringWithFormat:@"%@ ago", [MTPhotoCell stringForTimeIntervalSinceCreated:_photo.timePost]];
  
  CGSize textSize = [_photo.caption sizeWithFont:[UIFont systemFontOfSize:13.0]
                                 constrainedToSize:CGSizeMake([self captionLabelWidth], 2000)
                                     lineBreakMode:UILineBreakModeWordWrap];
  self.captionLabel.frame = CGRectMake(self.userImageButton.frame.origin.x +
                          self.userImageButton.frame.size.width +
                          [self viewSpacing],
                          self.userNameButton.frame.origin.y +
                          self.userNameButton.frame.size.height + 
                          [self viewSpacing],
                          [self captionLabelWidth],
                          textSize.height);
  self.captionLabel.text        = _photo.caption;
  
}





#pragma mark - Cell life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{  
  // Force use Default style
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  
  if (self) {
    // Initialization code
    
    // Add subviews
    [self.contentView addSubview:self.imageButton];
    [self.contentView addSubview:self.userImageButton];
    [self.contentView addSubview:self.userNameButton];
    [self.contentView addSubview:self.timePostLabel];
    [self.contentView addSubview:self.captionLabel];
    
    // Set selectionStyle
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set cell shadow
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 1.0);
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}




#pragma mark - Helper methods

+ (CGFloat)cellHeightForFrameWidth:(CGFloat)frameWidth andPhoto:(MTPhotoDetail *)photo {
  CGFloat firstPart = frameWidth;
  
  CGFloat secondPart = MAX(frameWidth * USER_IMAGE_BUTTON_WIDTH_RATIO,
                            [photo.caption sizeWithFont:[UIFont systemFontOfSize:13.0]
                                      constrainedToSize:CGSizeMake(frameWidth - (frameWidth*(1-IMAGE_BUTTON_WIDTH_RATIO)/2*3 + frameWidth * USER_IMAGE_BUTTON_WIDTH_RATIO), 
                                                                   2000)
                                          lineBreakMode:UILineBreakModeWordWrap].height + 15.0 + frameWidth*(1-IMAGE_BUTTON_WIDTH_RATIO)/2);
  
  CGFloat lastPart = frameWidth*(1-IMAGE_BUTTON_WIDTH_RATIO)/2;
  
  
  return (firstPart + secondPart + lastPart);
}

+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime {
  
  
  NSInteger minuteInterval;
  NSInteger hourInterval;
  NSInteger dayInterval;
  NSInteger yearInterval;
  
  
  NSInteger interval = abs([dateTime timeIntervalSinceNow]);
  
  
  if (interval >= (60*60*24*365)) {
    yearInterval = interval / (60*60*24*365);
    return [NSString stringWithFormat:@"%d years", yearInterval];
  } else if (interval >= 86400) {
    
    dayInterval   = interval / 86400;
    return [NSString stringWithFormat:@"%d days", dayInterval];
    
  } else if (interval >= 3600) {
    
    hourInterval= interval/3600;
    return [NSString stringWithFormat:@"%d hours", hourInterval];
    
  } else if (interval >= 60){
    
    minuteInterval = interval / 60;
    
    return [NSString stringWithFormat:@"%d minutes", minuteInterval];
  } else {
    return [NSString stringWithFormat:@"%d seconds", interval];
  }
}

@end
