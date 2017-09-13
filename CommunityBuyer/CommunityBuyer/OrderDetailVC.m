//
//  OrderDetailVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "OrderDetailVC.h"
#import "GoodsView.h"
#import "PayStateVC.h"
#import "CmmVC.h"
#import "PayView.h"
#import "RestaurantDetailVC.h"
#import "ServiceDetailVC.h"
#import "UILabel+myLabel.h"


#import "orderCouponView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface OrderDetailVC ()<UIAlertViewDelegate,UITextFieldDelegate>{
        
    NSString *str;
    UIButton *tempBT;
    
    
    orderCouponView *mCouponView;
    
    
    UIView  *mBGKV;
    
    orderCouponView *mShareView;
    
    UIButton    *mShareBtn;
    
    
    SShareContent   *mShareData;
    
}

@end

@implementation OrderDetailVC

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

+(void)gotoOrderDetailWithOrderId:(int)orderId vc:(UIViewController*)vc
{
    SOrderObj* tt  = SOrderObj.new;
    tt.mId = orderId;
    
    [SVProgressHUD showWithStatus:@"正在获取订单信息" maskType:SVProgressHUDMaskTypeClear];
    [tt getDetail:^(SResBase *resb) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            [OrderDetailVC whereToGo:tt vc:vc];
        }
        else [SVProgressHUD showErrorWithStatus:resb.mmsg];
    } type:nil];
}

+(OrderDetailVC*)whichVC:(SOrderObj*)order
{
    OrderDetailVC *orderDetail = nil;
    
    
    orderDetail = [[OrderDetailVC alloc] initWithNibName:@"OrderDetailNewVC" bundle:nil];

    
    return orderDetail;
}
+(void)whereToGo:(SOrderObj*)order vc:(UIViewController*)vc
{
    OrderDetailVC *orderDetail = [self whichVC:order];
    
    orderDetail.mTagOrder = order;
    [vc.navigationController pushViewController:orderDetail animated:YES];
}

- (void)leftBtnTouched:(id)sender{

    [self popViewController];
}



- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mPageName = @"订单详情";
    self.Title = self.mPageName;
//    self.rightBtnImage = [UIImage imageNamed:@"hongphone"];
       [self loadData];
    [self initSahreView];
    
}

- (void)loadData{
    
    [self addMEmptyView:self.view rect:CGRectZero];
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    if( _mTagOrder != nil )
        
    {
        
  
        if(_mTagOrder.misCanRefundStatusNew){
    
        self.type=@"1";
        }
        
        [_mTagOrder getDetail:^(SResBase *retobj) {
            
            if (retobj.msuccess) {
                [SVProgressHUD dismiss];
                [self updatePageInfo];
                [self removeMEmptyView];
                [self loadCouponData];

            }
            else {
                
                [SVProgressHUD showErrorWithStatus:retobj.mmsg];
                
            }

        } type:self.type];
    }
    else
    {
        _mTagOrder = SOrderObj.new;
        _mTagOrder.mId = _mOrderId;
        if(_mTagOrder.misCanRefundStatusNew){
            
            self.type=@"1";
        }
        [_mTagOrder getDetail:^(SResBase *retobj) {
            if (retobj.msuccess) {
                [SVProgressHUD dismiss];
                [self updatePageInfo];
                [self removeMEmptyView];
                [self loadCouponData];

            }else{
                
                [SVProgressHUD showErrorWithStatus:retobj.mmsg];
            }

        } type:self.type];
    }
    
}

- (void)updatePageInfo{
    
    [self updateTopView];
    
    [self updateMiddleViewZW];
    
    [self updateBotomView];
    
    
    
}

