//
//  ChooseVillageVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface ChooseVillageVC : BaseVC

@property (weak, nonatomic) IBOutlet UITableView *mInfoTable;//table
@property (weak, nonatomic) IBOutlet UITextField *mInput;//输入框

- (IBAction)goSearch:(id)sender;//搜索
@end
