//
//  PayStateVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/22.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "PayStateVC.h"
#import "OrderDetailVC.h"

@interface PayStateVC (){

    NSTimer   *timer;
    int time;
}

@end

@implementation PayStateVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mPageName = _mIsOK?@"支付成功":@"支付失败";
    self.Title = self.mPageName;
    [self loadData];
}

- (void)leftBtnTouched:(id)sender{

    if (_mTOrder) {
        //[OrderDetailVC whereToGo:_mTOrder vc:self];
        [self popViewController];

    }else{
        
        [self popViewController];
    }
    
}

- (void)loadData{

    self.mPageName = _mIsOK?@"支付成功":@"支付失败";
    self.Title = self.mPageName;
    
    NSString *string = [NSString stringWithFormat:@"%@会员，您的订单：",[SUser currentUser].mUserName];
    _mToplb.text = [NSString stringWithFormat:@"%@%@",string,_mTOrder.mSn];
    
    _mImg.image = _mIsOK?[UIImage imageNamed:@"paysuccess"]:[UIImage imageNamed:@"payfail"];
    
    _mlab1.text = _mIsOK?@"支付成功！祝您购物愉快！去逛逛":@"支付失败";
    
  
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"10秒后自动跳转到订单"];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:COLOR(119, 120, 121) range:NSMakeRange(attriString.length-9,9)];
    
    _mlab2.attributedText = attriString;
    
    if(_mIsOK)
        [_mBT setTitle:@"去逛逛" forState:UIControlStateNormal];
    else
        [_mBT setTitle:@"再试试" forState:UIControlStateNormal];
    
    time = 10;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(RemainingSecond)
                                           userInfo:nil
                                            repeats:YES];
    [timer fire];

}

-(void)RemainingSecond
{
    
    time--;
    
    if (time == 0) {
        
        [timer invalidate];
        [OrderDetailVC whereToGo:_mTOrder vc:self];
    }else{
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d秒后自动跳转到订单",time]];
        
        [attriString addAttribute:NSForegroundColorAttributeName value:COLOR(119, 120, 121) range:NSMakeRange(attriString.length-9,attriString.length-1)];
        
        _mlab2.attributedText = attriString;
    }
    
    
    
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



-(void)payOk
{
    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
    pay.mTOrder = _mTOrder;
    pay.mIsOK = YES;
    
    [self pushViewController:pay];
    
}

- (void)payNO{
    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
    pay.mTOrder = _mTOrder;
    pay.mIsOK = NO;
    [self pushViewController:pay];
    
}

- (IBAction)goGuang:(id)sender {
    
    if (_mIsOK) {
        
        self.tabBarController.selectedIndex = 0;
        
        return;
    }
    
    [self popViewController];
    
}
@end
