//
//  LoginVC.m
//  YiZanService
//
//  Created by ljg on 15-3-20.
//  Copyright (c) 2015年 zywl. All rights reserved.
//

#import "LoginVC.h"
#import "ResigerVC.h"
#import "NavC.h"

#import "loginOne.h"
#import "forgetViewController.h"
@interface LoginVC ()<UITextFieldDelegate,MZTimerLabelDelegate>
{

    loginOne *mNormalLogin;
    
    loginOne *mQuikLogin;
    
    UIView *mTopView;
    UIButton *tempBtn;
    
    int mType;
    
    UILabel *timer_show;//倒计时label

}
@end

@implementation LoginVC
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
    
    if (_isPwd) {
        self.hiddenBackBtn = NO;
    }else{
        self.hiddenBackBtn = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}





- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.phoneV.hidden = YES;
    self.codeV.hidden = YES;
    self.f.hidden = YES;
    self.d.hidden = YES;
    self.loginBT.hidden = YES;
    self.navBar.rightBtn.hidden = NO;
    self.rightBtnTitle = @"注册";
    
    self.mPageName = @"登录";
    
    self.Title = self.mPageName;
    
    _phoneV.layer.masksToBounds = YES;
    _phoneV.layer.cornerRadius = 3;
    _phoneV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _phoneV.layer.borderWidth = 1;
    _codeV.layer.masksToBounds = YES;
    _codeV.layer.cornerRadius = 3;
    _codeV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _codeV.layer.borderWidth = 1;
    
    _getCodeBT.layer.masksToBounds = YES;
    _getCodeBT.layer.cornerRadius = 3;
    
    
    _loginBT.layer.masksToBounds = YES;
    _loginBT.layer.cornerRadius = 3;
    
    
    [_phoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    _phoneTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [_codeTF setKeyboardType:UIKeyboardTypeNumberPad];
    _codeTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _phoneTF.delegate = self;
    _codeTF.delegate = self;

    [_phoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.statementLB.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(announceBtnTouched:)];
    [self.statementLB addGestureRecognizer:tap];

    
    if (_isPwd) {
        self.navBar.rightBtn.hidden = NO;
    }else{
        self.mPageName = @"重置密码";
        self.Title = self.mPageName;
    }
    mType = 1;
    [self loadTopView];
}
#pragma mark----初始化顶部2个按钮
-(void)loadTopView
{
    mTopView = [UIView new];
    mTopView.frame = CGRectMake(0, 64, DEVICE_Width, 50);
    mTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mTopView];
    
    float x = 0;
    for (int i =0; i<2; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, 0, DEVICE_Width/2, 50)];
        [btn setTitle:@"普通登录" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:M_BGCO];

        [mTopView addSubview:btn];
        if (i==0) {
            tempBtn = btn;
        }
        else
        {
            [btn setTitle:@"短信快捷登录" forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            
        }
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(topbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        x+=DEVICE_Width/2;
    }
    [self initLoginView];

    
}

-(void)topbtnTouched:(UIButton *)sender
{
    [mNormalLogin.mPhoneTx resignFirstResponder];
    [mNormalLogin.mNPwdTx resignFirstResponder];
    [mQuikLogin.mCodeTx resignFirstResponder];
    [mQuikLogin.mQuikPhone resignFirstResponder];
    
    if (tempBtn == sender&&sender.tag !=12) {
        return;
    }
    else
    {
        if (sender.tag ==10) {
            NSLog(@"left");
            mNormalLogin.hidden = NO;
            mQuikLogin.hidden = YES;
            mType = 1;
            
        }
        else
        {
            NSLog(@"right");
            mNormalLogin.hidden = YES;
            mQuikLogin.hidden = NO;
            mType = 2;

        }
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tempBtn setTitleColor:M_TCO forState:UIControlStateNormal];
        
        [tempBtn setBackgroundColor:[UIColor whiteColor]];
        [sender setBackgroundColor:M_BGCO];

        tempBtn = sender;
        
    }
    
}

