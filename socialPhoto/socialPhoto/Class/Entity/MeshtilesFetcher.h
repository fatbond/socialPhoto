//
//  MeshtilesFetcher.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshtilesPhotoDetail.h"
#import "MeshtilesUser.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define MeshtilesUserId @"1d6311db-6a2e-4362-a3c3-2a7a7814f7a4"

@protocol MeshtilesFetcherDelegate;


@interface MeshtilesFetcher : NSObject <ASIHTTPRequestDelegate>

@property (assign) id <MeshtilesFetcherDelegate> delegate;

- (void)getListUserPhotoByTags:(NSString *)tag 
                       andUserId:(NSString *)userId 
                     atPageIndex:(NSUInteger)index;

- (void)getListPhotoDetailFromPhotoIds:(NSArray *)photoIds
                              andUserId:(NSString *)userId;

- (void)getPhotoDetail:(NSString *)photoId
             andUserId:(NSString *)userId;

@end



@protocol MeshtilesFetcherDelegate


@optional

- (void)meshtilesFetcher:(MeshtilesFetcher *)fetcher didFinishedGetListUserPhoto:(NSArray *)photos;     // of MeshtilesPhoto
- (void)meshtilesFetcher:(MeshtilesFetcher *)fetcher didFinishedGetListPhotoDetailFromPhotoIds:(NSArray *)photosDetails;   // of MeshtilesPhotoDetail
- (void)meshtilesFetcher:(MeshtilesFetcher *)fetcher didFinishedGetPhotoDetail:(MeshtilesPhotoDetail *)photo;

- (void)meshtilesFetcherDidFailedGetListUserPhoto:(MeshtilesFetcher *)fetcher;
- (void)meshtilesFetcherDidFailedGetListPhotoDetailFromPhotoIds:(MeshtilesFetcher *)fetcher;
- (void)meshtilesFetcherDidFailedGetPhotoDetail:(MeshtilesFetcher *)fetcher;


@end