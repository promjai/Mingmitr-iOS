//
//  AppDelegate.h
//  MingMitr
//
//  Created by Pariwat Promjai on 12/16/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TabBarViewController.h"

#import "UpdateViewController.h"
#import "MenuViewController.h"
#import "MemberViewController.h"
#import "ContactViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarViewController *tabBarViewController;

@property (strong, nonatomic) UpdateViewController *update;
@property (strong, nonatomic) MenuViewController *menu;
@property (strong, nonatomic) MemberViewController *member;
@property (strong, nonatomic) ContactViewController *contact;

@end