//
//  ShopCarView.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/22.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "ShopCarView.h"

@implementation ShopCarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(ShopCarView *)shareView
{
    ShopCarView *view = [[[NSBundle mainBundle]loadNibNamed:@"ShopCarView" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
