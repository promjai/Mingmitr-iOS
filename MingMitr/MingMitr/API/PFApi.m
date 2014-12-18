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

#pragma mark - Menu
- (void)getDrink:(NSString *)limit link:(NSString *)link {

    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service/548ff27ada354d464c48bd6b/children?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getDrinkResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getDrinkErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getDessert:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service/548ff275da354d7c5248bd6b/children?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getDessertResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getDessertErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getBeans:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service/548ff269da354d474c48bd82/children?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getBeansResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getBeansErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getFranchise:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service/548ff259da354d424c48bd6b/children?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFranchiseResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFranchiseErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getFolderTypeByURL:(NSString *)url {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@",url];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFolderTypeByURLResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFolderTypeByURLErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getMenuPictureById:(NSString *)picture_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@service/%@/picture",API_URL,picture_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getMenuPictureByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getMenuPictureByIdErrorResponse:[error localizedDescription]];
    }];
    
}

@end
