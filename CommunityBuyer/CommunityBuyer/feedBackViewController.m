//
//  feedBackViewController.m
//  com.yizan.vso2o.business
//
//  Created by 密码为空！ on 15/4/24.
//  Copyright (c) 2015年 zy. All rights reserved.
//

#import "feedBackViewController.h"

@interface feedBackViewController ()

@end

@implementation feedBackViewController

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

    self.mPageName = @"意见反馈";
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.Title = self.mPageName;
    
    
    self.textView.placeholder = @"请输入您的宝贵意见，我们会更加完善的...";
    self.textView.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.608 alpha:1];
    
    self.tijiaoBtn.layer.masksToBounds = YES;
    self.tijiaoBtn.layer.cornerRadius = 3;
    [self.tijiaoBtn addTarget:self action:@selector(tijiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    
    [self.textView setHolderToTop];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tijiaoAction:(UIButton *)sender{
///提交按钮
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        [self showAlertVC:@"提示" alertMsg:@"您未输入任何信息!"];
        return;
    }
    if (self.textView.text.length >= 2000) {
        [self showAlertVC:@"提示" alertMsg:@"内容长度不能超过2000个字符"];
        return;
    }
    else{
        [self showWithStatus:@"正在提交。。。"];
        [SAppInfo feedback:self.textView.text block:^(SResBase *resb) {
            if (!resb.msuccess) {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];

            }
            else{
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                [self dismiss];
                [self popViewController];
            }
        }];
    }
}

- (void)showAlertVC:(NSString *)title alertMsg:(NSString *)message{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

@end
