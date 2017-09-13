

#import "APIClient.h"
#import "dateModel.h"
#import "CBCUtil.h"
#import "NSObject+myobj.h"
#import "CustomDefine.h"
#import "Util.h"
#import "sys/utsname.h"
#pragma mark -
#pragma mark APIClient


#define ENC
//static NSString* const  kAFAppDotNetAPIBaseURLString    = @"http://192.168.1.199/buyer/v1/";

//static NSString* const  kAFAppDotNetAPIBaseURLString    = @"http://api.sqtest.vso2o.jikesoft.com/buyer/v1/";
//static NSString* const  kAFAppDotNetAPIBaseURLString    = @"sq.test.o2o.fanwe.cn/buyer/v1/";
static NSString* const  kAFAppDotNetAPIBaseURLString    = @"51mycai365.com/buyer/v1/";




@interface APIClient ()

@end

#pragma mark -

@implementation APIClient
+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:[APIClient APiWithUrl:nil]]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    _sharedClient.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/json",@"text/html",@"charset=UTF-8",@"text/plain",@"application/json",nil];
#ifdef DEBUG
    _sharedClient.requestSerializer.timeoutInterval = 60;
#else
    _sharedClient.requestSerializer.timeoutInterval = 10;
#endif
    
    return _sharedClient;
}

- (void)cancelHttpOpretion:(AFHTTPRequestOperation *)http
{
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        if ([operation isEqual:http]) {
            [operation cancel];
            break;
        }
    }
}


#pragma mark -

/**
 *  Get链接总方法
 *
 *  @param URLString  请求链接
 *  @param parameters 参数
 *  @param callback   返回网络数据
 */
-(NSString*)getCityid
{
    NSString* ss = [SAppInfo shareClient].mSelCity;
    if( ss.length == 0 )
    {
        for (SCity *city  in  [GInfo shareClient].mSupCitys) {
            if (city.mIsDefault) {
                return [NSString stringWithFormat:@"%d",city.mId];
            }
        }
    }
    return [NSString stringWithFormat:@"%d",[SAppInfo shareClient].mCityId];
}
-(NSString*)getmToken
{
    if( [SUser currentUser].mToken.length == 0 )
        return [GInfo shareClient].mGToken;
    return [SUser currentUser].mToken;
}

-(NSString*)getUserId
{
    if( [SUser currentUser].mUserId )
        return [NSString stringWithFormat:@"%d",[SUser currentUser].mUserId];
    return nil;
}


-(void)getUrl:(NSString *)URLString parameters:(id)parameters call:(void (^)(  SResBase* info))callback
{
    assert(@"oh ,,,no...");
    NSMutableDictionary* tparam = NSMutableDictionary.new;
    if( [self getmToken].length == 0 )
    {//如果没有tonken,,那么返回特定的错误
        if( ![URLString isEqualToString:@"app.init"] )
        {
            SResBase* itbase = [SResBase infoWithError:@"获取配置信息失败,正在重新获取"];
            callback( itbase );
            return;
        }
    }
    else
        [tparam setObject:[self getmToken] forKey:@"token"];
    
    if( [self getUserId].length )
    {
        [tparam setObject:[self getUserId] forKey:@"userId"];
    }
    ///这2个参数是带再外面的
    
    if( parameters )//真正的参数需要弄到 Data里面
    {
        NSData* jj = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil
                      ];
        NSString *str = [[NSString alloc] initWithData:jj encoding:NSUTF8StringEncoding];
        [tparam setObject:str forKey:@"data"];
    }
    
    [self GET:URLString parameters:tparam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        MLLog(@"URL%@ data:%@",operation.response.URL,responseObject);
        
        SResBase* retob = [[SResBase alloc]initWithObj:responseObject];
        
        if( retob.mcode == 99996 )
        {//需要登陆
            id oneid = [UIApplication sharedApplication].delegate;
            [oneid performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.4f];
        }
        
        callback(  retob );
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MLLog(@"error:%@",error.description);
        callback( [SResBase infoWithError: @"网络请求错误.."] );
        
    }];
}




