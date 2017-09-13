//
//  ToTheRepairVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@class IQTextView;
@interface ToTheRepairVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *mName;//名称
@property (weak, nonatomic) IBOutlet UIButton *mFacilities;//设施
@property (weak, nonatomic) IBOutlet IQTextView *mIntro;//描述
- (IBAction)submitRepair:(id)sender;//提交

- (IBAction)chooseFacilities:(id)sender;


@property (nonatomic,assign) BOOL isShow;//用于标记是否显示了table
@property (nonatomic,strong) UITableView *mClassTable;

@property (nonatomic,strong)    SDistrict*  mtagDistrict;

@property (weak, nonatomic) IBOutlet UIView *mimgwaper;


@end
