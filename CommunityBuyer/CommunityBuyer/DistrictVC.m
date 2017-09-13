//
//  DistrictVC.m
//  CommunityBuyer
//
//  Created by zzl on 15/12/1.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "DistrictVC.h"
#import "DistrictCell.h"
#import "UILabel+myLabel.h"
#import "AddVillageVC.h"
@interface DistrictVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DistrictVC
{
    NSArray* tmparr;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.Title = self.mPageName = @"选择小区";

    
    UINib* nib = [UINib nibWithNibName:@"DistrictCell" bundle:nil];
    [self.mtagtable registerNib:nib forCellReuseIdentifier:@"cell"];
    self.mtagtable.delegate = self;
    self.mtagtable.dataSource = self;
    
    [self loadData];
}

-(void)loadData
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [SDistrict searchDistrict:_minputkeywords.text block:^(NSArray *all, SResBase *resb) {
        
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            tmparr = all;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        [self.mtagtable reloadData];
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tmparr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistrictCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SDistrict* one = tmparr[ indexPath.row];
    
    cell.mName.text =one.mName;
    cell.mAddr.text = one.mAddress;
    
//    [cell.mName autoReSizeWidthForContent:tableView.bounds.size.width];
//    [cell.mAddr autoReSizeWidthForContent:tableView.bounds.size.width  - cell.mName.frame.size.width];
//    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if( _itblock )
    {
        _itblock( tmparr[ indexPath.row] );
        [self leftBtnTouched:nil];
    }
    SDistrict* one = tmparr[ indexPath.row];
    
    AddVillageVC * vc = [[AddVillageVC alloc]initWithNibName:@"AddVillageVC" bundle:nil];
    vc.mtagDistrict = one;
    vc.mitblock = nil;
    
    [self pushViewController:vc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchclick:(id)sender {
    
    [self loadData];
    [_minputkeywords resignFirstResponder];
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
