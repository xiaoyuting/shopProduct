//
//  DYMgr.h
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYMgr : NSObject

//返回动态加载处理对象
+(nonnull instancetype)shareClient;


//开始获取动态资源数据,
-(void)startGetDY;

//加载图片
-(nullable UIImage*)loadMayBeImage:(nullable NSString*)imgNam;

//主题颜色
-(nonnull UIColor*)mainColor;

//背景颜色
-(nonnull UIColor*)backColor;

//分割线颜色
-(nonnull UIColor*)lineColor;

//普通文字描述颜色
-(nonnull UIColor*)textColor;


@end
