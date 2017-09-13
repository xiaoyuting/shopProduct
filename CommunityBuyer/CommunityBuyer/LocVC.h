//
//  LocVC.h
//  YiZanService
//
//  Created by zzl on 15/3/25.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "BaseVC.h"

@interface LocVC : BaseVC

@property (nonatomic,strong) NSArray*       mItpolys;
@property (nonatomic,strong) void(^itblock)(SAddress* getone);

@end
