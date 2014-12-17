//
//  ContactViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFContactViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong,nonatomic) IBOutlet UITableView *tableView;

@end
