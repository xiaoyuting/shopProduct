//
//  AppDelegate.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/6/18.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "AppDelegate.h"
#import "MyInfoVC.h"
#import "OrderVC.h"
#import "dateModel.h"
#import "MTA.h"
#import <QMapKit/QMapKit.h>
#import "WXApi.h"
#import "CBCUtil.h"
#import "APService.h"
#import "WebVC.h"
#import "OrderDetailVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "sys/utsname.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


#import "MessageVC.h"
#import "MainVC.h"
#import "UPPaymentControl.h"



@interface AppDelegate ()<WXApiDelegate>

@end

@interface myalert : UIAlertView

@property (nonatomic,strong) id obj;

@end

@implementation myalert


@end


@implementation AppDelegate




+(AppDelegate *)shareAppDelegate
{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return app;
}
-(void)initExtComp
{
    [MTA startWithAppkey:@"571f2c97e0f55a768b001158"];
    
    [QMapServices sharedServices].apiKey = QQMAPKEY;
    
    [WXApi registerApp:@"wxb7c973759943c44d" withDescription:[Util getAPPName]];
    
 
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"1291dc5ee919a"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeWechatSession)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 
                default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformSubTypeWechatSession:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb7c973759943c44d"
                                       appSecret:@"d6d60ce85a15024c12a3b5d9dc0ac55e"];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb7c973759943c44d"
                                       appSecret:@"d6d60ce85a15024c12a3b5d9dc0ac55e"];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2217555972"
                                           appSecret:@"20f003b696de1469e64ad315f3ca3f96"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105243105"
                                      appKey:@"KEYqQTz8pze5kyfOSlZ"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformSubTypeQQFriend:
                 [appInfo SSDKSetupQQByAppId:@"1105243105"
                                      appKey:@"KEYqQTz8pze5kyfOSlZ"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
    
}


//15123380391
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SAppInfo shareClient] reloadReSet];
    
    [self initExtComp];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    
    [APService setupWithOption:launchOptions];
    
    [SUser relTokenWithPush];
    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"push object :%@",[defaults objectForKey:@"push"]);
    
    if( notificationPayload )
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:notificationPayload forKey:@"push"];
        
        [defaults synchronize];
        
        [self performSelector:@selector(PushController:) withObject:notificationPayload afterDelay:1];
        
        
    }
    
    [[SAppInfo shareClient] getUserLocationQ:YES block:^(NSString *err) {
        
    }];

    NSLog(@"*******************%@",[APIClient deviceVersion]);
    NSLog(@"*******************%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    NSLog(@"*******************%@",[NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]]);
    return YES;
}

- (void)PushController:(NSDictionary *)dic{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"push_Message" object:dic];

}




-(void)gotoLogin
{
    LoginVC* vc = [[LoginVC alloc]init];
    UINavigationController* nownav = (UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController;
    
    UIViewController* vcvc = [nownav topViewController];
    
    if( [vcvc isKindOfClass:[LoginVC class]] )
    {//如果顶层是 LoginVC 就不去了
        
    }
    else
    {
        //这里还处理一个事情,就是退出登陆,,要把无效的token,去除..
        
        [SUser logout];
        [vcvc presentViewController:vc animated:YES completion:nil];
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    MLLog(@"hhhhhhurl:%@",url);
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // url:wx206e0a3244b4e469://pay/?returnKey=&ret=0 withsouce url:com.tencent.xin
    MLLog(@"url:%@ withsouce url:%@",url,sourceApplication);
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
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
        return YES;
    }
    else if( [sourceApplication isEqualToString:@"com.tencent.xin"] )
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"uppayresult"])
    {
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
           
            SResBase* retobj = SResBase.new;

            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //判断签名数据是否存在
                if( data == nil ){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    retobj.msuccess = NO;
                    retobj.mmsg = @"支付出现异常";
                  
                }
                else
                {
                    //数据从NSDictionary转换为NSString
                    NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                       options:0
                                                                         error:nil];
                    NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                    
                    //验签证书同后台验签证书
                    //此处的verify，商户需送去商户后台做验签
                    //if([Util verify:sign]) {
                    if( YES ) {
                        //支付成功且验签成功，展示支付成功提示
                        retobj.msuccess = YES;
                        retobj.mmsg = @"支付成功";
                    }
                    else
                    {
                        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                        retobj.msuccess = NO;
                        retobj.mmsg = @"支付出现异常情况";
                    }
                }
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                retobj.msuccess = NO;
                retobj.mmsg = @"支付失败";
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                retobj.msuccess = NO;
                retobj.mmsg = @"用户取消了支付";
            }
            else
            {
                retobj.msuccess = NO;
                retobj.mmsg = @"支付出现异常";
            }
            
            if( [SAppInfo shareClient].mPayBlock )
            {
                [SAppInfo shareClient].mPayBlock(retobj);
            }
            else
            {
                MLLog(@"may be err no block to back");
            }
            
        }];
        
        return YES;
    }
    return NO;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    
    // url:wx206e0a3244b4e469://pay/?returnKey=&ret=0 withsouce url:com.tencent.xin
