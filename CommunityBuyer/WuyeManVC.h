//
//  WuyeManVC.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/25.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface WuyeManVC : BaseVC

@property (weak, nonatomic) IBOutlet UIScrollView *mwaper;

@property (weak, nonatomic) IBOutlet UIImageView *mheadimg;
@property (weak, nonatomic) IBOutlet UILabel *mname;
@property (weak, nonatomic) IBOutlet UILabel *mandyuan;

@property (weak, nonatomic) IBOutlet UILabel *mtel;


@property (weak, nonatomic) IBOutlet UIView *mdoorfun;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mbotdis;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mdoorhiconst;

@end
