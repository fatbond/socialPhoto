//
//  Tab.m
//  CustomTab
//
//  Created by Le Quan on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController(){
    NSMutableArray *myTabButton;
    int     numberOfButton;
}
@end

@implementation CustomTabBarController

- (UIButton *)   buttonWithImage:(UIImage *)normal
                 selectedState:(UIImage *)select
{
    // Initialise our two images
    UIButton* bufferButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bufferButton setBackgroundImage:normal forState:UIControlStateNormal]; 
    [bufferButton setBackgroundImage:select forState:UIControlStateSelected]; 
    [bufferButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return bufferButton;
}

- (void)addButton:(UIButton*)button
{
    if(myTabButton == nil) 
    {
        numberOfButton = 0;
        myTabButton = [[NSMutableArray alloc] init];
        [self addButton:button];
    }
    else
    {
        [button setTag:numberOfButton++]; 
        [myTabButton addObject:button];
        int widthScreen = 320;
        int widthButton = widthScreen/numberOfButton;
        int heightButton = 60;
        for(UIButton *b in myTabButton)
        {
            CGRect rect = CGRectMake(widthButton*b.tag, 420, widthButton, heightButton);
            b.frame = rect;
        }
        [self.view addSubview:button];
    } 
    
    [[myTabButton objectAtIndex:0] setSelected:true];
}

- (void) changeBackgroundImage:(UIImage*)backgroundImage
{
    UIImageView* bgView = [[UIImageView alloc] initWithImage:backgroundImage];
    bgView.frame = CGRectMake(0, 420, 320, 60);
    [self.view addSubview:bgView];
}

- (void) addTabItemWithImage:(NSString*) normalImageName
         andSelectedImage:(NSString*) selectedImageName
{
    UIButton *button = [self buttonWithImage:[UIImage imageNamed:normalImageName] selectedState:[UIImage imageNamed:selectedImageName]];
    [self addButton:button];
}

- (void)selectTab:(int)tabID
{
    for(UIButton *b in myTabButton)
        [b setSelected:false];
    [[myTabButton objectAtIndex:tabID] setSelected:true];  
    self.selectedIndex = tabID;
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}

@end
