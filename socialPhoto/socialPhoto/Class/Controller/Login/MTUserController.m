//
//  MTUserController.m
//  socialPhoto
//
//  Created by Quan Le on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTUserController.h"
#import "MTLoginController.h"

@interface MTUserController ()

@end

@implementation MTUserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"User profile"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"UserID : %@", [MTLoginController getUserID]);
}
- (IBAction)logout:(id)sender {
    [MTLoginController setUserID:@""];
    [MTLoginController setDeviceToken:@""];
    MTLoginController *logged = [[MTLoginController alloc] initWithNibName:@"MTLoginController" bundle:nil];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:logged] animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
