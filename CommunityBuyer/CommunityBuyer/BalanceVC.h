//
//  BalanceVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@interface BalanceVC : BaseVC
@property (weak, nonatomic) IBOutlet UIView *bzView;
@property (weak, nonatomic) IBOutlet UIView *ysVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jieSuanH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beiZhuH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunSongH;
@property (weak, nonatomic) IBOutlet UIButton *distributionBtn;
@property (weak, nonatomic) IBOutlet UIButton *distributionOwnBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectTime;

@property (weak, nonatomic) IBOutlet UIView *distributionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numH;
@property (weak, nonatomic) IBOutlet UIView *pushView;
@property (weak, nonatomic) IBOutlet UITextField *numField;

@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pushH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeHeight;


@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIView *costView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *costHeight;





@property (nonatomic,strong) SAddress *mSAddress;
@property (nonatomic,strong) SCarSeller *mCarSeller;
@property (nonatomic,strong) NSMutableArray *mGoodsAry;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;

@property (weak, nonatomic) IBOutlet UIView *mImgBgView;
@property (weak, nonatomic) IBOutlet UILabel *mNum;

@property (weak, nonatomic) IBOutlet UILabel *mPeisonText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mPeiSonViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *mTimeText;
@property (weak, nonatomic) IBOutlet UILabel *mPeison;


@property (weak, nonatomic) IBOutlet UILabel *mTime;

@property (weak, nonatomic) IBOutlet UITextField *mHeKa;
@property (weak, nonatomic) IBOutlet UITextField *mFaPiao;
@property (weak, nonatomic) IBOutlet UITextField *mBeiZhu;

@property (weak, nonatomic) IBOutlet UILabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mYunFei;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mYunFeiHeight;


@property (weak, nonatomic) IBOutlet UILabel *mHeJi;
@property (weak, nonatomic) IBOutlet UILabel *mSystempayTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mPayViewHeight;
@property (weak, nonatomic) IBOutlet UIView *mPayView;
@property (weak, nonatomic) IBOutlet UILabel *mNoAddress;

@property (weak, nonatomic) IBOutlet UILabel *SumPrice;

@property (weak, nonatomic) IBOutlet UILabel *mproprice;



@property (weak, nonatomic) IBOutlet UILabel *timeText;

- (IBAction)GoAddressClick:(id)sender;

- (IBAction)GoPayClick:(id)sender;
- (IBAction)mTimeClick:(id)sender;
- (IBAction)mChooseCoupon:(id)sender;

@end
