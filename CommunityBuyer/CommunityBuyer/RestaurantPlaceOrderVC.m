//
//  RestaurantPlaceOrderVC.m
//  JiaZhengBuyer
//
//  Created by 周大钦 on 15/7/20.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "RestaurantPlaceOrderVC.h"
#import "AddContactVC.h"
#import "DatePicker.h"
#import "AddressVC.h"
#import "OrderPay.h"
#import "LocVC.h"
#import "JSBadgeView.h"
#import "ShopCarView.h"
#import "OrderDetailView.h"
#import "MyPhoneListVC.h"

@interface RestaurantPlaceOrderVC ()<AddContactDelegate>{

    DatePicker *datePic;
    SGoods *_goods;
    JSBadgeView *badgeView;
    SPromotion *_spm;
    
    BOOL isShowCar;
    UIView *maskView;
    
    UIScrollView *scrollView;
    
    SAddress *address;
    SMobile  *mobile;
    
}

@end


@implementation RestaurantPlaceOrderVC{

    BOOL isLoad;
}

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
    
    self.mPageName = @"确认订单";
    self.Title = self.mPageName;
    
    
    
    _mPlaceOrder.layer.masksToBounds = YES;
    _mPlaceOrder.layer.cornerRadius = 3;
    
    
    _mPrice.text = [NSString stringWithFormat:@"¥%d元",_mSumPrice];
    _mFree.text = [NSString stringWithFormat:@"配送费¥%d元",_mFreePrice];
    
    
    badgeView = [[JSBadgeView alloc] initWithParentView:_mCarBtn alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgePositionAdjustment = CGPointMake(-10, 10);
    badgeView.badgeStrokeWidth = 5;
    badgeView.badgeText = [NSString stringWithFormat:@"%d",_mSumnum];
    
    
    self.mRemarkV.placeholder = @"请输入您要特别说明的事情...";
    self.mRemarkV.textColor = [UIColor colorWithRed:0.608 green:0.592 blue:0.608 alpha:1];
    [self.mRemarkV setHolderToTop];
    
    //SMobile *defaultMobile = [[SUser currentUser] getMobileDefault];
//    _mPhone.text = defaultMobile?defaultMobile.mMobile:@"联系电话";
  //  mobile = defaultMobile?defaultMobile:nil;
    
    
    SAddress *defaultAddress = [[SUser currentUser] getDefault];
    _mAddress.text = defaultAddress?defaultAddress.mAddress:@"服务地址";
    address = defaultAddress?defaultAddress:nil;
    
}


- (void)setContactName:(NSString *)name andPhone:(NSString *)phone{

    _mPhone.text = phone;
    _mPhone.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)GoContactClick:(id)sender {
    
    if ( [SUser isNeedLogin] ) {
        
        [self gotoLoginVC];
        
        return;
    }

    
    MyPhoneListVC *phoneVC = [[MyPhoneListVC alloc] initWithNibName:@"MyPhoneListVC" bundle:nil];
    
    phoneVC.itblock = ^(SMobile* Mobile){
    
        if (Mobile) {
            
           // _mPhone.text = Mobile.mMobile;
            
            mobile = Mobile;
        }
    };
    
    [self pushViewController:phoneVC];
}



- (IBAction)mGoAddressClick:(id)sender {
    
    if ( [SUser isNeedLogin] ) {
        
        [self gotoLoginVC];
        
        return;
    }
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddressVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    
    viewController.itblock = ^(SAddress* retobj){
        if( retobj )
        {
            
            _mAddress.text = retobj.mAddress;
            
            address = retobj;
        }
        
    };

    
    [self.navigationController pushViewController:viewController animated:YES];
   
    
}




- (IBAction)CarClick:(id)sender {
    
    if (isShowCar) {
        [self closeMaskView];
        return;
    }
    
    
    [self layoutDatingInfo];
    
    [self.view bringSubviewToFront:_mBottomV];
}

-(void)closeMaskView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        //     EditTempBtn = nil;
        maskView.alpha = 0.0f;
        CGRect rect = scrollView.frame;
        rect.origin.y = DEVICE_Height;
        scrollView.frame =rect;
        
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
        [maskView removeFromSuperview];
    }];
    
    isShowCar = NO;
    
}



-(void)layoutDatingInfo
{
    
    CGRect rect = self.view.bounds;
    rect.size.height -=50;
    maskView = [[UIView alloc]initWithFrame:rect];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.0;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMaskView)];
    [maskView addGestureRecognizer:ges];
    [self.view addSubview:maskView];
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, DEVICE_Height, DEVICE_Width, 300+55)];
    scrollView.backgroundColor = COLOR(198, 193, 193);
    
    
    float y = 0;
    float heigth = 50;
    
    for (int i = 0; i < [_mCarArray count]; i ++) {
        
        SGoods *goods = [[_mCarArray objectAtIndex:i] objectForKey:@"goods"];
        
        ShopCarView *view = [ShopCarView shareView];
        view.frame = CGRectMake(0, y, DEVICE_Width, heigth);
        [scrollView addSubview:view];
        
        view.mName.text = goods.mName;
        
        view.mPrice.text = [NSString stringWithFormat:@"¥%.2f",goods.mPrice];
        
        view.mNum.text = [NSString stringWithFormat:@"%d份",goods.mCount];
        
        view.mJianBt.hidden = YES;
        view.mJiaBt.hidden = YES;
        
        
        y+= heigth;
        
    }

    [self.view addSubview:scrollView];
    [UIView animateWithDuration:0.2 animations:^{
        maskView.alpha = 0.5;
        CGRect rect = scrollView.frame;
        
        if (heigth*[_mCarArray count]>DEVICE_Height-200-50) {
            rect.size.height = DEVICE_Height-200-50;
            rect.origin.y = 200;
            scrollView.contentSize = CGSizeMake(DEVICE_Width, heigth*[_mCarArray count]);
        }else{
            
            rect.size.height = heigth*[_mCarArray count];
            rect.origin.y = DEVICE_Height-rect.size.height-50;
        }
        
        scrollView.frame =rect;
    }];
    
    isShowCar = YES;
}


- (IBAction)mGoPlaceOrderClick:(id)sender {
    
    if ([_mAddress.text isEqualToString:@"服务地址"]) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择服务地址"];
        return;
    }
    
    if ([_mPhone.text isEqualToString:@"联系电话"]) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择联系电话"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"下单中"];
    /*
    [SOrderInfo dealOneOrder:mobile.mId addressid:address.mId remark:_mRemarkV.text type:_mType goods:_mCarArray block:^(SResBase *resb, SOrderInfo *retobj) {
        
        
        if(resb.msuccess){
            [SVProgressHUD dismiss];
            OrderPay *payV = [[OrderPay alloc] initWithNibName:@"OrderPay" bundle:nil];
            payV.mTempOrder = retobj;
            
            [self pushViewController:payV];
        }else{
        
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
    */
    
    
    
    

}


@end
