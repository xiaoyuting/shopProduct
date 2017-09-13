//
//  ShopCarHeadView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ShopCarHeadView.h"

@implementation ShopCarHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ShopCarHeadView *)shareView{
    
    ShopCarHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"ShopCarHeadView" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
