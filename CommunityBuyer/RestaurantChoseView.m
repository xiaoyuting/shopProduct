//
//  RestaurantChoseView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/13.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "RestaurantChoseView.h"

@implementation RestaurantChoseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (RestaurantChoseView *)shareView{
    
    RestaurantChoseView *view = [[[NSBundle mainBundle]loadNibNamed:@"RestaurantChoseView" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
