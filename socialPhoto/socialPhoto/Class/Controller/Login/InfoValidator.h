//
//  ValidateInfo.h
//  SignUpApp
//
//  Created by Dinh Chinh on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoValidator : UIView

// Check if username doesn't have any invalid character
- (BOOL) validateCharacters:(NSString*)myString;

// Check if password has only number
- (BOOL) validateNumbers:(NSString*)myPassword;

// Check if username or password is emty
- (BOOL) checkEmpty:(NSString *)myUsername and:(NSString *)myPassword;

// Check if username's length is invalid
- (BOOL) checkUsernameLength:(NSString *)myUsername;

// Check if password's length is invalid
- (BOOL) checkPasswordLength:(NSString *)myPassword;

@end
