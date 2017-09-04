//
//  MDManager.h
//  MDPublicLib
//
//  Created by App on 15/5/12.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonModel.h"
#import "MDPublicData.h"

@class VirtualKey;

@interface MDManager : NSObject
single_h(Manager)

/**
 *  初始化蓝牙的状态，需要提前初始化哦。
 */
-(void)initBlue;

/**
 *  设置应用的AppKey
 */
-(void)setAppKey:(NSString *)appKey;

/**
 *  设置开门声响策略
 */
-(void)setSoundType:(OpenSoundType)soundType;

/**
 *  设置开门声响文件路径
 */
-(void)setOpenDoorSound:(NSString *)soundFile;

/**
 *  设置开门成功声响文件路径
 */
-(void)setOpenDoorSuccessSound:(NSString *)soundFile;

/**
 *  钥匙开门
 *
 *  @param userId       用户 ID
 *  @param keyId        用户 ID
 *  @param keyName      钥匙名称
 *  @param community    小区标识
 *  @param success      开门成功后执行的操作
 *  @param failure      开门失败后执行的操作
 */

-(void)openDoorWithUserId:(NSString *)userId UseKeyId:(NSString *)keyId
                  KeyName:(NSString *)keyName Community:(NSString *)community
                  Success:(void (^)()) success
                  Failure:(void(^)(NSUInteger errorCode)) failure;


/**
 *  摇一摇开门
 *
 *  @param userId         用户 ID
 *  @param keyIdList      钥匙 ID列表
 *  @param keyNameList    钥匙名称列表
 *  @param communityList  小区标识列表
 *  @param isSupportShake 摇一摇开关
 *  @param success        开门成功后执行的操作
 *  @param failure        开门失败后执行的操作
 */
-(void)shakeOpenDoorWithUserId:(NSString *)userId UseKeyIdList:(NSArray *)keyIdList
                   KeyNameList:(NSArray *)keyNameList CommunityList:(NSArray *)communityList
                isSupportShake:(BOOL)isSupportShake
                       Success:(void (^)(NSDictionary *keyInfo)) success
                       Failure:(void (^)(NSUInteger errorCode)) failure;


/**
 *  一键开门
 *
 *  @param userId         用户 ID
 *  @param keyIdList      钥匙 ID列表
 *  @param keyNameList    钥匙名称列表
 *  @param communityList  小区标识列表
 *  @param success        开门成功后执行的操作
 *  @param failure        开门失败后执行的操作
 */
-(void)oneKeyOpenDoorWithUserId:(NSString *)userId UseKeyIdList:(NSArray *)keyIdList
                   KeyNameList:(NSArray *)keyNameList CommunityList:(NSArray *)communityList
                       Success:(void (^)(NSDictionary *keyInfo)) success
                       Failure:(void (^)(ErrorType errorCode)) failure;

@end

