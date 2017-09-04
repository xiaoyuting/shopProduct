//
//  VillageVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface VillageVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mVillageTable;
@property (assign,nonatomic) BOOL isOwn;


@property (nonatomic,strong)    void(^mitblock)(SDistrict* selectobj );

@end
