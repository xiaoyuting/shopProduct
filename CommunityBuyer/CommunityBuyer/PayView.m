//
//  PayView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "PayView.h"
#import "PayStateVC.h"
#import "OrderDetailVC.h"

@interface PayView (){

    NSString *payType;
    int balancePay;
    UIButton *btn;
    BOOL _allYuE;
}

@end

@implementation PayView
-(id)init{
    if(self = [super init]){
        self.type= [NSString string];
    }
    return self;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mPageName = @"收银台";
    self.Title = self.mPageName;
    
    [self loadPayView];
}

- (void)loadPayView{

    float height = 0;
    
//    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor = [UIColor whiteColor];
    
    BOOL bhaveyue = NO;
    for (int i = 0; i < [GInfo shareClient].mPayment.count; i++) {
        SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:i];
        if( [payment.mCode isEqualToString:@"balancePay"] )
        {
            bhaveyue = YES;
            break;
        }
    }
    
    if( bhaveyue )
    {
        height=[self addYueEPayView:height];
    }
    
    for (int i = 0; i < [GInfo shareClient].mPayment.count; i++) {
        
        SPayment *payment = [[GInfo shareClient].mPayment objectAtIndex:i];
        if( [payment.mCode isEqualToString:@"cashOnDelivery"] )
        {
            continue;
        }
        else if( [payment.mCode isEqualToString:@"balancePay"] )
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
    
    _mPayViewHeight.constant = height;

    _mPayBT.layer.cornerRadius = 3;

    
    self.mshopname.text = self.mTagOrder.mShopName;
    self.mmoney.text = [NSString stringWithFormat:@"¥%.2f",self.mTagOrder.mPayFee-_mTagOrder.mPayMoney];
    
}



- (float)addYueEPayView:(float)height{
    
  
    
    UIButton *wxBT = [[UIButton alloc] initWithFrame:CGRectMake(0, height, DEVICE_Width, 55)];
    [_mPayView addSubview:wxBT];
    wxBT.tag = 201;
    [wxBT addTarget:self action:@selector(chooseBalancePayClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 39, 39)];
    imgV1.image = [UIImage imageNamed:@"yueIcon"];
    [wxBT addSubview:imgV1];
    
    
    
    UILabel *wxLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+10, 0, 200, 55)];
    wxLB.tag=111;
    SUser *user=SUser.new;
    
    
    UILabel *LB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+10, 30, 200, 21)];
    LB.tag=112;
    

    
    LB.textColor = COLOR(148, 148, 148);
    LB.hidden=YES;
    LB.font=[UIFont boldSystemFontOfSize:12];
    
    
    [user getbalance:^(SResBase *resb,NSString *balance){
        
        wxLB.text = [NSString stringWithFormat:@"账户余额可用%@元",balance];
        
        if ([balance floatValue]==0) {
//            [wxBT setEnabled:NO];
        }
//        LB.text = [NSString stringWithFormat:@"还需在线支付%@元",@(_mTagOrder.mPayFee-[balance floatValue])];
        float vvv = _mTagOrder.mPayFee - _mTagOrder.mPayMoney -[balance floatValue];
        if( vvv <= 0.00f )
        {
            vvv = 0.0f;
            _allYuE = YES;
        }
        else _allYuE = NO;
        
        if( _allYuE )
        {
            LB.attributedText = nil;
            LB.text = nil;
        }
        else
        {
            NSMutableAttributedString *zsting = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"还需在线支付%.2f元",vvv]];
            [zsting addAttributes:@{NSForegroundColorAttributeName:COLOR(251, 14, 59)} range:NSMakeRange(6,zsting.length-6)];
            LB.attributedText = zsting;
        }
        
    }];
    [wxBT addSubview:LB];

    
    
    wxLB.textColor = COLOR(72, 63, 69);
    [wxBT addSubview:wxLB];
    
    UIImageView * checkIV2 = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_Width-81, 14, 61, 31)];
    checkIV2.tag = 101;
    [wxBT addSubview:checkIV2];
    
    checkIV2.image = [UIImage imageNamed:@"switch_default"];
