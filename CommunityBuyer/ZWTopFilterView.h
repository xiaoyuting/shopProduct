//
//  ZWTopFilterView.h
//  MeiRongSeller
//
//  Created by zzl on 15/12/17.
//  Copyright © 2015年 zongyoutec.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWTopFilterView : UIView

//创建一个顶部的过滤View
+(ZWTopFilterView*)makeTopFilterView:(NSArray*)allTitles MainCorol:(UIColor*)MainCorol rect:(CGRect)rect;

//创建一个顶部可滚动的过滤View
+(ZWTopFilterView*)makeScrollTopFilterView:(NSArray*)allTitles MainCorol:(UIColor*)MainCorol rect:(CGRect)rect Width:(float)width IsBorder:(BOOL)border;

//当顶部选择时候的事件,,
@property(nonatomic,strong) void(^mitblock)(int fromIndex,int toIndex);

//返回当前选中
-(int)getNowIndex;

//设置到某个一个
-(void)changeToIndex:(int)index;


//更换所有的title
-(void)changeAllTitles:(NSArray*)all;


@end
