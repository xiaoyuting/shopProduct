//
//  ZWImageWaperView.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/28.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZWImageWaperView : UIView

@property (nonatomic,assign) BOOL   mbShowBig;//是否点击查看大图. 默认 YES
@property (nonatomic,assign) int    mlayoutal;//0 靠左, 1居中 ,2. 默认 0
@property (nonatomic,assign) CGFloat mtbpading;//上下的间隔,,默认 10;

//图片数组,allimgs: 所有的图片URL ,  右 block: allViewSize 分别返回每个图片的size,最后一个是 自己的size,调用者 必须设置尺寸,因为,如果这个view是被约束控制的,自己是没办法设置尺寸的,

//当宽度固定了之后再调用这个,,,里面缩放尺寸会以宽度为准
-(void)showSomeImages:(NSArray*)allimgs imgsblock:(void(^)(NSArray* allViewSize))block;


@end
