//
//  MTAppDelegate.h
//  socialPhoto
//
//  Created by ltt on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"
#import "MTMapController.h"
#import "MTTopController.h"
#import "MTPhotoView.h"
#import "MTLoginController.h"

@interface MTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBarController *tab;

@end
