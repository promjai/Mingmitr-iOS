//
//  PFNotificationViewController.h
//  MingMitr
//
//  Created by Pariwat on 26/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "PFNotificationCell.h"

#import "PFApi.h"

#import "PFUpdateDetailViewController.h"
#import "PFMessageViewController.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFNotificationViewControllerBack;

@end

@interface PFNotificationViewController : UIViewController

@property AFHTTPRequestOperationManager *manager;
@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property NSUserDefaults *notifyOffline;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *arrObj;

@property (retain, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *checkinternet;

@end
