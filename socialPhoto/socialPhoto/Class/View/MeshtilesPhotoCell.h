//
//  MeshtilesPhotoCell.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/6/12.
//  Copyright (c) 2012 dungnguyen photography. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeshtilesPhotoDetail.h"
#import "WebImageButton.h"

@interface MeshtilesPhotoCell : UITableViewCell



@property (strong, nonatomic) MeshtilesPhotoDetail  *photo;
@property (strong, nonatomic) WebImageButton        *imageButton;
@property (strong, nonatomic) WebImageButton        *userImageButton;
@property (strong, nonatomic) UIButton              *userNameButton;

+ (CGFloat)cellHeightForFrameWidth:(CGFloat)frameWidth andPhoto:(MeshtilesPhotoDetail *)photo;


@end
