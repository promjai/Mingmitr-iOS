//
//  MenuViewController.m
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "PFMenuViewController.h"

@interface PFMenuViewController ()

@end

@implementation PFMenuViewController

BOOL loadMenu;
BOOL noDataMenu;
BOOL refreshDataMenu;

int menuInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.drinkOffline = [NSUserDefaults standardUserDefaults];
        self.dessertOffline = [NSUserDefaults standardUserDefaults];
        self.beansOffline = [NSUserDefaults standardUserDefaults];
        self.franchiseOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.waitView];
    [self startSpin];
    
    // Navbar setup
    [[self.navController navigationBar] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
    
    [[self.navController navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    loadMenu = NO;
    noDataMenu = NO;
    refreshDataMenu = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = fv;
    
    [self.segmented setBackgroundColor:[UIColor clearColor]];
    [self.segmented setTintColor:RGB(255,255,255)];
    CALayer *segmented = [self.segmented layer];
    [segmented setMasksToBounds:YES];
    [segmented setCornerRadius:5.0f];
    
    [self.segmented addTarget:self
                       action:@selector(segmentselect:)
             forControlEvents:UIControlEventValueChanged];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    [self.Api getDrink:@"15" link:@"NO"];
    
    self.checksegmented = @"0";
    self.checkstatus = @"refresh";
    
    [self.drinkOffline setObject:@"0" forKey:@"drink_updated"];
    [self.dessertOffline setObject:@"0" forKey:@"dessert_updated"];
    [self.beansOffline setObject:@"0" forKey:@"beans_updated"];
    [self.franchiseOffline setObject:@"0" forKey:@"franchise_updated"];
    
    self.arrObjDrink = [[NSMutableArray alloc] init];
    self.arrObjDessert = [[NSMutableArray alloc] init];
    self.arrObjBeans = [[NSMutableArray alloc] init];
    self.arrObjFranchise = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        refreshDataMenu = YES;
        [self.Api getDrink:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
        
    } else if ([self.checksegmented isEqualToString:@"1"]) {
        
        refreshDataMenu = YES;
        [self.Api getDessert:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
        
    } else if ([self.checksegmented isEqualToString:@"2"]) {
        
        refreshDataMenu = YES;
        [self.Api getBeans:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
        
    } else {
        
        refreshDataMenu = YES;
        [self.Api getFranchise:@"15" link:@"NO"];
        self.checkstatus = @"notrefresh";
    
    }
    
}

- (void)segmentselect:(id)sender {
    if (self.segmented.selectedSegmentIndex == 0) {
    
        self.checksegmented = @"0";
        self.checkstatus = @"refresh";
        [self.view addSubview:self.waitView];
        [self startSpin];
        
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = fv;
        
        [self.Api getDrink:@"15" link:@"NO"];
        
    } else if (self.segmented.selectedSegmentIndex == 1) {
        
        self.checksegmented = @"1";
        self.checkstatus = @"refresh";
        [self.view addSubview:self.waitView];
        [self startSpin];
        
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = fv;
        
        [self.Api getDessert:@"15" link:@"NO"];
        
    } else if (self.segmented.selectedSegmentIndex == 2) {
        
        self.checksegmented = @"2";
        self.checkstatus = @"refresh";
        [self.view addSubview:self.waitView];
        [self startSpin];
        
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = fv;
        
        [self.Api getBeans:@"15" link:@"NO"];
        
    } else if (self.segmented.selectedSegmentIndex == 3) {
        
        self.checksegmented = @"3";
        self.checkstatus = @"refresh";
        [self.view addSubview:self.waitView];
        [self startSpin];
        
        UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableFooterView = fv;
        
        [self.Api getFranchise:@"15" link:@"NO"];
        
    }
}

- (void)startSpin
{
    if (!self.popupProgressBar) {
        
        if(IS_WIDESCREEN) {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(145, 269, 30, 30)];
            self.popupProgressBar.image = [UIImage imageNamed:@"ic_loading"];
            [self.waitView addSubview:self.popupProgressBar];
        } else {
            self.popupProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(145, 225, 30, 30)];
            self.popupProgressBar.image = [UIImage imageNamed:@"ic_loading"];
            [self.waitView addSubview:self.popupProgressBar];
        }
        
    }
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGRect frame = [self.popupProgressBar frame];
    self.popupProgressBar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.popupProgressBar.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:1.0] forKey:kCATransactionAnimationDuration];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [self.popupProgressBar.layer addAnimation:animation forKey:@"rotationAnimation"];
    
    [CATransaction commit];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
    if (finished)
    {
        
        [self startSpin];
        
    }
}

