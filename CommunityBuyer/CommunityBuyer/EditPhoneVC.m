//
//  EditPhoneVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/12.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "EditPhoneVC.h"

@interface EditPhoneVC ()

@end

@implementation EditPhoneVC

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
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"电话编辑";
    self.Title = self.mPageName;
    
    _mButton.layer.masksToBounds = YES;
    _mButton.layer.cornerRadius = 4;
    
    [_mPhoneTF setKeyboardType:UIKeyboardTypeNumberPad];
    _mPhoneTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
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

- (IBAction)BottonClick:(id)sender {
    
    if (![Util isMobileNumber:_mPhoneTF.text]) {
        [self showErrorStatus:@"请输入合法的手机号码"];
        [_mPhoneTF becomeFirstResponder];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"操作中"];
    /*
    [[SUser currentUser] addMobile:_mPhoneTF.text block:^(SResBase *resb) {
        
        if (resb.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
            if (_itblock) {
                _itblock(YES);
            }
            
            [self popViewController];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }

    }];
     */
}
@end
