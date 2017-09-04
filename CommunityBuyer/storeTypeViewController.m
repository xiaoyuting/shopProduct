//
//  storeTypeViewController.m
//  CommunityBuyer
//
//  Created by 密码为空！ on 15/10/10.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "storeTypeViewController.h"
#import "storeTypeTableViewCell.h"
@interface storeTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation storeTypeViewController
{
    
    NSMutableArray *dataArr;

    UIButton *okBtn;
    
    SSellerCate *selectCate;
    
    storeTypeTableViewCell *myCell;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"经营类型";
    self.hiddenlll = YES;
    self.navBar.rightBtn.hidden = YES;

    dataArr = [NSMutableArray new];

    [self initView];
    
}

- (void)initView{
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_InNavBar_Height-70)delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"storeTypeTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.haveHeader = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = M_BGCO;
    
    [self.tableView headerBeginRefreshing];
    
    okBtn = [UIButton new];
    okBtn.frame = CGRectMake(15, self.tableView.frame.origin.y+self.tableView.frame.size.height+15, DEVICE_Width-30, 45);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"collectHong"] forState:0];
    [okBtn setTitle:@"确定" forState:0];
    [okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];

}
- (void)okAction:(UIButton *)sender{
    
    
    for (SSellerCate *sc in self.tempArray) {
        
        if (sc.mSelected) {
            NSMutableDictionary *dic = NSMutableDictionary.new;
            
            [dic setObject:@(sc.mId) forKey:@"id"];
            [dic setObject:sc.mName forKey:@"name"];
            [dataArr addObject:dic];
        }else{
        
            for (SSellerCate *cate in sc.mChilds) {
                
                
                
                if (cate.mSelected) {
                    NSMutableDictionary *dic = NSMutableDictionary.new;
                    
                    [dic setObject:@(cate.mId) forKey:@"id"];
                    [dic setObject:cate.mName forKey:@"name"];
                    [dataArr addObject:dic];
                }
            }
        }
    }
    
    MLLog(@"最后选择的是：%@",dataArr);
    __weak storeTypeViewController *mSelf = self;
    
    mSelf.itblock( dataArr );
//    [mSelf leftBtnTouched:nil];
    [mSelf popViewController];


}

- (void)headerBeganRefresh{
    
//    self.page = 0;
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    [SSellerCate getAllCates:0 andType:0 block:^(SResBase *resb, NSArray *all) {
        [self.tableView headerEndRefreshing];

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return self.tempArray.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0;
    }
    else{
        SSellerCate *model = [self.tempArray objectAtIndex:section-1];

        return model.mChilds.count;
    }
    
    
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
    if (tableView == self.tableView) {
        
        storeTypeTableViewCell *cell = (storeTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.mTableViewHeight = 0;
        
        cell.mTableView.delegate = self;
        cell.mTableView.dataSource = self;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SSellerCate *model = [self.tempArray objectAtIndex:indexPath.section-1];
        
        SSellerCate *cate = [model.mChilds objectAtIndex:indexPath.row];
        
        
        cell.mName.text = cate.mName;
        
        cell.mImg.hidden = cate.mSelected?NO:YES;
        
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    myCell.mImg.hidden = YES;
//    storeTypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.mImg.hidden = NO;
//    myCell = cell;
    
    SSellerCate *model = [self.tempArray objectAtIndex:indexPath.section-1];
    SSellerCate *cate = [model.mChilds objectAtIndex:indexPath.row];
//    selectCate.mSelected = NO;
    cate.mSelected = !cate.mSelected;
    selectCate = cate;
    
    
//    NSMutableDictionary *dic = NSMutableDictionary.new;
//    
//    [dic setObject:@(selectCate.mId) forKey:@"id"];
//    [dic setObject:selectCate.mName forKey:@"name"];
//    
////    [dataArr removeAllObjects];
//    [dataArr addObject:dic];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return 50;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *Hv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    Hv.backgroundColor = M_BGCO;
    UILabel* ll = [[UILabel alloc]initWithFrame: CGRectMake(15, 15, 150, 20)];
    ll.text = @"经营类型可进行多选";
    ll.font = [UIFont systemFontOfSize:15];
    ll.textColor = [UIColor lightGrayColor];
    [Hv addSubview:ll];
    
    
    if (section != 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 0.5)];
        line.backgroundColor = COLOR(208, 209, 211);
        [Hv addSubview:line];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, DEVICE_Width, 0.5)];
        line2.backgroundColor = COLOR(208, 209, 211);
        [Hv addSubview:line2];
        SSellerCate *model = [self.tempArray objectAtIndex:section-1];
        Hv.backgroundColor = [UIColor whiteColor];
        ll.textColor = [UIColor blackColor];
        ll.text = model.mName;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_Width-28, 15, 20, 20)];
        image.image = [UIImage imageNamed:@"my_store_selected"];
         [Hv addSubview:image];
        image.hidden = model.mSelected?NO:YES;
       
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEVICE_Width, 50)];
        [Hv addSubview:btn];
        btn.tag = section-1;
        [btn addTarget:self action:@selector(SectionClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return Hv;
    
}

- (void)SectionClick:(UIButton *)sender{

    SSellerCate *model = [self.tempArray objectAtIndex:sender.tag];
    
    model.mSelected = !model.mSelected;
    
    for (SSellerCate *c in model.mChilds) {
        
        c.mSelected = model.mSelected;
    }
    
    [self.tableView reloadData];
}

@end
