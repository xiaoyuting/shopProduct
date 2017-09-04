//
//  ResigerVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "ResigerVC.h"

@interface ResigerVC ()<UITextFieldDelegate,MZTimerLabelDelegate>{

    UILabel *timer_show;//倒计时label

}

@end

@implementation ResigerVC


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
    
    [super viewDidLoad];
    
    if (_mIsUpdate) {
        self.mPageName = @"修改密码";
        [_mLoginBT setTitle:@"确认" forState:UIControlStateNormal];
    }
    else{
        self.mPageName = @"注册";
        _mNewPwdTF.placeholder = @"请输入密码";
    }
    
    self.Title = self.mPageName;
    
    _mPhoneV.layer.masksToBounds = YES;
    _mPhoneV.layer.cornerRadius = 3;
    _mPhoneV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mPhoneV.layer.borderWidth = 1;
    
    _mCodeV.layer.masksToBounds = YES;
    _mCodeV.layer.cornerRadius = 3;
    _mCodeV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mCodeV.layer.borderWidth = 1;
    
    _mNewPwdV.layer.masksToBounds = YES;
    _mNewPwdV.layer.cornerRadius = 3;
    _mNewPwdV.layer.borderColor = COLOR(218, 218, 215).CGColor;
    _mNewPwdV.layer.borderWidth = 1;
    
    _mCodeBT.layer.masksToBounds = YES;
    _mCodeBT.layer.cornerRadius = 3;
    
    _mLoginBT.layer.masksToBounds = YES;
    _mLoginBT.layer.cornerRadius = 3;
    
    
    [_mPhoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    _mPhoneTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [_mCodeTF setKeyboardType:UIKeyboardTypeNumberPad];
    _mCodeTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    
    _mNewPwdTF.clearButtonMode = UITextFieldViewModeUnlessEditing;

    _mCodeTF.delegate = self;
    _mCodeTF.delegate = self;

    
}

///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制验证码输入长度
#define PASS_LENGHT 6
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==6) {
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


- (IBAction)mEyesClick:(id)sender {
    
    _mNewPwdTF.secureTextEntry = !_mNewPwdTF.secureTextEntry;
}

- (IBAction)GetCodeClick:(id)sender {
    
    if (![Util isMobileNumber:_mPhoneTF.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhoneTF becomeFirstResponder];
        return;
    }
    
    [SUser sendSM:_mPhoneTF.text type:@"reg_check" block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self timeCount];
            [sender setBackgroundImage:[UIImage imageNamed:@"huibutton"] forState:0];
            
            
        }
        else
        {
            [self showErrorStatus:resb.mmsg];
            _mCodeBT.userInteractionEnabled = YES;
              [sender setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];
        }
    }];

}
- (void)timeCount{//倒计时函数
    
    [_mCodeBT setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _mCodeBT.frame.size.width, _mCodeBT.frame.size.height)];//UILabel设置成和UIButton一样的尺寸和位置
    [_mCodeBT addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss秒后重发";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:17.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _mCodeBT.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}
//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_mCodeBT setTitle:@"重发验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    _mCodeBT.userInteractionEnabled = YES;//按钮可以点击
    [_mCodeBT setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];
    
}

- (IBAction)LoginClick:(id)sender {
    
    if (![GInfo shareClient]) {
        //        [self addNotifacationStatus:@"获取配置信息失败,请稍后再试"];
        [_mPhoneTF resignFirstResponder];
        [_mPhoneTF resignFirstResponder];
        MLLog(@"获取配置信息失败,请稍后再试");
        return;
    }
    if (![Util isMobileNumber:_mPhoneTF.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhoneTF becomeFirstResponder];
        return;
    }
    

    if (_mCodeTF.text == nil || [_mCodeTF.text isEqualToString:@""]) {
        [self showErrorStatus:@"验证码不能为空"];
        [_mCodeTF becomeFirstResponder];
        return;
    }
    if (_mCodeTF.text.length > 6){
        [self showErrorStatus:@"验证码输入错误"];
        [_mCodeTF becomeFirstResponder];
        return;
    }
    
    if (_mNewPwdTF.text == nil || [_mNewPwdTF.text isEqualToString:@""]) {
        [self showErrorStatus:@"新密码不能为空"];
        [_mCodeTF becomeFirstResponder];
        return;
    }

    if( !_mIsUpdate )
    {
        [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeClear];
        [SUser regWithPhone:_mPhoneTF.text psw:_mNewPwdTF.text smcode:_mCodeTF.text  block:^(SResBase *resb, SUser *user) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                    [self logOK];
            
                
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
    
    if(self.tagVC )
    {
        NSMutableArray* t = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        [t removeLastObject];
        [t addObject:self.tagVC];
        [self.navigationController setViewControllers:t animated:YES];
    }
    else
    {
        if (_mIsOwn) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            if ([self respondsToSelector:@selector(presentingViewController)]){
                [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
                return;
            }
            else {
                [self.parentViewController.parentViewController dismissModalViewControllerAnimated:YES];
                return;
            }
        }
        
    }
    
    
    
}

- (IBAction)PhoneClick:(id)sender {
//
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"1234567"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    WebVC* vc = [[WebVC alloc]init];
    vc.mName = @"免责声明";
    vc.mUrl = [GInfo shareClient].mProtocolUrl;
    vc.isMode = YES;
    [self presentViewController:vc animated:YES completion:nil];
    
}
@end
