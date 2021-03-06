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
    int heightButton = 47;
    for(UIButton *b in myTabButton)
    {
      CGRect rect = CGRectMake(widthButton*b.tag, 433, widthButton, heightButton);
      b.frame = rect;
    }
    [self.view addSubview:button];
  }   
}

- (void) changeBackgroundImage:(UIImage*)backgroundImage
{
  UIImageView* bgView = [[UIImageView alloc] initWithImage:backgroundImage];
  bgView.frame = CGRectMake(0, 433, 320, 47);
  [self.view addSubview:bgView];
}

- (void) addTabItemWithImage:(NSString*) normalImageName
            andSelectedImage:(NSString*) selectedImageName
                  andTabName:(NSString *)tabName
{
  // Create the button
  UIButton *button = [self buttonWithImage:[UIImage imageNamed:normalImageName] selectedState:[UIImage imageNamed:selectedImageName]];
  
  // Set its tabName
  CGRect tabLabelFrame = button.frame;
  tabLabelFrame.origin.y += 30;
  tabLabelFrame.size.height -= 12;
  UILabel *tabLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, 64, 22)];
  tabLabel.text = tabName;
  tabLabel.textAlignment = UITextAlignmentCenter;
  tabLabel.textColor = [UIColor whiteColor];
  tabLabel.backgroundColor = [UIColor clearColor];
  tabLabel.font = [UIFont boldSystemFontOfSize:12];
  [button addSubview:tabLabel];
  
  // Add it to the tabBar
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
