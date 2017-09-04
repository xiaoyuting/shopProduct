//
//  DYMgr.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "DYMgr.h"

static DYMgr* g_dymsr = nil;
@implementation DYMgr

//返回动态加载处理对象
+(nonnull instancetype)shareClient
{
    if( g_dymsr ) return g_dymsr;
    @synchronized(self) {
        
        if( g_dymsr == nil )
        {
            g_dymsr = [[DYMgr alloc]init];
        }
    }
    return g_dymsr;
}

-(nonnull instancetype)init
{
    self = [super init];
    [self clearErr];
    
    
    
    return self;
}

//开始获取动态资源数据,
-(void)startGetDY
{
    //1.下载..
    
    //2.解压..
    
    //3.移动文件夹
    
}

//清理错误情况遗留的数据,,比如,压缩包,文件夹,
-(void)clearErr
{
    
}


//加载图片
-(nullable UIImage*)loadMayBeImage:(nullable NSString*)imgNam
{
    return nil;
}


//主题颜色
-(nonnull UIColor*)mainColor
{
    return [UIColor colorWithRed:245/255.0f green:77/255.0f blue:25/255.0f alpha:1.000];
}

//背景颜色
-(nonnull UIColor*)backColor
{
    return [UIColor colorWithRed:232/255.0f green:234/255.0f blue:235/255.0f alpha:1.000];
}

//分割线颜色
-(nonnull UIColor*)lineColor
{
    return [UIColor colorWithRed:197/255.0f green:196/255.0f blue:202/255.0f alpha:1.000];
}

//普通文字描述颜色
-(nonnull UIColor*)textColor
{
    return [UIColor colorWithRed:143/255.0f green:144/255.0f blue:145/255.0f alpha:1.000];
}


@end
