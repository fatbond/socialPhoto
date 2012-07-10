//
//  ImagePin.h
//  MapApp
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ImagePin : NSObject<MKAnnotation>{
    NSURL   *url;
    
    CLLocationCoordinate2D coordinate;
}

- (NSURL *) getURL;
- (CLLocationCoordinate2D) getCoordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D) c
     andURL:(NSURL*) imageURL;

@end