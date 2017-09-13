//
//  addMapVC.h
//  YiZanService
//
//  Created by zzl on 15/3/23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "BaseVC.h"

@class SAddress;

@protocol addMapDelegate <NSObject>

- (void)setAddress:(SAddress *)address;

@end


@interface addMapVC : BaseVC

@property (nonatomic,strong) id<addMapDelegate>delegate;
@property (nonatomic,assign) BOOL       mJustSelect;//如果是从下单那边过来的,仅仅是为了选择一个地址而已,不需要添加
@property (nonatomic,strong) void(^itblock)(SAddress* retobj);

@property (nonatomic,strong) NSArray*   mItRegions;//坐标点


@end
