//
//  FaultRepairVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface FaultRepairVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mFaultRepairTable;
- (IBAction)goRepair:(id)sender;

@property (nonatomic,strong) SDistrict* mtagDistrict;

@end