- (void)initLoginView{
    mNormalLogin = [loginOne shareOne];
    mNormalLogin.mPhoneTx.delegate = self;
    mNormalLogin.mNPwdTx.delegate = self;
    mNormalLogin.mPhoneTx.keyboardType = UIKeyboardTypeNumberPad;
    mNormalLogin.hidden = NO;
    
    mNormalLogin.mNPwdTx.secureTextEntry = YES;
//    mNormalLogin.mPhoneTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    mNormalLogin.mCodeTx.clearButtonMode = UITextFieldViewModeUnlessEditing;

    mNormalLogin.frame = CGRectMake(0, mTopView.frame.origin.y+mTopView.frame.size.height, DEVICE_Width, 241);
    [mNormalLogin.mForgetPwd addTarget:self action:@selector(notCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [mNormalLogin.mLoginBtn addTarget:self action:@selector(mNormalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mNormalLogin];
    
    mQuikLogin = [loginOne shareTwo];
    mQuikLogin.mQuikPhone.delegate = self;
    mQuikLogin.mCodeTx.delegate = self;

    mQuikLogin.mQuikPhone.keyboardType = UIKeyboardTypeNumberPad;
    mQuikLogin.mCodeTx.keyboardType = UIKeyboardTypeNumberPad;
    
    mQuikLogin.hidden = YES;
//    mQuikLogin.mPhoneTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    mQuikLogin.mCodeTx.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [mQuikLogin.mCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    mQuikLogin.frame = CGRectMake(0, mTopView.frame.origin.y+mTopView.frame.size.height, DEVICE_Width, 196);
    [mQuikLogin.mLoginBtn addTarget:self action:@selector(mQuikAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mQuikLogin];
}
#pragma mark----普通登录
- (void)mNormalAction:(UIButton *)sender{
    [self initLoginAction];
}
#pragma mark----快捷登录
- (void)mQuikAction:(UIButton *)sender{
    [self initLoginAction];

}

- (void)initLoginAction{
    
    
    [mNormalLogin.mPhoneTx resignFirstResponder];
    [mNormalLogin.mNPwdTx resignFirstResponder];
    [mQuikLogin.mCodeTx resignFirstResponder];
    [mQuikLogin.mQuikPhone resignFirstResponder];
    
    
    if (![GInfo shareClient]) {
        //        [self addNotifacationStatus:@"获取配置信息失败,请稍后再试"];
        [mNormalLogin.mPhoneTx resignFirstResponder];
        [mNormalLogin.mNPwdTx resignFirstResponder];
        [mQuikLogin.mCodeTx resignFirstResponder];
        [mQuikLogin.mQuikPhone resignFirstResponder];
        MLLog(@"获取配置信息失败,请稍后再试");
         [self showErrorStatus:@"获取配置信息失败,请稍后再试"];
        
        return;
    }


    
    
    if (mType == 1) {
        if (![Util isMobileNumber:mNormalLogin.mPhoneTx.text]) {
            [self showErrorStatus:@"请输入合法的手机号码"];
//            [mNormalLogin.mPhoneTx becomeFirstResponder];
            return;
        }
        if (mNormalLogin.mNPwdTx.text == nil || [mNormalLogin.mNPwdTx.text isEqualToString:@""]) {
            [self showErrorStatus:@"密码不能为空"];
//            [mNormalLogin.mNPwdTx becomeFirstResponder];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
        
        [SUser loginWithPhone:mNormalLogin.mPhoneTx.text psw:mNormalLogin.mNPwdTx.text vcode:nil block:^(SResBase *resb, SUser *user) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self logOK];
                }];
                
            }
            else
            {
                [self showErrorStatus:resb.mmsg];
            }
        }];
        
    }else{
        
        if (![Util isMobileNumber:mQuikLogin.mQuikPhone.text]) {
            [self showErrorStatus:@"请输入合法的手机号码"];
//            [mQuikLogin.mQuikPhone becomeFirstResponder];
            return;
        }
        if (mQuikLogin.mCodeTx.text == nil || [mQuikLogin.mCodeTx.text isEqualToString:@""]) {
            [self showErrorStatus:@"验证码不能为空"];
//            [mQuikLogin.mCodeTx becomeFirstResponder];
            return;
        }
        if (mQuikLogin.mCodeTx.text.length > 6){
            [self showErrorStatus:@"验证码输入错误"];
            [mQuikLogin.mCodeTx becomeFirstResponder];
            return;
        }
        
        
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
        [SUser loginWithPhone:mQuikLogin.mQuikPhone.text psw:nil vcode:mQuikLogin.mCodeTx.text block:^(SResBase *resb, SUser *user) {
            
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self logOK];
                }];
                
            }
            else
            {
                [self showErrorStatus:resb.mmsg];
            }
        }];
        
    }
}

