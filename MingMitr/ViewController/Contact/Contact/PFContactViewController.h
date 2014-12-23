//
//  ContactViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/12/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFBranchesViewController.h"
#import "PFWebViewController.h"
#import "PFMapAllViewController.h"

@protocol PFContactViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFContactViewController : UIViewController <UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) NSString *locationSum;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *mapImg;

@property (strong, nonatomic) IBOutlet UIButton *branchBt;
@property (strong, nonatomic) IBOutlet UILabel *branchLabel;

@property (strong, nonatomic) IBOutlet UILabel *websiteLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;

- (IBAction)mapTapped:(id)sender;

- (IBAction)branchTapped:(id)sender;

- (IBAction)webTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)facebookTapped:(id)sender;

- (IBAction)powerbyTapped:(id)sender;

@end