- (void)updateTopView{
    
   
    NSLog(@"_mTagOrder.mshowImgNew===%@",_mTagOrder.mshowImgNew);
    if(_mTagOrder.mshowImgNew){
        
       [_mTopImg sd_setImageWithURL:[NSURL URLWithString:_mTagOrder.mshowImgNew] placeholderImage:[UIImage imageNamed:@"DefaultBanner"]];
    }else{
        [_mTopImg sd_setImageWithURL:[NSURL URLWithString:_mTagOrder.mStatusFlowImage] placeholderImage:[UIImage imageNamed:@"DefaultBanner"]];
    }
    
    _mOrderState.text = [NSString stringWithFormat:@"订单状态 %@          ",_mTagOrder.mOrderStatusStr];
    _mOrderState.layer.masksToBounds = YES;
    _mOrderState.layer.cornerRadius = 10;
    
    if (_mTagOrder.mOrderType == 2){
        _mServiceName.text = [NSString stringWithFormat:@"服务人员：%@",!_mTagOrder.mStaffName?@"无":_mTagOrder.mStaffName];
    }else{
        _mServiceName.text = [NSString stringWithFormat:@"配送人员：%@",!_mTagOrder.mStaffName?@"无":_mTagOrder.mStaffName];
    }
    _mCuiDanBT.layer.cornerRadius = 3;
    _mCuiDanBT.layer.borderWidth = 0.8;
    _mCuiDanBT.layer.borderColor = COLOR(225, 228, 228).CGColor;
    if (_mTagOrder.mIsCanReminder) {
        _mCuiDanBT.hidden = NO;
    }else{
        _mCuiDanBT.hidden = YES;
    }

    _mSellerName.text = _mTagOrder.mSellerName;
    
    
    _mLxkfBT.layer.cornerRadius = 3;
    _mLxkfBT.layer.borderWidth = 0.8;
    _mLxkfBT.layer.borderColor = COLOR(225, 228, 228).CGColor;
    
    _mLxsjBT.layer.cornerRadius = 3;
    _mLxsjBT.layer.borderWidth = 0.8;
    _mLxsjBT.layer.borderColor = COLOR(225, 228, 228).CGColor;


}

- (void)CallClick:(UITapGestureRecognizer *)sender{
    
    NSMutableString * mobile=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mTagOrder.mStaffMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
}

- (void)CallClick2:(UITapGestureRecognizer *)sender{
    
    NSMutableString * mobile=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mTagOrder.mSellerTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
}

