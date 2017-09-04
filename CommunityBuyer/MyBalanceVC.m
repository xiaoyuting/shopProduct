//
//  MyBalanceVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/2/22.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "MyBalanceVC.h"
#import "RechargeVC.h"
#import "BalanceCell.h"
#import "dateModel.h"

@interface MyBalanceVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyBalanceVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];

    self.mPageName = @"我的余额";
    self.Title = self.mPageName;
    
    
    self.mRecordTable.delegate=self;
    self.mRecordTable.dataSource=self;
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"BalanceCell" bundle:nil];
    [self.mRecordTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    
    
    self.tableView = self.mRecordTable;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self addData];

}

- (void)addData{
    
    
    SUser* tt  = SUser.new;
    int page=1;
    [self.tempArray removeAllObjects];

    [tt getbalance:^(SResBase *resb,NSString *balance){
        
        if (resb.msuccess) {
            _mBalance.text=balance;
        }else{
            _mBalance.text=@"0";
        }

        
    }];
    
   
    
    [tt getMyYueList:page block:^(SResBase* resb,NSArray* all){
        
        
        for (NSDictionary *mdic in all) {
            

            NSArray *t1=@[[mdic objectForKey:@"payTypeStr"],[NSString stringWithFormat:@"订单号：%@",[mdic objectForKey:@"sn"]],[NSString stringWithFormat:@"余额：%.2f",[[mdic objectForKey:@"balance"] floatValue]],[mdic objectForKey:@"createTime"],[mdic objectForKey:@"money"],[mdic objectForKey:@"payType"]];
            
 
            [self.tempArray addObject:t1];
            
            
        }
        
        [self.tableView reloadData];
//        NSArray *t1=@[@"充值",@"订单号：13996976203",@"余额：365.33",@"2015-03-21 18:00",@"+198.00"];
//        NSArray *t2=@[@"消费",@"订单号：13996976203",@"余额：365.33",@"2015-03-21 18:00",@"-98.22"];
//        NSArray *t3=@[@"退款至余额",@"订单号：13996976203",@"余额：365.33",@"2015-03-21 18:00",@"+198.00"];
        
       
//        [self.tempArray addObject:t2];
//        [self.tempArray addObject:t3];

   
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BalanceCell *cell = (BalanceCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.mTradName.text=[self.tempArray objectAtIndex:indexPath.row][0];
    cell.mOrderID.text=[self.tempArray objectAtIndex:indexPath.row][1];
    cell.mBlance.text=[self.tempArray objectAtIndex:indexPath.row][2];
    cell.mTime.text=[self.tempArray objectAtIndex:indexPath.row][3];
    
    
    int payType=[[self.tempArray objectAtIndex:indexPath.row][5] intValue];
    
    
    if (payType==1) {
        cell.mTradPrice.text=[NSString stringWithFormat:@"-%.2f",[[self.tempArray objectAtIndex:indexPath.row][4] floatValue]];
        cell.mTradPrice.textColor=[UIColor grayColor];
    }else{
        cell.mTradPrice.text=[NSString stringWithFormat:@"+%.2f",[[self.tempArray objectAtIndex:indexPath.row][4] floatValue]];
        cell.mTradPrice.textColor=[UIColor redColor];
    }
    
    return cell;
    
}
- (IBAction)goChongzhi:(id)sender {
    
    
    RechargeVC *vc=[[RechargeVC alloc] initWithNibName:@"RechargeVC" bundle:nil];
    
    [self pushViewController:vc];
}
@end
