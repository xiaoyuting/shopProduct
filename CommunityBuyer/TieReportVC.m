//
//  TieReportVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "TieReportVC.h"
#import "IQTextView.h"
@interface TieReportVC ()

@end

@implementation TieReportVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mPageName = self.Title = @"举报帖子";
    
    self.mcontenbt.placeholder = @"请输入举报理由,我们会尽快核实...";
    [self.mcontenbt setHolderToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)msubmit:(id)sender {
    
    if( self.mcontenbt.text.length == 0 )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入举报内容"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"举报中..." maskType:SVProgressHUDMaskTypeClear];
    [self.mtagPost reportThis:self.mcontenbt.text block:^(SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
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
