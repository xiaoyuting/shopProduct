//
//  searchInMap.h
//  YiZanService
//
//  Created by zzl on 15/3/23.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "BaseVC.h"
#import <QMapKit/QMapKit.h>

@interface searchInMap : BaseVC

@property (nonatomic,strong) NSArray*   mItRegions;//坐标点


@property (nonatomic,strong)    void(^itblock)(NSString* addr,float lng,float lat);

@property (nonatomic,strong)    NSString*   mNowAddr;
@property (nonatomic,assign)    float       mLat;
@property (nonatomic,assign)    float       mLng;

@end

@interface SOnePoly : NSObject

@property (nonatomic,assign) CLLocationCoordinate2D*    mpbuffer;
@property (nonatomic,assign) NSInteger                  mcount;

+(BOOL)isInPoly:(NSArray*)all nowll:(CLLocationCoordinate2D)nowll;

@end