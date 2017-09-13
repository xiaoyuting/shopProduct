//
//  ShopCarVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/22.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ShopCarVC.h"
#import "ShopCarCell.h"
#import "AddressCell.h"
#import "ShopCarHeadView.h"
#import "ShopCarFooterView.h"
#import "AddressVC.h"
#import "BalanceVC.h"
#import "RestaurantDetailVC.h"
#import "ServiceDetailVC.h"
#import "SellerDetailView.h"
#import "SellerDetailVC.h"
@interface ShopCarVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{

    SAddress *DefaultAddress;
    ShopCarFooterView *headView;
}

@end


BOOL g_markall = NO;

@implementation ShopCarVC

+(void)willMarkAll
{
    g_markall =YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hiddenBackBtn = YES;
    
    self.mPageName = @"购物车";
    self.Title = self.mPageName;
    
    SAddress* t = [SAppInfo shareClient].mSelectAddrObj;
    if( ![t isVaildAddress] )//可能是首页的一个定位地址,,这种不能用来收货
        t = [SAddress loadDefault];
    
    DefaultAddress = t;
    
    self.rightBtnImage = [UIImage imageNamed:@"lajitong"];
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_InNavTabBar_Height) delegate:self dataSource:self];
    
    self.haveHeader = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UINib *nib2 = [UINib nibWithNibName:@"ShopCarCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"cell1"];
    
    
    UINib *nib = [UINib nibWithNibName:@"AddressCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"addressCell"];
    
  
    
    [self.tableView headerBeginRefreshing];
    [self addDataChangeNotif];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
-(void)loadAddress:(BOOL)binit
{
    //优先使用 首页选择的,如果没有,再用默认地址
    SAddress* t = [SAppInfo shareClient].mSelectAddrObj;
    if( ![t isVaildAddress] )//可能是首页的一个定位地址,,这种不能用来收货
        t = [SAddress loadDefault];
    
    if( t != DefaultAddress )
    {
        if( !binit && t )
        {
            DefaultAddress = t;
            if( [self tableView:self.tableView numberOfRowsInSection:0] )
            {//如果有数据,就需要刷新购物车
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                
            }
        }
    }
}


-(void)addDataChangeNotif
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doreload:) name:@"ShopCarChanged" object:nil];
}
-(void)doreload:(id)sender
{
    [self.tableView headerBeginRefreshing];
}

- (void)CheckAll{

    for (SCarSeller *s in self.tempArray) {
        s.mIsCheck = g_markall;
        for (SCarGoods *g in s.mCarGoods) {
            g.mIsCheck = g_markall;
        }
    }
    
    [self.tableView reloadData];
    g_markall = NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)rightBtnTouched:(id)sender{

    
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你狠心丢下我吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alt show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0) {
        return;
    }else{
    
        [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
        
        [SCarSeller clearCarInfo:^(SResBase *resb) {
            
            if (resb.msuccess) {
                [SVProgressHUD dismiss];
                [self.tableView headerBeginRefreshing];
                
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                item.badgeValue = nil;
            }else{
                
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];

    }
}

-(void)headerBeganRefresh
{
    
    
    
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [[SUser currentUser] getMyShopCar:^(SResBase *resb, NSArray *all) {
        [self headerEndRefresh];

        if (resb.msuccess) {
            
            [SVProgressHUD dismiss];
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            
            
            if (all.count==0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
            int num = 0;
            for (SCarSeller *carseller in all) {
                carseller.mIsCheck = g_markall;
                for (SCarGoods *cargoods in carseller.mCarGoods) {
                    cargoods.mIsCheck = g_markall;
                    num += cargoods.mNum;
                }
            }
            g_markall = NO;
            
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
            if(num >0)
                item.badgeValue = [NSString stringWithFormat:@"%d",num];
            else
                item.badgeValue = nil;
            
            [self.tableView reloadData];
            
            
            
        }else
        {
            [self CheckAll];
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( all.count == 0 )
        {
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeEmptyView];
        }
        
        [self.tableView reloadData];
        
    }];
    
    
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return self.tempArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.tempArray.count>0) {
            return 1;
        }else{
            return 0;
        }
        
    }
    SCarSeller *car = [self.tempArray objectAtIndex:section-1];
    return car.mCarGoods.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0;
    }
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section ==0) {
        return nil;
    }

    SCarSeller *car = [self.tempArray objectAtIndex:section-1];
    
    ShopCarHeadView *view = [ShopCarHeadView shareView];
    view.mCheck.tag = section-1;
    [view.mCheck addTarget:self action:@selector(SectionClick:) forControlEvents:UIControlEventTouchUpInside];
    view.mName.text = [NSString stringWithFormat:@"%@",car.mName];
    view.mCheck.selected = car.mIsCheck;
    [view.mCheck setImage:[UIImage imageNamed:@"quanhong"] forState:UIControlStateSelected];
    view.mbt.tag = section-1;
    [view.mbt addTarget:self action:@selector(gotoShopInfo:) forControlEvents:UIControlEventTouchUpInside];
    return view;
    
}

