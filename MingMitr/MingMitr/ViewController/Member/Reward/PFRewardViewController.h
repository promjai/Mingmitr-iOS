//
//  PFRewardViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@protocol PFRewardViewControllerDelegate <NSObject>

- (void) PFRewardViewControllerBack;

@end

@interface PFRewardViewController : UIViewController <UIWebViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (weak, nonatomic) IBOutlet UIView *popupwaitView;

@end
