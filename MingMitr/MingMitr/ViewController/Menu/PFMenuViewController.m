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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    [self.segmented setBackgroundColor:[UIColor clearColor]];
    [self.segmented setTintColor:RGB(255,255,255)];
    CALayer *segmented = [self.segmented layer];
    [segmented setMasksToBounds:YES];
    [segmented setCornerRadius:5.0f];
    
    [self.segmented addTarget:self
                       action:@selector(segmentselect:)
             forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    [self.tableView reloadData];
    [refreshControl endRefreshing];
    
}

- (void)segmentselect:(id)sender {
    if (self.segmented.selectedSegmentIndex == 0) {
        
        
    } else if (self.segmented.selectedSegmentIndex == 1) {
        
        
    } else if (self.segmented.selectedSegmentIndex == 2) {
        
        
    } else if (self.segmented.selectedSegmentIndex == 3) {
        
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

@end
