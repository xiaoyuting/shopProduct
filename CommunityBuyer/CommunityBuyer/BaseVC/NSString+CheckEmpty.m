//
//  NSString+CheckEmpty.m
//  YiZanService
//
//  Created by ljg on 15-3-19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "NSString+CheckEmpty.h"

@implementation NSString (CheckEmpty)
-(BOOL)isEmpty
{
    if ([self isEqualToString:@""]||self.length == 0) {
        return YES;
    }
    return NO;
}
@end
