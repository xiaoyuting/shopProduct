//
//  PingJiaVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/13.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "PingJiaVC.h"

@interface PingJiaVC (){

    NSArray *btnAry;
    
    int starnum;
}

@end

@implementation PingJiaVC


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
    
    btnAry = @[_mBt1,_mBt2,_mBt3,_mBt4,_mBt5];
    
    self.mPageName = @"评价";
    self.Title = self.mPageName;
    
    self.mTextView.placeholder = @"请输入您要特别说明的事情...";
    self.mTextView.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.608 alpha:1];
    
    _mCommitBT.layer.masksToBounds = YES;
    _mCommitBT.layer.cornerRadius = 5;
    starnum = 1;
    
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

- (IBAction)CommitClick:(id)sender {
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    /*
    [_mtagOrder commentThis:_mGoodsId content:_mTextView.text star:starnum block:^(SResBase *resb) {

        if (resb.msuccess) {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            
            if (_itblock) {
                _itblock(YES);
            }
            [self popViewController];
        }
        else [SVProgressHUD showErrorWithStatus:resb.mmsg];
    }];
     */

}

- (IBAction)mStarClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    int index = (int)btn.tag;
    
    for (int i = 0; i < index; i++) {
        
        UIButton *btnSelect = [btnAry objectAtIndex:i];
        [btnSelect setImage:[UIImage imageNamed:@"hongxing"] forState:UIControlStateNormal];
    }
    
    for (int j = index; j<5; j++) {
        UIButton *btnNoSelect = [btnAry objectAtIndex:j];
        [btnNoSelect setImage:[UIImage imageNamed:@"huixing"] forState:UIControlStateNormal];
    }
    
    starnum = index;
}
@end
