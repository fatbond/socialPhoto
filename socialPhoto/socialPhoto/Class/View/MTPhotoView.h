//
//  MTPhotoView.h
//  socialPhoto
//
//  Created by Le Quan on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTPhotoView : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIImagePickerController *picker;
}

@end
