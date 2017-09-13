//
//  OrderCell.h
//  YiZanService
//
//  Created by ljg on 15-3-26.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CunsomLabel.h"

@class myActButton;

@interface OrderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *stateLB;

@property (weak, nonatomic) IBOutlet UILabel *mOrderSn;

@property (weak, nonatomic) IBOutlet UIView *mImgBgView;
@property (weak, nonatomic) IBOutlet UILabel *mNum;
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
@property (weak, nonatomic) IBOutlet UIButton *mDelBT;
@property (weak, nonatomic) IBOutlet UIButton *mRightBT;
@property (weak, nonatomic) IBOutlet UIButton *mLeftBT;

@end
