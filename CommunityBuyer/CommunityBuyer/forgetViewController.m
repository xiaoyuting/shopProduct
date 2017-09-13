//
//  forgetViewController.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/9/29.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "forgetViewController.h"

@interface forgetViewController ()<UITextFieldDelegate,MZTimerLabelDelegate>

@end

@implementation forgetViewController{
    UILabel *timer_show;//倒计时label

    
}
-(void)loadView
{
    [super loadView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.Title = self.mPageName = @"忘记密码";

    
    _mPhontV.layer.masksToBounds = YES;
    _mPhontV.layer.cornerRadius = 3;
    _mPhontV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mPhontV.layer.borderWidth = 1;
    
    _mCodeV.layer.masksToBounds = YES;
    _mCodeV.layer.cornerRadius = 3;
    _mCodeV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mCodeV.layer.borderWidth = 1;
    
    _mPwdV.layer.masksToBounds = YES;
    _mPwdV.layer.cornerRadius = 3;
    _mPwdV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mPwdV.layer.borderWidth = 1;
    
    _mGetCodeBtn.layer.masksToBounds = YES;
    _mGetCodeBtn.layer.cornerRadius = 3;
    
    
    _mLoginBtn.layer.masksToBounds = YES;
    _mLoginBtn.layer.cornerRadius = 3;
    
    
    [_mPhoneTx setKeyboardType:UIKeyboardTypeNumberPad];
    _mPhoneTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [_mCodeTX setKeyboardType:UIKeyboardTypeNumberPad];
    _mCodeTX.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    _mCodeTX.delegate = self;
    _mPhoneTx.delegate = self;
    _mNewPwdTx.delegate = self;

    [_mLoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mGetCodeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark----登录
- (void)loginAction:(UIButton *)sender{

    if (![Util isMobileNumber:_mPhoneTx.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhoneTx becomeFirstResponder];
        return;
    }
    if (_mCodeTX.text == nil || [_mCodeTX.text isEqualToString:@""]) {
        [self showErrorStatus:@"验证码不能为空"];
        [_mCodeTX becomeFirstResponder];
        return;
    }
    if (_mCodeTX.text.length > 6){
        [self showErrorStatus:@"验证码输入错误"];
        [_mCodeTX becomeFirstResponder];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
    [SUser reSetPswWithPhone:_mPhoneTx.text newpsw:_mNewPwdTx.text smcode:_mCodeTX.text block:^(SResBase *resb, SUser *user) {
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            [self logOK];
            if ([self respondsToSelector:@selector(presentingViewController)]){
                [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
                return;
            }
            else {
                [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
                return;
            }
            
            
        }
        else
        {
            [self showErrorStatus:resb.mmsg];
        }
    }];
}
-(void)logOK
{
    
    if(self.tagVC )
    {
        NSMutableArray* t = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        [t removeLastObject];
        [t addObject:self.tagVC];
        [self.navigationController setViewControllers:t animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}

#pragma mark----获取验证吗
- (void)getCodeAction:(UIButton *)sender{
    _mGetCodeBtn.userInteractionEnabled = NO;
    if (![Util isMobileNumber:_mPhoneTx.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhoneTx becomeFirstResponder];

        return;
    }
    else{
        [SUser sendSM:_mPhoneTx.text type:nil block:^(SResBase *resb) {
            if (resb.msuccess) {
                [self timeCount];

                [sender setBackgroundImage:[UIImage imageNamed:@"huibutton"] forState:0];

            }
            else
            {
                [self showErrorStatus:resb.mmsg];
                _mGetCodeBtn.userInteractionEnabled = YES;
                [sender setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];

            }
        }];

    }
    
}
- (void)timeCount{//倒计时函数
    
    [_mGetCodeBtn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mGetCodeBtn.frame.size.width, _mGetCodeBtn.frame.size.height)];//UILabel设置成和UIButton一样的尺寸和位置
    [_mGetCodeBtn addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss秒后重发";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:17.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _mGetCodeBtn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}
//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_mGetCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    _mGetCodeBtn.userInteractionEnabled = YES;//按钮可以点击
    [_mGetCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制验证码输入长度
#define PASS_LENGHT 20
#define CODE_LENGHT 6

#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==6) {
        res= CODE_LENGHT-[new length];
        
        
    }
    if (textField.tag==20) {
        res= PASS_LENGHT-[new length];
        
        
    }else
    {
        res= TEXT_MAXLENGTH-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

- (void)leftBtnTouched:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
