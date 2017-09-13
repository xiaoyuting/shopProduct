//
//  OrderDetailVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQTextView.h"

@interface OrderDetailVC : BaseVC

//订单状态
@property (weak, nonatomic) IBOutlet UIImageView *mTopImg;
@property (nonatomic,strong) SOrderObj *mTagOrder;
@property (nonatomic,assign) int        mOrderId;

@property (weak, nonatomic) IBOutlet UILabel *mOrderState;

//服务人员
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
@property (weak, nonatomic) IBOutlet UIButton *mCuiDanBT;
- (IBAction)mCuidanClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mServiceHeight;

//商家信息
@property (weak, nonatomic) IBOutlet UILabel *mSellerName;
- (IBAction)mSellerClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *mLxkfBT;
@property (weak, nonatomic) IBOutlet UIButton *mLxsjBT;
- (IBAction)mLxkfClick:(id)sender;
- (IBAction)mLxsjClick:(id)sender;

//商品
@property (weak, nonatomic) IBOutlet UIView *mGoodsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mGoodsViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *mPriceType;
@property (weak, nonatomic) IBOutlet UILabel *mYunFeiPrice;
@property (weak, nonatomic) IBOutlet UILabel *mSumPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mYunFeiHeight;

//客户信心
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mPayType;
@property (weak, nonatomic) IBOutlet UILabel *mPlayOrderTime;
@property (weak, nonatomic) IBOutlet UILabel *mArriveTime;
@property (weak, nonatomic) IBOutlet UILabel *mOrderSn;;
@property (weak, nonatomic) IBOutlet UILabel *mRemark;

//底部Button
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;
@property (weak, nonatomic) IBOutlet UIButton *mRightBT;
@property (weak, nonatomic) IBOutlet UIButton *mOneBT;

@property (weak, nonatomic) IBOutlet UILabel *mproprice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mprohi;



@property (nonatomic ,copy) NSString  * type;

+(void)gotoOrderDetailWithOrderId:(int)orderId vc:(UIViewController*)vc;
+(void)whereToGo:(SOrderObj*)order vc:(UIViewController*)vc;
+(OrderDetailVC*)whichVC:(SOrderObj*)order;






@end
