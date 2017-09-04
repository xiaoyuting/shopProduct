//
//  PingJiaHeadView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "PingJiaHeadView.h"

@implementation PingJiaHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (PingJiaHeadView *)shareView{

    PingJiaHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"PingJiaHeadView" owner:self options:nil]objectAtIndex:0];
    return view;

}

+ (PingJiaHeadView *)shareView2{
    
    PingJiaHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"PingJiaSectionView" owner:self options:nil]objectAtIndex:0];
    return view;
    
}

@end
