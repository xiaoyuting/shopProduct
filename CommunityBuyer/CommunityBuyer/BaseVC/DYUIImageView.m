//
//  DYUIImageView.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/18.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "DYUIImageView.h"
#import "DYMgr.h"
@implementation DYUIImageView

- (instancetype)initWithImage:(nullable UIImage *)image
{
    if( self.mdy )
    {
        UIImage* t = [[DYMgr shareClient]loadMayBeImage: self.mdy];
        if( t != nil ) return t;
    }
    return [super initWithImage:image];
}

- (instancetype)initWithImage:(nullable UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage
{
    if( self.mdy )
    {
        UIImage* t = [[DYMgr shareClient]loadMayBeImage: self.mdy];
        if( t != nil ) return [super initWithImage:t highlightedImage:highlightedImage];
    }
    return [super initWithImage:image highlightedImage:highlightedImage];
}

@end