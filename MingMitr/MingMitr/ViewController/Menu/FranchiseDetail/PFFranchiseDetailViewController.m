//
//  PFMenuDetailViewController.m
//  MingMitr
//
//  Created by Pariwat Promjai on 11/4/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFFranchiseDetailViewController.h"

@interface PFFranchiseDetailViewController ()

@end

@implementation PFFranchiseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.catalogDetailOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.arrObj = [[NSMutableArray alloc] init];
    
    images = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollView addGestureRecognizer:singleTap];
    
    NSString *id = [NSString stringWithFormat:@"%@",[self.obj objectForKey:@"id"]];
    [self.Api getMenuPictureById:id];
    
    self.name.text = [self.obj objectForKey:@"name"];
    self.detail.text = [self.obj objectForKey:@"detail"];
    
    //
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[self.obj objectForKey:@"thumb"] objectForKey:@"url"]];
    
    self.imageView1.layer.masksToBounds = YES;
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              self.imageView1.image = [UIImage imageWithData:imgData];
                          }];
    
    self.name1.text = [self.obj objectForKey:@"name"];
    self.detail1.text = [self.obj objectForKey:@"detail"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)share {
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:[[self.obj objectForKey:@"node"] objectForKey:@"share"]];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nil, @"name",
                                       nil, @"caption",
                                       nil, @"description",
                                       [[self.obj objectForKey:@"node"] objectForKey:@"share"], @"link",
                                       nil, @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:scrollView];
    for(int index=0;index<[images count];index++)
    {
        UIImageView *imgView = [images objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], touchPoint))
        {
            self.current = [NSString stringWithFormat:@"%d",index];
            [self ShowDetailView:imgView];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [[event allTouches] anyObject];
    
    for(int index=0;index<[images count];index++)
    {
        UIImageView *imgView = [images objectAtIndex:index];
        
        if(CGRectContainsPoint([imgView frame], [touch locationInView:scrollView]))
        {
            [self ShowDetailView:imgView];
            break;
        }
    }
}

-(void)ShowDetailView:(UIImageView *)imgView
{
    imageView.image = imgView.image;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)PFApi:(id)sender getMenuPictureByIdResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    
    [self.catalogDetailOffline removeObjectForKey:@"catalogDetailArray"];
    
    [self.catalogDetailOffline setObject:response forKey:[self.obj objectForKey:@"id"]];
    [self.catalogDetailOffline synchronize];
    
    NSString *length = [NSString stringWithFormat:@"%@",[response objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        //name
        
        CGRect frameName1 = self.name1.frame;
        frameName1.size = [self.name1 sizeOfMultiLineLabel];
        [self.name1 sizeOfMultiLineLabel];
        
        [self.name1 setFrame:frameName1];
        int linesName1 = self.name1.frame.size.height/15;
        self.name1.numberOfLines = linesName1;
        
        UILabel *descTextName1 = [[UILabel alloc] initWithFrame:frameName1];
        descTextName1.textColor = RGB(255, 0, 0);
        descTextName1.text = self.name1.text;
        descTextName1.numberOfLines = linesName1;
        [descTextName1 setFont:[UIFont boldSystemFontOfSize:17]];
        self.name1.alpha = 0;
        [self.headerImgView addSubview:descTextName1];
        
        //detail
        
        self.detail1.frame = CGRectMake(self.detail1.frame.origin.x, self.detail1.frame.origin.y+self.name1.frame.size.height-20, self.detail1.frame.size.width, self.detail1.frame.size.height);
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.name1.frame.size.height+self.detail1.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerImgView;
        
    } else {
        
        //name
        
        CGRect frameName = self.name.frame;
        frameName.size = [self.name sizeOfMultiLineLabel];
        [self.name sizeOfMultiLineLabel];
        
        [self.name setFrame:frameName];
        int linesName = self.name.frame.size.height/15;
        self.name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(255, 0, 0);
        descTextName.text = self.name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.name.alpha = 0;
        [self.headerView addSubview:descTextName];
        
        //detail
        
        self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y+self.name.frame.size.height-20, self.detail.frame.size.width, self.detail.frame.size.height);
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.name.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }

}

