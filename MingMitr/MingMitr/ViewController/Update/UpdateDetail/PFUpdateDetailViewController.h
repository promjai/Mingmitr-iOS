//
//  PFDetailViewController.h
//  MingMitr
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <Social/Social.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

#import "PFUpdateDetailCell.h"
#import "PFLoginViewController.h"
//#import "PFSeeprofileViewController.h"

@protocol PFUpdateDetailViewControllerDelegate <NSObject>

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFUpdateDetailViewControllerBack;

@end

@interface PFUpdateDetailViewController : UIViewController <UITextViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;

@property (strong, nonatomic) NSString *internetstatus;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property NSUserDefaults *feedDetailOffline;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *titlenews;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detailnews;
@property (strong, nonatomic) IBOutlet UIImageView *detailthumb;

@property (strong, nonatomic) IBOutlet UIView *textCommentView;

@property (strong, nonatomic) IBOutlet UIButton *postBut;
@property (strong, nonatomic) IBOutlet UITextView *textComment;

- (IBAction)postCommentTapped:(id)sender;

@end
