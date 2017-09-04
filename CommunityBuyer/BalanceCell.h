//
//  BalanceCell.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mTradName;//交易名称
@property (weak, nonatomic) IBOutlet UILabel *mOrderID;//订单号
@property (weak, nonatomic) IBOutlet UILabel *mBlance;//余额
@property (weak, nonatomic) IBOutlet UILabel *mTradPrice;//交易金额
@property (weak, nonatomic) IBOutlet UILabel *mTime;//时间

@end
