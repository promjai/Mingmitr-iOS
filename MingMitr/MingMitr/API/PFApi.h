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

@end

@interface PFApi : NSObject

#pragma mark - Property
@property (assign, nonatomic) id delegate;
@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property NSString *urlStr;

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link;
- (void)getFeedById:(NSString *)news_id;

@end
