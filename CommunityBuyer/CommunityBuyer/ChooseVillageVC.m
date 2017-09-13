//
//  ChooseVillageVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "ChooseVillageVC.h"
#import "OwnerInfoCell.h"

@interface ChooseVillageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChooseVillageVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"保利香槟国际";
    self.Title = self.mPageName;
    
    [self LoadUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)LoadUI{
    
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"OwnerInfoCell" bundle:nil];
    [self.mInfoTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    
    _mInfoTable.dataSource=self;
    _mInfoTable.delegate=self;
    
    
    
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OwnerInfoCell *cell = (OwnerInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 50;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goSearch:(id)sender {
}
@end
