//
//  ZWSideBtImg.h
//  CommunityBuyer
//
//  Created by zzl on 16/1/4.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWSideBtImg;
@protocol ZWSideBtImgDelegate <NSObject>

@optional
-(void)btclicked:(UIButton*)bt imagetag:(ZWSideBtImg*)imagetag;

-(void)imgclicked:(ZWSideBtImg*)imagetag;

@end

@interface ZWSideBtImg : UIImageView

@property (nonatomic,assign)    BOOL        mbShowBt;//default yes
@property (nonatomic,assign)    int         mDicBt;// 0:左上角  1:右上角 2:右下角 3:左下角 default 1
@property (nonatomic,strong)    UIImage*    mImageBt;//按钮图标

//使用block或者协议
@property (nonatomic,strong)    void(^mbtClicked)(ZWSideBtImg*);
@property (nonatomic,assign)    void(^mimgClicked)(ZWSideBtImg*);
@property (nonatomic,assign)    id<ZWSideBtImgDelegate> mdelegate;

@end

