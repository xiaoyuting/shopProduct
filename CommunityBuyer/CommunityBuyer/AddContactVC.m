//
//  AddContactVC.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "AddContactVC.h"

@interface AddContactVC ()

@end

@implementation AddContactVC

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
    
    self.mPageName = @"洗衣洗鞋";
    self.Title = self.mPageName;
    
    _mSubmit.layer.masksToBounds = YES;
    _mSubmit.layer.cornerRadius = 5;
    
    
    [_mPhone setKeyboardType:UIKeyboardTypeNumberPad];
    _mPhone.clearButtonMode = UITextFieldViewModeUnlessEditing;
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

- (IBAction)SubmitClick:(id)sender {
    
    if (_mName.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系人"];
        [_mName becomeFirstResponder];
        return;
    }
    else if (_mPhone.text.length<1)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话"];
        return;
    }
    
    [self.delegate setContactName:_mName.text andPhone:_mPhone.text];
    [self popViewController];
}
@end
