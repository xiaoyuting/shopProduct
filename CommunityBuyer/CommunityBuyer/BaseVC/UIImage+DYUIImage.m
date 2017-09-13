//
//  UIImage+DYUIImage.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "UIImage+DYUIImage.h"
#import "DYMgr.h"
#import <objc/runtime.h>

@implementation UIImage (DYUIImage)


+ (nullable UIImage *)imageNamedy:(nonnull NSString *)name     // load from main bundle
{
    UIImage* retobj = [[DYMgr shareClient]loadMayBeImage:name];
    if( retobj != nil ) return retobj;
    
    return [UIImage imageNamed:name];
}

@end
