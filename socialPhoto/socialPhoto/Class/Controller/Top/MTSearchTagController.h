//
//  TagSearchController.h
//  TagSearcher
//
//  Created by ngocluan on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@protocol MTSearchTagControllerDelegate;

@interface MTSearchTagController : UIViewController
                                <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *favoriteTags;

@property (strong, nonatomic) NSArray *frequentTags;

@property (strong, nonatomic) NSArray *recommendTags;

@property (strong, nonatomic) NSArray *favoriteNumberPost;

@property (strong, nonatomic) NSArray *frequentNumberPost;

@property (strong, nonatomic) NSArray *recommendNumberPost;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *xButton;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

@property (unsafe_unretained, nonatomic) id <MTSearchTagControllerDelegate> tagDelegate;

@property (strong, nonatomic) NSString *userId;

- (IBAction)xPressed:(id)sender;

@end

@protocol MTSearchTagControllerDelegate

- (void)didFinishedSearchingWithTag:(NSString *)photoTag;

@end