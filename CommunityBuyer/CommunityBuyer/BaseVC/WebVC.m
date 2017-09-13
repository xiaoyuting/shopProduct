//
//  WebVC.m
//  YiZanService
//
//  Created by zzl on 15/3/29.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "WebVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "OrderDetailVC.h"
@interface WebVC ()<UIWebViewDelegate>

@end

@implementation WebVC
{
    UIWebView* itwebview;
    JSContext *context ;
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    self.mPageName = @"WEB浏览";
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.Title = self.mName;
    itwebview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_Width, DEVICE_InNavBar_Height)];
    [self.view addSubview:itwebview];
    
    if( _itblock )
    {
        self.rightBtnTitle = @"完成";
    }
    
    itwebview.delegate = self;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [itwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mUrl]]];
    
   
    
}
-(void)rightBtnTouched:(id)sender
{
    if( self.itblock )
    {
        NSString* retobj  = [itwebview stringByEvaluatingJavaScriptFromString:@"getMapPos()"];
        
        NSError* jsonerrr = nil;
        NSDictionary* datobj = [NSJSONSerialization JSONObjectWithData:[retobj dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonerrr];
        
        NSString* addr = [datobj objectForKey:@"address"];
        NSString* points = [datobj objectForKey:@"mapPos"];
        NSString    *mapPoint = [datobj objectForKey:@"mapPoint"];
        if( points.length == 0 )
        {
            [SVProgressHUD showErrorWithStatus:@"请先设置范围"];
            return;
        }
        
        self.itblock( addr,points ,mapPoint);
        [self leftBtnTouched:nil];

    }
}
-(void)dealloc
{
    context = nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    context = [itwebview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
  
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    __weak WebVC* selfref =self;
    
    context[@"callmsgnative"] = ^( ) {
        
        NSArray *args = [JSContext currentArguments];

        int orderid = -1;
        
        for (JSValue *jsVal in args) {
            orderid = [[jsVal toNumber] intValue];
        }
        if( orderid == -1 )
        {
            [SVProgressHUD showErrorWithStatus:@"程序出现异常,请稍后再试"];
        }
        else
        {
            [OrderDetailVC gotoOrderDetailWithOrderId:orderid vc:selfref];
        }
    };
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.description];
}

- (void)leftBtnTouched:(id)sender{

    if (_isMode) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super leftBtnTouched:sender];
    }
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
