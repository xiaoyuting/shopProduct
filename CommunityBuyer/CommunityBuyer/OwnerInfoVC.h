//
//  OwnerInfoVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface OwnerInfoVC : BaseVC


@property (weak, nonatomic) IBOutlet UITableView *mInfoTable;
@property (nonatomic,strong)    SAuth*  mtagAuth;

@end
