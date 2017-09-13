//
//  VillageCell.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "VillageCell.h"

@implementation VillageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)ButtonViewDisplay:(BOOL)bshow
{
    self.mButtonheight.constant=  bshow ? 50:0;
}

@end
