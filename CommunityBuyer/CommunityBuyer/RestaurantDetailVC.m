//
//  RestaurantDetailVC.m
//  XiCheBuyer
//
//  Created by 周大钦 on 15/7/16.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "RestaurantDetailVC.h"
#import "LeftCell.h"
#import "RightCell.h"
#import "ShopCarView.h"
#import "JSBadgeView.h"
#import "DetailTextView.h"
#import "ChoseView.h"
#import "SellerDetailVC.h"
#import "ShopCarVC.h"
#import "BalanceVC.h"
#import "SellerDetailView.h"
#import "PingJiaCell.h"
#import "PingJiaHeadView.h"
#import "SellerView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <objc/runtime.h>
#import "ResSectionHeadView.h"
#import "ResSectionFooterView.h"
#import "UIImage+RTTint.h"
#import "RightbottomCell.h"
#import "UILabel+myLabel.h"
#import "AdvView.h"

@interface RestaurantDetailVC ()<UITableViewDataSource,UITableViewDelegate>{

    LeftCell *tempCell;
    
    NSMutableArray *mainAry;
    
    int leftSelect;
    int leftSelectWillTo;
    ResSectionHeadView *sectionHead;
    
    NSIndexPath *leftIndexPath;
    int sunNum;
    float sumPrice;
    
    UIView *maskView;
    
    UIScrollView *scrollView;
    BOOL isShowCar;
    JSBadgeView *badgeView;
    
    
    float heigth;
    float y;
    
    BOOL isCollect;
    int _FreePrice;
    
    
    ChoseView *choseView;
    
    UIButton *tempBT;
    
    int goCarNum;
    
    UIButton *tempBtn;
    int nowSelect;
    UIImageView *lineImage;
    
    UITableView *pjTableView;//评价列表
    NSArray *pjArray;
    
    SellerView *sellerView; //商家
    BOOL isLoadSeller;
    BOOL isLoadPj;
    
    SOrderRate *myRate;
    int pjSelect;
    UIButton *tempPjBT;
    NSMutableDictionary *tempDic;
    
    NSString *AdvString;
    PingJiaHeadView *sectionView;
    PingJiaHeadView *headView;
    
    NSMutableDictionary* _allgoodsinfo;
    
    UILabel *advLab;
    
    AdvView *advView;
    

}

@end

@implementation RestaurantDetailVC{

    BOOL isLoad;
}