- (void)PFApi:(id)sender getMenuPictureByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    NSString *length = [NSString stringWithFormat:@"%@",[[self.catalogDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"length"]];
    int num = length.intValue;
    
    if (num <= 1) {
        
        //name
        
        CGRect frameName1 = self.name1.frame;
        frameName1.size = [self.name1 sizeOfMultiLineLabel];
        [self.name1 sizeOfMultiLineLabel];
        
        [self.name1 setFrame:frameName1];
        int linesName1 = self.name1.frame.size.height/15;
        self.name1.numberOfLines = linesName1;
        
        UILabel *descTextName1 = [[UILabel alloc] initWithFrame:frameName1];
        descTextName1.textColor = RGB(255, 0, 0);
        descTextName1.text = self.name1.text;
        descTextName1.numberOfLines = linesName1;
        [descTextName1 setFont:[UIFont boldSystemFontOfSize:17]];
        self.name1.alpha = 0;
        [self.headerImgView addSubview:descTextName1];
        
        //detail
        
        self.detail1.frame = CGRectMake(self.detail1.frame.origin.x, self.detail1.frame.origin.y+self.name1.frame.size.height-20, self.detail1.frame.size.width, self.detail1.frame.size.height);
        
        CGRect frame = self.detail1.frame;
        frame.size = [self.detail1 sizeOfMultiLineLabel];
        [self.detail1 sizeOfMultiLineLabel];
        
        [self.detail1 setFrame:frame];
        int lines = self.detail1.frame.size.height/15;
        self.detail1.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail1.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail1.alpha = 0;
        [self.headerImgView addSubview:descText];
        
        self.headerImgView.frame = CGRectMake(self.headerImgView.frame.origin.x, self.headerImgView.frame.origin.y, self.headerImgView.frame.size.width, self.headerImgView.frame.size.height+self.name1.frame.size.height+self.detail1.frame.size.height-20);
        
        
        self.tableView.tableHeaderView = self.headerImgView;
        
    } else {
        
        //name
        
        CGRect frameName = self.name.frame;
        frameName.size = [self.name sizeOfMultiLineLabel];
        [self.name sizeOfMultiLineLabel];
        
        [self.name setFrame:frameName];
        int linesName = self.name.frame.size.height/15;
        self.name.numberOfLines = linesName;
        
        UILabel *descTextName = [[UILabel alloc] initWithFrame:frameName];
        descTextName.textColor = RGB(255, 0, 0);
        descTextName.text = self.name.text;
        descTextName.numberOfLines = linesName;
        [descTextName setFont:[UIFont boldSystemFontOfSize:17]];
        self.name.alpha = 0;
        [self.headerView addSubview:descTextName];
        
        //detail
        
        self.detail.frame = CGRectMake(self.detail.frame.origin.x, self.detail.frame.origin.y+self.name.frame.size.height-20, self.detail.frame.size.width, self.detail.frame.size.height);
        
        
        CGRect frame = self.detail.frame;
        frame.size = [self.detail sizeOfMultiLineLabel];
        [self.detail sizeOfMultiLineLabel];
        
        [self.detail setFrame:frame];
        int lines = self.detail.frame.size.height/15;
        self.detail.numberOfLines = lines;
        
        UILabel *descText = [[UILabel alloc] initWithFrame:frame];
        descText.textColor = RGB(102, 102, 102);
        descText.text = self.detail.text;
        descText.numberOfLines = lines;
        [descText setFont:[UIFont systemFontOfSize:15]];
        self.detail.alpha = 0;
        [self.headerView addSubview:descText];
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.name.frame.size.height+self.detail.frame.size.height-20);
        
        self.tableView.tableHeaderView = self.headerView;
        
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        int scrollWidth = 70;
        scrollView.contentSize = CGSizeMake(scrollWidth,70);
        
        int xOffset = 0;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.catalogDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  imageView.image = [UIImage imageWithData:imgData];
                              }];
        
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.arrgalleryimg = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[[[self.catalogDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] count]; ++i) {
            //
            AsyncImageView *img = [[AsyncImageView alloc] init];
            
            img.layer.masksToBounds = YES;
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            img.frame = CGRectMake(xOffset, 0, 70, 70);
            
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[[self.catalogDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      img.image = [UIImage imageWithData:imgData];
                                  }];
            
            [images insertObject:img atIndex:i];
            
            [self.arrgalleryimg addObject:[[[[self.catalogDetailOffline objectForKey:[self.obj objectForKey:@"id"]] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
            
            scrollView.contentSize = CGSizeMake(scrollWidth+xOffset,70);
            [scrollView addSubview:[images objectAtIndex:i]];
            
            xOffset += 70;
        }
    }
    
}

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:self.imageView1.image];
}

- (IBAction)fullimgalbumTapped:(id)sender {
    [self.delegate PFGalleryViewController:self sum:self.arrgalleryimg current:self.current];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFFranchiseDetailViewControllerBack)]){
            [self.delegate PFFranchiseDetailViewControllerBack];
        }
    }
}

@end
