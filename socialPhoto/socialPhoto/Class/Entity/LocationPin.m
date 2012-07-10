//
//  MapPin.m
//  SDWebImage
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "LocationPin.h"

@implementation LocationPin
@synthesize coordinate;

- (NSString *)subtitle{
    return @"Here !!!";
}

- (NSString *)title{
    return @"Found";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
    coordinate=c;
    return self;
}
@end
