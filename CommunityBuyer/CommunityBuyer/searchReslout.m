//
//  searchReslout.m
//  CommunityBuyer
//
//  Created by zzl on 15/9/25.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "searchReslout.h"
#import "CollectCell.h"
#import "RestaurantDetailVC.h"
#import "SellerDetailView.h"
@interface searchReslout ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation searchReslout

- (void)viewDidLoad {
    self.hiddenTabBar = YES;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Title = @"搜索";
    self.mPageName = @"搜索结果";
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, self.contentView.bounds.size.height) delegate:self dataSource:self];
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = M_BGCO;
    
    UINib *nib = [UINib nibWithNibName:@"CollectCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 10)];
    headView.backgroundColor = M_BGCO;
    [self.tableView setTableHeaderView:headView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    [self.tableView headerBeginRefreshing];

}

-(void)headerBeganRefresh
{
    self.page = 1;
    
    
    [SSeller getAllSeller:0 page:self.page type:0 keyword:self.mSearchKey block:^(SResBase *info, NSArray *all) {
        
        [self headerEndRefresh];
        
        if (info.msuccess) {
            
            self.tempArray = [NSMutableArray arrayWithArray:all];
            
            if (all.count==0) {
                [self addSearchEmptyViewWithImg:@"search_emp"];
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
            [self addSearchEmptyViewWithImg:@"search_emp"];
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
    
    [SSeller getAllSeller:0 page:self.page type:0 keyword:self.mSearchKey block:^(SResBase *info, NSArray *all){
        [self footetEndRefresh];
        
        if (info.msuccess) {
            
            
            
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
    CollectCell *cell = (CollectCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
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
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[seller.mFreight dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.mQsPrice.attributedText = attrStr;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
//    
//    SellerDetailView *sellerView = [[SellerDetailView alloc] initWithNibName:@"SellerDetailView" bundle:nil];
//    sellerView.mSeller = seller;
//    
//    [self pushViewController:sellerView];
    
    /*
     选择搜索结果后去掉跳转店铺信息界面，直接跳转店铺商品界面
     */
    SSeller *seller = [self.tempArray objectAtIndex:indexPath.row];
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RestaurantDetailVC *viewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetailVC"];
    viewController.mSeller = seller;
    
    [self.navigationController pushViewController:viewController animated:YES];
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
