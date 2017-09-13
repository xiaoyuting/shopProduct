//
//  OrderCell.m
//  YiZanService
//
//  Created by ljg on 15-3-26.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    // Initialization code
    self.mLeftBT.layer.masksToBounds = YES;
    self.mLeftBT.layer.cornerRadius = 3;
    [self.mLeftBT.layer setBorderWidth:1.0];   //边框宽度
    self.mLeftBT.layer.borderColor = COLOR(68, 159, 243).CGColor;
   
    
    self.mRightBT.layer.masksToBounds = YES;
    self.mRightBT.layer.cornerRadius = 3;
    [self.mRightBT.layer setBorderWidth:1.0];   //边框宽度
    self.mRightBT.layer.borderColor = COLOR(249, 8, 59).CGColor;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
