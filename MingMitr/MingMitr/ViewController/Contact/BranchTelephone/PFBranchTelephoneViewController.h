//
//  PFBranchTelephoneViewController.h
//  P2 STORE
//
//  Created by Pariwat Promjai on 11/7/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

#import "PFBranchTelCell.h"

@protocol PFBranchTelephoneViewControllerDelegate <NSObject>

- (void)PFBranchTelephoneViewControllerBack;

@end

@interface PFBranchTelephoneViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *contactOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *paging;

@end
