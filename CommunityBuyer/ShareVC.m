//
//  ShareVC.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/29.
//  Copyright (c) 2015年 zdq. All rights reserved.
//


#import "ShareVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "APIClient.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"

@interface ShareVC (){


}

@end

@implementation ShareVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.mPageName = @"分享";
    self.Title = self.mPageName;
    [_mImage sd_setImageWithURL:[NSURL URLWithString:[GInfo shareClient].mShareQrCodeImage] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    [[APIClient sharedClient] postUrl:@"useractive.share" parameters:nil call:^(SResBase *info) {
        
        NSLog(@"打印数据类型%@",info.mdata);
        self.shareString = info.mdata[@"shareUrl"];
        self.qrcodeString = info.mdata[@"qrcodeUrl"];
        NSLog(@"------------这是二维码url：%@",self.qrcodeString);
        NSLog(@"------------这是分享链接url：%@",self.shareString);
        [self.mImage sd_setImageWithURL:[NSURL URLWithString:self.qrcodeString]];
        [self gestureForDownloadPic:self.shareString];
    }];
    
   
}

//长按下载二维码
- (void)gestureForDownloadPic:(NSString *)urlString
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(downloadPic:)];
    longPress.minimumPressDuration = 1.5;
    self.mImage.userInteractionEnabled = YES;
    [self.mImage addGestureRecognizer:longPress];
    
}

- (void)downloadPic:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        UIImageWriteToSavedPhotosAlbum(self.mImage.image, self, @selector(image:didFinishSavingWithError: contextInfo:), nil);
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"长按二维码结束！");
        
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"保存成功");
        [SVProgressHUD showSuccessWithStatus:@"二维码已保存至相册"];
        
    } else {
        NSLog(@"保存失败,%@",error);
    }
    
}


//获取网络分享数据并触发分享
- (void)beginToShare:(SSDKPlatformType)platformType
{
    
    [[APIClient sharedClient] postUrl:@"useractive.share" parameters:nil call:^(SResBase *info) {
        
        NSLog(@"打印数据类型%@",info.mdata);
        self.shareString = info.mdata[@"shareUrl"];
        self.qrcodeString = info.mdata[@"qrcodeUrl"];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSArray* imageArray = @[[UIImage imageNamed:@"sharep"]];
        
        if (imageArray) {
            
            [shareParams SSDKSetupShareParamsByText:@"我是你的菜，对你有真爱,下载注册即送优惠券!"
                                             images:imageArray
                                                url:[NSURL URLWithString:self.shareString]
                                              title:@"My菜"
                                               type:SSDKContentTypeWebPage];
            
            //进行分享
            [ShareSDK share:platformType
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
             }];
        }
        
        
    }];
    
}



//新浪微博分享,新浪微博不支持链接，需要单独处理
- (IBAction)ShareXinLang:(id)sender {
    
  
    [[APIClient sharedClient] postUrl:@"useractive.share" parameters:nil call:^(SResBase *info) {
        
        NSLog(@"打印数据类型%@",info.mdata);
        self.shareString = info.mdata[@"shareUrl"];
        self.qrcodeString = info.mdata[@"qrcodeUrl"];
        
        NSString *shareContent = [NSString stringWithFormat:@"我是你的菜，对你有真爱,下载注册即送优惠券:%@",self.shareString];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSArray* imageArray = @[[UIImage imageNamed:@"sharep"]];
        
        if (imageArray) {
            
            [shareParams SSDKSetupShareParamsByText:shareContent
                                             images:imageArray
                                                url:[NSURL URLWithString:self.shareString]
                                              title:@"My菜"
                                               type:SSDKContentTypeAuto];
            
            
            //进行分享
            
            [ShareSDK share:SSDKPlatformTypeSinaWeibo
                 parameters:shareParams
             onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                 
                 
                 
                 switch (state) {
                     case SSDKResponseStateSuccess:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateFail:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                             message:[NSString stringWithFormat:@"%@", error]
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     case SSDKResponseStateCancel:
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                             message:nil
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"确定"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                         break;
                     }
                     default:
                         break;
                 }
             }];
        }
        
        
    }];
}

//微信朋友圈分享
- (IBAction)SharePengyouquan:(id)sender {
    
    [self beginToShare:SSDKPlatformSubTypeWechatTimeline];
}

//微信好友分享
- (IBAction)ShareWeiXin:(id)sender {
    [self beginToShare:SSDKPlatformSubTypeWechatSession];
}


//qq好友分享
- (IBAction)SareQQ:(id)sender {
    
    [self beginToShare:SSDKPlatformSubTypeQQFriend];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