//    payType = payment.mCode;
    balancePay=0;
    btn = wxBT;
   

    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wxBT.frame), DEVICE_Width-10, 0.5)];
    line2.backgroundColor = COLOR(208, 206, 204);
    [_mPayView addSubview:line2];
    
    
    height = CGRectGetMaxY(line2.frame);
    
    return height;
}


- (void)chooseBalancePayClick:(id)sender{
    UIButton *btnn = sender;
    
    if (balancePay==0) {
        for (UIImageView *imgV in [btnn subviews]) {
            
            if ([imgV isKindOfClass:[UIImageView class]] ) {
                
                if (imgV.tag == 101) {
                    imgV.image = [UIImage imageNamed:@"switch_light"];
                }
                
            }
        }
        
        for (UILabel *lab in [btnn subviews]) {
            
            if ([lab isKindOfClass:[UILabel class]] ) {
                
                if (lab.tag == 111&& !_allYuE ) {
                    lab.frame=CGRectMake(59, 8, 200, 21);
                    
                }
                if (lab.tag==112) {
                    lab.hidden=NO;
                }
                
            }
        }

        balancePay=1;
        if( _allYuE )//如果余额全部够,就清除已经选择的其他支付方式
        {
            [self clearChoosePay];
            payType = @"balancePay";
        }
        
    }else{
        for (UIImageView *imgV in [btnn subviews]) {
            
            if ([imgV isKindOfClass:[UIImageView class]] ) {
                
                if (imgV.tag == 101) {
                    imgV.image = [UIImage imageNamed:@"switch_default"];
                }
                
            }
        }
        
        for (UILabel *lab in [btnn subviews]) {
            
            if ([lab isKindOfClass:[UILabel class]] ) {
                
                if (lab.tag == 111) {
                    lab.frame=CGRectMake(59, 0, 200, 55);
                }
                
                if (lab.tag==112) {
                    lab.hidden=YES;
                }
                
            }
        }

        
        balancePay=0;
        payType = @"";

    }
    
    
    
    
    
}

- (void)choosePayClick:(id)sender {
    
    if( balancePay && _allYuE ) return;//如果要用余额支付,并且 余额全部都够了,就不用其他支付方式了.
 
    
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
-(void)clearChoosePay
{
    for (UIImageView *imgV in [btn subviews]) {
        
        if ([imgV isKindOfClass:[UIImageView class]] ) {
            
            if (imgV.tag == 100) {
                imgV.image = [UIImage imageNamed:@"quan"];
            }
            
        }
    }
    payType = @"";
}


- (void)goPay{
    
    if ( payType == nil || [payType isEqualToString:@""] ) {
        [SVProgressHUD showErrorWithStatus:@"请先选择支付方式"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在支付..." maskType:SVProgressHUDMaskTypeNone];
    [_mTagOrder payIt:balancePay choosePaytype:payType vc:self block:^(SResBase *retobj) {
        
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [self performSelector:@selector(payOk) withObject:nil afterDelay:0.75f];
        }
        else{
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
            [self performSelector:@selector(payNO) withObject:nil afterDelay:0.75f];
        }
        
        
    }];
}

-(void)payOk
{
//    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
//    pay.mTOrder = _mTagOrder;
//    pay.mIsOK = YES;
//    pay.mPayType = payType;
//    
//    [self pushViewController:pay];
    
    OrderDetailVC *od = [[OrderDetailVC alloc] initWithNibName:@"OrderDetailNewVC" bundle:nil];
    od.type =self.type;
    od.mTagOrder = _mTagOrder;
    
    //[self pushViewController:od];
    [self setToViewController:od];
}

- (void)payNO{
//    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
//    pay.mTOrder = _mTagOrder;
//    pay.mIsOK = NO;
//    pay.mPayType = payType;
//    [self pushViewController:pay];
    
    OrderDetailVC *od = [[OrderDetailVC alloc] initWithNibName:@"OrderDetailNewVC" bundle:nil];
    
    od.mTagOrder = _mTagOrder;
    od.type =self.type;
    //[self pushViewController:od];
    [self setToViewController:od];
    
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

- (IBAction)mGoPayClick:(id)sender {
    
    [self goPay];
}
@end
