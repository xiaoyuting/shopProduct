//
//  allBlockVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/19.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "allBlockVC.h"
#import "oneblockCell.h"
#import "blockVC.h"
#import "WuyeManVC.h"

@interface allBlockVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation allBlockVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mPageName = self.Title = @"所有板块";
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, self.contentView.bounds.size.height) delegate:self dataSource:self];
    self.haveHeader = YES;
    
    UINib* nib = [UINib nibWithNibName:@"oneblockCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    [self.tableView headerBeginRefreshing];
    
}
-(void)headerBeganRefresh
{
    [SForumPlate getAllPlates:^(SResBase *resb, NSArray *all) {
        [self headerEndRefresh];
        
        [self.tempArray removeAllObjects];
        if( resb.msuccess )
        {
            [self.tempArray addObjectsFromArray: all];
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
        
        [self.tableView reloadData];
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    oneblockCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SForumPlate * oneobj = self.tempArray[ indexPath.row ];
    
    [cell.micon sd_setImageWithURL:[NSURL URLWithString: oneobj.mIcon] placeholderImage: [UIImage imageNamed:@"DefaultImg"]];
    cell.mname.text = oneobj.mName;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SForumPlate * oneobj = self.tempArray[ indexPath.row ];
    if( oneobj.mId ==  1)
    {
        WuyeManVC* vc = [[WuyeManVC alloc]initWithNibName:@"WuyeManVC" bundle:nil];
        [self pushViewController:vc];
        return;
    }
        
    blockVC * vc = [[blockVC alloc]init];
    vc.mtagPlate = oneobj;
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
