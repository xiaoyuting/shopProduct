//
//  loginOne.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/9/29.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "loginOne.h"

@implementation loginOne

+ (loginOne *)shareOne{
    loginOne *view = [[[NSBundle mainBundle]loadNibNamed:@"loginOneView" owner:self options:nil]objectAtIndex:0];
    view.mBgkView1.layer.masksToBounds = YES;
    view.mBgkView1.layer.cornerRadius = 4;
    view.mBgkView1.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    view.mBgkView1.layer.borderWidth = 0.75f;
    
    view.mBgkView2.layer.masksToBounds = YES;
    view.mBgkView2.layer.cornerRadius = 4;
    view.mBgkView2.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    view.mBgkView2.layer.borderWidth = 0.75f;
    
    view.mLoginBtn.layer.masksToBounds = YES;
    view.mLoginBtn.layer.cornerRadius = 4;
    view.mCodeBtn.layer.masksToBounds = YES;
    view.mCodeBtn.layer.cornerRadius = 4;
    
    
    return view;
}

+ (loginOne *)shareTwo{
    loginOne *view = [[[NSBundle mainBundle]loadNibNamed:@"quikLoginView" owner:self options:nil]objectAtIndex:0];
    view.mCodeBtn.titleString = @"获取验证码";
    
    view.mBgkView1.layer.masksToBounds = YES;
    view.mBgkView1.layer.cornerRadius = 4;
    view.mBgkView1.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    view.mBgkView1.layer.borderWidth = 0.75f;
    
    view.mBgkView2.layer.masksToBounds = YES;
    view.mBgkView2.layer.cornerRadius = 4;
    view.mBgkView2.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    view.mBgkView2.layer.borderWidth = 0.75f;
    
    view.mBgkView1.layer.masksToBounds = YES;
    view.mBgkView1.layer.cornerRadius = 4;
    view.mBgkView1.layer.borderColor = [UIColor colorWithRed:0.725 green:0.745 blue:0.765 alpha:1].CGColor;
    view.mBgkView1.layer.borderWidth = 0.75f;
    
    view.mLoginBtn.layer.masksToBounds = YES;
    view.mLoginBtn.layer.cornerRadius = 4;
    view.mCodeBtn.layer.masksToBounds = YES;
    view.mCodeBtn.layer.cornerRadius = 4;
    
    return view;
}

@end
