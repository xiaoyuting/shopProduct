//
//  ResSectionFooterView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ResSectionFooterView.h"

@implementation ResSectionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ResSectionFooterView *)shareView{
    
    ResSectionFooterView *view = [[[NSBundle mainBundle]loadNibNamed:@"ResSectionFooterView" owner:self options:nil]objectAtIndex:0];
    
    return view;
}

@end
