//
//  MapPin.h
//  SDWebImage
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation> {
    // CLLocationCoordinate2D coordinate;
    NSString *mTitle;
    NSString *mSubTitle;
}

- (NSString *)subtitle;
- (NSString *)title;
- (id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end