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
#import "UIImageView+WebCache.h"
#import "SBJson.h"
#import "LocationPin.h"
#import "MeshtilesFetcher.h"
#import "ImagePin.h"
#import "MTImageGridView.h"

@interface MTMapController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, MeshtilesFetcherDelegate, MTImageGridViewDelegate, MTImageGridViewDatasource>

@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *search;

@property (unsafe_unretained, nonatomic) IBOutlet MKMapView *myMap;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSArray *photos;

@end
