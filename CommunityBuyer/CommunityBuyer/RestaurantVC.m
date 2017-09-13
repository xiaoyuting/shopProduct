//
//  RestaurantVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/10.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "RestaurantVC.h"
#import "RestaurantDetailVC.h"
#import "DetailTextView.h"
#import "MapCell.h"
#import "CollectCell.h"
#import "SellerDetailVC.h"
#import "ServiceDetailVC.h"
#import "searchHotVC.h"
#import "RestaurantChoseView.h"
#import "ResRightCell.h"

@interface RestaurantVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *MainAry;
    
    BOOL    _bgotologin;
    
    NSMutableArray *typeAry;
    NSArray *sortAry;
    
    BOOL isOpen;
    BOOL isOpened1;
    BOOL isOpened2;
    
    int sortId;
    SSellerCate* selectCate;
    SSellerCate* selectCate2;
    
    UIView *bgView;
    RestaurantChoseView *choseView;
}

@end


@implementation RestaurantVC{
        
        BOOL      _neverload;
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    
}

- (void)gotType{

    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    
    [SSellerCate getAllCates:0 andType:0 block:^(SResBase *resb, NSArray *all) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
            typeAry = [[NSMutableArray alloc] initWithArray:all];
            
            [_mLeftBT setTitle:_mGoodsName forState:UIControlStateNormal];
            [choseView.mLeftTableView reloadData];
            
            if (all.count > 0) {
                
                for (int i = 0;i < typeAry.count;i++) {
                    
                    SSellerCate *c = [typeAry objectAtIndex:i];
                    
                    if (c.mId == _mGoodsId) {
                        selectCate = c;
                        
                        selectCate2 = [c.mChilds objectAtIndex:0];
                        selectCate2.mIsCheck = YES;
                        [_mLeftBT setTitle:selectCate.mName forState:UIControlStateNormal];
                        [choseView.mLeftTableView reloadData];
                        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [choseView.mLeftTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                    }
                    
                    
                    for(int j =0 ;j<c.mChilds.count;j++) {
                        
                        SSellerCate *s = [c.mChilds objectAtIndex:j];
                        if (s.mId == _mGoodsId) {
                            
                            selectCate = c;
                            selectCate2 = s;
                            selectCate2.mIsCheck = YES;
                            if ([selectCate2.mName isEqualToString:@"全部"]) {
                                
                                [_mLeftBT setTitle:selectCate.mName forState:UIControlStateNormal];
                            }else{
    
                                [_mLeftBT setTitle:selectCate2.mName forState:UIControlStateNormal];
                            }

                            [choseView.mLeftTableView reloadData];
                            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
                            [choseView.mLeftTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                            
                        }
                        
                    }
                    
                }
                
            }

            
            [self.tableView headerBeginRefreshing];
            
            sortAry = [NSArray arrayWithObjects:@"综合排序",@"销量最高",@"起送价最低",@"距离最近",@"评分最高", nil];
            
            [self loadTop];
        
            [choseView.mRightTableView reloadData];
            
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    
    sortId = 0;
    self.mPageName = _mGoodsName;
    self.Title = self.mPageName;
    
    self.rightBtnImage = [UIImage imageNamed:@"serach"];
    
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    self.tableView = _mTableView;
    self.haveHeader = YES;
    self.haveFooter = YES;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = M_BGCO;
    
    UINib *nib = [UINib nibWithNibName:@"CollectCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 10)];
//    headView.backgroundColor = M_BGCO;
//    [self.tableView setTableHeaderView:headView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    MainAry = [[NSMutableArray alloc] initWithObjects:dic,dic,dic, nil];
    
  
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -(DEVICE_InNavBar_Height-40), DEVICE_Width, DEVICE_InNavBar_Height-40)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseChoseView)];
    [bgView addGestureRecognizer:tap];
    
    choseView = [RestaurantChoseView shareView];
    choseView.frame = CGRectMake(0, DEVICE_NavBar_Height+40, DEVICE_Width/2, 0);

    [self.view addSubview:choseView];
    
    UINib *nib2 = [UINib nibWithNibName:@"ResRightCell" bundle:nil];
    [choseView.mRightTableView registerNib:nib2 forCellReuseIdentifier:@"rcell"];
    
    choseView.mLeftTableView.backgroundColor = M_BGCO;
    choseView.mLeftTableView.delegate = self;
    choseView.mLeftTableView.dataSource = self;
    [choseView.mLeftTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    choseView.mRightTableView.delegate = self;
    choseView.mRightTableView.dataSource = self;
    [choseView.mRightTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self gotType];
}


- (void)loadTop{
    

    
    _mRightTableHeight.constant = 0;
    
    [self.mRightTable initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [sortAry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        [cell.mlb setText:[sortAry objectAtIndex:indexPath.row]];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        
        
        [_mRightBT setTitle:[sortAry objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        sortId = (int)indexPath.row;
        
        [self.tableView headerBeginRefreshing];
        
        [UIView animateWithDuration:0.3 animations:^{
            
           _mRightTableHeight.constant = 0;
            _mRightJiantou.image = [UIImage imageNamed:@"jiantouxia"];
            [_mRightBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
        
    }];

}

- (void)rightBtnTouched:(id)sender{
    
    searchHotVC* vc = [[searchHotVC alloc]initWithNibName:@"searchHotVC" bundle:nil];
    [self pushViewController:vc];
   
}

-(void)headerBeganRefresh
{
    self.page = 1;
    
    
    
    if (selectCate) {
        _mType = selectCate.mId;
    }
    
    if (selectCate2) {
        _mType = selectCate2.mId;
    }
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    NSLog(@"=======%@",_mKeywords);
    
    NSLog(@"======%d",sortId);
    NSLog(@"======%d",_mType);
    NSLog(@"======%d",self.page);
    NSLog(@"======%@",_mKeywords);
    
    [SSeller getAllSeller:sortId page:self.page type:_mType keyword:_mKeywords block:^(SResBase *info, NSArray *all) {
        
        [self headerEndRefresh];
        
        if (info.msuccess) {
            
            [SVProgressHUD dismiss];
            [self.tempArray removeAllObjects];
            [self.tempArray addObjectsFromArray:all];
            
            if (all.count==0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
            [self.tableView reloadData];
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:info.mmsg];
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

- (void)footetBeganRefresh{

  
    
    self.page ++;
    
    if (selectCate) {
        _mType = selectCate.mId;
    }
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [SSeller getAllSeller:sortId page:self.page type:_mType keyword:_mKeywords block:^(SResBase *info, NSArray *all){
        [self footetEndRefresh];
        
        if (info.msuccess) {
            
            [SVProgressHUD dismiss];
            
            if (all.count!=0) {
                [self removeEmptyView];
                
                [self.tempArray addObjectsFromArray:all];
               
            }else
            {
                if(!self.tempArray||self.tempArray==0)
                {
                    [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                }
                else
                    [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                
            }
            [self.tableView reloadData];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:info.mmsg];
    
        }
    }];

}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == choseView.mLeftTableView) {
        return [typeAry count];
    }
    
    if (tableView == choseView.mRightTableView) {
        return [selectCate.mChilds count];
    }
    
    return [self.tempArray count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == choseView.mLeftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
        }
        
        
        cell.backgroundColor = M_BGCO;
        SSellerCate *cate = [typeAry objectAtIndex:indexPath.row];
        cell.textLabel.text = cate.mName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.bounds];
        //        imgV.image = [UIImage imageNamed:@"res_selectbg"];
        imgV.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = imgV;
        
        return cell;
    }
    
    if (tableView == choseView.mRightTableView) {
        
        ResRightCell *cell = (ResRightCell *)[tableView dequeueReusableCellWithIdentifier:@"rcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SSellerCate *cate = [selectCate.mChilds objectAtIndex:indexPath.row];
        
        cell.mName.text = cate.mName;
        
        if (cate.mIsCheck) {
            
            cell.mName.textColor = M_CO;
            cell.mCheckImg.hidden = NO;
        }else{
            cell.mName.textColor = [UIColor blackColor];
            cell.mCheckImg.hidden = YES;
        }
        
        return cell;
    }
    
    
    CollectCell *cell = (CollectCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
    
    [cell.mImg sd_setImageWithURL:[NSURL URLWithString:seller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    cell.mName.text = seller.mName;
    cell.mKm.text = seller.mDist;
    
    if (seller.mOrderCount >0) {
        cell.mSellNum.text = [NSString stringWithFormat:@"已售 %d",seller.mOrderCount];
    }else{
        cell.mSellNum.text = @"";
    }
    
    [cell setStar:seller.mScore];
    
    NSLog(@"seller.mFreight==%@",seller.mFreight);
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@<font color=#979797>起</font>",  seller.mFreight ] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    cell.mQsPrice.attributedText = attrStr;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(tableView == choseView.mLeftTableView){
    
        selectCate = [typeAry objectAtIndex:indexPath.row];
        
        [choseView.mRightTableView reloadData];
        //按客户要求，屏蔽二级菜单，直接通过一级菜单刷新数据
        if ([selectCate2.mName isEqualToString:@"全部"]) {
            self.mPageName = selectCate.mName;
            self.Title = self.mPageName;
            [_mLeftBT setTitle:selectCate.mName forState:UIControlStateNormal];
        }else{
            self.mPageName = selectCate2.mName;
            self.Title = self.mPageName;
            [_mLeftBT setTitle:selectCate2.mName forState:UIControlStateNormal];
        }
        
        selectCate2 = [selectCate.mChilds objectAtIndex:0];
        [self.tableView headerBeginRefreshing];
        [self CloseChoseView];
        
        
        return;
    }
    
//    if (tableView == choseView.mRightTableView) {
//        
//        selectCate2.mIsCheck = NO;
//        
//        selectCate2 = [selectCate.mChilds objectAtIndex:indexPath.row];
//        selectCate2.mIsCheck = YES;
//        
//        if ([selectCate2.mName isEqualToString:@"全部"]) {
//            self.mPageName = selectCate.mName;
//            self.Title = self.mPageName;
//            [_mLeftBT setTitle:selectCate.mName forState:UIControlStateNormal];
//        }else{
//            self.mPageName = selectCate2.mName;
//            self.Title = self.mPageName;
//            [_mLeftBT setTitle:selectCate2.mName forState:UIControlStateNormal];
//        }
//        
//        
//        
//        [choseView.mRightTableView reloadData];
//        
//        [self.tableView headerBeginRefreshing];
//        
//        isOpen = NO;
//        _mLeftJiantou.image = [UIImage imageNamed:@"jiantouxia"];
//        [_mLeftBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];
//        [self CloseChoseView];
//        
//        return;
//    }
    
//    if ([SUser isNeedLogin]) {
//        [self gotoLoginVC];
//        return;
//    }

    SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];

    if (selectCate.mType == 1) {
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
        viewController.mSeller = seller;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
    
        ServiceDetailVC *serviceVC = [[ServiceDetailVC alloc] init];
        serviceVC.mSeller = seller;
        [self pushViewController:serviceVC];

    }
   
}


- (IBAction)LeftClick:(id)sender {
    
    

    if (isOpen) {
        
        _mLeftJiantou.image = [UIImage imageNamed:@"jiantouxia"];
        [_mLeftBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];
        [self CloseChoseView];
    }else{
        
        _mLeftJiantou.image = [UIImage imageNamed:@"jiantoushang"];
        [_mLeftBT setTitleColor:M_CO forState:UIControlStateNormal];
        
        bgView.frame = CGRectMake(0, DEVICE_NavBar_Height+40, DEVICE_Width, DEVICE_InNavBar_Height-40);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect2 = choseView.frame;
            
            rect2.size.height= DEVICE_InNavBar_Height-150;
            choseView.frame = rect2;
            
            
        } completion:^(BOOL finished){
            
            isOpen = YES;
        }];
        
        
        //关掉右边
        _mRightJiantou.image = [UIImage imageNamed:@"jiantouxia"];
        [_mRightBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _mRightTableHeight.constant = 0;
            
            
        } completion:^(BOOL finished){
            
            
            isOpened2=NO;
            
        }];

    }
    
   
    _mLeftBT.backgroundColor = [UIColor whiteColor];
    _mRightBT.backgroundColor = COLOR(240, 240, 240);
    
}

- (void)CloseChoseView{
    bgView.frame = CGRectMake(0, -(DEVICE_InNavBar_Height-40), DEVICE_Width, DEVICE_InNavBar_Height-40);
    [UIView animateWithDuration:0.3 animations:^{
        
        
        CGRect rect2 = choseView.frame;
        
        rect2.size.height =  0;
        choseView.frame = rect2;
        
       
    }];

     isOpen = NO;
}

- (IBAction)RightClick:(id)sender {
    
    
    
    if (isOpened2) {
        
        _mRightJiantou.image = [UIImage imageNamed:@"jiantouxia"];
        [_mRightBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];

        [UIView animateWithDuration:0.3 animations:^{
            
            _mRightTableHeight.constant = 0;
            
            
        } completion:^(BOOL finished){
            
            
            isOpened2=NO;
            
        }];
        
        
        
        
    }else{
        
        
        _mRightJiantou.image = [UIImage imageNamed:@"jiantoushang"];
        [_mRightBT setTitleColor:M_CO forState:UIControlStateNormal];
        _mRightTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [UIView animateWithDuration:0.3 animations:^{

          
            _mRightTableHeight.constant = 220;

//            NSLog(@"suvp:%@ hid:%d",_mRightTable.superview,_mRightTable.hidden);
//            _mRightTable.backgroundColor = [UIColor redColor];
//            [self.view bringSubviewToFront:_mRightTable];
            
        } completion:^(BOOL finished){
            
            isOpened2=YES;
            
        }];
        
        //关掉左边
        _mLeftJiantou.image = [UIImage imageNamed:@"jiantouxia"];
        [_mLeftBT setTitleColor:COLOR(118, 119, 120) forState:UIControlStateNormal];
        [self CloseChoseView];
        
        
    }
    _mRightBT.backgroundColor = [UIColor whiteColor];
    _mLeftBT.backgroundColor = COLOR(240, 240, 240);
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
