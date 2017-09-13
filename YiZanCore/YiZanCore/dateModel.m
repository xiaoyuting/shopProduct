//
//  dateModel.m
//  YiZanService
//
//  Created by zzl on 15/3/19.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "CustomDefine.h"
#import "SVProgressHUD.h"
#import "dateModel.h"
#import "NSObject+myobj.h"
#import "APIClient.h"
#import "Util.h"
#import "OSSClient.h"
#import "OSSTool.h"
#import "OSSData.h"
#import "OSSLog.h"
#import "OSSBucket.h"
#import <CoreLocation/CoreLocation.h>

#import "AFURLSessionManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "APService.h"

#import <QMapKit/QMapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import <objc/message.h>
#import "UPPaymentControl.h"

@class SStaff;
@class SCar;


NSMutableArray* g_allCarInfo = nil;

@implementation dateModel

@end

@implementation SAutoEx

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        [self fetchIt:obj];
    }
    return self;
}

//mCertificateImg = "T@\"NSString\",&,N,V_mCertificateImg";
//mCountGoods = "Ti,N,V_mCountGoods";
//mCateIds = "T@\"NSArray\",&,N,V_mCateIds";
//获取自定义的类型,系统的,INT FLOAT 这种不要
-(NSString*)getPropCustomClassName:(NSString*)propInfo
{
    if( propInfo.length != 0  && [propInfo hasPrefix:@"T@\"S"] )
    {//如果是 S开头的classs,,就是我们的,应该
        NSArray* t = [propInfo componentsSeparatedByString:@"\""];
        if( t.count > 1 )
        {
            return t[1];
        }
    }
    return nil;
}

-(void)fetchIt:(NSDictionary*)obj
{
    if( obj == nil ) return;
    NSMutableDictionary* nameMapProp = NSMutableDictionary.new;
    id leaderClass = [self class];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(leaderClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        [nameMapProp setObject:[NSString stringWithFormat:@"%s",property_getAttributes(property)] forKey:propName];
    }
    if( properties )
    {
        free( properties );
    }
    
    if( nameMapProp.count == 0 ) return;
    
    NSArray* allnames = [nameMapProp allKeys];
    for ( NSString* oneName in allnames ) {
        if( ![oneName hasPrefix:@"m"] ) continue;
        //mId....like this
        NSString* jsonkey = [oneName stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:[[oneName substringWithRange:NSMakeRange(1, 1)] lowercaseString] ];
        //mId ==> mid;
        jsonkey = [jsonkey substringFromIndex:1];
        //mid ==> id;
        id itobj = [obj objectForKeyMy:jsonkey];

        if( itobj == nil ) continue;
        
        NSString* thispropclass = [self getPropCustomClassName:[nameMapProp objectForKey:oneName]];
        if( thispropclass.length )
        {//如果自己定义的类型就尝试用 initWithObj 处理下,,
            Class tclass = NSClassFromString(thispropclass);
            if( [tclass instancesRespondToSelector:@selector(initWithObj:)] )
            {
                id tobj = [[tclass alloc] initWithObj:itobj];
                if( tobj )
                    [self setValue:tobj forKey:oneName];
                else
                    [self setValue:itobj forKey:oneName];
            }
            else
                [self setValue:itobj forKey:oneName];
        }
        else
            [self setValue:itobj forKey:oneName];
    }
}
@end
@interface SResBase()

@property (nonatomic,strong)    id mcoredat;

@end

@implementation SResBase


-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
        self.mcoredat = obj;
    }
    return self;
}

-(void)fetchIt:(NSDictionary *)obj
{
    _mcode = [[obj objectForKeyMy:@"code"] intValue];
    _msuccess = _mcode == 0;
    self.mmsg = [obj objectForKeyMy:@"msg"];
    self.mdebug = [obj objectForKeyMy:@"debug"];
    self.mdata = [obj objectForKeyMy:@"data"];
}

+(SResBase*)infoWithError:(NSString*)error
{
    SResBase* retobj = SResBase.new;
    retobj.mcode = 1;
    retobj.msuccess = NO;
    retobj.mmsg = error;
    return retobj;
}
@end

@implementation SUserState

-(id)initWithObj:(NSDictionary*)dic
{
    self = [super init];
    if( self )
    {
        self.mbHaveNewMsg = [[dic objectForKeyMy:@"hasNewMessage"] boolValue];
    }
    return self;
}

@end

@interface SUser()

@property (nonatomic,strong)    id  mcoredat;

@end

@implementation SUser
{
}
static SUser* g_user = nil;
//返回当前用户
bool g_bined = NO;
+(SUser*)currentUser
{
    if( g_user ) return g_user;
    if( g_bined )
    {
        NSLog(@"fuck err rrrr");
        return nil;//递归问题,
    }
    g_bined = YES;
    @synchronized(self) {
        
        if ( !g_user )
        {
            g_user = [SUser loadUserInfo];
        }
    }
    g_bined = NO;
    return g_user;
}



+(void)saveUserInfo:(id)dccat
{
    dccat = [Util delNUll:dccat];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:dccat forKey:@"userInfo"];
    
    NSLog(@"%@   ...userinfo",dccat);
    [def synchronize];
}

+(SUser*)loadUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"userInfo"];
    if( dat )
    {
        SUser* tu = [[SUser alloc]initWithObj:dat];
        
        NSLog(@"%@   ...userinfo",dat);
        return tu;
    }
    return nil;
}
+(NSDictionary*)loadUserJson
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"userInfo"];
}

+(void)cleanUserInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"userInfo"];
    [def synchronize];
}

//判断是否需要登录
+(BOOL)isNeedLogin
{
    return [SUser currentUser] == nil;
}

//退出登陆
+(void)logout
{
    [SUser clearTokenWithPush];
    [SUser cleanUserInfo];
    g_user = nil;
    
    [[APIClient sharedClient] postUrl:@"user.logout" parameters:nil call:^(SResBase *info) {
        
    }];
    
}
//发送短信
+(void)sendSM:(NSString*)phone type:(NSString *)type block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    
    if (type.length>0) {
        [param setObject:phone forKey:@"reg_check"];
    }
    [param setObject:phone forKey:@"mobile"];
    
    [[APIClient sharedClient] postUrl:@"user.mobileverify" parameters:param call:^(SResBase *info) {
        block( info );
    }];
}

+(void)dealUserSession:(SResBase*)info block:(void(^)(SResBase* resb, SUser*user))block
{
    if( info.msuccess && info.mdata)
    {
        NSDictionary* tmpdic = info.mdata;
        
        NSMutableDictionary* tdic = [[NSMutableDictionary alloc]initWithDictionary:info.mdata];
        NSString* fucktoken = [info.mcoredat objectForKeyMy:@"token"];
        if( fucktoken.length )
            [tdic setObject:fucktoken forKey:@"token"];
        else
        {//如果没有token,那弄原来的
            [tdic setObject:[SUser currentUser].mToken forKey:@"token"];
        }
        
        SUser* tu = [[SUser alloc]initWithObj:tdic];
        tmpdic = tdic;
        
        if( tu )
        {
            [self logout];
            [SUser saveUserInfo: tmpdic];
            [SUser relTokenWithPush];
            
//            SAddress* t = [[SAddress alloc] initWithObj:[tdic objectForKeyMy:@"address"]];
            
            for (NSDictionary *dic in [tdic objectForKeyMy:@"address"]) {
                
                SAddress *t =  [[SAddress alloc] initWithObj:dic];
                
                if (t.mIsDefault) {
                    [SAddress saveDefault:t];
                }
            }
        }
    }
    block( info , [SUser currentUser] );
}

//登录,
+(void)loginWithPhone:(NSString*)phone psw:(NSString*)psw vcode:(NSString*)vcode block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    NSString *deviceType = [APIClient deviceVersion];
    [param setObject:deviceType forKey:@"device_type"];
    [param setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_no"];
    [param setObject:[NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]] forKey:@"os_version"];
    
    if( psw )
        [param setObject:psw forKey:@"pwd"];
    if( vcode )
        [param setObject:vcode forKey:@"verifyCode"];
    [[APIClient sharedClient] postUrl:@"user.login" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}


//注册
+(void)regWithPhone:(NSString*)phone psw:(NSString*)psw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    [param setObject:psw forKey:@"pwd"];
    [param setObject:smcode forKey:@"verifyCode"];
    
    [[APIClient sharedClient] postUrl:@"user.reg" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}

//重置密码
+(void)reSetPswWithPhone:(NSString*)phone newpsw:(NSString*)newpsw smcode:(NSString*)smcode  block:(void(^)(SResBase* resb, SUser*user))block{
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:phone forKey:@"mobile"];
    [param setObject:smcode forKey:@"verifyCode"];
    [param setObject:newpsw forKey:@"pwd"];
    
    [GInfo shareClient];
    [[APIClient sharedClient] postUrl:@"user.repwd" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
    
}

+(void)UpdatePwd:(NSString *)oldPwd newPwd:(NSString *)pwd block:(void(^)(SResBase* resb, SUser*user))block{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:oldPwd forKey:@"oldPwd"];
    [param setObject:pwd forKey:@"pwd"];
   
    [GInfo shareClient];
    [[APIClient sharedClient] postUrl:@"user.renewpwd" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
    
}

//修改电话号码验证旧电话号码
+(void)EverifyMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode block:(void(^)(SResBase* resb, BOOL flag))block{

    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:mobile forKey:@"mobile"];
    [param setObject:verifyCode forKey:@"verifyCode"];
    
    [[APIClient sharedClient] postUrl:@"user.info.verifymobile" parameters:param call:^(SResBase *info) {
        block(info,info.mdata);
    }];
}

//修改手机号码
+(void)UpdateMobile:(NSString *)mobile oldMobile:(NSString *)oldMobile verifyCode:(NSString *)verifyCode block:(void(^)(SResBase* resb, SUser*user))block{

    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:mobile forKey:@"mobile"];
    [param setObject:oldMobile forKey:@"oldMobile"];
    [param setObject:verifyCode forKey:@"verifyCode"];
    
    [[APIClient sharedClient] postUrl:@"user.updatemobile" parameters:param call:^(SResBase *info) {
        [self dealUserSession:info block:block];
    }];
}


-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
}

-(void)fetchIt:(NSDictionary *)obj
{
    self.mToken = [obj objectForKeyMy:@"token"];
    
    _mUserId = [[obj objectForKeyMy:@"id"] intValue];
    self.mUserName = [obj objectForKeyMy:@"name"];
    self.mHeadImgURL = [obj objectForKeyMy:@"avatar"];
    self.mPhone = [obj objectForKeyMy:@"mobile"];
    self.mAuth          = [[SAuth alloc]initWithObj:[obj objectForKeyMy:@"propertyUser"]];
    self.mbalance=[obj objectForKeyMy:@"balance"];

}


#define APPKEY      [GInfo shareClient].mOssid
#define APPSEC      [GInfo shareClient].mOssKey
#define BUCKET      [GInfo shareClient].mOssBucket
#define OSSHOST     [GInfo shareClient].mOssHost

- (void)checkReg:(void(^)(SResBase* resb,SSeller* seller))block{

    [[APIClient sharedClient] postUrl:@"seller.check" parameters:nil call:^(SResBase *info) {
        
//        if (info.msuccess) {
        
            SSeller *seller = [[SSeller alloc] initWithObj:info.mdata];
             block( info,seller );
//        }else
//            block(info,nil);
       
    }];
}
///我要开店
- (void)willCreateStore:(int)mStoreType andLogo:(UIImage*)mLogo andStoreName:(NSString *)mStoreName andCateId:(NSString *)mCateID andAddress:(NSString *)mAddress adressDetail:(NSString *)adressDetail proviceId:(int)proviceId cityId:(int)cityId areaId:(int)areaId mapPosStr:(NSString *)mapPosStr mapPointStr:(NSString *)mapPointStr andMbile:(NSString *)mMobile andName:(NSString *)contacts andIdCard:(NSString *)mIdCard andIdCardImg:(UIImage*)mIdCardImg1 andIdCardImg2:(UIImage *)mIdCardImg2 andLicenceImg:(UIImage *)mLicenceImg andIntroduction:(NSString *)mIntroduction block:(void(^)(SResBase* resb))block{

        
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
      
        
        NSString* mLogofilepath = nil;
        
        NSString* mIdCardImg1filepath = nil;
        NSString* mIdCardImg2filepath = nil;
        
        NSString* mLicenceImgfilepath = nil;
        
        NSError *err = nil;
        
        
        if ([mIdCardImg1 isKindOfClass:[NSString class]]) {
            mIdCardImg1filepath = (NSString *)mIdCardImg1;
        }else{
            
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传身份证..."] maskType:SVProgressHUDMaskTypeClear];
                
            });
            mIdCardImg1filepath = [SUser uploadImagSyn: mIdCardImg1 error: &err];
            
            
            if(mIdCardImg1filepath == nil){
            
                block( [SResBase infoWithError:err.description]  );
                return ;
            }
            
        }
        
        if ([mIdCardImg2 isKindOfClass:[NSString class]]) {
            mIdCardImg2filepath = (NSString *)mIdCardImg2;
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传身份证..."] maskType:SVProgressHUDMaskTypeClear];
                
            });
            mIdCardImg2filepath = [SUser uploadImagSyn: mIdCardImg2 error: &err];
            
            if(mIdCardImg2filepath == nil){
                
                block( [SResBase infoWithError:err.description]  );
                return ;
            }
        }
    
        if([mLogo isKindOfClass:[NSString class]]){
        
            mLogofilepath = (NSString *)mLogo;
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传头像..."] maskType:SVProgressHUDMaskTypeClear];
                
            });
            mLogofilepath = [SUser uploadImagSyn: mLogo error: &err];
            
            if(mLogofilepath == nil){
                
                block( [SResBase infoWithError:err.description]  );
                return ;
            }
        }
        
        
        
        NSMutableDictionary *param = NSMutableDictionary.new;
        [param setObject:NumberWithInt(mStoreType) forKey:@"sellerType"];
        
        [param setObject:mLogofilepath forKey:@"logo"];
        
        [param setObject:mStoreName forKey:@"name"];
        [param setObject:mCateID forKey:@"cateIds"];
        [param setObject:mAddress forKey:@"address"];
        [param setObject:mMobile forKey:@"serviceTel"];
        [param setObject:[SUser currentUser].mPhone forKey:@"mobile"];
        [param setObject:mIdCard forKey:@"idcardSn"];
        [param setObject:contacts forKey:@"contacts"];
        

        [param setObject:adressDetail forKey:@"addressDetail"];
        [param setObject:@(proviceId) forKey:@"provinceId"];
        [param setObject:@(cityId) forKey:@"cityId"];
        [param setObject:@(areaId) forKey:@"areaId"];
        [param setObject:mapPosStr forKey:@"mapPosStr"];
        [param setObject:mapPointStr forKey:@"mapPointStr"];
        
        
        [param setObject:mIdCardImg1filepath forKey:@"idcardPositiveImg"];
        [param setObject:mIdCardImg2filepath forKey:@"idcardNegativeImg"];
        [param setObject:mIntroduction forKey:@"introduction"];
        
        if (mStoreType == 2) {
            
            if( [mLicenceImg isKindOfClass:[UIImage class]] )
            {//
                dispatch_async(dispatch_get_main_queue(),^{
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传证件..."] maskType:SVProgressHUDMaskTypeClear];
                    
                });
                mLicenceImgfilepath = [SUser uploadImagSyn: mLicenceImg error: &err];
                
                if(mLicenceImgfilepath == nil){
                    
                    block( [SResBase infoWithError:err.description]  );
                    return ;
                }
                
                [param setObject:mLicenceImgfilepath forKey:@"businessLicenceImg"];
                
            }
            else if( [mLicenceImg isKindOfClass:[NSString class]] )
            {
                [param setObject:mLicenceImg forKey:@"businessLicenceImg"];
            }
        }

        [[APIClient sharedClient] postUrl:@"seller.reg" parameters:param call:^(SResBase *info) {
            block( info );
        }];

        
    });
    
    
   
    
}

