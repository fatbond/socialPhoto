//
//  WebImageButton.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImageButton : UIControl

@property (strong, nonatomic) NSURL *imageURL;
@property (assign, nonatomic) BOOL haveProgressHUD;

@end
