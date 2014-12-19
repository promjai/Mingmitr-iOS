//
//  PFDetailFoldertypeViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 11/4/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFApi.h"

#import "PFFolderCell.h"
#import "PFProductCell.h"

#import "PFDetailFoldertype1ViewController.h"
#import "PFMenuDetailViewController.h"

@protocol PFDetailFoldertypeViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFDetailFoldertypeViewControllerBack;

@end

@interface PFDetailFoldertypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *foldertypeOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *folder_id;

@property (strong, nonatomic) NSString *paging;

@end
