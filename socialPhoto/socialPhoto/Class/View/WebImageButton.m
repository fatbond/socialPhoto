//
//  WebImageButton.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import "WebImageButton.h"

#import "MBProgressHUD.h"
#import <SDWebImage/SDWebImageManager.h>
#import <QuartzCore/QuartzCore.h>

@interface WebImageButton() <SDWebImageManagerDelegate>

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) UIButton      *imageButton;

- (void)imageButtonTapped:(UIButton *)button;

@end

@implementation WebImageButton

@synthesize imageURL        = _imageURL;
@synthesize progressHUD     = _progressHUD;
@synthesize imageButton     = _imageButton;
@synthesize haveProgressHUD = _haveProgressHUD;



#pragma mark - Setters/getters

- (void)setHaveProgressHUD:(BOOL)haveProgressHUD {
  _haveProgressHUD = haveProgressHUD;
  
  if (_haveProgressHUD == YES) {
    [self addSubview:self.progressHUD];
  } else {
    [self.progressHUD removeFromSuperview];
  }
}

- (MBProgressHUD *)progressHUD {
  if (!_progressHUD) {
    _progressHUD = [[MBProgressHUD alloc] initWithView:self];        
    _progressHUD.mode = MBProgressHUDModeDeterminate;
    _progressHUD.square = YES;
    _progressHUD.minSize = CGSizeMake(30.0f, 30.0f);
    _progressHUD.progress = 0.0;
  }
  
  return _progressHUD;
}

- (UIButton *)imageButton {
  if (!_imageButton) {
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame = self.bounds;
    
    _imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageButton.imageView.clipsToBounds = YES;
    [_imageButton addTarget:self action:@selector(imageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

  }
  
  return _imageButton;
}

- (void)setImageURL:(NSURL *)imageURL {
  if (_imageURL != imageURL) {
    _imageURL = imageURL;
    
    // Show and reset the progressHUD
    [self showAndResetProgressHUD];
    
    // Hide the button
    self.imageButton.alpha = 0.0;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager cancelForDelegate:self];
    [manager downloadWithURL:_imageURL 
                    delegate:self 
                     options:SDWebImageProgressiveDownload 
                     success:^(UIImage *image, BOOL fromCache) {
                       
                       // Set the imageView's image to the downloaded image
                       [self setImage:image forButton:self.imageButton];
                       
                       // Set its frame to center and fit screen if large
                       if (image.size.width > self.bounds.size.width ||
                           image.size.height > self.bounds.size.height) {
                         
                         self.imageButton.frame = self.bounds;
                         
                       } else {
                         self.imageButton.frame = CGRectMake(self.bounds.size.width/2 - image.size.width/2,
                                                             self.bounds.size.height/2 - image.size.height/2,
                                                             image.size.width,
                                                             image.size.height);
                       }
                       
                       self.progressHUD.progress = 1.0;  
                       
                       // Fade in animation (only if not loading from cache)
                       if (fromCache) {
                         self.imageButton.alpha = 1.0;
                         [self.progressHUD hide:NO];
                       } else {
                         [UIView animateWithDuration:1.0 
                                               delay:0.0 
                                             options:UIViewAnimationOptionAllowUserInteraction 
                                          animations:^{
                                            self.imageButton.alpha = 1.0;
                                          }
                                          completion:nil];
                         [self.progressHUD hide:YES];
                       }
                       
      

                     } 
                     failure:^(NSError *error){
                       [self.progressHUD hide:YES];
                     }];    
    
  }
  
}

#pragma mark - WebImageManager delegate methods

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url {
  if ([url.absoluteString isEqual:self.imageURL]) {
    
    self.progressHUD.progress = [imageManager.progress doubleValue];
  }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url {
  
}


#pragma mark - Target/action

- (void)imageButtonTapped:(UIButton *)button {
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - Helper methods

- (void)showAndResetProgressHUD {
  [self.progressHUD show:YES];
  self.progressHUD.progress = 0.0;
}

- (void)setImage:(UIImage *)image forButton:(UIButton *)button {
  [button setImage:image forState:UIControlStateNormal];
  [button setImage:image forState:UIControlStateSelected];
  [button setImage:image forState:UIControlStateHighlighted];
}



#pragma mark - View lifecycle

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    
    [self addSubview:self.imageButton];
    
    
  }
  return self;
}

@end
