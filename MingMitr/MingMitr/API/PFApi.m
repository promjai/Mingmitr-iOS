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

#pragma mark - Access Token
- (void)saveAccessToken:(NSString *)access_token {
    [self.userDefaults setObject:access_token forKey:@"access_token"];
}

- (NSString *)getAccessToken {
    return [self.userDefaults objectForKey:@"access_token"];
}

#pragma mark - User ID
- (void)saveUserId:(NSString *)user_id {
    [self.userDefaults setObject:user_id forKey:@"user_id"];
}

- (NSString *)getUserId {
    return [self.userDefaults objectForKey:@"user_id"];
}

#pragma mark - Check Log in
- (BOOL)checkLogin {
    if ([self.userDefaults objectForKey:@"user_id"] != nil || [self.userDefaults objectForKey:@"access_token"] != nil) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@register",API_URL];
    NSDictionary *parameters = @{@"username":username , @"password":password , @"email":email ,@"birth_date":birth_date , @"gender":gender};
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self registerWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self registerWithUsernameErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/facebook",API_URL];
    
    NSDictionary *parameters;
    
    if ([[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@""] || [[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@"(null)"]) {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":@"" , @"ios_device_token[type]":@"product"};
        
    } else {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
        
    }
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithFacebookTokenResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithFacebookTokenErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/password",API_URL];
    
    NSDictionary *parameters = @{@"username":username , @"password":password , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithUsernameErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Log out
- (void)logOut {
    [self.userDefaults removeObjectForKey:@"deviceToken"];
    [self.userDefaults removeObjectForKey:@"access_token"];
    [self.userDefaults removeObjectForKey:@"user_id"];
}

#pragma mark - Me
- (void)me {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self meResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self meErrorResponse:[error localizedDescription]];
    }];
}

- (void)getUserSetting {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
}

- (void)userPictureUpload:(NSString *)picture_base64 {
    NSDictionary *parameters = @{@"picture":picture_base64};
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self meResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self meErrorResponse:[error localizedDescription]];
    }];
}

- (void)updateSetting:(NSString *)profilename email:(NSString *)email website:(NSString *)website tel:(NSString *)tel gender:(NSString *)gender birthday:(NSString *)birthday {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"display_name":profilename , @"email":email , @"website":website , @"mobile":tel , @"gender":gender , @"birth_date":birthday};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
}

- (void)changePassword:(NSString *)old_password new_password:(NSString *)new_password {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/change_password/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"old_password":old_password , @"new_password":new_password  };
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self changPasswordResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self changPasswordErrorResponse:[error localizedDescription]];
    }];
}

- (void)profile:(NSString *)userId {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,userId];
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserByIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)settingNews:(NSString *)status {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    
    NSDictionary *parameters = @{@"notify_update":status};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)settingMessage:(NSString *)status {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    
    NSDictionary *parameters = @{@"notify_message":status};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
    
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

- (void)getFeedById:(NSString *)news_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@feed/%@",API_URL,news_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFeedByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFeedByIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getNewsCommentObjId:(NSString *)feed_id padding:(NSString *)padding {
    
    if ([padding isEqualToString:@"NO"]) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@feed/%@/comment?limit=5",API_URL,feed_id];
    } else {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@",padding];
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getNewsCommentObjIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getNewsCommentObjIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)commentObjId:(NSString *)obj_id content:(NSString *)content {
    
    NSDictionary *parameters = @{@"message":content , @"access_token":[self getAccessToken]};
    self.urlStr = [[NSString alloc] initWithFormat:@"%@feed/%@/comment",API_URL,obj_id];
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self commentObjIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self commentObjIdErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Feed Notification
- (void)getNotification:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getNotificationErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)checkBadge {
    
    if ([[self.userDefaults objectForKey:@"access_token"] length] != 0) {
        
        NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/notify/unopened",API_URL];
        
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
        
        NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
        
        [self.manager  GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self checkBadgeResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self checkBadgeErrorResponse:[error localizedDescription]];
        }];
    }
    
}

- (void)clearBadge {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/clear_badge",API_URL];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"clear : %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
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

#pragma mark - Member
- (void)getStamp {
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/stamp/%@",API_URL,[self getUserId]];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getStampResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getStampErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)stampAddPoint:(NSString *)point password:(NSString *)password {
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@user/stamp/add/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"point":point , @"password":password  };
    [self.manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self stampAddPointResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self stampAddPointErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getStampStyle {
    
    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@stamp/style",API_URL];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getStampStyleResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getStampStyleErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)history {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/history/%@?limit=100",API_URL,[self getUserId]];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getHistoryResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getHistoryErrorResponse:[error localizedDescription]];
    }];
}

#pragma mark - Contact
- (void)getContact {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getContactErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getContactBranches {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/branches",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getContactBranchesResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getContactBranchesErrorResponse:[error localizedDescription]];
    }];
}

- (void)getBranchTelephone:(NSString *)branch_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/branches/%@/tel",API_URL,branch_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getBranchTelephoneResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getBranchTelephoneErrorResponse:[error localizedDescription]];
    }];
    
}

@end
