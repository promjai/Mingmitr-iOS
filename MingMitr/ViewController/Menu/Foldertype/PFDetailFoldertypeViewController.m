//
//  PFDetailFoldertypeViewController.m
//  MingMitr
//
//  Created by Pariwat Promjai on 11/4/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFDetailFoldertypeViewController.h"

@interface PFDetailFoldertypeViewController ()

@end

@implementation PFDetailFoldertypeViewController

BOOL loadFolder;
BOOL noDataFolder;
BOOL refreshDataFolder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
        self.foldertypeOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    loadFolder = NO;
    noDataFolder = NO;
    refreshDataFolder = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    self.Api = [[PFApi alloc] init];
    self.Api.delegate = self;
    
    [self.Api getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    refreshDataFolder = YES;
    [self.Api getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    
}

- (void)PFApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    if (!refreshDataFolder) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataFolder = YES;
    } else {
        noDataFolder = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.foldertypeOffline setObject:response forKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
    [self.foldertypeOffline synchronize];
    
    [self.tableView reloadData];
    
}

- (void)PFApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    [self.refreshControl endRefreshing];
    
    if (!refreshDataFolder) {
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.foldertypeOffline objectForKey:[[self.obj objectForKey:@"node"] objectForKey:@"children"]] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        PFFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFolderCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFolderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
        
    } else {
        
        PFProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFProductCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFProductCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.thumbnails.layer.masksToBounds = YES;
        cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",[[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"]];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.thumbnails.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detail.text = [[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"];
        
        NSString *price = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.price.text = price;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"item"]) {
        
        PFMenuDetailViewController *menuDetail = [[PFMenuDetailViewController alloc] init];
        if(IS_WIDESCREEN) {
            menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController_Wide" bundle:nil];
        } else {
            menuDetail = [[PFMenuDetailViewController alloc] initWithNibName:@"PFMenuDetailViewController" bundle:nil];
        }
        self.navigationItem.title = @" ";
        menuDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
        menuDetail.delegate = self;
        [self.navigationController pushViewController:menuDetail animated:YES];
        
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"folder"]) {
        
        NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
        
        if ([children_length isEqualToString:@"0"]) {
            
            [[[UIAlertView alloc] initWithTitle:@"Mingmitr!"
                                        message:@"Coming soon."
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
        } else {
            
            PFDetailFoldertype1ViewController *folderDetail = [[PFDetailFoldertype1ViewController alloc] init];
            if(IS_WIDESCREEN) {
                folderDetail = [[PFDetailFoldertype1ViewController alloc] initWithNibName:@"PFDetailFoldertype1ViewController_Wide" bundle:nil];
            } else {
                folderDetail = [[PFDetailFoldertype1ViewController alloc] initWithNibName:@"PFDetailFoldertype1ViewController" bundle:nil];
            }
            self.navigationItem.title = @" ";
            folderDetail.obj = [self.arrObj objectAtIndex:indexPath.row];
            folderDetail.delegate = self;
            [self.navigationController pushViewController:folderDetail animated:YES];
        }
        
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataFolder) {
            refreshDataFolder = NO;
            
            [self.Api getFolderTypeByURL:[[self.obj objectForKey:@"node"] objectForKey:@"children"]];
        }
    }
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    [self.delegate PFImageViewController:self viewPicture:image];
}

- (void)PFDetailFoldertype1ViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    [self.tableView reloadData];
}

- (void)PFMenuDetailViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    [self.tableView reloadData];
}

- (void)PFFranchiseDetailViewControllerBack {
    self.navigationItem.title = [self.obj objectForKey:@"name"];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFDetailFoldertypeViewControllerBack)]){
            [self.delegate PFDetailFoldertypeViewControllerBack];
        }
    }
}

@end
