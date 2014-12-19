//
//  PFApi.h
//  P2 STORE
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PFApiDelegate <NSObject>

#pragma mark - Register
- (void)PFApi:(id)sender registerWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - Login facebook token
- (void)PFApi:(id)sender loginWithFacebookTokenResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithFacebookTokenErrorResponse:(NSString *)errorResponse;

#pragma mark - login with username password
- (void)PFApi:(id)sender loginWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - User
- (void)PFApi:(id)sender meResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender meErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getUserSettingResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender changPasswordResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender changPasswordErrorResponse:(NSString *)errorResponse;

#pragma mark - Overview Protocal Delegate
- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

#pragma mark - Overview Notification Protocal Delegate
- (void)PFApi:(id)sender getNotificationResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender checkBadgeResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse;

#pragma mark - Menu Protocal Delegate
- (void)PFApi:(id)sender getDrinkResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getDrinkErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getDessertResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getDessertErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getBeansResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getBeansErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getFranchiseResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFranchiseErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getMenuPictureByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getMenuPictureByIdErrorResponse:(NSString *)errorResponse;

@end

@interface PFApi : NSObject

#pragma mark - Property
@property (assign, nonatomic) id delegate;
@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property NSString *urlStr;

#pragma mark - User_id
- (void)saveUserId:(NSString *)user_id;
- (void)saveAccessToken:(NSString *)access_token;

- (NSString *)getUserId;
- (NSString *)getAccessToken;

#pragma mark - Check Login
- (BOOL)checkLogin;

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date;

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token;

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)passeord;

#pragma mark - Log out
- (void)logOut;

#pragma mark - User
- (void)me;
- (void)getUserSetting;
- (void)userPictureUpload:(NSString *)picture_base64;
- (void)updateSetting:(NSString *)profilename email:(NSString *)email website:(NSString *)website tel:(NSString *)tel gender:(NSString *)gender birthday:(NSString *)birthday;
- (void)changePassword:(NSString *)old_password new_password:(NSString *)new_password;

- (void)settingNews:(NSString *)status;
- (void)settingMessage:(NSString *)status;

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link;

#pragma mark - Feed Notification
- (void)getNotification:(NSString *)limit link:(NSString *)link;
- (void)checkBadge;
- (void)clearBadge;

#pragma mark - Menu
- (void)getDrink:(NSString *)limit link:(NSString *)link;
- (void)getDessert:(NSString *)limit link:(NSString *)link;
- (void)getBeans:(NSString *)limit link:(NSString *)link;
- (void)getFranchise:(NSString *)limit link:(NSString *)link;

- (void)getFolderTypeByURL:(NSString *)url;

- (void)getMenuPictureById:(NSString *)picture_id;

@end
