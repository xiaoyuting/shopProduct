//
//  orderCouponView.m
//  CommunityBuyer
//
//  Created by wangke on 16/2/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "orderCouponView.h"

@implementation orderCouponView

+ (orderCouponView *)shareView{

    orderCouponView *view = [[[NSBundle mainBundle] loadNibNamed:@"orderCouponView" owner:self options:nil] objectAtIndex:0];


    
    
    view.backgroundColor = [UIColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:0.2];
    
    view.mSendBtn.layer.masksToBounds = view.mView.layer.masksToBounds = YES;
    view.mSendBtn.layer.cornerRadius = view.mView.layer.cornerRadius = 3;
    
    return view;
    

}


+ (orderCouponView *)initShareView{
    
    orderCouponView *view = [[[NSBundle mainBundle] loadNibNamed:@"shareView" owner:self options:nil] objectAtIndex:0];
    
    
    return view;
}


@end