//修改用户信息,修改成功会更新对应属性
-(void)updateUserInfo:(NSString*)name HeadImg:(UIImage*)Head block:(void(^)(SResBase* resb ))block
{
    NSString* filepath = nil;
    if( Head )
    {//上传头像
        
        [SVProgressHUD showWithStatus:@"正在保存头像..."];
        OSSClient* _ossclient = [OSSClient sharedInstanceManage];
        _ossclient.globalDefaultBucketHostId = OSSHOST;
        
        NSString *accessKey = APPKEY;
        NSString *secretKey = APPSEC;
        [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
            NSString *signature = nil;
            NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
            signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
            signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
            //NSLog(@"here signature:%@", signature);
            return signature;
        }];
        
        OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
        NSData *dataObj = UIImageJPEGRepresentation(Head, 1.0);
        filepath = [SUser makeFileName:@"jpg"];
        OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
        [testData setData:dataObj withType:@"jpg"];
        
        [testData uploadWithUploadCallback:^(BOOL bok, NSError *err) {
            if( !bok )
            {
                SResBase* resb = [SResBase infoWithError:err.description];
                block( resb  );
            }
            else
            {
                [self realUpdate:name file:filepath  block:block];
            }
            
        } withProgressCallback:^(float process) {
            
            NSLog(@"process:%f",process);
          //  block(nil,NO,process);
            
        }];
    }
    else
    {
        [self realUpdate:name file:nil block:block];
    }
}
-(void)realUpdate:(NSString*)name file:(NSString*)file block:(void(^)(SResBase* resb ))block
{
    NSMutableDictionary *param = NSMutableDictionary.new;
    if( name.length )
        [param setObject:name forKey:@"name"];
    if( file.length )
        [param setObject:file forKey:@"avatar"];
    
    [[APIClient sharedClient] postUrl:@"user.info.update" parameters:param call:^(SResBase *info) {
        [SUser dealUserSession:info block:^(SResBase *resb, SUser *user) {
            block( info );
        }];
    }];
}



//获取地址
-(void)getMyAddress:(void(^)(SResBase* resb,NSArray* arr))block
{
    [[APIClient sharedClient]postUrl:@"user.address.lists" parameters:nil call:^(SResBase *info) {
        
        NSArray* reta  = nil;
        if( info.msuccess )
        {
            NSMutableArray* tar = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata  ) {
                [tar addObject: [[SAddress alloc]initWithObj: one] ];
            }
            reta = tar;
        }
        block( info , reta );
    }];
}


//获取我的订单,,
-(void)getMyOrders:(int)type  status:(int)status page:(int)page block:(void(^)(SResBase* resb,NSArray* all,int num))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(status) forKey:@"status"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    NSString *url = [NSString string];
    if(type==0){
        url =@"order.lists";
    }else if(type==1){
        url =@"order.cardlists";
    }
    
    [[APIClient sharedClient] postUrl:url parameters:param call:^(SResBase *info) {
        
        int num = 0;
        NSArray* t = nil;
        if( info.msuccess )
        {
            num = [[info.mdata objectForKeyMy:@"commentNum"] intValue];
            NSMutableArray* tar = NSMutableArray.new;
            for (NSDictionary* one in [info.mdata objectForKeyMy:@"orderList"] ) {
                SOrderObj *sss= [[SOrderObj alloc] initWithObj:one];
                [tar addObject: sss];
            }
            t = tar;
        }
        block(info,t,num);
    }];
}

//我收藏的店铺
-(void)getMyFavShop:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(2) forKey:@"type"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    [[APIClient sharedClient] postUrl:@"collect.lists" parameters:param call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* tar = NSMutableArray.new;
            for (NSDictionary* one in info.mdata ) {
                SSeller *sss= [[SSeller alloc] initWithObj:one];
                [tar addObject: sss];
            }
            t = tar;
        }
        block(info,t);
    }];
}

//我收藏的商品
-(void)getMyFavGoods:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(1) forKey:@"type"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    [[APIClient sharedClient] postUrl:@"collect.lists" parameters:param call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* tar = NSMutableArray.new;
            for (NSDictionary* one in info.mdata ) {
                SGoods *sss= [[SGoods alloc] initWithObj:one];
                [tar addObject: sss];
            }
            t = tar;
        }
        block(info,t);
    }];
}

//消息列表
-(void)getMyMsg:(int)page block:(void(^)(SResBase* resb,NSArray* arr))block
{
    [[APIClient sharedClient]postUrl:@"msg.lists" parameters:@{@"page":@(page)} call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* tar = NSMutableArray.new;
            for (NSDictionary* one in info.mdata ) {
                SMessageInfo *sss= [[SMessageInfo alloc] initWithObj:one];
                [tar addObject: sss];
            }
            t = tar;
        }
        block(info,t);
        
    }];
}

-(void)haveNewMsg:(void(^)(int newMsgCount,int cartGoodsCount,int collectCount,int addressCount,int procount))block;
{
    [[APIClient sharedClient]postUrl:@"msg.status" parameters:nil call:^(SResBase *info) {
       
        int n = [[info.mdata objectForKeyMy:@"newMsgCount"] intValue];
        int nn = [[info.mdata objectForKeyMy:@"cartGoodsCount"] intValue];
        int nnn = [[info.mdata objectForKeyMy:@"collectCount"] intValue];
        int nnnn = [[info.mdata objectForKeyMy:@"addressCount"] intValue];
        int nnnnn = [[info.mdata objectForKeyMy:@"proCount"] intValue];
        block(n,nn,nnn,nnnn,nnnnn);
        
    }];
}

//获取我的购物车 all SCarSeller
-(void)getMyShopCar:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]  postUrl:@"shopping.lists" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SCarSeller alloc]initWithObj:one]];
            }
            g_allCarInfo = t;
            block( info,t);
        }
        else
            block(info,nil);
        
    }];
}

//获取我的优惠卷 status状态 1:已失效 2:可用(下单选择优惠券) 3:未使用
-(void)getMyYouHuiJuan:(int)page status:(int)status sellerId:(int)sellerId money:(double)money block:(void(^)(SResBase* resb,NSArray* all,int cangetcount ))block
{
    [[APIClient sharedClient]postUrl:@"user.promotion.lists" parameters:@{@"page":@(page),@"status":@(status),@"sellerId":@(sellerId),@"money":@(money)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            NSArray* rt = [info.mdata objectForKeyMy:@"list"];
            int cangetcount = [[info.mdata objectForKeyMy:@"count"] intValue];
            for ( NSDictionary* one in rt ) {
                [t addObject:[[SPromotion alloc]initWithObj:one]];
            }
            block( info , t,cangetcount);
        }
        else
        {
            block( info,nil,0);
        }
    }];
}

//获取我的第一个可以用的优惠卷
-(void)getMyFirstYouHuiJuan:(void(^)(SResBase* resb ,SPromotion* retobj ))block
{
    [[APIClient sharedClient]postUrl:@"user.promotion.first" parameters:nil call:^(SResBase *info) {
       
        if( info.msuccess )
            block( info,[[SPromotion alloc]initWithObj:info.mdata]);
        else
            block( info,nil);
        
    }];
}

-(void)getMyTie:(int)page type:(int)type block:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"forumposts.userlists" parameters:@{@"page":@(page),@"pageSize":@(20),@"type":@(type)} call:^(SResBase *info) {
        if (  info.msuccess ) {
            
            NSMutableArray*tt = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [tt addObject: [[SForumPosts alloc]initWithObj:one]];
            }
            block( info , tt);
        }
        else
        {
            block( info , nil );
        }
    }];
}

//获取论坛消息
-(void)getTieMsg:(int)page block:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"forummessage.lists" parameters:@{@"page":@(page),@"pageSize":@(20)} call:^(SResBase *info) {
        if (  info.msuccess ) {
            
            NSMutableArray*tt = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [tt addObject: [[SForumMessage alloc]initWithObj:one]];
            }
            block( info , tt);
        }
        else
        {
            block( info , nil );
        }
    }];
}

//获取我的小区 all => SDistrict
-(void)getMyDistrict:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"district.lists" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray *  t  = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                SDistrict* oneobj =  [[SDistrict alloc]initWithObj:one];
                oneobj.mIsUser = YES;
                [t addObject: oneobj];
            }
            block( info , t);
        }
        else
        {
            block( info , nil );
        }
        
    }];
}


//充值日志
- (void)getMyYueList:(int)page block:(void (^)(SResBase *, NSArray *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:@(page) forKey:@"page"];
    
    
    [[APIClient sharedClient] postUrl:@"user.getbalance" parameters:para call:^(SResBase *info) {
        if (info.msuccess) {
            NSMutableArray *  t  = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"paylogs"]) {
//                SDistrict* oneobj =  [[SDistrict alloc]initWithObj:one];
//                oneobj.mIsUser = YES;
//                [t addObject: oneobj];
                [t addObject:one];
            }
            block( info , t);
        }else{
            block (nil,nil);
        }
    }];
}

- (void)getbalance:(void (^)(SResBase *resb,NSString *balance))block{
    
    [[APIClient sharedClient] postUrl:@"user.balance" parameters:nil call:^(SResBase *info) {
        if (info.msuccess) {
           
            NSString *balac=[info.mdata objectForKeyMy:@"balance"];
            NSLog(@"   %@  ....  data",info.mdata);
            NSLog(@"   %@  ....  dic",balac);
            block( info ,balac);
        }else{
            block (nil,nil);
        }
    }];

}



//是否需要认证
-(BOOL)isNeedAuth
{
    return self.mAuth.mStatus != 1;
}

//是否需要申请门禁功能
-(BOOL)isNeedApply
{
    return self.mAuth.mAccessStatus != 1;
}
-(void)checkAuth:(void(^)(SAuth* retobj,SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"user.checkvillagesauth" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            block( [[SAuth alloc]initWithObj:info.mdata],info );
        }
        else
            block( nil, info );
        
    }];
}

//更新认证信息到存储
-(void)updateAuthInfo:(NSDictionary*)dic
{
    NSDictionary* one  = [SUser loadUserJson];
    if( one &&  dic )
    {
        NSMutableDictionary*t = [NSMutableDictionary dictionaryWithDictionary:one];
        [t setObject:dic forKey:@"propertyUser"];
        [SUser saveUserInfo:t];
    }
}
//是否摇一摇
-(BOOL)isOpenDoorShake:(NSNumber*)setv
{
    NSUserDefaults* set = [NSUserDefaults standardUserDefaults];
    
    NSString* key = [NSString stringWithFormat:@"opendoor_%d",_mUserId];
    if( setv )
    {
        [set setObject:setv forKey:key];
        [set synchronize];
    }
    
    return [[set objectForKey:key] boolValue];
}








static int g_index = 0;
+(NSString*)makeFileName:(NSString*)extName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* t = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"HH-mm-ss"];
    NSString* s = [dateFormatter stringFromDate:[NSDate date]];
    g_index++;
    
    return [NSString stringWithFormat:@"temp/%@/%d_%u_%@.%@",t,[SUser currentUser].mUserId,g_index,s,extName];
}



+(void)clearTokenWithPush
{
    [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
}
+(void)relTokenWithPush
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id switchid = [defaults objectForKey:@"msgpush"];
    if( switchid && ![switchid boolValue] ) return;//如果设置过,但是,不是1,,就不要关联了
    
    
    if( [SUser currentUser] == nil ) return;
    NSString* t = [NSString stringWithFormat:@"%d", [SUser currentUser].mUserId];
    
    t = [@"buyer_" stringByAppendingString:t];
    
    //别名
    //1."seller_1"
    //2."buyer_1"
    
    
    //标签
    //1."seller"/"buyer"
    //2."重庆"/...
    
    
    NSSet* labelset = [[NSSet alloc]initWithObjects:@"buyer", @"ios",nil];
    
    [APService setTags:labelset alias:t callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
    
}

+(NSString*)uploadImagSyn:(UIImage*)tagimg error:(NSError**)error
{
    OSSClient* _ossclient = [OSSClient sharedInstanceManage];
    _ossclient.globalDefaultBucketHostId = OSSHOST;
    //_ossclient.globalDefaultBucketHostId = @"osscn-hangzhou.aliyuncs.com";
    
    NSString *accessKey = APPKEY;
    NSString *secretKey = APPSEC;
    [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        //NSLog(@"here signature:%@", signature);
        return signature;
    }];
    
    OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
    UIImage* tempimg = [Util scaleImg:tagimg maxsizeW:1242];
    NSData *dataObj = UIImageJPEGRepresentation(tempimg, 1.0);
    NSString* filepath = [SUser makeFileName:@"jpg"];
    OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
    [testData setData:dataObj withType:@"jpg"];
    [testData upload:error];
    if( *error ) return nil;
    return filepath;
}

