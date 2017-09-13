//
//  CellButton.h
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/16.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton

@property (nonatomic,strong)    NSIndexPath *indexPath;

@property (nonatomic,strong)    SGoods *mGoods;

@property (nonatomic,assign)    id  mrefobj;//cell关联的对象,,,

@end
