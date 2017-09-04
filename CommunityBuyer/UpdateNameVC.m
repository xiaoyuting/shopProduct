//
//  UpdateNameVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/12/14.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "UpdateNameVC.h"

@interface UpdateNameVC ()

@end

@implementation UpdateNameVC

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
    
    self.mPageName = @"我的账号";
    self.Title = self.mPageName;
    
    _mSubmitBT.layer.masksToBounds = YES;
    _mSubmitBT.layer.cornerRadius = 3;
    
    _mName.text = [SUser currentUser].mUserName;
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

- (IBAction)mSubmitClick:(id)sender {
    
    
    if (_mName.text.length<2 || _mName.text.length>20) {
        [SVProgressHUD showErrorWithStatus:@"呢称长度为2-20个字符"];
    }
    
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser] updateUserInfo:_mName.text HeadImg:nil block:^(SResBase *resb) {
        if (resb.msuccess) {
            [self showSuccessStatus:@"保存成功"];
            [self popViewController];
        }else
        {
            [self showErrorStatus:resb.mmsg];
        }
    }];
    
    
}
@end
