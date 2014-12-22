//
//  PFSeeprofileViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFSeeprofileViewController.h"

@interface PFSeeprofileViewController ()

@end

@implementation PFSeeprofileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    self.navigationItem.title = @"Profile";
    
    self.tableView.tableHeaderView = self.headerView;
    self.bgheaderView.layer.shadowOffset = CGSizeMake(0.5, -0.5);
    self.bgheaderView.layer.shadowRadius = 2;
    self.bgheaderView.layer.shadowOpacity = 0.1;
    
    self.obj = [[NSDictionary alloc] init];
    
    self.rowCount = [[NSString alloc] init];
    
    [self.Api profile:self.user_id];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFApi:(id)sender getUserByIdResponse:(NSDictionary *)response {
    self.obj = response;
    NSLog(@"Me %@",response);
    
    [self.waitView removeFromSuperview];
    
    self.display_name.text = [response objectForKey:@"display_name"];
    
    NSString *picStr = [[response objectForKey:@"picture"] objectForKey:@"url"];
    self.thumUser.layer.masksToBounds = YES;
    self.thumUser.contentMode = UIViewContentModeScaleAspectFill;
    
    [DLImageLoader loadImageFromURL:picStr
                          completed:^(NSError *error, NSData *imgData) {
                              self.thumUser.image = [UIImage imageWithData:imgData];
                          }];
    
    [self.tableView reloadData];

}

- (void)PFApi:(id)sender getUserByIdErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFAccountCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFAccountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {

        cell.imgrow.image = [UIImage imageNamed:@"ic_mail"];
        cell.detailrow.text = [self.obj objectForKey:@"email"];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEmail:)];
        [cell addGestureRecognizer:singleTap];
        
    } else if (indexPath.row == 1) {
        
        cell.imgrow.image = [UIImage imageNamed:@"ic_web"];
        cell.detailrow.text = [self.obj objectForKey:@"website"];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapWebsite:)];
        [cell addGestureRecognizer:singleTap];
        
    } else if (indexPath.row == 2) {

        cell.imgrow.image = [UIImage imageNamed:@"ic_iphone"];
        cell.detailrow.text = [self.obj objectForKey:@"mobile"];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [cell addGestureRecognizer:singleTap];
        
    } else if (indexPath.row == 3) {

        cell.imgrow.image = [UIImage imageNamed:@"ic_gender"];
        cell.detailrow.text = [self.obj objectForKey:@"gender"];
        
    } else if (indexPath.row == 4) {
        
        cell.imgrow.image = [UIImage imageNamed:@"ic_birthday"];
        NSString *myString = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"birth_date"]];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[myString intValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *dte = [dateFormatter stringFromDate:date];
        cell.detailrow.text = dte;

    }
    
    return cell;
}

- (void)singleTapWebsite:(UITapGestureRecognizer *)gesture
{
    if (![[self.obj objectForKey:@"website"] isEqualToString:@""]) {
        NSString *website = [[NSString alloc] initWithFormat:@"%@",[self.obj objectForKey:@"website"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (![[self.obj objectForKey:@"mobile"] isEqualToString:@""]) {
        NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",[self.obj objectForKey:@"mobile"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

- (void)singleTapEmail:(UITapGestureRecognizer *)gesture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        NSLog(@"Send Email");
        
        // Email Subject
        NSString *emailTitle = nil;
        // Email Content
        NSString *messageBody = nil;
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:[self.obj objectForKey:@"email"]];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:229.0f/255.0f green:172.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)fullimgTapped:(id)sender {
    [self.delegate PFImageViewController:self viewPicture:self.thumUser.image];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFSeeprofileViewControllerBack)]){
            [self.delegate PFSeeprofileViewControllerBack];
        }
    }
    
}

@end
