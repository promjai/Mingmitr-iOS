//
//  PFFranchiseCell.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PFFranchiseCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *thumbnails;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detail;

@end
