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

#pragma mark - Overview Protocal Delegate
- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

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

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link;

#pragma mark - Menu
- (void)getDrink:(NSString *)limit link:(NSString *)link;
- (void)getDessert:(NSString *)limit link:(NSString *)link;
- (void)getBeans:(NSString *)limit link:(NSString *)link;
- (void)getFranchise:(NSString *)limit link:(NSString *)link;

- (void)getFolderTypeByURL:(NSString *)url;

- (void)getMenuPictureById:(NSString *)picture_id;

@end
