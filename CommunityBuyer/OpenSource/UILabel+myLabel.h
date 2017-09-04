//
//  UILabel+myLabel.h
//  tour
//
//  Created by zzl on 14-10-6.
//  Copyright (c) 2014年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (myLabel)
//这个用于高度定死了,自动设置宽度
-(void)autoReSizeWidthForContent:(CGFloat)maxW;

//这个用于宽度定死了,自动设置高度
-(void)autoResizeHeightForContent:(CGFloat)maxH;

@end