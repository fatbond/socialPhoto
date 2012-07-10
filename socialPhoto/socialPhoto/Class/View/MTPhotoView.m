//
//  MTPhotoView.m
//  socialPhoto
//
//  Created by Le Quan on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTPhotoView.h"

@implementation MTPhotoView

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {   
    NSLog(@"Cancel");
    [Picker dismissModalViewControllerAnimated:YES];   
}

- (void)imagePickerController:(UIImagePickerController *) Picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Select");
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        NSLog(@"Camera");
    } 
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) 
    {
        NSLog(@"Library");
        [Picker dismissModalViewControllerAnimated:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [self presentModalViewController:picker animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
