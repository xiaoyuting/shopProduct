//
//  AddVillageVC.m
//  CommunityBuyer
//
//  Created by zy _cheng_mac on 16/1/26.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "AddVillageVC.h"
#import "OwnerInfoCell.h"
#import "WuyeManVC.h"

@interface AddVillageVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddVillageVC
{
    int _mstep;
}
- (void)viewDidLoad {
    self.hiddenTabBar = YES;
    [super viewDidLoad];
    
    self.mPageName = @"保利香槟国际";
    self.Title = self.mtagDistrict.mName;
    
    [self LoadUI];
    
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [self.mtagDistrict getDetail:^(SResBase *resb) {
        
        if( resb.msuccess  )
        {
            [SVProgressHUD dismiss];
            [self updatePage];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:resb.mmsg];
            [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
        }
        
    }];
    
}
-(void)rightBtnTouched:(id)sender
{
    if( _mstep )
    {
        [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
        [self.mtagDistrict delThis:^(SResBase *resb) {
           
            if( resb.msuccess )
            {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
                [self performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
            
        }];
    }
}

-(void)updatePage
{

    if( self.mtagDistrict.mIsEnter )
    {//有物业功能,
        if( self.mtagDistrict.mIsUser )
        {//查看物业,,就是已经是我的小区了
            self.rightBtnImage = [UIImage imageNamed:@"ic_delright"];
            self.mText.text = @"小区物业已经入住平台";
            [self.mbt setTitle: @"物业"  forState:UIControlStateNormal];
            _mstep = 1;
        }
        else
        {//添加到我的小区
            self.mText.text = @"小区物业已经入住平台";
            [self.mbt setTitle: @"加入我的小区"  forState:UIControlStateNormal];
            _mstep = 2;
        }
    }
    else
    {
        _mstep = 0;
        self.mText.hidden = YES;
        self.mbt.hidden = YES;
    }
    
    
    NSArray* t =  @[ @"小区名", [NSString stringWithFormat:@"%@",self.mtagDistrict.mName] ];
    [self.tempArray addObject: t];
    
    t =  @[ @"户数", [NSString stringWithFormat:@"%d户",self.mtagDistrict.mHouseNum] ];
    [self.tempArray addObject: t];

    t =  @[ @"占地面积",  [NSString stringWithFormat:@"%d平方米",self.mtagDistrict.mAreaNum] ];
    [self.tempArray addObject: t];

    t =  @[ @"小区位置", [NSString stringWithFormat:@"%@",self.mtagDistrict.mAddress] ];
    [self.tempArray addObject: t];

    t =  @[ @"房产类型", [NSString stringWithFormat:@"%@",self.mtagDistrict.mHouseTypeName] ];
    [self.tempArray addObject: t];

    t =  @[ @"物业公司",  [NSString stringWithFormat:@"%@",self.mtagDistrict.mSellerName] ];
    [self.tempArray addObject: t];
    
    [self.mInfoTable reloadData];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray* tt = self.tempArray[indexPath.row];
    
    cell.mTitle.text = tt[0];
    cell.mInfo.text = tt[1];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tempArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==3) {
        return 70;
    }
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

- (IBAction)addMyVillage:(id)sender {
    
    if( _mstep == 1  )
    {//物业
        
 
        if( self.mitblock )
            self.mitblock( self.mtagDistrict );
        
        if(_isOwn){
            
            WuyeManVC* vc = [[WuyeManVC alloc]initWithNibName:@"WuyeManVC" bundle:nil];
            [self pushViewController:vc];
            
        }else{
            
            [self popViewController_2];
            
        }
        
    }
    else if( _mstep == 2 )
    {//加入小区
        
        [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
        __weak AddVillageVC* refself = self;
        [self.mtagDistrict addThis:^(SResBase *resb) {
            
            if( resb.msuccess )
            {
                [SVProgressHUD showSuccessWithStatus:resb.mmsg];
//                [refself performSelector:@selector(leftBtnTouched:) withObject:nil afterDelay:0.85f];
                
                if(refself.isOwn){
                    
                    WuyeManVC* vc = [[WuyeManVC alloc]initWithNibName:@"WuyeManVC" bundle:nil];
                    [refself pushViewController:vc];
                    
                }else{
                    
                    [refself popViewController_2];
                    
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:resb.mmsg];
            }
        }];
    }
    
}
@end
