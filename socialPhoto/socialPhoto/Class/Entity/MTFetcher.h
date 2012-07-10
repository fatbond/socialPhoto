//
//  MeshtilesFetcher.h
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTPhotoDetail.h"
#import "MTUser.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define MeshtilesUserId @"1d6311db-6a2e-4362-a3c3-2a7a7814f7a4"

@protocol MTFetcherDelegate;


@interface MTFetcher : NSObject <ASIHTTPRequestDelegate>

@property (unsafe_unretained) id <MTFetcherDelegate> delegate;

- (void)getListUserPhotoByTags:(NSString *)tag 
                       andUserId:(NSString *)userId 
                     atPageIndex:(NSUInteger)index;

- (void)getListPhotoDetailFromPhotoIds:(NSArray *)photoIds
                              andUserId:(NSString *)userId;

- (void)getPhotoDetail:(NSString *)photoId
             andUserId:(NSString *)userId;

@end



@protocol MTFetcherDelegate


@optional

- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetListUserPhoto:(NSArray *)photos;     // of MeshtilesPhoto
- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetListPhotoDetailFromPhotoIds:(NSArray *)photosDetails;   // of MeshtilesPhotoDetail
- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetPhotoDetail:(MTPhotoDetail *)photo;

- (void)meshtilesFetcherDidFailedGetListUserPhoto:(MTFetcher *)fetcher;
- (void)meshtilesFetcherDidFailedGetListPhotoDetailFromPhotoIds:(MTFetcher *)fetcher;
- (void)meshtilesFetcherDidFailedGetPhotoDetail:(MTFetcher *)fetcher;


@end