+(void)uploadImg:(UIImage*)tagimg block:(void(^)(NSString* err,NSString* filepath))block
{
    
    OSSClient* _ossclient = [OSSClient sharedInstanceManage];
    _ossclient.globalDefaultBucketHostId = OSSHOST;

    //_ossclient.globalDefaultBucketHostId = @"osscn-hangzhou.aliyuncs.com";
    
    NSString *accessKey = APPKEY;
    NSString *secretKey = APPSEC;
    [_ossclient setGenerateToken:^(NSString *method, NSString *md5, NSString *type, NSString *date, NSString *xoss, NSString *resource){
        NSString *signature = nil;
        NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, md5, type, date, xoss, resource];
        signature = [OSSTool calBase64Sha1WithData:content withKey:secretKey];
        signature = [NSString stringWithFormat:@"OSS %@:%@", accessKey, signature];
        //NSLog(@"here signature:%@", signature);
        return signature;
    }];
    
    OSSBucket* _ossbucket = [[OSSBucket alloc] initWithBucket:BUCKET];
    UIImage* tempimg = [Util scaleImg:tagimg maxsizeW:1242];
    NSData *dataObj = UIImageJPEGRepresentation(tempimg, 1.0);
    NSString* filepath = [SUser makeFileName:@"jpg"];
    OSSData *testData = [[OSSData alloc] initWithBucket:_ossbucket withKey:filepath];
    [testData setData:dataObj withType:@"jpg"];
    [testData uploadWithUploadCallback:^(BOOL bok, NSError *err) {
        if( !bok )
        {
            block(err.description,nil);
        }
        else
        {
            block(nil,filepath);
        }
    } withProgressCallback:^(float process) {
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传图片:%.1f%%",process*100.0f] maskType:SVProgressHUDMaskTypeClear];
    }];
}



//++++++++++++++++++++++++++++++++++
NSMutableArray* g_allWaiterKey = nil;

+(void)addSearchWaiterKey:(NSString*)key
{
    if( g_allWaiterKey == nil )
        g_allWaiterKey = NSMutableArray.new;
    
    if( key.length )
    {
        if( ![g_allWaiterKey containsObject:key] )
        {
            [g_allWaiterKey addObject:key];
            [SUser saveHistoryWaiter:g_allWaiterKey];
        }
    }
}
+(NSArray*)loadHistoryWaiter
{
    if( g_allWaiterKey ) return g_allWaiterKey;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_wat_his",userid];
    g_allWaiterKey =  [st objectForKey:key];
    return g_allWaiterKey;
}
+(void)clearHistoryWaiter
{
    [SUser saveHistoryWaiter:@[]];
    g_allWaiterKey = NSMutableArray.new;
}
+(void)saveHistoryWaiter:(NSArray*)dat
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_wat_his",userid];
    [st setObject:dat forKey:key];
    [st synchronize];
}
//++++++++++++++++++++++++++++++++++



//++++++++++++++++++++++++++++++++++
NSMutableArray* g_allGoodsKey = nil;

+(void)addSearchKey:(NSString*)key
{
    if( g_allGoodsKey == nil )
        g_allGoodsKey = NSMutableArray.new;
    
    if( key.length )
    {
        if( ![g_allGoodsKey containsObject:key] )
        {
            [g_allGoodsKey addObject:key];
            [SUser saveHistory:g_allGoodsKey];
        }
    }
}

+(NSArray*)loadHistory
{
    if( g_allGoodsKey ) return g_allGoodsKey;
    g_allGoodsKey = NSMutableArray.new;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_srv_his",userid];
    NSArray* tt = [st objectForKey:key];
    if( tt )
        [g_allGoodsKey addObjectsFromArray:tt];
    return g_allGoodsKey;
}
+(void)clearHistory
{
    [SUser saveHistory:@[]];
    g_allGoodsKey = NSMutableArray.new;
}
+(void)saveHistory:(NSArray*)dat
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    int userid = [SUser currentUser].mUserId;
    NSString* key = [NSString stringWithFormat:@"%d_srv_his",userid];
    [st objectForKey:key];
    [st setObject:dat forKey:key];
    [st synchronize];
}
//++++++++++++++++++++++++++++++++++
@end


static GInfo* g_info = nil;
@implementation GInfo
{
}

+(GInfo*)shareClient
{
    if( g_info ) return g_info;
    @synchronized(self) {
        
        if ( !g_info )
        {
            GInfo* t = [GInfo loadGInfo];
            if( [t isGInfoVaild] )
                g_info = t;
        }
        return g_info;
    }
}
-(BOOL)isGInfoVaild
{//这个全局数据是否有效,,目前只判断了,token,应该判断所有的字段,:todo
    return self.mGToken.length > 0;
}
-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        [self fetchIt:obj];
    }
    return self;
}
-(void)fetchIt:(NSDictionary *)obj
{
    self.mGToken = [obj objectForKeyMy:@"token"];
    NSString* sssssss = [obj objectForKeyMy:@"key"];
    if( sssssss.length )
    {
        char keyPtr[10]={0};
        [sssssss getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        self.mivint  = (int)strtoul(keyPtr,NULL,24);
    }
    
    NSDictionary* data = [obj objectForKeyMy:@"data"];
    NSArray* tt = [data objectForKeyMy:@"citys"];
    NSMutableArray* t = NSMutableArray.new;
    for ( NSDictionary* one in tt ) {
        [t addObject: [[SCity alloc]initWithObj:one] ];
    }
    self.mSupCitys = t;
    
    
    tt = [data objectForKeyMy:@"payment"];
    t = NSMutableArray.new;
    for (NSDictionary* one in tt ) {
        [t addObject: [[SPayment alloc]initWithObj: one]];
    }
    
    self.mPayment = t;
    
    
    self.mAppVersion    = [data objectForKeyMy:@"appVersion"];
    self.mForceUpgrade  = [[data objectForKeyMy:@"forceUpgrade"] boolValue];
    self.mAppDownUrl    = [data objectForKeyMy:@"appDownUrl"];
    self.mUpgradeInfo   = [data objectForKeyMy:@"upgradeInfo"];
    self.mServiceTel    = [data objectForKeyMy:@"serviceTel"];
    self.mServiceTime   = [data objectForKeyMy:@"serviceTime"];
    
    
    NSDictionary* tttt = [data objectForKeyMy:@"fileUploadConfig"];
    
    self.mOssBucket = [tttt objectForKey:@"bucket"];
    self.mOssHost = [tttt objectForKey:@"host"];
    self.mOssid = [tttt objectForKey:@"accessId"];
    self.mOssKey = [tttt objectForKey:@"accessKey"];
    
    float nowver = [[Util getAppVersion] floatValue];
    float srvver = [self.mAppVersion floatValue];
    if(  nowver >= srvver )
    {
        self.mAppDownUrl = nil;
    }
    
    self.mAboutUrl = [data objectForKeyMy:@"aboutUrl"];          //关于我们Url
    self.mProtocolUrl = [data objectForKeyMy:@"protocolUrl"];       //用户协议Url
    self.mHelpUrl = [data objectForKeyMy:@"helpUrl"];
    self.mRestaurantTips = [data objectForKeyMy:@"restaurantTips"];    //餐厅订餐说明
    self.mShareQrCodeImage = [data objectForKeyMy:@"shareQrCodeImage"];  //分享二维码图片地址
    self.mShareContent = [data objectForKeyMy:@"shareContent"];
    int time = [[data objectForKeyMy:@"systemOrderPass"] intValue];
    
    if (time>=3600) {
        self.mSystemOrderPass = [NSString stringWithFormat:@"%d小时",time/3600];
    }else{
    
       self.mSystemOrderPass = [NSString stringWithFormat:@"%d分钟",time/60];
    }
    
    tt = [data objectForKeyMy:@"province"];
    NSMutableArray* allcitys = NSMutableArray.new;
    for ( NSDictionary* one in tt ) {
        SCity* rootprov =   SCity.new;
        rootprov.mId = [[one objectForKeyMy:@"id"] intValue];
        rootprov.mName = [one objectForKeyMy:@"name"];
        NSArray* subcitys = [one objectForKeyMy:@"city"];
        if( subcitys.count )
        {
            NSMutableArray* _subcitys = NSMutableArray.new;
            for ( NSDictionary* onecity in subcitys ) {
                SCity* onesubcity = SCity.new;
                onesubcity.mId = [[onecity objectForKeyMy:@"id"] intValue];
                onesubcity.mName = [onecity objectForKeyMy:@"name"];
                
                NSArray* subarea = [onecity objectForKeyMy:@"area"];
                if( subarea.count )
                {
                    NSMutableArray* _subareas = NSMutableArray.new;
                    for ( NSDictionary* onearea in subarea ) {
                        SCity* onesubarea = SCity.new;
                        onesubarea.mId = [[onearea objectForKeyMy:@"id"] intValue];
                        onesubarea.mName = [onearea objectForKeyMy:@"name"];
                        [_subareas addObject:onesubarea];
                    }
                    onesubcity.mSubs = _subareas;
                }
                [_subcitys addObject: onesubcity];
            }
            rootprov.mSubs = _subcitys;
        }
        [allcitys  addObject: rootprov];
    }
    self.mSupCitys = allcitys;
    
    self.mIntroUrl = [data objectForKeyMy:@"introUrl"];
 
    self.mIsOpenProperty = [[data objectForKeyMy:@"isOpenProperty"] intValue];
    
}

static bool g_blocked = NO;
static bool g_startlooop = NO;
+(void)getGInfoForce:(void(^)(SResBase* resb, GInfo* gInfo))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:DeviceType()   forKey:@"systemInfo"];
    [param setObject:@"ios"  forKey:@"deviceType"];
    [param setObject:DeviceSys()    forKey:@"systemVersion"];
    NSString *version =  [Util getAppVersion];
    [param setObject:version  forKey:@"appVersion"];
    [[APIClient sharedClient] postUrl:@"app.init" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {//如果网络获取成功,并且数据有效,就覆盖本地的,
            GInfo* obj = [[GInfo alloc] initWithObj: info.mcoredat];
            if( [obj isGInfoVaild] )
            {//有效
                [GInfo saveGInfo:info.mcoredat];
                obj = [GInfo shareClient] ;
                if( [obj isGInfoVaild] )
                {
                    block( info, obj);
                    return ;
                }
            }
        }
        
        block(info,nil);
    }];
}

+(void)getGInfo:(void(^)(SResBase* resb, GInfo* gInfo))block
{
    if( !g_startlooop )
    {
        GInfo* s = [GInfo shareClient];
        if( s )
        {
            SResBase* objret = [[SResBase alloc]init];
            objret.msuccess = YES;
            
            block( objret , s );
            g_blocked = YES;
        }
    }
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:DeviceType()   forKey:@"systemInfo"];
    [param setObject:@"ios"  forKey:@"deviceType"];
    [param setObject:DeviceSys()    forKey:@"systemVersion"];
    NSString *version =  [Util getAppVersion];
    [param setObject:version  forKey:@"appVersion"];
    [[APIClient sharedClient] postUrl:@"app.init" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {//如果网络获取成功,并且数据有效,就覆盖本地的,
    
            GInfo* obj = [[GInfo alloc] initWithObj: info.mcoredat];
            if( [obj isGInfoVaild] )
            {//有效
                [GInfo saveGInfo:info.mcoredat];
                obj = [GInfo shareClient] ;
                if( [obj isGInfoVaild] )
                {
                    if( !g_blocked )
                    {
                        g_blocked = YES;
                        block( info, obj);
                    }
                    
                    if( g_startlooop )
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGinfoSuccess" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"appupdatecheck" object:nil];
                    return ;//这里就不用再下去了,,
                }
            }
        }
        else
        {
            //这里就是,没有网络或者数据无效了,就本地看看
            GInfo* tmp = [GInfo shareClient];
            if( tmp )
            {//如果本地有也可以
                if( !g_blocked )
                {
                    g_blocked = YES;
                    block(info,tmp);
                }
            }
            else
            {
                //连本地都没得,,,那么要一直循环获取了,,直到成功为止
                if( !g_blocked )
                {
                    g_blocked = YES;
                    
                    block([SResBase infoWithError:@"获取配置信息失败"] ,nil);
                }
                [GInfo loopGInfo];
            }
        }
    }];
}
+(void)loopGInfo
{
    g_startlooop = YES;
    MLLog(@"loopGInfo...");
    int64_t delayInSeconds = 1.0*20;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [GInfo getGInfo:^(SResBase *resb, GInfo *gInfo) {
            
            
        }];
        
    });
}
+(void)saveGInfo:(id)dat
{
    dat = [Util delNUll:dat];
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:dat  forKey:@"GInfo"];
    [def synchronize];
}
+(GInfo*)loadGInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"GInfo"];
    if( dat)
    {
        return [[GInfo alloc]initWithObj:dat];
    }
    return nil;
}

-(SPayment*)geAiPayInfo
{
    
    for ( SPayment* one in _mPayment ) {
        
        if( [one.mCode isEqualToString:@"alipay"] )
            return one;
    }
    return nil;
}

-(SPayment*)geWxPayInfo
{
    for ( SPayment* one in _mPayment ) {
        
        if( [one.mCode isEqualToString:@"weixin"] )
            return one;
    }
    return nil;
}



