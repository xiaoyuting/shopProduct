//
//  MessageVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/9/21.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "MessageVC.h"
#import "MsgCell.h"
#import "messageDetailView.h"
#import "OrderDetailVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MessageVC

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
    [self.tableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"系统消息";
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height)delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"MsgCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = M_BGCO;

}

- (void)headerBeganRefresh{
    
    self.page = 1;

    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    
    [[SUser currentUser] getMyMsg:self.page block:^(SResBase *resb, NSArray *arr) {
        
        [self.tableView headerEndRefreshing];
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            self.tempArray = [[NSMutableArray alloc] initWithArray:arr];
            
            if (arr.count==0) {
                [self addEmptyViewWithImg:@"noitem"];
            }else
            {
                [self removeEmptyView];
            }
            
            [self.tableView reloadData];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
}

- (void)footetBeganRefresh{

    self.page ++;
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeClear];
    
    [[SUser currentUser] getMyMsg:self.page block:^(SResBase *resb, NSArray *arr) {
        
        [self.tableView footerEndRefreshing];
        if (resb.msuccess) {
            [SVProgressHUD dismiss];
            
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
    
    MsgCell *cell = (MsgCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SMessageInfo *msg = [self.tempArray objectAtIndex:indexPath.row];
    cell.mNew.hidden=msg.mIsRead;
    
    cell.mName.text = msg.mTitle;
    cell.mTime.text = msg.mCreateTime;
    cell.mContent.text = msg.mContent;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    messageDetailView *msgDetail = [[messageDetailView alloc]initWithNibName:@"messageDetailView" bundle:nil];
    
    
    SMessageInfo *msg = [self.tempArray objectAtIndex:indexPath.row];
    msgDetail.msgObj = msg;
    
    [msg readThis:^(SResBase *resb) {
        
    }];
    
    if( msg.mType == 1 )
    {
        
       [self pushViewController:msgDetail];
    }
    else if( msg.mType == 2 )
    {
        WebVC* vc = [[WebVC alloc] init];
        vc.mName = msg.mTitle;
        vc.mUrl = msg.mArgs;
        [self pushViewController:vc];
    }
    else if( msg.mType == 3 || msg.mType == 4 )
    {
        [OrderDetailVC gotoOrderDetailWithOrderId:[msg.mArgs intValue] vc:self];
    }
    
    else{
        [self pushViewController:msgDetail];
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
