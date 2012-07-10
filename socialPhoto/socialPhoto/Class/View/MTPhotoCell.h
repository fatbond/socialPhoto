//
//  MeshtilesPhotoCell.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTPhotoDetail.h"
#import "MTWebImageButton.h"

@interface MTPhotoCell : UITableViewCell



@property (strong, nonatomic) MTPhotoDetail  *photo;
@property (strong, nonatomic) MTWebImageButton        *imageButton;
@property (strong, nonatomic) MTWebImageButton        *userImageButton;
@property (strong, nonatomic) UIButton              *userNameButton;

+ (CGFloat)cellHeightForFrameWidth:(CGFloat)frameWidth andPhoto:(MTPhotoDetail *)photo;


@end
