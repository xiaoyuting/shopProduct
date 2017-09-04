//
//  myTie.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/19.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "myTie.h"
#import "ZWTopFilterView.h"
#import "QuanCell.h"
#import "TieDetailVC.h"
#import "SWTableViewCell.h"
#import "addTie.h"
@interface myTie ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@end

@implementation myTie
{
    ZWTopFilterView*    _topfilter;
    int                 _itstatus;
    BOOL                _bwillreload;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mPageName = self.Title = @"我的帖子";
    
    _topfilter = [ZWTopFilterView makeTopFilterView:@[@"发表的帖子",@"回复的帖子",@"点赞的帖子"] MainCorol:M_CO rect:CGRectMake(0, 0, DEVICE_Width, 44)];
    _topfilter.backgroundColor= [UIColor whiteColor];
    __weak myTie* selfref = self;
    _topfilter.mitblock = ^(int from ,int to){
        [selfref topselected:from to:to];
    };
    [self.contentView addSubview:_topfilter];
    
    [self loadTableView:CGRectMake(0, 54, DEVICE_Width, self.contentView.bounds.size.height - 54) delegate:self dataSource:self];
    UINib * nib = [UINib nibWithNibName:@"QuanCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.haveFooter = YES;
    self.haveHeader = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( _bwillreload )
    {
        _bwillreload = NO;
        [self.tableView headerBeginRefreshing];
    }
}

-(void)topselected:(int)from to:(int)to
{
    _itstatus = to;
    
    [self.tableView headerBeginRefreshing];
}
-(void)headerBeganRefreshWithBlock:(void (^)(SResBase *, NSArray *))block
{
    self.page = 1;
    [[SUser currentUser]getMyTie:self.page type:_itstatus+1 block:^(SResBase *resb, NSArray *all) {
        block( resb,all);
    }];
}

-(void)footetBeganRefreshWithBlock:(void (^)(SResBase *, NSArray *))block
{
    self.page ++;
    [[SUser currentUser]getMyTie:self.page type:_itstatus+1 block:^(SResBase *resb, NSArray *all) {
      
        block( resb,all);
        
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
    QuanCell* cell      =   [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SForumPosts* oneobj =   self.tempArray[ indexPath.row ];
    cell.mtitle.text = oneobj.mTitle;
    cell.msubtitle.text = oneobj.mPlate.mName;
    cell.mtime.text = oneobj.mCreateTimeStr;
    cell.mcount.text = [NSString stringWithFormat:@"%d",oneobj.mRateNum];
    cell.delegate = self;
    
    [cell setRightUtilityButtons:[self makeRightButtons] WithButtonWidth:58.0f];
    
    return cell;
}
-(NSArray*)makeRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.945 green:0.600 blue:0.247 alpha:1.000] icon:[UIImage imageNamed:@"ic_edit"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.980 green:0.055 blue:0.235 alpha:1.000] icon:[UIImage imageNamed:@"ic_del"]];
    
    return rightUtilityButtons;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SForumPosts * oneobj = self.tempArray[ indexPath.row ];
    
    TieDetailVC* vc = [[TieDetailVC alloc]initWithNibName:@"TieDetailVC" bundle:nil];
    vc.mtagPost = oneobj;
    [self pushViewController:vc];
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath* indexPath  =  [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    SForumPosts * oneobj = self.tempArray[ indexPath.row ];
    if( index == 0 )
    {
        addTie *  vc = [[addTie alloc]initWithNibName:@"addTie" bundle:nil];
        vc.mtagPost = oneobj;
        [self pushViewController:vc];
        [cell  hideUtilityButtonsAnimated:YES];
        _bwillreload = YES;
    }
    else
    {
        [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
        [oneobj delThis:^(SResBase *resb) {
            if( resb.msuccess )
            {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                
                [self.tempArray removeObject:oneobj];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
