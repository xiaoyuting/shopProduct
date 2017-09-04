//
//  UpdatePhoneVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "UpdatePhoneVC.h"
#import "UpdatePhoneTwoVC.h"

@interface UpdatePhoneVC ()<MZTimerLabelDelegate>{

    UILabel *timer_show;//倒计时label
}

@end

@implementation UpdatePhoneVC

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
    
    self.mPageName = @"换绑手机号码";
    self.Title = self.mPageName;
    
    _mNextBT.layer.masksToBounds = YES;
    _mNextBT.layer.cornerRadius = 5;
    
    _mPhone.text = [SUser currentUser].mPhone;
    
    //[self mGetCodeClick:nil];
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

- (IBAction)mGetCodeClick:(id)sender {
    
    _mCodeBT.userInteractionEnabled = NO;
    
    if (![Util isMobileNumber:_mPhone.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhone becomeFirstResponder];
        _mCodeBT.userInteractionEnabled = YES;
        return;
    }

    [SUser sendSM:[SUser currentUser].mPhone type:nil block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self timeCount];
            [_mCodeBT setBackgroundImage:[UIImage imageNamed:@"huibutton"] forState:0];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            _mCodeBT.userInteractionEnabled = YES;
            [_mCodeBT setBackgroundImage:[UIImage imageNamed:@"btn_duan"] forState:0];
            
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



- (IBAction)mNextClick:(id)sender {
    
    if (_mCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [SUser EverifyMobile:[SUser currentUser].mPhone verifyCode:_mCode.text block:^(SResBase *resb, BOOL flag) {
        if (resb.msuccess) {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            UpdatePhoneTwoVC *up = [[UpdatePhoneTwoVC alloc] initWithNibName:@"UpdatePhoneTwoVC" bundle:nil];
            [self pushViewController:up];
        }else{
        
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
}



@end
