//
//  ContentScrollView.m
//  YiZanService
//
//  Created by ljg on 15-3-23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "ContentScrollView.h"

@implementation ContentScrollView

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    if (self.needFix) {
        self.contentSize = CGSizeMake(DEVICE_Width, view.frame.origin.y+view.frame.size.height);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
