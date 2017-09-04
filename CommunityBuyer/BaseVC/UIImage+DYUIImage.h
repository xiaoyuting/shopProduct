//
//  UIImage+DYUIImage.h
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 处理动态图片资源问题,,通过在预编译头里面引入这个,类别,分类,,
 让整个APP加载图片的地方都经过这里,,然后这里判断是否加载其他地方的图片,,
 
 通过重写 imageNamed ,在里面判断 是否有 name 名字的图片在缓存区域,,如果有,就用,没有就用原来的,
 
*/
@interface UIImage (DYUIImage)

+ (nullable UIImage *)imageNamedy:(nonnull NSString *)name;      // load from main bundle

@end