@end

@implementation SProvince

- (id)initWithObj:(NSDictionary *)obj{

    [super fetchIt:obj];
    
    NSMutableArray *arry = NSMutableArray.new;
    
    if (_mChild) {
        NSDictionary *dic = (NSDictionary *)_mChild;
        for (NSDictionary *d in [dic allValues]) {
            
            SProvince *p = [[SProvince alloc] initWithObj:d];
            
            [arry addObject:p];
        }
        _mChild = arry;
    }
    
    return self;
}

+ (void)GetProvice:(void(^)(NSArray* all))block{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    
    //获取数据
    NSData *reader = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:reader options:NSJSONReadingAllowFragments error:nil];

    NSMutableArray *all = NSMutableArray.new;
    NSArray *arry = [dic allValues];
    for (NSDictionary *d in arry) {
        
        SProvince *p = [[SProvince alloc] initWithObj:d];
        
        [all addObject:p];
    }
    block(all);
}

@end

@implementation SCity
-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mName = [obj objectForKeyMy:@"name"];
        self.mFirstChar = [obj objectForKeyMy:@"firstChar"];
        self.mIsDefault = [[obj objectForKeyMy:@"isDefault"] boolValue];
    }
    return self;
}

@end

@implementation SWxPayInfo
-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        self.mpartnerId = [obj objectForKeyMy:@"partnerid"];//	string	是			商户号
        self.mprepayId = [obj objectForKeyMy:@"prepayid"];//	string	是			预支付交易会话标识
        self.mpackage = [obj objectForKeyMy:@"packages"];//	string	是			扩展字段
        self.mnonceStr = [obj objectForKeyMy:@"noncestr"];//	string	是			随机字符串
        self.mtimeStamp = [[obj objectForKeyMy:@"timestamp"] intValue];//	int	是			时间戳
        self.msign = [obj objectForKeyMy:@"sign"];//	string	是			签名
        
    }
    return self;
}


@end
@implementation SPayment


-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        self.mCode = [obj objectForKeyMy:@"code"];
        self.mName = [obj objectForKeyMy:@"name"];
        self.mIconName = [obj objectForKeyMy:@"icon"];
        self.mDefault = [[obj objectForKeyMy:@"isDefault"] boolValue];
    }
    return self;
}

@end


@implementation SNotice


@end

@implementation SMainFunc

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj != nil )
    { 
        self.mImage = [obj objectForKeyMy:@"image"];
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mArg = [obj objectForKeyMy:@"arg"];
        self.mName = [obj objectForKeyMy:@"name"];
        self.mType = [[obj objectForKeyMy:@"type"] intValue];
    }
    return self;
}

//获取首页数据 banner ==> SMainFunc, menus ==> SMainFunc, notices ==> SMainFunc, rgoods ==> SGoods , rseller ==> SSeller
+(void)getMainFuncs:(void(^)(SResBase* resb,NSArray* banner,NSArray* menus,NSArray* notices,NSArray* rgoods,NSArray* rseller))block
{
    [[APIClient sharedClient] postUrl:@"config.index" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"banner"]) {
                [t addObject: [[SMainFunc alloc]initWithObj:one]];
            }
            
            NSMutableArray* tt = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"menu"]) {
                [tt addObject: [[SMainFunc alloc]initWithObj:one]];
            }
            
            NSMutableArray* ttt = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"notice"]) {
                [ttt addObject: [[SMainFunc alloc]initWithObj:one]];
            }
            
            NSMutableArray* tttt = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"goods"]) {
                [tttt addObject: [[SGoods alloc]initWithObj:one]];
            }
            
            NSMutableArray* ttttt = NSMutableArray.new;
            for ( NSDictionary* one in [info.mdata objectForKeyMy:@"sellers"]) {
                [ttttt addObject: [[SSeller alloc]initWithObj:one]];
            }
            
            block( info, t,tt,ttt,tttt,ttttt);
        }
        else
        {
            block( info , nil ,nil ,nil,nil,nil);
        }
        
    }];
}



@end

@interface SAppInfo()<CLLocationManagerDelegate>

@property (atomic,strong) NSMutableArray*   allblocks;

@end
SAppInfo* g_appinfo = nil;
@implementation SAppInfo
{
    CLLocationManager* _llmgr;
    BOOL            _blocing;
    NSDate*          _lastget;
    
    int     _mreloadstep;
    
    QMapView* _mapView;
}

+(void)feedback:(NSString*)content block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:content forKey:@"content"];
    [param setObject:@"ios" forKey:@"deviceType"];
    [[APIClient sharedClient]postUrl:@"feedback.create" parameters:param call:block];
}

+(SAppInfo*)shareClient
{
    if( g_appinfo ) return g_appinfo;
    @synchronized(self) {
        
        if ( !g_appinfo )
        {
            SAppInfo* t = [SAppInfo loadAppInfo];
            g_appinfo = t;
        }
        return g_appinfo;
    }
}

+(SAppInfo*)loadAppInfo
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dat = [def objectForKey:@"gappinfo"];
    SAppInfo* tt = SAppInfo.new;
    if( dat )
    {
        tt.mCityId = [[dat objectForKey:@"cityid"] intValue];
        tt.mSelCity = [dat objectForKey:@"selcity"];
        
        if( [dat objectForKey:@"seladdrobj"] )
            tt.mSelectAddrObj = [[SAddress alloc]initWithObj:[dat objectForKey:@"seladdrobj"] bload:NO];
    }
    return tt;
}
-(id)init
{
    self = [super init];
    self.allblocks = NSMutableArray.new;
    return self;
}

-(NSString*)getAppSelectAddrOrLocAddr
{
    if (self.mSelectAddrObj.mDetailAddress.length>0) {
        return self.mSelectAddrObj.mDetailAddress;
    }
    
    if (self.mSelectAddrObj.mAddress.length) {
        return self.mSelectAddrObj.mAddress;
    }
    return self.mAddr;
}
-(float)getAppSelectLatOrLocLat
{
    return self.mSelectAddrObj.mAddress.length > 0 ? self.mSelectAddrObj.mlat : self.mlat;
}

-(float)getAppSelectLngOrLocLng
{
    return self.mSelectAddrObj.mAddress.length > 0 ? self.mSelectAddrObj.mlng : self.mlng;
}


-(void)updateAppInfo
{
    NSMutableDictionary* dic = NSMutableDictionary.new;
    if( self.mSelCity )
        [dic setObject:self.mSelCity forKey:@"selcity"];
    
    [dic setObject:NumberWithInt(self.mCityId) forKey:@"cityid"];
    
    if( self.mSelectAddrObj.mdic )
        [dic setObject:[Util delNUll:self.mSelectAddrObj.mdic] forKey:@"seladdrobj"];
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:dic forKey:@"gappinfo"];
    [def synchronize];
}

//QMap定位
-(void)getUserLocationQ:(BOOL)bforce block:(void(^)(NSString*err))block{

    NSDate *nowt = [NSDate date];
    long diff = [nowt timeIntervalSince1970] - [_lastget timeIntervalSince1970];
    if( diff < 60*5 && !bforce && _mlat != 0.0f && _mlng != 0.0f && _mAddr.length != 0 )
    {//如果是5 分钟内 不是要求强制定位,并且有坐标,有地址了,,,就不重新定位了,
        block(nil);
        return;
    }
    
    [_allblocks addObject:block];
    if( _blocing )
    {
        return;
    }
    _blocing = YES;
    
    _mapView = [[QMapView alloc] initWithFrame:CGRectZero];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
}

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _mapView.showsUserLocation = NO;
    
    _mlat = userLocation.coordinate.latitude;
    _mlng = userLocation.coordinate.longitude;
    
    
    [SAppInfo getPointAddress:_mlng lat:_mlat block:^(NSString *address,NSString* city, NSString *err) {
        if( !err )
        {
            self.mAddr = address;
            self.mCityNow = city;
            _lastget = [NSDate date];
        }
        
        for(int j = 0; j < _allblocks.count;j++ )
        {
            void(^block)(NSString*err) = _allblocks[j];
            block(err);
        }
        [_allblocks removeAllObjects];
        _blocing = NO;
        
    }];
    
}

- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error{

    NSString* str = nil;
    if( error.code ==1 )
    {
        str = @"定位权限失败";
    }
    else
    {
        str = @"定位失败";
    }
    for(int j = 0; j < _allblocks.count;j++ )
    {
        void(^block)(NSString*err) = _allblocks[j];
        block(str);
    }
    [_allblocks removeAllObjects];
    _blocing = NO;

}

//定位,
-(void)getUserLocation:(BOOL)bforce block:(void(^)(NSString*err))block
{
    NSDate *nowt = [NSDate date];
    long diff = [nowt timeIntervalSince1970] - [_lastget timeIntervalSince1970];
    if( diff < 60*5 && !bforce && _mlat != 0.0f && _mlng != 0.0f && _mAddr.length != 0 )
    {//如果是5 分钟内 不是要求强制定位,并且有坐标,有地址了,,,就不重新定位了,
        block(nil);
        return;
    }
    
    [_allblocks addObject:block];
    if( _blocing )
    {
        return;
    }
    _blocing = YES;
    _llmgr = [[CLLocationManager alloc] init];
    _llmgr.delegate = self;
    _llmgr.desiredAccuracy = kCLLocationAccuracyBest;
    _llmgr.distanceFilter = kCLDistanceFilterNone;
    if([_llmgr respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [_llmgr  requestWhenInUseAuthorization];
    
    
    [_llmgr startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    [manager stopUpdatingLocation];
    
    CLLocation* location = [locations lastObject];
    
    _mlat = location.coordinate.latitude;
    _mlng = location.coordinate.longitude;
    
    
    [SAppInfo getPointAddress:_mlng lat:_mlat block:^(NSString *address,NSString* city, NSString *err) {
        if( !err )
        {
            self.mAddr = address;
            self.mCityNow = city;
            _lastget = [NSDate date];
        }
        
        for(int j = 0; j < _allblocks.count;j++ )
        {
            void(^block)(NSString*err) = _allblocks[j];
            block(err);
        }
        [_allblocks removeAllObjects];
        _blocing = NO;
        
    }];
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString* str = nil;
    if( error.code ==1 )
    {
        str = @"定位权限失败";
    }
    else
    {
        str = @"定位失败";
    }
    for(int j = 0; j < _allblocks.count;j++ )
    {
        void(^block)(NSString*err) = _allblocks[j];
        block(str);
    }
    [_allblocks removeAllObjects];
    _blocing = NO;
}
    

+(void)getPointAddress:(float)lng lat:(float)lat block:(void(^)(NSString* address,NSString* city,NSString*err))block
{
    NSString* requrl = @"http://apis.map.qq.com/ws/geocoder/v1";
    [[APIClient sharedClient] GET:requrl parameters:@{@"location":[NSString stringWithFormat:@"%.6f,%.6f",lat,lng],@"key":QQMAPKEY,@"get_poi":@(0)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* addr = [[[responseObject objectForKey:@"result"] objectForKey:@"formatted_addresses"] objectForKey:@"recommend"];
        NSString* city = [[[responseObject objectForKey:@"result"] objectForKey:@"address_component"] objectForKey:@"city"];
        if( addr == nil || city == nil )
            block(nil,nil,@"获取位置信息失败");
        else
        {
            block(addr,city,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil,nil,@"获取位置信息失败");
        
    }];
}

//根据地址获取坐标
+(void)getAdressPoint:(NSString*)address block:(void(^)(float lng ,float lat,NSString* err))block
{
    NSString* requrl = @"http://apis.map.qq.com/ws/geocoder/v1";
    
    [[APIClient sharedClient] GET:requrl parameters:@{@"address":address,@"key":QQMAPKEY} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* point = [[responseObject objectForKey:@"result"] objectForKey:@"location"];
        float   lng = [[point objectForKey:@"lng"] floatValue];
        float   lat = [[point objectForKey:@"lat"] floatValue];
        if( lat == 0.0f && lat == 0.0f )
            block( lng, lat , @"获取位置信息失败");
        else
            block( lng, lat , nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block( 0,0,@"获取位置信息失败");
        
    }];
}

+(int)calcDist:(float)lat lng:(float)lng
{
    QMapPoint q1 =  QMapPointForCoordinate( CLLocationCoordinate2DMake(lat, lng));
    QMapPoint q2 =  QMapPointForCoordinate( CLLocationCoordinate2DMake([[SAppInfo shareClient] getAppSelectLatOrLocLat], [[SAppInfo shareClient] getAppSelectLngOrLocLng]));
    
    return QMetersBetweenMapPoints(q1,q2);
}



-(void)willReload
{
    _mreloadstep = 1;
}

-(BOOL)canReload
{
    return _mreloadstep == 1;
}

-(void)reloadReSet
{
    _mreloadstep = 0;
}




@end

@implementation SAddress

+(void)saveDefault:(SAddress*)obj
{
    NSString* fuckkey = [NSString stringWithFormat:@"defaultaddr_%d",[SUser currentUser].mUserId];
    if( obj )
    {
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setObject:[Util delNUll:obj.mdic]  forKey:fuckkey];
        [def synchronize];
    }
    else
    {
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        [def setObject:nil forKey:fuckkey];
        [def synchronize];
    }
}
+(SAddress*)loadDefault
{
    NSString* fuckkey = [NSString stringWithFormat:@"defaultaddr_%d",[SUser currentUser].mUserId];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic =[def objectForKey:fuckkey];
    if( dic )
    {
        SAddress* t =  [[SAddress alloc] initWithObj:dic bload:YES];
        t.mIsDefault = YES;
        return t;
    }
    return nil;
}

-(id)initWithObj:(NSDictionary*)obj
{
    return  [self initWithObj:obj bload:NO];
}
-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
    self.mdic = obj;
    
    if ( [self.mMapPoint.class isSubclassOfClass:[NSDictionary class]] )
    {
        self.mlat = [[self.mMapPoint objectForKeyMy:@"x"] floatValue];
        self.mlng = [[self.mMapPoint objectForKeyMy:@"y"] floatValue];
    }
    
    self.mMapPoint = [NSString stringWithFormat:@"%.8f,%.8f",self.mlat,self.mlng];
    
}

-(id)initWithObj:(NSDictionary*)obj bload:(BOOL)bload
{
    if( obj == nil ) return nil;
    self = [super initWithObj:obj];
    if( self && obj != nil )
    {
        if( self.mIsDefault && !bload )
                [SAddress saveDefault:self];
    }
    return self;
}

-(void)setThisDefault:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"user.address.setdefault" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            _mIsDefault = YES;
            
            if( self.mIsDefault )
                [SAddress saveDefault:self];
        }
        block(info);
    }];
    
}


