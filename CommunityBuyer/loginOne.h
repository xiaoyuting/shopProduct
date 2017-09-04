//
//  loginOne.h
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/9/29.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeButton.h"

@interface loginOne : UIView

///背景1
@property (weak, nonatomic) IBOutlet UIView *mBgkView1;
///背景2
@property (weak, nonatomic) IBOutlet UIView *mBgkView2;

///手机输入
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTx;

@property (weak, nonatomic) IBOutlet UITextField *mNPwdTx;

///普通登录
+ (loginOne *)shareOne;


///忘记密码
@property (weak, nonatomic) IBOutlet UIButton *mForgetPwd;

@property (weak, nonatomic) IBOutlet UITextField *mQuikPhone;
///密码／验证码输入
@property (weak, nonatomic) IBOutlet UITextField *mCodeTx;

///快捷登录
+ (loginOne *)shareTwo;

///获取验证吗按钮
@property (weak, nonatomic) IBOutlet CodeButton *mCodeBtn;
///登录按钮
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn;

@end
