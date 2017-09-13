//
//  MapView.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "MapView.h"

@implementation MapView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (MapView *)shareView{

    MapView *view = [[[NSBundle mainBundle]loadNibNamed:@"MapView" owner:self options:nil]objectAtIndex:0];
    return view;
}

@end
