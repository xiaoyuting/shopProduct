//
//  CellButton.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/16.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "CellButton.h"

@implementation CellButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
}

- (void)setMGoods:(SGoods *)mGoods{
    _mGoods = mGoods;
}

@end