- (void)viewWillAppear:(BOOL)animated{
    
//    if (!isLoad) {
    
        
       [self addMEmptyView:_mGoodsView rect:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height-100)];
        
        sunNum =0;
        sumPrice = 0;
    
        if ([SUser isNeedLogin]) {
//            [self gotoLoginVC];
            [self getGoods];
            return;
        }
    
        [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
        [[SUser currentUser] getMyShopCar:^(SResBase *resb, NSArray *all) {
            [self headerEndRefresh];
            
            if (resb.msuccess) {
                
                mainAry = [[NSMutableArray alloc] initWithArray:all];
                int num = 0;
                for (SCarSeller *carseller in all) {
                    for (SCarGoods *cargoods in carseller.mCarGoods) {
                        
                        num += cargoods.mNum;
                    }
                }
                
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                if(num >0)
                    item.badgeValue = [NSString stringWithFormat:@"%d",num];
                else
                    item.badgeValue = nil;
                
                [self getGoods];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
        
//        isLoad = YES;
    
        
//    }
    
    
    
    
}
-(NSString*)mk:(NSInteger)i
{
    return [NSString stringWithFormat:@"section_%d",(int)i];
}

#define S_OPENED @"opened"

#define S_CLOSED @"closeed"

#define D_NORMCOUNT 3//默认的规格是3个

-(void)makeAllGoodsInfo
{
    //把所有数据都平坦的放到数组里面
    [_allgoodsinfo removeAllObjects];
    for ( int j = 0; j < self.tempArray.count;j++ ) {
        
        SGoodsPack* one = self.tempArray[j];
        NSMutableArray* tmp = [_allgoodsinfo objectForKey:[self mk:j]];
        
        if( tmp == nil )
        {
            tmp = NSMutableArray.new;
            [_allgoodsinfo setObject:tmp forKey:[self mk:j]];
        }
        
        if( one.mGoods.count )
        {//如果这个分类下面有商品,
            for ( SGoods* onegoods in one.mGoods ) {
                
                [tmp addObject: onegoods];
                
                int normscount = 0;
                for (SGoodsNorms* onenorm in onegoods.mNorms ) {
                    if( onenorm.mId == 0 ) continue;
                    if( normscount == D_NORMCOUNT )
                    {
                        [tmp addObject:S_CLOSED];
                        break;
                    }else
                        [tmp addObject:onenorm];
                    normscount++;
                }
            }
        }
        else
        {//如果没有,就弄个暂无商品
            SGoods* emptgoods = SGoods.new;
            emptgoods.mName=  @"暂无商品";
            emptgoods.mId = -1;
            [tmp addObject: emptgoods];
        }
    }
}
-(SGoods*)findGoodswithNorm:(SGoodsNorms*)w
{
    for( SGoodsPack* one in self.tempArray )
    {
        for ( SGoods* onegoods in one.mGoods ) {
            if( [onegoods.mNorms containsObject:w] ) return onegoods;
        }
    }
    return nil;
}


-(void)extendOneSection:(NSIndexPath*)indexPath
{
    //扩展一个,或者收缩一个
    NSMutableArray* tmp = [_allgoodsinfo objectForKey:[self mk:indexPath.section]];
    if( tmp.count > indexPath.row )
    {
        NSString* w = tmp[indexPath.row];
        if( [w isKindOfClass:[NSString class]] )
        {
            if( [w isEqualToString:S_CLOSED] )
            {
                [self realexo:tmp index:indexPath.row toopen:YES];
            }
            else if( [w isEqualToString:S_OPENED] )
            {
                [self realexo:tmp index:indexPath.row toopen:NO];
            }
            else
            {
                NSLog(@"may be err");
            }
        }
    }
}
-(void)realexo:(NSMutableArray*)tmp index:(NSInteger)index toopen:(BOOL)toopen
{
    for ( NSInteger j = index-1; j >= 0; j -- ) {
        id one = tmp[j];
        if( [one isKindOfClass:[SGoods class]])//从这个开始往前找,肯定可以找到这个的商品
        {
            if( !toopen )
            {//如果是收起,,,,就直接把多的干掉
                [tmp replaceObjectAtIndex:index withObject:S_CLOSED];
                [tmp removeObjectsInRange:NSMakeRange(j+D_NORMCOUNT+1, index - (j+D_NORMCOUNT+1) )];
            }
            else
            {//如果是展开
                [tmp replaceObjectAtIndex:index withObject:S_OPENED];
                NSArray* sub = ((SGoods*)one).mNorms;
                for ( int k = 0; k < sub.count-D_NORMCOUNT; k ++) {
                    [tmp insertObject:((SGoods*)one).mNorms[k+D_NORMCOUNT] atIndex: index+k];
                }
            }
            break;
        }
    }
}




//获取商品列表
- (void)getGoods{
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [_mSeller getGoods:^(SResBase *info, NSArray *all){
        
        
        if (info.msuccess) {
            [SVProgressHUD dismiss];
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            [self makeAllGoodsInfo];
            
            
            
            if(self.tempArray.count >0){
            
                if (mainAry.count>0) {
                    
                    //遍历购物车
                    for (SCarSeller *carSeller in mainAry) {
                        
                        if(carSeller.mId == _mSeller.mId){
                            
                            for(SCarGoods *carGoods in carSeller.mCarGoods){
                                
                                sunNum += carGoods.mNum;
                                sumPrice +=carGoods.mPrice*carGoods.mNum;
                                //遍历商品列表
                                for (SGoodsPack *pack in self.tempArray) {
                                    
                                    for (SGoods *goods in pack.mGoods) {
                                        
                                        if (goods.mId == carGoods.mGoodsId) {
                                            
                                            
                                            goods.mCount = carGoods.mNum;
                                            
                                        }
                                        
                                        [SCarSeller getCarInfoWithGoods:goods];//获取对应商品在购物车内数量
                                        
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                
                UINib *nib = [UINib nibWithNibName:@"leftcell" bundle:nil];
                [self.tableView registerNib:nib forCellReuseIdentifier:@"leftcell"];
                
                
                UINib *nib2 = [UINib nibWithNibName:@"rightcell" bundle:nil];
                [self.tableView registerNib:nib2 forCellReuseIdentifier:@"rightcell"];
                
                UINib *nib3 = [UINib nibWithNibName:@"rightcell2" bundle:nil];
                [self.tableView registerNib:nib3 forCellReuseIdentifier:@"rightcell2"];
 
                _mLeftTableV.delegate = self;
                _mLeftTableV.dataSource = self;
                
                UINib *nib4 = [UINib nibWithNibName:@"RightbottomCell" bundle:nil];
                [_mRightTableV registerNib:nib4 forCellReuseIdentifier:@"rightcell3"];
                _mRightTableV.delegate = self;
                _mRightTableV.dataSource = self;
                
                
                if (self.tempArray.count>0) {
                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_mLeftTableV selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    [_mRightTableV reloadData];
                }
                
                isLoad = YES;

                [self removeMEmptyView];
            }
            
            //加载数据
            [self loadData];
            
           
            
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
            
        }
        
    }];
}

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    leftSelect = 0;
    leftSelectWillTo = -1;
    goCarNum = 0;
    pjSelect = 0;
    
    _allgoodsinfo = NSMutableDictionary.new;
    
    self.mPageName = (_mSeller.mName==nil?@"商家":_mSeller.mName);
    self.Title = self.mPageName;
    
    tempBtn = _mLeftBT;
    nowSelect  = 0 ;
    lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_Width/3-30, 3)];
    lineImage.backgroundColor = M_CO;
    lineImage.center = _mLeftBT.center;
    CGRect rect = lineImage.frame;
    rect.origin.y = 52;
    lineImage.frame = rect;
    [_mTopView addSubview:lineImage];

    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [SSeller getGongGao:_mSeller.mId block:^(SResBase *info, NSString *content) {
             [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
            if (info.msuccess) {
                
                if(content.length>0){
            
                    AdvString = content;
                    
                    advLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 34)];
                    advLab.numberOfLines = 0;
                    advLab.font = [UIFont systemFontOfSize:14];
                    advLab.textColor = M_CO;
                    [_mAdvView addSubview:advLab];
                    
                    _mAdvView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AdvClick:)];
                    
                    [_mAdvView addGestureRecognizer:tap];
                    
                    
                    advLab.text = content;
                    NSTimer *timer;
                    [advLab autoReSizeWidthForContent:CGFLOAT_MAX];
                    
                    if (advLab.text.length*14> DEVICE_Width-32) {
                        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                 target:self
                                                               selector:@selector(RemainingSecond)
                                                               userInfo:nil
                                                                repeats:YES];
                        [timer fire];
                    }

                    
                }else{
                    _mAdvHeight.constant = 0;
                }
                
            }else{
                _mAdvHeight.constant = 0;
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
            
        }];
        
   // });
    
    
    _mLeftTableV.tableFooterView =  UIView.new;
    _mRightTableV.tableFooterView = UIView.new;
    
    
    [_mSeller getDetail:^(SResBase *info) {
        
        
    }];
    
}
-(void)CallClick:(UIButton*)sender
{
    NSMutableString * string=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_mSeller.mMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}
- (void)AdvClick:(UIButton*)sender{

    advView = [[AdvView alloc] init];
    
    [advView showInView:self.view title:nil content:AdvString];
    
    [advView.mCloseBT addTarget:self action:@selector(CloseClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)CloseClick:(UIButton *)sender{

    [advView hiddenView];
}

- (void)RemainingSecond{
    
    CGRect rect = advLab.frame;
    
    if (rect.origin.x+advLab.frame.size.width>0) {
        rect.origin.x -=5;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            advLab.frame = rect;
            
        } completion:^(BOOL finished){
            
        }];
    }
    else{
        rect.origin.x = DEVICE_Width-32;
        advLab.frame = rect;
    }
}

- (void)loadData{

    badgeView.layer.masksToBounds = YES;
    badgeView.layer.cornerRadius = 10;
    
    badgeView = [[JSBadgeView alloc] initWithParentView:_mCarBt alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgePositionAdjustment = CGPointMake(0, 5);
    badgeView.badgeStrokeWidth = 5;
    
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
    
    badgeView.badgeBackgroundColor = M_CO;
    
    [_mSuccess setTitle:@"选好了" forState:UIControlStateNormal];
    [_mSuccess setBackgroundColor:M_CO];
    _mSuccess.enabled = YES;
    
    if ( (_mSeller.mServiceFee - sumPrice ) > 0.001f ) {
        [_mSuccess setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
        [_mSuccess setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
        _mSuccess.enabled = NO;
    }
    
    if (_mSeller.mIsCollect) {
        
        self.rightBtnImage = [UIImage imageNamed:@"shoucang"];
        isCollect = YES;
    }else{
        self.rightBtnImage = [UIImage imageNamed:@"shoucangno"];
    }
    
    
    _mLeftTableV.backgroundColor = COLOR(240, 235, 234);
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView                                               // any offset changes
{
    for ( int j = 0 ; j < [_mRightTableV numberOfSections]; j++) {
        if( CGRectContainsPoint( [_mRightTableV rectForSection:j] , scrollView.contentOffset) )
        {
            [self changeLeftSelect:j];
            return;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //为了处理当不能滚动到最下面范围的时候,就要处理把限制去掉
    leftSelectWillTo = -1;
}


-(void)changeLeftSelect:(int)section
{
    
    if( leftSelect != section )
    {
        if( leftSelectWillTo != -1 && leftSelectWillTo != section )
        {//这种就是还没有到达指定的位置,,先不管,,,但是,如果是最后一个
            return;
        }
        
        leftSelectWillTo = -1;
        leftSelect = section;
        
        [_mLeftTableV selectRowAtIndexPath:[NSIndexPath indexPathForRow:leftSelect inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}



#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    if (tableView == _mRightTableV) {
        
        return self.tempArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mLeftTableV) {
        
        return [self.tempArray count];
        
    }else if (tableView == _mRightTableV){
        
        NSArray* all = [_allgoodsinfo objectForKey:[self mk:section]];
        return all.count;
        
    }
    
    NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",pjSelect];
    
    NSArray *arr = [tempDic objectForKey:key2];
    
    return [arr count];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (tableView == pjTableView) {

            return sectionView;
    }
    
    if (tableView == _mRightTableV) {
        
        sectionHead = [ResSectionHeadView shareView];
        SGoodsPack *pack = [self.tempArray objectAtIndex:section];
        
        sectionHead.mText.text = pack.mName;
        
        return sectionHead;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (tableView == _mRightTableV) {
        return nil;
        SGoodsPack *pack = [self.tempArray objectAtIndex:section];
        if (pack.mGoods.count>0) {
            SGoods *goods = [pack.mGoods objectAtIndex:section];
            
            if (goods.mNorms.count>3) {
                
                ResSectionFooterView *footV = [ResSectionFooterView shareView];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
                line.backgroundColor = COLOR(196, 195, 201);
                [footV addSubview:line];
                
                
                footV.mNum.tag = section;
                [footV.mNum addTarget:self action:@selector(OpenClick:) forControlEvents:UIControlEventTouchUpInside];
                if (goods.mIsOpen) {
                    [footV.mNum setTitle:@"收起商品规格" forState:UIControlStateNormal];
                    footV.mJiantou.image = [UIImage imageNamed:@"huitopjiantou"];
                }else{
                    [footV.mNum setTitle:[NSString stringWithFormat:@"展开剩下%lu条",goods.mNorms.count-3] forState:UIControlStateNormal];
                    footV.mJiantou.image = [UIImage imageNamed:@"huiDownjiantou"];
                }
                
                return footV;
            }
        }
       
    }
    return nil;
}

- (void)OpenClick:(UIButton *)sender{

    SGoodsPack *pack = [self.tempArray objectAtIndex:leftSelect];
    
    SGoods *goods = [pack.mGoods objectAtIndex:sender.tag];
    
    goods.mIsOpen = !goods.mIsOpen;
    
    [_mRightTableV reloadData];

}

- (void)ChoseClick:(UIButton *)sender{

    pjSelect = (int)sender.tag-1;
    
    if (tempPjBT == sender) {
        return;
    }
    else
    {
        NSString *key1 = [NSString stringWithFormat:@"nowselectdata%d",pjSelect];
        
        if (![tempDic objectForKey:key1]) {
            [self.tableView headerBeginRefreshing];
        }
        else
        {
            if ([[tempDic objectForKey:key1] count]>0) {
                [self removeEmptyView];
                
                [self.tableView reloadData];
            }
            
        }
        
        [tempPjBT setTitleColor:COLOR(126, 121, 124) forState:UIControlStateNormal];
        [tempPjBT setBackgroundColor:[UIColor whiteColor]];
        tempPjBT.layer.borderWidth = 1;
        tempPjBT.layer.borderColor = COLOR(226, 226, 226).CGColor;
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:M_CO];
        sender.layer.borderWidth = 0;
        sender.layer.borderColor = [UIColor whiteColor].CGColor;
        tempPjBT = sender;
        
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == pjTableView) {
        return 60;
    }
    
    if (tableView == _mRightTableV) {
        return 35;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (tableView == _mRightTableV) {
        
        return 0;
   
        SGoodsPack *pack = [self.tempArray objectAtIndex:leftSelect];
        if (pack.mGoods.count>0) {
            SGoods *goods = [pack.mGoods objectAtIndex:section];
            
            if (goods.mNorms.count>3) {
                return 35;
            }
        
        }
    }
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
    if (tableView == _mLeftTableV) {
        
        LeftCell *cell = (LeftCell *)[tableView dequeueReusableCellWithIdentifier:@"leftcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.bounds];
//        imgV.image = [UIImage imageNamed:@"res_selectbg"];
        imgV.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = imgV;
        
        SGoodsPack *pack = [self.tempArray objectAtIndex:indexPath.row];
        
        cell.mName.text = pack.mName;
        
        if (indexPath.row == 0) {
            
            leftIndexPath = indexPath;
            
        }
       
        
        return cell;
        
    }else if (tableView == _mRightTableV){
     
        RightCell *cell;
        
        id obj = [_allgoodsinfo objectForKey:[self mk:indexPath.section]];
        obj = [obj objectAtIndex:indexPath.row];
        
        if( [obj isKindOfClass: [NSString class]] )
        {
            SGoodsNorms * goodsnomor  = [[_allgoodsinfo objectForKey:[self mk:indexPath.section]] objectAtIndex:indexPath.row-1];//它前面一个,肯定是一个规格
            SGoods *goods = [self findGoodswithNorm:goodsnomor];

            RightbottomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"rightcell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            if( [obj isEqualToString:S_CLOSED] )
            {
                cell.mtitle.text = [NSString stringWithFormat:@"展开剩下%d条",(int)goods.mNorms.count - 3];
                [cell.mtitle autoReSizeWidthForContent:200];
                cell.mtitle.center = CGPointMake(cell.contentView.bounds.size.width/2, cell.mtitle.center.y);
                cell.mimage.image = [UIImage imageNamed:@"huiDownjiantou"];
                [Util relPosUI:cell.mtitle dif:5 tag:cell.mimage tagatdic:E_dic_r];
            }
            else if( [obj isEqualToString:S_OPENED] )
            {
                cell.mtitle.text = @"收起商品规格";
                [cell.mtitle autoReSizeWidthForContent:200];
                cell.mtitle.center = CGPointMake(cell.contentView.bounds.size.width/2, cell.mtitle.center.y);
                cell.mimage.image = [UIImage imageNamed:@"huitopjiantou"];
                [Util relPosUI:cell.mtitle dif:5 tag:cell.mimage tagatdic:E_dic_r];
            }
            else
            {
                NSLog(@"may be error string info:%@",obj);
            }
            return cell;
        }
        else
        {
            if( [obj isKindOfClass: [SGoods class]])
            {
                SGoods *goods = obj;
                if( goods.mId == -1 )
                {
                    RightbottomCell* cell   = [tableView dequeueReusableCellWithIdentifier:@"rightcell3"];
                    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
                    cell.accessoryType      = UITableViewCellAccessoryNone;
                    
                    cell.mtitle.text    = goods.mName;
                    cell.mimage.image   = nil;
                    cell.mtitle.center = CGPointMake(cell.contentView.bounds.size.width/2, cell.mtitle.center.y);
                    return cell;
                }
                
                SGoodsNorms *norm = goods.mNorms.firstObject;
                
                cell = (RightCell *)[tableView dequeueReusableCellWithIdentifier:@"rightcell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                
                [cell.mImg sd_setImageWithURL:[NSURL URLWithString:[Util makeImgUrl:[goods.mImages objectAtIndex:0] tagImg:cell.mImg]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
                cell.mName.text = goods.mName;
                if (goods.mSalesCount > 0) {
                     cell.mXiaoLiang.text = [NSString stringWithFormat:@"已售 %d",goods.mSalesCount];
                }else{
                     cell.mXiaoLiang.text = @"";
                }
               
                cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",goods.mPrice];
                cell.mImg.layer.masksToBounds = YES;
                cell.mImg.layer.cornerRadius = 3;
                
                if( goods.mNorms.count == 1)
                {//1个规格的是,需要判断是否 是不是真的规格
                    if( norm.mId == 0 )
                    {//这种不是真的规格,,就是没有规格的意思
                        cell.mDetailHeight.constant = 35;
                        cell.mNormName.text = @"";
                    }
                    else
                    {//只有1个规格,,,,也不能用这个的,,
                        cell.mDetailHeight.constant = 0;
                    }
                }
                else
                {//很多规格的情况就不考虑,,,
                    cell.mDetailHeight.constant = 0;
                    cell.mNormName.text = @"";
                }
                
                if (norm.mCount > 0) {
                    cell.mDelButton.hidden = NO;
                    cell.mNum.hidden = NO;
                    cell.mNum.text = [NSString stringWithFormat:@"%d",norm.mCount];
                }else{
                    cell.mDelButton.hidden = YES;
                    cell.mNum.hidden = YES;
                }
            }
            else if( [obj isKindOfClass: [SGoodsNorms class]])
            {
                cell = (RightCell *)[tableView dequeueReusableCellWithIdentifier:@"rightcell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                
                SGoodsNorms *norm = obj;
                cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",norm.mPrice];
                cell.mNormName.text = norm.mName;
                
                
                if (norm.mCount > 0) {
                    cell.mDelButton.hidden = NO;
                    cell.mNum.hidden = NO;
                    cell.mNum.text = [NSString stringWithFormat:@"%d",norm.mCount];
                }else{
                    cell.mDelButton.hidden = YES;
                    cell.mNum.hidden = YES;
                }
            }
            else
            {
                NSLog(@"may be error class:%@",[obj class]);
            }
            
            cell.mAddButton.mrefobj = obj;
            if([cell.mAddButton allTargets].count == 0 )
                [cell.mAddButton addTarget:self action:@selector(AddClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.mDelButton.mrefobj = obj;
            if([cell.mDelButton allTargets].count == 0 )
                [cell.mDelButton addTarget:self action:@selector(DelClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
       
        
        /*
        SGoodsPack *pack = [self.tempArray objectAtIndex:indexPath.section];
        
        if (pack.mGoods.count>0) {
            
            SGoods *goods = [pack.mGoods objectAtIndex:indexPath.section];
            
            SGoodsNorms *norm = [goods.mNorms objectAtIndex:indexPath.row];
            
            if (indexPath.row == 0) {
                [cell.mImg sd_setImageWithURL:[NSURL URLWithString:[goods.mImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
                cell.mName.text = goods.mName;
                cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",norm.mPrice];
                cell.mImg.layer.masksToBounds = YES;
                cell.mImg.layer.cornerRadius = 3;
                cell.mNormName.text = norm.mName;
            }else{
                cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",norm.mPrice];
                cell.mNormName.text = norm.mName;
            }
            
            if (norm.mId == 0) {
                norm.mCount = goods.mCount;
            }
            
            if (norm.mCount > 0) {
                cell.mDelButton.hidden = NO;
                cell.mNum.hidden = NO;
                cell.mNum.text = [NSString stringWithFormat:@"%d",norm.mCount];
            }else{
                cell.mDelButton.hidden = YES;
                cell.mNum.hidden = YES;
            }
            
            
            cell.mAddButton.tag = indexPath.row;
            cell.mAddButton.indexPath = indexPath;
            [cell.mAddButton addTarget:self action:@selector(AddClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.mDelButton.tag = indexPath.row;
            cell.mDelButton.indexPath = indexPath;
            [cell.mDelButton addTarget:self action:@selector(DelClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        return cell;
         */
        
    }else if (tableView == pjTableView){
    
        PingJiaCell *cell = (PingJiaCell *)[tableView dequeueReusableCellWithIdentifier:@"pjcell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",pjSelect];
        NSArray *arr = [tempDic objectForKey:key2];
        
        SOrderRateInfo *rate = [arr objectAtIndex:indexPath.row];
        
        [self initPingJiaCell:cell andRate:rate];
        
        return cell;
    }
   
    return nil;
}
char* g_asskey = "g_asskey";
- (void)initPingJiaCell:(PingJiaCell *)cell andRate:(SOrderRateInfo *)rate{

    [cell.mHeadImg sd_setImageWithURL:[NSURL URLWithString:rate.mAvatar] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    cell.mName.text = rate.mUserName;
    cell.mTime.text = rate.mCreateTime;
    cell.mStarImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"xing_%d",rate.mStar]];
    cell.mContent.text = rate.mContent;
    cell.mReply.text = ([rate.mReply isEqualToString:@""]?@"":[NSString stringWithFormat:@"回复：%@",rate.mReply]);
    
    
    
    if( rate.mImages.count > 0 )
    {
        cell.mImgBgView.hidden = NO;
        if (rate.mImages.count>4) {
            cell.mImgViewHeight.constant = 95;
        }else{
            cell.mImgViewHeight.constant = 40;
        }
        
        for ( int  j = 0 ; j < 8; j++) {
            
            UIImageView * oneimg = (UIImageView *)[cell.mImgBgView viewWithTag:j+1];
            oneimg.image = nil;
            
            if (j < rate.mImages.count) {
                
                NSString* oneurl = rate.mImages[j];
                
                [oneimg sd_setImageWithURL:[NSURL URLWithString:oneurl] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
                
                if( !oneimg.userInteractionEnabled )
                {
                    oneimg.userInteractionEnabled  = YES;
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
                    [oneimg addGestureRecognizer:tap];
                }
                
                objc_setAssociatedObject(oneimg, g_asskey, nil, OBJC_ASSOCIATION_ASSIGN);
                objc_setAssociatedObject(oneimg, g_asskey, rate, OBJC_ASSOCIATION_ASSIGN);
            }
            
        }
        
    }else{
        
        cell.mImgViewHeight.constant = 0;
        cell.mImgBgView.hidden = YES;
    }

}
-(void)imageClick:(UITapGestureRecognizer*)sender
{
    UIImageView* tagv = (UIImageView*)sender.view;
    
    SOrderRateInfo *rate = objc_getAssociatedObject(tagv, g_asskey);
    NSMutableArray* allimgs = NSMutableArray.new;
    for ( NSString* url in rate.mImages )
    {
        MJPhoto* onemj = [[MJPhoto alloc]init];
        onemj.url = [NSURL URLWithString:url ];
        onemj.srcImageView = tagv;
        [allimgs addObject: onemj];
    }
    
    MJPhotoBrowser* browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = tagv.tag-1;
    browser.photos  = allimgs;
    [browser show];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _mLeftTableV){
        
        leftIndexPath = indexPath;
        
        leftSelectWillTo = (int)indexPath.row;
        //先看这个分类下面是否有数据,
        NSInteger thissectioncount = [self tableView:_mRightTableV numberOfRowsInSection:indexPath.row];
        if( thissectioncount == 0 )
        {///如果没有,,只能滚动 scrollview到指定地方
            CGRect f = [_mRightTableV rectForSection:indexPath.row];
            //[_mRightTableV scrollRectToVisible:f animated:YES];
            [_mRightTableV setContentOffset:f.origin animated:YES];
            
        }
        else
        {//有,就直接过了,
            [_mRightTableV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else if(tableView == _mRightTableV){
     
        SGoods *goods = nil;
        id itobj = [_allgoodsinfo objectForKey:[self mk:indexPath.section]];
        itobj = [itobj objectAtIndex:indexPath.row];
        if( [itobj isKindOfClass:[SGoods class]] )
        {
            goods = itobj;
            if ( goods.mId == -1 ) {
                return;
            }
        }
        else if( [itobj isKindOfClass:[SGoodsNorms class]] )
        {
            goods = [self findGoodswithNorm:itobj];
        }
        else if( [itobj isKindOfClass:[NSString class]] )
        {
            [self extendOneSection:indexPath];
            [_mRightTableV reloadData];
            return;
        }
        else
        {
            NSLog(@"may be erorr class:%@",[itobj class]);
        }
        
        SellerDetailVC *seller = [[SellerDetailVC alloc] initWithNibName:@"SellerDetailVC" bundle:nil];
        seller.mGoods = goods;
        seller.mSeller = _mSeller;
        seller.mType = goods.mType;
        seller.mSumNum = sunNum;
        seller.mSumprice = sumPrice;
        [self pushViewController:seller];
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
        
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        sender.mGoods.mNormId = norm.mId;
        sender.mGoods.mCount = goCarNum;
    }


    goCarNum ++;
    choseView.mNum.text = [NSString stringWithFormat:@"%d",goCarNum];
}

- (void)JianClick:(CellButton *)sender{
    
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        if (!tempBT) {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
            
            return;
        }
        
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        sender.mGoods.mNormId = norm.mId;
        sender.mGoods.mCount = goCarNum;
    }

    
    if (goCarNum>0) {
        
        goCarNum --;
        choseView.mNum.text = [NSString stringWithFormat:@"%d",goCarNum];
    }
    
}

- (void)AddCarClick:(CellButton *)sender{
    
    SGoodsNorms *norm;
    
    if (sender.mGoods.mNorms.count>1) {
        if (!tempBT) {
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品规格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alt show];
            
            return;
        }
        
        int index = (int)tempBT.tag;
        norm = [sender.mGoods.mNorms objectAtIndex:index];
        sender.mGoods.mNormId = norm.mId;
        sender.mGoods.mCount = goCarNum;
    }
    
    
    if (goCarNum<=0) {
        
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品数量" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alt show];
        
        return;
    }
    
    
    
    
    [SVProgressHUD showWithStatus:@"操作中.." maskType:SVProgressHUDMaskTypeClear];
    [sender.mGoods addToCart:norm block:^(SResBase *info, NSArray *all){
        
        if (info.msuccess) {
            
            if (all.count >0) {
                
                
                sunNum = 0;
                sumPrice = 0;
                
                for (SCarSeller *carseller in all) {
                    
                    if( carseller.mId == _mSeller.mId )
                    {
                        for (SCarGoods *cargoods in carseller.mCarGoods) {
                            
                            sunNum += cargoods.mNum;
                            sumPrice += cargoods.mPrice*cargoods.mNum;
                        }
                    }
                }
                
                badgeView.hidden = NO;
                badgeView.badgeText = [NSString stringWithFormat:@"%d",sunNum];
                _mSumPrice.text = [NSString stringWithFormat:@"¥%.2f元",sumPrice];
                _mSumPrice.font = [UIFont systemFontOfSize:20];
                
                [_mSuccess setTitle:@"选好了" forState:UIControlStateNormal];
                [_mSuccess setBackgroundColor:M_CO];
                _mSuccess.enabled = YES;
                if ( (_mSeller.mServiceFee - sumPrice ) > 0.001f ) {
                    [_mSuccess setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
                    [_mSuccess setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
                    _mSuccess.enabled = NO;
                }
                
                
                [_mRightTableV reloadData];

                
                
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                if(mainAry.count >0)
                    item.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[mainAry count]];
                else
                    item.badgeValue = nil;
            }
            
            [SVProgressHUD showSuccessWithStatus:info.mmsg];
            
            goCarNum = 0;
            [self closeChoseView];
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
   
}

- (void)BuyClick:(CellButton *)sender{
    
    
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
    
    //添加到购物车,,数量就是 mCount
    [sender.mGoods addToCart:norm block:^(SResBase *info, NSArray *all){
        
        if (info.msuccess) {
            [SVProgressHUD dismiss];
            
            
            
            if (all.count>0) {
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
                
                
                UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                if(mainAry.count >0)
                    item.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[mainAry count]];
                else
                    item.badgeValue = nil;
                
                BalanceVC *balance = [[BalanceVC alloc] initWithNibName:@"BalanceVC" bundle:nil];
                balance.mGoodsAry = goodsAry;
                balance.mCarSeller = carseller;
                
                [self pushViewController:balance];

            }
            
            
//            [self closeChoseView];
        }else{
            
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];

    
}

- (void)delNum:(int)num andGoods:(SGoods *)goods andNorm:(SGoodsNorms *)norm{

        if ([SUser isNeedLogin]) {
            [self gotoLoginVC];
            return;
        }
    
        goods.mCount +=num;
        norm.mCount +=num;
    
        [SVProgressHUD showWithStatus:@"操作中" maskType:SVProgressHUDMaskTypeClear];
        [goods addToCart:norm block:^(SResBase *info, NSArray *all){
            
            if (info.msuccess) {
                
                [SVProgressHUD dismiss];
                
                
                sunNum = 0;
                sumPrice = 0;
                
                if (all.count>0) {
                    
                    for (SCarSeller *seller in all) {
                        if( seller.mId == _mSeller.mId )
                        {
                            for (SCarGoods *goods in seller.mCarGoods) {
                                sunNum += goods.mNum;
                                sumPrice += goods.mPrice*goods.mNum;
                            }
                        }
                    }

                    UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
                    if(mainAry.count >0)
                        item.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)[mainAry count]];
                    else
                        item.badgeValue = nil;
                    
                    
                }
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
                
                
                [_mSuccess setTitle:@"选好了" forState:UIControlStateNormal];
                [_mSuccess setBackgroundColor:M_CO];
                _mSuccess.enabled = YES;
                if ( (_mSeller.mServiceFee - sumPrice) > 0.001f ) {
                    [_mSuccess setTitle:[NSString stringWithFormat:@"还差%.2f元起送",_mSeller.mServiceFee-sumPrice] forState:UIControlStateNormal];
                    [_mSuccess setBackgroundColor:[UIColor colorWithRed:202/255.f green:201/255.f blue:200/255.f alpha:1]];
                    _mSuccess.enabled = NO;
                }
                
                [_mRightTableV reloadData];
                
            }else{
                
                goods.mCount -=num;
                norm.mCount -=num;
                
                [SVProgressHUD showErrorWithStatus:info.mmsg];
            }
        }];
    
    

}

- (void)AddClick:(CellButton *)sender{
    
    if( [sender.mrefobj isKindOfClass:[SGoods class]] )
    {//选择的商品,,这种是没有规格的那种
        
        SGoods *goods = sender.mrefobj;
        SGoodsNorms *norm = goods.mNorms.firstObject;
        [self delNum:1 andGoods:goods andNorm:norm];
        
    }
    else if( [sender.mrefobj isKindOfClass:[SGoodsNorms class]] )
    {//这种是有规格的,选择了某个规格
        SGoodsNorms *norm = sender.mrefobj;
        SGoods *goods = [self findGoodswithNorm: norm];
        if( goods == nil )
        {
            NSLog(@"may be error deal goods norms");
        }
        [self delNum:1 andGoods:goods andNorm:norm];
    }
    else
    {
        NSLog(@"may be error deal goods norms cell erfobj");
    }
    
//  [self layoutChoseView:goods];
    
}
- (void)DelClick:(CellButton *)sender{
    if( [sender.mrefobj isKindOfClass:[SGoods class]] )
    {//选择的商品,,这种是没有规格的那种
        
        SGoods *goods = sender.mrefobj;
        SGoodsNorms *norm = goods.mNorms.firstObject;
        [self delNum:-1 andGoods:goods andNorm:norm];
        
    }
    else if( [sender.mrefobj isKindOfClass:[SGoodsNorms class]] )
    {//这种是有规格的,选择了某个规格
        SGoodsNorms *norm = sender.mrefobj;
        SGoods *goods = [self findGoodswithNorm: norm];
        if( goods == nil )
        {
            NSLog(@"may be error deal goods norms");
        }
        [self delNum:-1 andGoods:goods andNorm:norm];
    }
    else
    {
        NSLog(@"may be error deal goods norms cell erfobj");
    }
}


#pragma 评价
-(void)headerBeganRefresh
{
    self.page = 1;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    
    [SOrderRateInfo getComments:pjSelect page:self.page sellerId:_mSeller.mId block:^(SResBase *resb, NSArray *arr){
        
        
        [self.tableView headerEndRefreshing];
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",pjSelect];
            
            [tempDic setObject:arr forKey:key2];
            
            if (arr.count==0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [self addEmptyViewWithImg:@"noitem"];
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
    
}
-(void)footetBeganRefresh
{
    self.page++;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [SOrderRateInfo getComments:pjSelect page:self.page sellerId:_mSeller.mId block:^(SResBase *resb, NSArray *arr){
        
        
        [self.tableView footerEndRefreshing];
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            NSString *key2 = [NSString stringWithFormat:@"nowselectdata%d",pjSelect];
            
            NSArray *arr2 = [tempDic objectForKey:key2];
            
            if (arr.count!=0) {
                [self removeEmptyView];
                
                
                NSMutableArray *array = [NSMutableArray array];
                if (arr2) {
                    [array addObjectsFromArray:arr2];
                }
                [array addObjectsFromArray:arr];
                [tempDic setObject:array forKey:key2];
            }else
            {
                if(!arr||arr.count==0)
                {
                    [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                }
                else
                    [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                //   [self addEmptyView:@"暂无数据"];
                
            }
            
            [self.tableView reloadData];
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
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


- (IBAction)CarClick:(id)sender {
    
    if (sunNum <= 0) {
        [SVProgressHUD showErrorWithStatus:@"购物车为空"];
        return;
    }
    
    self.tabBarController.selectedIndex = 1;
    [self popToRootViewController];
    
}

- (IBAction)GoPlaceClick:(id)sender {
    
    if (sunNum <= 0) {
        [SVProgressHUD showErrorWithStatus:@"购物车为空"];
        return;
    }
    
    [ShopCarVC willMarkAll];
    
    self.tabBarController.selectedIndex = 1;
    [self popToRootViewController];
}

- (IBAction)mTopClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (tempBtn == sender) {
        return;
    }
    else
    {
        if (button.tag ==10) {
            NSLog(@"left");
            nowSelect = 0;
            [self.view bringSubviewToFront:_mGoodsView];
        }
        else if(button.tag == 11)
        {
            nowSelect = 1;
            NSLog(@"mid");
            if (!isLoadPj) {
                [self loadPingJia];
            }else{
                 [self.view bringSubviewToFront:pjTableView];
            }
        }
        else
        {
            nowSelect = 2;
            NSLog(@"right");
            
            if (!isLoadSeller) {
                [self loadSellerDetail];
            }else{
                [self.view bringSubviewToFront:sellerView];
            }
            
        }
        
        [tempBtn setTitleColor:COLOR(126, 121, 124) forState:UIControlStateNormal];
        [button setTitleColor:M_CO forState:UIControlStateNormal];
        
        tempBtn = button;
        
    }
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        lineImage.center = button.center;
        CGRect rect = lineImage.frame;
        rect.origin.y = 52;
        lineImage.frame = rect;
    }];

}

- (void)loadPingJia{

    tempDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    pjTableView = [[UITableView alloc] initWithFrame:_mGoodsView.frame];
    pjTableView.delegate = self;
    pjTableView.dataSource = self;
    [self.view addSubview:pjTableView];
    self.tableView = pjTableView;
    
    UINib *nib = [UINib nibWithNibName:@"PingJiaCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"pjcell"];
    
    headView= [PingJiaHeadView shareView];
    [self.tableView setTableHeaderView:headView];
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = UIView.new;
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [SOrderRate getRateNum:_mSeller.mId block:^(SResBase *resb, SOrderRate *rate) {
        
        if (resb.msuccess) {
            
            [SVProgressHUD dismiss];
            
            myRate = rate;
            
            headView.mFen.text = [NSString stringWithFormat:@"%.1f",rate.mStar];
            [self setXingXing:rate.mStar];
            isLoad = YES;
            [self loadSectionView];
            [pjTableView headerBeginRefreshing];
        }else{
        
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
    isLoadPj = YES;
}


- (void)setXingXing:(CGFloat)score{
    
    
    for (UIImageView *i in headView.mXing.subviews) {
        [i removeFromSuperview];
    }
    
    NSString *string =  [NSString stringWithFormat:@"%.1f",score];
    
    NSRange range = [string rangeOfString:@"."];
    NSRange range2 = {0,range.location};
    NSRange range3 = {range.location+1,1};
    int z = [[string substringWithRange:range2] intValue];
    int f = [[string substringWithRange:range3] intValue];
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView *igv = [[UIImageView alloc] initWithFrame:CGRectMake(i*25, 0, 21, 21)];
        if (i<z) {
            igv.image = [UIImage imageNamed:@"hongxing"];
        }else{
            igv.image = [UIImage imageNamed:@"huixing"];
        }
        
        if (f > 0) {
            if (i == z) {
                
                float ff = (float)f;
                UIImage *image = [UIImage imageNamed:@"hongxing"];
                float j = ff/10*21;
                UIEdgeInsets e = UIEdgeInsetsMake(0, j, 0, 0);
                UIImage *tinted = [image rt_tintedImageWithColor:COLOR(184, 184, 184) insets:e];
                [igv setImage:tinted];
            }
        }
        
        [headView.mXing addSubview:igv];
    }
}


- (void)loadSectionView{
    
    
    sectionView = [PingJiaHeadView shareView2];
    
    sectionView.mAllBT.layer.cornerRadius = 12;
    sectionView.mHaoBT.layer.cornerRadius = 12;
    sectionView.mZhongBT.layer.cornerRadius = 12;
    sectionView.mChaBT.layer.cornerRadius = 12;
    
    sectionView.mHaoBT.layer.borderWidth = 1;
    sectionView.mHaoBT.layer.borderColor = COLOR(226, 226, 226).CGColor;
    
    sectionView.mZhongBT.layer.borderWidth = 1;
    sectionView.mZhongBT.layer.borderColor = COLOR(226, 226, 226).CGColor;
    
    sectionView.mChaBT.layer.borderWidth = 1;
    sectionView.mChaBT.layer.borderColor = COLOR(226, 226, 226).CGColor;
    
    
    [sectionView.mAllBT setTitle:[NSString stringWithFormat:@"全部(%d)",myRate.mTotalCount] forState:UIControlStateNormal];
    [sectionView.mHaoBT setTitle:[NSString stringWithFormat:@"好评(%d)",myRate.mGoodCount] forState:UIControlStateNormal];
    [sectionView.mZhongBT setTitle:[NSString stringWithFormat:@"中评(%d)",myRate.mNeutralCount] forState:UIControlStateNormal];
    [sectionView.mChaBT setTitle:[NSString stringWithFormat:@"差评(%d)",myRate.mBadCount] forState:UIControlStateNormal];
    
    [sectionView.mAllBT addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.mHaoBT addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.mZhongBT addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView.mChaBT addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    tempPjBT = sectionView.mAllBT;
}

- (void)loadSellerDetail{
    
    

    sellerView  = [SellerView shareView];
    sellerView.frame = _mGoodsView.frame;
    [self.view addSubview:sellerView];
    
    [sellerView.mCallBT addTarget:self action:@selector(CallClick:) forControlEvents:UIControlEventTouchUpInside];
    isLoadSeller = YES;
    [sellerView.mAdvBT addTarget:self action:@selector(AdvClick:) forControlEvents:UIControlEventTouchUpInside];
    
    sellerView.mImg.layer.masksToBounds = YES;
    sellerView.mImg.layer.cornerRadius = 35;
    
    [self addMEmptyView:sellerView rect:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height-100)];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [_mSeller getDetail:^(SResBase *info) {
        if (info.msuccess) {
            
            [SVProgressHUD dismiss];
            [self removeMEmptyView];
            [sellerView.mImg sd_setImageWithURL:[NSURL URLWithString:_mSeller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
            sellerView.mName.text = [NSString stringWithFormat:@"%@",_mSeller.mName];
            
            sellerView.mTime.text = [NSString stringWithFormat:@"%@",_mSeller.mBusinessHours];
            
            
            sellerView.mQPrice.text = [NSString stringWithFormat:@"¥%.2f",_mSeller.mServiceFee];
            sellerView.mPPrice.text = [NSString stringWithFormat:@"¥%.2f",_mSeller.mDeliveryFee];
            sellerView.mPhone.text = [NSString stringWithFormat:@"%@",_mSeller.mMobile];
            sellerView.mAddress.text = _mSeller.mAddress;
            sellerView.mAdv.text = AdvString;
            
            if (AdvString.length == 0) {
                sellerView.mAdvHeight.constant = 0;
            }
           
            [sellerView.mBgImg sd_setImageWithURL:[NSURL URLWithString:_mSeller.mImage] placeholderImage:[UIImage imageNamed:@"sellerBg"]];
            
            if (_mSeller.mDetail.length == 0) {
                sellerView.mRemark.text = @"暂无介绍";
            }else{
                sellerView.mRemark.text = _mSeller.mDetail;
            }

        }else{
        
            [SVProgressHUD showErrorWithStatus:info.mmsg];
        }
    }];
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
    
    isShowCar = YES;
}

- (void)GuigeClick:(CellButton *)sender{
    
    tempBT.layer.borderColor = COLOR(107, 107, 109).CGColor;
    tempBT.layer.borderWidth = 0.5;
    [tempBT setTitleColor:COLOR(107, 107, 109) forState:UIControlStateNormal];
    [tempBT setBackgroundColor:[UIColor whiteColor]];
    
    sender.layer.borderWidth = 0;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender setBackgroundColor:M_CO];
   
    SGoodsNorms *norm = [sender.mGoods.mNorms objectAtIndex:sender.tag];
    choseView.mNum.text = [NSString stringWithFormat:@"%d",norm.mCount];
    goCarNum = norm.mCount;
    tempBT = sender;
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
        
        [_mRightTableV reloadData];
    }];
    
    isShowCar = NO;
    
}


















@end