-(void)delThis:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"id"];
    [[APIClient sharedClient] postUrl:@"user.address.delete" parameters:param call:^(SResBase *info) {
        
        if( _mIsDefault )
        {
            [SAddress saveDefault:nil];
        }
        block( info );
        
    }];
}


//添加地址或者修改一个
-(void)addOneAddress:(void(^)(SResBase* resb,SAddress* retobj))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:self.mMobile forKey:@"mobile"];
    [param setObject:@(0) forKey:@"ProvinceId"];
    [param setObject:@(0) forKey:@"cityId"];
    [param setObject:@(0) forKey:@"areaId"];
    [param setObject:self.mMapPoint forKey:@"mapPoint"];
    [param setObject:self.mName forKey:@"name"];
    [param setObject:self.mDetailAddress forKey:@"detailAddress"];
    [param setObject:self.mDoorplate forKey:@"doorplate"];
    if( _mId )
        [param setObject:@(_mId) forKey:@"id"];
    
    [[APIClient sharedClient]postUrl:@"user.address.create" parameters:param call:^(SResBase *info) {
        
        SAddress* retobj = nil;
        if( info.msuccess )
        {
            retobj = [[SAddress alloc]initWithObj:info.mdata];
        }
        block( info , retobj);
        
    }];
    
}

//是否 是一个合法的收货地址
-(BOOL)isVaildAddress
{
    return self.mAddress.length > 0 && self.mMobile.length > 0 && self.mlat != 0.0f && self.mlng != 0.0f;
}



@end


@implementation SStaff



@end

static NSMutableDictionary* g_allhistorykey = nil;

@implementation SSeller
{

}
-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
   
    NSMutableArray *arry = NSMutableArray.new;
    
    NSArray *marry = [obj objectForKeyMy:@"banner"];
    for (int i = 0; i < marry.count; i++) {
        
        SMainFunc *func = [[SMainFunc alloc] initWithObj:[marry objectAtIndex:i]];
        
        [arry addObject:func];
        
    }

    
    self.mBanner = arry;
    
    if ( [self.mMapPoint.class isSubclassOfClass:[NSDictionary class]] ) {
        
        self.mlat = [[self.mMapPoint objectForKeyMy:@"x"] floatValue];
        self.mlng = [[self.mMapPoint objectForKeyMy:@"y"] floatValue];
        
    }
    
    self.mDist = [Util getDistStr: [SAppInfo calcDist:_mlat lng:_mlng]];
    
    
    self.mCity = [[SCity alloc] initWithObj:(NSDictionary *)self.mCity];
    self.mProvince = [[SCity alloc] initWithObj:(NSDictionary *)self.mProvince];
    self.mArea = [[SCity alloc] initWithObj:(NSDictionary *)self.mArea];
    
}

//商家详情
-(void)getDetail:(void(^)(SResBase* info))block
{
    [[APIClient sharedClient]postUrl:@"seller.detail" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
       
        if( info.msuccess ) [self fetchIt:info.mdata];
        block( info );
    }];
}


-(void)favIt:(void(^)(SResBase* info))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"id"];
    [param setObject:@(2) forKey:@"type"];
    NSString* url = @"collect.create";
    if( _mIsCollect )
        url = @"collect.delete";
    [[APIClient sharedClient]postUrl:url parameters:param call:^(SResBase *info) {
        if( info.msuccess )
            _mIsCollect = !_mIsCollect;
        block( info );
    }];
}

+(void)addHistoryKeys:(NSString*)onekey
{
    if( onekey == nil ) return;
    NSMutableDictionary* nowall = [self loadHistoryKeys];
    NSNumber* t = [nowall objectForKey:onekey];
    if( t )
    {
        int j =  [t intValue] + 1;
        [nowall setObject:[NSNumber numberWithInt:j] forKey:onekey];
    }
    else
    {
        [nowall setObject:@(1) forKey:onekey];
    }
    [self saveHistoryKeys:nowall];
}

static NSString* g_key = @"historykey";

+(void)saveHistoryKeys:(NSMutableDictionary*)tag
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    [st setObject:tag forKey:g_key];
    [st synchronize];
}
+(NSMutableDictionary*)loadHistoryKeys
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    id r = [st objectForKey:g_key];
    if( r == nil )
        r = NSMutableDictionary.new;
    else
        r  =[NSMutableDictionary dictionaryWithDictionary:r];
    return r;
}

+(void)cleanAllKeys
{
    [self saveHistoryKeys:nil];
}

//获取商家列表
//sort	int	"排序方式 0：综合排序 1：销量倒序 2：起送价倒序，3：按距离配送，4：评分最高"
//page	int	当前页码
//type	     int	商户类型ID；0为全部
//keyword	String	搜索关键字
+(void)getAllSeller:(int)sort page:(int)page type:(int)type keyword:(NSString*)keyword block:(void(^)( SResBase* info ,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    sort = 3;//设置默认排序为按最近距离排序，同时按客户要求将选择排序按钮默认名称修改为距离最近，与实际排序选择默认sortArr中不符
    [param setObject:@(sort) forKey:@"sort"];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(type) forKey:@"id"];
    if( keyword )
    {
        [param setObject:keyword forKey:@"keyword"];
        if( keyword )
            [SSeller addHistoryKeys:keyword];
    }
    [[APIClient sharedClient]postUrl:@"seller.lists" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for( NSDictionary* one in info.mdata )
            {
                [t addObject: [[SSeller alloc]initWithObj:one]];
            }
            block(info,t);
        }
        else
        {
            block(info,nil);
        }
    }];
}

+(void)getGongGao:(int)sellerId  block:(void(^)( SResBase* info ,NSString* content))block{

    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(sellerId) forKey:@"selelrId"];
    [param setObject:@(sellerId) forKey:@"sellerId"];
    
       [[APIClient sharedClient]postUrl:@"article.lists" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {
            if (info.mdata) {
                
                NSArray *arry = (NSArray *)info.mdata;
                NSString *string = @"";
                if (arry.count>0) {
                    string = [[info.mdata objectAtIndex:0] objectForKeyMy:@"content"]; 
                }
               block(info,string);
            }
        }
        else
        {
            block(info,nil);
        }
    }];

}

//获取商品列表
-(void)getGoods:(void(^)(SResBase* info,NSArray* all))block
{
    [[APIClient sharedClient] postUrl:@"goods.lists" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [t addObject: [[SGoodsPack alloc]initWithObj:one]];
            }
            block( info,t);
        }
        else
            block( info, nil);
    }];
}

//获取该商家 服务列表
-(void)getServices:(void(^)(SResBase* info,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"service.lists" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [t addObject: [[SServiceInfo alloc]initWithObj:one]];
            }
            block( info,t);
        }
        else
            block( info, nil);
        
    }];
}


//all 热门的关键字,,NSString..
+(void)getSearchKeys:(void(^)(SResBase* info,NSArray*allhot,NSArray* allhistory))block
{
    [[APIClient sharedClient]postUrl:@"seller.hotlists" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                SSeller*ttt = [[SSeller alloc]initWithObj:one];
                [t addObject:ttt.mName];
            }
            
            //历史记录
            NSDictionary* hist = [SSeller loadHistoryKeys];
            NSArray* all = [hist allKeys];
            block( info,t,all);
        }
        else
            block(info,nil,nil);
    }];
}


//获取物业详情
-(void)getPropDetail:(void(^)(SResBase* info))block
{
    [[APIClient sharedClient]postUrl:@"property.detail" parameters:@{@"districtId":@(_mId)} call:^(SResBase *info) {
       
        if( info.msuccess ) [self fetchIt:info.mdata];
        block( info );
        
    }];
    
}



@end


@implementation SCarGoods

//添加到购物车,,数量就是 mNum
-(void)addToCart:(int)normId block:(void(^)(SResBase* info,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mGoodsId) forKey:@"goodsId"];
    [param setObject:@(normId) forKey:@"normsId"];
    [param setObject:@(_mNum) forKey:@"num"];
    [[APIClient sharedClient]postUrl:@"shopping.save" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SCarSeller alloc]initWithObj:one]];
            }
            g_allCarInfo = t;
            block( info,t);
        }
        else
            block(info,nil);
        
    }];
}


@end

@interface SCarSeller ()

@property (nonatomic,strong)    id  mGoods;

@end

@implementation SCarSeller

-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
    NSMutableArray* t = NSMutableArray.new;
    for ( NSDictionary* one in self.mGoods) {
        [t addObject:[[SCarGoods alloc] initWithObj:one]];
    }
    self.mCarGoods = t;
    
}


//清除购物车所有数据,
+(void)clearCarInfo:(void(^)( SResBase * resb ))block
{
    [[APIClient sharedClient]postUrl:@"shopping.delete" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [g_allCarInfo removeAllObjects];
            g_allCarInfo = nil;
        }
         block(info);
    }];
}

//获取购物车商品总数
+(int)allCount:(int)selller
{
    int a = 0;
    if( g_allCarInfo )
    {
        for ( SCarSeller* one in g_allCarInfo )
        {
            if( one.mId == selller )
            {
                for ( SCarGoods* oneg in one.mCarGoods ) {
                    a += oneg.mNum;
                }
            }
        }
    }
    return a;
}

//获取某商家的某商品购物车详细数据
+(void)getCarInfoWithGoods:(SGoods*)tag
{
    if( g_allCarInfo )
    {
        for ( SCarSeller* one in g_allCarInfo )
        {
            for ( SCarGoods* oneg in one.mCarGoods ) {
                for ( SGoodsNorms* onen in tag.mNorms  )
                {
                    if( oneg.mNormsId == nil || (onen.mId == [oneg.mNormsId intValue] && onen.mGoodsId == oneg.mGoodsId ) )
                        onen.mCount = oneg.mNum;
                }
            }
        }
    }
}

+(NSArray*)getAllGoodsImages:(NSArray*)all
{
    NSMutableArray* tt = NSMutableArray.new;
    for ( SCarSeller* one in all )
    {
        [tt addObject: one.mCartSellers];
    }
    
   
    
    return tt;
}





@end


@implementation SGoodsPack

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self && obj )
    {
        self.mId = [[obj objectForKeyMy:@"id"] intValue];
        self.mName = [obj objectForKeyMy:@"name"];
        NSMutableArray* t = NSMutableArray.new;
        for ( NSDictionary* one in [obj objectForKeyMy:@"goods"] ) {
            [t addObject: [[SGoods alloc]initWithObj:one]];
        }
        self.mGoods = t;
    }
    return self;
}

@end

@implementation SGoodsNorms


@end

@implementation SGoods
{
}

-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
    NSMutableArray *arry = NSMutableArray.new;
    
    for (NSDictionary *dic in self.mNorms) {
        
        [arry addObject:[[SGoodsNorms alloc] initWithObj:dic]];
        
    }
    
    if( arry.count == 0 )
    {
        SGoodsNorms*ta = SGoodsNorms.new;
        ta.mId = 0;
        ta.mCount = self.mCount;
        ta.mPrice = self.mPrice;
        [arry addObject:  ta ];
    }
    self.mNorms = arry;
}

//详情
-(void)getDetail:(void(^)(SResBase* info))block
{
    [[APIClient sharedClient]postUrl:@"goods.detail" parameters:@{@"goodsId":@(_mId)} call:^(SResBase *info) {
        if( info.msuccess)
            [self fetchIt:info.mdata];
        block(info);
    }];
}




//收藏,,自动处理取消还是收藏
-(void)favIt:(void(^)(SResBase* info))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"id"];
    [param setObject:@(1) forKey:@"type"];
    NSString* url = @"collect.create";
    if( _mIscollect )
        url = @"collect.delete";
    [[APIClient sharedClient]postUrl:url parameters:param call:^(SResBase *info) {
        if( info.msuccess )
            _mIscollect = !_mIscollect;
        block( info );
    }];
}

//添加到购物车,,数量就是 mCount
-(void)addToCart:(SGoodsNorms*)normobj block:(void(^)(SResBase* info,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"goodsId"];
    [param setObject:@(normobj.mId) forKey:@"normsId"];
    [param setObject:@(normobj.mCount) forKey:@"num"];
    [[APIClient sharedClient]postUrl:@"shopping.save" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SCarSeller alloc]initWithObj:one]];
            }
            g_allCarInfo = t;
            block( info,t);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShopCarChanged" object:nil];
        }
        else
            block(info,nil);
        
    }];
}


@end

@implementation SOrderObj

-(id)initWithObj:(NSDictionary*)obj
{
    return  [super initWithObj:obj];
}
-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    NSMutableArray* t = NSMutableArray.new;
    for ( NSDictionary*one in self.mCartSellers)
    {
        [t addObject:[[SCarSeller alloc]initWithObj:one]];
    }
   
    self.mCartSellers = t;


}


