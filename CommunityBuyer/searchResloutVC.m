//
//  searchResloutVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/8.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "searchResloutVC.h"
#import "normaltieCell.h"
#import "TieDetailVC.h"

@interface searchResloutVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation searchResloutVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mPageName = @"帖子搜索结果";
    self.Title = self.mKeyWords;
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    
    UINib* nib = [UINib nibWithNibName:@"normaltieCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"n_cell"];
    
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    [self.tableView headerBeginRefreshing];
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SForumPosts* oneobj = self.tempArray[ indexPath.row];
    
    normaltieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"n_cell"];
    if( oneobj.mImagesArr.count == 0 )
    {
        cell.mbigimgconsth.constant = 0;
        cell.mbigimgconstw.constant = 0;
    }
    else
    {
        cell.mbigimgconsth.constant = 73.0f;
        cell.mbigimgconstw.constant = 73.0f;
    }
    cell.mtitle.text = oneobj.mTitle;
    
    [cell.mheadimg sd_setImageWithURL:[NSURL URLWithString:oneobj.mUser.mHeadImgURL ] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    
    cell.mname.text =  oneobj.mUser.mUserName;
    cell.mgoodscount.text = [NSString stringWithFormat:@"%d",oneobj.mGoodNum];
    cell.mcmmcount.text =[NSString stringWithFormat:@"%d",oneobj.mRateNum];
    cell.mtime.text = oneobj.mCreateTimeStr;
    
    if(  oneobj.mImagesArr.count )
    {
        NSString * oneurl = oneobj.mImagesArr[0];
        oneurl = [Util makeImgUrl:oneurl tagImg:cell.mbigimg];
        
        cell.mbigimgconsth.constant = 50;
        cell.mbigimgconstw.constant = 50;
        
        [cell.mbigimg sd_setImageWithURL:[NSURL URLWithString:oneurl] placeholderImage:[UIImage imageNamed:@"defultHead"]];
    }
    else
    {
        cell.mbigimgconsth.constant = 0;
        cell.mbigimgconstw.constant = 0;
    }
    
    cell.mgoodimg.image = oneobj.mIsPraise ? [UIImage imageNamed:@"ic_heart"] : [UIImage imageNamed:@"ic_heart_h"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SForumPosts* oneobj = self.tempArray[ indexPath.row];
    
    TieDetailVC* vc = [[TieDetailVC alloc]initWithNibName:@"TieDetailVC" bundle:nil];
    vc.mtagPost = oneobj;
    [self pushViewController:vc];
}

-(void)headerBeganRefresh
{
    self.page = 1;
    [SForumPosts searchPost:self.page keywords:self.mKeyWords block:^(SResBase *resb, NSArray *all) {
        
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        if( resb.msuccess )
        {
            [self.tempArray addObjectsFromArray:all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        [self.tableView reloadData];
        if( self.tempArray.count == 0 )
        {
            [self addSearchEmptyViewWithImg:@"search_emp"];
        }
        else
        {
            [self removeEmptyView];
        }
        
    }];
}
-(void)footetBeganRefresh
{
    self.page++;
    [SForumPosts searchPost:self.page keywords:self.mKeyWords block:^(SResBase *resb, NSArray *all) {
        
        [self footetEndRefresh];
        if( resb.msuccess )
        {
            [self.tempArray addObjectsFromArray:all];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        if( self.tempArray.count == 0 )
        {
            [self addSearchEmptyViewWithImg:@"search_emp"];
        }
        else
        {
            [self removeEmptyView];
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

@end
