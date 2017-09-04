//
//  OwnFooter.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/1.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "OwnFooter.h"

@implementation OwnFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (OwnFooter *)shareView{
    
    OwnFooter *view =  [[[NSBundle mainBundle]loadNibNamed:@"OwnFooter" owner:self options:nil]objectAtIndex:0];
    
    return view;
}
@end
