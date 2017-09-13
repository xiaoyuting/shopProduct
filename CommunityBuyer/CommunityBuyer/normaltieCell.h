//
//  normaltieCell.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface normaltieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mbigimg;

@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;

@property (weak, nonatomic) IBOutlet UILabel *mtitle;

@property (weak, nonatomic) IBOutlet UILabel *mtime;
@property (weak, nonatomic) IBOutlet UILabel *mcmmcount;
@property (weak, nonatomic) IBOutlet UILabel *mgoodscount;
@property (weak, nonatomic) IBOutlet UIImageView *mgoodimg;
@property (weak, nonatomic) IBOutlet UILabel *mname;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mbigimgconsth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mbigimgconstw;


@end
