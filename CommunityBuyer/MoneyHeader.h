//
//  MoneyHeader.h
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/1.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyHeader : UIView
+ (MoneyHeader *)shareView;
@property (weak, nonatomic) IBOutlet UIButton *mMoneyBtn;//余额按钮
@property (weak, nonatomic) IBOutlet UIButton *mCouponBtn;//优惠券按钮
@property (weak, nonatomic) IBOutlet UILabel *mCouponNum;//优惠券
@property (weak, nonatomic) IBOutlet UILabel *mMoneyNum;//余额
@end
