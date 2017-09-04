//
//  PropertyIntroduceVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/27.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "PropertyIntroduceVC.h"
#import "OwnerInfoCell.h"
#import "PropertyIntroduceCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface PropertyIntroduceVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PropertyIntroduceVC

- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    self.mPageName = @"物业介绍";
    self.Title = self.mPageName;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [self.mtagSeller getPropDetail:^(SResBase *info) {
        
        if( !info.msuccess )
        {
            [SVProgressHUD showErrorWithStatus:info.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        else {
            [SVProgressHUD dismiss];
            [self addData];
            [self LoadUI];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)addData{
    
    
    NSArray *arr=[[NSArray alloc] init];
    

    arr=@[@"公司名",    [NSString stringWithFormat:@"%@",self.mtagSeller.mName]];
    [self.tempArray addObject:arr];
    
   
    arr=@[@"联系人", [NSString stringWithFormat:@"%@",self.mtagSeller.mContacts]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"物业电话",    [NSString stringWithFormat:@"%@",self.mtagSeller.mMobile]];
    [self.tempArray addObject:arr];
    
    
    arr=@[@"营业执照", [NSString stringWithFormat:@"%@", self.mtagSeller.mBusinessLicenceImg]];
    [self.tempArray addObject:arr];
    
 
    
}


- (void)LoadUI{
    
    //初始化cell
    UINib *nibS = [UINib nibWithNibName:@"OwnerInfoCell" bundle:nil];
    [self.mInfoTable registerNib:nibS forCellReuseIdentifier:@"cell"];
    
    UINib *nib = [UINib nibWithNibName:@"PropertyIntroduceCell" bundle:nil];
    [self.mInfoTable registerNib:nib forCellReuseIdentifier:@"aCell"];
    
    _mInfoTable.dataSource=self;
    _mInfoTable.delegate=self;
    
    
    [_mInfoTable reloadData];
    
}


#pragma UITableDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.tempArray.count-1)
    {
        PropertyIntroduceCell *cell = (PropertyIntroduceCell *)[tableView dequeueReusableCellWithIdentifier:@"aCell"];
        cell.mTitle.text=[self.tempArray objectAtIndex:indexPath.row][0];
        NSString* oneurl = [self.tempArray objectAtIndex:indexPath.row][1];
        oneurl = [Util makeImgUrl:oneurl tagImg:cell.mImage];
        
        [cell.mImage sd_setImageWithURL:[NSURL URLWithString:oneurl] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
        return cell;
    }
    else
    {
        OwnerInfoCell *cell = (OwnerInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.mTitle.text=[self.tempArray objectAtIndex:indexPath.row][0];
        cell.mInfo.text=[self.tempArray objectAtIndex:indexPath.row][1];
        return cell;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [self.tempArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==self.tempArray.count-1) {
        return 100;
    }
    
    return 50;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PropertyIntroduceCell *cell = (PropertyIntroduceCell *)[tableView dequeueReusableCellWithIdentifier:@"aCell"];
    NSString* oneurl = [self.tempArray objectAtIndex:indexPath.row][1];
    if (indexPath.row==self.tempArray.count-1) {
        
        UIImageView* tagv = cell.mImage;
//        tagv.tag=1;
        
        NSMutableArray* allimgs = NSMutableArray.new;
       
        MJPhoto* onemj = [[MJPhoto alloc]init];
        onemj.url = [NSURL URLWithString:oneurl ];
        onemj.srcImageView = tagv;
        [allimgs addObject: onemj];
        
        
        MJPhotoBrowser* browser = [[MJPhotoBrowser alloc]init];
//        browser.currentPhotoIndex = tagv.tag-1;
        browser.photos  = allimgs;
        [browser show];
    }

        
    
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
