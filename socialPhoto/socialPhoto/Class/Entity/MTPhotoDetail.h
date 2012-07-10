//
//  MeshtilesPhotoDetail.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTPhoto.h"
#import "MTUser.h"

@interface MTPhotoDetail : MTPhoto

@property (strong, nonatomic) NSURL         *photoURL;
@property (strong, nonatomic) NSString      *caption;
@property (strong, nonatomic) MTUser *user;
@property (strong, nonatomic) NSDate        *timePost;

@end
