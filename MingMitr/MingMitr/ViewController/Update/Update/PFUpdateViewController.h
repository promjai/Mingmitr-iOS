//
//  UpdateViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import "BBBadgeBarButtonItem.h"

#import "PFApi.h"

#import "PFUpdateCell.h"

//#import "PFUpdateDetailViewController.h"
#import "PFLoginViewController.h"
#import "PFAccountViewController.h"
#import "PFNotificationViewController.h"

@protocol PFUpdateViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFUpdateViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *feedOffline;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *badgeCheck;

@end
