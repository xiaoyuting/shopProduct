//
//  QuanVC.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface QuanVC : BaseVC

@property (weak, nonatomic) IBOutlet UIView *mtopwaper;

@property (weak, nonatomic) IBOutlet UIImageView *mleftimg;
@property (weak, nonatomic) IBOutlet UIImageView *mrightimg;

@property (weak, nonatomic) IBOutlet UILabel *mlefttxt;
@property (weak, nonatomic) IBOutlet UILabel *mrighttxt;


@property (weak, nonatomic) IBOutlet UIView *mimagewaper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimgwaperconst;

@property (weak, nonatomic) IBOutlet UITableView *mittableview;




@end
