//
//  PFApi.m
//  P2 STORE
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFApi.h"

@implementation PFApi

- (id) init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@feed?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFeedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFeedErrorResponse:[error localizedDescription]];
    }];
    
}

@end
