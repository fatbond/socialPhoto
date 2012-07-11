//
//  MTLoginController.h
//  socialPhoto
//
//  Created by ltt on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "NSString+MD5.h"
#import "MTUserController.h"

@interface MTLoginController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ASIHTTPRequestDelegate>

+ (NSString*) userID;
+ (NSString*) deviceToken;

@property (nonatomic, retain) NSArray *listData;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UITextField *textField;

+ (NSString*) getUserID;

@end
