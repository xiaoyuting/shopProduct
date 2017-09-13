//
//  BalanceVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/24.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "BalanceVC.h"
#import "DatePicker.h"
#import "PayStateVC.h"
#import "AddressVC.h"
#import "OrderDetailVC.h"
#import "PayView.h"
#import "myYouHuiJuan.h"

@interface BalanceVC ()<UITextFieldDelegate>{

    UIButton *btn;
    
    float yue;
    UILabel *yueLB;
    NSString *payType;
    
    SAddress *defaultAddress;
    
    DatePicker *datePic;
    
    SOrderObj *myOrder;
    SOrderCompute*  _mtagcomp;
    SOrderCompute*  _cheakInfo;
    NSMutableArray* _allpayment;
    
    SPromotion* _selectpro;
    
    UIColor*    _orgpricecolor;
    
    NSString *  _coupon ;
    NSString *  _TagY;
    
}


@end

@implementation BalanceVC
-(void)setCard {
    self.timeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.costView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bzView.translatesAutoresizingMaskIntoConstraints   = NO;
    self.ysVIew.translatesAutoresizingMaskIntoConstraints   = NO;
    self.bzView.alpha =0;
    self.ysVIew.alpha = 0;
    self.jieSuanH.constant=0;
    self.yunSongH.constant=0;
    self.beiZhuH.constant =0;
    self.timeHeight.constant = 0;
    self.timeView.alpha = 0;
    self.costHeight.constant = 0;
    self.costView.alpha = 0;
     _TagY=@"1";
    self.timeText.text=@"0";

    
    
}
- (IBAction)selectDistributionStyle:(UIButton *)sender {
    self.timeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.costView.translatesAutoresizingMaskIntoConstraints = NO;
    if(sender.tag==1){
          _TagY=@"0";
       // _mYunFei.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mFreight];
        _mHeJi.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
        _SumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
            self.timeHeight.constant =50;
            self.costHeight.constant = 50;
            self.costView.alpha = 1;
            self.timeView.alpha = 1;
            self.timeText.text=@"";
            self.distributionOwnBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:0 blue:43/255.0 alpha:1];
            self.distributionBtn.backgroundColor  = [UIColor whiteColor];
            [self.distributionOwnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.distributionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           // [self getComputerDat:YES];
       

        
    }else if (sender.tag==0){
    
        _mHeJi.text  = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee-_mtagcomp.mFreight];
        _SumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee-_mtagcomp.mFreight];
          _TagY=@"1";
        self.timeHeight.constant = 0;
        self.timeView.alpha = 0;
        self.costHeight.constant = 0;
        self.costView.alpha = 0;
        self.distributionBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:0 blue:43/255.0 alpha:1];
        self.distributionOwnBtn.backgroundColor = [UIColor whiteColor];
        [self.distributionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.distributionOwnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
            self.timeText.text=@"0";
        
    }
    
}

