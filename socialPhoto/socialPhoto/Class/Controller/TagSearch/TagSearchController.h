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

@protocol TagSearchControllerDelegate;

@interface TagSearchController : UIViewController
                                <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *favoriteTags;

@property (strong, nonatomic) NSArray *frequentTags;

@property (strong, nonatomic) NSArray *recommendTags;

@property (strong, nonatomic) NSArray *favoriteNumberPost;

@property (strong, nonatomic) NSArray *frequentNumberPost;

@property (strong, nonatomic) NSArray *recommendNumberPost;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *xButton;

@property (unsafe_unretained, nonatomic) id <TagSearchControllerDelegate> tagDelegate;

- (IBAction)xPressed:(id)sender;

@end

@protocol TagSearchControllerDelegate

- (void)didFinishedSearchingWithTag:(NSString *)photoTag;

@end