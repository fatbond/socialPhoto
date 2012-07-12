//
//  MTUserController.m
//  socialPhoto
//
//  Created by Quan Le on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTUserController.h"
#import "MTLoginController.h"

#import <QuartzCore/QuartzCore.h>

@interface MTUserController ()

@end

@implementation MTUserController
@synthesize userImage = _userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    [self setTitle:@"User profile"];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.0/255.0
                                                  green:234.0/255.0
                                                   blue:229.0/255.0
                                                  alpha:1.0]];
    
    self.userImage.layer.shadowOpacity = 0.5;
    __unsafe_unretained UIImageView *userImage = self.userImage;
    [self.userImage setImageWithURL:[NSURL URLWithString:[MTLoginController getUserImageURL]] 
                   placeholderImage:nil 
                            success:^(UIImage *image, BOOL fromCache) {
                              __strong UIImageView *strongUserImage = userImage;
                              strongUserImage.alpha = 0.0;
                              [UIView animateWithDuration:1.0
                                               animations:^{                                                 
                                                 strongUserImage.alpha = 1.0;
                                               }];
                            } failure:^(NSError *error) {
                              
                            }];
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
  [self setUserImage:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
