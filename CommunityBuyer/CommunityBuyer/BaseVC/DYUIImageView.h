//
//  DYUIImageView.h
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 //处理动态 加载图片资源问题,,主要解决XIB里面的 UIImageView 对象,,
 在处理XIB的时候,,需要设置下, User Defined RunTime Attrib,,就是通过XIB设置 UIImageView 的属性
 
 通过判断 重载 initWithImage 函数,,在里面判断 mdy 是否是空,如果不是,就用mdy的图片,
 
 */
@interface DYUIImageView : UIImageView

- (nonnull instancetype)initWithImage:(nullable UIImage *)image;
- (nonnull instancetype)initWithImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage;

@property (nullable,nonatomic,strong) NSString*  mdy;//动态设置的图片名字,


@end
