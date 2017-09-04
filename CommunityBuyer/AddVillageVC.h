//
//  AddVillageVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface AddVillageVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mInfoTable;
@property (weak, nonatomic) IBOutlet UIButton *mbt;

@property (weak, nonatomic) IBOutlet UILabel *mText;//提示文字
- (IBAction)addMyVillage:(id)sender;//加入我的小区

@property (assign,nonatomic) BOOL isOwn;
@property (nonatomic,strong) SDistrict* mtagDistrict;

//如果是查看物业,就有这个变量,否则就是需要 添加到我的小区
@property (nonatomic,strong)    void(^mitblock)(SDistrict* selectobj );

@end
