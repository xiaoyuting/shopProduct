//
//  DistrictVC.h
//  CommunityBuyer
//
//  Created by zzl on 15/12/1.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface DistrictVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *minputkeywords;

@property (weak, nonatomic) IBOutlet UITableView *mtagtable;


@property (nonatomic,strong) void(^itblock)(SDistrict* retobj);

@end
