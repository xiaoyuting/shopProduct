//
//  VillageVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "VillageVC.h"
#import "VillageCell.h"
#import "DistrictVC.h"
#import "AddVillageVC.h"
#import "WuyeManVC.h"
@interface VillageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation VillageVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"我的小区";
    self.Title = self.mPageName;
    self.rightBtnTitle = @"添加";
    
    [self LoadUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView headerBeginRefreshing];
    
}
-(void)dealloc
{
    self.tableView = nil;
}

-(void)rightBtnTouched:(id)sender
{
    
    DistrictVC* vc = [[DistrictVC alloc]initWithNibName:@"DistrictVC" bundle:nil];
    [self pushViewController:vc];
}

- (void)LoadUI{
    
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"VillageCell" bundle:nil];
    [self.mVillageTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    _mVillageTable.dataSource=self;
    _mVillageTable.delegate=self;
    
    self.tableView = _mVillageTable;
    self.haveHeader = YES;
    
}

-(void)headerBeganRefresh
{
    [[SUser currentUser] getMyDistrict:^(SResBase *resb, NSArray *all) {
        
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
        [self.tableView reloadData];
        
        if ( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:@"noitem"];
        }
        else
        {
            [self removeEmptyView];
        }
    }];
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VillageCell *cell = (VillageCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SDistrict* oneobj = [self.tempArray objectAtIndex: indexPath.row];
    
    cell.mVillageName.text = oneobj.mName;
    cell.mAddress.text = oneobj.mAddress;
    if( oneobj.mIsEnter && oneobj.mIsUser )
    {
        [cell ButtonViewDisplay:YES];
        cell.mVillageButton.tag = indexPath.row;
        [cell.mVillageButton addTarget:self action:@selector(wuyeclicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell ButtonViewDisplay:NO];
    }
    
    return cell;
}
-(void)wuyeclicked:(UIButton*)sender
{
    SDistrict* oneobj = [self.tempArray objectAtIndex: sender.tag ];
    
    if( self.mitblock )
        self.mitblock( oneobj );
    if(_isOwn){
        
        WuyeManVC* vc = [[WuyeManVC alloc]initWithNibName:@"WuyeManVC" bundle:nil];
        [self pushViewController:vc];
        
    }else{
        
        [self leftBtnTouched:nil];
        
    }

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SDistrict* oneobj = [self.tempArray objectAtIndex: indexPath.row ];

    AddVillageVC * vc = [[AddVillageVC alloc]initWithNibName:@"AddVillageVC" bundle:nil];
    vc.mtagDistrict = oneobj;
        
    vc.mitblock = self.mitblock;
    
    if(_isOwn){
        vc.isOwn=YES;
    }
    [self pushViewController:vc];

  
    
    
    
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
