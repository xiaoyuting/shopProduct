//
//  OrderPay.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/22.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "OrderPay.h"
#import "OrderDetailVC.h"

@interface OrderPay (){

    UIButton *btn;
    
    
    int num;
    float yue;
    UILabel *yueLB;
    NSString *payType;
}

@end

@implementation OrderPay

- (void)viewWillAppear:(BOOL)animated{

    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    yue = 0;
    num = 0;
    payType = @"";
    self.mPageName = @"下单支付";
    self.Title = self.mPageName;
    
   
//    _mPrice.text = [NSString stringWithFormat:@"¥%.2f元",_mTempOrder.mTotalFee];
    
    [self layoutUI];
}

- (void)layoutUI{
    
    BOOL ali = [[GInfo shareClient] geAiPayInfo] != nil;
    BOOL wx = [[GInfo shareClient] geWxPayInfo] != nil;
    
    float height = 0;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DEVICE_Width-10, 45)];
    lab.text = @"支付方式";
    lab.textColor = COLOR(107, 108, 109);
    [contentView addSubview:lab];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab.frame), DEVICE_Width, 0.5)];
    line.backgroundColor = COLOR(208, 206, 204);
    [contentView addSubview:line];
    height = CGRectGetMaxY(line.frame);
    
    for (int i = 0; i < [GInfo shareClient].mPayment.count; i++) {
        
        SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:i];
        
        UIButton *wxBT = [[UIButton alloc] initWithFrame:CGRectMake(0, height, DEVICE_Width, 55)];
        [contentView addSubview:wxBT];
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
            checkIV2.image = [UIImage imageNamed:@"coupon_lvquan"];
            payType = payment.mCode;
            btn = wxBT;
        }else{
            checkIV2.image = [UIImage imageNamed:@"coupon_quan"];
        }
        
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wxBT.frame), DEVICE_Width-10, 0.5)];
        line2.backgroundColor = COLOR(208, 206, 204);
        [contentView addSubview:line2];
        
        
        height = CGRectGetMaxY(line2.frame);

    }
    
    UIButton *payBT = [[UIButton alloc] initWithFrame:CGRectMake(20, height+20, (DEVICE_Width-40), 45)];
    [payBT setTitle:@"确认支付" forState:UIControlStateNormal];
    [payBT setBackgroundColor:COLOR(67 , 161, 243)];
    [payBT addTarget:self action:@selector(paylAction:) forControlEvents:UIControlEventTouchUpInside];
    payBT.layer.masksToBounds = YES;
    payBT.layer.cornerRadius = 3;
    [contentView addSubview:payBT];
    
    height = CGRectGetMaxY(payBT.frame)+20;
    
    contentView.frame = CGRectMake(0, CGRectGetMaxY(_mTopView.frame)+20, DEVICE_Width, height);
    [self.view addSubview:contentView];
    
}

- (void)paylAction:(UIButton *)sender{
    
    
    if ([payType isEqualToString:@""]) {
        return;
    }
//    [SVProgressHUD showWithStatus:@"正在支付..." maskType:SVProgressHUDMaskTypeNone];
    /*
    [_mTempOrder payIt:payType block:^(SResBase *retobj) {
        
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [self performSelector:@selector(payOk) withObject:nil afterDelay:0.75f];
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
*/
    
}

-(void)payOk
{

    OrderDetailVC *viewController = [[OrderDetailVC alloc] initWithNibName:@"OrderDetailView" bundle:nil];
   // viewController.mTagOrder = _mTempOrder;
    [self pushViewController:viewController];
}


- (void)choosePayClick:(id)sender {
    
    UIButton *btnn = sender;
    for (UIImageView *imgV in [btn subviews]) {
        
        if ([imgV isKindOfClass:[UIImageView class]] ) {
            
            if (imgV.tag == 100) {
                imgV.image = [UIImage imageNamed:@"coupon_quan"];
            }
            
        }
    }
    
    for (UIImageView *imgV in [btnn subviews]) {
        
        if ([imgV isKindOfClass:[UIImageView class]] ) {
            
            if (imgV.tag == 100) {
                imgV.image = [UIImage imageNamed:@"coupon_lvquan"];
            }
            
        }
    }
    
    
    
    SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:btnn.tag];
    payType = payment.mCode;
    
    btn = btnn;
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

@end