-(NSMutableDictionary*)formatNormGoods:(NSArray*)alltag
{
    NSMutableDictionary* dic = NSMutableDictionary.new;
    for ( int i = 0; i < alltag.count; i++ ) {
        
        SCarSeller *scarSeller = alltag[i];
        NSString* key = [NSString stringWithFormat:@"%d", scarSeller.mGoodsId];
        NSMutableArray* sub = [dic objectForKey:key];
        if( sub == nil )
        {
            sub = NSMutableArray.new;
            [dic setObject:sub forKey:key];
        }
        [sub addObject: scarSeller];
    }
    return dic;
}
-(float)getOneGroupTotalPrice:(NSArray*)onegroup
{
    float t = 0.0f;
    for ( SCarSeller* oneobj in onegroup )
    {
        t = oneobj.mPrice * oneobj.mNum;
    }
    return t;
}
- (void)updateMiddleViewZW{
    
    NSDictionary* dic  = [self formatNormGoods:_mTagOrder.mCartSellers];
    NSArray* all = dic.allValues;
    CGFloat offsety = 0.0f;
    for(  NSArray* one in  all  )
    {
        BOOL bhavenorm = NO;
        for ( int j = 0 ; j < one.count; j++ ) {
            SCarSeller* oneobj = one[j];
            bhavenorm = one.count > 1  || oneobj.mGoodsNorms.length > 0;//如果有多个,或者有规格名字,,就是有规格
            if( j == 0  )
            {
                if( bhavenorm )
                {//如果有规格,第一个,显示头
                    GoodsView *goodsView = [GoodsView shareView];
                    CGRect rect = goodsView.frame;
                    rect.origin.y = offsety;
                    rect.size.width = DEVICE_Width;
                    goodsView.frame = rect;
                    offsety += 48.0f;
                    
                    goodsView.mName.text = oneobj.mGoodsName;
                    [goodsView.mName autoReSizeWidthForContent:0.75*DEVICE_Width];
                    
                    goodsView.mNum.text = @"";
                    goodsView.mPrice.text = [NSString stringWithFormat:@"¥%.2f",[self getOneGroupTotalPrice:one]];
                    
                    [_mGoodsView addSubview:goodsView];
                    
                    if( one.count == 1 )
                    {//如果有规格,只有1个,就后面跟规格了
                        
                        //规格
                        GoodsView *goodsView = [GoodsView shareView];
                        CGRect rect = goodsView.frame;
                        rect.origin.y = offsety;
                        rect.size.width = DEVICE_Width;
                        rect.size.height = 30.0f;
                        goodsView.frame = rect;
                        offsety += 30.0f;
                        
                        goodsView.mName.text = [NSString stringWithFormat:@" %@ ",oneobj.mGoodsNorms];
                        [goodsView.mName autoReSizeWidthForContent:0.75*DEVICE_Width];
                        goodsView.mNum.text = @"";
                        goodsView.mPrice.text = [NSString stringWithFormat:@"¥%.2f x %d",oneobj.mPrice,oneobj.mNum];
                        
                        goodsView.mName.backgroundColor     = [UIColor colorWithWhite:0.600 alpha:1.000];
                        goodsView.mName.layer.cornerRadius  = 3.0f;
                        goodsView.mName.layer.borderColor   = [UIColor whiteColor].CGColor;
                        goodsView.mName.layer.borderWidth   = 1.0f;
                        goodsView.mName.textColor           = [UIColor whiteColor];
                        goodsView.mName.font                = [UIFont systemFontOfSize:12.0f];
                        
                        [_mGoodsView addSubview:goodsView];
                        
                    }
                }
                else
                {//如果没有规格.
                    GoodsView *goodsView = [GoodsView shareView];
                    CGRect rect = goodsView.frame;
                    rect.origin.y = offsety;
                    rect.size.width = DEVICE_Width;
                    goodsView.frame = rect;
                    offsety += 48.0f;
                    
                    goodsView.mName.text = oneobj.mGoodsName;
                    goodsView.mNum.text = @"";
                    goodsView.mPrice.text = [NSString stringWithFormat:@"¥%.2f x %d",oneobj.mPrice,oneobj.mNum];
                    
                    [goodsView.mName autoReSizeWidthForContent:0.75*DEVICE_Width];

                    
                    [_mGoodsView addSubview:goodsView];
                    
                }
            }
            else
            {
                //这里全部都是规格了
                
                //规格
                GoodsView *goodsView = [GoodsView shareView];
                CGRect rect = goodsView.frame;
                rect.origin.y = offsety;
                rect.size.width = DEVICE_Width;
                rect.size.height = 30.0f;
                goodsView.frame = rect;
                offsety += 30;
                
                goodsView.mName.text = [NSString stringWithFormat:@" %@ ",oneobj.mGoodsNorms];
                goodsView.mNum.text = @"";
                goodsView.mPrice.text = [NSString stringWithFormat:@"¥%.2f x %d",oneobj.mPrice,oneobj.mNum];
                
                [goodsView.mName autoReSizeWidthForContent:0.75*DEVICE_Width];
                goodsView.mName.backgroundColor = [UIColor colorWithWhite:0.600 alpha:1.000];
                goodsView.mName.layer.cornerRadius  = 3.0f;
                goodsView.mName.layer.borderColor   = [UIColor whiteColor].CGColor;
                goodsView.mName.layer.borderWidth   = 1.0f;
                goodsView.mName.textColor           = [UIColor whiteColor];
                goodsView.mName.font                = [UIFont systemFontOfSize:12.0f];
                
                [_mGoodsView addSubview:goodsView];
                
            }
        }
    }
    
    _mGoodsViewHeight.constant = offsety;
    
    _mYunFeiPrice.text = [NSString stringWithFormat:@"¥%.2f",_mTagOrder.mFreight];
    
    _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mTagOrder.mPayFee];
    
    if( _mTagOrder.mDiscountFee == 0.0f )
    {
        _mprohi.constant = 0;
    }
    else
    {
        _mprohi.constant = 48;
        _mproprice.text = [NSString stringWithFormat:@"-%.2f",_mTagOrder.mDiscountFee];
    }
    
}

