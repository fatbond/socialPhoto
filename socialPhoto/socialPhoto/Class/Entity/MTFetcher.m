//
//  MeshtilesFetcher.m
//  ImageGridTableView
//
//  Created by Dung Nguyen on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTFetcher.h"
#import "MTPhoto.h"

#import "SBJson.h"

#define MESHTILES_PHOTO             @"photo"
#define MESHTILES_PHOTOS            @"photo"
#define MESHTILES_PHOTO_THUMB_URL   @"url_thumb"
#define MESHTILES_PHOTO_ID          @"photo_id"
#define MESHTILES_PHOTO_LATITUDE    @"latitude"
#define MESHTILES_PHOTO_LONGITUDE   @"longitude"
#define MESHTILES_PHOTO_URL         @"url_photo"
#define MESHTILES_PHOTO_CAPTION     @"caption"
#define MESHTILES_PHOTO_USER        @"user"
#define MESHTILES_PHOTO_TIME_POST   @"time_post"

#define MESHTILES_USER_NAME         @"user_name"
#define MESHTILES_USER_ID           @"user_id"
#define MESHTILES_USER_IMAGE_URL    @"url_image"


@interface MTFetcher()

@property (strong, nonatomic) ASIHTTPRequest      *getListUserPhotoByTagsRequest;
@property (strong, nonatomic) ASIHTTPRequest      *getPhotoDetailRequest;
@property (strong, nonatomic) ASIFormDataRequest  *getListPhotoDetailFromPhotoIdsRequests;

- (MTPhotoDetail *)photoDetailFromPhotoDictionary:(NSDictionary *)photoDictionary;

- (void)getListUserPhotoByTagsRequestFinished;
- (void)getPhotoDetailRequestFinished;
- (void)getListPhotoDetailFromPhotoIdsFinished;

- (void)getListUserPhotoByTagsRequestFailed;
- (void)getPhotoDetailRequestFailed;
- (void)getListPhotoDetailFromPhotoIdsFailed;

@end

@implementation MTFetcher

@synthesize delegate                                = _delegate;
@synthesize getListUserPhotoByTagsRequest           = _getListUserPhotoByTagsRequest;
@synthesize getPhotoDetailRequest                   = _getPhotoDetailRequest;
@synthesize getListPhotoDetailFromPhotoIdsRequests  = _getListPhotoDetailFromPhotoIdsRequests;

#pragma mark - Get list of photo details from list of photoIDs

#define GET_LIST_PHOTO_DETAIL_FROM_PHOTO_IDS_URL @"http://ec2-107-20-246-0.compute-1.amazonaws.com/api/View/getListPhotoDetail"

- (void)getListPhotoDetailFromPhotoIds:(NSArray *)photoIds
                                 andUserId:(NSString *)userId {
  
  
  NSMutableString *photoIdsString = [[NSMutableString alloc] init];  
  for (NSInteger i=0; i<photoIds.count; i++) {
    [photoIdsString appendString:[photoIds objectAtIndex:i]];
    
    if (i<photoIds.count-1) {
      [photoIdsString appendString:@","];   // add a comma separator if not last element
    }
  }
  
  self.getListPhotoDetailFromPhotoIdsRequests = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:GET_LIST_PHOTO_DETAIL_FROM_PHOTO_IDS_URL]];  
  [self.getListPhotoDetailFromPhotoIdsRequests setPostValue:photoIdsString  
                                                     forKey:@"list_photo_id"];
  [self.getListPhotoDetailFromPhotoIdsRequests setPostValue:userId          
                                                     forKey:@"user_id"];
  
  self.getListPhotoDetailFromPhotoIdsRequests.delegate = self;
  self.getListPhotoDetailFromPhotoIdsRequests.timeOutSeconds = 60;
  [self.getListPhotoDetailFromPhotoIdsRequests startAsynchronous];
}

- (void)getListPhotoDetailFromPhotoIdsFinished {
  
  NSString *responseString = [[NSString alloc] initWithData:[self.getListPhotoDetailFromPhotoIdsRequests responseData] encoding:NSUTF8StringEncoding];
  NSDictionary *responseJSON = [responseString JSONValue];
  NSArray *photosJSONs = [responseJSON objectForKey:MESHTILES_PHOTOS];
  
  NSMutableArray *photosDetails = [[NSMutableArray alloc] init];
  for (NSDictionary *photoJSON in photosJSONs) {
    [photosDetails addObject:[self photoDetailFromPhotoDictionary:photoJSON]];
  }
  
  
  [self.delegate meshtilesFetcher:self didFinishedGetListPhotoDetailFromPhotoIds:photosDetails];
}

- (void)getListPhotoDetailFromPhotoIdsFailed {
  [self.delegate meshtilesFetcherDidFailedGetListPhotoDetailFromPhotoIds:self];
}



#pragma mark - Get list user photo by tags

#define GET_LIST_USER_PHOTO_BY_TAGS_URL @"http://ec2-107-20-246-0.compute-1.amazonaws.com/api/View/getListPhotoByTags?user_id=%@&tag=%@&page_index=%d"

- (void)getListUserPhotoByTags:(NSString *)tag 
                     andUserId:(NSString *)userId 
                   atPageIndex:(NSUInteger)index {
  
  NSString *url = [NSString stringWithFormat:GET_LIST_USER_PHOTO_BY_TAGS_URL, 
                   userId, tag, index];
  
  self.getListUserPhotoByTagsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
  
  self.getListUserPhotoByTagsRequest.delegate = self;
  self.getListUserPhotoByTagsRequest.timeOutSeconds = 60;
  [self.getListUserPhotoByTagsRequest startAsynchronous];
  
}

