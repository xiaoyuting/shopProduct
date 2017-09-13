//
//  OwnerInfoVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "OwnerInfoVC.h"
#import "OwnerInfoCell.h"

@interface OwnerInfoVC ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation OwnerInfoVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"业主信息";
    self.Title = self.mPageName;
    [self addData];
    [self LoadUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)addData{
    
    
    NSArray *arr=[[NSArray alloc] init];

    arr=@[@"业主名",    [NSString stringWithFormat:@"%@",self.mtagAuth.mName]];
    [self.tempArray addObject:arr];
    
    
    NSString* ss =  [NSString stringWithFormat:@"%@#%@",self.mtagAuth.mBuild.mName,self.mtagAuth.mRoom.mRoomNum];
    arr=@[@"房产单元", ss];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"建筑面积",[NSString stringWithFormat:@"%d平方",self.mtagAuth.mRoom.mStructureArea]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"套内面积",[NSString stringWithFormat:@"%d平方",self.mtagAuth.mRoom.mRoomArea]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"手机",[NSString stringWithFormat:@"%@",self.mtagAuth.mMobile]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"入住时间",[NSString stringWithFormat:@"%@",self.mtagAuth.mRoom.mIntakeTime]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"物业费",[NSString stringWithFormat:@"￥%.2f",self.mtagAuth.mRoom.mPropertyFee]];
    [self.tempArray addObject:arr];
    
}


- (void)LoadUI{
 
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"OwnerInfoCell" bundle:nil];
    [self.mInfoTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    
    _mInfoTable.dataSource=self;
    _mInfoTable.delegate=self;
    
    
    
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OwnerInfoCell *cell = (OwnerInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mTitle.text=[self.tempArray objectAtIndex:indexPath.row][0];
    cell.mInfo.text=[self.tempArray objectAtIndex:indexPath.row][1];
    
    if (indexPath.row==6) {
        
        cell.mMonth.hidden=NO;
    }
    

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.tempArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 50;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
