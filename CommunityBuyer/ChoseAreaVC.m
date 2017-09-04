//
//  ChoseAreaVC.m
//  CommunityBuyer
//
//  Created by 周大钦 on 15/11/23.
//  Copyright © 2015年 zdq. All rights reserved.
//

#import "ChoseAreaVC.h"
#import "MapCell.h"

@interface ChoseAreaVC (){

    NSArray *pArry;
    NSArray *cArry;
    NSArray *aArry;
    

    
    BOOL isOpened1;
    BOOL isOpened2;
    BOOL isOpened3;
}

@end

@implementation ChoseAreaVC

- (void)viewDidLoad {
    
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.Title = self.mPageName = @"所在地区";
    
    self.rightBtnTitle = @"保存";
    
    
    _mProvice.layer.masksToBounds = YES;
    _mProvice.layer.cornerRadius = 5;
    [_mProvice.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mProvice.layer setBorderWidth:1];
    
    _mCity.layer.masksToBounds = YES;
    _mCity.layer.cornerRadius = 5;
    [_mCity.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mCity.layer setBorderWidth:1];
    
    _mArea.layer.masksToBounds = YES;
    _mArea.layer.cornerRadius = 5;
    [_mArea.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mArea.layer setBorderWidth:1];
    
    [SProvince GetProvice:^(NSArray *all) {
        
        pArry = all;
    }];

    [self loadTableData];
    
    [self initStatus];
}
-(void)initStatus
{
    if (self.pp && self.cp && self.ap) {
        
        
        [_mProvice setTitle:self.pp.mN forState:UIControlStateNormal];
        if( self.pp.mChild == nil )
        {
            for( SProvince* one in pArry )
            {
                if( one.mI == self.pp.mI )
                    self.pp.mChild = one.mChild;
            }
        }
        cArry = self.pp.mChild;
        
        [_mCityTable reloadData];
        
        
        
        [_mCity setTitle:self.cp.mN forState:UIControlStateNormal];
        
        if( self.cp.mChild == nil )
        {
            for ( SProvince* one in  cArry ) {
                if( one.mI == self.cp.mI )
                    self.cp.mChild = one.mChild;
            }
        }
        
        aArry = self.cp.mChild;
        [_mAreaTable reloadData];
        
        [_mArea setTitle:self.ap.mN forState:UIControlStateNormal];
        
        
    }
}


- (void)rightBtnTouched:(id)sender{
    
    if (self.pp && self.cp) {
        
        if (aArry.count == 0 || self.ap) {
            if (_itblock) {
                _itblock(self.pp,self.cp,self.ap);
            }
            
            [self popViewController];
        }else{
        
            [SVProgressHUD showErrorWithStatus:@"请选择完整地区"];
        }
        
    }else{
    
        
    }
}


- (void)loadTableData{

    
    isOpened1=NO;
    [_mProviceTable initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [pArry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        SProvince *province = [pArry objectAtIndex:indexPath.row];
        
        [cell.mlb setText:province.mN];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
        SProvince *province = [pArry objectAtIndex:indexPath.row];
        
        [_mProvice setTitle:cell.mlb.text forState:UIControlStateNormal];
        
        self.pp = province;
        
        cArry = self.pp.mChild;
        [_mCityTable reloadData];
        [_mCity setTitle:@"城市" forState:UIControlStateNormal];
        [_mArea setTitle:@"区域" forState:UIControlStateNormal];
        self.cp = nil;
        self.ap = nil;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mProviceTable.frame;
            
            frame.size.height=0;
            [_mProviceTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened1=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mCityTable.frame;
            
            frame.size.height=0;
            
            [_mCityTable setFrame:frame];
            
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mAreaTable.frame;
            
            frame.size.height=0;
            [_mAreaTable setFrame:frame];
            
            
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
    }];
    
    
    _mProviceTable.layer.masksToBounds = YES;
    _mProviceTable.layer.cornerRadius = 5;
    [_mProviceTable.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mProviceTable.layer setBorderWidth:1];
    
    
    [_mCityTable initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [cArry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        
        SProvince *city = [cArry objectAtIndex:indexPath.row];
        
        [cell.mlb setText:city.mN];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        SProvince *city = [cArry objectAtIndex:indexPath.row];
        [_mCity setTitle:city.mN forState:UIControlStateNormal];
        self.cp = city;
        aArry = city.mChild;
        [_mAreaTable reloadData];
        [_mArea setTitle:@"区域" forState:UIControlStateNormal];
        self.ap = nil;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mCityTable.frame;
            
            frame.size.height=0;
            [_mCityTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened2=NO;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mAreaTable.frame;
            
            frame.size.height=0;
            [_mAreaTable setFrame:frame];
            
            
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
    }];
    
    
    _mCityTable.layer.masksToBounds = YES;
    _mCityTable.layer.cornerRadius = 5;
    [_mCityTable.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mCityTable.layer setBorderWidth:1];
    
    
    [_mAreaTable initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        
        NSInteger num = [aArry count];
        return num;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MapCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MapCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        SProvince *area = [aArry objectAtIndex:indexPath.row];
        [cell.mlb setText:area.mN];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        MapCell *cell=(MapCell*)[tableView cellForRowAtIndexPath:indexPath];
        SProvince *area = [aArry objectAtIndex:indexPath.row];
        [_mArea setTitle:area.mN forState:UIControlStateNormal];
        
        self.ap = area;
        if(area == nil){
            
            self.ap = [[SProvince alloc] init];
            self.ap.mI = 0;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mAreaTable.frame;
            
            frame.size.height=0;
            [_mAreaTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened3=NO;
        }];
        
        
    }];
    
    
    _mAreaTable.layer.masksToBounds = YES;
    _mAreaTable.layer.cornerRadius = 5;
    [_mAreaTable.layer setBorderColor:COLOR(201, 202, 198).CGColor];
    [_mAreaTable.layer setBorderWidth:1];

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

- (IBAction)mProviceClick:(id)sender {
    if (isOpened1) {

        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mProviceTable.frame;
            
            frame.size.height=0;
            [_mProviceTable setFrame:frame];

        } completion:^(BOOL finished){
            isOpened1=NO;
        }];

    }else{
        
        _mProviceTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [UIView animateWithDuration:0.3 animations:^{

            CGRect frame=_mProviceTable.frame;
            
            if (pArry.count*44 < 250) {
                frame.size.height=pArry.count*44;
            }else{
                frame.size.height=250;
            }
            
            [_mProviceTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened1=YES;
            
        }];
        
    }

}

- (IBAction)mCityClick:(id)sender {
    
    if (isOpened2) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mCityTable.frame;
            
            frame.size.height=0;
            [_mCityTable setFrame:frame];
            
        } completion:^(BOOL finished){
            isOpened2=NO;
        }];
        
    }else{
        
        _mCityTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mCityTable.frame;
            
            if (cArry.count*44 < 250) {
                frame.size.height=cArry.count*44;
            }else{
                frame.size.height=250;
            }
            
            [_mCityTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened2=YES;
            
        }];
        
    }

}

- (IBAction)mAreaClick:(id)sender {
    
    if (isOpened3) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mAreaTable.frame;
            
            frame.size.height=0;
            [_mAreaTable setFrame:frame];
            
        } completion:^(BOOL finished){
            isOpened3=NO;
        }];
        
    }else{
        
        _mAreaTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame=_mAreaTable.frame;
            
            if (aArry.count*44 < 250) {
                frame.size.height=aArry.count*44;
            }else{
                frame.size.height=250;
            }
            
            [_mAreaTable setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened3=YES;
            
        }];
        
    }

}
@end