-(void)gotoShopInfo:(UIButton*)sender
{
    SCarSeller *carseller = [self.tempArray objectAtIndex:sender.tag];
    
    if(carseller.mCountGoods>0 && carseller.mCountService == 0){
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
        viewController.mSeller = SSeller.new;
        viewController.mSeller.mId = carseller.mId;
        viewController.mSeller.mServiceFee = carseller.mServiceFee;
        viewController.mSeller.mDeliveryFee = carseller.mDeliveryFee;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if(carseller.mCountGoods == 0 && carseller.mCountService > 0){
        
        ServiceDetailVC *serviceVC = [[ServiceDetailVC alloc] init];
        serviceVC.mSeller = SSeller.new;
        serviceVC.mSeller.mId = carseller.mId;
        serviceVC.mSeller.mServiceFee = carseller.mServiceFee;
        serviceVC.mSeller.mDeliveryFee = carseller.mDeliveryFee;
        [self pushViewController:serviceVC];
    }else{
        SellerDetailView *sellerView = [[SellerDetailView alloc] initWithNibName:@"SellerDetailView" bundle:nil];
        sellerView.mSeller = SSeller.new;;
        sellerView.mSeller.mId =carseller.mId;
        sellerView.mSeller.mServiceFee = carseller.mServiceFee;
        sellerView.mSeller.mDeliveryFee = carseller.mDeliveryFee;
        [self pushViewController:sellerView];
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    }
    
    SCarSeller *car = [self.tempArray objectAtIndex:section-1];
    
    headView = [ShopCarFooterView shareView];
    
    headView.mJieSuan.tag = section-1;
    [headView.mJieSuan addTarget:self action:@selector(JieSuanClick:) forControlEvents:UIControlEventTouchUpInside];
    headView.mJieSuan.layer.masksToBounds = YES;
    headView.mJieSuan.layer.cornerRadius = 3;
    BOOL flags = NO;
    for (SCarGoods *g in car.mCarGoods) {
        if (g.mIsCheck) {
            flags = YES;
        }
    }
    
    if (!flags) {
        headView.mJieSuan.enabled = NO;
        headView.mJieSuan.backgroundColor = [UIColor grayColor];
    }else{
        headView.mJieSuan.enabled = YES;
        headView.mJieSuan.backgroundColor = M_CO;
    }
    
    float price = 0;
    for (SCarGoods *goods in car.mCarGoods) {
        price += goods.mPrice*goods.mNum;
    }
    
    headView.mPrice.text = [NSString stringWithFormat:@"¥%.2f",price];
    
    if( ( car.mServiceFee - price ) > 0.001f )
    {
        [headView.mJieSuan setTitle:[NSString stringWithFormat:@"还差%.2f元起送",car.mServiceFee-price] forState:UIControlStateNormal];
        headView.mJieSuan.enabled = NO;
        headView.mJieSuan.backgroundColor = [UIColor grayColor];
    }
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:@"addressCell"];
        
        if ( DefaultAddress == nil) {
            cell.mNoAddress.hidden = NO;
            cell.mName.hidden = YES;
            cell.mPhone.hidden = YES;
            cell.mAddress.hidden = YES;
        }else{
        
            cell.mNoAddress.hidden = YES;
            cell.mName.hidden = NO;
            cell.mPhone.hidden = NO;
            cell.mAddress.hidden = NO;
            cell.mName.text = DefaultAddress.mName;
            cell.mPhone.text = DefaultAddress.mMobile;
            cell.mAddress.text = DefaultAddress.mAddress;
        }
        
        cell.mJiantou.hidden = NO;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    ShopCarCell *cell = (ShopCarCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SCarSeller *car = [self.tempArray objectAtIndex:indexPath.section-1];
    
    SCarGoods *goods = [car.mCarGoods objectAtIndex:indexPath.row];
    
    [cell.mChoseBT setImage:[UIImage imageNamed:@"quanhong"] forState:UIControlStateSelected];
    cell.mChoseBT.selected = goods.mIsCheck;
    
    [cell.mImg sd_setImageWithURL:[NSURL URLWithString:goods.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    cell.mGoodsName.text = goods.mName;
    cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",goods.mPrice];
    cell.mNum.text = [NSString stringWithFormat:@"%d",goods.mNum];
    
    [cell.mChoseBT addTarget:self action:@selector(RowClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mJiaBT addTarget:self action:@selector(AddClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mJianBT addTarget:self action:@selector(JianClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mDelBT addTarget:self action:@selector(DelClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if( ( car.mServiceFee - goods.mPrice ) < 0.001f )
    {
//        [cell.m setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
//        [_mSuccess setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
//        _mSuccess.enabled = NO;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        AddressVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
        
        viewController.itblock = ^(SAddress* retobj){
            if( retobj )
            {
                
               DefaultAddress  = retobj;
                
                [self.tableView reloadData];
                
            }
            
        };
        [self pushViewController:viewController];
        return;
    }
    SCarSeller *car = [self.tempArray objectAtIndex:indexPath.section-1];
    SCarGoods *goods = [car.mCarGoods objectAtIndex:indexPath.row];

    SellerDetailVC *seller = [[SellerDetailVC alloc] initWithNibName:@"SellerDetailVC" bundle:nil];
    
    SGoods *good = [[SGoods alloc] init];
    good.mId = goods.mGoodsId;
    seller.mSumNum = goods.mNum;
    seller.mSumprice = goods.mPrice;
    seller.mGoods = good;
    seller.mType = goods.mType;
    [self pushViewController:seller];

    
    
    
    
}

- (void)SectionClick:(UIButton *)sender{
    
    NSLog(@"%d",sender.selected);
    sender.selected = !sender.selected;
    NSLog(@"%d",sender.selected);
    SCarSeller *car = [self.tempArray objectAtIndex:sender.tag];
    
    if (sender.selected) {
        
        car.mIsCheck = YES;
        for (int i = 0; i < car.mCarGoods.count; i++) {
            
            SCarGoods *goods = [car.mCarGoods objectAtIndex:i];
            goods.mIsCheck = YES;
        }
    }else{
        car.mIsCheck = NO;
        for (int i = 0; i < car.mCarGoods.count; i++) {
            
            SCarGoods *goods = [car.mCarGoods objectAtIndex:i];
            goods.mIsCheck = NO;
        }
    }
    [self.tableView reloadData];
   
}

- (void)JieSuanClick:(UIButton *)sender{
    
    NSMutableArray *goodsAry = NSMutableArray.new;
    
    SCarSeller *car = [self.tempArray objectAtIndex:(int)sender.tag];
    
    for (SCarGoods *goods in car.mCarGoods) {
        if (goods.mIsCheck) {
            [goodsAry addObject:goods];
         }
    }
    
    if (goodsAry.count<=0) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alt show];
        return;
    }
    
    BalanceVC *balance = [[BalanceVC alloc] initWithNibName:@"BalanceVC" bundle:nil];
    balance.mGoodsAry = goodsAry;
    balance.mCarSeller = car;
    balance.mSAddress = DefaultAddress;
    
    [self pushViewController:balance];
    
}

- (void)DelClick:(UIButton *)sender{

    ShopCarCell *cell = (ShopCarCell*)[sender findSuperViewWithClass:[ShopCarCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    SCarSeller *car = [self.tempArray objectAtIndex:indexpath.section-1];
    
    SCarGoods *goods = [car.mCarGoods objectAtIndex:indexpath.row];
    
    goods.mNum = 0;
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [goods addToCart:[goods.mNormsId intValue] block:^(SResBase *info, NSArray *all){
        
        if (info.msuccess) {
            
            [SVProgressHUD showSuccessWithStatus:info.mmsg];
            
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            
            [self.tableView reloadData];
            
            
            int badge = 0;
            
            for (SCarSeller *carseller in self.tempArray) {
                for (SCarGoods *cargoods in carseller.mCarGoods) {
                    
                    badge += cargoods.mNum;
                }
            }
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
            if (badge>0)
                item.badgeValue = [NSString stringWithFormat:@"%d",badge];
            else
                item.badgeValue = nil;
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];

}

- (void)RowClick:(UIButton *)sender
{
    
    ShopCarCell *cell = (ShopCarCell*)[sender findSuperViewWithClass:[ShopCarCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    SCarSeller *car = [self.tempArray objectAtIndex:indexpath.section-1];
    
    SCarGoods *goods = [car.mCarGoods objectAtIndex:indexpath.row];
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        goods.mIsCheck = YES;
    }else{
        goods.mIsCheck = NO;
    }
    
    [self.tableView reloadData];
    
}

- (void)AddClick:(UIButton *)sender{
    
    [self dealNum:1 sender:sender];
}

- (void)JianClick:(UIButton *)sender{

    
    [self dealNum:-1 sender:sender];
    
}
-(void)dealNum:(int)i sender:(UIButton*)sender
{
    
    ShopCarCell *cell = (ShopCarCell*)[sender findSuperViewWithClass:[ShopCarCell class]];
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    
    SCarSeller *car = [self.tempArray objectAtIndex:indexpath.section-1];
    
    SCarGoods *goods = [car.mCarGoods objectAtIndex:indexpath.row];
    
    if ( ( i == -1 && goods.mNum > 0 ) || ( i == 1 ) ) {
        
        goods.mNum +=i;
        [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
        [goods addToCart:[goods.mNormsId intValue] block:^(SResBase *info, NSArray *all){
            
            if (info.msuccess) {
                
                [SVProgressHUD showSuccessWithStatus:info.mmsg];
                
                self.tempArray = [[NSMutableArray alloc] initWithArray:all];
                
                [self.tableView reloadData];
                
                int badge = 0;
                
                for (SCarSeller *carseller in self.tempArray) {
                    for (SCarGoods *cargoods in carseller.mCarGoods) {
                        
                        badge += cargoods.mNum;
                    }
                }
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                if (badge>0)
                    item.badgeValue = [NSString stringWithFormat:@"%d",badge];
                else
                    item.badgeValue = nil;
                
            }else{
                goods.mNum -=i;
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
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

@end