/**
 *  Post链接总方法
 *
 *  @param apiType    请求链接
 *  @param parameters 参数
 *  @param callback   返回网络数据
 */
-(void)postUrl:(NSString *)URLString parameters:(id)parameters call:(void (^)(  SResBase* info))callback
{
    BOOL binit = [URLString isEqualToString:@"app.init"];
    NSString* token = [self getmToken];
    
    NSMutableDictionary* tparam = NSMutableDictionary.new;
    if( token.length == 0 )
    {//如果没有tonken,,那么返回特定的错误
        if( !binit )
        {
            SResBase* itbase = [SResBase infoWithError:@"获取配置信息失败,正在重新获取"];
            callback( itbase );
            return;
        }
    }
    else
        [tparam setObject:token forKey:@"token"];
    
    if( [self getUserId].length )
    {
        [tparam setObject:[self getUserId] forKey:@"userId"];
    }
    
    [tparam setObject:[NSString stringWithFormat:@"%.6f,%.6f",[[SAppInfo shareClient] getAppSelectLatOrLocLat],[[SAppInfo shareClient] getAppSelectLngOrLocLng]] forKey:@"mapPoint"];
    
    ///这2个参数是带再外面的
    
    if( parameters )//真正的参数需要弄到 Data里面
    {
    
        NSData* jj = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil
                      ];
        NSString *str = [[NSString alloc] initWithData:jj encoding:NSUTF8StringEncoding];
        
        NSMutableString*  sssss = [NSMutableString stringWithFormat:@"%@%@?",[APIClient APiWithUrl:nil],URLString];
        
        for ( NSString* onekey in ((NSDictionary*)parameters).allKeys ) {
            [sssss appendFormat:@"%@=%@&",onekey,[parameters objectForKey:onekey]];
        }
        [sssss replaceCharactersInRange:NSMakeRange(sssss.length-1, 1) withString:@""];
        
        NSLog(@"request 请求加密前参数：%@",sssss);
        
#ifdef ENC
        if( !binit )
        {
            int iv = [GInfo shareClient].mivint;
            NSString* key = token;//[Util URLDeCode:token];
            NSString* userid = [self getUserId];
            if( userid.length == 0 )
                userid = @"0";
            key = [Util md5:[key stringByAppendingString:userid]];
            
            iv = [Util gettopestV:iv];
            str = [CBCUtil CBCEncrypt:str key:key index:iv];
            if( str == nil )
            {
                SResBase* itbase = [SResBase infoWithError:@"程序处理错误"];
                callback( itbase );
                return;
            }
        }
#endif
        [tparam setObject:str forKey:@"data"];
    }
    
    NSLog(@"request 所有请求参数：%@",tparam);
    
    [self POST:URLString parameters:tparam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
#ifdef ENC
        
        NSString* getnewtoken = [responseObject objectForKeyMy:@"token"];
        int newuserid = [[responseObject objectForKeyMy:@"userId"] intValue];
        NSString* getnewuserid = nil;
        if( newuserid > 0 )
            getnewuserid = [NSString stringWithFormat:@"%d",newuserid];
        
        
        id fuckdata = [responseObject objectForKeyMy:@"data"];
        if( responseObject && fuckdata && [fuckdata isKindOfClass:[NSString class]] )
        {
            NSMutableDictionary* tresb = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
            int ivint = 0;
            NSString* key = @"";
            if( binit )
            {
                NSString* tmpss = [tresb objectForKey:@"key"];
                char keyPtr[10]={0};
                [tmpss getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
                ivint  = (int)strtoul(keyPtr,NULL,24);
                key = [tresb objectForKey:@"token"];//[Util URLDeCode:[tresb objectForKey:@"token"]];
                NSString* userid = @"0";
                
                key = [Util md5:[key stringByAppendingString:userid]];
                
            }
            else
            {
                ivint = [GInfo shareClient].mivint;
                if( getnewtoken == nil )
                    key = [self getmToken];//[Util URLDeCode: [self getmToken]];
                else
                    key = getnewtoken;
                
                NSString* userid = @"0";
                if( getnewuserid == nil )
                    userid = [self getUserId];
                else
                    userid = getnewuserid;
                
                if( userid.length == 0  )
                    userid = @"0";
                key = [Util md5:[key stringByAppendingString:userid]];
            }
            
            ivint = [Util gettopestV:ivint];
            
            NSString* dat = [CBCUtil CBCDecrypt:fuckdata key:key index:ivint];
            
            NSError* jsonerrr = nil;
            id datobj = nil;
            if( dat )
            {
                datobj = [NSJSONSerialization JSONObjectWithData:[dat dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonerrr];
            }
            
            if( datobj || [[tresb objectForKeyMy:@"code"] intValue] == 0)
            {
                if (datobj == nil) {
                    [tresb setObject:@(1) forKey:@"data"];
                }else{
                    [tresb setObject:datobj forKey:@"data"];
                }
                
                
            }
            else
            {
                [tresb setObject:[NSNumber numberWithInt:9997] forKey:@"code"];
                [tresb setObject:@"程序处理有错误." forKey:@"msg"];
                [tresb removeObjectForKey:@"data"];
                NSLog(@"json err:%@",jsonerrr.description);
            }
            responseObject = tresb;
        }
#endif
        
        NSLog(@"URL:%@ data:%@",operation.response.URL,responseObject);
        
        SResBase* retob = [[SResBase alloc]initWithObj:responseObject];
        
        if( retob.mcode == 99996 )
        {//需要登陆
            id oneid = [UIApplication sharedApplication].delegate;
            [oneid performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.4f];
        }
        callback(  retob );
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"url:%@ error:%@",operation.request,error.description);
        callback( [SResBase infoWithError:@"网络请求错误.."] );
        
    }];
}