+(void)dealOneOrder:(NSArray*)carids addressId:(int)addressId giftContent:(NSString*)giftContent cardNO:(NSString*)cardNo invoiceTitle:(NSString*)invoiceTitle buyRemark:(NSString*)buyRemark appTime:(NSDate*)appTime  bonelinepay:(int)bonelinepay promotionSnId:(NSString*)promotionSnId block:(void(^)(SResBase* resb,SOrderObj* retobj))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:carids forKey:@"cartIds"];
    [param setObject:@(addressId) forKey:@"addressId"];
    
    if( giftContent )
        [param setObject:giftContent forKey:@"giftContent"];
    if( invoiceTitle )
        [param setObject:invoiceTitle forKey:@"invoiceTitle"];
    if( buyRemark )
        [param setObject:buyRemark forKey:@"buyRemark"];
    if( appTime )
    {
        NSString* tt = [Util getTimeString:appTime bfull:YES];
        [param setObject:tt forKey:@"appTime"];
    }
    if(cardNo ){
         [param setObject:cardNo forKey:@"cardNo"];
    }
    [param setObject:@(bonelinepay) forKey:@"payment"];
    
    if( promotionSnId )
        [param setObject:promotionSnId forKey:@"promotionSnId"];
    
    [[APIClient sharedClient]postUrl:@"order.create" parameters:param call:^(SResBase *info) {
       
        if( info.msuccess )
        {
            block( info, [[SOrderObj alloc]initWithObj:info.mdata]);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShopCarChanged" object:nil];
        }
        else
            block( info, nil);
    }];
}

//服务订单提交 不需要支付，下单成功后直接跳转至订单详情
+(void)dealServiceOneOrder:(int)itid mobileid:(int)mobileid addressid:(int)addressid block:(void(^)( SResBase* resb, SOrderObj* retobj ))block
{
    [[APIClient sharedClient]postUrl:@"service.order.create" parameters:@{ @"mobileId":@(mobileid),@"addressId":@(addressid),@"id":@(itid)  } call:^(SResBase *info) {
        if( info.msuccess )
        {
            block( info , [[SOrderObj alloc]initWithObj:info.mdata] );
        }
        else
        {
            block( info, nil );
        }
    }];
}


//订单详情
-(void)getDetail:(void(^)(SResBase* resb))block type:(NSString *)type
{
    NSString * str =@"order.detail";
    if([type intValue]==1){
        str =@"order.cardDetail";
    }
    [[APIClient sharedClient]postUrl:str parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block( info );
    }];
    
}

//取消订单
-(void)cancelThis:(NSString*)remark block:(void(^)(SResBase* resb))block;
{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (remark) {
        [dic setObject:remark forKey:@"cancelRemark"];
    }
    
    [dic setObject:NumberWithInt(_mId) forKey:@"id"];
    
    [[APIClient sharedClient]postUrl:@"order.cancel" parameters:dic call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block( info );
        
    }];
}
//卡卷申请退款
-(void)pullMoney:(NSString *)goodID :(void(^)(SResBase* resb))block
{    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (goodID) {
        [dic setObject:goodID forKey:@"orderId"];
    }
    
    [dic setObject:@(_mId) forKey:@"id"];

    [[APIClient sharedClient]postUrl:@"order.cardRefund" parameters:dic call:block];
}

//卡卷申请退款
-(void)cancelPullMoney:(NSString *)goodID :(void(^)(SResBase* resb))block
{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (goodID) {
        [dic setObject:goodID forKey:@"orderId"];
    }
    
    [dic setObject:@(_mId) forKey:@"id"];
    [[APIClient sharedClient]postUrl:@"order.cardRefundCancel" parameters:dic call:block];
}
//删除订单
-(void)deleteThis:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"order.delete" parameters:@{@"id":@(_mId)} call:block];
}

//订单确认完成（外卖）
-(void)confirmThis:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"order.confirm" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block( info );
    }];
}

-(void)cuidanThis:(void(^)(SResBase* resb))block{

    [[APIClient sharedClient]postUrl:@"order.urge" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block( info );
    }];
}

//申请退款
-(void)refundThis:(NSString*)refundContent refundImages:(UIImage*)refundImages block:(void(^)(SResBase* resb))block
{
    if( refundContent.length == 0 )
    {
        block( [SResBase infoWithError:@"退款理由不能为空"] );
        return;
    }
    
    if( refundImages != nil )
    {
        [SUser uploadImg:refundImages block:^(NSString *err, NSString *filepath) {
           
            if( filepath.length == 0 )
            {
                block( [SResBase infoWithError:err==nil?@"上传文件失败":err]);
            }
            else
            {
                [[APIClient sharedClient]postUrl:@"order.refund" parameters:@{@"refundContent":refundContent,@"refundImages":filepath} call:^(SResBase *info) {
                    
                    if( info.msuccess )
                        [self fetchIt:info.mdata];
                    block( info );
                }];
            }
        }];
    }
    else
    {
        [[APIClient sharedClient]postUrl:@"order.refund" parameters:@{@"refundContent":refundContent} call:^(SResBase *info) {
            
            if( info.msuccess )
                [self fetchIt:info.mdata];
            block( info );
        }];
    }
}



- (void)payIt:(float)money paytype:(NSString *)paytype vc:(UIViewController *)vc block:(void (^)(SResBase *))block{
    
    _payurl=@"user.charge";
    self.money=money;
    if( [paytype isEqualToString:@"alipay"] )
    {
        [self aliPay:block];
    }
    else
        if( [paytype isEqualToString:@"weixin"] )
        {
            [self wxPay:block];
        }
        else if( [paytype isEqualToString:@"unionapp"] )
        {
            [self yinlianPay:vc block:block];
        }
        else if( [paytype isEqualToString:@"cashOnDelivery"] )
        {
            [self huodaoPay:block];
        }
        else
        {
            block( [SResBase infoWithError:@"不支持的支付方式"] );
        }
    
}



//支付 paytype 支付方式 ==> SPayment.mName
-(void)payIt:(int)balance choosePaytype:(NSString*)paytype vc:(UIViewController*)vc block:(void(^)(SResBase* resb))block
{
    
    _payurl=@"order.pay";
    _isbalancePay=balance;
    if( [paytype isEqualToString:@"alipay"] )
    {
        [self aliPay:block];
    }
    else
    if( [paytype isEqualToString:@"weixin"] )
    {
        [self wxPay:block];
    }
    else if( [paytype isEqualToString:@"unionapp"] )
    {
        [self yinlianPay:vc block:block];
    }
    else if( [paytype isEqualToString:@"cashOnDelivery"] )
    {
        [self huodaoPay:block];
    }
    else if( [paytype isEqualToString:@"balancePay"] )
    {
        [self yuEPay:block];
    }
    else
    {
        block( [SResBase infoWithError:@"不支持的支付方式"] );
    }
}
-(void)yuEPay:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"id"];
    [param setObject:@"balancePay" forKey:@"payment"];
    [param setObject:@{@"balancePay":@"1"} forKey:@"extend"];
    
    [[APIClient sharedClient] postUrl:@"order.pay" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self getDetail:block type:nil];
        }
        else
        {
            block(info);//再回调获取
        }
    }];
}
-(void)yinlianPay:(UIViewController*)vc block:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    if(_money>0.0f){
        [param setObject:@(_money) forKey:@"money"];
    }else{
        [param setObject:NumberWithInt(_mId) forKey:@"id"];
        [param setObject:@{@"balancePay":@(_isbalancePay)} forKey:@"extend"];
    }
    
    [param setObject:@"unionapp" forKey:@"payment"];
    [[APIClient sharedClient] postUrl:_payurl parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSString* payinfotn = [[info.mdata objectForKeyMy:@"payRequest"] objectForKeyMy:@"tn"];
            
            NSString* ss = @"00";
#ifdef DEBUG
            ss = @"00";
#endif
            [SAppInfo shareClient].mPayBlock = ^(SResBase *retobj) {
                
                if( retobj.msuccess )
                {//如果成功了,就更新下
                    if (_money>0.0f) {
                        block(retobj);
                    }else{
                        [self getDetail:block type:nil];
                    }
                }else
                    block(retobj);//再回调获取
                [SAppInfo shareClient].mPayBlock = nil;
                
            };
            
            [[UPPaymentControl defaultControl] startPay:payinfotn fromScheme:@"UPPayO2OCommunity" mode:ss viewController:vc];
            
        }
        else
        {
            block(info);//再回调获取
        }
    }];
}
-(void)huodaoPay:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"id"];
    [param setObject:@"cashOnDelivery" forKey:@"payment"];
    [[APIClient sharedClient] postUrl:@"order.pay" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self getDetail:block type:nil];
        }
        else
        {
            block(info);//再回调获取
        }
    }];
}
-(void)aliPay:(void(^)(SResBase* retobj))block
{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    if(_money>0.0f){
        [param setObject:@(_money) forKey:@"money"];
    }else{
        [param setObject:NumberWithInt(_mId) forKey:@"id"];
        [param setObject:@{@"balancePay":@(_isbalancePay)} forKey:@"extend"];
    }
    [param setObject:@"alipay" forKey:@"payment"];
         NSLog(@" parm=================%@",param);
    [[APIClient sharedClient] postUrl:_payurl parameters:param call:^(SResBase *info) {
   
        if( info.msuccess )
        {
//            self.mPayedSn = [info.mdata objectForKeyMy:@"sn"];
//            self.mPayMoney = [[info.mdata objectForKeyMy:@"money"] floatValue];
            NSString* typestr = [info.mdata objectForKeyMy:@"paymentType"];
            if( [typestr isEqualToString:@"alipay"] )
            {
                NSLog(@"info.mdata%@",info.mdata);
                NSString* payinfo = [[info.mdata objectForKeyMy:@"payRequest"] objectForKeyMy:@"packages"];
                NSLog(@"payinfo====%@",payinfo);
                [SAppInfo shareClient].mPayBlock = ^(SResBase *retobj) {
                    
                    if( retobj.msuccess )
                    {//如果成功了,就更新下
                        if (_money>0.0f) {
                            block(retobj);
                        }else{
                            [self getDetail:block type:nil];
                        }
                    }else
                        block(retobj);//再回调获取
                    [SAppInfo shareClient].mPayBlock = nil;
                    
                };
                
                [SVProgressHUD dismiss];
                
                [[AlipaySDK defaultService] payOrder:payinfo fromScheme:@"YiZanO2OCommunity" callback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"xxx:%@",resultDic);
                    
                    SResBase* retobj = nil;
                    
                    if (resultDic)
                    {
                        if ( [[resultDic objectForKey:@"resultStatus"] intValue] == 9000 )
                        {
                            retobj = [[SResBase alloc]init];
                            retobj.msuccess = YES;
                            retobj.mmsg = @"支付成功";
                            retobj.mcode = 0;
                        }
                        else
                        {
                            retobj = [SResBase infoWithError: [resultDic objectForKey:@"memo" ]];
                        }
                    }
                    else
                    {
                        retobj = [SResBase infoWithError: @"支付出现异常"];
                    }
                    
                    if( [SAppInfo shareClient].mPayBlock )
                    {
                        [SAppInfo shareClient].mPayBlock( retobj );
                    }
                    else
                    {
                        MLLog(@"alipay block nil?");
                    }
                    
                }];
                return;
            }
            else
            {
                SResBase* retobj = [SResBase infoWithError:@"支付出现异常,请稍后再试"];
                block(retobj);
            }
        }
        else block( info );
        
    }];
    
}

//=======================微信支付===================================
-(void)wxPay:(void(^)(SResBase* retobj))block
{
    
    NSMutableDictionary* param =    NSMutableDictionary.new;
    if(_money>0.0f){
        [param setObject:@(_money) forKey:@"money"];
        
    }else{
        [param setObject:NumberWithInt(_mId) forKey:@"id"];
        [param setObject:@{@"balancePay":@(_isbalancePay)} forKey:@"extend"];
    }
    [param setObject:@"weixin" forKey:@"payment"];
    [[APIClient sharedClient] postUrl:_payurl parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
           // self.mPayedSn = [info.mdata objectForKeyMy:@"sn"];
           // self.mPayMoney = [[info.mdata objectForKeyMy:@"money"] floatValue];
            
            NSString* typestr = [info.mdata objectForKeyMy:@"paymentType"];
            if( [typestr isEqualToString:@"weixin"] )
            {
                [SVProgressHUD dismiss];
                SWxPayInfo* wxpayinfo = [[SWxPayInfo alloc]initWithObj:[info.mdata objectForKeyMy:@"payRequest"]];
                [SAppInfo shareClient].mPayBlock = ^(SResBase *retobj) {
                    
                    if( retobj.msuccess )
                    {//如果成功了,就更新下
                        if (_money>0.0f) {
                            block(retobj);
                        }else{
                            [self getDetail:block type:nil];
                        }
                        
                    }else
                        block(retobj);//再回调获取
                    [SAppInfo shareClient].mPayBlock = nil;
                    
                };
                [self gotoWXPayWithSRV:wxpayinfo];
            }
            else
            {
                SResBase* itretobj = [SResBase infoWithError:@"支付出现异常,请稍后再试"];
                block(itretobj);//再回调获取
            }
        }
        else
            block( info );
    }];
}

-(void)gotoWXPayWithSRV:(SWxPayInfo*)payinfo
{
    PayReq * payobj = [[PayReq alloc]init];
    payobj.partnerId = payinfo.mpartnerId;
    payobj.prepayId = payinfo.mprepayId;
    payobj.nonceStr = payinfo.mnonceStr;
    payobj.timeStamp = payinfo.mtimeStamp;
    payobj.package = @"Sign=WXPay";
    payobj.sign = payinfo.msign;
    [WXApi sendReq:payobj];
    
}


//评价订单
-(void)cmmThis:(NSString*)content star:(int)star imgs:(NSArray*)imgs bno:(int)isAno block:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    if( content )
        [param setObject:content forKey:@"content"];
    [param setObject:@(_mId) forKey:@"orderId"];
    [param setObject:@(star) forKey:@"star"];
    [param setObject:@(isAno) forKey:@"isAno"];
    
    if( 0 == imgs.count )
    {
        [[APIClient sharedClient]postUrl:@"rate.order.create" parameters:param call:block];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            NSError* err = nil;
            NSMutableArray* allupload = NSMutableArray.new;
            int j = 1;
            int c = imgs.count;
            for ( UIImage* one in imgs )
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传图片:%d/%d",j,c] maskType:SVProgressHUDMaskTypeClear];
                });
                
                NSString* s = [SUser uploadImagSyn: one error: &err];
                if( s )
                {
                    [allupload addObject: s ];
                }
                else{
                    block( [SResBase infoWithError:err.description]  );
                    return ;
                }
                j++;
            }
            
            [param setObject:allupload forKey:@"images"];
            [[APIClient sharedClient]postUrl:@"rate.order.create" parameters:param call:block];
            
        });
    }
}