/* Drink */
- (void)PFApi:(id)sender getDrinkResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.objDrink = response;
    
    if (!refreshDataMenu) {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataMenu = YES;
    } else {
        noDataMenu = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.drinkOffline setObject:response forKey:@"drinkArray"];
    [self.drinkOffline synchronize];
    
    if ([[self.drinkOffline objectForKey:@"drink_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.drinkOffline setObject:[response objectForKey:@"last_updated"] forKey:@"drink_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

- (void)PFApi:(id)sender getDrinkErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.drinkOffline objectForKey:@"drink_updated"] intValue] != [[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.drinkOffline setObject:[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"last_updated"] forKey:@"drink_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

/* Dessert */
- (void)PFApi:(id)sender getDessertResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.objDessert = response;
    
    if (!refreshDataMenu) {
        [self.arrObjDessert removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDessert addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDessert removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDessert addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataMenu = YES;
    } else {
        noDataMenu = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.dessertOffline setObject:response forKey:@"dessertArray"];
    [self.dessertOffline synchronize];
    
    if ([[self.dessertOffline objectForKey:@"dessert_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.dessertOffline setObject:[response objectForKey:@"last_updated"] forKey:@"dessert_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
}

- (void)PFApi:(id)sender getDessertErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        [self.arrObjDessert removeAllObjects];
        for (int i=0; i<[[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDessert addObject:[[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDessert removeAllObjects];
        for (int i=0; i<[[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDessert addObject:[[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.dessertOffline objectForKey:@"dessert_updated"] intValue] != [[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.dessertOffline setObject:[[self.dessertOffline objectForKey:@"dessertArray"] objectForKey:@"last_updated"] forKey:@"dessert_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

/* Beans */
- (void)PFApi:(id)sender getBeansResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.objBeans = response;
    
    if (!refreshDataMenu) {
        [self.arrObjBeans removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjBeans addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjBeans removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjBeans addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataMenu = YES;
    } else {
        noDataMenu = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.beansOffline setObject:response forKey:@"beansArray"];
    [self.beansOffline synchronize];
    
    if ([[self.beansOffline objectForKey:@"beans_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.beansOffline setObject:[response objectForKey:@"last_updated"] forKey:@"beans_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
}

- (void)PFApi:(id)sender getBeansErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        [self.arrObjBeans removeAllObjects];
        for (int i=0; i<[[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjBeans addObject:[[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjBeans removeAllObjects];
        for (int i=0; i<[[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjBeans addObject:[[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.beansOffline objectForKey:@"beans_updated"] intValue] != [[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.beansOffline setObject:[[self.beansOffline objectForKey:@"beansArray"] objectForKey:@"last_updated"] forKey:@"beans_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

/* Franchise */
- (void)PFApi:(id)sender getFranchiseResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    self.objFranchise = response;
    
    if (!refreshDataMenu) {
        [self.arrObjFranchise removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjFranchise addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjFranchise removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjFranchise addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataMenu = YES;
    } else {
        noDataMenu = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.franchiseOffline setObject:response forKey:@"franchiseArray"];
    [self.franchiseOffline synchronize];
    
    if ([[self.franchiseOffline objectForKey:@"franchise_updated"] intValue] != [[response objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.franchiseOffline setObject:[response objectForKey:@"last_updated"] forKey:@"franchise_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
}

- (void)PFApi:(id)sender getFranchiseErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        [self.arrObjFranchise removeAllObjects];
        for (int i=0; i<[[[self.franchiseOffline objectForKey:@"franchiseArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjFranchise addObject:[[[self.franchiseOffline objectForKey:@"franchiseArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjFranchise removeAllObjects];
        for (int i=0; i<[[[self.franchiseOffline objectForKey:@"franchiseArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjFranchise addObject:[[[self.drinkOffline objectForKey:@"franchiseArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ([[self.franchiseOffline objectForKey:@"franchise_updated"] intValue] != [[[self.franchiseOffline objectForKey:@"franchiseArray"] objectForKey:@"last_updated"] intValue]) {
        [self.tableView reloadData];
        [self.franchiseOffline setObject:[[self.franchiseOffline objectForKey:@"franchiseArray"] objectForKey:@"last_updated"] forKey:@"franchise_updated"];
    }
    
    if ([self.checkstatus isEqualToString:@"refresh"]) {
        [self.tableView reloadData];
    }
    
}

- (void)countDown {
    menuInt -= 1;
    if (menuInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.checksegmented isEqualToString:@"0"]) {
        return [self.arrObjDrink count];
    } else if ([self.checksegmented isEqualToString:@"1"]) {
        return [self.arrObjDessert count];
    } else if ([self.checksegmented isEqualToString:@"2"]) {
        return [self.arrObjBeans count];
    } else {
        return [self.arrObjFranchise count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        if ([[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
            PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"name"];
            
            return cell;
            
        } else {
            
            PFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFProductCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFProductCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detail.text = [[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"detail"];
            
            NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"price"]];
            cell.price.text = price;
            
            return cell;
        
        }
        
    } else if ([self.checksegmented isEqualToString:@"1"]) {
        
        if ([[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"name"];
            
            return cell;
            
        } else {
            
            PFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFProductCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFProductCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detail.text = [[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"detail"];
            
            NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"price"]];
            cell.price.text = price;
            
            return cell;
            
        }
        
    } else if ([self.checksegmented isEqualToString:@"2"]) {
        
        if ([[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"name"];
            
            return cell;
            
        } else {
            
            PFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFProductCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFProductCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detail.text = [[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"detail"];
            
            NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"price"]];
            cell.price.text = price;
            
            return cell;
            
        }
        
    } else {
        
        if ([[[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"name"];
            
            return cell;
            
        } else {
            
            PFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFProductCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFProductCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"name"];
            cell.detail.text = [[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"detail"];
            
            NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjFranchise objectAtIndex:indexPath.row] objectForKey:@"price"]];
            cell.price.text = price;
            
            return cell;
            
        }
    
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.NoInternetView removeFromSuperview];
    
    if ([self.checksegmented isEqualToString:@"0"]) {
        
        if ([[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
            
            if ([children_length isEqualToString:@"0"]) {
                
                [[[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
            } else {
                [self.delegate HideTabbar];
                
                PFDetailFoldertypeViewController *folderDetail = [[PFDetailFoldertypeViewController alloc] init];
                if(IS_WIDESCREEN) {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
                } else {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
                }
                self.navItem.title = @" ";
                folderDetail.obj = [self.arrObjDrink objectAtIndex:indexPath.row];
                folderDetail.delegate = self;
                [self.navController pushViewController:folderDetail animated:YES];
            }
            
            
        } else {
            
            [self.delegate HideTabbar];
            
            PFMenuDetailViewController *menuDetail = [[PFMenuDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController_Wide" bundle:nil];
            } else {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController" bundle:nil];
            }
            self.navItem.title = @" ";
            menuDetail.obj = [self.arrObjDrink objectAtIndex:indexPath.row];
            menuDetail.delegate = self;
            [self.navController pushViewController:menuDetail animated:YES];
            
        }
        
    } else if ([self.checksegmented isEqualToString:@"1"]) {
        
        if ([[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjDessert objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
            
            if ([children_length isEqualToString:@"0"]) {
                
                [[[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
            } else {
                [self.delegate HideTabbar];
                
                PFDetailFoldertypeViewController *folderDetail = [[PFDetailFoldertypeViewController alloc] init];
                if(IS_WIDESCREEN) {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
                } else {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
                }
                self.navItem.title = @" ";
                folderDetail.obj = [self.arrObjDessert objectAtIndex:indexPath.row];
                folderDetail.delegate = self;
                [self.navController pushViewController:folderDetail animated:YES];
            }
            
            
        } else {
            
            [self.delegate HideTabbar];
            
            PFMenuDetailViewController *menuDetail = [[PFMenuDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController_Wide" bundle:nil];
            } else {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController" bundle:nil];
            }
            self.navItem.title = @" ";
            menuDetail.obj = [self.arrObjDessert objectAtIndex:indexPath.row];
            menuDetail.delegate = self;
            [self.navController pushViewController:menuDetail animated:YES];
            
        }
        
    } else if ([self.checksegmented isEqualToString:@"2"]) {
        
        if ([[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
            
            NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjBeans objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
            
            if ([children_length isEqualToString:@"0"]) {
                
                [[[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
            } else {
                [self.delegate HideTabbar];
                
                PFDetailFoldertypeViewController *folderDetail = [[PFDetailFoldertypeViewController alloc] init];
                if(IS_WIDESCREEN) {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
                } else {
                    folderDetail = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
                }
                self.navItem.title = @" ";
                folderDetail.obj = [self.arrObjBeans objectAtIndex:indexPath.row];
                folderDetail.delegate = self;
                [self.navController pushViewController:folderDetail animated:YES];
            }
            
            
        } else {
            
            [self.delegate HideTabbar];
            
            PFMenuDetailViewController *menuDetail = [[PFMenuDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController_Wide" bundle:nil];
            } else {
                menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController" bundle:nil];
            }
            self.navItem.title = @" ";
            menuDetail.obj = [self.arrObjBeans objectAtIndex:indexPath.row];
            menuDetail.delegate = self;
            [self.navController pushViewController:menuDetail animated:YES];
            
        }
        
    } else {
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataMenu) {
            refreshDataMenu = NO;
            
            if ([self.checksegmented isEqualToString:@"0"]) {
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    
                }
            } else if ([self.checksegmented isEqualToString:@"1"]) {
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    
                }
            } else if ([self.checksegmented isEqualToString:@"2"]) {
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    
                }
            } else {
                if ([self.checkinternet isEqualToString:@"connect"]) {
                    
                }
            }
            
        }
    }
}

//full image
- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image {
    [self.delegate PFImageViewController:self viewPicture:image];
}

//back to contact page

- (void)PFDetailFoldertypeViewControllerBack {
    [self.delegate ShowTabbar];
    [self.tableView reloadData];
}

- (void)PFMenuDetailViewControllerBack {
    [self.delegate ShowTabbar];
    [self.tableView reloadData];
}

@end