+ (NSString *)APiWithUrl:(NSString *)mUrl{
    if (mUrl == nil || [mUrl isEqualToString:@""]) {
        mUrl = @"";
    }
    
    NSString *APIUrl = [NSString stringWithFormat:@"http://api.m.%@%@",kAFAppDotNetAPIBaseURLString,mUrl];
    return APIUrl;
    
}
+ (NSString *)wapWithUrl:(NSString *)path{
    if (path == nil || [path isEqualToString:@""]) {
        path = @"";
    }
    NSString *APIUrl = [NSString stringWithFormat:@"http://wap.%@%@",kAFAppDotNetAPIBaseURLString,path];
    return APIUrl;
}

+ (NSString *)NoWapUrl:(NSString *)path{

    if (path == nil || [path isEqualToString:@""]) {
        path = @"";
    }
    NSString *APIUrl = [NSString stringWithFormat:@"http://%@%@",kAFAppDotNetAPIBaseURLString,path];
    return APIUrl;
}



//单独封装ping
- (void)upatePingForUserInfo
{
    NSMutableDictionary* param = NSMutableDictionary.new;

    NSString *deviceType = [APIClient deviceVersion];
    [param setObject:deviceType forKey:@"device_type"];
    [param setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"device_no"];
    [param setObject:[NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]] forKey:@"os_version"];
    
    //    mapPoint 地理位置信息， 例如：31.2123,123.4519  和登陆接口的保存一致
    [param setObject:[NSString stringWithFormat:@"%.6f,%.6f",[[SAppInfo shareClient] getAppSelectLatOrLocLat],[[SAppInfo shareClient] getAppSelectLngOrLocLng]] forKey:@"mapPoint"];
    
    //    userId  登陆的用户ID，没有可以不传，或者传 0
    //    token 如果已经登陆的用户要加上token
    if( [self getmToken].length )
    {
        [param setObject:[self getmToken] forKey:@"token"];
    }

    if( [self getUserId].length )
    {
        [param setObject:[self getUserId] forKey:@"userId"];
    }
    else
    {
       [param setObject:@"0" forKey:@"userId"];
    }
    
    [self postUrl:@"user.ping" parameters:param call:^(SResBase *info) {
        
    }];
//    NSLog(@"上报ping==============================%@",[self getUserId]);
}


//获取设备型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

@end





