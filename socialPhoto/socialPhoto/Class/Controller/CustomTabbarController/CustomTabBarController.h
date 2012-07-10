//
//  Tab.h
//  CustomTab
//
//  Created by Le Quan on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController 

- (void) changeBackgroundImage:(UIImage*)backgroundImage;
- (void) addTabItemWithImage:(NSString*) normalImageName
         andSelectedImage:(NSString*) selectedImageName;
@end