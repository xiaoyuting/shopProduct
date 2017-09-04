//
//  MoreVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/10/12.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "MoreVC.h"
#import "OwnCell.h"
#import "RestaurantVC.h"

@interface MoreVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];

    self.mPageName = @"全部分类";
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height) delegate:self  dataSource:self];
    
    self.tableView.backgroundColor = M_BGCO;
    self.tableView.userInteractionEnabled = YES;
    
    
    UINib *nib = [UINib nibWithNibName:@"OwnCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    [SSellerCate getAllCates:0 andType:0 block:^(SResBase *resb, NSArray *all) {
        
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
           
            for(SSellerCate *cate in all){
            
                NSMutableArray *arry = (NSMutableArray *)cate.mChilds;
                
                [arry removeObjectAtIndex:0];
            }
            
            self.tempArray = [[NSMutableArray alloc] initWithArray:all];
            
            [self.tableView reloadData];
           
        }else{
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return self.tempArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SSellerCate *model = [self.tempArray objectAtIndex:section];

    return model.mChilds.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OwnCell *cell = (OwnCell *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
    line.backgroundColor = M_LINECO;
    
    cell.mSwith.hidden = YES;
    SSellerCate *model = [self.tempArray objectAtIndex:indexPath.section];
    SSellerCate *cate = [model.mChilds objectAtIndex:indexPath.row];
    cell.mImage.hidden = YES;
    [cell.mImage sd_setImageWithURL:[NSURL URLWithString:cate.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    cell.mName.text = cate.mName;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSellerCate *model = [self.tempArray objectAtIndex:indexPath.section];
    SSellerCate *cate = [model.mChilds objectAtIndex:indexPath.row];

    RestaurantVC *viewController = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
    viewController.mGoodsName = cate.mName;
    viewController.mGoodsId = cate.mId;
    viewController.mType = cate.mType;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    SSellerCate *model = [self.tempArray objectAtIndex:section];
    UIView *Hv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    Hv.backgroundColor = M_BGCO;
    UILabel* ll = [[UILabel alloc]initWithFrame: CGRectMake(45, 15, 150, 20)];;
    ll.font = [UIFont systemFontOfSize:15];
    [Hv addSubview:ll];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 30, 30)];
    [Hv addSubview:imgV];
    [imgV sd_setImageWithURL:[NSURL URLWithString:model.mLogo] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
    line.backgroundColor = COLOR(208, 209, 211);
    [Hv addSubview:line];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DEVICE_Width, 0.5)];
    line2.backgroundColor = COLOR(208, 209, 211);
    [Hv addSubview:line2];
    Hv.backgroundColor = [UIColor whiteColor];
    ll.textColor = [UIColor blackColor];
    ll.text = model.mName;
    
    Hv.tag = section;
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(GoSeller:)];
    [Hv addGestureRecognizer:tap];
    
    
    return Hv;
}

- (void)GoSeller:(UITapGestureRecognizer *)sender{

    int index = (int)sender.view.tag;
    
     SSellerCate *cate = [self.tempArray objectAtIndex:index];
    
    RestaurantVC *viewController = [[RestaurantVC alloc] initWithNibName:@"RestaurantVC" bundle:nil];
    viewController.mGoodsName = cate.mName;
    viewController.mGoodsId = cate.mId;
    viewController.mType = cate.mType;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0;
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
