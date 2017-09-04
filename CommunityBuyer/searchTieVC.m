//
//  searchTieVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/8.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "searchTieVC.h"
#import "searchResloutVC.h"
#import "searchTieCell.h"
@interface searchTieVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation searchTieVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.Title = @"搜索";
    self.mPageName = @"帖子搜索";
    
    _minputkey.delegate = self;
    
    self.mtable.delegate = self;
    self.mtable.dataSource = self;
    
    UINib* nib = [UINib nibWithNibName:@"searchTieCell" bundle:nil];
    [self.mtable registerNib:nib forCellReuseIdentifier:@"cell"];
    
    NSArray* t = [SForumPosts getHistory];
    if( t )
        [self.tempArray addObjectsFromArray:t];
    [self.mtable reloadData];
    
    
    self.mtopwaper.layer.cornerRadius = 3;
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField.text.length == 0  )
    {
        [SVProgressHUD showErrorWithStatus:@"请先输入关键字"];
        return NO;
    }
    searchResloutVC* vc = [[searchResloutVC alloc]init];
    vc.mKeyWords = textField.text;
    [self pushViewController:vc];
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    searchTieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.mtxt.text = self.tempArray[ indexPath.row ];
    [cell.mbt addTarget:self action:@selector(delclicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.mbt.tag = indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    searchResloutVC* vc = [[searchResloutVC alloc]init];
    vc.mKeyWords = self.tempArray[ indexPath.row ];
    [self pushViewController:vc];
}
-(void)delclicked:(UIButton*)sender
{
    NSString* sss = self.tempArray[sender.tag];
    [SForumPosts delThisHistory:sss];
    [self.tempArray removeObjectAtIndex:sender.tag];
    
    [self.mtable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
