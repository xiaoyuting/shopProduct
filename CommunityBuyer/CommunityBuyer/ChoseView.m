//
//  ChoseView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ChoseView.h"

@implementation ChoseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (ChoseView *)shareView{

    ChoseView *view = [[[NSBundle mainBundle]loadNibNamed:@"ChoseView" owner:self options:nil]objectAtIndex:0];
    view.mImg.layer.masksToBounds = YES;
    view.mImg.layer.cornerRadius = 5;
    view.mImg.layer.borderColor = M_TCO.CGColor;
    view.mImg.layer.borderWidth = 0.45;
    return view;
}

@end
