//
//  MeshtilesPhoto.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPhoto : NSObject

@property (strong, nonatomic)   NSString    *photoId;
@property (strong, nonatomic)   NSURL       *thumbURL;
@property (assign)              double      longitude;
@property (assign)              double      latitude;

@end