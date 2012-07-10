//
//  MapViewController.m
//  MapAppGrid
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTMapController.h"

@interface MTMapController(){
@private
    SBJsonParser *parser;    
    LocationPin *addAnnotation;
    NSMutableArray *listImageToShow;
    MTImageGridView *imageGridView;
    MTFetcher *fetcher;
}
@end

@implementation MTMapController
@synthesize search = _search;
@synthesize myMap = _myMap;
@synthesize locationManager = _locationManager;
@synthesize photos = _photos;

-(void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self meshtilesFetcher:fetcher didFinishedGetListUserPhoto:_photos];
}

- (CLLocationCoordinate2D) addressLocation {
    // Construct Google API for searching
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&key=YourGoogleMapAPIKey", 
                           [self.search.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // Get result data from Google API, a CSV string
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
        
    // Seperate by ,
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Show error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not found" message:@"Place is not on the Earth" delegate:self cancelButtonTitle:@"True Story!" otherButtonTitles:nil];
        [alert show];
        return addAnnotation.coordinate;
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

- (void) showAddress:(CLLocationCoordinate2D) address{
    //Hide the keypad
    [self.search resignFirstResponder];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.5;
    span.longitudeDelta=0.5;
    
    CLLocationCoordinate2D location = address;
    region.span=span;
    region.center=location;
    
    // Pin to map
    if(addAnnotation != nil) {
        [self.myMap removeAnnotation:addAnnotation];
         addAnnotation = nil;
    }
    addAnnotation = [[LocationPin alloc] initWithCoordinate:location];
    [self.myMap addAnnotation:addAnnotation];
    [self.myMap setRegion:region animated:TRUE];
    [self.myMap regionThatFits:region];
}

- (void)    pinImageWithURL:(NSURL *)url
            atLongitude:(float) longitude
            atLatitude:(float) latitude{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
    ImagePin *annView = [[ImagePin alloc] initWithCoordinate:location 
                                          andURL:url];
    [self.myMap addAnnotation:annView]; 
}

- (void)fetchedData:(NSString *)tag
        withUserID:(NSString *)id{
    // parse out the json data   
    // URL is complete by using USERNAME and TAG
    [fetcher getListUserPhotoByTags:tag andUserId:id atPageIndex:1];    
}


- (void)meshtilesFetcher:(MTFetcher *)fetcher didFinishedGetListUserPhoto:(NSArray *)photos
{
    int i = 0;    
    for(NSDictionary *photo in photos){    
        double lon = ((MTPhoto*)photo).longitude;
        double lat = ((MTPhoto*)photo).latitude;
        NSURL *imageURL = ((MTPhoto*)photo).thumbURL;
        
        if((lon < 0)||(lon > 180)) ;
        else if((lat < -90)&&(lat > 90)) ;
        else {
            [self pinImageWithURL:imageURL atLongitude:lon atLatitude:lat];
            i++;
        }
        // if(i >= 3) break; // Only load 3 image
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    static NSString *ImagePinID = @"imagePinID";
     
    // Create pin for found location
    if([annotation isKindOfClass:[LocationPin class]]){
        MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annView.pinColor = MKPinAnnotationColorRed;
        annView.animatesDrop = YES;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        return annView;
    }
    
    // Create pin for an image
    if([annotation isKindOfClass:[ImagePin class]]){
        MKAnnotationView *annView = [mapView dequeueReusableAnnotationViewWithIdentifier:ImagePinID];
        if (annView == nil)
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ImagePinID];
        
        UIImageView *bgView = [[UIImageView alloc] init];
        [bgView setImage:[UIImage imageNamed:@"map_image_bg.png"]];
        bgView.frame = CGRectMake(0, -28, 56, 56);
        
        UIImageView *myView = [[UIImageView alloc] init];
        [myView setImageWithURL:[(ImagePin*)annotation getURL] placeholderImage:[UIImage imageNamed:@"map_image_bg.png"]];
        myView.frame = CGRectMake(7, -23, 38, 38);
        
        annView.frame = CGRectMake(0, -23, 48, 38);
       
        [annView insertSubview:bgView atIndex:0];
        [annView insertSubview:myView atIndex:1];
        
        return annView;
    }
    
    // Return nil if its type is current location
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[ImagePin class]]){        
        NSLog(@"====");
        
        [listImageToShow removeAllObjects];
        
        // Check others image is overlapped or not
        for(ImagePin *ann in self.myMap.annotations)
            if([ann isKindOfClass:[ImagePin class]]){
                MKAnnotationView *annView = [self mapView:self.myMap viewForAnnotation:ann];
                CGPoint touchPoint = [self.myMap convertCoordinate:[view.annotation coordinate] toPointToView:self.myMap];
                
                CGRect buffer = ((UIImageView*)[annView.subviews objectAtIndex:0]).frame;
                CGPoint point = [self.myMap convertCoordinate:[ann getCoordinate] toPointToView:self.myMap];
                CGRect rect = CGRectMake(point.x-buffer.size.width/2, point.y-buffer.size.height/2, buffer.size.width, buffer.size.height);
                
                if(CGRectContainsPoint(rect, touchPoint)) {
                    [listImageToShow addObject:annView];
                    NSLog(@"Tap");
                }
            }
        
        // Show grid view if any >= 2 images overlaps
        if([listImageToShow count] == 1)
        {
            view.bounds = CGRectMake(0, 0, 52, 52);
            ((UIImageView*)[view.subviews objectAtIndex:0]).frame = CGRectMake(0, -30, 72, 72);
            ((UIImageView*)[view.subviews objectAtIndex:1]).frame = CGRectMake(7, -27, 52, 52);
        }
        else
        {
            [self.view addSubview:imageGridView];
            NSLog(@"Grid View");
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [imageGridView removeFromSuperview];
    if([view.annotation isKindOfClass:[ImagePin class]]){
        view.bounds = CGRectMake(0, 0, 38, 38);
        ((UIImageView*)[view.subviews objectAtIndex:0]).frame = CGRectMake(0, -28, 56, 56);
        ((UIImageView*)[view.subviews objectAtIndex:1]).frame = CGRectMake(7, -23, 38, 38);
        [imageGridView removeFromSuperview];
    }
}

// Show searched location
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {  
    if(self.search.text != nil) [self showAddress:[self addressLocation]];
}

// Show current location
- (IBAction)showCurrentLocation:(id)sender {
    [self.myMap setCenterCoordinate:self.locationManager.location.coordinate animated:TRUE];
}


- (NSUInteger) numberOfImagesInImageGridView:(MTImageGridView *)imageGridView
{
    return [listImageToShow count];
}

-(NSURL*) imageURLAtIndex:(NSUInteger)index{
    return [((ImagePin*)((MKAnnotationView*)[listImageToShow objectAtIndex:index]).annotation) getURL];
}

-(void) imageTappedAtIndex:(NSUInteger)index{
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.search.delegate = self;
    self.myMap.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
        
    imageGridView = [[MTImageGridView alloc] init];
    imageGridView.frame = CGRectMake(50, 50, 200, 200);
    imageGridView.numberOfImagesPerRow = 4;
    imageGridView.gridDelegate = self;
    imageGridView.gridDataSource = self;
    imageGridView.canRefresh = FALSE;
    imageGridView.haveNextPage = FALSE;
    [imageGridView setBackgroundColor:[UIColor colorWithRed:0.47f green:0.23f blue:0.61f alpha:0.3f]];
    
    fetcher = [[MTFetcher alloc] init];
    [fetcher setDelegate:self];
    
    listImageToShow = [[NSMutableArray alloc] init];
    
    // JUST FOR TEST
    [self fetchedData:@"cat" withUserID:@"1d6311db-6a2e-4362-a3c3-2a7a7814f7a4"];
}

- (void)viewDidUnload
{
    [self setSearch:nil];
    [self setMyMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
