//
//  CollectVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/11.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "CollectVC.h"
#import "CollectCell.h"
#import "RestaurantDetailVC.h"
#import "CollectHeadView.h"
#import "ServiceDetailVC.h"
#import "SellerDetailVC.h"
#import "SellerDetailView.h"

@interface CollectVC ()<UITableViewDataSource,UITableViewDelegate>{

    int nowSelect;
}

@end

@implementation CollectVC
{
    CollectHeadView * _headView;
}
- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"我的收藏";
    self.Title = self.mPageName;
    
    nowSelect = 0;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height)delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"CollectCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"CollectCellTwo" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"cell2"];
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = M_BGCO;
    
    _headView = [CollectHeadView shareView];
    _headView.mLeft.tag = 0;
    [_headView.mLeft addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    _headView.mRight.tag = 1;
    [_headView.mRight addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView setTableHeaderView:_headView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [self.tableView headerBeginRefreshing];
}

- (void)ChoseClick:(UIButton *)sender{

    nowSelect = (int)sender.tag;
    if( nowSelect == 0 )
    {
        [_headView.mLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_headView.mRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _headView.mBgImg.image = [UIImage imageNamed:@"collectBT"];
    }
    else
    {
        [_headView.mLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_headView.mRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _headView.mBgImg.image = [UIImage imageNamed:@"collectBTu"];
    }
    
    [self.tableView headerBeginRefreshing];
}


-(void)headerBeganRefresh
{
    self.page = 1;
    
    
    if (nowSelect == 0) {
        
        [[SUser currentUser] getMyFavGoods:self.page block:^(SResBase *resb, NSArray *arr) {
            
            [self headerEndRefresh];
            
            if (resb.msuccess) {
                
                [self.tempArray removeAllObjects];
                [self.tempArray addObjectsFromArray:arr];
                
                if (arr.count==0) {
                    [self addEmptyViewWithImg:@"noitem"];
                }else
                {
                    [self removeEmptyView];
                }
                
                [self.tableView reloadData];
                
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
            if ( arr.count == 0 )
            {
                [self addEmptyViewWithImg:nil];
            }
            else
            {
                [self removeEmptyView];
            }
            
            [self.tableView reloadData];
            
        }];
    }else{
        
        [[SUser currentUser] getMyFavShop:self.page block:^(SResBase *resb, NSArray *arr) {
            
            [self headerEndRefresh];
            
            if (resb.msuccess) {
                
                [self.tempArray removeAllObjects];
                [self.tempArray addObjectsFromArray:arr];
                
                if (arr.count==0) {
                    [self addEmptyViewWithImg:@"noitem"];
                }else
                {
                    [self removeEmptyView];
                }
                
                [self.tableView reloadData];
                
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
            if ( arr.count == 0 )
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
    
    
    
}

- (void)footetBeganRefresh{
    
    
    
    self.page ++;
    
    if (nowSelect == 0) {
        
        [[SUser currentUser] getMyFavGoods:self.page block:^(SResBase *resb, NSArray *arr){
            [self footetEndRefresh];
            
            if (resb.msuccess) {
                
                
                
                if (arr.count!=0) {
                    [self removeEmptyView];
                    
                    [self.tempArray addObjectsFromArray:arr];
                    
                }else
                {
                    if(!arr||arr.count==0)
                    {
                        [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                    }
                    else
                        [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                    
                }
                [self.tableView reloadData];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
        }];
    }else{
    
        [[SUser currentUser] getMyFavShop:self.page block:^(SResBase *resb, NSArray *arr){
            [self footetEndRefresh];
            
            if (resb.msuccess) {
                
                
                
                if (arr.count!=0) {
                    [self removeEmptyView];
                    
                    [self.tempArray addObjectsFromArray:arr];
                    
                }else
                {
                    if(!arr||arr.count==0)
                    {
                        [SVProgressHUD showSuccessWithStatus:@"暂无数据"];
                    }
                    else
                        [SVProgressHUD showSuccessWithStatus:@"暂无新数据"];
                    
                }
                [self.tableView reloadData];
                
            }else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
                
            }
        }];
        
    }
    
    
 
}


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.tempArray.count;
    
    return self.tempArray.count;
    
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
    
    CollectCell *cell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (nowSelect == 0) {
        
        cell = (CollectCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        SGoods *goods = [self.tempArray objectAtIndex:indexPath.row];
        [cell.mImg sd_setImageWithURL:[NSURL URLWithString:goods.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        cell.mName.text = goods.mName;
        cell.mPrice.text = [NSString stringWithFormat:@"¥%.2f",goods.mPrice];
        if (goods.mSalesCount >0) {
            cell.mSellNum.text = [NSString stringWithFormat:@"已售 %d",goods.mSalesCount];
        }else{
            cell.mSellNum.text = @"";
        }
    
    }else{
    
        cell = (CollectCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
        
        [cell.mImg sd_setImageWithURL:[NSURL URLWithString:seller.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        cell.mName.text = seller.mName;

        cell.mKm.text = seller.mDist;
        [cell setStar:seller.mScore];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[seller.mFreight dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.mQsPrice.attributedText = attrStr;
        
        if (seller.mOrderCount >0) {
            cell.mSellNum.text = [NSString stringWithFormat:@"已售 %d",seller.mOrderCount];
        }else{
            cell.mSellNum.text = @"";
        }

        
    }
    
    cell.delegate = self;
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}



- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"取消收藏"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (index) {
            
        case 0:
        {
            if (nowSelect == 0) {
                
                SGoods *goods = [self.tempArray objectAtIndex:indexPath.row];
                goods.mIscollect = YES;
                [goods favIt:^(SResBase *resb) {
                    if( resb.msuccess )
                    {
                        [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                        [self.tempArray removeObjectAtIndex:indexPath.row];
                        [self.tableView beginUpdates];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                        
                    }
                    else
                        [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    
                }];
                
            }else{
            
                SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
                seller.mIsCollect = YES;
                
                [SVProgressHUD showWithStatus:@"正在操作..." maskType:SVProgressHUDMaskTypeClear];
                [seller favIt:^(SResBase *resb) {
                    if( resb.msuccess )
                    {
                        [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                        [self.tempArray removeObjectAtIndex:indexPath.row];
                        [self.tableView beginUpdates];
                        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                    }
                    else
                        [SVProgressHUD showErrorWithStatus:resb.mmsg];
                    
                }];
                
            }
            
           
            
            break;
          
        }
        default:
            break;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
    
    if (nowSelect == 0) {
        
        SGoods *goods = [self.tempArray objectAtIndex:indexPath.row];
//        WebVC* vc = [[WebVC alloc] init];
//        vc.mName = goods.mName;
//        vc.mUrl = [NSString stringWithFormat:@"%@Goods/detail?goodsId=%d",kAFAppDotNetAPIBaseURLStringW,goods.mId];
//        [self pushViewController:vc];
        SellerDetailVC *seller = [[SellerDetailVC alloc] initWithNibName:@"SellerDetailVC" bundle:nil];
        
        seller.mType = goods.mType;
        if (goods.mType == 1) {
            seller.mGoods = goods;
        }else{
            SServiceInfo *info = [[SServiceInfo alloc] init];
            info.mId = goods.mId;
            seller.mServiceInfo = info;
        }
        
        [self pushViewController:seller];
    }else{
        
        SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
        
        if(seller.mCountGoods>0 && seller.mCountService == 0){
            
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
            viewController.mSeller = seller;
            
            [self.navigationController pushViewController:viewController animated:YES];
            
        }else if(seller.mCountGoods == 0 && seller.mCountService > 0){
            
            ServiceDetailVC *serviceVC = [[ServiceDetailVC alloc] init];
            serviceVC.mSeller = seller;
            [self pushViewController:serviceVC];
        }else{
            SellerDetailView *sellerView = [[SellerDetailView alloc] initWithNibName:@"SellerDetailView" bundle:nil];
            sellerView.mSeller = seller;
            
            [self pushViewController:sellerView];
        };
        
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
