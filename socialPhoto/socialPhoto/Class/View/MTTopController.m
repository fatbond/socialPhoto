//
//  MTTopController.m
//  socialPhoto
//
//  Created by Le Quan on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTTopController.h"

@interface MTTopController(){
    UISegmentedControl *segment;
}
@end

@implementation MTTopController
@synthesize navi = _navi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor blueColor]];  
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_bg.png"]];
    [self.navi addSubview:imgView];
    
//    segment = [[UISegmentedControl alloc] initWithItems:nil];
//    [segment insertSegmentWithImage:[UIImage imageNamed:@"tab_mesh.png"] atIndex:1 animated:true];
//    [segment insertSegmentWithImage:[UIImage imageNamed:@"tab_shot.png"] atIndex:2 animated:true];
//    [segment insertSegmentWithImage:[UIImage imageNamed:@"tab_user.png"] atIndex:3 animated:true];
//    [segment setMomentary:true];
//    segment.segmentedControlStyle = UISegmentedControlStylePlain;
//    segment.frame = CGRectMake(0, 0, 90, 30);
//    [segment setMomentary:YES];
//    
//    [self.view addSubview:segment];
}

- (void)viewDidUnload
{
    [self setNavi:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
