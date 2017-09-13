//
//  forgetViewController.h
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/9/29.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BalanceVC.h"

@interface forgetViewController : BalanceVC
@property (nonatomic,strong) UIViewController *tagVC;

///手机号码
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTx;
///验证吗
@property (weak, nonatomic) IBOutlet UITextField *mCodeTX;
///获取验证码
@property (weak, nonatomic) IBOutlet UIButton *mGetCodeBtn;
///新密码
@property (weak, nonatomic) IBOutlet UITextField *mNewPwdTx;
///登录
@property (weak, nonatomic) IBOutlet UIButton *mLoginBtn;


@property (weak, nonatomic) IBOutlet UIView *mPhontV;

@property (weak, nonatomic) IBOutlet UIView *mCodeV;

@property (weak, nonatomic) IBOutlet UIView *mPwdV;

@end
