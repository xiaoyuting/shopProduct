//
//  AnnouncementVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "AnnouncementVC.h"
#import "AnnouncementCell.h"
#import "AnnouncementDetailVC.h"

@interface AnnouncementVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AnnouncementVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"社区公告";
    self.Title = self.mPageName;
    
    [self LoadUI];
    
    [self.tableView headerBeginRefreshing];
    
}

-(void)dealloc
{
    self.tableView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)LoadUI{
    
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
    [_mAnnounTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    
    _mAnnounTable.dataSource=self;
    _mAnnounTable.delegate=self;
    
    
    self.tableView = _mAnnounTable;
    
    self.haveHeader = YES;
}
-(void)headerBeganRefreshWithBlock:(void (^)(SResBase *, NSArray *))block
{
    [SArticle getArticlelist:_msellerid block:^(SResBase *resb, NSArray *all) {
       
        block( resb ,all);
        
    }];
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnnouncementCell *cell = (AnnouncementCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SArticle* oneobj = self.tempArray[ indexPath.row];
    
    
    NSString *time=oneobj.mCreateTime;
    
    cell.mTitle.text=oneobj.mTitle;
    cell.mContent.text=oneobj.mContent;
    cell.mTime.text=oneobj.mCreateTime;
    
    if (oneobj.mReadTime) {
        cell.mTitleToLeadWidth.constant=10;
        cell.mRedPoint.hidden=YES;
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.tempArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return UITableViewAutomaticDimension;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SArticle* oneobj = self.tempArray[ indexPath.row];
    
    AnnouncementDetailVC *vc=[[AnnouncementDetailVC alloc] initWithNibName:@"AnnouncementDetailVC" bundle:nil];
    
    vc.mSArticle=oneobj;
    
    [self pushViewController: vc];

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
