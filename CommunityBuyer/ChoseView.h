//
//  ChoseView.h
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellButton.h"

@interface ChoseView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *mImg;
@property (weak, nonatomic) IBOutlet DYMainLabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mNumKu;
@property (weak, nonatomic) IBOutlet UILabel *mGuige;
@property (weak, nonatomic) IBOutlet CellButton *mJianBT;
@property (weak, nonatomic) IBOutlet CellButton *mJiaBT;

@property (weak, nonatomic) IBOutlet UILabel *mNum;
@property (weak, nonatomic) IBOutlet CellButton *mJiaCar;
@property (weak, nonatomic) IBOutlet CellButton *mBuy;
@property (weak, nonatomic) IBOutlet UIButton *mClose;
@property (weak, nonatomic) IBOutlet UIView *mGuigeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mGuigeHeight;

+ (ChoseView *)shareView;

@end
