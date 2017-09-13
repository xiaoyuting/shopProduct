//
//  SellerView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "SellerView.h"

@implementation SellerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (SellerView *)shareView{
    
    SellerView *view = [[[NSBundle mainBundle]loadNibNamed:@"SellerView" owner:self options:nil]objectAtIndex:0];
    return view;
    
}

@end
