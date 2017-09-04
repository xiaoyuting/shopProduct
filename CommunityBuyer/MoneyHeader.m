//
//  MoneyHeader.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/1.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "MoneyHeader.h"

@implementation MoneyHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (MoneyHeader *)shareView{
    
    MoneyHeader *view =  [[[NSBundle mainBundle]loadNibNamed:@"MoneyHeader" owner:self options:nil]objectAtIndex:0];
    
    return view;
}

@end
