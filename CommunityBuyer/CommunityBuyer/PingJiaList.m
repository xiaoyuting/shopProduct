//
//  PingJiaList.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/11.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "PingJiaList.h"
#import "PingJiaCell.h"

@interface PingJiaList ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PingJiaList

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"用户评价";
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height)delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"PingJiaCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView headerBeginRefreshing];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)headerBeganRefresh
{
    self.page = 1;
    
    
     [_mServiceInfo getRateList:self.page block:^(SResBase *resb, NSArray *allrates) {
        
        [self headerEndRefresh];
        
        if (resb.msuccess) {
            
            [self.tempArray removeAllObjects];
            
            [self.tempArray addObjectsFromArray:allrates];
            
            if (allrates.count==0) {
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
        
        if ( allrates.count == 0 )
        {
             [self addEmptyViewWithImg:@"noitem"];
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
    
    [_mServiceInfo getRateList:self.page block:^(SResBase *resb, NSArray *allrates){
        [self footetEndRefresh];
        
        if (resb.msuccess) {
           
            
            if (allrates.count!=0) {
                [self removeEmptyView];
                
                [self.tempArray addObjectsFromArray:allrates];
            }else
            {
                if(!allrates||allrates.count==0)
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


#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    PingJiaCell *cell = (PingJiaCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    SOrderRateInfo *rateInfo = [self.tempArray objectAtIndex:indexPath.row];
    
    cell.mName.text = rateInfo.mUserName;
    cell.mTime.text = rateInfo.mCreateTime;
    cell.mStarImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"xing_%d",rateInfo.mStar]];
    cell.mContent.text = rateInfo.mContent;
    cell.mReply.text = rateInfo.mReply?[NSString stringWithFormat:@"回复：%@",rateInfo.mReply]:@"";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
