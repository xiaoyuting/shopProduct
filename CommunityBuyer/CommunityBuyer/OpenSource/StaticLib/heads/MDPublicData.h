//
//  PublicData.h
//  MiaoDouLib
//
//  Created by App on 6/15/15.
//  Copyright (c) 2015 App. All rights reserved.
//

#ifndef MiaoDouLib_PublicData_h
#define MiaoDouLib_PublicData_h


#endif

typedef NS_ENUM(NSUInteger, ErrorType){
    ERR_UNKNOWN = 0,                            //未知错误
    ERR_APP_KEY_MISS = -1000,                   //APP_ID 缺失
    ERR_DEVICE_ADDRESS_EMPTY = -2001,           //设备 mac 地址为空
    ERR_BLUETOOTH_DISABLE = -2002,              //蓝牙未开启
    ERR_DEVICE_INVALID = -2003,                 //设备失效
    ERR_DEVICE_CONNECT_FAIL = -2004,            //与设备建立连接失败
    ERR_DEVICE_OPEN_FAIL = -2005,               //开门失败
    ERR_DEVICE_DISCONNECT = -2006,              //与设备断开连接
    ERR_DEVICE_PARSE_RESPONSE_FAIL = -2007,     //解析数据失败
    ERR_APP_ID_MISMATCH = -2008,                //APP_KEY 与应用不匹配
    ERR_NO_AVAILABLE_DEVICES = -2009,            //附近没有可用设备
    ERR_DEVICE_SCAN_TIMEOUT = -2010,            //设备扫描超时
    ERR_DEVICE_CONNECT_TIMEOUT = -2011,         //设备连接超时
    ERR_KEY_STRING_PARSE_FAIL = -2012,          //钥匙信息解析失败
    ERR_SHAKE_KEY = -2013,                      //摇一摇钥匙参数信息有误
    ERR_OPEN_PARAMETER_WRONG = -2014,           //开门参数中存在nil或空字符串
    ERR_BLE_SERVICE_FOUND_FAILURE = -2015 ,     //蓝牙服务发现失败
    ERR_BLE_CHARACTER_FOUND_FAILURE = -2016,    //蓝牙特征值发现失败
    ERR_BLE_UPDATE_VALUE_FAILURE = -2017,       //获取蓝牙订阅值错误
    ERR_KEY_TIMEOUT = -2018,                    //钥匙有效期失效
    
    ERR_NETWORK_ERROR = -3001,                  //联网上传失败
    ERR_AUTHORIZE_INVALID = -3002              //授权无效
};

typedef NS_ENUM(NSUInteger, OpenSoundType){
    OpenSoundTypeNone,      //  无音效
    OpenSoundTypeDefault1,  //  预定义:开门成功时,播放音效"DingDong"
    OpenSoundTypeDefault2,  //  预定义:开门时,播放音效"ShuaShua" + 开门成功时,播放音效"DingDong"
    OpenSoundTypeCustom     //  如果不喜欢预定义音效方案可以使用自定义音效；
};






























































//自定义动画预留类型，即将上线(勿删，否则出错)
typedef NS_ENUM(NSUInteger, AnimationType){
    AnimationTypeNone,
    AnimationTypeDefault1,
    AnimationTypeDefault2
};
