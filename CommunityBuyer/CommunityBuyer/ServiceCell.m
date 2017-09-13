//
//  ServiceCell.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/26.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

- (void)awakeFromNib {
    // Initialization code
    _mLeftV.layer.masksToBounds = YES;
    _mLeftV.layer.cornerRadius = 3;
    
    _mRightV.layer.masksToBounds = YES;
    _mRightV.layer.cornerRadius = 3;
    
    self.contentView.backgroundColor = COLOR(237, 237, 235);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
