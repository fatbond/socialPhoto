//
//  MapViewController.m
//  MapAppGrid
//
//  Created by Le Quan on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
#define URL [NSURL URLWithString:@"http://ec2-107-20-246-0.compute-1.amazonaws.com/api/View/getListPhotoByTags?user_id=1d6311db-6a2e-4362-a3c3-2a7a7814f7a4&tag=cat&page_index=1"] 

#import "MapViewController.h"

@interface MapViewController(){
@private
    SBJsonParser *parser;    
    MapPin *addAnnotation;
    NSMutableArray *listImageToShow;
    ImageGridView *imageGridView;
}
@end

@implementation MapViewController
@synthesize search = _search;
@synthesize myMap = _myMap;
@synthesize locationManager = _locationManager;

- (CLLocationCoordinate2D) addressLocation {
    // Construct Google API for searching
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&key=YourGoogleMapAPIKey", 
                           [self.search.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    // Get result data from Google API, a CSV string
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
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
    addAnnotation = [[MapPin alloc] initWithCoordinate:location];
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

- (void)fetchedData{
    //parse out the json data   
    NSString *string = [NSString stringWithContentsOfURL:URL];
    
    NSDictionary *json = [string JSONValue];
    
    NSArray* album = [json objectForKey:@"photo"];
    
    int i = 0;
    
    for(NSDictionary *photo in album){    
        NSNumber *lon = [photo objectForKey:@"longitude"];
        NSNumber *lat = [photo objectForKey:@"latitude"];
        NSURL *imageURL = [NSURL URLWithString:[photo objectForKey:@"url_thumb"]];
        
        float flon = [lon floatValue];
        float flat = [lat floatValue];
        
        if((flon < 0)||(flon > 180)) ;
        else if((flat < -90)&&(flat > 90)) ;
        else {
            NSLog(@"Lon(%f) + Lat(%f)", flon, flat);
            [self pinImageWithURL:imageURL atLongitude:flon atLatitude:flat];
            i++;
        }
        
        // if(i >= 3) break; // Only load 3 image
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    static NSString *ImagePinID = @"imagePinID";
      
    if([annotation isKindOfClass:[MapPin class]]){
        MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        annView.pinColor = MKPinAnnotationColorRed;
        annView.animatesDrop = YES;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        return annView;
    }
    
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
//        annView.canShowCallout = NO;
//        annView.calloutOffset = CGPointMake(0, 0);
       
        [annView insertSubview:bgView atIndex:0];
        [annView insertSubview:myView atIndex:1];
        
        return annView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[ImagePin class]]){        
        NSLog(@"====");
        
        [listImageToShow removeAllObjects];
        
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
    }
}

// Show searched location
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {  
    if(self.search.text != nil) [self showAddress:[self addressLocation]];
}
- (IBAction)showCurrentLocation:(id)sender {
    [self.myMap setCenterCoordinate:self.locationManager.location.coordinate animated:TRUE];
}


- (NSInteger) numberOfImagesInImageGridView:(ImageGridView *)imageGridView
{
    return [listImageToShow count];
}

-(NSURL*) imageURLAtIndex:(NSUInteger)index
{
    return [((ImagePin*)((MKAnnotationView*)[listImageToShow objectAtIndex:index]).annotation) getURL];
}

-(void) imageTappedAtIndex:(NSUInteger)index
{
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
    
    //[self.search setBackgroundImage:[UIImage imageNamed:@"search_form_bg.png"]];
    
    imageGridView = [[ImageGridView alloc] init];
    imageGridView.frame = CGRectMake(50, 50, 200, 200);
    imageGridView.numberOfImagesPerRow = 4;
    imageGridView.delegate = self;
    imageGridView.dataSource = self;
    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *opearation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(fetchedData) object:nil];
    [myQueue addOperation:opearation];
    
    listImageToShow = [[NSMutableArray alloc] init];
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