- (void)getActivity:(void(^)(SShareContent *mShare,SResBase* resb))block{

    [[APIClient sharedClient]postUrl:@"activity.getshare" parameters:@{@"orderId":@(_mId)} call:^(SResBase *info) {
    
        
        if (info.msuccess) {
            
            SShareContent   *mSS  = [[SShareContent alloc] initWithObj:info.mdata];
            NSLog(@"*-*-*-*-*-*-*:%@",mSS);
            block ( mSS,info );

        }else{
            block ( nil,info );
        }
        

        
    }];
    
}

-(void)notShowBigShare
{
    [[APIClient sharedClient]postUrl:@"order.notshow" parameters:@{@"orderId":@(_mId)} call:^(SResBase *info) {
        
    }];
}
@end




@implementation SOrderRateInfo


//获取评价
//typ 1:好评 2:中评 3:差评 ; arr => SComments1:
//获取评价
+(void)getComments:(int)type page:(int)page sellerId:(int)sellerId block:(void(^)(SResBase* resb,NSArray* arr))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(type) forKey:@"type"];
    [param setObject:NumberWithInt(page) forKey:@"page"];
    [param setObject:NumberWithInt(sellerId) forKey:@"sellerId"];
    
    [[APIClient sharedClient] postUrl:@"rate.order.lists" parameters:param call:^(SResBase *info) {
        
        NSArray* t = nil;
        if( info.msuccess )
        {
            NSMutableArray* tmpa = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata) {
                [tmpa addObject:[[SOrderRateInfo alloc] initWithObj: one]];
            }
            t = tmpa;
        }
        
        block(info,t);
        
    }];
    
}



@end



@implementation SServiceInfo
//收藏,,自动处理取消还是收藏
-(void)favIt:(void(^)(SResBase* info))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"id"];
    [param setObject:@(1) forKey:@"type"];
    NSString* url = @"collect.create";
    if( _mIsCollect )
        url = @"collect.delete";
    [[APIClient sharedClient]postUrl:url parameters:param call:^(SResBase *info) {
        if( info.msuccess )
            _mIsCollect = !_mIsCollect;
        block( info );
    }];
}
-(void)getDetail:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"service.detail" parameters:@{@"goodsId":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
        }
        block( info );
        
    }];
}


//服务评价列表 allrates ==> SOrderRateInfo
-(void)getRateList:(int)page block:(void(^)(SResBase* resb, NSArray* allrates ))block
{
    [[APIClient sharedClient]postUrl:@"rate.service.lists" parameters:@{ @"id":@(_mId),@"page":@(page)} call:^(SResBase *info) {
        
        if ( info.msuccess ) {
            
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in  info.mdata )
            {
                [t addObject: [[SOrderRateInfo alloc]initWithObj:one]];
            }
            block( info ,t );
        }
        else block( info , nil );
        
    }];
}

-(void)addToCart:(NSString*)timestr block:(void(^)(SResBase* info,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"goodsId"];
    [param setObject:@(_mNum) forKey:@"num"];
    if( timestr )
        [param setObject:timestr forKey:@"serviceTime"];
    [[APIClient sharedClient]postUrl:@"shopping.save" parameters:param call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SCarSeller alloc]initWithObj:one]];
            }
            g_allCarInfo = t;
            block( info,t);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShopCarChanged" object:nil];
        }
        else
            block(info,nil);
        
    }];
}


@end


@implementation SOrderRate


+(void)getRateNum:(int)sellerId block:(void(^)(SResBase* resb,SOrderRate *rate))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    
    [param setObject:NumberWithInt(sellerId) forKey:@"sellerId"];
    
    [[APIClient sharedClient] postUrl:@"rate.order.statistics" parameters:param call:^(SResBase *info) {
        
        SOrderRate *Rate;
        if( info.msuccess )
        {
    
          Rate = [[SOrderRate alloc] initWithObj: info.mdata];
    
        }
        
        block(info,Rate);
        
    }];
    
}

@end




@implementation SMessageInfo

-(id)initWithAPN:(NSDictionary*)objapn
{
    self = [super init];
    if( self )
    {
        self.mArgs = [objapn objectForKeyMy:@"args"];
        self.mType = [[objapn objectForKeyMy:@"type"] intValue];
    }
    
    return self;
}


-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    
    self.mIsRead = [[obj objectForKeyMy:@"isRead"] intValue];
    self.mType = [[obj objectForKeyMy:@"type"] intValue];
    self.mContent = [obj objectForKeyMy:@"content"];
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mTitle = [obj objectForKeyMy:@"title"];
    self.mCreateTime = [obj objectForKeyMy:@"createTime"];
    self.mArgs = [obj objectForKeyMy:@"args"];
    
    return self;
}


//读这个
-(void)readThis:(void(^)(SResBase* resb))block
{
    [SMessageInfo readAll:@[@(_mId)] block:^(SResBase *resb) {
        
        if ( resb.msuccess ) {
            _mIsRead = NO;
        }
        block( resb );
    }];
}

//删除这个
-(void)delThis:(void(^)(SResBase* resb))block
{
    [SMessageInfo delAll:@[@(_mId)] block:block];
}

//阅读,批量,all==nil,表示所有
+(void)readAll:(NSArray*)all block:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"msg.read" parameters:@{@"id":all == nil ? @"0":all} call:block];
}

//删除,批量,all==nil,表示所有
+(void)delAll:(NSArray*)all block:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"msg.delete" parameters:@{@"id":all == nil ? @"0":all} call:block];
}




@end


@implementation SSellerCate

- (void)fetchIt:(NSDictionary *)obj{

    [super fetchIt:obj];
    
    NSMutableArray *arry =  NSMutableArray.new;
    
    SSellerCate *allCate = [[SSellerCate alloc] init];
    allCate.mId = _mId;
    allCate.mName = @"全部";
    allCate.mLogo = _mLogo;
    [arry addObject:allCate];
    
    for (NSDictionary *dic in self.mChilds) {
        
        SSellerCate *cate = [[SSellerCate alloc] initWithObj:dic];
        
        [arry addObject:cate];
    }
    
    self.mChilds = arry;
}

+(void)getAllCates:(int)sellerid andType:(int)type  block:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"seller.catelists" parameters:@{@"id":@(sellerid),@"type":@(type)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SSellerCate alloc] initWithObj:one]];
            }
            block( info,t);
        }
        else
            block(info,nil);
    }];
}



@end


@implementation SForumPlate

//
-(void)getThisPosts:(int)page block:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"forumposts.lists" parameters:@{@"plateId":@(_mId),@"page":@(page),@"pageSize":@(20)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for (NSDictionary* one in info.mdata )
            {
                [t addObject: [[SForumPosts alloc]initWithObj:one]];
            }
            block(info,t);
        }
        else
            block( info,nil );
    }];
}

//获取所有板块
+(void)getAllPlates:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"forumplate.lists" parameters:nil call:^(SResBase *info) {
       
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary* one in info.mdata ) {
                [t addObject: [[SForumPlate alloc]initWithObj:one]];
            }
            block( info , t );
        }
        else
        {
            block( info , nil );
        }
        
    }];
}


@end

NSMutableArray* g_searchkey = nil;
@implementation SForumPosts



-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
    NSMutableArray*t = NSMutableArray.new;
    for ( NSDictionary* one in self.mChilds ) {
        [t addObject: [[SForumPosts alloc]initWithObj:one]];
    }
    self.mChilds = t;
    
}

//提交,保存帖子
-(void)submitPost:(void(^)(SResBase* resb))block
{
    NSMutableArray* needupload = NSMutableArray.new;
    NSMutableArray* allpath = NSMutableArray.new;

    if( self.mImagesArr.count )
    {
        for ( UIImage* one in self.mImagesArr ) {
            if( [one isKindOfClass:[UIImage class]] )
            {
                [needupload addObject:one];
            }
            else if( [one isKindOfClass:[NSString class]])
            {
                [allpath addObject: one];
            }
        }
    }
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"id"];
    [param setObject:@(_mPlate.mId) forKey:@"plateId"];
    [param setObject:self.mTitle forKey:@"title"];
    [param setObject:self.mContent forKey:@"content"];
    [param setObject:@(self.mAddress.mId) forKey:@"addressId"];
    
    if( needupload.count )
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            NSError* error = nil;
            int i = 1;
            int c = needupload.count;
            for ( UIImage* one in needupload ) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传图片:%d/%d...",i,c] maskType:SVProgressHUDMaskTypeClear];
                });
                
                NSString* onefilepath =
                [SUser uploadImagSyn:one error:&error];
                if( onefilepath == nil )
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SResBase* info = [SResBase infoWithError:@"上传图片失败"];
                        block( info );
                    });
                    return ;
                }
                
                [allpath addObject:onefilepath];
                
                i++;
            }
            [param setObject:allpath forKey:@"images"];
            [[APIClient sharedClient]postUrl:@"forumposts.save" parameters:param call:^(SResBase *info) {
                
                if( info.msuccess )
                {
                    [self fetchIt:info.mdata];
                }
                block( info );
            }];
        });
    }
    else
    {
        
        [param setObject:allpath forKey:@"images"];
        
        [[APIClient sharedClient]postUrl:@"forumposts.save" parameters:param call:^(SResBase *info) {
            
            if( info.msuccess )
            {
                [self fetchIt:info.mdata];
            }
            block( info );
        }];
    }
}


//搜索帖子,会自动记录搜索的关键字,做为历史记录
+(void)searchPost:(int)page keywords:(NSString*)keywords block:(void(^)(SResBase* resb,NSArray* all))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:keywords forKey:@"keywords"];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(20) forKey:@"pageSize"];
    
    [self addHistroy:keywords];
    
    [[APIClient sharedClient]postUrl:@"forumposts.search" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for (NSDictionary* one in info.mdata ) {
                [t addObject:[[SForumPosts alloc]initWithObj:one]];
            }
            block( info,t);
        }
        else
        {
            block( info ,nil );
        }
    }];
}

//获取记录记录
+(NSArray*)getHistory
{
    return [self loadHistoryArr];
}

+(NSMutableArray*)loadHistoryArr
{
    if( nil != g_searchkey ) return g_searchkey;
    g_searchkey = NSMutableArray.new;
    
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    
    NSArray* t = [st objectForKey:@"tie_searchkey"];
    if( t )
        [g_searchkey addObjectsFromArray:t];
    
    return g_searchkey;
}

+(void)dumpHistoryArr:(NSArray*)arr
{
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    [st setObject:arr forKey:@"tie_searchkey"];
    [st synchronize];
}

+(void)addHistroy:(NSString*)keywords
{
    if( keywords == nil ) return;
    if( [g_searchkey containsObject:keywords] ) return;
    [g_searchkey addObject:keywords];
    [self dumpHistoryArr:g_searchkey];
}

//删除历史记录
+(void)delThisHistory:(NSString*)keywords
{
    [g_searchkey removeObject:keywords];
    [self dumpHistoryArr:g_searchkey];
}

//获取评论 ==> all
//isLandlord	int	1表示只看楼主 0表示所有
//sort	int	根据时间 （0 升序，1 降序） 排列
-(void)getRebacks:(int)page isLandlord:(int)isLandlord sort:(int)sort block:(void(^)(SResBase* resb,NSArray* all))block
{
    /*
     id	int	帖子编号
     isLandlord	int	1表示只看楼主 0表示所有
     sort	int	根据时间 （0 升序，1 降序） 排列
     page	int	页数
     pageSize	int	每页数量
     */
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mId) forKey:@"id"];
    [param setObject:@(isLandlord) forKey:@"isLandlord"];
    [param setObject:@(sort) forKey:@"sort"];
    [param setObject:@(page) forKey:@"page"];
    [param setObject:@(20) forKey:@"pageSize"];
    
    [[APIClient sharedClient]postUrl:@"forumposts.edit" parameters:param call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            //SForumPosts* tobj = [[SForumPosts alloc]initWithObj:info.mdata];
            [self fetchIt:info.mdata];
            block( info , self.mChilds );
        }
        else
        {
            block( info , nil);
        }
    }];
}

//删除
-(void)delThis:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"forumposts.delete" parameters:@{@"id":@(_mId)} call:block];
}

//回复,
-(void)rebackThis:(NSString*)content block:(void(^)(SResBase* resb))block
{
    /*
    id	int	帖子编号
    content	string	内容
     */
    [[APIClient sharedClient]postUrl:@"forumposts.reply" parameters:@{@"id":@(_mId),@"content":content} call:block];
}

//点赞
-(void)goodThis:(void(^)(SResBase* resb))block
{
    
    [[APIClient sharedClient]postUrl:@"forumposts.praise" parameters:@{@"postsId":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            self.mIsPraise = [[info.mdata objectForKeyMy:@"status"] boolValue];
            self.mGoodNum += self.mIsPraise ==1 ?1:-1;
        }
        block( info );
        
    }];
    
}
-(void)reportThis:(NSString*)content block:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"forumposts.complain" parameters:@{@"id":@(_mId),@"content":content} call:^(SResBase *info) {
        
        block( info );
        
    }];
}


@end

@implementation SForumIndex

-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    NSMutableArray*t = NSMutableArray.new;
    for ( NSDictionary* one in self.mPlates ) {
        [t addObject: [[SForumPlate alloc]initWithObj:one]];
    }
    self.mPlates = t;
    
    NSMutableArray*tt = NSMutableArray.new;
    for ( NSDictionary* one in self.mPosts ) {
        [tt addObject: [[SForumPosts alloc]initWithObj:one]];
    }
    self.mPosts = tt;
}
+(void)getForumIndex:(void(^)(SResBase* resb,SForumIndex* retobj))block
{
    [[APIClient sharedClient]postUrl:@"forumposts.index" parameters:nil call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            block( info , [[SForumIndex alloc]initWithObj:info.mdata] );
        }
        else
        {
            block( info,nil);
        }
    }];
}

