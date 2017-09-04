//
//  ActivityCell.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/7.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "ActivityCell.h"

@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
    _mBgView.layer.masksToBounds = YES;
    _mBgView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
