//
//  LingQuVC.m
//  CommunityBuyer
//
//  Created by zzl on 16/1/13.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "LingQuVC.h"
#import "OneJCell.h"
@interface LingQuVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LingQuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mPageName = self.Title = @"领券";
    
    [self loadTableView:CGRectMake(0, 0, DEVICE_Width, DEVICE_Height-64) delegate:self dataSource:self];
    
    UINib* nib = [UINib nibWithNibName:@"OneJCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1];
    
    self.haveFooter = YES;
    self.haveHeader = YES;
    
    [self.tableView headerBeginRefreshing];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OneJCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SPromotion* oneobj = self.tempArray[indexPath.row];
    if( [oneobj bY] )
    {
        NSMutableAttributedString* attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",oneobj.mMoney]];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
        cell.mPrcie.attributedText = attr;
        cell.mname.text = @"优惠券";
        cell.mforbid.text = oneobj.mBrief;
        cell.mPrcie.textColor = [UIColor colorWithRed:0.890 green:0.271 blue:0.376 alpha:1.000];
    }
    else
    {
        cell.mPrcie.textColor = [UIColor colorWithRed:0.925 green:0.702 blue:0.306 alpha:1.000];
        cell.mPrcie.text =  @"抵";
        cell.mname.text = @"抵用券";
        cell.mforbid.text = oneobj.mBrief;
    }
    
    cell.mexttime.text = oneobj.mExpireTimeStr;
    cell.mexpimg.hidden = !oneobj.mStatus;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPromotion* oneobj = self.tempArray[indexPath.row];
    [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
    [oneobj getThis:^(SResBase *resb, SPromotion *retobj) {
       
        if( resb.msuccess )
        {
            [SVProgressHUD dismiss];
            [self.tableView headerBeginRefreshing];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
    }];
    
}

-(void)headerBeganRefresh
{
    self.page = 1;
   [[SUser currentUser]getMyYouHuiJuan:self.page status:2 sellerId:0 money:0 block:^(SResBase *resb, NSArray *all, int cangetcount) {
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray: all];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
        if ( self.tempArray.count == 0 )
        {
            [self addEmptyViewWithImg:@"noitem"];
        }
        else
        {
            [self removeEmptyView];
        }
        
        [self.tableView reloadData];
        
    }];
}

-(void)footetBeganRefresh
{
    self.page ++;
   [[SUser currentUser]getMyYouHuiJuan:self.page status:2 sellerId:0 money:0 block:^(SResBase *resb, NSArray *all, int cangetcount) {
        [self footetEndRefresh];
        if (resb.msuccess) {
            [self.tempArray addObjectsFromArray: all];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
        }
        
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
