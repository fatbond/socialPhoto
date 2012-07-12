//
//  ImagePin.m
//  MapApp
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImagePin.h"

@interface ImagePin()
    @property (strong) NSURL *url;
    @property (assign) bool isFocus;
@end

@implementation ImagePin
@synthesize coordinate;
@synthesize url = _url;
@synthesize isFocus = _isFocus;
@synthesize index = _index;

- (void)changeFocus:(bool) state
{
    self.isFocus = state;
}

- (bool)isFocused
{
    return self.isFocus;
}

-(NSURL*) getURL
{
    // NSLog(@"pin : %@", self.url);
    return self.url;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
                 andURL:(NSURL*) imageURL{
    coordinate = c;
    self.url = imageURL;
    return self;
}

- (CLLocationCoordinate2D) getCoordinate{return coordinate;}

@end