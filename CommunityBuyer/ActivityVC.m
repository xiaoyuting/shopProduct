//
//  ActivityVC.m
//  PaoTuiBuyer
//
//  Created by 周大钦 on 15/8/7.
//  Copyright (c) 2015年 zdq. All rights reserved.
//

#import "ActivityVC.h"
#import "ActivityCell.h"

@interface ActivityVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ActivityVC

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    
    [super viewDidLoad];
    
    self.mPageName = @"活动查看";
    self.Title = self.mPageName;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_InNavBar_Height) delegate:self dataSource:self];
    
    UINib *nib = [UINib nibWithNibName:@"ActivityCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
//    self.haveHeader = YES;
//    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = COLOR(20, 128, 232);
    
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.tempArray.count;
    
    return [_mNotice count];
    
}



-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SNotice *notice = [_mNotice objectAtIndex:indexPath.row];
    cell.mName.text = notice.mName;
    cell.mContent.text = notice.mContent;
    cell.mType.text = notice.mServiceRange;
    cell.mTime.text = notice.mNoticeDate;
    
    if (notice.mType == 1) {
        cell.mImg.image = [UIImage imageNamed:@"act_waimai"];
    }else if (notice.mType == 2){
        cell.mImg.image = [UIImage imageNamed:@"act_paotui"];
    }else if (notice.mType == 3){
        cell.mImg.image = [UIImage imageNamed:@"act_jiazheng"];
    }else if (notice.mType == 4){
        cell.mImg.image = [UIImage imageNamed:@"act_qiche"];
    }else{
        cell.mImg.image = [UIImage imageNamed:@"act_qita"];
    }
    
    
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
