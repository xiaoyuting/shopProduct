//
//  blockmsgcell.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface blockmsgcell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mname;

@property (weak, nonatomic) IBOutlet UILabel *mtime;

@property (weak, nonatomic) IBOutlet UILabel *mcontent;

@property (weak, nonatomic) IBOutlet UILabel *mfrom;
@property (weak, nonatomic) IBOutlet UILabel *mcommname;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mfromconst;
@property (weak, nonatomic) IBOutlet UIImageView *mdian;



@end
