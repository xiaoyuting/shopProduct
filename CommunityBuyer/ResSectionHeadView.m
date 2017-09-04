//
//  ResSectionHeadView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ResSectionHeadView.h"

@implementation ResSectionHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ResSectionHeadView *)shareView{
    
    ResSectionHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"ResSectionHeadView" owner:self options:nil]objectAtIndex:0];
    
    return view;
}

@end
