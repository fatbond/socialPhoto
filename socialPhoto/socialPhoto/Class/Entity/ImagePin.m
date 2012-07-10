//
//  ImagePin.m
//  MapApp
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePin.h"

@implementation ImagePin
@synthesize coordinate;

-(NSURL*) getURL
{
    return url;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
                 andURL:(NSURL*) imageURL{
    coordinate = c;
    url = imageURL;
    return self;
}

- (CLLocationCoordinate2D) getCoordinate{return self.coordinate;}

@end