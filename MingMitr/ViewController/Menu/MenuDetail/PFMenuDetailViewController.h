//
//  PFMenuDetailViewController.h
//  MingMitr
//
//  Created by Pariwat Promjai on 11/4/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "ScrollView.h"
#import "DLImageLoader.h"
#import "AsyncImageView.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFApi.h"

@protocol PFMenuDetailViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image;
- (void)PFMenuDetailViewControllerBack;

@end

@interface PFMenuDetailViewController : UIViewController < UIScrollViewDelegate> {
    
    IBOutlet ScrollView *scrollView;
    IBOutlet AsyncImageView *imageView;
    NSMutableArray *images;
    NSArray *imagesName;
    
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *catalogDetailOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerImgView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *name;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *name1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail1;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *baht1;

-(void)ShowDetailView:(UIImageView *)imgView;

- (IBAction)fullimgTapped:(id)sender;
- (IBAction)fullimgalbumTapped:(id)sender;

@end