//    MLLog(@"url:%@ withsouce url:%@",[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"]);
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
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
        return YES;
    }
    else if( [[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"] )
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"uppayresult"])
    {
        
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            SResBase* retobj = SResBase.new;
            
            //结果code为成功时，先校验签名，校验成功后做后续处理
            if([code isEqualToString:@"success"]) {
                
                //判断签名数据是否存在
                if( data == nil ){
                    //如果没有签名数据，建议商户app后台查询交易结果
                    retobj.msuccess = NO;
                    retobj.mmsg = @"支付出现异常";
                    
                }
                else
                {
                    //数据从NSDictionary转换为NSString
                    NSData *signData = [NSJSONSerialization dataWithJSONObject:data
                                                                       options:0
                                                                         error:nil];
                    NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
                    
                    //验签证书同后台验签证书
                    //此处的verify，商户需送去商户后台做验签
                    //if([Util verify:sign]) {
                    if( YES ) {
                        //支付成功且验签成功，展示支付成功提示
                        retobj.msuccess = YES;
                        retobj.mmsg = @"支付成功";
                    }
                    else
                    {
                        //验签失败，交易结果数据被篡改，商户app后台查询交易结果
                        retobj.msuccess = NO;
                        retobj.mmsg = @"支付出现异常情况";
                    }
                }
            }
            else if([code isEqualToString:@"fail"]) {
                //交易失败
                retobj.msuccess = NO;
                retobj.mmsg = @"支付失败";
            }
            else if([code isEqualToString:@"cancel"]) {
                //交易取消
                retobj.msuccess = NO;
                retobj.mmsg = @"用户取消了支付";
            }
            else
            {
                retobj.msuccess = NO;
                retobj.mmsg = @"支付出现异常";
            }
            
            if( [SAppInfo shareClient].mPayBlock )
            {
                [SAppInfo shareClient].mPayBlock(retobj);
            }
            else
            {
                MLLog(@"may be err no block to back");
            }
            
        }];
        
        return YES;
    }
    return NO;

}

-(void) onResp:(BaseResp*)resp
{
    if( [resp isKindOfClass: [PayResp class]] )
    {
        NSString *strMsg    =   [NSString stringWithFormat:@"errcode:%d errmsg:%@ payinfo:%@", resp.errCode,resp.errStr,((PayResp*)resp).returnKey];
        MLLog(@"payresp:%@",strMsg);
        
        SResBase* retobj = SResBase.new;
        if( resp.errCode == -1 )
        {//
            retobj.msuccess = NO;
            retobj.mmsg = @"支付出现异常";
        }
        else if( resp.errCode == -2 )
        {
            retobj.msuccess = NO;
            retobj.mmsg = @"用户取消了支付";
        }
        else
        {
            retobj.msuccess = YES;
            retobj.mmsg = @"支付成功";
        }
        
        if( [SAppInfo shareClient].mPayBlock )
        {
            [SAppInfo shareClient].mPayBlock(retobj);
        }
        else
        {
            MLLog(@"may be err no block to back");
        }
    }
    else
    {
        MLLog(@"may be err what class one onResp");
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[SAppInfo shareClient]willReload];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[APIClient sharedClient] upatePingForUserInfo];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [application setApplicationIconBadgeNumber:0];
    [APService resetBadge];
    
    if( [[SAppInfo shareClient]canReload] )
    {//如果把程序界面一直停留到首页,按HOME,再打开,这种情况首页的viewwillapper不会被执行的,就需要这边发通知过去
        if( [MainVC IsInMainPage] )
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserGinfoSuccess" object:nil];
        }
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



/*
 sourceApplication:
 
 1.com.tencent.xin
 
 2.com.alipay.safepayclient
 */


-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"reg push err:%@",error);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        
        [self dealPush:userInfo bopenwith:NO];
    }
    else
    {
        [self dealPush:userInfo bopenwith:YES];
    }
}
-(void)dealPush:(NSDictionary*)userinof bopenwith:(BOOL)bopenwith
{
 
    
    SMessageInfo* pushobj = [[SMessageInfo alloc]initWithAPN:userinof];
    
    if( !bopenwith )
    {//当前用户正在APP内部,,
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushnotfi" object:nil];
        
        myalert *alertVC = [[myalert alloc]initWithTitle:@"提示" message:@"有新的消息是否查看?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        alertVC.obj = pushobj;
        [alertVC show];
    }
    else
    {
        [self dealMsg:pushobj];
    }
}






- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        SMessageInfo* pushobj = ((myalert *)alertView).obj;
        [self dealMsg:pushobj];
    }
}

-(void)dealMsg:(SMessageInfo*)obj
{
    //  int "消息类型1：普通消息2：html页面，args为url3：订单消息，args为订单id"
    if( obj.mType == 1 )
    {
     
        /*
        MessageVC *msg = [[MessageVC alloc] init];
        
        [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:msg animated:YES];
         
         */
        WebVC* vc = [[WebVC alloc]init];
        vc.mName = @"系统消息";
        vc.mUrl =  [APIClient APiWithUrl:[NSString stringWithFormat:@"msg.message?token=%@&userId=%d",[SUser currentUser].mToken,[SUser currentUser].mUserId]];
        [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
    }
    else if( obj.mType == 2 )
    {
        WebVC* vc = [[WebVC alloc]init];
        vc.mName = @"详情";
        vc.mUrl = obj.mArgs;
        [(UINavigationController*)((UITabBarController*)self.window.rootViewController).selectedViewController pushViewController:vc animated:YES];
    }
    else if( obj.mType == 3 || obj.mType == 4 )
    {
        [OrderDetailVC gotoOrderDetailWithOrderId:[obj.mArgs intValue] vc:((UINavigationController *)(((UITabBarController*)self.window.rootViewController).selectedViewController)).topViewController];
        
        
    }
    
}



- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    NSLog(@"tag:%@ alias%@ irescod:%d",tags,alias,iResCode);
    if( iResCode == 6002 )
    {
        [SUser relTokenWithPush];
    }
    
}
@end
