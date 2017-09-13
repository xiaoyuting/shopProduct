//
//  ServiceHeadView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ServiceHeadView.h"

@implementation ServiceHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ServiceHeadView *)shareView{
    
    ServiceHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"ServiceHeadView" owner:self options:nil]objectAtIndex:0];
    
    view.mImg.layer.masksToBounds = YES;
    view.mImg.layer.cornerRadius = 4;

    return view;
}

@end
