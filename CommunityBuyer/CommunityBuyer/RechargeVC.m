//
//  RechargeVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "RechargeVC.h"
#import "dateModel.h"
@interface RechargeVC (){
    NSString *payType;
    UIButton *btn;
}

@end

@implementation RechargeVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"充值";
    self.Title = self.mPageName;
    
    [self loadPayView];
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




- (void)loadPayView{
    
    float height = 0;
    
    //    UIView *contentView = [[UIView alloc] init];
    //    contentView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < [GInfo shareClient].mPayment.count; i++) {
        
        SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:i];
        if( [payment.mName isEqualToString:@"余额支付"] )
        {
            continue;
        }
        if( [payment.mName isEqualToString:@"货到付款"] )
        {
            continue;
        }
        UIButton *wxBT = [[UIButton alloc] initWithFrame:CGRectMake(0, height, DEVICE_Width, 55)];
        [_mPayView addSubview:wxBT];
        wxBT.tag = i;
        [wxBT addTarget:self action:@selector(choosePayClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 39, 39)];
        [imgV1 sd_setImageWithURL:[NSURL URLWithString:payment.mIconName] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        [wxBT addSubview:imgV1];
        
        UILabel *wxLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+10, 0, 200, 55)];
        wxLB.text = payment.mName;
        wxLB.textColor = COLOR(72, 63, 69);
        [wxBT addSubview:wxLB];
        
        UIImageView * checkIV2 = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_Width-47, 14, 27, 27)];
        checkIV2.tag = 100;
        [wxBT addSubview:checkIV2];
        if (payment.mDefault) {
            checkIV2.image = [UIImage imageNamed:@"quanhong"];
            payType = payment.mCode;
            btn = wxBT;
        }else{
            checkIV2.image = [UIImage imageNamed:@"quan"];
        }
        
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wxBT.frame), DEVICE_Width-10, 0.5)];
        line2.backgroundColor = COLOR(208, 206, 204);
        [_mPayView addSubview:line2];
        
        
        height = CGRectGetMaxY(line2.frame);
        
    }
    
    _mheight.constant = height;
    
    _mPatbtn.layer.cornerRadius = 3;
    
    
    }

- (void)choosePayClick:(id)sender {
    
    UIButton *btnn = sender;
    for (UIImageView *imgV in [btn subviews]) {
        
        if ([imgV isKindOfClass:[UIImageView class]] ) {
            
            if (imgV.tag == 100) {
                imgV.image = [UIImage imageNamed:@"quan"];
            }
            
        }
    }
    
    for (UIImageView *imgV in [btnn subviews]) {
        
        if ([imgV isKindOfClass:[UIImageView class]] ) {
            
            if (imgV.tag == 100) {
                imgV.image = [UIImage imageNamed:@"quanhong"];
            }
            
        }
    }
    
    
    
    SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:btnn.tag];
    payType = payment.mCode;
    
    btn = btnn;
}





- (IBAction)goRecharge:(id)sender {
    
    
    
    if ([self.mMoney.text doubleValue]<=0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入正确金额"];

        return;
    }
    
    if ([payType isEqualToString:@""]) {
        return;
    }
    
    double money=[self.mMoney.text doubleValue];
    
    SOrderObj  *pay=SOrderObj.new;
    
    
    [SVProgressHUD showWithStatus:@"正在支付..." maskType:SVProgressHUDMaskTypeNone];
    
    [pay payIt:money paytype:payType vc:self block:^(SResBase* resb){
    

        if (resb.msuccess) {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [self leftBtnTouched:nil];
            NSLog(@"成功");
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            
        }
        
        
    }];
    
    
    
}
@end
