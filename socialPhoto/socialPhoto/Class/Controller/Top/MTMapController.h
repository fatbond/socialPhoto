//
//  MapViewController.h
//  MapAppGrid
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h> 
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBJson.h"
#import "LocationPin.h"
#import "MTFetcher.h"
#import "ImagePin.h"
#import "MTImageGridView.h"

@interface MTMapController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, MTFetcherDelegate, MTImageGridViewDelegate, MTImageGridViewDatasource>

@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *search;

@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *myMap;

@property (nonatomic, strong) CLLocationManager *locationManager;

-(void) setPhotos:(NSArray *)photos;

@end
