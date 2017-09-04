//
//  CollectCell.h
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/11.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"
#import "SWTableViewCell.h"

@interface CollectCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet SImageView *mImg;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UIView *mXing;

@property (weak, nonatomic) IBOutlet DYDescLabel *mPrice;
@property (weak, nonatomic) IBOutlet UILabel *mSellNum;


@property (weak, nonatomic) IBOutlet UILabel *mKm;
@property (weak, nonatomic) IBOutlet UILabel *mQsPrice;

- (void)setStar:(float)num;

@end
