//
//  ShopCarFooterView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ShopCarFooterView.h"

@implementation ShopCarFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ShopCarFooterView *)shareView{
    
    ShopCarFooterView *view = [[[NSBundle mainBundle]loadNibNamed:@"ShopCarFooterView" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
