//
//  blockmsgcell.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "blockmsgcell.h"

@implementation blockmsgcell

- (void)awakeFromNib {
    // Initialization code
    
    self.mheadimg.layer.cornerRadius = self.mheadimg.bounds.size.height/2;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