-(void)logOK
{

    if (_mViewController) {
        
        ((NavC *)_mViewController).TabBar.selectedIndex = [(NavC *)_mViewController indexOfTab];
        
        NSLog(@"%@",((NavC *)_mViewController).TabBar);
    }
    
    [[SUser currentUser] haveNewMsg:^(int newMsgCount, int cartGoodsCount, int collectCount, int addressCount,int procount) {
        
        if ([SUser isNeedLogin]) {
            
        }else{
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
            if(cartGoodsCount>0)
                item.badgeValue = [NSString stringWithFormat:@"%d",cartGoodsCount];
            else
                item.badgeValue = nil;
            
            UITabBarItem *item2 = [self.tabBarController.tabBar.items objectAtIndex:3];
            if (newMsgCount>0)
                item2.badgeValue = [NSString stringWithFormat:@"%d",newMsgCount];
            else
                item2.badgeValue = nil;
        }
    }];
    
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

-(void)announceBtnTouched:(id)sender
{
    
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"免责声明";
    vc.mUrl = [GInfo shareClient].mProtocolUrl;
    vc.isMode = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

//获取验证码
- (IBAction)getCodeClick:(id)sender {
    
    [mNormalLogin.mPhoneTx resignFirstResponder];
    [mNormalLogin.mNPwdTx resignFirstResponder];
    [mQuikLogin.mCodeTx resignFirstResponder];
    [mQuikLogin.mQuikPhone resignFirstResponder];
    
    if (![Util isMobileNumber:mQuikLogin.mQuikPhone.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
//        [mQuikLogin.mQuikPhone becomeFirstResponder];
        return;
    }
    [SUser sendSM:mQuikLogin.mQuikPhone.text type:nil block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self timeCount];
            [sender setBackgroundImage:[UIImage imageNamed:@"huibutton"] forState:0];

        }
        else
        {
            [self showErrorStatus:resb.mmsg];
            mQuikLogin.mCodeBtn.userInteractionEnabled = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];

        }
    }];
    
}
- (void)timeCount{//倒计时函数
    
    [mQuikLogin.mCodeBtn setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mQuikLogin.mCodeBtn.frame.size.width, mQuikLogin.mCodeBtn.frame.size.height)];//UILabel设置成和UIButton一样的尺寸和位置
    [mQuikLogin.mCodeBtn addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss秒后重发";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:17.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    mQuikLogin.mCodeBtn.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}
//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [mQuikLogin.mCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    mQuikLogin.mCodeBtn.userInteractionEnabled = YES;//按钮可以点击
    [mQuikLogin.mCodeBtn setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];
    
}

- (IBAction)notCodeClick:(id)sender {
        
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    forgetViewController *f = [storyboard instantiateViewControllerWithIdentifier:@"forget"];
    
    [self presentViewController:f animated:YES completion:nil];

    
    
}

//登录
- (IBAction)loginClick:(id)sender {
    
    [mNormalLogin.mPhoneTx resignFirstResponder];
    [mNormalLogin.mNPwdTx resignFirstResponder];
    [mQuikLogin.mCodeTx resignFirstResponder];
    [mQuikLogin.mQuikPhone resignFirstResponder];

    
    if (![GInfo shareClient]) {
        //        [self addNotifacationStatus:@"获取配置信息失败,请稍后再试"];
//        [_phoneTF resignFirstResponder];
//        [_codeTF resignFirstResponder];
        MLLog(@"获取配置信息失败,请稍后再试");
        return;
    }
    if (![Util isMobileNumber:_phoneTF.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
//        [_phoneTF becomeFirstResponder];
        return;
    }
    
    
    if (_isPwd) {
        
        if (_mPwd.text == nil || [_mPwd.text isEqualToString:@""]) {
            [self showErrorStatus:@"密码不能为空"];
//            [_codeTF becomeFirstResponder];
            return;
        }
        
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
        
        [SUser loginWithPhone:_phoneTF.text psw:_mPwd.text vcode:nil block:^(SResBase *resb, SUser *user) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self logOK];
                }];

            }
            else
            {
                [self showErrorStatus:resb.mmsg];
            }
        }];

    }else{
    
    }
    
}

- (void)rightBtnTouched:(id)sender{
    [self RegisterClick:nil];
}
- (IBAction)RegisterClick:(id)sender {
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ResigerVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"ResigerVC"];
    viewController.tagVC = _tagVC;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)CallPhoneClick:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)leftBtnTouched:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
