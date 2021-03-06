//
//  ContactViewController.m
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "PFContactViewController.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

BOOL loadContact;
BOOL noDataContact;
BOOL refreshDataContact;

int contactInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.contactOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navItem.title = @"Contact";
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getContactBranches];
    
    self.branchLabel.text = @"Our Branches";
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    loadContact = NO;
    noDataContact = NO;
    refreshDataContact = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.tableView.tableHeaderView = self.headerView;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = fv;
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    [self.branchBt.layer setMasksToBounds:YES];
    [self.branchBt.layer setCornerRadius:5.0f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)refresh:(UIRefreshControl *)refreshControl {

    [self.Api getContactBranches];

}

- (void)PFApi:(id)sender getContactBranchesResponse:(NSDictionary *)response {
    //NSLog(@"contactBranch %@",response);
    
    [self.Api getContact];
    
    [self.contactOffline setObject:response forKey:@"contactMap"];
    [self.contactOffline synchronize];
    
    NSString *urlmap1 = @"http://maps.googleapis.com/maps/api/staticmap?center=";
    
    NSMutableArray *pointmap = [[NSMutableArray alloc] initWithCapacity:[[response objectForKey:@"data"] count]];
    for (int i=0; i < [[response objectForKey:@"data"] count]; i++) {
        NSString *pointchar = [NSString alloc];
        if (i == [[response objectForKey:@"data"] count]-1) {
            pointchar  = [NSString stringWithFormat:@"%@%@%@", [[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"]];
        } else {
            pointchar  = [NSString stringWithFormat:@"%@%@%@%@", [[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"],@","];
        }
        [pointmap addObject:pointchar];
    }
    
    NSMutableString * resultpoint = [[NSMutableString alloc] init];
    for (NSObject * obj in pointmap)
    {
        [resultpoint appendString:[obj description]];
    }
    
    NSString *urlmap2 = resultpoint;
    
    NSString *urlmap3 = @"&zoom=8&size=600x300&sensor=false";
    
    NSMutableArray *locationmap = [[NSMutableArray alloc] initWithCapacity:[[response objectForKey:@"data"] count]];
    for (int i=0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        
        NSString *locationchar = [NSString alloc];
        
        locationchar  = [NSString stringWithFormat:@"%@%@%@%@",@"&markers=color:red%7Clabel:o%7C",[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"]];
        
        [locationmap addObject:locationchar];
    }
    
    self.locationSum = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[[response objectForKey:@"data"] count]];
    
    NSMutableString * resultlocation = [[NSMutableString alloc] init];
    for (NSObject * obj in locationmap)
    {
        [resultlocation appendString:[obj description]];
    }
    NSString *urlmap4 = resultlocation;
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@",urlmap1,urlmap2,urlmap3,urlmap4];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImg.image = [UIImage imageWithData:imgData];
                          }];
    
    
}

- (void)PFApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.Api getContact];
    
    NSString *urlmap1 = @"http://maps.googleapis.com/maps/api/staticmap?center=";
    
    NSMutableArray *pointmap = [[NSMutableArray alloc] initWithCapacity:[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] count]];
    for (int i=0; i < [[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] count]; i++) {
        NSString *pointchar = [NSString alloc];
        if (i == [[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] count]-1) {
            pointchar  = [NSString stringWithFormat:@"%@%@%@", [[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"]];
        } else {
            pointchar  = [NSString stringWithFormat:@"%@%@%@%@", [[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"],@","];
        }
        [pointmap addObject:pointchar];
    }
    
    NSMutableString * resultpoint = [[NSMutableString alloc] init];
    for (NSObject * obj in pointmap)
    {
        [resultpoint appendString:[obj description]];
    }
    
    NSString *urlmap2 = resultpoint;
    
    NSString *urlmap3 = @"&zoom=8&size=600x300&sensor=false";
    
    NSMutableArray *locationmap = [[NSMutableArray alloc] initWithCapacity:[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] count]];
    for (int i=0; i < [[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] count]; i++) {
        
        [self.arrObj addObject:[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i]];
        
        NSString *locationchar = [NSString alloc];
        
        locationchar  = [NSString stringWithFormat:@"%@%@%@%@",@"&markers=color:red%7Clabel:o%7C",[[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[[[self.contactOffline objectForKey:@"contactMap"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"]];
        
        [locationmap addObject:locationchar];
    }
    
    NSMutableString * resultlocation = [[NSMutableString alloc] init];
    for (NSObject * obj in locationmap)
    {
        [resultlocation appendString:[obj description]];
    }
    NSString *urlmap4 = resultlocation;
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@",urlmap1,urlmap2,urlmap3,urlmap4];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImg.image = [UIImage imageWithData:imgData];
                          }];
    
}

- (void)PFApi:(id)sender getContactResponse:(NSDictionary *)response {
    //NSLog(@"contact %@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    [self.contactOffline setObject:response forKey:@"contactArray"];
    [self.contactOffline synchronize];
    
    self.websiteLabel.text = [response objectForKey:@"website"];
    self.emailLabel.text = [response objectForKey:@"email"];
    self.facebookLabel.text = [response objectForKey:@"facebook"];
}

- (void)PFApi:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    contactInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    self.websiteLabel.text = [[self.contactOffline objectForKey:@"contactArray"] objectForKey:@"website"];
    self.emailLabel.text = [[self.contactOffline objectForKey:@"contactArray"] objectForKey:@"email"];
    self.facebookLabel.text = [[self.contactOffline objectForKey:@"contactArray"] objectForKey:@"facebook"];
}

- (void)countDown {
    contactInt -= 1;
    if (contactInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (IBAction)mapTapped:(id)sender {
    
    [self.NoInternetView removeFromSuperview];
    
    [self.delegate HideTabbar];
    PFMapAllViewController *mapView = [[PFMapAllViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        mapView = [[PFMapAllViewController alloc] initWithNibName:@"PFMapAllViewController_Wide" bundle:nil];
    } else {
        mapView = [[PFMapAllViewController alloc] initWithNibName:@"PFMapAllViewController" bundle:nil];
    }
    mapView.delegate = self;
    mapView.arrObj = self.arrObj;
    mapView.locationSum = self.locationSum;
    self.navItem.title = @" ";
    [self.navController pushViewController:mapView animated:YES];
    
}

- (IBAction)branchTapped:(id)sender {
    
    [self.NoInternetView removeFromSuperview];
    
    [self.delegate HideTabbar];
    PFBranchesViewController *branchesView = [[PFBranchesViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        branchesView = [[PFBranchesViewController alloc] initWithNibName:@"PFBranchesViewController_Wide" bundle:nil];
    } else {
        branchesView = [[PFBranchesViewController alloc] initWithNibName:@"PFBranchesViewController" bundle:nil];
    }
    branchesView.delegate = self;
    branchesView.arrObj = self.arrObj;
    self.navItem.title = @" ";
    [self.navController pushViewController:branchesView animated:YES];
    
}

- (IBAction)webTapped:(id)sender {
    
    [self.NoInternetView removeFromSuperview];
    
    if (![self.websiteLabel.text isEqualToString:@""]) {
        NSString *website = [[NSString alloc] initWithFormat:@"%@",self.websiteLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    }
    
}

- (IBAction)emailTapped:(id)sender {
    
    [self.NoInternetView removeFromSuperview];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
    
}

- (IBAction)facebookTapped:(id)sender {
    
    [self.NoInternetView removeFromSuperview];
    
    if (![self.facebookLabel.text isEqualToString:@""]) {
        [self.delegate HideTabbar];
        PFWebViewController *webView = [[PFWebViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController_Wide" bundle:nil];
        } else {
            webView = [[PFWebViewController alloc] initWithNibName:@"PFWebViewController" bundle:nil];
        }
        
        NSString *getweb = self.facebookLabel.text;
        webView.url = getweb;
        webView.delegate = self;
        self.navItem.title = @" ";
        [self.navController pushViewController:webView animated:YES];
    }
    
}

- (IBAction)powerbyTapped:(id)sender {
    [self.NoInternetView removeFromSuperview];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        
        // Email Subject
        NSString *emailTitle = nil;
        // Email Content
        NSString *messageBody = nil;
        // To address
        NSArray *toRecipents = [self.emailLabel.text componentsSeparatedByString: @","];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//full image
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

//back to contact page

- (void)PFMapAllViewControllerBack {
    [self.delegate ShowTabbar];
    self.navItem.title = @"Contact";
}

- (void)PFBranchesViewControllerBack {
    [self.delegate ShowTabbar];
    self.navItem.title = @"Contact";
}

- (void) PFWebViewControllerBack {
    [self.delegate ShowTabbar];
    self.navItem.title = @"Contact";
}

@end
