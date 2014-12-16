//
//  AppDelegate.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/16/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TabBarViewController.h"

#import "PFUpdateViewController.h"
#import "PFMenuViewController.h"
#import "PFMemberViewController.h"
#import "PFContactViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFMenuViewController *menu;
@property (strong, nonatomic) PFMemberViewController *member;
@property (strong, nonatomic) PFContactViewController *contact;

@end