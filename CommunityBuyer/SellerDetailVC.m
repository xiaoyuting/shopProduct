//
//  SellerDetailVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "SellerDetailVC.h"
#import "ChoseView.h"
#import "JSBadgeView.h"
#import "BalanceVC.h"
#import "DatePicker.h"
#import "SellerDetailView.h"

#import "ShopCarVC.h"
@interface SellerDetailVC ()<UIWebViewDelegate>{

    UIView *maskView;
    ChoseView *choseView;
    UIButton *tempBT;
    
    int sunNum;
    float sumPrice;
    
    JSBadgeView *badgeView;
    
    DatePicker *datePic;

    
    int goCarNum;

}

@end

@implementation SellerDetailVC

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"商品详情";
    self.Title = self.mPageName;
    
    goCarNum = 0;

   
    
    sunNum = _mSumNum;
    sumPrice = _mSumprice;
    
    
    [self updateInfo];
    
}

- (void)updateInfo{
    
   

    if (_mType == 1) {
        
        _mTypeDetail.text = @"商品详情";
        _mTopHeight.constant = 7;
        _mSellNum.text = @"";
        
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
        [_mGoods getDetail:^(SResBase *info) {
            
            if (info.msuccess) {
                
                [SVProgressHUD dismiss];
                self.mPageName = _mGoods.mName;
                self.Title = self.mPageName;
                _mTimeHeight.constant = 0;
                
                NSString *url = @"";
                if (_mGoods.mLogo) {
                    url = _mGoods.mLogo;
                }
                if (_mGoods.mImages.count>0) {
                    url = [_mGoods.mImages objectAtIndex:0];
                }
                
                [_mImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"DefualtImg"]];
                _mName.text = _mGoods.mName;
                _mPrice.text = [NSString stringWithFormat:@"¥%.2f",_mGoods.mPrice];
                
                if (_mSeller.mName) {
                    _mAddress.text = [NSString stringWithFormat:@"%@",_mSeller.mName];
                }else{
                    _mAddress.text = @"";
                }
                
                if (_mGoods.mSalesCount>0) {
                    _mSellNum.text = [NSString stringWithFormat:@"已售 %d",_mGoods.mSalesCount];
                }else{
                    _mSellNum.text = @"";
                }
                
                _mWebView.delegate = self;
                [SVProgressHUD showWithStatus:@"加载中..."];
                [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_mGoods.mUrl]]];
                
                
                self.rightBtnImage = _mGoods.mIscollect?[UIImage imageNamed:@"shoucang"]:[UIImage imageNamed:@"shoucangno"];
            }else{
            
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
        
        
    }else{
        
        _mTypeDetail.text = @"服务详情";
        _mSellNum.text = @"";
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
        [_mServiceInfo getDetail:^(SResBase *resb) {
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                
                self.mPageName = _mServiceInfo.mName;
                self.Title = self.mPageName;
                
                [_mImg sd_setImageWithURL:[NSURL URLWithString:_mServiceInfo.mLogo] placeholderImage:[UIImage imageNamed:@"DefualtImg"]];
                _mName.text = _mServiceInfo.mName;
                _mPrice.text = [NSString stringWithFormat:@"¥%.2f",_mServiceInfo.mPrice];
                _mAddress.text = [NSString stringWithFormat:@"%@",_mServiceInfo.mName];
                
                if (_mServiceInfo.mSalesCount>0) {
                    _mSellNum.text = [NSString stringWithFormat:@"已售 %d",_mServiceInfo.mSalesCount];
                }else{
                    _mSellNum.text = @"";
                }
                
                _mWebView.delegate = self;
                [SVProgressHUD showWithStatus:@"加载中..."];
                [_mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_mServiceInfo.mUrl]]];
                
                self.rightBtnImage = _mServiceInfo.mIsCollect?[UIImage imageNamed:@"shoucang"]:[UIImage imageNamed:@"shoucangno"];
            }else{
            
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
        }];
        
       
    }
    
    badgeView.layer.masksToBounds = YES;
    badgeView.layer.cornerRadius = 10;
    badgeView = [[JSBadgeView alloc] initWithParentView:_mCarBt alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgePositionAdjustment = CGPointMake(0, 5);
    badgeView.badgeStrokeWidth = 5;
    
    if (sunNum<=0) {
        badgeView.hidden = YES;
    }else{
        badgeView.hidden = NO;
    }
    
    badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
    
    
    
    if ((_mGoods.mNorms.count == 1 && _mGoods.mCount > 0 && _mType == 1) || (_mServiceInfo.mNum > 0 && _mType == 2)) {
        _mDelButton.hidden = NO;
        _mNum.hidden = NO;
        _mNum.text = [NSString stringWithFormat:@"%d",_mGoods.mCount];
    }else{
        _mDelButton.hidden = YES;
        _mNum.hidden = YES;
    }
    
    
    if (_mType == 1) {
        
        if(sunNum<=0){
            //        badgeView.badgeText = @"购物车空空如也";
            badgeView.hidden = YES;
            _mSumPrice.text = @"购物车空空如也";
            _mSumPrice.font = [UIFont systemFontOfSize:14];
        }else{
            
            badgeView.hidden = NO;
            _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f元",sumPrice];
            _mSumPrice.font = [UIFont systemFontOfSize:20];
        }
        
        badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
        
        [_mBT setTitle:@"选好了" forState:UIControlStateNormal];
        [_mBT setBackgroundColor:M_CO];
        _mBT.enabled = YES;
        if (sumPrice < _mSeller.mServiceFee) {
            [_mBT setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
            [_mBT setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
            _mBT.enabled = NO;
        }


    }
   
   
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    CGRect frame = _mWebView.frame;
    frame.size.height = 1;
    _mWebView.frame = frame;
    CGSize fittingSize = [_mWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
//    _mWebView.frame = frame;
    _mWebViewHeight.constant = fittingSize.height;
    
     _mWebView.scrollView.scrollEnabled = YES;
    
    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:error.description];
}
- (void)rightBtnTouched:(id)sender{

    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    
    if (_mType == 1) {
        
        [_mGoods favIt:^(SResBase *info) {
            
            if (info.msuccess) {
                [SVProgressHUD showSuccessWithStatus:info.mmsg];
                
                 self.rightBtnImage = _mGoods.mIscollect?[UIImage imageNamed:@"shoucang"]:[UIImage imageNamed:@"shoucangno"];
            }else{
                
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
    }else{
    
        [_mServiceInfo favIt:^(SResBase *info) {
            
            if (info.msuccess) {
                [SVProgressHUD showSuccessWithStatus:info.mmsg];
                
               self.rightBtnImage = _mServiceInfo.mIsCollect?[UIImage imageNamed:@"shoucang"]:[UIImage imageNamed:@"shoucangno"];
            }else{
                
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
    }
    
}

- (void)JiaClick:(CellButton *)sender{
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        if (!tempBT) {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
            
            return;
        }
        
        goCarNum ++;
        choseView.mNum.text = [NSString stringWithFormat:@"%d",goCarNum];
        
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        sender.mGoods.mNormId = norm.mId;
        norm.mCount = goCarNum;
    }

    
    
}

- (void)JianClick:(CellButton *)sender{
    
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        if (!tempBT) {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
            
            return;
        }
        
        if (goCarNum>0) {
            
            goCarNum --;
            choseView.mNum.text = [NSString stringWithFormat:@"%d",goCarNum];
        }
        
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        sender.mGoods.mNormId = norm.mId;
        norm.mCount = goCarNum;
    }

    
}

- (void)AddCarClick:(CellButton *)sender{
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    
    if (goCarNum<=0) {
        
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品数量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alt show];
        
        return;
    }
    
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        
        sender.mGoods.mNormId = norm.mId;
        
    }
    sender.mGoods.mCount = goCarNum;
    
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [sender.mGoods addToCart:norm block:^(SResBase *info, NSArray *all){
        
        if (info.msuccess) {
            
        
            
            sunNum = 0;
            sumPrice = 0;
            
            if (all.count > 0) {
                
                for (SCarSeller *seller in all) {
                    
                    for (SCarGoods *goods in seller.mCarGoods) {
                        sunNum += goods.mNum;
                        sumPrice += goods.mPrice*goods.mNum;
                    }
                }
            }
            
            
            
            
            if (sunNum == 0) {
                badgeView.hidden = YES;
            }else{
                badgeView.hidden = NO;
            }
            badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
            _mNum.text = [NSString stringWithFormat:@"%d",_mGoods.mCount];
            
            if(sunNum<=0){
                //        badgeView.badgeText = @"购物车空空如也";
                badgeView.hidden = YES;
                _mSumPrice.text = @"购物车空空如也";
                _mSumPrice.font = [UIFont systemFontOfSize:14];
            }else{
                
                badgeView.hidden = NO;
                _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f元",sumPrice];
                _mSumPrice.font = [UIFont systemFontOfSize:20];
            }
            
            [_mBT setTitle:@"选好了" forState:UIControlStateNormal];
            [_mBT setBackgroundColor:M_CO];
            _mBT.enabled = YES;
            if (sumPrice < _mSeller.mServiceFee) {
                [_mBT setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
                [_mBT setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
                _mBT.enabled = NO;
            }
            
            [SVProgressHUD showSuccessWithStatus:info.mmsg];
            
            [self closeChoseView];
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
    
}

- (void)BuyClick:(CellButton *)sender{
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        
        sender.mGoods.mNormId = norm.mId;
        
    }
    
    sender.mGoods.mCount = goCarNum;
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [sender.mGoods addToCart:norm block:^(SResBase *info, NSArray *all){
        
        if (info.msuccess) {
            
            if (all.count>0) {
                
                [SVProgressHUD dismiss];
                

                SCarSeller *carseller = [all objectAtIndex:0];
                
                
                NSMutableArray *goodsAry = NSMutableArray.new;
                
                
                for (SCarSeller *carseller in all) {
                    for (SCarGoods *cargoods in carseller.mCarGoods) {
                        
                        if (cargoods.mGoodsId == sender.mGoods.mId) {
                            
                            if (cargoods.mNum>0) {
                                [goodsAry addObject:cargoods];
                            }
                        }
                    }
                }
                
                if(goodsAry.count == 0){
                    
                    [SVProgressHUD showErrorWithStatus:@"请选择商品"];
                    
                    return;
                }
                
                BalanceVC *balance = [[BalanceVC alloc] initWithNibName:@"BalanceVC" bundle:nil];
                balance.mGoodsAry = goodsAry;
                balance.mCarSeller = carseller;
                
                [self pushViewController:balance];
                
                [self closeChoseView];
            }else{
                
               [SVProgressHUD showErrorWithStatus:@"请选择商品"];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
    
}

-(void)closeChoseView
{
    
    [UIView animateWithDuration:0.2 animations:^{
        //     EditTempBtn = nil;
        maskView.alpha = 0.0f;
        CGRect rect = choseView.frame;
        rect.origin.y = DEVICE_Height+50;
        choseView.frame =rect;
        
    } completion:^(BOOL finished) {
        [choseView removeFromSuperview];
        [maskView removeFromSuperview];
        tempBT = nil;
        
    }];
    
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

- (IBAction)mOKClick:(id)sender {
    
    [ShopCarVC willMarkAll];
    
    self.tabBarController.selectedIndex = 1;
    [self popToRootViewController];
}

- (IBAction)mChoseClick:(id)sender {
    
    [self layoutChoseView:_mGoods];
}

- (IBAction)mTimeClick:(id)sender {
    
    if (!datePic) {
        datePic = [[DatePicker alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
        datePic.backgroundColor = [UIColor whiteColor];
    }
    
    datePic.hidden = NO;
    
    [datePic SetTextFieldDate:_mServiceTime];
    [datePic setDatePickerType:UIDatePickerModeDateAndTime dateFormat:@"yyyy-MM-dd hh:mm"];
    
    
    [datePic showInView:self.view];
}


- (IBAction)mGoDetailClick:(id)sender {
    
    WebVC* vc = [[WebVC alloc] init];
    vc.mName = _mGoods.mName;
    vc.mUrl = _mGoods.mUrl;
    [self pushViewController:vc];
    
}

- (IBAction)mDelClick:(id)sender {
    
    [self dealNum:-1];
}

- (void)dealNum:(int)num{
    
   
        if ([SUser isNeedLogin]) {
            [self gotoLoginVC];
            return;
        }

    if (_mType == 1) {
        
        if ( _mGoods.mNorms.count>1) {
            
            [self layoutChoseView:_mGoods];
            
            return;
        }
        
        
            
        _mGoods.mCount +=num;
        SGoodsNorms* tmpnorm = SGoodsNorms.new;
        tmpnorm.mId = 0;
        tmpnorm.mCount = _mGoods.mCount;
        [SVProgressHUD showWithStatus:@"添加到购物车中" maskType:SVProgressHUDMaskTypeClear];
        [_mGoods addToCart:tmpnorm block:^(SResBase *info, NSArray *all){
            
            if (info.msuccess) {
                
                [SVProgressHUD dismiss];
                
                sunNum = 0;
                sumPrice = 0;
                
                if(all.count>0){
                
                    for (SCarSeller *seller in all) {
                        
                        if (seller.mId == _mSeller.mId) {
                            for (SCarGoods *goods in seller.mCarGoods) {
                                
                                sunNum += goods.mNum;
                                sumPrice += goods.mPrice*goods.mNum;
                            }
                        }
                    }
                    
                }
                
                
               
                
                if (sunNum>0) {
                    badgeView.hidden = NO;
                }else{
                    badgeView.hidden = YES;
                }
                
                badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
                _mNum.text = [NSString stringWithFormat:@"%d",_mGoods.mCount];
                
                if (_mType == 1) {
                    
                    if(sunNum<=0){
                        //        badgeView.badgeText = @"购物车空空如也";
                        badgeView.hidden = YES;
                        _mSumPrice.text = @"购物车空空如也";
                        _mSumPrice.font = [UIFont systemFontOfSize:14];
                    }else{
                        
                        badgeView.hidden = NO;
                        _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f元",sumPrice];
                        _mSumPrice.font = [UIFont systemFontOfSize:20];
                    }
                    
                    badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
                    
                    [_mBT setTitle:@"选好了" forState:UIControlStateNormal];
                    [_mBT setBackgroundColor:M_CO];
                    _mBT.enabled = YES;
                    if (sumPrice < _mSeller.mServiceFee) {
                        [_mBT setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
                        [_mBT setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
                        _mBT.enabled = NO;
                    }

                }

                
                if (_mGoods.mNorms.count == 1 && _mGoods.mCount > 0) {
                    _mDelButton.hidden = NO;
                    _mNum.hidden = NO;
                    _mNum.text = [NSString stringWithFormat:@"%d",_mGoods.mCount];
                }else{
                    _mDelButton.hidden = YES;
                    _mNum.hidden = YES;
                }
                
            }else{
                _mServiceInfo.mNum-=num;
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
        
        
        
    }else{
        
        
        if (_mServiceTime.text.length<=0) {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择服务时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
            return;
        }
        if ((num == -1 && _mServiceInfo.mNum>0) || (_mServiceInfo.mNum >=0 && num ==1)) {
        
        
            _mServiceInfo.mNum +=num;
            [SVProgressHUD showWithStatus:@"添加到购物车中" maskType:SVProgressHUDMaskTypeClear];
            [_mServiceInfo addToCart:_mServiceTime.text block:^(SResBase *info, NSArray *all){
                
                if (info.msuccess) {
                    
                    [SVProgressHUD dismiss];
                    
                    sunNum = 0;
                    sumPrice = 0;
                    
                    for (SCarSeller *carseller in all) {
                        for (SCarGoods *cargoods in carseller.mCarGoods) {
                            
                            sunNum += cargoods.mNum;
                            sumPrice += cargoods.mPrice*cargoods.mNum;
                        }
                    }
                    
                    if (_mServiceInfo.mNum > 0) {
                        _mDelButton.hidden = NO;
                        _mNum.hidden = NO;
                        _mNum.text = [NSString stringWithFormat:@"%d",_mGoods.mCount];
                    }else{
                        _mDelButton.hidden = YES;
                        _mNum.hidden = YES;
                    }
                    
                    if (sunNum>0) {
                        badgeView.hidden = NO;
                    }else{
                        badgeView.hidden = YES;
                    }
                    badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
                    _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f元",sumPrice];
                    _mNum.text = [NSString stringWithFormat:@"%d",_mServiceInfo.mNum];
                    
                }else{
                    _mServiceInfo.mNum-=num;
                    [SVProgressHUD showErrorWithStatus:info.mmsg];
                }
            }];

        }
    }
    


}

- (IBAction)mAddClick:(id)sender {
    
    [self dealNum:1];
    
}


-(void)layoutChoseView:(SGoods *)goods
{

    [SCarSeller getCarInfoWithGoods:goods];//获取对应商品在购物车内数量
    
    CGRect rect = self.view.bounds;
    rect.size.height -=50;
    maskView = [[UIView alloc]initWithFrame:rect];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.0;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeChoseView)];
    [maskView addGestureRecognizer:ges];
    [self.view addSubview:maskView];
    
    choseView = [ChoseView shareView];
    [choseView.mImg sd_setImageWithURL:[NSURL URLWithString:[goods.mImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    NSString *str = @"";
    float xx = 0;
    float yy = 0;
    float height = 0;
    if(goods.mNorms.count>1){
        
        SGoodsNorms *norm = [goods.mNorms objectAtIndex:0];
        choseView.mPrice.text = [NSString stringWithFormat:@"¥%.2f",norm.mPrice];
        choseView.mNumKu.text = [NSString stringWithFormat:@"库存%d件",norm.mStock];
        
        for (int i = 0;i < goods.mNorms.count;i++) {
            
            SGoodsNorms *norm = [goods.mNorms objectAtIndex:i];
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ ",norm.mName]];
            
            
            if (xx+ norm.mName.length*15+20 >DEVICE_Width-23) {
                
                xx = 0 ;
                yy +=40;
            }
            
            CellButton *button = [[CellButton alloc] initWithFrame:CGRectMake(xx, yy, norm.mName.length*15+20, 30)];
            button.mGoods = goods;
            [button setTitle:norm.mName forState:UIControlStateNormal];
            [button setTitleColor:COLOR(107, 107, 109) forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor whiteColor]];
            button.layer.borderColor = COLOR(107, 107, 109).CGColor;
            button.layer.borderWidth = 0.5;
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(GuigeClick:) forControlEvents:UIControlEventTouchUpInside];
            
            xx += button.frame.size.width+15;
            
            [choseView.mGuigeView addSubview:button];
            
        }
        height = yy+30;
    }
    choseView.mGuigeHeight.constant = height;
    
    choseView.mGuige.text = [NSString stringWithFormat:@"请选择%@",str];
    
    choseView.mJiaBT.mGoods = goods;
    [choseView.mJiaBT addTarget:self action:@selector(JiaClick:) forControlEvents:UIControlEventTouchUpInside];
    choseView.mJianBT.mGoods = goods;
    [choseView.mJianBT addTarget:self action:@selector(JianClick:) forControlEvents:UIControlEventTouchUpInside];
    choseView.mJiaCar.mGoods = goods;
    [choseView.mJiaCar addTarget:self action:@selector(AddCarClick:) forControlEvents:UIControlEventTouchUpInside];
    
    choseView.mBuy.mGoods = goods;
    [choseView.mBuy addTarget:self action:@selector(BuyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    choseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:choseView];
    CGRect rect2 = choseView.frame;
    rect2.origin.y = DEVICE_Height;
    rect2.size.width = DEVICE_Width;
    rect2.size.height +=(height-35);
    choseView.frame = rect2;
    
    [choseView.mClose addTarget:self action:@selector(closeChoseView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        maskView.alpha = 0.5;
        CGRect rect2 = choseView.frame;
        rect2.origin.y = DEVICE_Height-rect2.size.height;
        choseView.frame = rect2;
        
        
    }];
    
}

- (void)GuigeClick:(UIButton *)sender{
    
    tempBT.layer.borderColor = COLOR(107, 107, 109).CGColor;
    tempBT.layer.borderWidth = 0.5;
    [tempBT setTitleColor:COLOR(107, 107, 109) forState:UIControlStateNormal];
    [tempBT setBackgroundColor:[UIColor whiteColor]];
    
    sender.layer.borderWidth = 0;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:M_CO];
    
    SGoodsNorms *norm = [_mGoods.mNorms objectAtIndex:sender.tag];
    choseView.mNum.text = [NSString stringWithFormat:@"%d",norm.mCount];
    goCarNum = norm.mCount;
    tempBT = sender;
    
    choseView.mPrice.text = [NSString stringWithFormat:@"¥%.2f",norm.mPrice];
    choseView.mNumKu.text = [NSString stringWithFormat:@"库存%d件",norm.mStock];
}

@end
