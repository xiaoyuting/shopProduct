//
//  FaultRepairVC.m
//  CommunityBuyer
//  我要报修
//  Created by zy _cheng_mac on 16/1/21.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "FaultRepairVC.h"
#import "FaultRepairCell.h"
#import "ToTheRepairVC.h"
#import "RepairDetailVC.h"
#import "ShowMenuVC.h"
#import "AddVillageVC.h"
@implementation OneItem

@end
@interface FaultRepairVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FaultRepairVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"故障报修";
    self.Title = self.mPageName;
    
   
    [self LoadUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if( self.mtagDistrict == nil ){
        [SVProgressHUD showErrorWithStatus:@"数据错误"];
        [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        return;
    }
    
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)LoadUI{
    
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"FaultRepairCell" bundle:nil];
    [_mFaultRepairTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    
    _mFaultRepairTable.dataSource=self;
    _mFaultRepairTable.delegate=self;
    

    self.tableView = _mFaultRepairTable;
    
    self.haveHeader = YES;
    self.haveFooter = YES;
}
-(void)headerBeganRefreshWithBlock:(void (^)(SResBase *, NSArray *))block
{
    self.page = 1;
    [self.mtagDistrict getRepairList:self.page block:^(SResBase *resb, NSArray *all) {
        block( resb,all);
    }];
    
}
-(void)footetBeganRefreshWithBlock:(void (^)(SResBase *, NSArray *))block
{
    self.page ++;
    [self.mtagDistrict getRepairList:self.page block:^(SResBase *resb, NSArray *all) {
        block( resb,all);
    }];
    
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FaultRepairCell *cell = (FaultRepairCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SRepair* oneobj = self.tempArray[ indexPath.row];
    
    
    cell.mTitle.text=oneobj.mRepairType;
    cell.mTime.text=oneobj.mCreateTime;
    cell.mContent.text=oneobj.mContent;
    if (oneobj.mImages.count>0) {
        
       
        cell.mImageViewHeight.constant = 100;
       
        
        for ( int  j = 0 ; j < 4; j++) {
            
            UIImageView * oneimg = (UIImageView *)[cell.mImgUIView viewWithTag:j+1];
            oneimg.image = nil;
            
            if (j < oneobj.mImages.count) {
                
                NSString* oneurl = oneobj.mImages[j];
                oneurl = [Util makeImgUrl:oneurl tagImg:oneimg];
                [oneimg sd_setImageWithURL:[NSURL URLWithString:oneurl] placeholderImage:[UIImage imageNamed:@"img_def"]];
                
                                
            }
            
        }
        
    }else{
        
        cell.mImageViewHeight.constant = 0;

    }

    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.tempArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SRepair* oneobj = self.tempArray[ indexPath.row];
    RepairDetailVC *vc=[[RepairDetailVC alloc] initWithNibName:@"RepairDetailVC" bundle:nil];
    
    vc.mSRepair=oneobj;
    
    [self pushViewController: vc];
    
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

- (IBAction)goRepair:(id)sender {
    
    
    ToTheRepairVC *vc=[[ToTheRepairVC alloc] initWithNibName:@"ToTheRepairVC" bundle:nil];
    vc.mtagDistrict = self.mtagDistrict;
    [self pushViewController:vc];
    
    
    
}
@end
