//
//  orderCouponView.h
//  CommunityBuyer
//
//  Created by wangke on 16/2/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderCouponView : UIView
/**
 *  取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mCancelBtn;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet WPHotspotLabel *mTitle;
/**
 *  内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mContent;
/**
 *  子内容
 */
@property (weak, nonatomic) IBOutlet UILabel *mSubContent;
/**
 *  发送按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *mSendBtn;


@property (weak, nonatomic) IBOutlet UIView *mView;



+ (orderCouponView *)shareView;

#pragma mark----分享按钮view

/**
 *  微信朋友圈
 */
@property (weak, nonatomic) IBOutlet UIButton *mWechatQ;

/**
 *  微信好友
 */
@property (weak, nonatomic) IBOutlet UIButton *mWechatF;

+ (orderCouponView *)initShareView;

@end
