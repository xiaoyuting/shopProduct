//
//  RepairDetailVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"
#import "ShowImagesView.h"

@interface RepairDetailVC : BaseVC
@property (weak, nonatomic) IBOutlet UILabel *mTime;//时间
@property (weak, nonatomic) IBOutlet UILabel *mState;//状态
@property (weak, nonatomic) IBOutlet UILabel *mTitle;//标题
@property (weak, nonatomic) IBOutlet ShowImagesView *mimgView;
@property (weak, nonatomic) IBOutlet UILabel *mContent;//内容
@property (weak, nonatomic) IBOutlet UIImageView *mImage;//图片
@property (nonatomic,strong) SRepair* mSRepair;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimgViewHeight;

@end
