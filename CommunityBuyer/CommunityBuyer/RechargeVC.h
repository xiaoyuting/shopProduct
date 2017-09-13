//
//  RechargeVC.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "BaseVC.h"

@interface RechargeVC : BaseVC

- (IBAction)goRecharge:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mMoney;
@property (weak, nonatomic) IBOutlet UIView *mPayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mheight;
@property (weak, nonatomic) IBOutlet UIButton *mPatbtn;
@end
