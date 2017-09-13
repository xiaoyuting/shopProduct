//
//  ServiceDetailVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ServiceDetailVC.h"
#import "ServiceCell.h"
#import "CustomBtn.h"
#import "CustomButton.h"
#import "RestaurantVC.h"
#import "SDCycleScrollView.h"
#import "TAPageControl.h"
#import "ServiceHeadView.h"
#import "SellerDetailVC.h"
#import "SellerDetailView.h"

@interface ServiceDetailVC ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>{

    NSMutableArray *mainAry;
    
    
    TAPageControl *pageControl;
    
    SDCycleScrollView *cycleScrollView;
    
    NSArray *_bannerAry;
    
    ServiceHeadView *headView;
    
    
    
}

@end

@implementation ServiceDetailVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    
    self.mPageName = @"店铺详情";
    
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height) delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"ServiceCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = M_BGCO;
    
    headView = [ServiceHeadView shareView];
    [self.tableView setTableHeaderView:headView];
    
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = M_BGCO;
    
    [self addMEmptyView:self.view rect:CGRectZero];
    [_mSeller getDetail:^(SResBase *info) {
        if (info.msuccess) {
            
            self.Title = _mSeller.mName;
            [self loadTopView];
            [self removeMEmptyView];
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
    
//    mainAry = [[NSMutableArray alloc] initWithCapacity:0];
    [self.tableView headerBeginRefreshing];
}

-(void)headerBeganRefresh
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    [_mSeller getServices:^(SResBase *info, NSArray *all) {
        
        [self.tableView headerEndRefreshing];
        
        if (info.msuccess) {
            
            [SVProgressHUD dismiss];
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            
            [self.tableView reloadData];
            
            if (all.count==0) {
//                [self addEmptyViewWithImg:@"noitem"];
                
            }else
            {
                [self removeEmptyView];
            }
            
        }else
        {
            [self addEmptyViewWithImg:@"noitem"];
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
        
    }];
    
}

- (void)loadTopView{
    
    
    [headView.mImg sd_setImageWithURL:[NSURL URLWithString:_mSeller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    headView.mName.text = _mSeller.mName;
    headView.mTime.text = [NSString stringWithFormat:@"营业时间：%@",_mSeller.mBusinessHours];
    
    [headView.mButton addTarget:self action:@selector(GoDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (_mSeller.mBanner.count == 0) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, headView.mTopView.frame.size.height)];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.image = [UIImage imageNamed:@"DefaultBanner"];
        [headView.mTopView addSubview:imageV];
        return;
    }
    
    if (_mSeller.mBanner.count == 1) {
        SMainFunc *func = [_mSeller.mBanner objectAtIndex:0];
        CustomBtn* topadbt = [[CustomBtn alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width, headView.mTopView.frame.size.height)];
        [topadbt sd_setBackgroundImageWithURL:[NSURL URLWithString:func.mImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"DefaultBanner"]];
        topadbt.contentMode = UIViewContentModeScaleAspectFill;
        topadbt.clipsToBounds = YES;
        topadbt.func = func;
        [topadbt addTarget:self action:@selector(mainBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        [headView.mTopView addSubview:topadbt];
        return;
    }
    
    NSMutableArray *bannerAry = NSMutableArray.new;
    for (int i = 0; i < _mSeller.mBanner.count; i++) {
        SMainFunc *func = [_mSeller.mBanner objectAtIndex:i];
        
        [bannerAry addObject:func.mImage];
    }
    
    
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, headView.mTopView.frame.size.width, headView.mTopView.frame.size.height) imagesGroup:bannerAry];
    cycleScrollView.delegate = self;
    [headView.mTopView addSubview: cycleScrollView];
    
    pageControl = [[TAPageControl alloc]initWithFrame:CGRectMake(120,130,100,18)]; // 初始化mypagecontrol
    pageControl.center = cycleScrollView.center;
    CGRect rect = pageControl.frame;
    rect.origin.y = 130;
    pageControl.frame = rect;
    
   
    
}

- (void)GoDetailClick:(UIButton *)sender{

    SellerDetailView *sellerView = [[SellerDetailView alloc] initWithNibName:@"SellerDetailView" bundle:nil];
    sellerView.mSeller = _mSeller;
    [self pushViewController:sellerView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"---点击了第%ld张图片", (long)index);
    SMainFunc *func = [_bannerAry objectAtIndex:index];
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
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
            
            RestaurantVC *viewController = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
            viewController.mGoodsId = [func.mArg intValue];
            viewController.mGoodsName = func.mName;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
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

-(void)mainBtnTouched:(CustomBtn *)sender
{
    
    SMainFunc *func = sender.func;
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
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
            
            RestaurantVC *viewController = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
            viewController.mGoodsId = [func.mArg intValue];
            viewController.mGoodsName = func.mName;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        }
            break;
        case 3://商品详情
        {
            
            WebVC* vc = [[WebVC alloc] init];
            vc.mName = func.mName;
            vc.mUrl = [APIClient wapWithUrl:[NSString stringWithFormat:@"Goods/detail?goodsId=%d",[func.mArg intValue]]];
            [self pushViewController:vc];
        }
            
            break;
        case 4:{//商家详情
            
            SSeller *seller = [[SSeller alloc] init];
            seller.mId = [func.mArg intValue];
            
            SellerDetailView *sellerView = [[SellerDetailView alloc] initWithNibName:@"SellerDetailView" bundle:nil];
            sellerView.mSeller = seller;
            [self pushViewController:sellerView];
            
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
        {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未开通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alt show];
        }
            
            break;
    }
    
    
    
    
}





-(void)nowChoosePage:(NSInteger)page
{
    pageControl.currentPage = page;
    
}

-(void)selectIndex:(NSInteger )index
{
    //    pageControl.currentPage = index;
    
    
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.tempArray.count%2==0?self.tempArray.count/2:self.tempArray.count/2+1;
    
}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ServiceCell *cell = (ServiceCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SServiceInfo * item1 = [self.tempArray  objectAtIndex:indexPath.row*2];
    SServiceInfo *item2;
    if ((indexPath.row+1)*2>self.tempArray.count) {
        
        cell.mRightV.hidden = YES;
        
    }
    else
    {
        item2 = [self.tempArray objectAtIndex:indexPath.row*2+1];
        cell.mRightV.hidden = NO;
        
    }
    
    [cell.mLeftImg sd_setImageWithURL:[NSURL URLWithString:item1.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    [cell.mRightImg sd_setImageWithURL:[NSURL URLWithString:item2.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    
    cell.mLeftName.text = item1.mName;
    cell.mRightName.text = item2.mName;
    
    cell.mLeftTime.text = [NSString stringWithFormat:@"%d分钟",item1.mDuration];
    cell.mRightTime.text = [NSString stringWithFormat:@"%d分钟",item2.mDuration];
    
    cell.mLeftPrice.text = [NSString stringWithFormat:@"¥%.2f",item1.mPrice];
    cell.mRightPrice.text = [NSString stringWithFormat:@"¥%.2f",item2.mPrice];
    
    cell.mLeftBT.tag = item1.mId;
    cell.mLeftBT.mServiceInfo = item1;
    [cell.mLeftBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.mRightBT.tag = item2.mId;
    cell.mRightBT.mServiceInfo = item2;
    [cell.mRightBT addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    return cell;
}


- (void)buttonClick:(CustomButton *)sender{
    
    SellerDetailVC *seller = [[SellerDetailVC alloc] initWithNibName:@"SellerDetailVC" bundle:nil];
    seller.mServiceInfo =  sender.mServiceInfo;
    seller.mType = 2;
    seller.mSeller = _mSeller;
    [self pushViewController:seller];
    
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
