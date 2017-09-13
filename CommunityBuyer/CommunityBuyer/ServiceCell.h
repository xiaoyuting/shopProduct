//
//  ServiceCell.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/26.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"


@interface ServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mLeftV;
@property (weak, nonatomic) IBOutlet UIView *mRightV;
@property (weak, nonatomic) IBOutlet CustomButton *mLeftBT;
@property (weak, nonatomic) IBOutlet CustomButton *mRightBT;
@property (weak, nonatomic) IBOutlet SImageView *mLeftImg;
@property (weak, nonatomic) IBOutlet SImageView *mRightImg;
@property (weak, nonatomic) IBOutlet UILabel *mLeftName;
@property (weak, nonatomic) IBOutlet UILabel *mRightName;
@property (weak, nonatomic) IBOutlet UILabel *mLeftTime;
@property (weak, nonatomic) IBOutlet UILabel *mRightTime;
@property (weak, nonatomic) IBOutlet UILabel *mLeftPrice;
@property (weak, nonatomic) IBOutlet UILabel *mRightPrice;


@end