@end

@implementation SOrderCompute

//计算购物车价格 promotionSn 优惠卷 carids 购物车编号(数组)
+(void)computerInfo:(NSString*)promotionSnId carids:(NSArray*)carids block:(void(^)(SResBase* resb ,SOrderCompute* retobj ))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    if( promotionSnId )
        [param setObject:promotionSnId forKey:@"promotionSnId"];
    if( carids )
        [param setObject:carids forKey:@"cartIds"];
    
    [[APIClient sharedClient]postUrl:@"order.compute" parameters:param call:^(SResBase *info) {
        
        block( info, [[SOrderCompute alloc]initWithObj:info.mdata] );
        
    }];
    
}

@end



@implementation SPromotion

//@property (nonatomic,strong)    NSString*       mType;//	string	优惠券类型: offset :抵用券 money: 优惠券
-(BOOL)bY// YES 优惠券 ,  NO 抵用券 ,
{
    return [self.mType isEqualToString:@"money"];
}

//优惠券兑换
+(void)exchangeOne:(NSString*)sn block:(void(^)(SResBase* resb ,SPromotion* retobj ))block
{
    [[APIClient sharedClient]postUrl:@"user.promotion.exchange" parameters:@{@"sn":sn,@"type":@(2)} call:^(SResBase *info) {
        
        if( info.msuccess)
        {
            block(info,[[SPromotion alloc]initWithObj:info.mdata]);
        }
        else
        {
            block( info,nil);
        }
    }];
}

//领取
-(void)getThis:(void(^)(SResBase* resb ,SPromotion* retobj ))block
{
    [[APIClient sharedClient]postUrl:@"user.promotion.exchange" parameters:@{@"promotionId":@(_mPromotionId),@"type":@(1)} call:^(SResBase *info) {
        
        if( info.msuccess)
        {
            block(info,[[SPromotion alloc]initWithObj:info.mdata]);
        }
        else
        {
            block( info,nil);
        }
    }];
}






@end


@implementation SForumMessage


//删除这个
-(void)delThis:(void(^)(SResBase* resb ))block
{
    [[APIClient sharedClient]postUrl:@"forummessage.delete" parameters:@{@"id":@(_mId)} call:block];
}

//已读
-(void)readThis:(void(^)(SResBase* resb ))block
{
    [[APIClient sharedClient]postUrl:@"forummessage.read" parameters:@{@"id":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            self.mReadTime = @"1";
        }
        block( info );
        
    }];
}




@end

@implementation SDoorKeysInfo



+(void)dumpCache:(id)tag
{
    NSString* key = [NSString stringWithFormat:@"doorkeycache_%d",[SUser currentUser].mUserId];
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    [st setObject:[Util delNullInArr:tag] forKey:key];
    [st synchronize];
}
+(id)loadCache
{
    NSString* key = [NSString stringWithFormat:@"doorkeycache_%d",[SUser currentUser].mUserId];
    NSUserDefaults* st = [NSUserDefaults standardUserDefaults];
    return [st objectForKey:key];
}

+ (void)getDoorKeys:(int)villagesid block:(void(^)(SResBase* resb,NSArray* all))block{
    
    if( ![AFNetworkReachabilityManager sharedManager].reachable )
    {
        NSMutableArray* t = NSMutableArray.new;
        NSArray* cachetag = [SDoorKeysInfo loadCache];
        if( cachetag.count )
        {
            for ( NSDictionary*one in cachetag ) {
                [t addObject:[[SDoorKeysInfo alloc] initWithObj:one]];
            }
            SResBase* tt =SResBase.new;
            tt.mcode = 0;
            tt.msuccess = YES;
            block( tt ,t);
            return;
        }
    }
    
    
    [[APIClient sharedClient]postUrl:@"user.getdoorkeys" parameters:@{@"villagesid":@(villagesid)} call:^(SResBase *info) {
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SDoorKeysInfo alloc] initWithObj:one]];
            }
            if( info.mdata )
            {
                [SDoorKeysInfo dumpCache:info.mdata];
            }
            block( info,t);
        }
        else
        {
            if( info.mcode == 1 )
            {
                NSMutableArray* t = NSMutableArray.new;
                NSArray* cachetag = [SDoorKeysInfo loadCache];
                if( cachetag.count )
                {
                    for ( NSDictionary*one in cachetag ) {
                        [t addObject:[[SDoorKeysInfo alloc] initWithObj:one]];
                    }
                    SResBase* tt =SResBase.new;
                    tt.mcode = 0;
                    tt.msuccess = YES;
                    block( tt ,t);
                }
                else
                {
                    block(info,nil);
                }
            }
            else
                block(info,nil);
        }
    }];
}


- (void)updateDoorKeys:(NSString *)doorname block:(void(^)(SResBase* resb))block{
    
    [[APIClient sharedClient]postUrl:@"user.editdoorinfo" parameters:@{@"doorid":@(_mDoorid),@"doorname":doorname} call:^(SResBase *info) {
        if( info.msuccess )
        {
            [self fetchIt:info.mdata];
            block( info );
        }
        else
            block(info);
    }];
    
}

-(void)openRecode:(int)ecode did:(int)did bid:(int)bid rid:(int)rid
{
    [[APIClient sharedClient]postUrl:@"user.opendoor" parameters:@{@"errorCode":@(ecode),@"districtId":@(did),@"buildId":@(bid),@"roomId":@(rid),@"doorId":@(_mDoorid)} call:^(SResBase *info) {
        
        
    }];
}



@end

@implementation SRoom



@end
@implementation SBuilding



//获取这栋楼的所有房间
-(void)getRooms:(void(^)(NSArray* all,SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"district.getroomlist" parameters:@{@"buildingid":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SRoom alloc]initWithObj:one]];
            }
            block( t, info );
        }
        else
            block( nil, info );
        
    }];
}


@end
@implementation SDistrict


-(void)getBuilds:(void(^)(NSArray* all,SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"district.getbuildinglist" parameters:@{@"villagesid":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SBuilding alloc]initWithObj:one]];
            }
            block( t, info );
        }
        else
            block( nil, info );
    }];
}

+(void)searchDistrict:(NSString*)keywords block:(void(^)(NSArray* all,SResBase* resb))block
{
    if( keywords.length )
    {
        [[APIClient sharedClient]postUrl:@"district.searchvillages" parameters:@{@"keywords":keywords} call:^(SResBase *info) {
            
            if( info.msuccess )
            {
                NSMutableArray* t = NSMutableArray.new;
                for ( NSDictionary*one in info.mdata) {
                    [t addObject:[[SDistrict alloc]initWithObj:one]];
                }
                block( t  , info);
            }
            else
                block( nil , info);
            
        }];
        
    }
    else
    {
        NSString* ss = [NSString stringWithFormat:@"%.6f,%.6f",[[SAppInfo shareClient] getAppSelectLatOrLocLat],[[SAppInfo shareClient] getAppSelectLngOrLocLng]];
        [[APIClient sharedClient]postUrl:@"district.getnearestlist" parameters:@{@"location":ss} call:^(SResBase *info) {
            
            if( info.msuccess )
            {
                NSMutableArray* t = NSMutableArray.new;
                for ( NSDictionary*one in info.mdata) {
                    [t addObject:[[SDistrict alloc]initWithObj:one]];
                }
                block( t  , info);
            }
            else
                block( nil , info);
            
        }];
    }
}

//删除这个小区
-(void)delThis:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"district.delete" parameters:@{@"districtId":@(_mId)} call:block];
}


//加入我的小区
-(void)addThis:(void(^)(SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"district.create" parameters:@{@"districtId":@(_mId)} call:block];
}

//获取详情
-(void)getDetail:(void(^)(SResBase* resb))block
{
    
    [[APIClient sharedClient]postUrl:@"district.get" parameters:@{@"districtId":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
            [self fetchIt:info.mdata];
        block( info );
        
    }];
    
}

//获取保修列表

-(void)getRepairList:(int)page block:(void (^)(SResBase *, NSArray *))block
{
    [[APIClient sharedClient]postUrl:@"property.repairlists" parameters:@{@"districtId":@(_mId),@"page":@(page)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SRepair alloc]initWithObj:one]];
            }
            block(  info, t);
        }
        else
            block( info, nil );
    }];
}

-(void)checkDoor:(void(^)(SAuth* retobj,SResBase* resb))block
{
    [[APIClient sharedClient]postUrl:@"user.applyaccess" parameters:@{@"districtId":@(_mId)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            block( [[SAuth alloc]initWithObj:info.mdata],info );
        }
        else
            block( nil, info );
        
    }];
}




@end

@implementation SAuth



-(void)fetchIt:(NSDictionary *)obj
{
    [super fetchIt:obj];
    
}

-(void)submitThisAuth:(void(^)(SResBase* resb))block
{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mDistrict.mId)  forKey:@"villagesid"];
    [param setObject:@(_mBuild.mId)  forKey:@"buildingid"];
    [param setObject:@(_mRoom.mId)  forKey:@"roomid"];
    [param setObject:self.mName         forKey:@"username"];
    [param setObject:self.mMobile       forKey:@"usertel"];
    
    [[APIClient sharedClient]postUrl:@"user.villagesauth" parameters:param call:^(SResBase *info) {
        block( info );
    }];
}

//获取我的物业信息
+(void)getMyWuye:(int)sdid block:(void(^)(SResBase*resb,SAuth* retobj))block
{
    if( sdid == -1 )
    {
        [[APIClient sharedClient]postUrl:@"district.getdistrict" parameters:nil call:^(SResBase *info) {
            
            block( info , [[SAuth alloc]initWithObj:info.mdata]);
            
        }];
    }
    else
    {
        [[APIClient sharedClient]postUrl:@"district.getdistrict" parameters:@{@"districtId":@(sdid)} call:^(SResBase *info) {
            
            block( info , [[SAuth alloc]initWithObj:info.mdata]);
            
        }];
    }
}





@end





@implementation SArticle


+(void)getArticlelist:(int)sellerid block:(void(^)(SResBase* resb,NSArray* all))block
{
    [[APIClient sharedClient]postUrl:@"article.lists" parameters:@{@"sellerId":@(sellerid)} call:^(SResBase *info) {
        
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SArticle alloc]initWithObj:one]];
            }
            block(  info, t);
        }
        else
            block( info, nil );
    }];

}
@end

@implementation SRepair

-(void)submitRepair:(void(^)(SResBase* resb))block
{
    __block NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:@(_mDistrictId) forKey:@"districtId"];
    [param setObject:@(_mTypeid) forKey:@"typeId"];
    if( self.mContent )
        [param setObject:self.mContent forKey:@"content"];
    
    if( self.mImages.count )
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSError* error = nil;
            int c = self.mImages.count;
            int i = 1;
            NSMutableArray* uploaded = NSMutableArray.new;
            for ( UIImage* one in self.mImages ) {
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在上传图片%d/%d...",i,c] maskType:SVProgressHUDMaskTypeClear];
                });
                NSString* ss = [SUser uploadImagSyn:one error:&error];
                if( ss.length == 0 )
                {
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        SResBase* aaa = [SResBase infoWithError:@"上传图片失败"];
                        block( aaa );
                        
                    });
                    return ;
                }
                [uploaded addObject: ss];
                i++;
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD showWithStatus:@"正在提交数据" maskType:SVProgressHUDMaskTypeClear];
            });
            
            [param setObject:uploaded forKey:@"images"];
            [[APIClient sharedClient]postUrl:@"property.createrepair" parameters:param call:block];
        });
    }
    else
    {
        [[APIClient sharedClient]postUrl:@"property.createrepair" parameters:param call:block];
    }
}




@end

@implementation SRepairType


+(void)getRepairTypes:(void (^)(SResBase *, NSArray *))block
{
    [[APIClient sharedClient]postUrl:@"property.typelists" parameters:nil call:^(SResBase *info) {
       
        if( info.msuccess )
        {
            NSMutableArray* t = NSMutableArray.new;
            for ( NSDictionary*one in info.mdata) {
                [t addObject:[[SRepairType alloc]initWithObj:one]];
            }
            block(  info, t);
        }
        else
            block( info, nil );
    }];
}





@end


@implementation SShareContent


-(id)initWithObj:(NSDictionary*)obj{

    
    self = [super init];
    if( self && obj )
    {
        [self fetchIt:obj];
    }
    return self;
}

-(void)fetchIt:(NSDictionary*)obj{

    self.mSurplusTime = [obj objectForKeyMy:@"surplusTime"];
    self.mStatus = [[obj objectForKeyMy:@"status"] intValue];
    self.mTitle = [obj objectForKeyMy:@"title"];
    self.mMoney = [[obj objectForKeyMy:@"money"] floatValue];
    self.mUrl = [obj objectForKeyMy:@"linkUrl"];
    self.mImgUrl = [obj objectForKeyMy:@"image"];
    self.mSort = [[obj objectForKeyMy:@"sort"] intValue];
    self.mBtnName = [obj objectForKeyMy:@"buttonName"];
    self.mEndTime = [[obj objectForKeyMy:@"endTime"] intValue];
    self.mSendType = [[obj objectForKeyMy:@"sendType"] intValue];
    self.mName = [obj objectForKeyMy:@"name"];
    self.mType = [[obj objectForKeyMy:@"type"] intValue];
    self.mId = [[obj objectForKeyMy:@"id"] intValue];
    self.mDetail = [obj objectForKeyMy:@"detail"];
    self.mBtnUrl = [obj objectForKeyMy:@"buttonUrl"];
    self.mSharePromotionNum = [[obj objectForKeyMy:@"sharePromotionNum"] intValue];
    self.mStartTime = [[obj objectForKeyMy:@"startTime"] intValue];
    self.mCreateTime = [[obj objectForKeyMy:@"createTime"] intValue];
    self.mBgImg = [obj objectForKeyMy:@"bgimage"];
    
    
}

@end













