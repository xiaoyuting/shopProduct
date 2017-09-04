//
//  TieRebackCell.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/18.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "TieRebackCell.h"

@implementation TieRebackCell

- (void)awakeFromNib {
    // Initialization code
    self.mheadimg.layer.cornerRadius = self.mheadimg.bounds.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rebackclicked:(id)sender {
    
    if( self.mtagref && self.mselref )
        [self.mtagref performSelector:self.mselref withObject:sender];
}

@end
