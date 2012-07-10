//
//  MTAppDelegate.m
//  socialPhoto
//
//  Created by ltt on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTAppDelegate.h"

#import "MTMeshViewController.h"

@implementation MTAppDelegate

@synthesize window = _window;
@synthesize tab = _tab;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tab = [[CustomTabBarController alloc] init];
    [self.tab changeBackgroundImage:[UIImage imageNamed:@"tab_bg.png"]];  
    
  MTMeshViewController *vc1 = [[MTMeshViewController alloc] init];
    MTMapController *vc2 = [[MTMapController alloc] init];
    MTPhotoView *vc3 = [[MTPhotoView alloc] init];
    UIViewController *vc4 = [[UIViewController alloc] init];
    UIViewController *vc5 = [[UIViewController alloc] init];
    
    [self.tab addTabItemWithImage:@"tab_mesh.png" andSelectedImage:@"tab_mesh_active.png"];
    [self.tab addTabItemWithImage:@"tab_trend_tag.png" andSelectedImage:@"tab_trend_tag_active.png"];
    [self.tab addTabItemWithImage:@"tab_shot.png" andSelectedImage:@"tab_shot_active.png"];
    [self.tab addTabItemWithImage:@"tab_timeline.png" andSelectedImage:@"tab_timeline_active.png"];
    [self.tab addTabItemWithImage:@"tab_user.png" andSelectedImage:@"tab_user_active.png"];
    
    
    NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5, nil];
    
    [self.tab setViewControllers:viewControllers];
    
    [self.window addSubview:[self.tab view]];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
