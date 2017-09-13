//
//  AnnouncementCell.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "AnnouncementCell.h"

@implementation AnnouncementCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _mRedPoint.clipsToBounds=YES;
    _mRedPoint.layer.cornerRadius=4;
}

@end
