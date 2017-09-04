//
//  SingletonModel.h
//  MDPublicLib
//
//  Created by App on 15/5/12.
//  Copyright (c) 2015年 App. All rights reserved.
//

#ifndef MDPublicLib_SingletonModel_h
#define MDPublicLib_SingletonModel_h

#endif

/**
 *  单例宏定义
 */
#define single_h(name) +(instancetype)shared##name;

#if __has_feature(objc_arc)
#define single_m(name)\
static id _instance;\
+(id)shared##name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance=[[self alloc] init];\
});\
return _instance;\
}\
\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance=[super allocWithZone:zone];\
});\
return _instance;\
}\
+(id)copyWithZone:(struct _NSZone *)zone{\
return _instance;\
}
#else
#define single_m(name)\
static id _instance;\
+(instancetype)shared##name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance=[[self alloc]init];\
});\
return  _instance;\
}\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance=[super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(id)copyWithZone:(struct _NSZone *)zone{\
return _instance;\
}\
\
-(oneway void)release{\
}\
-(instancetype)autorelease{\
return _instance;\
}\
-(instancetype)retain{\
return _instance;\
}\
-(NSUInteger)retainCount{\
return 1;\
}
#endif
