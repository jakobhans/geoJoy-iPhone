//
//  moreInfoViewController.m
//  geoJoy
//
//  Created by Jakob Hans Renpening on 22/08/11.
//  Copyright 2011 Claim Soluciones, S.C.P. All rights reserved.
//

#import "moreInfoViewController.h"

@implementation moreInfoViewController

-(void)checkForConnection {
    ConnectedClass *connection = [[ConnectedClass alloc] init];
    
    if ([connection connected] == NO) {
        UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"Internet Connection" message:@"This application needs an internet connection to work properly. Please activate either a WiFi or a cellular data connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertDialog show];
        [alertDialog release];
    }
    
    [connection release];
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

-(IBAction)openRepoInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/ClaimSoluciones/geoJoy-iPhone"]];
}

-(IBAction)openClaimInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.claimsoluciones.com"]];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [self checkForConnection];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
