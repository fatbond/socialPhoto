//
//  TagSearchController.m
//  TagSearcher
//
//  Created by ngocluan on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagSearchController.h"

@interface TagSearchController ()

@property (assign, nonatomic) BOOL beginEditing;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL searched;

@end

@implementation TagSearchController

@synthesize favoriteTags = _favoriteTags;
@synthesize frequentTags = _frequentTags;
@synthesize recommendTags = _recommendTags;
@synthesize favoriteNumberPost = _favoriteNumberPost;
@synthesize frequentNumberPost = _frequentNumberPost;
@synthesize recommendNumberPost = _recommendNumberPost;
@synthesize searchBar = _searchBar;
@synthesize beginEditing = _beginEditing;
@synthesize searched = _searched;
@synthesize tableView = _tableView;
@synthesize xButton = _xButton;
@synthesize tagDelegate = _tagDelegate;

- (void)setBeginEditing:(BOOL)beginEditing
{
    _beginEditing = beginEditing;
    //NSLog(@"%@", _beginEditing ? @"yes" : @"no");
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TagSearchController" bundle:nil];
    if (self)
    {
        self.title = @"Tag search";
    }
    
    return self;
}

- (IBAction)xPressed:(id)sender
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 216);
    self.xButton.hidden = YES;
}

#pragma mark - ASIHTTPRequest delegate methods

- (void)grabURLInBackground:(NSString *) userId
{
    NSString *favoriteTagString = [NSString stringWithFormat:@"http://107.20.246.0/api/Photo/getFavouristTags?user_id=%@", userId];
    
    NSString *frequentTagString = [NSString stringWithFormat:@"http://107.20.246.0/api/Photo/getFrequentTags?user_id=%@", userId];
    
    NSURL *favoriteTagUrl = [NSURL URLWithString:favoriteTagString];
    
    NSURL *frequentTagUrl = [NSURL URLWithString:frequentTagString];
    
    // Create favorite request
    ASIHTTPRequest *favoriteTagRequest = [[ASIHTTPRequest alloc] initWithURL:favoriteTagUrl];
    favoriteTagRequest.tag = 1;
    [favoriteTagRequest setDelegate:self];
    // Start request
    [favoriteTagRequest startAsynchronous];
    
    // Create frequent request
    ASIHTTPRequest *frequentTagRequest = [[ASIHTTPRequest alloc] initWithURL:frequentTagUrl];
    frequentTagRequest.tag = 2;
    [frequentTagRequest setDelegate:self];
    // Start request
    [frequentTagRequest startAsynchronous];
}