- (void)viewDidLoad {
    self.pushView.translatesAutoresizingMaskIntoConstraints=NO;
    self.numView.translatesAutoresizingMaskIntoConstraints = NO;
    self.numH.constant=0;
    self.pushH.constant=90;
    self.numView.alpha =0;
    self.numField.delegate=self;
    _TagY =@"0";
    self.hiddenTabBar = YES;
    //self.distributionOwnBtn.layer.cornerRadius =4;
    //self.distributionBtn.layer.cornerRadius =4;
    [super viewDidLoad];
    
    self.mPageName = @"确认订单";
    self.Title = self.mPageName;
    
    self.mSystempayTime.text = [NSString stringWithFormat:@"请在下单后%@内完成支付",[GInfo shareClient].mSystemOrderPass];
   
    if( [SUser currentUser] )
    {
//        //先不使用第一个优惠卷,getComputerDat 里面会判断是否有优惠卷
//        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
//        [[SUser currentUser]getMyFirstYouHuiJuan:^(SResBase *resb, SPromotion *retobj) {
////            _selectpro = retobj;
//            
//            if (retobj) {
//                _mproprice.text = @"请选择优惠券";
//                _mproprice.textColor = [UIColor colorWithWhite:0.416 alpha:1.000];
//            }else{
//                _mproprice.text = @"无可用优惠券";
//                _mproprice.textColor = [UIColor colorWithWhite:0.416 alpha:1.000];
//            }
//            
////            [self getComputerDat:YES];
//
//        }];
        
        [self getComputerDat:YES];
        
    }
    else
        [self getComputerDat:YES];
   
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

-(void)getComputerDat:(BOOL)failedback
{//获取计算结果
    NSMutableArray* tt = NSMutableArray.new;
    for (SCarGoods *goods in _mGoodsAry) {
        [tt addObject:@( goods.mId )];
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    
    //计算购物车价格 promotionSn 优惠卷 carids 购物车编号(数组)
    [SOrderCompute computerInfo:[NSString stringWithFormat:@"%d",_selectpro.mId] carids:tt block:^(SResBase *resb, SOrderCompute *retobj) {
        
       
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            _cheakInfo = [SOrderCompute yy_modelWithJSON:resb.mdata];
            
            _mtagcomp = retobj;
            
            [self loadData];
            
            if(_cheakInfo. isCard){
                [self setCard];
        if(!_cheakInfo.isBind){
                self.numH.constant=40;
                self.pushH.constant=130;
                self.numView.alpha =1;
                }
            }
            [self layoutPayView];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            if( failedback )
                [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.8f];
        }
    }];
    
}


- (void)loadData{
       if (_mSAddress) {
        defaultAddress = _mSAddress;
    }else{
        
        //优先使用 首页选择的,如果没有,再用默认地址
        defaultAddress = [SAppInfo shareClient].mSelectAddrObj;
        if( ![defaultAddress isVaildAddress] )//可能是首页的一个定位地址,,这种不能用来收货
            defaultAddress = [SAddress loadDefault];
        
    }
    
    if( defaultAddress == nil){
    
        _mNoAddress.hidden = NO;
        _mName.hidden = YES;
        _mPhone.hidden = YES;
        _mAddress.hidden = YES;
    }else{
        _mNoAddress.hidden = YES;
        _mName.hidden = NO;
        _mPhone.hidden = NO;
        _mAddress.hidden = NO;
        _mName.text = defaultAddress.mName;
        _mPhone.text = defaultAddress.mMobile;
        _mAddress.text = defaultAddress.mAddress;
    }
    
    
    int num = 0;
    
    //使用计算的的价格,
    for (SCarGoods *goods in _mGoodsAry) {
        
        num += goods.mNum;
        //NSLog(@"使用计算的的价格==%d",num);
//        price += (goods.mPrice*goods.mNum);
        
    }
    
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%d件",num]];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(0,1)];
    [attriString addAttribute:NSForegroundColorAttributeName value:M_TCO range:NSMakeRange(attriString.length-1,1)];
    
    _mNum.attributedText = attriString;
    
    for (UIImageView *imgV in _mImgBgView.subviews) {
        
        if ([imgV isKindOfClass:[UIImageView class]]) {
            
            for (int i = 0; i < _mGoodsAry.count; i++) {
                
                SCarGoods *goods = [_mGoodsAry objectAtIndex:i];
                
                if (imgV.tag -10 ==i) {
                    
                    [imgV sd_setImageWithURL:[NSURL URLWithString:goods.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
                }
            }
        }
    }
    
    if(_mGoodsAry.count>0){
    
        SCarGoods *goods = [_mGoodsAry objectAtIndex:0];
        
        if (goods.mType == 2) {
            
            _mPeisonText.text = @"服务时间";
            _mTimeText.text = @"服务时间";
            _mPeiSonViewHeight.constant = 0;
            _mPeison.text = @"";
            _SumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
            _mYunFeiHeight.constant = 0;
            
            _mHeJi.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
            
        }
        

    }

    [self setTextField:_mHeKa];
    [self setTextField:_mFaPiao];
    [self setTextField:_mBeiZhu];
    
    _mPrice.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mGoodsFee];
    _mYunFei.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mFreight];
    
    _SumPrice.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
    _mHeJi.text = [NSString stringWithFormat:@"¥%.2f",_mtagcomp.mPayFee];
    
    
    
    if( _orgpricecolor == nil )
        
        
        _orgpricecolor = _mproprice.textColor;
    
    if( _selectpro == nil )
    {
        NSLog(@"_mtagcomp.todayUsed====%d",_mtagcomp.todayUsed);
        if(_cheakInfo.todayUsed){
            _mproprice.text = @"当日优惠券限用一张已使用";
            _mproprice.textColor = [UIColor colorWithWhite:0.416 alpha:1.000];
        }else{
        if (_mtagcomp.mPromotionCount) {
            _mproprice.text = @"请选择优惠券";
            _mproprice.textColor = [UIColor colorWithWhite:0.416 alpha:1.000];
        }else{
            _mproprice.text = @"无可用优惠券";
            _mproprice.textColor = [UIColor colorWithWhite:0.416 alpha:1.000];
        }
        }
    }
    else
    {
        _mproprice.text = [NSString stringWithFormat:@"-%.2f",_selectpro.mMoney];
        _mproprice.textColor = _orgpricecolor;
    }
    
   

}

- (void)setTextField:(UITextField *)txf{

    txf.layer.borderColor = COLOR(206, 206, 207).CGColor;
    txf.layer.borderWidth = 0.5;
    
    
    CGRect frame = [txf frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    txf.leftViewMode = UITextFieldViewModeAlways;
    txf.leftView = leftview;
}

- (void)layoutPayView{

    float height = 0;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    _allpayment = NSMutableArray.new;
    
    SPayment *payment = SPayment.new;
    payment.mName  = @"在线支付";
    payment.mDefault = 1;
    payment.mCode = @"z";
    [_allpayment addObject:payment];
    
    if( _mtagcomp.mIsCashOnDelivery )
    {
        payment = SPayment.new;
        payment.mName  = @"货到付款";
        payment.mCode = @"h";
        [_allpayment addObject: payment];
        
    }
    
    for (int i = 0; i < _allpayment.count; i++) {
        
        SPayment *payment = [_allpayment objectAtIndex:i];
        
        UIButton *wxBT = [[UIButton alloc] initWithFrame:CGRectMake(0, height, DEVICE_Width, 55)];
        [contentView addSubview:wxBT];
        wxBT.tag = i;
        [wxBT addTarget:self action:@selector(choosePayClick:) forControlEvents:UIControlEventTouchUpInside];

        //不需要ICON
//        UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 39, 39)];
//        [imgV1 sd_setImageWithURL:[NSURL URLWithString:payment.mIconName] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
//        [wxBT addSubview:imgV1];
        
//        UILabel *wxLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+10, 0, 200, 55)];
        UILabel *wxLB = [[UILabel alloc] initWithFrame:CGRectMake( 0+10, 0, 200, 55)];
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
        [contentView addSubview:line2];
        
        
        height = CGRectGetMaxY(line2.frame);
        
    }
    
    contentView.frame = CGRectMake(0, 40, DEVICE_Width, height);
    contentView.tag = 99;
    [[_mPayView viewWithTag:99] removeFromSuperview];//把之前的删除了,,
    [_mPayView addSubview:contentView];
    
    _mPayViewHeight.constant = 40+height;
}



- (void)goPay:(SOrderObj *)order{
    
    //去支付,这里不应该支付了,应该直接到payview界面..
    PayView * vc = [[PayView alloc]initWithNibName:@"PayView" bundle:nil];
    vc.mTagOrder = order;
    if(_cheakInfo.isCard){
        vc.type=@"1";
    }
    [self setToViewController:vc];
    return;
    /*
    if ([payType isEqualToString:@""]) {
        return;
    }

        [SVProgressHUD showWithStatus:@"正在支付..." maskType:SVProgressHUDMaskTypeNone];
        [order payIt:payType block:^(SResBase *retobj) {
            
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
     */
}

-(void)payOk
{
    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
    pay.mTOrder = myOrder;
    pay.mIsOK = YES;
    pay.mPayType = payType;
    
    [self pushViewController:pay];
    
}

- (void)payNO{
    PayStateVC *pay = [[PayStateVC alloc] initWithNibName:@"PayStateVC" bundle:nil];
    pay.mTOrder = myOrder;
    pay.mPayType = payType;
    pay.mIsOK = NO;
    [self pushViewController:pay];
    
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
    
    
    SPayment *payment = [_allpayment objectAtIndex:btnn.tag];
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

- (IBAction)GoAddressClick:(id)sender {
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddressVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    
    viewController.itblock = ^(SAddress* retobj){
        if( retobj )
        {
            
            defaultAddress  = retobj;
            _mNoAddress.hidden = YES;
            _mName.hidden = NO;
            _mPhone.hidden = NO;
            _mAddress.hidden = NO;
            _mName.text = defaultAddress.mName;
            _mPhone.text = defaultAddress.mMobile;
            _mAddress.text = defaultAddress.mAddress;
            
            
        }
        
    };
    [self pushViewController:viewController];;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.numField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.numField.text.length >= 12) {
            self.numField   .text = [textField.text substringToIndex:12];
            return NO;
        }
        
    }
     return YES;
}

- (IBAction)GoPayClick:(id)sender {
    if(_cheakInfo. isCard){
      
        if(!_cheakInfo.isBind){
          
            if(self.numField.text.length!=12){
                [SVProgressHUD showErrorWithStatus:@"首次需要输入12位会员卡卡号"];
                return;
            }
            
        }
    }

    
    if ( [_TagY isEqualToString:@"0"]){
        if(_timeText.text.length==0){
            
            [SVProgressHUD showErrorWithStatus:@"未选择配送时间"];
            return;
        }
    }else{
       _timeText.text=@"0";
    }
    
    
    NSMutableArray *idAry = NSMutableArray.new;
    for (SCarGoods *goods in _mGoodsAry) {
        
        [idAry addObject:[NSString stringWithFormat:@"%d",goods.mId]];
    }
    
    
    int bonelinepay = [payType isEqualToString:@"z"];
    
    if (myOrder) {
        //订单已经创建成功,这种情况不应该出现
        if(myOrder.mIsCanPay)
            [self goPay:myOrder];
    }
    else
    {
        NSString * cardNo=@"0";
        if(_cheakInfo. isCard){
            
            if(!_cheakInfo.isBind){
                
               
                    cardNo =self.numField.text;
                
               
            }
        }

        [SVProgressHUD showWithStatus:@"处理中.." maskType:SVProgressHUDMaskTypeClear];

        [SOrderObj dealOneOrder:idAry
                      addressId:defaultAddress.mId
                    giftContent:_mHeKa.text
                         cardNO:cardNo
                   invoiceTitle:_mFaPiao.text
                      buyRemark:_mBeiZhu.text
                        appTime:[Util getDataString:_timeText.text bfull:NO]
                    bonelinepay:bonelinepay
                  promotionSnId:[NSString stringWithFormat:@"%d",_selectpro.mId]
                          block:^(SResBase *resb, SOrderObj *retobj) {
            
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                myOrder = retobj;
                if(myOrder.mIsCanPay){
                    [self goPay:retobj];
                   
                }else{
                    
                    [OrderDetailVC whereToGo:myOrder vc:self];
                }
                
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
    }

}

- (IBAction)mTimeClick:(id)sender {
    
    if (!datePic) {
        datePic = [[DatePicker alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
        datePic.backgroundColor = [UIColor whiteColor];
    }
    
    datePic.hidden = NO;
    
    [datePic SetTextFieldDate:_timeText];
    [datePic setDatePickerType:UIDatePickerModeDateAndTime dateFormat:@"yyyy-MM-dd HH:mm"];
    
    [datePic showInView:self.view];
    
    
}

- (IBAction)mChooseCoupon:(id)sender {
    
//    if(_mtagcomp.){
//        
//    }
    if(_cheakInfo.todayUsed){
    }
    else{
    myYouHuiJuan* vc = [[myYouHuiJuan alloc]initWithNibName:@"myYouHuiJuan" bundle:nil];
    vc.mselect = YES;
    vc.mSellerId = _mtagcomp.mSellerId;
    vc.mMoney = _mtagcomp.mTotalMoney;
    vc.mitblock = ^(SPromotion* selectobj)
    {
        _selectpro = selectobj;
        
        [self getComputerDat:NO];
        
    };
    
    [self pushViewController:vc];
    }
}









@end
