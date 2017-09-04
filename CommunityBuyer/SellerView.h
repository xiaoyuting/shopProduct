//
//  SellerView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mQPrice;
@property (weak, nonatomic) IBOutlet UILabel *mPPrice;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
@property (weak, nonatomic) IBOutlet UILabel *mAdv;
@property (weak, nonatomic) IBOutlet UILabel *mRemark;
@property (weak, nonatomic) IBOutlet UIButton *mCallBT;
@property (weak, nonatomic) IBOutlet UIButton *mAdvBT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mAdvHeight;

+ (SellerView *)shareView;

@end
