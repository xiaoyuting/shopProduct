//
//  myStoreView.h
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/9.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mCustomImage.h"

@interface myStoreView : UIView


+(myStoreView *)shareView;
///商户类型
@property (weak, nonatomic) IBOutlet UIButton *mStoreTypeBtn;
///剪头
@property (weak, nonatomic) IBOutlet UIImageView *mDownImg;
///店铺logo
@property (weak, nonatomic) IBOutlet UIImageView *mLogo;
///店铺logo按钮
@property (weak, nonatomic) IBOutlet UIButton *mLogoBtn;
///店铺名称
@property (weak, nonatomic) IBOutlet UITextField *mStoreName;
///经营类型按钮
@property (weak, nonatomic) IBOutlet UIButton *mSaleTypeBtn;
///线
@property (weak, nonatomic) IBOutlet UIView *mLine;


@property (weak, nonatomic) IBOutlet UILabel *mArea;
@property (weak, nonatomic) IBOutlet UIButton *mAreaBT;
@property (weak, nonatomic) IBOutlet UITextField *mAddressDetail;
@property (weak, nonatomic) IBOutlet UILabel *mServiceRange;
@property (weak, nonatomic) IBOutlet UIButton *mRangeBT;

///地址
@property (weak, nonatomic) IBOutlet UITextField *mAddress;
///电话
@property (weak, nonatomic) IBOutlet UITextField *mPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *mNameText;

@property (weak, nonatomic) IBOutlet UITextField *mName;


///身份证
@property (weak, nonatomic) IBOutlet UITextField *mIdCard;


+(myStoreView *)shareBottomView;
///身份证图片
@property (weak, nonatomic) IBOutlet UIImageView *mCardZ;

@property (weak, nonatomic) IBOutlet UIImageView *mCardB;

@property (weak, nonatomic) IBOutlet UIImageView *mZenJian;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mZenJianHeight;

///简介
@property (weak, nonatomic) IBOutlet UITextView *mNote;
///提交按钮
@property (weak, nonatomic) IBOutlet UIButton *mSubmitBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAddressDetailBT;


+(myStoreView *)shareTypeView;
///便利店图片
@property (weak, nonatomic) IBOutlet UIImageView *mStoreImg;
///便利店按钮
@property (weak, nonatomic) IBOutlet UIButton *mStoreBtn;
///美食图片
@property (weak, nonatomic) IBOutlet UIImageView *mFoodImg;
///美食按钮
@property (weak, nonatomic) IBOutlet UIButton *mFoodBtn;
///汽车图片
@property (weak, nonatomic) IBOutlet UIImageView *mCarImg;
///汽车按钮
@property (weak, nonatomic) IBOutlet UIButton *mCarBtn;
///确定按钮
@property (weak, nonatomic) IBOutlet UIButton *mOkBtn;



@end
