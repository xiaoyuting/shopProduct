//
//  CBCUtil.h
//  YiZanService
//
//  Created by zzl on 15/4/1.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCUtil : NSObject

+ (NSString*) CBCEncrypt:(NSString *)plainText key:(NSString*)ptKey index:(int)index;

+ (NSString*) CBCDecrypt:(NSString *)encryptText key:(NSString*)ptKey index:(int)index;


@end
