//
//  blockMsgVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "blockMsgVC.h"
#import "blockmsgcell.h"
#import "TieDetailVC.h"
@interface blockMsgVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation blockMsgVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mPageName = self.Title = @"论坛消息";
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, self.contentView.bounds.size.height) delegate:self dataSource:self];
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    UINib * nib = [UINib nibWithNibName:@"blockmsgcell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    [self.tableView headerBeginRefreshing];
}

-(void)headerBeganRefresh
{
    self.page = 1;
    [[SUser currentUser]getTieMsg:self.page block:^(SResBase *resb, NSArray *all) {
        
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
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeMEmptyView];
        }
        
    }];
    
}
-(void)footetBeganRefresh
{
    self.page ++;
    [[SUser currentUser]getTieMsg:self.page block:^(SResBase *resb, NSArray *all) {
        
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
            [self addEmptyViewWithImg:nil];
        }
        else
        {
            [self removeMEmptyView];
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    blockmsgcell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SForumMessage*  oneobj = self.tempArray[ indexPath.row ];
    if( oneobj.mType == 1 )
    {
        cell.mheadimg.image = [UIImage imageNamed:@"ic_sysmsg"];
        cell.mname.text =  oneobj.mTitle;
        cell.mcontent.text = oneobj.mContent;
        cell.mfromconst.constant = 0;
    }
    else
    {
        cell.mname.text = oneobj.mUser.mUserName;
        NSString* ss = [Util makeImgUrl:oneobj.mUser.mHeadImgURL tagImg:cell.mheadimg];
        [cell.mheadimg sd_setImageWithURL: [NSURL URLWithString:ss] placeholderImage:[UIImage imageNamed:@"defultHead"]];
        cell.mcontent.text = oneobj.mTitle;
        cell.mfromconst.constant = 36;
    }
    
    cell.mtime.text = oneobj.mSendTime;
    cell.mdian.hidden = oneobj.mReadTime.length != 0;
    
    if( oneobj.mPosts.mTitle.length )
    {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:oneobj.mPosts.mTitle];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        cell.mcommname.attributedText = content;
    }
    else
    {
        cell.mcommname.text = oneobj.mPosts.mTitle;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SForumMessage*  oneobj = self.tempArray[ indexPath.row ];
    TieDetailVC* vc = [[TieDetailVC alloc]initWithNibName:@"TieDetailVC" bundle:nil];
    vc.mtagPost = oneobj.mPosts;
    if( oneobj.mReadTime.length == 0 )
    {
        [oneobj readThis:^(SResBase *resb) {
            
        }];
    }
    oneobj.mReadTime = @"1";
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    
    [self pushViewController: vc];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SForumMessage*  oneobj = self.tempArray[ indexPath.row ];
        NSInteger ii = indexPath.row;
        [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
        [oneobj delThis:^(SResBase *resb) {
            
            if( resb.msuccess )
            {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self.tempArray removeObjectAtIndex:ii];
                [self.tableView beginUpdates];
                
                [self.tableView deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:ii inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];
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
