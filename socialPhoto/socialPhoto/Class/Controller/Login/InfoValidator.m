//
//  ValidateInfo.m
//  SignUpApp
//
//  Created by Dinh Chinh on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoValidator.h"

@implementation InfoValidator

#define MIN_CHARACTERS_USERNAME 4
#define MAX_CHARACTERS_USERNAME 16
#define MIN_CHARACTERS_PASSWORD 5
#define MAX_CHARACTERS_PASSWORD 32

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Check if username doesn't have any invalid character
- (BOOL) validateCharacters:(NSString*)myString
{
    char c;
    bool flag = true;
    
    for (int i = 0; i < myString.length; i++)
    {
        c = [myString characterAtIndex:i];
        if (((int)c < 48) || ((int)c > 57 && (int)c < 65) || ((int)c > 90 && (int)c < 95) || ((int)c > 95 && (int)c < 97) || ((int)c > 122))
        {
            flag = false;
            break;
        }
    }
    if (flag == true)
        return YES; // Username is valid
    else
        return NO;  // Username has invalid character
}

// Check if password has only number
- (BOOL) validateNumbers:(NSString*)myPassword
{
    char c;
    bool flag = true;
    
    for (int i = 0; i < myPassword.length; i++)
    {
        c = [myPassword characterAtIndex:i];
        if (((int)c < 48) || (int)c > 57)
        {
            flag = false;
            break;
        }
        
    }
    if (flag == true)
        return YES; // Valid password
    else
        return NO; // Invalid password
}

// Check if username or password is emty
- (BOOL) checkEmpty:(NSString *)myUsername and:(NSString *)myPassword
{
    BOOL flag = YES;
    
    if ((myUsername.length == 0) || (myPassword.length == 0))
        flag = NO;
    
    return flag;
}

// Check if username's length is invalid
- (BOOL) checkUsernameLength:(NSString *)myUsername
{
    if ((myUsername.length < MIN_CHARACTERS_USERNAME) || (myUsername.length > MAX_CHARACTERS_USERNAME))
        return NO;
    else
        return YES;
}

// Check if password's length is invalid
- (BOOL) checkPasswordLength:(NSString *)myPassword
{
    if ((myPassword.length < MIN_CHARACTERS_PASSWORD) || (myPassword.length > MAX_CHARACTERS_PASSWORD))
        return NO;
    else
        return YES;
}

@end
