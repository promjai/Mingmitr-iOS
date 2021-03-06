//
//  UpdateViewController.m
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadFeed;
BOOL noDataFeed;
BOOL refreshDataFeed;

int updateInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.feedOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navItem.title = @"Update";
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getFeed:@"15" link:@"NO"];
    
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
    
    [self.Api checkBadge];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkN:) userInfo:nil repeats:YES];
    
    [self BarButtonItem];
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableHeaderView = hv;
    self.tableView.tableFooterView = fv;
    
    loadFeed = NO;
    noDataFeed = NO;
    refreshDataFeed = NO;
    
    [self.feedOffline setObject:@"0" forKey:@"feed_updated"];
    
    self.arrObj = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)checkN:(NSTimer *)timer
{
    if ([self.Api checkLogin] == 1){
        [self.Api checkBadge];
    }
}

- (void)PFApi:(id)sender checkBadgeResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    //NSLog(@"%@",[response objectForKey:@"length"]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];
    
}
- (void)PFApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];
}

-(void)BarButtonItem {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_setting"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *badge = [[NSString alloc] initWithFormat:@"%@",[def objectForKey:@"badge"]];
    
    //notification if (noti = 0) else
    if ([[def objectForKey:@"badge"] intValue] == 0) {
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_notification"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
        self.navItem.rightBarButtonItem = rightButton;
        
    } else {
        
        UIButton *toggleKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleKeyboardButton.bounds = CGRectMake( 0, 0, 21, 21 );
        [toggleKeyboardButton setTitle:badge forState:UIControlStateNormal];
        [toggleKeyboardButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [toggleKeyboardButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        toggleKeyboardButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [toggleKeyboardButton setBackgroundColor:[UIColor clearColor]];
        [toggleKeyboardButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [toggleKeyboardButton.layer setBorderWidth: 1.0];
        [toggleKeyboardButton.layer setCornerRadius:10.0f];
        [toggleKeyboardButton addTarget:self action:@selector(notify) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:toggleKeyboardButton];
        self.navItem.rightBarButtonItem = rightButton;
        
    }
    
    self.navItem.leftBarButtonItem = leftButton;
}

- (void)account {
    
    if ([self.Api checkLogin] == 0){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"account";
        [self.view addSubview:self.loginView.view];
        
    } else{
        
        [self.delegate HideTabbar];
        
        PFAccountViewController *account = [[PFAccountViewController alloc] init];
        if(IS_WIDESCREEN) {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
        } else {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
        }
        account.delegate = self;
        self.navItem.title = @" ";
        [self.navController pushViewController:account animated:YES];
        
    }
    
}

- (void)PFAccountViewController:(id)sender{
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFAccountViewController *account = [[PFAccountViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
    } else {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
    }
    account.delegate = self;
    [self.navController pushViewController:account animated:YES];
    
}

- (void)notify {
    
    if ([self.Api checkLogin] == 0){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.delegate = self;
        self.loginView.menu = @"notify";
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        [self.delegate HideTabbar];
        
        PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
        } else {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
        }
        
        notify.delegate = self;
        self.navItem.title = @" ";
        [self.navController pushViewController:notify animated:YES];
        
    }
    
}

- (void)PFNotificationViewController:(id)sender {
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    notify.delegate = self;
    [self.navController pushViewController:notify animated:YES];
    
}

- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response {
    //NSLog(@"feed %@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.obj = response;
    
    if (!refreshDataFeed) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataFeed = YES;
    } else {
        noDataFeed = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.feedOffline setObject:response forKey:@"feedArray"];
    [self.feedOffline synchronize];
    
    if ([[self.feedOffline objectForKey:@"feed_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.feedOffline setObject:[response objectForKey:@"last_updated"] forKey:@"feed_updated"];
    }
    
}

- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    updateInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataFeed) {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.feedOffline objectForKey:@"feed_updated"] intValue] != [[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.feedOffline setObject:[[self.feedOffline objectForKey:@"feedArray"]objectForKey:@"last_updated"] forKey:@"feed_updated"];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataFeed = YES;
    [self.Api getFeed:@"15" link:@"NO"];
    
}

- (void)countDown {
    updateInt -= 1;
    if (updateInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCell"];
    
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.NoInternetView removeFromSuperview];
    [self.delegate HideTabbar];
    
    PFUpdateDetailViewController *detailView = [[PFUpdateDetailViewController alloc] init];
    if(IS_WIDESCREEN) {
        detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController_Wide" bundle:nil];
    } else {
        detailView = [[PFUpdateDetailViewController alloc] initWithNibName:@"PFUpdateDetailViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    detailView.obj = [self.arrObj objectAtIndex:indexPath.row];
    detailView.delegate = self;
    [self.navController pushViewController:detailView animated:YES];
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataFeed) {
            refreshDataFeed = NO;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.Api getFeed:@"NO" link:self.paging];
            }
            
        }
    }
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFAccountViewControllerBack {
    self.navItem.title = @"Update";
    [self.delegate ShowTabbar];
    
}

- (void)PFUpdateDetailViewControllerBack {
    self.navItem.title = @"Update";
    [self.delegate ShowTabbar];
    
}

- (void)PFNotificationViewControllerBack {
    self.navItem.title = @"Update";
    [self.delegate ShowTabbar];
}

@end