- (void)updateMiddleView{

    float price = 0;
    
    for (int i = 0; i < _mTagOrder.mCartSellers.count; i++) {
        
        SCarSeller *scarSeller = _mTagOrder.mCartSellers[i];
        GoodsView *goodsView = [GoodsView shareView];
        CGRect rect = goodsView.frame;
        rect.origin.y = rect.size.height*i;
        rect.size.width = DEVICE_Width;
        goodsView.frame = rect;
        
        goodsView.mName.text = scarSeller.mGoodsName;
        goodsView.mNum.text = [NSString stringWithFormat:@"X%d",scarSeller.mNum];
        goodsView.mPrice.text = [NSString stringWithFormat:@"¥%.2f",scarSeller.mPrice];
        
        [_mGoodsView addSubview:goodsView];
        
        price += scarSeller.mPrice;
    }
    
    _mGoodsViewHeight.constant = _mTagOrder.mCartSellers.count*48;
    
    _mYunFeiPrice.text = [NSString stringWithFormat:@"¥%.2f",_mTagOrder.mFreight];
    
    _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mTagOrder.mTotalFee];}



- (void)updateBotomView{

    _mName.text = [NSString stringWithFormat:@"收货人：%@",_mTagOrder.mName];
    _mPhone.text = [NSString stringWithFormat:@"电     话：%@",_mTagOrder.mMobile];
    _mPayType.text = [NSString stringWithFormat:@"支付方式：%@",_mTagOrder.mPayType];
    _mPlayOrderTime.text = [NSString stringWithFormat:@"顾客下单时间：%@",_mTagOrder.mCreateTime];
    _mArriveTime.text = [NSString stringWithFormat:@"预约到达时间：%@",_mTagOrder.mAppTime];
    _mAddress.text = _mTagOrder.mAddress;
    _mOrderSn.text = [NSString stringWithFormat:@"订单编号：%@", _mTagOrder.mSn];
    if (_mTagOrder.mBuyRemark.length <= 0) {
        _mRemark.text =@"无";
    }else{
        _mRemark.text =_mTagOrder.mBuyRemark;
    }
    
    _mLeftBT.layer.cornerRadius = 3;
    _mRightBT.layer.cornerRadius = 3;
    _mOneBT.layer.cornerRadius = 3;
    
    NSMutableArray *statuAry =  NSMutableArray.new;
    SEL selectorAry[8];
    int index = 0;
    
    if (_mTagOrder.mIsCanDelete) {//删除订单
        
        [statuAry addObject:@"删除订单"];
        selectorAry[index] = @selector(deleteAction);
        index++;
    }
    if (_mTagOrder.mIsCanRate) {//评价
        
        [statuAry addObject:@"评价"];
        selectorAry[index] = @selector(PingjiaAction);
        index++;
    }
    if (_mTagOrder.mIsCanCancel) {//取消订单
        
        [statuAry addObject:@"取消订单"];
        selectorAry[index] = @selector(cancelAction);
        index++;
    }
    if (_mTagOrder.mIsCanPay) {//去支付
        
        [statuAry addObject:@"去支付"];
        selectorAry[index] = @selector(GoPayAction);
        index++;
        
    }
    if (_mTagOrder.mIsCanConfirm) {//确认完成
         [statuAry addObject:@"确认完成"];
        selectorAry[index] = @selector(comfirmAction);
        index++;
    }
    if([_mTagOrder.misCanRefundStatusNew intValue]==2){
        [statuAry addObject:@"申请退款"];
        selectorAry[index] = @selector(pullMoney );
        index++;

    }
    if([_mTagOrder.misCanRefundStatusNew intValue]==3){
        [statuAry addObject:@"取消退款"];
        selectorAry[index] = @selector(cancelPullMoney);
        index++;
        
    }
    if(((_mTagOrder.mIsCanDelete || _mTagOrder.mIsCanRate) && statuAry.count<2) || statuAry.count == 0||([_mTagOrder.misCanRefundStatusNew intValue]==5)){
    
        [statuAry addObject:@"去逛逛"];
        selectorAry[index] = @selector(GoAction);
        index++;
    }
    
    
    
    [_mLeftBT removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [_mRightBT removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [_mOneBT removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];

    if(statuAry.count == 2){
        
        _mLeftBT.hidden = NO;
        _mRightBT.hidden = NO;
        _mOneBT.hidden = YES;
        [_mLeftBT setTitle:[statuAry objectAtIndex:0] forState:UIControlStateNormal];
        [_mLeftBT addTarget:self action:selectorAry[0] forControlEvents:UIControlEventTouchUpInside];
        
        [_mRightBT setTitle:[statuAry objectAtIndex:1] forState:UIControlStateNormal];
        [_mRightBT addTarget:self action:selectorAry[1] forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if (statuAry.count == 1){
    
        _mLeftBT.hidden = YES;
        _mRightBT.hidden = YES;
        _mOneBT.hidden = NO;
        
        [_mOneBT setTitle:[statuAry objectAtIndex:0] forState:UIControlStateNormal];
        [_mOneBT addTarget:self action:selectorAry[0] forControlEvents:UIControlEventTouchUpInside];
    }
  
}
-(void)cancelPullMoney{
   
    [SVProgressHUD showWithStatus:@"取消退款" maskType:SVProgressHUDMaskTypeClear];
    [_mTagOrder  cancelPullMoney:[NSString stringWithFormat:@"%d", _mTagOrder.mId ] :^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            [self loadData];
            
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    

   }
-(void)pullMoney{
    [SVProgressHUD showWithStatus:@"申请退款" maskType:SVProgressHUDMaskTypeClear];
    [_mTagOrder  pullMoney:[NSString stringWithFormat:@"%d", _mTagOrder.mId ] :^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            [self loadData];
            
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
}
- (void)deleteAction{
    //删除订单
    
    [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeClear];
    [_mTagOrder deleteThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            [self popToRootViewController];
            
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    
    
}

//取消订单
- (void)cancelAction{
    
    
    
    if(!_mTagOrder.mIsContactCancel){
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消订单吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        //    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"商家已接单，如需取消订单请电话联系%@:%@",_mTagOrder.mShopName,_mTagOrder.mSellerTel] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        //    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
        
       
    }
    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //得到输入框
    //    UITextField *tf=[alertView textFieldAtIndex:0];
    
    
    if (_mTagOrder.mIsContactCancel) {
        
        if (buttonIndex == 1){
            NSMutableString * mobile=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mTagOrder.mSellerTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobile]];
        }else{
            
            return;
        }
        
        
    }else{
        
        if (buttonIndex == 0) {
            
            [SVProgressHUD showWithStatus:@"正在取消..." maskType:SVProgressHUDMaskTypeClear];
            [_mTagOrder cancelThis:str block:^(SResBase *resb) {
                if( resb.msuccess )
                {
                    [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                    
                    [self updatePageInfo];
                }
                else
                    [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }];
            
        }else{
            
            return;
        }
    }
        
    
    
    
    
    
}

//评价订单
- (void)PingjiaAction{
    
    CmmVC* vc = [[CmmVC alloc]initWithNibName:@"CmmVC" bundle:nil];
    vc.mtagOrder = self.mTagOrder;
    [self pushViewController:vc];
}

//去支付
- (void)GoPayAction{

    PayView *payV = [[PayView alloc] initWithNibName:@"PayView" bundle:nil];
    payV.mTagOrder = _mTagOrder;
    [self pushViewController:payV];
}

//确认完成
- (void)comfirmAction{

    [SVProgressHUD showWithStatus:@"正在确认完成..." maskType:SVProgressHUDMaskTypeClear];
    
    [_mTagOrder confirmThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            
            [self updatePageInfo];
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    
    
}

//去逛逛
- (void)GoAction{

    self.tabBarController.selectedIndex = 0;
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


- (void)tuiKuanAction{//申请退款

    [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeClear];
    [_mTagOrder deleteThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:retobj.mmsg];
            [self popToRootViewController];
            
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];
    
}






- (IBAction)mCuidanClick:(id)sender {
    
    //确认完成
    [SVProgressHUD showWithStatus:@"正在催单..." maskType:SVProgressHUDMaskTypeClear];
    
    [_mTagOrder cuidanThis:^(SResBase *retobj) {
        if( retobj.msuccess )
        {
            [SVProgressHUD showSuccessWithStatus:@"催单成功"];
        }
        else
            [SVProgressHUD showErrorWithStatus:retobj.mmsg];
        
    }];

    
}
- (IBAction)mSellerClick:(id)sender {
    
    
    if (_mTagOrder.mOrderType == 1) {
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
        SSeller *seller = [[SSeller alloc] init];
        seller.mId = _mTagOrder.mSellerId;
        seller.mName = _mTagOrder.mSellerName;
        viewController.mSeller = seller;

        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        
        ServiceDetailVC *serviceVC = [[ServiceDetailVC alloc] init];
        
        SSeller *seller = [[SSeller alloc] init];
        seller.mId = _mTagOrder.mSellerId;
        seller.mName = _mTagOrder.mSellerName;
        serviceVC.mSeller = seller;
        [self pushViewController:serviceVC];
        
    }

}
- (IBAction)mLxkfClick:(id)sender {
    
    NSMutableString * string=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[GInfo shareClient].mServiceTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (IBAction)mLxsjClick:(id)sender {
    
    NSMutableString * string=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mTagOrder.mSellerTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

#pragma mark----优惠券信息
- (void)loadCouponData{

    [_mTagOrder getActivity:^(SShareContent *mShare, SResBase *resb) {

        if (resb.msuccess) {
            
//            NSLog(@"*--**-*-*-*-*--*-**-*-:%@",mShare);
            
            mShareData = [[SShareContent alloc] initWithObj:resb.mdata];
            NSLog(@"*--**-*-*-*-*--*-**-*-:%@",mShareData);

            if ( resb.mdata ) {
                [self loadCouponView];
            }
        }else{
            
        }
    }];
    
}
/**
 *  加载优惠券view
 */
- (void)loadCouponView{
    if (mShareBtn == nil  ) {
      
        mShareBtn = [UIButton new];
        mShareBtn.frame = CGRectMake(DEVICE_Width-60, DEVICE_Height-150, 50, 50);
        mShareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        mShareBtn.backgroundColor = [UIColor redColor];
//        [mShareBtn setTitle:@"分享" forState:0];
        [mShareBtn setImage:[UIImage imageNamed:@"shareBtn"] forState:0];
//        mShareBtn.layer.masksToBounds = YES;
//        mShareBtn.layer.cornerRadius = mShareBtn.frame.size.width/2;

        [mShareBtn addTarget:self action:@selector(mShareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:mShareBtn];
    }

    
    
    if( !_mTagOrder.mPromotionIsShow )
    {
        _mTagOrder.mPromotionIsShow = 1;//显示过了
        [_mTagOrder notShowBigShare];

        NSDictionary *mStyle2 = @{@"color": [UIColor redColor],@"font":[UIFont systemFontOfSize:15]};
        
        
        if (mCouponView == nil) {
            mCouponView = [orderCouponView shareView];
            mCouponView.alpha = 0;
            mCouponView.frame = self.view.bounds;
            
            mCouponView.mTitle.attributedText = [[NSString stringWithFormat:@"<font>恭喜获得</font><color>%d</color><font>个优惠券</font>",mShareData.mSharePromotionNum] attributedStringWithStyleBook:mStyle2];
            
            [self.view addSubview:mCouponView];
            [mCouponView.mCancelBtn addTarget:self action:@selector(mCloseAction) forControlEvents:UIControlEventTouchUpInside];
            [mCouponView.mSendBtn addTarget:self action:@selector(mSendAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [self showCouponView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        
        [mCouponView addGestureRecognizer:tap];
    
    }
}
/**
 *  点击空白view
 */
- (void)tapAction{
    [self closeCouponView];
    [self closeShareView];

}
/**
 *分享按钮
 */
- (void)mShareAction{
    [self showShareView];
}
/**
 *  打开优惠券
 */
- (void)showCouponView{

    
    
    [UIView animateWithDuration:0.35 animations:^{
        
        mCouponView.alpha = 1;
        
    }];
    
    
}
/**
 *  关闭优惠券view
 */
- (void)closeCouponView{
    [UIView animateWithDuration:0.35 animations:^{
        
        mCouponView.alpha = 0;
        
    }];
}

/**
 *  x取消按钮
 */
- (void)mCloseAction{
    
    [self closeCouponView];
}
/**
 *  发送优惠券
 */
- (void)mSendAction{
    [self closeCouponView];
    [self showShareView];
}

/**
 *  初始化分享view
 */
- (void)initSahreView{

    
    if (mBGKV == nil) {
        mBGKV = [UIView new];
        mBGKV.alpha = 0;
        mBGKV.backgroundColor = [UIColor colorWithRed:0.16 green:0.17 blue:0.21 alpha:0.2];
        mBGKV.frame = CGRectMake(0, 0, DEVICE_Width, DEVICE_Height);
        [self.view addSubview:mBGKV];
        
        
    }
    if (mShareView == nil) {
        mShareView = [orderCouponView initShareView];
        mShareView.frame = CGRectMake(0, DEVICE_Height, DEVICE_Width, 145);
        [mShareView.mWechatQ addTarget:self action:@selector(mWechatQ) forControlEvents:UIControlEventTouchUpInside];
        [mShareView.mWechatF addTarget:self action:@selector(mWechatF) forControlEvents:UIControlEventTouchUpInside];
        [mBGKV addSubview:mShareView];

    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [mBGKV addGestureRecognizer:tap];

}
/**
 *  打开分享
 */
- (void)showShareView{
    [UIView animateWithDuration:0.25 animations:^{
        mShareBtn.alpha = 0;
        mBGKV.alpha = 1;
        CGRect rrr = mShareView.frame;
        rrr.origin.y = DEVICE_Height-145;
        mShareView.frame = rrr;
    }];
}
/**
 *  关闭分享view
 */
- (void)closeShareView{
    [UIView animateWithDuration:0.25 animations:^{
        mShareBtn.alpha = 1;
        mBGKV.alpha = 0;
        CGRect rrr = mShareView.frame;
        rrr.origin.y = DEVICE_Height;
        mShareView.frame = rrr;
    }];
}
/**
 *  分享到微信好友
 */
- (void)mWechatF{
    NSLog(@"微信朋友圈");
    [self Share:SSDKPlatformSubTypeWechatTimeline];

    [self closeShareView];
}
/**
 *  分享到微信朋友圈
 */
- (void)mWechatQ{
    NSLog(@"微信好友");
    [self Share:SSDKPlatformSubTypeWechatSession];
    [self closeShareView];
}

- (void)Share:(SSDKPlatformType)type{
    
    
    
    
    
    //1、创建分享参数
   // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）

    NSArray* tt = @[@""];
    if( mShareData.mImgUrl )
        tt = @[mShareData.mImgUrl];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:mShareData.mDetail
                                         images:tt
                                            url:[NSURL URLWithString:mShareData.mUrl]
                                          title:mShareData.mTitle
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                case SSDKResponseStateCancel:{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户取消了操作！"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }
         ];
    
    
    
}

@end
