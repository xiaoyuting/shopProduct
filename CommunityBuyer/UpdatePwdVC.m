//
//  UpdatePwdVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "UpdatePwdVC.h"

@interface UpdatePwdVC ()

@end

@implementation UpdatePwdVC

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
    
    self.mPageName = @"修改密码";
    self.Title = self.mPageName;
    
    _mSubmitBT.layer.masksToBounds = YES;
    _mSubmitBT.layer.cornerRadius = 5;
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

- (IBAction)mSubmitBT:(id)sender {
    
    if (_mOldPwd.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入原密码"];
        return;
    }
    if (_mNewPwd.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    
    if (_mNewPwdTwo.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入新密码"];
        return;
    }
    
    if (_mNewPwd.text.length< 6 || _mNewPwd.text.length>20 || _mOldPwd.text.length< 6 || _mOldPwd.text.length>20 || _mNewPwdTwo.text.length< 6 || _mNewPwdTwo.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"密码长度6-20位"];
        return;
    }
    
    if (![_mNewPwd.text isEqualToString:_mNewPwdTwo.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [SUser UpdatePwd:_mOldPwd.text newPwd:_mNewPwd.text block:^(SResBase *resb, SUser *user) {
        
        if (resb.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self popViewController];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
}


@end
