//
//  SellerDetailView.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/25.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "SellerDetailView.h"
#import "SDCycleScrollView.h"
#import "RestaurantVC.h"
#import "CustomBtn.h"
#import "TAPageControl.h"
#import "ServiceDetailVC.h"
#import "RestaurantDetailVC.h"
#import "AdvView.h"

@interface SellerDetailView ()<SDCycleScrollViewDelegate>{

    SDCycleScrollView *cycleScrollView;
    
    NSArray *_bannerAry;
    
    TAPageControl *pageControl;
    
    BOOL isCollect;
    
    AdvView *advView;
    
    NSString *AdvString;
}

@end

@implementation SellerDetailView

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    
    
    self.mPageName = @"商家详情";
    self.Title = self.mPageName;
    
    
   [self addMEmptyView:self.view rect:CGRectZero];
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [_mSeller getDetail:^(SResBase *info) {
        if (info.msuccess) {
            [SVProgressHUD dismiss];
            [self loadTop];
            
            self.mPageName = _mSeller.mName;
            self.Title = self.mPageName;
            
            [self removeMEmptyView];
        }else{
        
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
}

- (void)rightBtnTouched:(id)sender{
    
    if ([SUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"操作中" maskType:SVProgressHUDMaskTypeClear];
    
    [_mSeller favIt:^(SResBase *resb) {
        
        
        if (resb.msuccess) {
            
            isCollect = !isCollect;
            
            if (isCollect) {
                self.rightBtnImage = [UIImage imageNamed:@"shoucang"];
            }else{
                self.rightBtnImage = [UIImage imageNamed:@"shoucangno"];
            }
            
            [SVProgressHUD showSuccessWithStatus:resb.mmsg];
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)loadTop{
    
    
    if (_mSeller.mIsCollect) {
        
        self.rightBtnImage = [UIImage imageNamed:@"shoucang"];
        isCollect = YES;
    }else{
        self.rightBtnImage = [UIImage imageNamed:@"shoucangno"];
    }
    
    _mLogo.layer.masksToBounds = YES;
    _mLogo.layer.cornerRadius = 35;
    
    [_mLogo sd_setImageWithURL:[NSURL URLWithString:_mSeller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    _mName.text = [NSString stringWithFormat:@"%@",_mSeller.mName];
    
    _mTime.text = [NSString stringWithFormat:@"%@",_mSeller.mBusinessHours];
    
    _mQPrice.text = [NSString stringWithFormat:@"¥%.2f",_mSeller.mServiceFee];
    _mPPrice.text = [NSString stringWithFormat:@"¥%.2f",_mSeller.mDeliveryFee];
    _mPhone.text = [NSString stringWithFormat:@"%@",_mSeller.mMobile];
    _mAddress.text = _mSeller.mAddress;
    
    
    [_mBgImg sd_setImageWithURL:[NSURL URLWithString:_mSeller.mImage] placeholderImage:[UIImage imageNamed:@"sellerBg"]];
    
    if ([_mSeller.mDetail isEqualToString:@""] || _mSeller.mDetail == nil) {
        _mRemark.text = @"暂无介绍";
    }else{
        _mRemark.text = _mSeller.mDetail;
    }
    [SSeller getGongGao:_mSeller.mId block:^(SResBase *info, NSString *content) {
        
        if (info.msuccess) {
            _mAdv.text = content;
            AdvString = content;
            
            if (content.length == 0) {
                _mAdvHeight.constant = 0;
            }

        }else{
            _mAdvHeight.constant = 0;
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
    

    
    [self loadBottom];
    
}

- (void)loadBottom{
    
    NSMutableArray *arry = [[NSMutableArray alloc] initWithCapacity:0];

    if (_mSeller.mCountGoods>0) {
        
        [arry addObject:@"选择商品"];
    }
    
    if (_mSeller.mCountService>0) {
        [arry addObject:@"选择服务"];
    }
    
    UIButton *fwBT = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width/2, 50)];
    [fwBT setTitle:@"选择服务" forState:UIControlStateNormal];
    fwBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [fwBT setBackgroundColor:M_CO];
    [fwBT addTarget:self action:@selector(goServiceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mButtonView addSubview:fwBT];
    
    UIButton *spBT = [[UIButton alloc] initWithFrame:CGRectMake(DEVICE_Width/2+1, 0, DEVICE_Width/2-1, 50)];
    [spBT setTitle:@"选择商品" forState:UIControlStateNormal];
    spBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [spBT setBackgroundColor:M_CO];
    [spBT addTarget:self action:@selector(goGoodsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mButtonView addSubview:spBT];
    
    if (arry.count == 1) {
        
        if ([[arry objectAtIndex:0] isEqualToString:@"选择服务"]) {
            
            fwBT.frame = CGRectMake(0, 0, DEVICE_Width, 50);
            spBT.hidden = YES;
        }else{
            spBT.frame = CGRectMake(0, 0, DEVICE_Width, 50);
            fwBT.hidden = YES;
        }
    }else if (arry.count == 0)
    {
        spBT.frame = CGRectMake(0, 0, DEVICE_Width, 50);
        fwBT.hidden = YES;
    }
}

- (void)goServiceClick:(UIButton *)sender{

        
    ServiceDetailVC *serviceVC = [[ServiceDetailVC alloc] init];
    serviceVC.mSeller = _mSeller;
    [self pushViewController:serviceVC];


}

- (void)goGoodsClick:(UIButton *)sender{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
    viewController.mSeller = _mSeller;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    SMainFunc *func = [_bannerAry objectAtIndex:index];
    
    switch (func.mType) {
            
        case 1://商户类型
        {
            RestaurantVC *viewController = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
            viewController.mGoodsId = [func.mArg intValue];
            viewController.mGoodsName = func.mName;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
            
            
        case 2://服务类型
        {
            
            
            
        }
            break;
        case 3://商品详情
        {
            
            
        }
            break;
        case 4:{//商家详情
            
            
            
        }
            
            break;
        case 5:{//URL
            
            WebVC* vc = [[WebVC alloc] init];
            vc.mName = func.mName;
            vc.mUrl = func.mArg;
            [self pushViewController:vc];
            
        }
            
            break;
            
        default:
            break;
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

- (void)CloseClick:(UIButton *)sender{
    
    [advView hiddenView];
}

- (IBAction)CallClick:(id)sender {
    NSMutableString * string=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mSeller.mMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (IBAction)mAdvClick:(id)sender {
    
    advView = [[AdvView alloc] init];
    
    [advView showInView:self.view title:nil content:AdvString];
    
    [advView.mCloseBT addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
}
@end
