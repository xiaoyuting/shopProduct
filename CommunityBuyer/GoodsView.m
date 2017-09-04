//
//  GoodsView.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/13.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "GoodsView.h"

@implementation GoodsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (GoodsView *)shareView{
    
    GoodsView *view = [[[NSBundle mainBundle]loadNibNamed:@"GoodsView" owner:self options:nil]objectAtIndex:0];
    view.mImg.layer.masksToBounds = YES;
    view.mImg.layer.cornerRadius = 4;
    return view;
}


+ (GoodsView *)shareViewTwo{
    
    GoodsView *view = [[[NSBundle mainBundle]loadNibNamed:@"GoodsServiceView" owner:self options:nil]objectAtIndex:0];
    view.mImg.layer.masksToBounds = YES;
    view.mImg.layer.cornerRadius = 4;
    return view;
}
@end
