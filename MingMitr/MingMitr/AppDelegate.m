//
//  AppDelegate.m
//  MingMitr
//
//  Created by Pariwat Promjai on 12/16/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (IS_OS_8_OR_LATER) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.update = [[UpdateViewController alloc] init];
    self.menu = [[MenuViewController alloc] init];
    self.member = [[MemberViewController alloc] init];
    self.contact = [[ContactViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        
        self.update = [[UpdateViewController alloc] initWithNibName:@"UpdateViewController_Wide" bundle:nil];
        self.menu = [[MenuViewController alloc] initWithNibName:@"MenuViewController_Wide" bundle:nil];
        self.member = [[MemberViewController alloc] initWithNibName:@"MemberViewController_Wide" bundle:nil];
        self.contact = [[ContactViewController alloc] initWithNibName:@"ContactViewController_Wide" bundle:nil];
        
    } else {
        
        self.update = [[UpdateViewController alloc] initWithNibName:@"UpdateViewController" bundle:nil];
        self.menu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
        self.member = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
        self.contact = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
        
    }
    
    self.tabBarViewController = [[TabBarViewController alloc] initWithBackgroundImage:nil viewControllers:self.update,self.menu,self.member,self.contact,nil];
    
    //self.update.delegate = self;
    //self.menu.delegate = self;
    //self.member.delegate = self;
    //self.contact.delegate = self;
    
    TabBarItemButton *item0 = [self.tabBarViewController.itemButtons objectAtIndex:0];
    [item0 setHighlightedImage:[UIImage imageNamed:@"en_update_on"]];
    [item0 setStanbyImage:[UIImage imageNamed:@"en_update_off"]];
    
    TabBarItemButton *item1 = [self.tabBarViewController.itemButtons objectAtIndex:1];
    [item1 setHighlightedImage:[UIImage imageNamed:@"en_menu_on"]];
    [item1 setStanbyImage:[UIImage imageNamed:@"en_menu_off"]];
    
    TabBarItemButton *item2 = [self.tabBarViewController.itemButtons objectAtIndex:2];
    [item2 setHighlightedImage:[UIImage imageNamed:@"en_member_on"]];
    [item2 setStanbyImage:[UIImage imageNamed:@"en_member_off"]];
    
    TabBarItemButton *item3 = [self.tabBarViewController.itemButtons objectAtIndex:3];
    [item3 setHighlightedImage:[UIImage imageNamed:@"en_contact_on"]];
    [item3 setStanbyImage:[UIImage imageNamed:@"en_contact_off"]];
    
    [self.tabBarViewController setSelectedIndex:1];
    [self.tabBarViewController setSelectedIndex:2];
    [self.tabBarViewController setSelectedIndex:3];
    [self.tabBarViewController setSelectedIndex:0];
    [self.window setRootViewController:self.tabBarViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is : %@", dt);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dt forKey:@"deviceToken"];
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:63];
    
    for (int i=0; i<63; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(36) % [letters length]]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"deviceToken"] length] == 0) {
        [defaults setObject:randomString forKey:@"deviceToken"];
    }
    [defaults synchronize];
}

@end