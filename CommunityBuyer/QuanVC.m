//
//  QuanVC.m
//  CommunityBuyer
//
//  Created by zzl on 15/12/30.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "QuanVC.h"
#import "QuanCell.h"
#import "blockVC.h"
#import "myTie.h"
#import "allBlockVC.h"
#import "TieDetailVC.h"
#import "blockMsgVC.h"
#import "FaultRepairVC.h"
#import "WuyeManVC.h"
@interface QuanVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QuanVC
{
    SForumIndex*    _mtagIndex;
}
-(void)dealloc
{
    self.tableView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mPageName = self.Title = @"生活圈";
    self.hiddenBackBtn = YES;
    
    self.mittableview.tableFooterView = UIView.new;
    UINib* nib = [UINib nibWithNibName:@"QuanCell" bundle:nil];
    [self.mittableview registerNib:nib forCellReuseIdentifier:@"cell"];
    self.mittableview.delegate = self;
    self.mittableview.dataSource = self;
    
    self.tableView = self.mittableview;
    
    self.haveHeader = YES;
}

-(void)headerBeganRefresh
{
    [SForumIndex getForumIndex:^(SResBase *resb, SForumIndex *retobj) {
        
        [self headerEndRefresh];
        if( resb.msuccess )
        {
            _mtagIndex =  retobj;
            [self updatePage];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if( self.mittableview.tableHeaderView == nil )
        self.mittableview.tableHeaderView = self.mtopwaper;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];

}
 
-(void)updatePage
{
    self.mlefttxt.text = [NSString stringWithFormat:@"我的帖子(%d)",_mtagIndex.mPostsnum];
    self.mrighttxt.text = [NSString stringWithFormat:@"论坛消息(%d)",_mtagIndex.mMessagenum];
    
    for ( int j = 0; j < _mtagIndex.mPlates.count ; j++ ) {
        UIView* onev = [self.mimagewaper viewWithTag: j+1];
        SForumPlate* oneobj = _mtagIndex.mPlates[j];
        for (UIView* onesv in onev.subviews ) {
            if( [onesv isKindOfClass:[UIImageView class]] )
            {
                UIImageView* ff = (UIImageView*)onesv;
                [ff sd_setImageWithURL:[NSURL URLWithString:oneobj.mIcon] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
            }
            else if( [onesv isKindOfClass:[UILabel class]] )
            {
                UILabel* ff = (UILabel*)onesv;
                ff.text = oneobj.mName;
            }
        }
    }
    
    if( _mtagIndex.mPlates.count < 5  )
        self.mimgwaperconst.constant = 85;
    else
        self.mimgwaperconst.constant = 160;
    
    [self.mtopwaper layoutIfNeeded];
    self.mittableview.tableHeaderView = self.mtopwaper;

    [self.mittableview reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mtagIndex.mPosts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuanCell* cell      =   [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SForumPosts* oneobj =   _mtagIndex.mPosts[ indexPath.row ];
    cell.mtitle.text = oneobj.mTitle;
    cell.msubtitle.text = oneobj.mPlate.mName;
    cell.mtime.text = oneobj.mCreateTimeStr;
    cell.mcount.text = [NSString stringWithFormat:@"%d",oneobj.mRateNum];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SForumPosts* oneobj =   _mtagIndex.mPosts[ indexPath.row ];
    TieDetailVC* vc = [[TieDetailVC alloc]initWithNibName:@"TieDetailVC" bundle:nil];
    vc.mtagPost = oneobj;
    [self pushViewController:vc];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (IBAction)platclicked:(UIButton*)sender {
    
    NSInteger i = sender.superview.tag -1;
    if(  i >= _mtagIndex.mPlates.count || i < 0 )
        return;
    
    SForumPlate* oneblock = _mtagIndex.mPlates[ i ];
    
    if( oneblock.mId == 0 )
    {//更多
        allBlockVC* vc = [[allBlockVC alloc]init];
        [self pushViewController:vc];
    }
    else if( oneblock.mId == 1)
    {//物业
        WuyeManVC* vc = [[WuyeManVC alloc]initWithNibName:@"WuyeManVC" bundle:nil];
        [self pushViewController:vc];
    }
    else
    {
        blockVC* vc = [[blockVC alloc]init];
        vc.mtagPlate = oneblock;
        [self pushViewController:vc];
    }
}

- (IBAction)leftclicked:(id)sender {
    
    myTie* vc = [[myTie alloc] init];
    [self pushViewController:vc];
}

- (IBAction)rightclicked:(id)sender {
    
    blockMsgVC * vc = [[blockMsgVC alloc]init];
    [self pushViewController:vc];
    
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
