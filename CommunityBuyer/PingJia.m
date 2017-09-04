//
//  PingJia.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/13.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "PingJia.h"

@implementation PingJia

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (PingJia *)shareView{

    PingJia *view = [[[NSBundle mainBundle]loadNibNamed:@"PingJia" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