- (void)grabRecommendTagURL:(NSString *) userId andKeyword:(NSString *) keyword
{
    NSString *recommendTagString = [NSString stringWithFormat:@"http://107.20.246.0/api/Photo/getListTagsRecommend?keyword=%@&user_id=%@", keyword, userId];
    
    NSURL *recommendTagUrl = [NSURL URLWithString:recommendTagString];
    
    // Create recommend request
    ASIHTTPRequest *recommendTagRequest = [[ASIHTTPRequest alloc] initWithURL:recommendTagUrl];
    recommendTagRequest.tag = 3;
    [recommendTagRequest setDelegate:self];
    // Start request
    [recommendTagRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching data
    if (request.tag == 1)
    {
        NSString *favoriteTagResponseString = [request responseString];
        
        NSDictionary *favoriteTagJson = [favoriteTagResponseString JSONValue];
        
        //self.favoriteTags = [[NSArray alloc] init];
        //self.favoriteNumberPost = [[NSArray alloc] init];
        
        self.favoriteTags = [favoriteTagJson valueForKeyPath:@"tag.tag_name"];
        self.favoriteNumberPost = [favoriteTagJson valueForKeyPath:@"tag.number_post"];
        
        [self.tableView reloadData];
    }
    if (request.tag == 2)
    {
        NSString *frequentTagResponseString = [request responseString];
        
        NSDictionary *frequentTagJson = [frequentTagResponseString JSONValue];
        
        //self.frequentTags = [[NSArray alloc] init];
        //self.frequentNumberPost = [[NSArray alloc] init];
        
        self.frequentTags = [frequentTagJson valueForKeyPath:@"tag.tag_name"];
        //self.frequentNumberPost = [frequentTagJson valueForKeyPath:@"tag.number_post"];
        
        [self.tableView reloadData];
    }
    if (request.tag == 3)
    {
        NSString *recommendTagResponseString = [request responseString];
        
        NSDictionary *recommendTagJson = [recommendTagResponseString JSONValue];
        
        //self.recommendTags = [[NSArray alloc] init];
        //self.recommendNumberPost = [[NSArray alloc] init];
        
        self.recommendTags = [recommendTagJson valueForKeyPath:@"tag.tag_name"];
        self.recommendNumberPost = [recommendTagJson valueForKeyPath:@"tag.number_post"];
        
        //NSLog(@"recommend tags: %@", self.recommendTags);
        //NSLog(@"recommend number_post: %@", self.recommendNumberPost);
        
        [self.tableView reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
}

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    //self.searchBar.delegate = self;
    self.beginEditing = NO;
    self.searched = NO;
    
    self.xButton.hidden = YES;

    UITextField *textField = nil;
    for (UIView *view in [self.searchBar subviews]) {
    if ([view isKindOfClass:[UITextField class]])
    {
        textField = (UITextField *)view;
    }
    }
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tag_search_bg.png"]];

    
    /*
    textField = nil;
    for (UIView *subview in self.searchBar.subviews) 
    {
        // we can't check if it is a UITextField because it is a UISearchBarTextField.
        // Instead we check if the view conforms to UITextInput protocol. This finds
        // the view we are after.
        if ([subview conformsToProtocol:@protocol(UITextInput)]) 
        {
            textField = (UITextField*)subview;
            break;
        }
    }
    
    if (textField != nil)
        [textField selectAll:self];
    textField.placeholder = @"yeah";
    
    CGRect frame = CGRectMake(0, 0, 20, 29);
    UITextField *search= [[UITextField alloc] initWithFrame:frame];
    textField = search;
    */
    
    UITextField *searchField = (UITextField *)[[self.searchBar subviews] objectAtIndex:0];
    
    searchField.frame = CGRectMake(0, 0, 160, 44);
    
    // Hide the clear button
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                [(UITextField *)subview setClearButtonMode:UITextFieldViewModeNever];
            }
    }
    
    
    [self.searchBar setTintColor:[UIColor grayColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"whiteBackground.png"] forState:UIControlStateNormal];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [button.layer setCornerRadius:5.0f];
    [button.layer setMasksToBounds:YES];
    //[button.layer setBorderWidth:1.0f];
    //[button.layer setBorderColor: [[UIColor grayColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 60.0, 30.0);
    [button addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
    /*
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"doneButtonIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = doneButton; // Create Done button
    */
    NSString *userId = @"1d6311db-6a2e-4362-a3c3-2a7a7814f7a4";
    
    [self grabURLInBackground:userId];
    
    [self.tableView reloadData];
}

// When done
- (IBAction)donePressed:(id)sender
{
    if (self.searchBar.text.length != 0)
    {
        [self.tagDelegate didFinishedSearchingWithTag:self.searchBar.text];
        // Back to the root page at which images are displayed
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    // Put code to display image...
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setXButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Search bar delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.tagDelegate didFinishedSearchingWithTag:self.searchBar.text];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // Put code to display image...
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 216);
    //searchBar
    
    NSLog(@"begin editing...");
    /*if (self.searched == YES)
    {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 216);
        [searchBar resignFirstResponder];
    }*/
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *userId = @"1d6311db-6a2e-4362-a3c3-2a7a7814f7a4";
    NSLog(@"searchBar:textDidChange: isFirstResponder: %i", [self.searchBar isFirstResponder]);
    if (searchText.length != 0)
    {
        self.xButton.hidden = NO;
        self.beginEditing = YES;
        self.searched = YES;
        NSLog(@"You type: %@", searchText);
        [self grabRecommendTagURL:userId andKeyword:searchText];
    }
    if (searchText.length == 0)
    {
        self.xButton.hidden = YES;
        self.beginEditing = NO;
        /*if (self.searched == YES)
        {
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 216);
            [searchBar resignFirstResponder];
        }*/
    }
    //NSLog(@"search length = %d", searchText.length);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"End editing...");
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"it's called");
    
    self.xButton.hidden = NO;
    
    return YES;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index1 = indexPath.row * (indexPath.section + 1);
    NSUInteger index2 = indexPath.row * (indexPath.section + 2);
    
    self.searchBar.text = [self.recommendTags objectAtIndex:indexPath.row];
    NSLog(@"begin editing = %d", self.beginEditing);
    
    if ((self.beginEditing == NO) && (indexPath.section == 0))
    {
        self.searchBar.text = [self.favoriteTags objectAtIndex:index1];
        [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    }
    
    if ((self.beginEditing == NO) && (indexPath.section == 1))
    {
        self.searchBar.text = [self.frequentTags objectAtIndex:index2];
        [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.beginEditing == YES)
    {
        return 1;
    }
    if (self.beginEditing == NO)
    {
        return 2;
    }
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.beginEditing == YES)
        return nil;
    else
    {
        switch (section)
        {
            case 0:
                return @"favorite";
                break;
            case 1:
                return @"frequent";
                break;
            default:
                return nil;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (self.beginEditing == YES)
    {
        rows = [self.recommendTags count];
    }
    else
    {
        if (section == 0)
        {
            rows = [self.favoriteTags count];
        }
        if (section == 1)
        {
            rows = [self.frequentTags count];
        }
    }
    
    return rows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:CellIdentifier];
    }
    
    if (self.beginEditing == YES)
    {
        cell.textLabel.text = [self.recommendTags objectAtIndex:indexPath.row];
        if ([self.recommendNumberPost count] != 0)
            cell.detailTextLabel.text = [[self.recommendNumberPost objectAtIndex:indexPath.row] stringValue];
    }
    else
    {
        if (indexPath.section == 0) //In favorite section
        {  
            cell.textLabel.text = [self.favoriteTags objectAtIndex:indexPath.row];
            if ([self.favoriteNumberPost count] != 0)
                cell.detailTextLabel.text = [[self.favoriteNumberPost objectAtIndex:indexPath.row] stringValue];
        }
        if (indexPath.section == 1) // In frequent section
        {
            cell.textLabel.text = [self.frequentTags objectAtIndex:indexPath.row];
            if ([self.frequentNumberPost count] != 0)
                cell.detailTextLabel.text = [[self.frequentNumberPost objectAtIndex:indexPath.row] stringValue];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

@end
