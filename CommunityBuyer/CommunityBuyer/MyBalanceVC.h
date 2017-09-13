//
//  MyBalanceVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface MyBalanceVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *mBalance;
- (IBAction)goChongzhi:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *mRecordTable;
@end
