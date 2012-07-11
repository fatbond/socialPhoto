//
//  MTLoginController.m
//  socialPhoto
//
//  Created by ltt on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTLoginController.h"
#import "InfoValidator.h"

static NSString* userID;
static NSString* deviceToken;

@implementation MTLoginController
@synthesize textField = _textfield;
@synthesize listData = _listData;
@synthesize tableView = _tableView;

+ (NSString*) getUserID{
    return userID;
}

+ (void) setUserID:(NSString*)newUserID{
    userID = [newUserID copy];
}

+ (NSString*) getDeviceToken{
    return deviceToken;
}

+ (void) setDeviceToken:(NSString*)newDeviceToken{
    deviceToken = [newDeviceToken copy];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Log in"];
    }
    return self;
}

- (void) grabURLInBackground:(NSString *) username andPassword:(NSString *) password
{
    //NSString *deviceToken = [UIDevice currentDevice].uniqueIdentifier;    
    NSURL *url = [NSURL URLWithString:@"http://107.20.246.0/api/Login/login"];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setPostValue:username forKey:@"user_name"];
    [request setPostValue:[password MD5] forKey:@"password"];
    [request setPostValue:@"" forKey:@"device_token"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Response string: %@", responseString);
    NSDictionary *json = [responseString JSONValue];
//    NSLog(@"%@", json);
    // Check if successfull or not
    Boolean isSuccess = [[json valueForKey:@"is_success"] boolValue];
    if(isSuccess){
        [MTLoginController setUserID:[json valueForKey:@"user_id"]];
//        NSLog(@"userId: %@", [MTLoginController getUserID]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are logged in" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        // Move to User View
        MTUserController *logged = [[MTUserController alloc] initWithNibName:@"MTUserController" bundle:nil];
        [self.navigationController pushViewController:logged animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username or password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    // Use when fetching binary data
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)donePressed:(id)sender
{
    UITextField *usernameTextField = (UITextField *)[self.view viewWithTag:1];
    UITextField *passwordTextField = (UITextField *)[self.view viewWithTag:2];
    
    NSString *username = usernameTextField.text;
    NSString *password = passwordTextField.text;
    
    NSString *userInfo = [[NSString alloc] initWithFormat:@"Username: %@\nPassword: %@", username, password];
    
    NSLog(@"%@", userInfo);
    
    InfoValidator *v = [InfoValidator alloc];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username or password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (([v checkEmpty:username and:password] == NO)||
        ([v checkUsernameLength:username] == NO)||
        ([v validateCharacters:username] == NO)||
        ([v checkPasswordLength:password] == NO)||
        ([v validateNumbers:password] == NO))
    {
        [alert show];
        return;
    }                       
    
    [self grabURLInBackground:username andPassword:password]; // Create request to server    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier;
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:kCellIdentifier];
        
        if ([indexPath section] == 0)
        {
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(125, 10, 170, 30)];
            self.textField.delegate = self;
            self.textField.adjustsFontSizeToFitWidth = YES;
            self.textField.textColor = [UIColor blackColor];
            self.textField.backgroundColor = [UIColor clearColor];
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.textAlignment = UITextAlignmentLeft;
            self.textField.clearButtonMode = UITextFieldViewModeWhileEditing; 
            [self.textField setEnabled: YES];
            
            if ([indexPath row] == 0) // Username
            {
                cell.textLabel.text = @"Username";
                self.textField.placeholder = @"required";
                self.textField.keyboardType = UIKeyboardTypeDefault;
                self.textField.returnKeyType = UIReturnKeyDone;
                self.textField.tag = 1;
                [self.textField becomeFirstResponder];
            }
            if ([indexPath row] == 1)
            {
                cell.textLabel.text = @"Password";
                self.textField.placeholder = @"required";
                self.textField.keyboardType = UIKeyboardTypeDefault;
                self.textField.returnKeyType = UIReturnKeyDone;
                self.textField.secureTextEntry = YES;
                self.textField.tag = 2;
                [self.textField becomeFirstResponder];
            }
            
            [cell.contentView addSubview:self.textField];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone; // Don't highlight when tapping
        }
        if ([indexPath section] == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue; // Highlight when tapping
            cell.textLabel.text = @"Forgot password?";
        }
    }
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    
    [self donePressed:self];
    
    return YES;
}

@end
