//
//  CollectHeadView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "CollectHeadView.h"

@implementation CollectHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CollectHeadView *)shareView{
    
    CollectHeadView *view = [[[NSBundle mainBundle]loadNibNamed:@"CollectHeadView" owner:self options:nil]objectAtIndex:0];
    
    return view;
}

@end
