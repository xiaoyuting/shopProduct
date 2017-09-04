//
//  SellerDetailVC.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerDetailVC : BaseVC

@property (nonatomic,strong) SServiceInfo *mServiceInfo;
@property (nonatomic,strong) SGoods *mGoods;
@property (nonatomic,strong) SSeller *mSeller;

@property (nonatomic,assign) int    mSumNum;
@property (nonatomic,assign) float    mSumprice;

@property (weak, nonatomic) IBOutlet UIButton *mDelButton;
@property (weak, nonatomic) IBOutlet UIButton *mAddButton;

@property (nonatomic,assign) int    mType;
@property (weak, nonatomic) IBOutlet SImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet DYMainLabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mSellNum;

@property (weak, nonatomic) IBOutlet UILabel *mServiceTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTimeHeight;


@property (weak, nonatomic) IBOutlet UIButton *mCarBt;
@property (weak, nonatomic) IBOutlet DYMainLabel *mSumPrice;
@property (weak, nonatomic) IBOutlet UIButton *mBT;
@property (weak, nonatomic) IBOutlet UILabel *mNum;

@property (weak, nonatomic) IBOutlet UIWebView *mWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mWebViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *mTypeDetail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTopHeight;


- (IBAction)mOKClick:(id)sender;

- (IBAction)mTimeClick:(id)sender;
- (IBAction)mGoDetailClick:(id)sender;
- (IBAction)mDelClick:(id)sender;

- (IBAction)mAddClick:(id)sender;

@end
