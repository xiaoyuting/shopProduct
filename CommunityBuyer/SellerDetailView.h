//
//  SellerDetailView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/25.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerDetailView : BaseVC

@property (nonatomic,strong) SSeller *mSeller;

@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgImg;
@property (weak, nonatomic) IBOutlet UILabel *mQPrice;
@property (weak, nonatomic) IBOutlet UILabel *mPPrice;
@property (weak, nonatomic) IBOutlet UILabel *mAdv;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAdvHeight;

@property (weak, nonatomic) IBOutlet SImageView *mLogo;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mRemark;

@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mBottomHeight;

@property (weak, nonatomic) IBOutlet UIView *mButtonView;
- (IBAction)CallClick:(id)sender;

- (IBAction)mAdvClick:(id)sender;

@end