- (void)getListUserPhotoByTagsRequestFinished {
  
  NSDictionary *responseJSON = [[[NSString alloc] initWithData:[self.getListUserPhotoByTagsRequest responseData] encoding:NSUTF8StringEncoding] JSONValue];
  
  NSArray *photosDictionaries = [responseJSON objectForKey:MESHTILES_PHOTOS];
  NSMutableArray *photos = [[NSMutableArray alloc] init];      // of MeshtilesPhoto
  
  for (NSDictionary *photoDictionary in photosDictionaries) {
    MTPhoto *photo = [[MTPhoto alloc] init];
    photo.thumbURL  = [photoDictionary  objectForKey:MESHTILES_PHOTO_THUMB_URL];
    photo.photoId   = [photoDictionary  objectForKey:MESHTILES_PHOTO_ID];
    photo.latitude  = [[photoDictionary objectForKey:MESHTILES_PHOTO_LATITUDE] doubleValue];
    photo.longitude = [[photoDictionary objectForKey:MESHTILES_PHOTO_LONGITUDE] doubleValue];
    
    [photos addObject:photo];
  }
  
  [self.delegate meshtilesFetcher:self didFinishedGetListUserPhoto:photos];
}

- (void)getListUserPhotoByTagsRequestFailed {
  [self.delegate meshtilesFetcherDidFailedGetListUserPhoto:self];
}



#pragma mark - Get photo detail

#define GET_PHOTO_DETAIL_URL @"http://ec2-107-20-246-0.compute-1.amazonaws.com/api/View/getPhotoDetail?photo_id=%@&user_id=%@"

- (MTUser *)userFromUserDictionary:(NSDictionary *)userDictionary {
  MTUser *user = [[MTUser alloc] init];
  
  user.userName = [userDictionary objectForKey:MESHTILES_USER_NAME];
  user.userId   = [userDictionary objectForKey:MESHTILES_USER_ID];
  user.imageURL = [userDictionary objectForKey:MESHTILES_USER_IMAGE_URL];
  
  return user;
}

- (MTPhotoDetail *)photoDetailFromPhotoDictionary:(NSDictionary *)photoDictionary {
  MTPhotoDetail *photo = [[MTPhotoDetail alloc] init];
  
  photo.photoURL  =   [photoDictionary objectForKey:MESHTILES_PHOTO_URL];
  photo.caption   =   [[photoDictionary objectForKey:MESHTILES_PHOTO_CAPTION] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  photo.thumbURL  =   [photoDictionary objectForKey:MESHTILES_PHOTO_THUMB_URL];
  photo.photoId   =   [photoDictionary objectForKey:MESHTILES_PHOTO_ID];
  photo.latitude  =   [[photoDictionary objectForKey:MESHTILES_PHOTO_LATITUDE] doubleValue];
  photo.longitude =   [[photoDictionary objectForKey:MESHTILES_PHOTO_LONGITUDE] doubleValue];
  photo.user      =   [self userFromUserDictionary:[photoDictionary objectForKey:MESHTILES_PHOTO_USER]];
  photo.timePost  =   [NSDate dateWithTimeIntervalSinceNow:-(NSInteger)[photoDictionary objectForKey:MESHTILES_PHOTO_TIME_POST]];

  return photo;
}

- (MTPhotoDetail *)photoDetailFromJSONString:(NSString *)JSONString {
  
  NSDictionary *photoDictionary = [[JSONString JSONValue] objectForKey:MESHTILES_PHOTO];
  
  return [self photoDetailFromPhotoDictionary:photoDictionary];
}

- (void)getPhotoDetail:(NSString *)photoId andUserId:(NSString *)userId {
  
  NSString *url = [NSString stringWithFormat:GET_PHOTO_DETAIL_URL, photoId, userId];
  
  self.getPhotoDetailRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
  self.getPhotoDetailRequest.delegate = self;
  self.getPhotoDetailRequest.timeOutSeconds = 60;
  [self.getPhotoDetailRequest startAsynchronous];
  
}

- (void)getPhotoDetailRequestFinished {
  
  MTPhotoDetail *photo = [self photoDetailFromJSONString:[[NSString alloc] initWithData:[self.getPhotoDetailRequest responseData] encoding:NSUTF8StringEncoding]];
  
  [self.delegate meshtilesFetcher:self didFinishedGetPhotoDetail:photo];
  
}

- (void)getPhotoDetailRequestFailed {
  [self.delegate meshtilesFetcherDidFailedGetPhotoDetail:self];
}


# pragma mark - ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request {
  
  if (request == self.getListUserPhotoByTagsRequest) {
    [self getListUserPhotoByTagsRequestFinished];
  } else if (request == self.getPhotoDetailRequest) {
    [self getPhotoDetailRequestFinished];
  } else if (request == self.getListPhotoDetailFromPhotoIdsRequests) {
    [self getListPhotoDetailFromPhotoIdsFinished];
  }
  
  
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  
  if (request == self.getListUserPhotoByTagsRequest) {
    [self getListUserPhotoByTagsRequestFailed];
  } else if (request == self.getPhotoDetailRequest) {
    [self getPhotoDetailRequestFailed];
  } else if (request == self.getListPhotoDetailFromPhotoIdsRequests) {
    [self getListPhotoDetailFromPhotoIdsFinished];
  }
  
}


@end