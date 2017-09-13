//
//  PropertyIntroduceVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/27.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface PropertyIntroduceVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mInfoTable;


@property (nonatomic,strong) SSeller*   mtagSeller;

@end
