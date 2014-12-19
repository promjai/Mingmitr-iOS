//
//  MenuViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFFolderCell.h"
#import "PFProductCell.h"
#import "PFFranchiseCell.h"

#import "PFDetailFoldertypeViewController.h"
#import "PFMenuDetailViewController.h"

@protocol PFMenuViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) NSDictionary *objDrink;
@property (strong, nonatomic) NSDictionary *objDessert;
@property (strong, nonatomic) NSDictionary *objBeans;
@property (strong, nonatomic) NSDictionary *objFranchise;

@property (strong, nonatomic) NSMutableArray *arrObjDrink;
@property (strong, nonatomic) NSMutableArray *arrObjDessert;
@property (strong, nonatomic) NSMutableArray *arrObjBeans;
@property (strong, nonatomic) NSMutableArray *arrObjFranchise;

@property NSUserDefaults *drinkOffline;
@property NSUserDefaults *dessertOffline;
@property NSUserDefaults *beansOffline;
@property NSUserDefaults *franchiseOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) NSString *checksegmented;
@property (strong, nonatomic) NSString *checkstatus;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *paging;

@end
